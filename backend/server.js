require('dotenv').config();
const logger = require('./logger');

// Validation des variables d'environnement critiques
const REQUIRED_ENV = ['JWT_SECRET', 'REFRESH_SECRET', 'DB_USER', 'DB_HOST', 'DB_NAME', 'DB_PASSWORD'];
const missing = REQUIRED_ENV.filter(key => !process.env[key]);
if (missing.length > 0) {
  logger.error('Variables d\'environnement manquantes', { missing: missing.join(', ') });
  process.exit(1);
}
if (process.env.JWT_SECRET.length < 32) {
  logger.error('JWT_SECRET doit faire au moins 32 caractères');
  process.exit(1);
}
if (process.env.REFRESH_SECRET.length < 32) {
  logger.error('REFRESH_SECRET doit faire au moins 32 caractères');
  process.exit(1);
}

const app = require('./app');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

// Génère frontend/js/app-version.js depuis backend/package.json à chaque boot.
// Le fichier expose window.APP_VERSION (lu par sentry-init.js pour le tag release)
// et window.APP_BUILD (timestamp du boot, utile pour cache-busting et debug).
(function writeAppVersion() {
  try {
    const pkg = require('./package.json');
    const out = `/* Auto-généré au boot du serveur — ne pas éditer */
window.APP_VERSION = ${JSON.stringify(pkg.version)};
window.APP_BUILD   = ${JSON.stringify(new Date().toISOString())};
`;
    fs.writeFileSync(path.join(__dirname, '../frontend/js/app-version.js'), out);
    logger.info('app-version.js généré', { version: pkg.version });
  } catch (err) {
    logger.error('Échec génération app-version.js', { error: err });
  }
})();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
  ssl: process.env.DB_SSL === 'false'     ? false
     : process.env.DB_SSL === 'no-verify' ? { rejectUnauthorized: false }
     :                                      { rejectUnauthorized: true },
});

app.setPool(pool);

// Init Redis rate-limiter (si REDIS_URL défini et Redis joignable)
app.initRedis().then(() => {
  const port = process.env.PORT || 3000;
  const server = app.listen(port, () => {
    logger.info('Serveur démarré', { port, url: `http://localhost:${port}` });
  });

  // Garder la ref pour le shutdown
  setupShutdown(server);
}).catch(err => {
  logger.error('Erreur init serveur', { error: err.message });
  process.exit(1);
});

// -----------------------------------------------------------------------------
// Arrêt gracieux (SIGTERM / SIGINT)
// -----------------------------------------------------------------------------
function setupShutdown(server) {
  async function shutdown(signal) {
    logger.info('Arrêt gracieux en cours', { signal });

    server.close(async () => {
      try {
        // Fermer Redis si connecté
        if (app._redisClient) await app._redisClient.quit().catch(() => {});
        await logger.flushSentry(2000);
        await pool.end();
        logger.info('Pool PostgreSQL fermé');
        process.exit(0);
      } catch (err) {
        logger.error('Erreur fermeture', { error: err });
        process.exit(1);
      }
    });

    setTimeout(() => {
      logger.error('Délai dépassé — arrêt forcé');
      process.exit(1);
    }, 10000).unref();
  }

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
}

// Erreurs non capturées : forward vers logger → Sentry
process.on('uncaughtException', (err) => {
  logger.error('uncaughtException', { error: err });
  process.exit(1);
});
process.on('unhandledRejection', (reason) => {
  logger.error('unhandledRejection', { error: reason instanceof Error ? reason : new Error(String(reason)) });
});