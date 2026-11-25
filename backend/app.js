require('dotenv').config();
const express = require('express');
const compression = require('compression');
const cors = require('cors');
const path = require('path');
const cookieParser = require('cookie-parser');
const authMiddleware = require('./middleware/auth');
const logger = require('./logger');
const {
  cleanupExpiredTokens, cleanupUnverifiedUsers, revokeAllUserRefreshTokens,
} = authMiddleware;
const mailer = require('./mailer');
const { langMiddleware } = require('./i18n');
const observability = require('./middleware/observability');
const createMonitoringRouter = require('./routes/monitoring');
const { createPrivateStaticGuard } = require('./utils/static-guard');
const { rejectNulBytes } = require('./middleware/input-guards');
const { createCspReportRouter } = require('./middleware/csp-report');
const { cspNonce, securityHeaders, injectCspNonce } = require('./middleware/security-headers');
const { createRateLimiters } = require('./middleware/rate-limiters');
const { STATIC_OPTS, canonicalPageRedirect } = require('./middleware/static-files');
const { errorHandler } = require('./middleware/error-handler');
const { connectRedis } = require('./utils/redis-client');
const { createHtmlPages } = require('./utils/html-pages');
const { createPagesRouter, createCleanUrlFallback } = require('./routes/pages');
const { createApiDocsRouter } = require('./routes/api-docs');
const { startCleanupJobs } = require('./jobs/cleanup');

// Assemblage de l'application : chaque responsabilité vit dans son module
// (en-têtes de sécurité, limiteurs, fichiers statiques, pages HTML, routeurs
// d'API, gestion d'erreurs, purges) ; l'ordre de montage ci-dessous compte.
const app = express();
const frontendRoot = path.join(__dirname, '../frontend');

// Nécessaire derrière un reverse proxy (Apache, Nginx) pour que
// req.ip retourne l'IP réelle du client (rate limiting, logs).
// 'loopback' et non 1 : seul Apache, qui se connecte depuis 127.0.0.1, peut
// dicter l'IP. Un client joignant Node en direct ne peut pas la forger via
// X-Forwarded-For pour contourner le rate limiting ou hCaptcha.
app.set('trust proxy', 'loopback');

// Compression gzip/brotli sur toutes les réponses text/html, css, js, json, svg.
// Niveau 6 = compromis taille/CPU. Skip si client demande déjà compressed
// (ex: image/* sont déjà compressées). Gain ~70% sur les payloads texte.
app.use(compression({
  level: 6,
  threshold: 1024, // ne compresse que > 1 KB (en dessous c'est du gaspillage CPU)
  filter: (req, res) => {
    if (req.headers['x-no-compression']) return false;
    return compression.filter(req, res);
  },
}));

// En-têtes de sécurité et CSP à nonce (middleware/security-headers.js).
app.use(cspNonce);
app.use(securityHeaders);

// -----------------------------------------------------------------------------
// Protection CSRF — pourquoi pas de token CSRF dédié
// -----------------------------------------------------------------------------
// 1. Le refresh token est un cookie SameSite=Strict + HttpOnly + Path=/api
//    → le navigateur ne l'envoie jamais lors de requêtes cross-origin.
// 2. L'access token est stocké en mémoire JS (pas en cookie) et envoyé via
//    le header Authorization: Bearer → un site tiers ne peut pas le forger.
// 3. CORS restreint avec whitelist d'origins + credentials: true.
// 4. CSP form-action 'self' empêche les formulaires HTML de poster cross-origin.
// Ces 4 couches rendent un token CSRF classique redondant (Double Submit Cookie
// ou Synchronizer Token Pattern). Si SameSite=Strict est modifié un jour,
// réévaluer cette posture.
// -----------------------------------------------------------------------------

// CORS restreint : liste en production ; en local, localhost ET 127.0.0.1
// (utils/origins.js).
const allowedOrigins = require('./utils/origins').allowedOrigins(process.env);
app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Origine non autorisée par CORS'));
    }
  },
  credentials: true,
}));

app.use(express.json({ limit: '100kb' }));
// Express 5 laisse req.body à undefined quand la requête n'a pas de corps
// (Express 4 posait {}). Toute route qui déstructure req.body levait alors une
// TypeError → 500 : /login, /register, /contact, /auth/verify-email… Corps
// vide = objet vide, et la validation de chaque route répond 400.
app.use((req, res, next) => {
  if (req.body === undefined) req.body = {};
  next();
});
app.use(cookieParser());

// Observabilité : Request ID + access log + métriques HTTP
app.use(observability.requestId);
app.use(observability.accessLog);

// -----------------------------------------------------------------------------
// Limiteurs (middleware/rate-limiters.js), store Redis si disponible
// -----------------------------------------------------------------------------
const { limiters, useRedis } = createRateLimiters();

// Upgrade vers Redis — appelé depuis server.js si REDIS_URL est défini : branche
// les RedisStore des limiteurs et le cache applicatif. Échec → repli mémoire.
app.initRedis = async function initRedis() {
  if (!process.env.REDIS_URL || process.env.NODE_ENV === 'test') return;
  const client = await connectRedis(process.env.REDIS_URL);
  if (!client) return;
  try {
    const count = useRedis(client);
    app._redisClient = client; // exposé pour shutdown gracieux et /ready
    require('./utils/cache').setRedisClient(client); // cache applicatif partagé
    logger.info('Redis activé', { limiters: count, cache: true });
  } catch (err) {
    logger.warn('Redis indisponible — fallback mémoire', { error: err.message });
    try { client.disconnect(); } catch { /* déjà fermé */ }
  }
};

// Appliquer le limiteur global à toutes les routes API
app.use('/api/', limiters.global);

// Octet NUL dans la requête ou le corps → 400 avant toute requête SQL
// (PostgreSQL le refuse en UTF-8 : c'était un 500). SEC-003.
app.use('/api/', rejectNulBytes);

// Rapports de violation CSP (SEC-006) — corps propres (application/csp-report,
// application/reports+json), que express.json() global ne lit pas.
app.use('/api', createCspReportRouter({ logger, limiter: limiters.cspReport }));

// Middleware i18n : attache req.lang (fr/en) à toutes les requêtes. Monté
// ailleurs que sur /api/ : les rendus serveur (/details, /conflits) en ont
// besoin pour écrire titre, description et h1 dans la langue du visiteur
// (?lang= puis Accept-Language) — limités à /api, ils restaient en français.
app.use(langMiddleware);

// -----------------------------------------------------------------------------
// Pages HTML : cache lu au démarrage, ?v=<version> posé sur les assets
// -----------------------------------------------------------------------------
const pkgVersion = (() => {
  try { return require('./package.json').version || 'dev'; }
  catch { return 'dev'; }
})();
// En développement, ?v= change à chaque démarrage (utils/asset-cache.js).
const pageAssetVersion = require('./utils/asset-cache').currentAssetVersion();
const pages = createHtmlPages({ frontendRoot, assetVersion: pageAssetVersion });
const { htmlCache, sendCachedHtml, sendNotFound } = pages;

app.htmlCache = htmlCache;          // exposé pour le SSR router /details
app.sendCachedHtml = sendCachedHtml;
app.injectCspNonce = injectCspNonce; // exposé pour le SSR router /details

app.use('/api/docs', createApiDocsRouter({ env: process.env, sendCachedHtml, frontendRoot }));

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injectable pour les tests)
// -----------------------------------------------------------------------------
let pool;
const getPool = () => pool;

app.setPool = (p) => {
  pool = p;
  authMiddleware.setPool(p);
  observability.startDbPoolMetrics(getPool);
};
app.getPool = getPool;

// Endpoints de monitoring (live, health, ready, metrics, status)
app.use('/api', createMonitoringRouter(getPool));

// -----------------------------------------------------------------------------
// Fichiers statiques (middleware/static-files.js)
// -----------------------------------------------------------------------------
// URL canoniques des pages : 301 AVANT express.static.
app.use(canonicalPageRedirect);
// frontend/ contient aussi les outils de dev (node_modules, tests, package.json) :
// on les filtre avant express.static.
app.use(createPrivateStaticGuard(sendNotFound));
// Gestionnaires de mots de passe (W3C « A Well-Known URL for Changing
// Passwords ») : renvoie vers l'onglet Sécurité des réglages, ouvert d'après
// l'ancre (js/settings/tabs.js). 302 : la cible peut changer.
app.get('/.well-known/change-password', (req, res) => {
  res.redirect(302, '/settings#security');
});
// .well-known/ commence par un point : express.static l'ignore par défaut (dotfiles).
app.use('/.well-known', express.static(path.join(frontendRoot, '.well-known'), STATIC_OPTS));
// `index: false` : empêche express.static de servir frontend/index.html pour GET /
// (sans ça, l'auto-index court-circuiterait la route '/' et donc injectCspNonce(),
// laissant tout inline <style> sans nonce — CSP bloquerait).
app.use(express.static(frontendRoot, { ...STATIC_OPTS, index: false }));
app.use('/css', express.static(path.join(frontendRoot, 'css'), STATIC_OPTS));
app.use('/js', express.static(path.join(frontendRoot, 'js'), STATIC_OPTS));

// SSR /details/:slug et /details?id=X — injecte les meta tags dynamiques
// AVANT les pages statiques (sinon /details serait servi en HTML brut).
const createDetailsSsrRouter = require('./routes/details-ssr');
app.use('/', createDetailsSsrRouter(getPool));
// Idem pour /conflits et /conflits/:slug (titre et description par conflit).
const createConflictsSsrRouter = require('./routes/conflicts-ssr');
app.use('/', createConflictsSsrRouter(getPool));

// Accueil et frise rendues côté serveur, pages statiques, anciennes pages
// d'authentification (routes/pages.js).
app.use('/', createPagesRouter({ getPool, frontendRoot, assetVersion: pageAssetVersion, pages }));

// -----------------------------------------------------------------------------
// Routes d'API
// -----------------------------------------------------------------------------

// Public config : sitekey hCaptcha + version. Le frontend lit ce endpoint
// au boot pour savoir s'il doit afficher le widget captcha sur les forms.
app.get('/api/config', (req, res) => {
  res.set('Cache-Control', 'public, max-age=300');
  res.json({
    version: pkgVersion,
    // Clé effective : vide en développement (captcha désactivé, pas de
    // widget) — middleware/hcaptcha.js, captchaKeys.
    hcaptchaSitekey: require('./middleware/hcaptcha').captchaKeys(process.env).sitekey || null,
  });
});

const createAuthRouter = require('./routes/auth');
app.use('/api', createAuthRouter(getPool, {
  registerLimiter: limiters.register,
  loginLimiter: limiters.login,
  emailLimiter: limiters.email,
  refreshLimiter: limiters.refresh,
  codeLimiter: limiters.code,
  sessionsLimiter: limiters.sessions,
  mailer,
}));

const createUsersRouter = require('./routes/users');
app.use('/api', createUsersRouter(getPool, { mailer, dataExportLimiter: limiters.dataExport }));

// IMPORTANT : le routeur facets doit être monté AVANT airplanes, sinon
// /api/airplanes/facets est capté par la route /api/airplanes/:id qui
// interprète "facets" comme un id et renvoie 400 "ID invalide".
const createFacetsRouter = require('./routes/facets');
app.use('/api', createFacetsRouter(getPool));

const createWarsRouter = require('./routes/wars');
app.use('/api', createWarsRouter(getPool));

const createCreditsRouter = require('./routes/credits');
app.use('/api', createCreditsRouter(getPool));

const createAirplanesRouter = require('./routes/airplanes');
const { invalidateSitemap } = require('./routes/sitemap');
const { invalidateLlms } = require('./routes/llms');
const airplanesRouter = createAirplanesRouter(getPool, {
  onAirplaneChange: () => {
    app.invalidateStatsCache?.();
    app.invalidateTimelineCache?.();
    app.invalidateHeroCache?.();
    invalidateSitemap().catch(() => {}); // sitemap stale si Redis down, non-bloquant
    invalidateLlms().catch(() => {});
  },
});
app.use('/api', airplanesRouter);
app.invalidateAirplanesReferentialCache = () => airplanesRouter.invalidateReferentialCache?.();

const createFavoritesRouter = require('./routes/favorites');
app.use('/api', createFavoritesRouter(getPool));

const createStatsRouter = require('./routes/stats');
const statsRouter = createStatsRouter(getPool);
app.use('/api', statsRouter);
// Exposer l'invalidation du cache stats (utilisé par les routes airplanes)
app.invalidateStatsCache = () => statsRouter.invalidateCache?.();

const createTimelineRouter = require('./routes/timeline');
const timelineRouter = createTimelineRouter(getPool);
app.use('/api', timelineRouter);
// Exposer l'invalidation cache timeline (appelée après CRUD avions)
app.invalidateTimelineCache = () => timelineRouter.invalidateCache?.();

const createHeroRouter = require('./routes/hero');
const heroRouter = createHeroRouter(getPool);
app.use('/api', heroRouter);
// Exposer l'invalidation cache hero (appelée après CRUD avions)
app.invalidateHeroCache = () => heroRouter.invalidateCache?.();

const createContactRouter = require('./routes/contact');
app.use('/api', createContactRouter(getPool, { contactLimiter: limiters.contact, mailer }));

const createSitemapRouter = require('./routes/sitemap');
app.use('/', createSitemapRouter(getPool));
const createLlmsRouter = require('./routes/llms');
app.use('/', createLlmsRouter(getPool));

// Toute autre URL sous /api : 404 JSON, quelle que soit la méthode. Monté
// après le dernier routeur d'API, avant le catch-all des pages HTML.
app.use('/api', sendNotFound);

// URL propres des pages (/hangar → hangar.html…) puis 404 du site pour ce
// qu'aucune route n'a servi (fichier absent, méthode non routée) plutôt que
// « Cannot POST /x » d'Express.
app.use(createCleanUrlFallback({ frontendRoot, pages }));
app.use(sendNotFound);

app.use(errorHandler);

// -----------------------------------------------------------------------------
// Purges périodiques (jobs/cleanup.js) : refresh tokens toutes les heures,
// comptes non vérifiés toutes les 24 h.
// -----------------------------------------------------------------------------
const stopCleanupJobs = process.env.NODE_ENV !== 'test'
  ? startCleanupJobs({ cleanupExpiredTokens, cleanupUnverifiedUsers })
  : () => {};

// Exposé pour les tests et le graceful shutdown
app.stopCleanup = stopCleanupJobs;
app.cleanupUnverifiedUsers = cleanupUnverifiedUsers;

// Exposé pour que d'autres routes puissent révoquer les tokens (ex: changement de MDP)
app.revokeAllUserRefreshTokens = revokeAllUserRefreshTokens;

module.exports = app;
