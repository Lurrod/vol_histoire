'use strict';

/**
 * Requêtes du sitemap (routes/sitemap.js).
 */

/**
 * Fiches publiées, avec leur date de dernière écriture en base : `updated_at`
 * est tenu à jour par le déclencheur trg_airplanes_updated_at (db.sql).
 * @param {import('pg').Pool} pool
 * @returns {Promise<{id: number, name: string, updated_at: Date|null}[]>}
 */
async function listAirplanesForSitemap(pool) {
  const { rows } = await pool.query(
    'SELECT id, name, updated_at FROM airplanes ORDER BY id ASC'
  );
  return rows;
}

module.exports = { listAirplanesForSitemap };
