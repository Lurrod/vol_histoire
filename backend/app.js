require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const cookieParser = require('cookie-parser');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yaml');
const fs = require('fs');
const authMiddleware = require('./middleware/auth');
const logger = require('./logger');
const {
  authorize, cleanupExpiredTokens, cleanupUnverifiedUsers, revokeAllUserRefreshTokens,
} = authMiddleware;
const mailer = require('./mailer');
const { langMiddleware } = require('./i18n');
const observability = require('./middleware/observability');
const createMonitoringRouter = require('./routes/monitoring');

const app = express();

// Nécessaire derrière un reverse proxy (Apache, Nginx) pour que
// req.ip retourne l'IP réelle du client (rate limiting, logs).
app.set('trust proxy', 1);

// -----------------------------------------------------------------------------
// Sécurité : Headers HTTP
// -----------------------------------------------------------------------------
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  res.setHeader('Content-Security-Policy', [
    "default-src 'self'",
    "script-src 'self' https://www.googletagmanager.com https://www.google-analytics.com https://browser.sentry-cdn.com",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com",
    "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com",
    "img-src 'self' https://i.postimg.cc https://flagcdn.com https://www.googletagmanager.com https://picsum.photos https://fastly.picsum.photos data:",
    "connect-src 'self' https://www.google-analytics.com https://www.googletagmanager.com https://*.ingest.sentry.io https://*.sentry.io",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
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
// En production multi-instances, ajouter un store Redis :
//   npm install rate-limit-redis ioredis
//   const RedisStore = require('rate-limit-redis');
//   const Redis = require('ioredis');
//   const redisClient = new Redis(process.env.REDIS_URL);
//   Puis passer { store: new RedisStore({ sendCommand: (...args) => redisClient.call(...args) }) }
//   dans chaque rateLimit() ci-dessous.
// -----------------------------------------------------------------------------
const rateLimit = require('express-rate-limit');

const registerLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: { message: "Trop de tentatives d'inscription, réessayez dans 15 minutes." },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: { message: "Trop de tentatives de connexion, réessayez dans 15 minutes." },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

const globalApiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  message: { message: 'Trop de requêtes, réessayez plus tard.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

const refreshLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  message: { message: 'Trop de tentatives de rafraîchissement, réessayez dans 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

const resetPasswordLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { message: 'Trop de tentatives, réessayez dans 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

const emailLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 3,
  message: { message: 'Trop de demandes, réessayez dans 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

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
    app.use('/api/docs', (req, res, next) => {
      res.status(404).sendFile(path.join(__dirname, '../frontend/index.html'));
    });
  } else {
    app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(openapiDoc, {
    customCss: `
      /* Fond global */
      html, body, #swagger-ui, .swagger-ui { background: #0a0a0a !important; }
      .swagger-ui .wrapper { background: #0a0a0a !important; }
      .swagger-ui .topbar { display: none !important; }

      /* Polices */
      .swagger-ui, .swagger-ui .opblock-body, .swagger-ui .opblock-description-wrapper,
      .swagger-ui table, .swagger-ui .btn { font-family: 'Space Grotesk', sans-serif !important; }
      .swagger-ui .info .title, .swagger-ui .opblock-tag { font-family: 'Orbitron', sans-serif !important; }

      /* Titres et texte */
      .swagger-ui .info .title { color: #C8A96E !important; }
      .swagger-ui .info .title small { background: #C8A96E !important; color: #0a0a0a !important; }
      .swagger-ui .info .title small pre { color: #0a0a0a !important; }
      .swagger-ui .info { margin: 30px 0 !important; }
      .swagger-ui .info p, .swagger-ui .info a { color: #aaa !important; }
      .swagger-ui p, .swagger-ui .markdown p, .swagger-ui .renderedMarkdown p { color: #aaa !important; }
      .swagger-ui h4, .swagger-ui h5, .swagger-ui label { color: #ddd !important; }
      .swagger-ui a { color: #C8A96E !important; }
      .swagger-ui .opblock-tag { color: #C8A96E !important; border-bottom: 1px solid #1a1a1a !important; }
      .swagger-ui .opblock-tag small { color: #888 !important; }

      /* Scheme container */
      .swagger-ui .scheme-container { background: #111 !important; border-bottom: 1px solid #222 !important; box-shadow: none !important; }

      /* Blocs opérations */
      .swagger-ui .opblock { border-color: #222 !important; background: #111 !important; box-shadow: none !important; }
      .swagger-ui .opblock .opblock-summary { border-color: #222 !important; }
      .swagger-ui .opblock .opblock-summary-description { color: #aaa !important; }
      .swagger-ui .opblock .opblock-summary-path, .swagger-ui .opblock .opblock-summary-path span { color: #ddd !important; }
      .swagger-ui .opblock.opblock-get { background: rgba(26,58,92,0.15) !important; border-color: #1a3a5c !important; }
      .swagger-ui .opblock.opblock-get .opblock-summary { border-color: #1a3a5c !important; background: rgba(26,58,92,0.25) !important; }
      .swagger-ui .opblock.opblock-post { background: rgba(26,92,58,0.15) !important; border-color: #1a5c3a !important; }
      .swagger-ui .opblock.opblock-post .opblock-summary { border-color: #1a5c3a !important; background: rgba(26,92,58,0.25) !important; }
      .swagger-ui .opblock.opblock-put { background: rgba(92,74,26,0.15) !important; border-color: #5c4a1a !important; }
      .swagger-ui .opblock.opblock-put .opblock-summary { border-color: #5c4a1a !important; background: rgba(92,74,26,0.25) !important; }
      .swagger-ui .opblock.opblock-delete { background: rgba(92,26,26,0.15) !important; border-color: #5c1a1a !important; }
      .swagger-ui .opblock.opblock-delete .opblock-summary { border-color: #5c1a1a !important; background: rgba(92,26,26,0.25) !important; }
      .swagger-ui .opblock-body { background: #0d0d0d !important; }
      .swagger-ui .opblock-body pre { background: #111 !important; color: #ccc !important; }
      .swagger-ui .opblock-description-wrapper p { color: #aaa !important; }

      /* Boutons */
      .swagger-ui .btn { border-color: #C8A96E !important; color: #C8A96E !important; background: transparent !important; }
      .swagger-ui .btn:hover { background: rgba(200,169,110,0.1) !important; }
      .swagger-ui .btn.execute { background: #C8A96E !important; color: #0a0a0a !important; border-color: #C8A96E !important; }
      .swagger-ui .btn.cancel { background: transparent !important; }

      /* Inputs */
      .swagger-ui select { background: #1a1a1a !important; color: #e0e0e0 !important; border-color: #333 !important; }
      .swagger-ui input[type=text], .swagger-ui input[type=password], .swagger-ui input[type=search],
      .swagger-ui input[type=email], .swagger-ui input[type=file] { background: #1a1a1a !important; color: #e0e0e0 !important; border-color: #333 !important; }
      .swagger-ui textarea { background: #1a1a1a !important; color: #e0e0e0 !important; border-color: #333 !important; }

      /* Tables */
      .swagger-ui table { background: transparent !important; }
      .swagger-ui table thead tr th { color: #C8A96E !important; border-bottom: 1px solid #222 !important; background: transparent !important; }
      .swagger-ui table tbody tr td { border-bottom: 1px solid #1a1a1a !important; color: #ccc !important; background: transparent !important; }
      .swagger-ui .parameters-col_description input { background: #1a1a1a !important; color: #e0e0e0 !important; }

      /* Paramètres */
      .swagger-ui .parameter__name { color: #e0e0e0 !important; }
      .swagger-ui .parameter__name.required::after { color: #e74c3c !important; }
      .swagger-ui .parameter__type { color: #888 !important; }
      .swagger-ui .parameter__in { color: #666 !important; }

      /* Réponses */
      .swagger-ui .response-col_status { color: #C8A96E !important; }
      .swagger-ui .response-col_description { color: #ccc !important; }
      .swagger-ui .responses-inner { background: #0d0d0d !important; }
      .swagger-ui .responses-table { background: transparent !important; }
      .swagger-ui .response { color: #ccc !important; }
      .swagger-ui .microlight { background: #111 !important; color: #ccc !important; }
      .swagger-ui .highlight-code { background: #111 !important; }
      .swagger-ui .highlight-code .microlight { background: #111 !important; }
      .swagger-ui .copy-to-clipboard { background: #222 !important; }

      /* Modèles */
      .swagger-ui section.models { border: 1px solid #222 !important; background: #0d0d0d !important; }
      .swagger-ui section.models h4 { color: #C8A96E !important; border-bottom: 1px solid #222 !important; }
      .swagger-ui .model-title { color: #C8A96E !important; }
      .swagger-ui .model-box { background: #111 !important; }
      .swagger-ui .model { color: #ccc !important; }
      .swagger-ui .prop-type { color: #C8A96E !important; }
      .swagger-ui .prop-format { color: #888 !important; }

      /* Authorize */
      .swagger-ui .auth-wrapper { background: #0d0d0d !important; }
      .swagger-ui .dialog-ux .modal-ux { background: #111 !important; border: 1px solid #222 !important; }
      .swagger-ui .dialog-ux .modal-ux-header { border-bottom: 1px solid #222 !important; }
      .swagger-ui .dialog-ux .modal-ux-header h3 { color: #C8A96E !important; }
      .swagger-ui .dialog-ux .modal-ux-content p { color: #ccc !important; }
      .swagger-ui .dialog-ux .modal-ux-content h4 { color: #ddd !important; }
      .swagger-ui .auth-btn-wrapper .btn-done { background: #C8A96E !important; color: #0a0a0a !important; }
    `,
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
app.use(express.static(path.join(__dirname, '../frontend/')));
app.use('/css', express.static(path.join(__dirname, '../frontend/css')));
app.use('/js', express.static(path.join(__dirname, '../frontend/js')));

// SSR /details/:slug et /details?id=X — injecte les meta tags dynamiques
// AVANT la liste statique htmlPages (sinon /details serait servi en HTML brut).
const createDetailsSsrRouter = require('./routes/details-ssr');
app.use('/', createDetailsSsrRouter(() => pool));

// Routes HTML sans extension (utile en dev local — en prod c'est Apache/.htaccess qui gère)
const htmlPages = [
  'verify-email', 'forgot-password', 'reset-password', 'check-email',
  'hangar', 'timeline', 'favorites', 'login', 'settings',
  'a-propos', 'contact', 'faq', 'support', 'mentions-legales',
  'politique-confidentialite', 'cgu',
];
htmlPages.forEach(page => {
  app.get(`/${page}`, (req, res) => {
    res.sendFile(path.join(__dirname, `../frontend/${page}.html`));
  });
});
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// -----------------------------------------------------------------------------
// Routes
// -----------------------------------------------------------------------------
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
const airplanesRouter = createAirplanesRouter(() => pool, {
  onAirplaneChange: () => app.invalidateStatsCache?.(),
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
    return res.sendFile(path.join(frontendDir, req.path + '.html'));
  }

  // Fallback async pour les pages ajoutées dynamiquement après le démarrage
  const htmlFile = path.join(frontendDir, req.path + '.html');
  try {
    await fsPromises.access(htmlFile, fs.constants.F_OK);
    return res.sendFile(htmlFile);
  } catch {
    // 404 personnalisé
    const notFoundFile = path.join(frontendDir, '404.html');
    try {
      await fsPromises.access(notFoundFile, fs.constants.F_OK);
      return res.status(404).sendFile(notFoundFile);
    } catch {
      res.status(404).send('Page non trouvée');
    }
  }
});

// -----------------------------------------------------------------------------
// Gestionnaire d'erreurs global
// -----------------------------------------------------------------------------
app.use((err, req, res, next) => {
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
