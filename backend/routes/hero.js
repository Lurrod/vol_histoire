/**
 * Route /api/hero/discoveries — données dynamiques des widgets de la home.
 *
 * Renvoie en un seul payload :
 *   - facts    : événements éditoriaux (timeline_events) liés à un appareil,
 *                pour le widget "Saviez-vous ?".
 *   - aircraft : appareils avec image_url + generation + type, pour le widget
 *                "Devine l'avion" (le client pioche 1 cible + 2 leurres).
 *
 * Cache applicatif (Redis si dispo, mémoire sinon) — TTL 10 min.
 * Invalidation manuelle via router.invalidateCache() ou clé vdh:hero:v1
 * (déclenchée par les routes airplanes quand une fiche change).
 */
const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const cache = require('../utils/cache');
const logger = require('../logger');

const CACHE_KEY = 'vdh:hero:v1';
const CACHE_TTL_S = 10 * 60; // 10 minutes

module.exports = function createHeroRouter(getPool) {
  const router = express.Router();

  router.get('/hero/discoveries', asyncHandler(async (req, res) => {
    const force = req.query.force === '1';

    if (!force) {
      try {
        const cached = await cache.get(CACHE_KEY);
        if (cached) {
          res.setHeader('X-Cache', 'HIT');
          return res.type('application/json').send(cached);
        }
      } catch (err) {
        logger.warn('hero cache get failed', { error: err.message });
      }
    }

    const pool = getPool();

    // Facts : on prend uniquement les événements liés à un appareil pour avoir
    // un lien "Voir la fiche" cohérent. Le titre (160 chars) sert de phrase
    // courte type "Saviez-vous?" — le body est trop long pour ce widget.
    const factsPromise = pool.query(`
      SELECT
        e.id,
        EXTRACT(YEAR FROM e.event_date)::int AS year,
        e.title_fr,
        e.title_en,
        a.id      AS airplane_id,
        a.name    AS airplane_name,
        a.name_en AS airplane_name_en
      FROM timeline_events e
      INNER JOIN airplanes a ON e.airplane_id = a.id
      ORDER BY e.event_date, e.id
    `);

    // Aircraft : seulement ceux ayant une image (sinon le quiz n'a rien à
    // afficher). On expose name + name_en + generation + type pour permettre
    // au client de piocher des leurres crédibles (même génération si possible).
    const aircraftPromise = pool.query(`
      SELECT
        a.id,
        a.name,
        a.name_en,
        a.image_url,
        g.generation,
        t.name    AS type_name,
        t.name_en AS type_name_en
      FROM airplanes a
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type       t ON a.type          = t.id
      WHERE a.image_url IS NOT NULL AND a.image_url <> ''
      ORDER BY a.id
    `);

    const [factsRes, aircraftRes] = await Promise.all([factsPromise, aircraftPromise]);

    const payload = {
      generated_at: new Date().toISOString(),
      facts: factsRes.rows.map(r => ({
        year: r.year,
        title_fr: r.title_fr,
        title_en: r.title_en,
        airplane_id: r.airplane_id,
        airplane_name: r.airplane_name,
        airplane_name_en: r.airplane_name_en,
      })),
      aircraft: aircraftRes.rows.map(r => ({
        id: r.id,
        name: r.name,
        name_en: r.name_en,
        image_url: r.image_url,
        generation: r.generation,
        type_name: r.type_name,
        type_name_en: r.type_name_en,
      })),
    };

    const json = JSON.stringify(payload);
    try {
      await cache.set(CACHE_KEY, json, CACHE_TTL_S);
    } catch (err) {
      logger.warn('hero cache set failed', { error: err.message });
    }
    res.setHeader('X-Cache', 'MISS');
    res.type('application/json').send(json);
  }));

  router.invalidateCache = async () => {
    try { await cache.del(CACHE_KEY); } catch { /* noop */ }
  };

  return router;
};
