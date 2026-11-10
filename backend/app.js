require('dotenv').config();
const express = require('express');
const compression = require('compression');
const cors = require('cors');
const path = require('path');
const crypto = require('crypto');
const cookieParser = require('cookie-parser');
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
const { blockPrivateStatic } = require('./utils/static-guard');
const { rejectNulBytes } = require('./middleware/input-guards');
const { createCspReportRouter } = require('./middleware/csp-report');

const app = express();

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

// Remontée des violations CSP (SEC-006) : `report-to` pour les navigateurs qui
// implémentent la Reporting API, `report-uri` pour les autres (Firefox). Les
// deux visent la même route, qui accepte les deux formats.
const CSP_REPORT_PATH = '/api/csp-report';
const CSP_REPORT_GROUP = 'csp-endpoint';

app.use((req, res, next) => {
  const nonce = res.locals.cspNonce;
  const styleHosts = "https://hcaptcha.com https://*.hcaptcha.com";
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  // Isolation cross-origin (protection Spectre, tabnabbing, xsleaks).
  // same-origin sur COOP = isolation stricte de la fenêtre (empêche window.opener cross-origin).
  // same-site sur CORP = permet les assets cross-sous-domaine tout en bloquant l'embed hostile.
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Resource-Policy', 'same-site');
  res.setHeader('Reporting-Endpoints', `${CSP_REPORT_GROUP}="${CSP_REPORT_PATH}"`);
  res.setHeader('Content-Security-Policy', [
    "default-src 'self'",
    // Scripts : nonce + 'strict-dynamic' (SEC-006). Chaque <script src> local
    // reçoit le nonce de la requête (injectCspNonce) ; un script ainsi approuvé
    // peut en charger d'autres par createElement — gtm.js après consentement,
    // puis les balises du conteneur GTM, l'API hCaptcha, le SDK Sentry local.
    // Un <script> injecté dans le HTML, lui, n'a pas le nonce : il est bloqué,
    // même s'il vise googletagmanager.com (contournement connu d'une liste
    // d'hôtes, que le chemin /gtm.js ne fermait pas : l'identifiant du
    // conteneur passe en paramètre). Les navigateurs qui comprennent
    // 'strict-dynamic' ignorent 'self' et les hôtes ; ceux-ci ne servent qu'aux
    // très anciens navigateurs. Le CDN Sentry a disparu : le SDK est servi en
    // local (js/vendor/sentry.min.js).
    `script-src 'nonce-${nonce}' 'strict-dynamic' 'self' https://www.googletagmanager.com https://www.google-analytics.com https://hcaptcha.com https://*.hcaptcha.com`,
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
    "img-src 'self' https://www.googletagmanager.com data:",
    // Hôtes Sentry retirés (SEC-006) : aucun DSN front n'est configuré. Si l'on
    // active Sentry navigateur un jour, rajouter ici l'hôte d'ingestion du DSN.
    "connect-src 'self' https://www.google-analytics.com https://*.google-analytics.com https://www.googletagmanager.com https://hcaptcha.com https://*.hcaptcha.com",
    "frame-src https://hcaptcha.com https://*.hcaptcha.com",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "worker-src 'self'",
    "manifest-src 'self'",
    `report-uri ${CSP_REPORT_PATH}`,
    `report-to ${CSP_REPORT_GROUP}`,
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
const { rateLimit, ipKeyGenerator } = require('express-rate-limit');

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
  // Une page en défaut peut envoyer plusieurs rapports CSP par chargement.
  { key: 'cspReport',     max: 60,  msg: 'Trop de rapports, réessayez plus tard.' },
  // Export des données personnelles (LEGAL-011) : requête rare et coûteuse.
  { key: 'dataExport',    max: 10,  msg: "Trop de demandes d'export, réessayez dans 15 minutes." },
];

function buildLimiter({ max, msg }, store) {
  return rateLimit({
    windowMs: 15 * 60 * 1000,
    // v8 a renommé `max` → `limit` ; on garde un alias pour la lisibilité.
    limit: max,
    message: { message: msg },
    standardHeaders: true,
    legacyHeaders: false,
    // ipKeyGenerator normalise les IPv6 (sinon v8 bloque au boot : ERR_ERL_KEY_GEN_IPV6).
    keyGenerator: (req) => ipKeyGenerator(req.ip),
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
const cspReportLimiter     = (req, res, next) => _impl.cspReport(req, res, next);
const dataExportLimiter    = (req, res, next) => _impl.dataExport(req, res, next);

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

// Octet NUL dans la requête ou le corps → 400 avant toute requête SQL
// (PostgreSQL le refuse en UTF-8 : c'était un 500). SEC-003.
app.use('/api/', rejectNulBytes);

// Rapports de violation CSP (SEC-006) — corps propres (application/csp-report,
// application/reports+json), que express.json() global ne lit pas.
app.use('/api', createCspReportRouter({ logger, limiter: cspReportLimiter }));

// Middleware i18n : attache req.lang (fr/en) à toutes les requêtes. Monté
// ailleurs que sur /api/ : les rendus serveur (/details, /conflits) en ont
// besoin pour écrire titre, description et h1 dans la langue du visiteur
// (?lang= puis Accept-Language) — limités à /api, ils restaient en français.
app.use(langMiddleware);

// -----------------------------------------------------------------------------
// Documentation API (Swagger UI)
// -----------------------------------------------------------------------------
// Désactivée en production (404). swagger-ui-express et yaml ne sont chargés
// que dans la branche hors production (DEVOPS-009) : le processus de prod ne
// les requiert jamais, ils vivent en devDependencies (`npm ci --omit=dev`).
if (process.env.NODE_ENV === 'production') {
  app.use('/api/docs', (req, res) => {
    // Page 404 servie par le cache HTML (nonce CSP posé sur ses scripts).
    res.status(404);
    sendCachedHtml(res, path.join(__dirname, '../frontend/404.html'));
  });
} else {
  try {
    const swaggerUi = require('swagger-ui-express');
    const YAML = require('yaml');
    const openapiDoc = YAML.parse(fs.readFileSync(path.join(__dirname, 'openapi.yaml'), 'utf8'));
    const swaggerThemeCss = fs.readFileSync(path.join(__dirname, 'assets/swagger-theme.css'), 'utf8');
    // Les <script> de Swagger UI ne portent pas le nonce : la page de doc
    // (hors production seulement) garde l'ancienne règle 'self'.
    const relaxDocsScriptSrc = (req, res, next) => {
      const csp = res.getHeader('Content-Security-Policy');
      if (typeof csp === 'string') {
        res.setHeader('Content-Security-Policy', csp.replace(/script-src [^;]+/, "script-src 'self'"));
      }
      next();
    };
    app.use('/api/docs', relaxDocsScriptSrc, swaggerUi.serve, swaggerUi.setup(openapiDoc, {
      customCss: swaggerThemeCss,
      customSiteTitle: 'Vol d\'Histoire — API Docs',
      customfavIcon: '/favicon.ico',
    }));
  } catch { /* openapi.yaml ou devDependencies absents — Swagger désactivé */ }
}

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
// Cache headers : 30 jours sur fonts (immutable), 1 an sur les fichiers dont
// l'URL porte un ?v= (le bump de version suffit à invalider), 1 jour sur le
// reste, pas de cache sur HTML (rendu dynamique potentiel + invalidation rapide).
const IMAGE_EXTS = new Set(['.svg', '.png', '.jpg', '.jpeg', '.webp', '.avif', '.ico']);

function isVersionedRequest(req) {
  const url = (req && (req.originalUrl || req.url)) || '';
  const q = url.indexOf('?');
  return q >= 0 && /(?:^|&)v=[^&]+/.test(url.slice(q + 1));
}

// -----------------------------------------------------------------------------
// URL canoniques des pages : 301 AVANT express.static
// -----------------------------------------------------------------------------
// Sans cela, express.static servait /index.html, /hangar.html… tels quels :
// hors du cache HTML, donc sans ?v= sur les assets ni nonce sur le <style>
// critique (bloqué par la CSP), et sans en-tête ni pied de page (inclusions).
// Express ignorant la casse et le slash final, /HANGAR et /hangar/ répondaient
// aussi 200 : autant d'URL en double.
// Exceptions : les fichiers qui ne sont demandés que sous leur nom complet.
const HTML_FILE_EXCEPTIONS = new Set([
  '/cookie-consent.html',          // fragment chargé par cookies.js (fetch)
  '/googleb250c8eb3ae5dfa7.html',  // vérification Google Search Console
]);

function canonicalPagePath(p) {
  let target = p;
  if (/\.html$/i.test(target)) target = target.slice(0, -5);
  // Seules les pages (sans extension) sont normalisées : un asset garde sa casse.
  if (!path.extname(target)) {
    target = target.toLowerCase();
    if (target.length > 1) target = target.replace(/\/+$/, '');
    if (target === '' || target === '/index') target = '/';
  }
  return target;
}

function canonicalPageRedirect(req, res, next) {
  if (req.method !== 'GET' && req.method !== 'HEAD') return next();
  const p = req.path;
  if (p === '/api' || p.startsWith('/api/') || p.startsWith('/.well-known/')) return next();
  if (HTML_FILE_EXCEPTIONS.has(p)) return next();
  // Garde anti-redirection ouverte : « //domaine » ou « /\domaine » dans un
  // Location serait lu comme une URL d'un autre site.
  if (p.startsWith('//') || p.includes('\\')) return next();
  const target = canonicalPagePath(p);
  if (target === p) return next();
  const query = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
  return res.redirect(301, target + query);
}
app.use(canonicalPageRedirect);

const STATIC_OPTS = {
  setHeaders: (res, filePath, _stat) => {
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
    } else if (ext === '.css' || ext === '.js') {
      // Les CSS et JS sont servis avec ?v=<version> : le contenu d'une URL
      // donnée ne change jamais, donc un an de cache immuable.
      res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
    } else if (IMAGE_EXTS.has(ext)) {
      // Images : une URL versionnée (?v=, posé par shared/picture.js et le
      // SSR des fiches) change à chaque release, donc un an immuable. Sans
      // version (og:image, JSON-LD, favicons, logos), une photo peut être
      // remplacée sous le même nom : une journée, revalidée en arrière-plan.
      res.setHeader('Cache-Control', isVersionedRequest(res.req)
        ? 'public, max-age=31536000, immutable'
        : 'public, max-age=86400, s-maxage=604800, stale-while-revalidate=604800');
    }
  },
};
// `index: false` : empêche express.static de servir frontend/index.html auto pour GET /
// (sans ça, le auto-index court-circuiterait app.get('/') et donc injectCspNonce(),
// laissant tout inline <style> sans nonce — CSP bloquerait). Notre route explicite
// app.get('/') passe par sendCachedHtml() qui nonce les <style> à l'exécution.
// frontend/ contient aussi les outils de dev (node_modules, tests, package.json) :
// on les filtre avant express.static.
app.use(blockPrivateStatic);
// .well-known/ commence par un point : express.static l'ignore par défaut (dotfiles).
app.use('/.well-known', express.static(path.join(__dirname, '../frontend/.well-known'), STATIC_OPTS));
app.use(express.static(path.join(__dirname, '../frontend/'), { ...STATIC_OPTS, index: false }));
app.use('/css', express.static(path.join(__dirname, '../frontend/css'), STATIC_OPTS));
app.use('/js', express.static(path.join(__dirname, '../frontend/js'), STATIC_OPTS));

// SSR /details/:slug et /details?id=X — injecte les meta tags dynamiques
// AVANT la liste statique htmlPages (sinon /details serait servi en HTML brut).
const createDetailsSsrRouter = require('./routes/details-ssr');
app.use('/', createDetailsSsrRouter(() => pool));
// Idem pour /conflits et /conflits/:slug (titre et description par conflit).
const createConflictsSsrRouter = require('./routes/conflicts-ssr');
app.use('/', createConflictsSsrRouter(() => pool));

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
// Marqueur <!-- @include x --> sans fragment frontend/partials/x.html : la
// page est servie avec le marqueur, l'oubli doit se voir au démarrage.
htmlCache.warnings.forEach(w => logger.warn && logger.warn('Inclusion HTML non résolue', { detail: w }));

// Un <script src> est nonçé seulement s'il vise un fichier du site (chemin
// relatif ou absolu, jamais « // » ni un schéma) : même si une donnée mal
// échappée glissait un <script src="https://…"> dans un rendu SSR, il ne
// recevrait pas le nonce et resterait bloqué. Les <script> sans src (JSON-LD)
// ne s'exécutent pas : inutile de les nonçer.
const LOCAL_SCRIPT_SRC = /\bsrc\s*=\s*"(?!\/\/|[a-z][a-z0-9+.-]*:)[^"]+"/i;

// Injecte le nonce CSP sur chaque balise <style> et sur chaque <script src>
// local (sans attribut nonce existant). Coût : O(n) sur la taille du HTML
// (~sub-ms pour 50 Ko), acceptable en runtime.
function injectCspNonce(html, nonce) {
  if (!nonce) return html;
  return html
    .replace(/<style(\s+[^>]*)?>/gi, (match, attrs) => {
      if (attrs && /\bnonce\s*=/.test(attrs)) return match; // déjà nonçé
      return `<style${attrs || ''} nonce="${nonce}">`;
    })
    .replace(/<script(\s+[^>]*)>/gi, (match, attrs) => {
      if (/\bnonce\s*=/.test(attrs) || !LOCAL_SCRIPT_SRC.test(attrs)) return match;
      return `<script${attrs} nonce="${nonce}">`;
    });
}

function sendCachedHtml(res, filePath) {
  // Variante anglaise (lang, title, description, og, canonical) si req.lang === 'en' :
  // la langue vient de ?lang= puis d'Accept-Language, d'où le Vary.
  const cached = htmlCache.get(filePath, res.req && res.req.lang);
  if (cached !== null) {
    res.vary('Accept-Language');
    res.set('Content-Type', 'text/html; charset=utf-8');
    return res.send(injectCspNonce(cached, res.locals.cspNonce));
  }
  // Fallback : fichier ajouté après le boot. Lu puis nonçé comme les autres :
  // servi brut, ses scripts seraient bloqués par 'strict-dynamic'.
  return fs.promises.readFile(filePath, 'utf8')
    .then((html) => {
      res.set('Content-Type', 'text/html; charset=utf-8');
      res.send(injectCspNonce(html, res.locals.cspNonce));
    })
    .catch(() => res.status(404).send('Page non trouvée'));
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
app.use('/api', createUsersRouter(() => pool, { mailer, dataExportLimiter }));

// IMPORTANT : le routeur facets doit être monté AVANT airplanes, sinon
// /api/airplanes/facets est capté par la route /api/airplanes/:id qui
// interprète "facets" comme un id et renvoie 400 "ID invalide".
const createFacetsRouter = require('./routes/facets');
app.use('/api', createFacetsRouter(() => pool));

const createWarsRouter = require('./routes/wars');
app.use('/api', createWarsRouter(() => pool));

const createCreditsRouter = require('./routes/credits');
app.use('/api', createCreditsRouter(() => pool));

const createAirplanesRouter = require('./routes/airplanes');
const { invalidateSitemap } = require('./routes/sitemap');
const airplanesRouter = createAirplanesRouter(() => pool, {
  onAirplaneChange: () => {
    app.invalidateStatsCache?.();
    app.invalidateTimelineCache?.();
    app.invalidateHeroCache?.();
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

const createHeroRouter = require('./routes/hero');
const heroRouter = createHeroRouter(() => pool);
app.use('/api', heroRouter);
// Exposer l'invalidation cache hero (appelée après CRUD avions)
app.invalidateHeroCache = () => heroRouter.invalidateCache?.();

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

// La redirection 301 des variantes (.html, majuscules, slash final) est faite
// par canonicalPageRedirect, avant express.static.

// Servir le fichier .html correspondant à l'URL propre
const fsPromises = fs.promises;

// Pré-construction de la liste des pages HTML valides au démarrage (évite fs à chaque requête)
const frontendDir = path.join(__dirname, '../frontend');
// Pages physiques mais NON exposées en URL propre (fragments chargés par JS, fichiers de vérif tiers).
// Le fichier .html reste accessible via express.static (consommé par cookies.js fetch), mais
// l'URL propre /cookie-consent renvoie 404 — évite l'indexation d'un partial sans <html lang>.
const HIDDEN_CLEAN_URLS = new Set(['/cookie-consent']);
const validPages = new Set();
try {
  fs.readdirSync(frontendDir).forEach((file) => {
    if (file.endsWith('.html')) {
      const cleanUrl = '/' + file.slice(0, -5); // /hangar, /details, /a-propos, etc.
      if (!HIDDEN_CLEAN_URLS.has(cleanUrl)) validPages.add(cleanUrl);
    }
  });
} catch { /* Silencieux si le dossier n'existe pas encore (tests) */ }

// Express 5 / path-to-regexp v6 rejette le wildcard '*' tel quel.
// app.use((req,res,next)=>...) en dernière position joue le même rôle de catch-all
// HTML pour les URLs propres sans extension.
app.use(async (req, res, next) => {
  if (req.method !== 'GET') return next();
  // Ignorer les requêtes API et les fichiers avec extension
  if (req.path.startsWith('/api/') || path.extname(req.path)) {
    return next();
  }

  // URLs propres masquées (fragment cookie-consent etc.) : 404 immédiat sans
  // tomber sur le fichier .html, qui reste atteignable uniquement via /xxx.html.
  if (HIDDEN_CLEAN_URLS.has(req.path)) {
    const notFoundFile = path.join(frontendDir, '404.html');
    res.status(404);
    return sendCachedHtml(res, notFoundFile);
  }

  // /404 est une vraie page d'erreur : statut 404, jamais un 200 indexable.
  if (req.path === '/404') {
    res.status(404);
    return sendCachedHtml(res, path.join(frontendDir, '404.html'));
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
// Erreurs de lecture du corps (body-parser) : la faute est côté client. Elles
// répondaient 500 et chacune produisait une ligne « Erreur non gérée » avec sa
// pile (SEC-002). `err.type` est posé par body-parser.
const BODY_ERRORS = {
  'entity.parse.failed': { status: 400, message: 'Corps de requête JSON invalide' },
  'entity.too.large': { status: 413, message: 'Corps de requête trop volumineux (100 Ko maximum)' },
  'encoding.unsupported': { status: 415, message: 'Encodage du corps non pris en charge' },
  'charset.unsupported': { status: 415, message: 'Jeu de caractères non pris en charge' },
  'request.aborted': { status: 400, message: 'Requête interrompue' },
  'request.size.invalid': { status: 400, message: 'Taille de requête incohérente' },
  'stream.encoding.set': { status: 400, message: 'Requête invalide' },
};

app.use((err, req, res, _next) => {
  if (err.message === 'Origine non autorisée par CORS') {
    return res.status(403).json({ message: 'Origine non autorisée' });
  }
  const bodyError = BODY_ERRORS[err.type];
  if (bodyError) {
    logger.debug('Corps de requête rejeté', { reqId: req.id, path: req.path, type: err.type });
    return res.status(bodyError.status).json({ message: bodyError.message });
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
