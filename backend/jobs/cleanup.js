'use strict';
const logger = require('../logger');

const HOUR = 60 * 60 * 1000;
const DAY = 24 * HOUR;

// -----------------------------------------------------------------------------
// Tâches périodiques de purge
// -----------------------------------------------------------------------------
// - refresh tokens expirés ou révoqués : toutes les heures ;
// - comptes non vérifiés depuis plus de 7 jours : toutes les 24 h.

async function runTokenCleanup(cleanupExpiredTokens) {
  try {
    await cleanupExpiredTokens();
  } catch (err) {
    logger.error('Erreur nettoyage refresh tokens', { error: err.message });
  }
}

async function runUnverifiedUsersCleanup(cleanupUnverifiedUsers) {
  try {
    const deleted = await cleanupUnverifiedUsers();
    if (deleted > 0) logger.info('Comptes non vérifiés purgés', { count: deleted });
  } catch (err) {
    logger.error('Erreur purge comptes non vérifiés', { error: err.message });
  }
}

/**
 * Démarre les purges périodiques.
 * @param {{ cleanupExpiredTokens: Function, cleanupUnverifiedUsers: Function }} tasks
 * @returns {() => void} arrêt des minuteries (tests, arrêt gracieux)
 */
function startCleanupJobs({ cleanupExpiredTokens, cleanupUnverifiedUsers }) {
  const timers = [
    setInterval(() => runTokenCleanup(cleanupExpiredTokens), HOUR),
    setInterval(() => runUnverifiedUsersCleanup(cleanupUnverifiedUsers), DAY),
  ];
  return () => timers.forEach(clearInterval);
}

module.exports = { startCleanupJobs, runTokenCleanup, runUnverifiedUsersCleanup };
