'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — chiffres clés du catalogue (GET /api/stats).
// -----------------------------------------------------------------------------

/**
 * @returns {Promise<{ airplanes: number, earliest: number|null, latest: number|null, countries: number, generations: number, wars: number }>}
 */
async function loadCatalogStats(db) {
  const [countRes, datesRes, countriesRes, generationsRes, warsRes] = await Promise.all([
    db.query('SELECT COUNT(*)::int AS total FROM airplanes'),
    db.query(`
        SELECT
          MIN(EXTRACT(YEAR FROM date_first_fly))::int AS earliest,
          MAX(EXTRACT(YEAR FROM date_first_fly))::int AS latest
        FROM airplanes
        WHERE date_first_fly IS NOT NULL
      `),
    db.query('SELECT COUNT(DISTINCT country_id)::int AS total FROM airplanes WHERE country_id IS NOT NULL'),
    db.query('SELECT COUNT(DISTINCT id_generation)::int AS total FROM airplanes WHERE id_generation IS NOT NULL'),
    // Conflits référencés (pied de page : « 61 conflits »)
    db.query('SELECT COUNT(*)::int AS total FROM wars'),
  ]);
  return {
    airplanes: countRes.rows[0].total,
    earliest: datesRes.rows[0].earliest,
    latest: datesRes.rows[0].latest,
    countries: countriesRes.rows[0].total,
    generations: generationsRes.rows[0].total,
    wars: warsRes.rows[0].total,
  };
}

module.exports = { loadCatalogStats };
