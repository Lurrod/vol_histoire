const express = require('express');

module.exports = function createStatsRouter(getPool) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Statistiques
  // -----------------------------------------------------------------------------
  router.get('/stats', async (req, res) => {
    try {
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

      res.json({
        airplanes: countRes.rows[0].total,
        earliest_year: datesRes.rows[0].earliest ?? null,
        latest_year: datesRes.rows[0].latest ?? null,
        countries: countriesRes.rows[0].total,
      });
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  return router;
};
