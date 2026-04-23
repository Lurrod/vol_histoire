require('dotenv').config();
const express = require('express');
const compression = require('compression');
const cors = require('cors');
const path = require('path');
const crypto = require('crypto');
const cookieParser = require('cookie-parser');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yaml');
const fs = require('fs');
const authMiddleware = require('./middleware/auth');
const logger = require('./logger');
const {
  cleanupExpiredTokens, cleanupUnverifiedUsers, revokeAllUserRefreshTokens,
} = authMiddleware;
const mailer = require('./mailer');
const { langMiddleware } = require('./i18n');
const observability = require('./middleware/observability');
const createMonitoringRouter = require('./routes/monitoring');
const { buildHtmlCache } = require('./middleware/serveHtml');

const app = express();

// Nécessaire derrière un reverse proxy (Apache, Nginx) pour que
// req.ip retourne l'IP réelle du client (rate limiting, logs).
app.set('trust proxy', 1);

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

// -----------------------------------------------------------------------------
// Sécurité : Headers HTTP
// -----------------------------------------------------------------------------
// Nonce CSP : généré par requête, injecté dans chaque <style> servi par
// sendCachedHtml + dans le header style-src-elem. Les vieux navigateurs
// (sans support style-src-elem) tombent sur style-src, également nonce-based
// depuis v4.1.1 — plus d'unsafe-inline. Les modernes (~99%) passent par
// style-src-elem et bloquent toute injection de <style> XSS.
app.use((req, res, next) => {
  res.locals.cspNonce = crypto.randomBytes(16).toString('base64');
  next();
});

app.use((req, res, next) => {
  const nonce = res.locals.cspNonce;
  const styleHosts = "https://hcaptcha.com https://*.hcaptcha.com";
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  // Isolation cross-origin (protection Spectre, tabnabbing, xsleaks).
  // same-origin sur COOP = isolation stricte de la fenêtre (empêche window.opener cross-origin).
  // same-site sur CORP = permet les assets cross-sous-domaine tout en bloquant l'embed hostile.
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Resource-Policy', 'same-site');
  res.setHeader('Content-Security-Policy', [
    "default-src 'self'",
    "script-src 'self' https://www.googletagmanager.com https://www.google-analytics.com https://browser.sentry-cdn.com https://hcaptcha.com https://*.hcaptcha.com",
    // CSP L3 : nonce sur <style>, pas d'inline style="" autorisé.
    // Tous les styles dynamiques injectés via innerHTML passent par des
    // classes CSS ou element.style.setProperty() post-insertion (non bloqués
    // car c'est une API DOM, pas un attribut parsé).
    `style-src-elem 'self' 'nonce-${nonce}' ${styleHosts}`,
    "style-src-attr 'none'",
    // Fallback pour navigateurs ignorant style-src-elem (< 1% du trafic).
    // Tous les <style> inline sont nonce-és au runtime via injectCspNonce(),
    // donc 'unsafe-inline' n'est plus nécessaire — CSP strictement nonce-based.
    `style-src 'self' 'nonce-${nonce}' ${styleHosts}`,
    "font-src 'self'",
    "img-src 'self' https://flagcdn.com https://www.googletagmanager.com https://picsum.photos https://fastly.picsum.photos data:",
    "connect-src 'self' https://www.google-analytics.com https://*.google-analytics.com https://www.googletagmanager.com https://*.ingest.sentry.io https://*.sentry.io https://hcaptcha.com https://*.hcaptcha.com",
    "frame-src https://hcaptcha.com https://*.hcaptcha.com",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "worker-src 'self'",
    "manifest-src 'self'",
  ].join('; '));
  res.removeHeader('X-Powered-By');
  next();
});

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

// -----------------------------------------------------------------------------
// Sécurité : CORS restreint
// -----------------------------------------------------------------------------
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',')
  : ['http://localhost:3000', 'https://vol-histoire.titouan-borde.com'];

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
app.use(cookieParser());

// Observabilité : Request ID + access log + métriques HTTP
app.use(observability.requestId);
app.use(observability.accessLog);

// -----------------------------------------------------------------------------
// Rate-limiter (express-rate-limit)
// -----------------------------------------------------------------------------
// Store Redis automatique si REDIS_URL est défini (multi-instances / scaling).
// Sinon fallback sur le store mémoire (instance unique, dev).
// -----------------------------------------------------------------------------
const rateLimit = require('express-rate-limit');

// Store mémoire par défaut (instance unique).
// Si REDIS_URL est défini, app.initRedis() (appelé depuis server.js avant listen)
// remplace les stores par des RedisStore pour le scaling horizontal.
const LIMITER_DEFS = [
  { key: 'register',      max: 10,  msg: "Trop de tentatives d'inscription, réessayez dans 15 minutes." },
  { key: 'login',         max: 20,  msg: "Trop de tentatives de connexion, réessayez dans 15 minutes." },
  { key: 'global',        max: 200, msg: 'Trop de requêtes, réessayez plus tard.' },
  { key: 'refresh',       max: 30,  msg: 'Trop de tentatives de rafraîchissement, réessayez dans 15 minutes.' },
  { key: 'resetPassword', max: 5,   msg: 'Trop de tentatives, réessayez dans 15 minutes.' },
  { key: 'email',         max: 3,   msg: 'Trop de demandes, réessayez dans 15 minutes.' },
  { key: 'contact',       max: 5,   msg: 'Trop de messages envoyés, réessayez dans 15 minutes.' },
];

function buildLimiter({ max, msg }, store) {
  return rateLimit({
    windowMs: 15 * 60 * 1000,
    max,
    message: { message: msg },
    standardHeaders: true,
    legacyHeaders: false,
    keyGenerator: (req) => req.ip,
    skip: () => process.env.NODE_ENV === 'test',
    ...(store ? { store } : {}),
  });
}

// Implémentations mutables — wrappers qui délèguent au limiter courant
const _impl = {};
LIMITER_DEFS.forEach(d => { _impl[d.key] = buildLimiter(d); });

const registerLimiter      = (req, res, next) => _impl.register(req, res, next);
const loginLimiter         = (req, res, next) => _impl.login(req, res, next);
const globalApiLimiter     = (req, res, next) => _impl.global(req, res, next);
const refreshLimiter       = (req, res, next) => _impl.refresh(req, res, next);
const resetPasswordLimiter = (req, res, next) => _impl.resetPassword(req, res, next);
const emailLimiter         = (req, res, next) => _impl.email(req, res, next);
const contactLimiter       = (req, res, next) => _impl.contact(req, res, next);

// Upgrade vers Redis — appelé depuis server.js si REDIS_URL est défini.
// 1. Connexion paresseuse + ping pour valider rapidement (échec → fallback mémoire)
// 2. Si OK, branche les RedisStore du rate-limiter et le cache applicatif
// 3. En cas de déconnexion runtime, ioredis reconnecte avec backoff ; les appels
//    échouent vite (offlineQueue=false) et cache.js/rate-limit tombent en mémoire.
app.initRedis = async function initRedis() {
  if (!process.env.REDIS_URL || process.env.NODE_ENV === 'test') return;
  let client;
  try {
    const Redis = require('ioredis');
    const { RedisStore } = require('rate-limit-redis');
    client = new Redis(process.env.REDIS_URL, {
      lazyConnect: true,
      connectTimeout: 3000,
      maxRetriesPerRequest: 3,
      enableOfflineQueue: false,
      retryStrategy: (times) => {
        if (times > 20) return null; // abandonne au bout de ~40s cumulées
        return Math.min(times * 200, 2000); // backoff 200ms → 2s
      },
      reconnectOnError: (err) => /READONLY|ECONNRESET/i.test(err.message),
    });

    // Log throttlé : on ne veut pas spammer le logger pendant une panne Redis
    let lastErrorLoggedAt = 0;
    client.on('error', (err) => {
      const now = Date.now();
      if (now - lastErrorLoggedAt > 60_000) {
        logger.warn('Redis erreur', { error: err.message });
        lastErrorLoggedAt = now;
      }
    });
    client.on('reconnecting', (delay) => logger.info('Redis reconnexion', { delayMs: delay }));
    client.on('ready', () => logger.info('Redis prêt'));
    client.on('end', () => logger.info('Redis déconnecté'));

    await client.connect();
    await client.ping();

    LIMITER_DEFS.forEach(d => {
      _impl[d.key] = buildLimiter(d, new RedisStore({
        sendCommand: (...args) => client.call(...args),
        prefix: `vdh:rl:${d.key}:`,
      }));
    });
    app._redisClient = client; // exposé pour shutdown gracieux et /ready
    require('./utils/cache').setRedisClient(client); // cache applicatif partagé
    logger.info('Redis activé', { limiters: LIMITER_DEFS.length, cache: true });
  } catch (err) {
    logger.warn('Redis indisponible — fallback mémoire', { error: err.message });
    try { if (client) client.disconnect(); } catch {}
  }
};

// Appliquer le limiteur global à toutes les routes API
app.use('/api/', globalApiLimiter);

// Middleware i18n : attache req.lang (fr/en) sur toutes les routes /api/*
app.use('/api/', langMiddleware);

// -----------------------------------------------------------------------------
// Documentation API (Swagger UI)
// -----------------------------------------------------------------------------
try {
  const openapiDoc = YAML.parse(fs.readFileSync(path.join(__dirname, 'openapi.yaml'), 'utf8'));
  // En production, restreindre l'accès à la doc API aux admins
  if (process.env.NODE_ENV === 'production') {
    app.use('/api/docs', (req, res) => {
      res.status(404).sendFile(path.join(__dirname, '../frontend/index.html'));
    });
  } else {
    const swaggerThemeCss = fs.readFileSync(path.join(__dirname, 'assets/swagger-theme.css'), 'utf8');
    app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(openapiDoc, {
      customCss: swaggerThemeCss,
      customSiteTitle: 'Vol d\'Histoire — API Docs',
      customfavIcon: '/favicon.ico',
    }));
  }
} catch { /* openapi.yaml absent (tests) — Swagger désactivé */ }

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injectable pour les tests)
// -----------------------------------------------------------------------------
let pool;

app.setPool = (p) => {
  pool = p;
  authMiddleware.setPool(p);
  observability.startDbPoolMetrics(() => pool);
};
app.getPool = () => pool;

// Endpoints de monitoring (live, ready, metrics, status)
app.use('/api', createMonitoringRouter(() => pool));

// -----------------------------------------------------------------------------
// Fichiers statiques
// -----------------------------------------------------------------------------
// Cache headers : 30 jours sur fonts (immutable), 1 jour sur CSS/JS/images,
// pas de cache sur HTML (rendu dynamique potentiel + invalidation rapide).
const STATIC_OPTS = {
  setHeaders: (res, filePath) => {
    const ext = path.extname(filePath).toLowerCase();
    const base = path.basename(filePath).toLowerCase();
    if (base === 'sw.js') {
      // Service worker : pas de cache pour que les updates soient déployées
      // immédiatement. Les browsers capent de toute façon la revérification à 24h.
      res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
      res.setHeader('Service-Worker-Allowed', '/');
    } else if (ext === '.webmanifest') {
      // Manifest PWA : revalider à chaque nav. Assez petit pour que ce ne soit
      // pas un souci bandwidth.
      res.setHeader('Cache-Control', 'public, max-age=3600, must-revalidate');
      res.setHeader('Content-Type', 'application/manifest+json; charset=utf-8');
    } else if (ext === '.html') {
      res.setHeader('Cache-Control', 'no-cache');
    } else if (ext === '.woff2' || ext === '.woff') {
      // Fonts : long cache + immutable (le contenu ne change jamais)
      res.setHeader('Cache-Control', 'public, max-age=2592000, immutable');
    } else if (['.css', '.js', '.svg', '.png', '.jpg', '.jpeg', '.webp', '.avif', '.ico'].includes(ext)) {
      // Statiques fingerprintables : 1 jour navigateur, 7 jours CDN
      res.setHeader('Cache-Control', 'public, max-age=86400, s-maxage=604800');
    }
  },
};
app.use(express.static(path.join(__dirname, '../frontend/'), STATIC_OPTS));
app.use('/css', express.static(path.join(__dirname, '../frontend/css'), STATIC_OPTS));
app.use('/js', express.static(path.join(__dirname, '../frontend/js'), STATIC_OPTS));

// SSR /details/:slug et /details?id=X — injecte les meta tags dynamiques
// AVANT la liste statique htmlPages (sinon /details serait servi en HTML brut).
const createDetailsSsrRouter = require('./routes/details-ssr');
app.use('/', createDetailsSsrRouter(() => pool));

// Cache HTML : au boot, on lit tous les *.html et on injecte ?v=<version>
// sur les références asset (css/js/fonts) pour bust le cache navigateur à
// chaque déploiement. Coût runtime = 0 (lecture une fois, sert depuis Map).
const pkgVersion = (() => {
  try { return require('./package.json').version || 'dev'; }
  catch { return 'dev'; }
})();
const frontendRoot = path.join(__dirname, '../frontend');
const htmlCache = buildHtmlCache(frontendRoot, pkgVersion);
logger.info && logger.info('HTML cache initialisé', { count: htmlCache.count, version: pkgVersion });

// Injecte le nonce CSP sur chaque balise <style> (sans attribut nonce existant).
// Coût : O(n) sur la taille du HTML (~sub-ms pour 50 Ko), acceptable en runtime.
function injectCspNonce(html, nonce) {
  if (!nonce) return html;
  return html.replace(/<style(\s+[^>]*)?>/gi, (match, attrs) => {
    if (attrs && /\bnonce\s*=/.test(attrs)) return match; // déjà nonçé
    return `<style${attrs || ''} nonce="${nonce}">`;
  });
}

function sendCachedHtml(res, filePath) {
  const cached = htmlCache.get(filePath);
  if (cached !== null) {
    res.set('Content-Type', 'text/html; charset=utf-8');
    return res.send(injectCspNonce(cached, res.locals.cspNonce));
  }
  // Fallback : fichier ajouté après le boot, on le sert via sendFile
  return res.sendFile(filePath);
}
app.htmlCache = htmlCache;          // exposé pour le SSR router /details
app.sendCachedHtml = sendCachedHtml;
app.injectCspNonce = injectCspNonce; // exposé pour le SSR router /details

// Routes HTML sans extension (utile en dev local — en prod c'est Apache/.htaccess qui gère)
const htmlPages = [
  'verify-email', 'forgot-password', 'reset-password', 'check-email',
  'hangar', 'timeline', 'favorites', 'login', 'settings',
  'contact', 'mentions-legales',
  'politique-confidentialite', 'cgu',
];
htmlPages.forEach(page => {
  app.get(`/${page}`, (req, res) => {
    sendCachedHtml(res, path.join(frontendRoot, `${page}.html`));
  });
});
app.get('/', (req, res) => {
  sendCachedHtml(res, path.join(frontendRoot, 'index.html'));
});

// -----------------------------------------------------------------------------
// Routes
// -----------------------------------------------------------------------------

// Public config : sitekey hCaptcha + version. Le frontend lit ce endpoint
// au boot pour savoir s'il doit afficher le widget captcha sur les forms.
app.get('/api/config', (req, res) => {
  res.set('Cache-Control', 'public, max-age=300');
  res.json({
    version: pkgVersion,
    hcaptchaSitekey: process.env.HCAPTCHA_SITEKEY || null,
  });
});

const createAuthRouter = require('./routes/auth');
app.use('/api', createAuthRouter(() => pool, { registerLimiter, loginLimiter, emailLimiter, refreshLimiter, resetPasswordLimiter, mailer }));

const createUsersRouter = require('./routes/users');
app.use('/api', createUsersRouter(() => pool));

// IMPORTANT : le routeur facets doit être monté AVANT airplanes, sinon
// /api/airplanes/facets est capté par la route /api/airplanes/:id qui
// interprète "facets" comme un id et renvoie 400 "ID invalide".
const createFacetsRouter = require('./routes/facets');
app.use('/api', createFacetsRouter(() => pool));

const createAirplanesRouter = require('./routes/airplanes');
const { invalidateSitemap } = require('./routes/sitemap');
const airplanesRouter = createAirplanesRouter(() => pool, {
  onAirplaneChange: () => {
    app.invalidateStatsCache?.();
    app.invalidateTimelineCache?.();
    invalidateSitemap().catch(() => {}); // sitemap stale si Redis down, non-bloquant
  },
});
app.use('/api', airplanesRouter);
app.invalidateAirplanesReferentialCache = () => airplanesRouter.invalidateReferentialCache?.();

const createFavoritesRouter = require('./routes/favorites');
app.use('/api', createFavoritesRouter(() => pool));

const createStatsRouter = require('./routes/stats');
const statsRouter = createStatsRouter(() => pool);
app.use('/api', statsRouter);

// Exposer l'invalidation du cache stats (utilisé par les routes airplanes)
app.invalidateStatsCache = () => statsRouter.invalidateCache?.();

const createTimelineRouter = require('./routes/timeline');
const timelineRouter = createTimelineRouter(() => pool);
app.use('/api', timelineRouter);
// Exposer l'invalidation cache timeline (appelée après CRUD avions)
app.invalidateTimelineCache = () => timelineRouter.invalidateCache?.();

const createContactRouter = require('./routes/contact');
app.use('/api', createContactRouter(() => pool, { contactLimiter, mailer }));

const createSitemapRouter = require('./routes/sitemap');
app.use('/', createSitemapRouter(() => pool));

// Health check
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', uptime: process.uptime(), timestamp: new Date().toISOString() });
  } catch {
    res.status(503).json({ status: 'error', message: 'Database unreachable' });
  }
});

// -----------------------------------------------------------------------------
// Clean URLs : /hangar → hangar.html, /a-propos → a-propos.html, etc.
// -----------------------------------------------------------------------------

// Redirection 301 : supprimer .html des URLs (SEO)
app.use((req, res, next) => {
  if (req.path.endsWith('.html') && req.method === 'GET') {
    const clean = req.path.slice(0, -5);
    const query = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
    return res.redirect(301, clean + query);
  }
  next();
});

// Servir le fichier .html correspondant à l'URL propre
const fsPromises = fs.promises;

// Pré-construction de la liste des pages HTML valides au démarrage (évite fs à chaque requête)
const frontendDir = path.join(__dirname, '../frontend');
const validPages = new Set();
try {
  fs.readdirSync(frontendDir).forEach((file) => {
    if (file.endsWith('.html')) {
      validPages.add('/' + file.slice(0, -5)); // /hangar, /details, /a-propos, etc.
    }
  });
} catch { /* Silencieux si le dossier n'existe pas encore (tests) */ }

app.get('*', async (req, res, next) => {
  // Ignorer les requêtes API et les fichiers avec extension
  if (req.path.startsWith('/api/') || path.extname(req.path)) {
    return next();
  }

  // Vérification rapide via le Set pré-construit
  if (validPages.has(req.path)) {
    return sendCachedHtml(res, path.join(frontendDir, req.path + '.html'));
  }

  // Fallback async pour les pages ajoutées dynamiquement après le démarrage
  const htmlFile = path.join(frontendDir, req.path + '.html');
  try {
    await fsPromises.access(htmlFile, fs.constants.F_OK);
    return sendCachedHtml(res, htmlFile);
  } catch {
    // 404 personnalisé
    const notFoundFile = path.join(frontendDir, '404.html');
    try {
      await fsPromises.access(notFoundFile, fs.constants.F_OK);
      res.status(404);
      return sendCachedHtml(res, notFoundFile);
    } catch {
      res.status(404).send('Page non trouvée');
    }
  }
});

// -----------------------------------------------------------------------------
// Gestionnaire d'erreurs global
// -----------------------------------------------------------------------------
app.use((err, req, res, _next) => {
  if (err.message === 'Origine non autorisée par CORS') {
    return res.status(403).json({ message: 'Origine non autorisée' });
  }
  // Passer l'objet Error complet (pas err.message string) → permet à Sentry
  // de capturer la stack trace via captureException(meta.error).
  observability.errorsTotal.inc({ type: 'unhandled' });
  const entry = logger.error('Erreur non gérée', {
    error: err,
    reqId: req.id,
    path: req.path,
    method: req.method,
    status: err.status || 500,
    userId: req.user?.id,
    userRole: req.user?.role,
  });
  res.status(500).json({ message: 'Erreur interne du serveur', errorId: entry.errorId });
});

// -----------------------------------------------------------------------------
// Nettoyage périodique des refresh tokens expirés/révoqués (toutes les heures)
// -----------------------------------------------------------------------------
let tokenCleanupInterval;
let unverifiedUsersCleanupInterval;
if (process.env.NODE_ENV !== 'test') {
  tokenCleanupInterval = setInterval(async () => {
    try {
      await cleanupExpiredTokens();
    } catch (err) {
      logger.error('Erreur nettoyage refresh tokens', { error: err.message });
    }
  }, 60 * 60 * 1000);

  // Purge des comptes non vérifiés depuis plus de 7 jours (toutes les 24h)
  unverifiedUsersCleanupInterval = setInterval(async () => {
    try {
      const deleted = await cleanupUnverifiedUsers();
      if (deleted > 0) {
        logger.info('Comptes non vérifiés purgés', { count: deleted });
      }
    } catch (err) {
      logger.error('Erreur purge comptes non vérifiés', { error: err.message });
    }
  }, 24 * 60 * 60 * 1000);
}

// Exposé pour les tests et le graceful shutdown
app.stopCleanup = () => {
  if (tokenCleanupInterval) clearInterval(tokenCleanupInterval);
  if (unverifiedUsersCleanupInterval) clearInterval(unverifiedUsersCleanupInterval);
};
app.cleanupUnverifiedUsers = cleanupUnverifiedUsers;

// Exposé pour que d'autres routes puissent révoquer les tokens (ex: changement de MDP)
app.revokeAllUserRefreshTokens = revokeAllUserRefreshTokens;

module.exports = app;
