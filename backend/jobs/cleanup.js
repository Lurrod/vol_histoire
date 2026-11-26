'use strict';
const logger = require('../logger');

const HOUR = 60 * 60 * 1000;
const DAY = 24 * HOUR;
// Délai avant la première passe : laisse le serveur démarrer et la base répondre.
const STARTUP_DELAY = 60 * 1000;

// -----------------------------------------------------------------------------
// Tâches périodiques de purge
// -----------------------------------------------------------------------------
// - refresh tokens expirés ou révoqués : toutes les heures ;
// - comptes non vérifiés depuis plus de 7 jours : toutes les 24 h.
// Les deux tournent aussi une minute après le démarrage (JS-007) : avec des
// setInterval seuls, chaque redémarrage (déploiement) remettait le compteur
// à zéro, et des déploiements rapprochés repoussaient la purge des comptes
// non vérifiés au-delà des 7 jours annoncés par la politique de
// confidentialité.

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
  const startup = setTimeout(() => {
    runTokenCleanup(cleanupExpiredTokens);
    runUnverifiedUsersCleanup(cleanupUnverifiedUsers);
  }, STARTUP_DELAY);
  const timers = [
    setInterval(() => runTokenCleanup(cleanupExpiredTokens), HOUR),
    setInterval(() => runUnverifiedUsersCleanup(cleanupUnverifiedUsers), DAY),
  ];
  return () => {
    clearTimeout(startup);
    timers.forEach(clearInterval);
  };
}

module.exports = { startCleanupJobs, runTokenCleanup, runUnverifiedUsersCleanup };
