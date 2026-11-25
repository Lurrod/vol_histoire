/**
 * Cache applicatif léger : Redis si dispo, sinon Map en mémoire.
 *
 * Utilisation :
 *   const cache = require('./utils/cache');
 *   await cache.set('foo', 'bar', 3600);   // TTL 1h
 *   const v = await cache.get('foo');
 *   await cache.del('foo');
 *
 * Branchement Redis : cache.setRedisClient(ioredisInstance) dans app.initRedis().
 * Si Redis tombe en panne en runtime, les opérations se replient en mémoire
 * (le cache survit mais n'est plus partagé entre instances). Les erreurs
 * Redis sont journalisées (JS-005), au plus une fois par minute et par
 * opération ; une invalidation (del) en échec est retentée une fois, sinon
 * la clé périmée resterait servie jusqu'à son expiration.
 */
const logger = require('../logger');

let redisClient = null;
const memory = new Map(); // key → { value, expiresAt }
const lastWarnAt = {};
const WARN_INTERVAL_MS = 60 * 1000;
const DEL_RETRY_MS = 1000;

function setRedisClient(client) {
  redisClient = client;
}

function warnRedis(op, key, err) {
  const now = Date.now();
  if (lastWarnAt[op] && now - lastWarnAt[op] < WARN_INTERVAL_MS) return;
  lastWarnAt[op] = now;
  logger.warn('cache_redis_error', { op, key, error: err && err.message });
}

/**
 * @param {string} key
 * @returns {Promise<string|null>}
 */
async function get(key) {
  if (redisClient) {
    try {
      const val = await redisClient.get(key);
      if (val !== null) return val;
    } catch (err) {
      warnRedis('get', key, err); // repli sur la mémoire
    }
  }
  const entry = memory.get(key);
  if (!entry) return null;
  if (Date.now() > entry.expiresAt) {
    memory.delete(key);
    return null;
  }
  return entry.value;
}

/**
 * @param {string} key
 * @param {string} value
 * @param {number} ttlSeconds
 */
async function set(key, value, ttlSeconds) {
  const ttl = Math.max(1, Number(ttlSeconds) || 0);
  if (redisClient) {
    try {
      await redisClient.setex(key, ttl, value);
      return;
    } catch (err) {
      warnRedis('set', key, err); // repli sur la mémoire
    }
  }
  memory.set(key, { value, expiresAt: Date.now() + ttl * 1000 });
}

/**
 * @param {string} key
 */
async function del(key) {
  memory.delete(key);
  if (!redisClient) return;
  const client = redisClient;
  try {
    await client.del(key);
  } catch (err) {
    warnRedis('del', key, err);
    // Un second essai peu après : une coupure brève ne doit pas laisser la
    // clé périmée en place jusqu'à son TTL.
    const retry = setTimeout(() => {
      client.del(key).catch((e) => warnRedis('del-retry', key, e));
    }, DEL_RETRY_MS);
    if (retry.unref) retry.unref();
  }
}

// Utile pour les tests
function _resetForTests() {
  redisClient = null;
  memory.clear();
  Object.keys(lastWarnAt).forEach((k) => { delete lastWarnAt[k]; });
}

module.exports = { setRedisClient, get, set, del, _resetForTests };
