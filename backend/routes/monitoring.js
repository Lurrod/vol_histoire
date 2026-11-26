'use strict';
const crypto = require('crypto');
const express = require('express');
const { register } = require('../middleware/observability');
const logger = require('../logger');
const pkg = require('../package.json');

// -----------------------------------------------------------------------------
// Endpoints de monitoring
//   GET /api/live    → Liveness probe (toujours 200 si le process tourne)
//   GET /api/health  → Santé publique (200 si la base répond, 503 sinon)
//   GET /api/ready   → Readiness probe (200 si DB OK, 503 sinon)
//   GET /api/metrics → Métriques Prometheus (texte)
//   GET /api/status  → Statut applicatif (version, uptime, sentry, env)
// -----------------------------------------------------------------------------
/**
 * Comparaison de jetons à temps constant. `!==` s'arrête au premier octet qui
 * diffère : le temps de réponse fuit alors la longueur du préfixe correct.
 * timingSafeEqual exige des tailles identiques, d'où le hachage préalable —
 * qui égalise à 32 octets sans révéler la longueur du secret.
 */
function tokenEgal(fourni, attendu) {
  if (typeof fourni !== 'string' || typeof attendu !== 'string' || !attendu) return false;
  const a = crypto.createHash('sha256').update(fourni).digest();
  const b = crypto.createHash('sha256').update(attendu).digest();
  return crypto.timingSafeEqual(a, b);
}

module.exports = function createMonitoringRouter(getPool) {
  const router = express.Router();
  const startedAt = new Date();

  // Liveness — pas de dépendance, juste vérifier que Express répond.
  // Pas d'uptime : public, il donnerait la date du dernier redémarrage
  // (donc des déploiements). Il reste dans /status, protégé par jeton.
  router.get('/live', (req, res) => {
    res.json({ status: 'ok' });
  });

  // Health check. Pas d'uptime : public, il donnait la date du dernier
  // redémarrage. Le déploiement vérifie le redémarrage par le PID pm2.
  router.get('/health', async (req, res) => {
    try {
      await getPool().query('SELECT 1');
      res.json({ status: 'ok', timestamp: new Date().toISOString() });
    } catch {
      res.status(503).json({ status: 'error', message: 'Database unreachable' });
    }
  });

  // Readiness — vérifie la dépendance critique (PostgreSQL)
  // Le statut Redis est informatif : Redis down ≠ not_ready (fallback mémoire OK)
  router.get('/ready', async (req, res) => {
    const pool = getPool();
    if (!pool) {
      return res.status(503).json({ status: 'not_ready', reason: 'pool_not_initialized' });
    }
    const redisClient = req.app._redisClient;
    let redisStatus = { configured: false };
    if (redisClient) {
      const start = Date.now();
      try {
        await redisClient.ping();
        redisStatus = { configured: true, ok: true, latencyMs: Date.now() - start };
      } catch (err) {
        // Le message (hôte, port, cause) va au journal, pas à la réponse publique.
        logger.warn('readiness_redis_failed', { error: err });
        redisStatus = { configured: true, ok: false };
      }
    }
    try {
      const start = Date.now();
      await pool.query('SELECT 1');
      res.json({
        status: 'ready',
        db: { ok: true, latencyMs: Date.now() - start },
        redis: redisStatus,
      });
    } catch (err) {
      logger.error('readiness_check_failed', { error: err });
      res.status(503).json({ status: 'not_ready', db: { ok: false }, redis: redisStatus });
    }
  });

  // Métriques Prometheus (à scraper depuis Prometheus / Grafana Agent)
  // Protégé par Bearer token — obligatoire en production
  router.get('/metrics', async (req, res) => {
    const token = process.env.METRICS_TOKEN;
    if (!token && process.env.NODE_ENV === 'production') {
      return res.status(403).json({ message: 'METRICS_TOKEN requis en production.' });
    }
    if (token) {
      const auth = req.headers.authorization || '';
      const provided = auth.startsWith('Bearer ') ? auth.slice(7) : '';
      if (!tokenEgal(provided, token)) {
        return res.status(401).end();
      }
    }
    try {
      res.setHeader('Content-Type', register.contentType);
      res.end(await register.metrics());
    } catch {
      res.status(500).end();
    }
  });

  // Statut applicatif — protégé par le même token que /metrics
  router.get('/status', (req, res) => {
    const token = process.env.METRICS_TOKEN;
    if (token) {
      const auth = req.headers.authorization || '';
      const provided = auth.startsWith('Bearer ') ? auth.slice(7) : '';
      if (!tokenEgal(provided, token)) {
        return res.status(401).end();
      }
    }
    res.json({
      status: 'ok',
      service: pkg.name,
      version: pkg.version,
      env: process.env.NODE_ENV || 'development',
      uptimeSec: Math.round(process.uptime()),
      startedAt: startedAt.toISOString(),
    });
  });

  return router;
};
