'use strict';

// Helper pour exécuter une fonction dans une transaction SQL.
// Commit automatique si fn() réussit, rollback si elle throw.
async function withTransaction(pool, fn) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const result = await fn(client);
    await client.query('COMMIT');
    return result;
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

/**
 * Écoute les erreurs des connexions inactives du pool (JS-003). node-postgres
 * émet « error » sur le pool quand un client au repos perd sa connexion
 * (redémarrage de PostgreSQL, coupure réseau). Sans écouteur, l'événement
 * devient une exception non capturée et arrête le processus ; avec lui, le
 * client fautif est retiré du pool et la prochaine requête en ouvre un neuf.
 * @param {import('pg').Pool} pool
 * @param {{ error: Function }} logger
 */
function watchPoolErrors(pool, logger) {
  pool.on('error', (err) => {
    logger.error('PostgreSQL : connexion inactive perdue', { error: err });
  });
  return pool;
}

module.exports = { withTransaction, watchPoolErrors };
