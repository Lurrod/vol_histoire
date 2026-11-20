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

/**
 * Fiches pour llms.txt (routes/llms.js) : nom, type et pays en français,
 * année de mise en service (à défaut, de premier vol).
 * @param {import('pg').Pool} pool
 * @returns {Promise<{id: number, name: string, type_name: string|null,
 *   country_name: string|null, year: number|null}[]>}
 */
async function listAirplanesForLlms(pool) {
  const { rows } = await pool.query(`
    SELECT a.id, a.name, t.name AS type_name, c.name AS country_name,
           EXTRACT(YEAR FROM COALESCE(a.date_operationel, a.date_first_fly))::int AS year
    FROM airplanes a
    LEFT JOIN type t ON t.id = a.type
    LEFT JOIN countries c ON c.id = a.country_id
    ORDER BY a.name ASC
  `);
  return rows;
}

module.exports = { listAirplanesForSitemap, listAirplanesForLlms };
