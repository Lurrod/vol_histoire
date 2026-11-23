/**
 * Route /api/timeline — frise chronologique.
 *
 * Renvoie les décennies 1940 → 2020 (événements éditoriaux et appareils,
 * placés à leur mise en service ou, à défaut, à leur premier vol) et les
 * conflits datés auxquels au moins un appareil est rattaché.
 * Forme et cache : utils/timeline-payload.js (clé vdh:timeline:v3, 30 min).
 */
const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const timelinePayload = require('../utils/timeline-payload');

module.exports = function createTimelineRouter(getPool) {
  const router = express.Router();

  router.get('/timeline', asyncHandler(async (req, res) => {
    const { json, hit } = await timelinePayload.loadPayloadJson(getPool(), { force: req.query.force === '1' });
    res.setHeader('X-Cache', hit ? 'HIT' : 'MISS');
    res.type('application/json').send(json);
  }));

  // Invalidation exposée au module app (appelée par les routes airplanes
  // quand une fiche est créée, modifiée ou supprimée).
  router.invalidateCache = () => timelinePayload.invalidate();

  return router;
};
