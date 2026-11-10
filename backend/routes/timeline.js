/**
 * Route /api/timeline — chronologie éditoriale cinématographique
 *
 * Renvoie la liste des décennies (1940 → 2020) avec :
 *   - les événements éditoriaux (table timeline_events)
 *   - les appareils dont date_operationel tombe dans la décennie
 *
 * Cache applicatif (Redis si dispo, mémoire sinon) — TTL 30 min.
 * Invalidation manuelle via router.invalidateCache() ou clé vdh:timeline:v1.
 */
const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const cache = require('../utils/cache');
const logger = require('../logger');
const timelineRepo = require('../repositories/timeline');

const CACHE_KEY = 'vdh:timeline:v1';
const CACHE_TTL_S = 30 * 60; // 30 minutes

module.exports = function createTimelineRouter(getPool) {
  const router = express.Router();

  router.get('/timeline', asyncHandler(async (req, res) => {
    const force = req.query.force === '1';

    if (!force) {
      try {
        const cached = await cache.get(CACHE_KEY);
        if (cached) {
          res.setHeader('X-Cache', 'HIT');
          return res.type('application/json').send(cached);
        }
      } catch (err) {
        logger.warn('timeline cache get failed', { error: err.message });
      }
    }

    const { events, aircraft } = await timelineRepo.loadTimeline(getPool());

    // Regroupement en structure par décennie.
    const decadeMap = new Map();
    const allDecades = [1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020];
    for (const d of allDecades) {
      decadeMap.set(d, { decade: d, events: [], aircraft: [] });
    }

    for (const row of events) {
      const bucket = decadeMap.get(row.era_decade);
      if (!bucket) continue; // défense : décennie inattendue
      bucket.events.push({
        id: row.id,
        event_date: row.event_date,
        kind: row.kind,
        title_fr: row.title_fr,
        title_en: row.title_en,
        body_fr: row.body_fr,
        body_en: row.body_en,
        quote_author_fr: row.quote_author_fr,
        quote_author_en: row.quote_author_en,
        airplane: row.airplane_id ? {
          id: row.airplane_id,
          name: row.airplane_name,
          name_en: row.airplane_name_en,
          image_url: row.airplane_image_url,
          little_description: row.airplane_little_description,
          little_description_en: row.airplane_little_description_en,
        } : null,
      });
    }

    for (const row of aircraft) {
      const bucket = decadeMap.get(Number(row.era_decade));
      if (!bucket) continue;
      bucket.aircraft.push({
        id: row.id,
        name: row.name,
        name_en: row.name_en,
        image_url: row.image_url,
        little_description: row.little_description,
        little_description_en: row.little_description_en,
        date_operationel: row.date_operationel,
        country_name: row.country_name,
        country_name_en: row.country_name_en,
        generation: row.generation,
        type_name: row.type_name,
        type_name_en: row.type_name_en,
      });
    }

    const payload = {
      generated_at: new Date().toISOString(),
      decades: Array.from(decadeMap.values()),
    };

    const json = JSON.stringify(payload);
    try {
      await cache.set(CACHE_KEY, json, CACHE_TTL_S);
    } catch (err) {
      logger.warn('timeline cache set failed', { error: err.message });
    }
    res.setHeader('X-Cache', 'MISS');
    res.type('application/json').send(json);
  }));

  // Invalidation exposée au module app (utilisée par les routes airplanes
  // quand une fiche est créée/modifiée/supprimée — la liste des appareils
  // par décennie peut changer).
  router.invalidateCache = async () => {
    try { await cache.del(CACHE_KEY); } catch { /* noop */ }
  };

  return router;
};
