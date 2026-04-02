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
  authorize, cleanupExpiredTokens, revokeAllUserRefreshTokens,
} = authMiddleware;
const mailer = require('./mailer');

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
    "script-src 'self' https://www.googletagmanager.com https://www.google-analytics.com",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com",
    "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com",
    "img-src 'self' https://i.postimg.cc https://flagcdn.com https://www.googletagmanager.com data:",
    "connect-src 'self' https://www.google-analytics.com https://www.googletagmanager.com",
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
});

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: { message: "Trop de tentatives de connexion, réessayez dans 15 minutes." },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

const globalApiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  message: { message: 'Trop de requêtes, réessayez plus tard.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

const refreshLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  message: { message: 'Trop de tentatives de rafraîchissement, réessayez dans 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
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

// -----------------------------------------------------------------------------
// Documentation API (Swagger UI)
// -----------------------------------------------------------------------------
try {
  const openapiDoc = YAML.parse(fs.readFileSync(path.join(__dirname, 'openapi.yaml'), 'utf8'));
  app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(openapiDoc, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'Vol d\'Histoire — API Docs',
  }));
} catch { /* openapi.yaml absent (tests) — Swagger désactivé */ }

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injectable pour les tests)
// -----------------------------------------------------------------------------
let pool;

app.setPool = (p) => { pool = p; authMiddleware.setPool(p); };
app.getPool = () => pool;

// -----------------------------------------------------------------------------
// Fichiers statiques
// -----------------------------------------------------------------------------
app.use(express.static(path.join(__dirname, '../frontend/')));
app.use('/css', express.static(path.join(__dirname, '../frontend/css')));
app.use('/js', express.static(path.join(__dirname, '../frontend/js')));

// Routes HTML sans extension (utile en dev local — en prod c'est Apache/.htaccess qui gère)
const htmlPages = [
  'verify-email', 'forgot-password', 'reset-password', 'check-email',
  'hangar', 'details', 'timeline', 'favorites', 'login', 'settings',
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

const createAirplanesRouter = require('./routes/airplanes');
app.use('/api', createAirplanesRouter(() => pool, {
  onAirplaneChange: () => app.invalidateStatsCache?.(),
}));

const createFavoritesRouter = require('./routes/favorites');
app.use('/api', createFavoritesRouter(() => pool));

const createStatsRouter = require('./routes/stats');
const statsRouter = createStatsRouter(() => pool);
app.use('/api', statsRouter);

// Exposer l'invalidation du cache stats (utilisé par les routes airplanes)
app.invalidateStatsCache = () => statsRouter.invalidateCache?.();

const createSitemapRouter = require('./routes/sitemap');
app.use('/', createSitemapRouter(() => pool));

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
  const entry = logger.error('Erreur non gérée', { error: err.message, path: req.path, method: req.method });
  res.status(500).json({ message: 'Erreur interne du serveur', errorId: entry.errorId });
});

// -----------------------------------------------------------------------------
// Nettoyage périodique des refresh tokens expirés/révoqués (toutes les heures)
// -----------------------------------------------------------------------------
let tokenCleanupInterval;
if (process.env.NODE_ENV !== 'test') {
  tokenCleanupInterval = setInterval(async () => {
    try {
      await cleanupExpiredTokens();
    } catch (err) {
      logger.error('Erreur nettoyage refresh tokens', { error: err.message });
    }
  }, 60 * 60 * 1000);
}

// Exposé pour les tests et le graceful shutdown
app.stopCleanup = () => {
  if (tokenCleanupInterval) clearInterval(tokenCleanupInterval);
};

// Exposé pour que d'autres routes puissent révoquer les tokens (ex: changement de MDP)
app.revokeAllUserRefreshTokens = revokeAllUserRefreshTokens;

module.exports = app;
