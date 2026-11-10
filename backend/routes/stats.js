const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const statsRepo = require('../repositories/stats');

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

    const stats = await statsRepo.loadCatalogStats(getPool());
    const data = {
      airplanes: stats.airplanes,
      earliest_year: stats.earliest ?? null,
      latest_year: stats.latest ?? null,
      countries: stats.countries,
      generations: stats.generations,
    };

    cached = data;
    cacheTime = now;

    res.json(data);
  }));

  // Invalider le cache (appelé après ajout/suppression d'avion)
  router.invalidateCache = () => { cached = null; };

  return router;
};
