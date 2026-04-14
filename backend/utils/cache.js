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
 * Si Redis tombe en panne en runtime, les opérations fallback silencieusement
 * en mémoire (le cache survit mais n'est plus partagé entre instances).
 */

let redisClient = null;
const memory = new Map(); // key → { value, expiresAt }

function setRedisClient(client) {
  redisClient = client;
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
    } catch {
      // fallthrough vers mémoire
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
    } catch {
      // fallthrough vers mémoire
    }
  }
  memory.set(key, { value, expiresAt: Date.now() + ttl * 1000 });
}

/**
 * @param {string} key
 */
async function del(key) {
  if (redisClient) {
    try { await redisClient.del(key); } catch { /* noop */ }
  }
  memory.delete(key);
}

// Utile pour les tests
function _resetForTests() {
  redisClient = null;
  memory.clear();
}

module.exports = { setRedisClient, get, set, del, _resetForTests };
