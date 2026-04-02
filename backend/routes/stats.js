const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const logger = require('../logger');

module.exports = function createStatsRouter(getPool) {
  const router = express.Router();

  // Cache en mémoire (TTL 5 minutes)
  let cached = null;
  let cacheTime = 0;
  const TTL = 5 * 60 * 1000;

  // -----------------------------------------------------------------------------
  // Statistiques
  // -----------------------------------------------------------------------------
  router.get('/stats', asyncHandler(async (req, res) => {
    const now = Date.now();

    if (cached && now - cacheTime < TTL) {
      return res.json(cached);
    }

    const [countRes, datesRes, countriesRes] = await Promise.all([
      getPool().query('SELECT COUNT(*)::int AS total FROM airplanes'),
      getPool().query(`
        SELECT
          MIN(EXTRACT(YEAR FROM date_first_fly))::int AS earliest,
          MAX(EXTRACT(YEAR FROM date_first_fly))::int AS latest
        FROM airplanes
        WHERE date_first_fly IS NOT NULL
      `),
      getPool().query('SELECT COUNT(DISTINCT country_id)::int AS total FROM airplanes WHERE country_id IS NOT NULL'),
    ]);

    const data = {
      airplanes: countRes.rows[0].total,
      earliest_year: datesRes.rows[0].earliest ?? null,
      latest_year: datesRes.rows[0].latest ?? null,
      countries: countriesRes.rows[0].total,
    };

    cached = data;
    cacheTime = now;

    res.json(data);
  }));

  // Invalider le cache (appelé après ajout/suppression d'avion)
  router.invalidateCache = () => { cached = null; };

  return router;
};
