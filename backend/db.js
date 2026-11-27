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

/**
 * Colonnes DATE (premier vol, mise en service, dates d'un conflit) rendues
 * telles quelles, en texte « AAAA-MM-JJ », comme le décrit openapi.yaml.
 * Par défaut, node-postgres en fait un objet Date à minuit dans le fuseau du
 * serveur (Paris) ; en JSON, il devenait « la veille à 22 h ou 23 h UTC ».
 * Un visiteur des Amériques voyait alors chaque date un jour plus tôt (et
 * « 31 décembre 1977 » pour une date connue à l'année 1978), et le
 * formulaire d'administration réenregistrait la veille. Une date de
 * calendrier n'a pas de fuseau : on la garde en texte.
 * Réglage global du module pg : à appeler avant de créer un pool.
 * @param {typeof import('pg')} pg
 */
const PG_DATE_OID = 1082;
function useCalendarDates(pg) {
  pg.types.setTypeParser(PG_DATE_OID, (value) => value);
  return pg;
}

module.exports = { withTransaction, watchPoolErrors, useCalendarDates };
