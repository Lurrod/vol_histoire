'use strict';
const logger = require('../logger');

/**
 * Ouvre la connexion Redis (REDIS_URL) et la valide par un ping.
 * 1. Connexion paresseuse + ping pour valider rapidement (échec → null, repli mémoire)
 * 2. En cas de déconnexion runtime, ioredis reconnecte avec backoff ; les appels
 *    échouent vite (offlineQueue=false) et cache.js/rate-limit tombent en mémoire.
 * @param {string} url
 * @returns {Promise<object|null>} client prêt, ou null si Redis est indisponible
 */
async function connectRedis(url) {
  let client;
  try {
    const Redis = require('ioredis');
    client = new Redis(url, {
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
    return client;
  } catch (err) {
    logger.warn('Redis indisponible — fallback mémoire', { error: err.message });
    try { if (client) client.disconnect(); } catch { /* déjà fermé */ }
    return null;
  }
}

module.exports = { connectRedis };
