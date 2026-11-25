/**
 * Route /api/hero/discoveries — données dynamiques des widgets de la home.
 *
 * Charge utile (day, ephemeris, facts, aircraft) et cache par jour :
 * utils/hero-payload.js, partagé avec le rendu serveur de la photo du jour
 * de l'accueil (utils/home-ssr.js). Invalidation : router.invalidateCache()
 * ou clé vdh:hero:v3:<jour> (déclenchée par les routes airplanes quand une
 * fiche change).
 */
const logger = require('../logger');
const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const heroPayload = require('../utils/hero-payload');

module.exports = function createHeroRouter(getPool) {
  const router = express.Router();

  router.get('/hero/discoveries', asyncHandler(async (req, res) => {
    const { json, hit } = await heroPayload.loadPayloadJson(getPool(), { force: req.query.force === '1' });
    res.setHeader('X-Cache', hit ? 'HIT' : 'MISS');
    res.type('application/json').send(json);
  }));

  router.invalidateCache = async () => {
    try {
      await heroPayload.invalidate();
    } catch (err) {
      logger.warn('hero : invalidation du cache impossible', { error: err.message });
    }
  };

  return router;
};
