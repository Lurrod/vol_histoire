/**
 * Route /api/hero/discoveries — données dynamiques des widgets de la home.
 *
 * Renvoie en un seul payload :
 *   - day       : date de référence (Europe/Paris, YYYY-MM-DD). Le client s'en
 *                 sert comme graine pour l'appareil du jour, afin que tous les
 *                 visiteurs voient le même quel que soit leur fuseau.
 *   - ephemeris : anniversaires du jour (premier vol / mise en service) pour le
 *                 widget « Ce jour-là ».
 *   - facts     : événements éditoriaux (timeline_events) liés à un appareil,
 *                 repli du widget « Ce jour-là » les jours sans anniversaire.
 *   - aircraft  : appareils avec image_url + generation + type, pour le widget
 *                 "Devine l'avion" (le client pioche 1 cible + 2 leurres).
 *
 * Cache applicatif (Redis si dispo, mémoire sinon) — TTL 10 min, **clé par
 * jour** : sans ça un cache posé à 23h55 servirait l'éphéméride de la veille.
 * Invalidation manuelle via router.invalidateCache() ou clé vdh:hero:v2:<jour>
 * (déclenchée par les routes airplanes quand une fiche change).
 */
const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const cache = require('../utils/cache');
const { todayInParis } = require('../utils/day');
const logger = require('../logger');
const heroRepo = require('../repositories/hero');

const CACHE_PREFIX = 'vdh:hero:v2';
const CACHE_TTL_S = 10 * 60; // 10 minutes

// Fenêtre de repli quand la date du jour ne porte aucun anniversaire.
// Sur les 434 fiches : 400 premiers vols au jour près (229 jours distincts) et
// 115 mises en service exploitables, soit 260 jours de l'année couverts. La plus
// longue série de jours vides étant de 4, une fenêtre de ±3 garantit toujours au
// moins un résultat. Le widget affiche alors « Cette semaine-là » plutôt que
// « Ce jour-là » — la date exacte étant de toute façon écrite dans la carte.
const DAY_WINDOW = 3;
const EPHEMERIS_LIMIT = 12;

const cacheKeyFor = (day) => `${CACHE_PREFIX}:${day}`;

module.exports = function createHeroRouter(getPool) {
  const router = express.Router();

  router.get('/hero/discoveries', asyncHandler(async (req, res) => {
    const force = req.query.force === '1';
    const day = todayInParis();
    const cacheKey = cacheKeyFor(day);

    if (!force) {
      try {
        const cached = await cache.get(cacheKey);
        if (cached) {
          res.setHeader('X-Cache', 'HIT');
          return res.type('application/json').send(cached);
        }
      } catch (err) {
        logger.warn('hero cache get failed', { error: err.message });
      }
    }

    // Requêtes et règles de l'éphéméride (année bissextile de référence,
    // dates au 1er du mois écartées) : voir repositories/hero.js.
    const { facts, aircraft, ephemeris } = await heroRepo.loadDiscoveries(getPool(), {
      day, windowDays: DAY_WINDOW, limit: EPHEMERIS_LIMIT,
    });

    const payload = {
      generated_at: new Date().toISOString(),
      day,
      facts: facts.map(r => ({
        year: r.year,
        title_fr: r.title_fr,
        title_en: r.title_en,
        airplane_id: r.airplane_id,
        airplane_name: r.airplane_name,
        airplane_name_en: r.airplane_name_en,
      })),
      aircraft: aircraft.map(r => ({
        id: r.id,
        name: r.name,
        name_en: r.name_en,
        image_url: r.image_url,
        generation: r.generation,
        type_name: r.type_name,
        type_name_en: r.type_name_en,
      })),
      ephemeris: ephemeris.map(r => ({
        kind: r.kind,
        day_gap: r.day_gap,
        event_date: r.event_date,
        year: r.year,
        airplane_id: r.airplane_id,
        airplane_name: r.airplane_name,
        airplane_name_en: r.airplane_name_en,
      })),
    };

    const json = JSON.stringify(payload);
    try {
      await cache.set(cacheKey, json, CACHE_TTL_S);
    } catch (err) {
      logger.warn('hero cache set failed', { error: err.message });
    }
    res.setHeader('X-Cache', 'MISS');
    res.type('application/json').send(json);
  }));

  router.invalidateCache = async () => {
    try { await cache.del(cacheKeyFor(todayInParis())); } catch { /* noop */ }
  };

  return router;
};
