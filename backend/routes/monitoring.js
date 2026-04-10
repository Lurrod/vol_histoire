'use strict';
const express = require('express');
const { register } = require('../middleware/observability');
const logger = require('../logger');
const pkg = require('../package.json');

// -----------------------------------------------------------------------------
// Endpoints de monitoring
//   GET /api/live    → Liveness probe (toujours 200 si le process tourne)
//   GET /api/ready   → Readiness probe (200 si DB OK, 503 sinon)
//   GET /api/metrics → Métriques Prometheus (texte)
//   GET /api/status  → Statut applicatif (version, uptime, sentry, env)
// -----------------------------------------------------------------------------
module.exports = function createMonitoringRouter(getPool) {
  const router = express.Router();
  const startedAt = new Date();

  // Liveness — pas de dépendance, juste vérifier que Express répond
  router.get('/live', (req, res) => {
    res.json({ status: 'ok', uptime: process.uptime() });
  });

  // Readiness — vérifie la dépendance critique (PostgreSQL)
  router.get('/ready', async (req, res) => {
    const pool = getPool();
    if (!pool) {
      return res.status(503).json({ status: 'not_ready', reason: 'pool_not_initialized' });
    }
    try {
      const start = Date.now();
      await pool.query('SELECT 1');
      res.json({
        status: 'ready',
        db: { ok: true, latencyMs: Date.now() - start },
      });
    } catch (err) {
      logger.error('readiness_check_failed', { error: err });
      res.status(503).json({ status: 'not_ready', db: { ok: false } });
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
      if (provided !== token) {
        return res.status(401).end();
      }
    }
    try {
      res.setHeader('Content-Type', register.contentType);
      res.end(await register.metrics());
    } catch (err) {
      res.status(500).end();
    }
  });

  // Statut applicatif — protégé par le même token que /metrics
  router.get('/status', (req, res) => {
    const token = process.env.METRICS_TOKEN;
    if (token) {
      const auth = req.headers.authorization || '';
      const provided = auth.startsWith('Bearer ') ? auth.slice(7) : '';
      if (provided !== token) {
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
