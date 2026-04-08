'use strict';
const crypto = require('crypto');
const promClient = require('prom-client');
const logger = require('../logger');

// -----------------------------------------------------------------------------
// Observability — Request ID + Access logs + Métriques Prometheus
// -----------------------------------------------------------------------------

// Registre Prometheus dédié (évite collision si plusieurs apps dans le process)
const register = new promClient.Registry();
register.setDefaultLabels({ app: 'vol_histoire' });

// Métriques par défaut Node.js (CPU, mémoire, event loop, GC)
promClient.collectDefaultMetrics({ register, prefix: 'voh_' });

// Compteur HTTP : nombre total de requêtes
const httpRequestsTotal = new promClient.Counter({
  name: 'voh_http_requests_total',
  help: 'Nombre total de requêtes HTTP',
  labelNames: ['method', 'route', 'status'],
  registers: [register],
});

// Histogramme HTTP : durée des requêtes en secondes
const httpRequestDuration = new promClient.Histogram({
  name: 'voh_http_request_duration_seconds',
  help: 'Durée des requêtes HTTP en secondes',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2, 5],
  registers: [register],
});

// Jauge pool PostgreSQL (connexions actives/idle/waiting)
const dbPoolActive = new promClient.Gauge({
  name: 'voh_db_pool_active',
  help: 'Connexions PostgreSQL actuellement actives',
  registers: [register],
});
const dbPoolIdle = new promClient.Gauge({
  name: 'voh_db_pool_idle',
  help: 'Connexions PostgreSQL idle',
  registers: [register],
});
const dbPoolWaiting = new promClient.Gauge({
  name: 'voh_db_pool_waiting',
  help: 'Requêtes en attente d\'une connexion PostgreSQL',
  registers: [register],
});

// Compteur erreurs non gérées
const errorsTotal = new promClient.Counter({
  name: 'voh_errors_total',
  help: 'Nombre total d\'erreurs serveur (5xx + non gérées)',
  labelNames: ['type'],
  registers: [register],
});

// -----------------------------------------------------------------------------
// Middleware : Request ID
// -----------------------------------------------------------------------------
function requestId(req, res, next) {
  const incoming = req.headers['x-request-id'];
  req.id = (typeof incoming === 'string' && incoming.length <= 64)
    ? incoming
    : crypto.randomBytes(8).toString('hex');
  res.setHeader('X-Request-ID', req.id);
  next();
}

// -----------------------------------------------------------------------------
// Middleware : Access log + métriques HTTP
// -----------------------------------------------------------------------------
function accessLog(req, res, next) {
  const start = process.hrtime.bigint();

  res.on('finish', () => {
    const durationNs = Number(process.hrtime.bigint() - start);
    const durationSec = durationNs / 1e9;

    // Route normalisée (évite l'explosion de cardinalité avec les params)
    const route = (req.route && req.baseUrl + req.route.path)
      || req.path.replace(/\/\d+/g, '/:id').replace(/\/[a-f0-9-]{16,}/gi, '/:hash');

    const labels = { method: req.method, route, status: String(res.statusCode) };
    httpRequestsTotal.inc(labels);
    httpRequestDuration.observe(labels, durationSec);

    if (res.statusCode >= 500) {
      errorsTotal.inc({ type: 'http_5xx' });
    }

    // Log structuré (skip health/metrics pour ne pas polluer)
    if (req.path !== '/api/live' && req.path !== '/api/ready' && req.path !== '/api/metrics') {
      logger.info('http_request', {
        reqId: req.id,
        method: req.method,
        path: req.path,
        status: res.statusCode,
        durationMs: Math.round(durationSec * 1000),
        ip: req.ip,
        userAgent: req.headers['user-agent'],
        userId: req.user?.id,
      });
    }
  });

  next();
}

// -----------------------------------------------------------------------------
// Mise à jour périodique des métriques DB pool
// -----------------------------------------------------------------------------
function startDbPoolMetrics(getPool, intervalMs = 5000) {
  const timer = setInterval(() => {
    try {
      const pool = getPool();
      if (pool && typeof pool.totalCount === 'number') {
        dbPoolActive.set(pool.totalCount - pool.idleCount);
        dbPoolIdle.set(pool.idleCount);
        dbPoolWaiting.set(pool.waitingCount);
      }
    } catch { /* silencieux */ }
  }, intervalMs);
  timer.unref();
  return timer;
}

module.exports = {
  register,
  requestId,
  accessLog,
  startDbPoolMetrics,
  errorsTotal,
};
