'use strict';

/**
 * Sortie sur erreur fatale (JS-004) : l'envoi Sentry de logger.error est
 * asynchrone ; un process.exit immédiat le coupait, et l'erreur la plus
 * utile — celle qui arrête le serveur — n'atteignait jamais Sentry. On vide
 * d'abord la file (2 s au plus, comme l'arrêt gracieux), puis on quitte.
 * Un minuteur de secours garantit la sortie si le vidage ne rend pas la main.
 * @param {{ flushSentry: (ms: number) => Promise<unknown> }} logger
 * @param {{ exit?: (code: number) => void, timeoutMs?: number }} [opts]
 * @returns {Promise<void>}
 */
function exitAfterFlush(logger, { exit = (code) => process.exit(code), timeoutMs = 2000 } = {}) {
  let done = false;
  const finish = () => {
    if (done) return;
    done = true;
    exit(1);
  };
  const guard = setTimeout(finish, timeoutMs + 500);
  if (guard.unref) guard.unref();
  return Promise.resolve()
    .then(() => logger.flushSentry(timeoutMs))
    .catch(() => { /* Sentry injoignable : on quitte quand même */ })
    .finally(() => {
      clearTimeout(guard);
      finish();
    });
}

module.exports = { exitAfterFlush };
