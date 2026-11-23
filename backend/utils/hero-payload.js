'use strict';

/**
 * Charge utile du hero de l'accueil (GET /api/hero/discoveries et photo du
 * jour écrite par le serveur dans index.html).
 *
 *   { generated_at, day, facts: [...], aircraft: [...], ephemeris: [...] }
 *
 *   - day       : date de référence (Europe/Paris, YYYY-MM-DD), graine de
 *                 l'appareil du jour : tous les visiteurs voient le même.
 *   - ephemeris : anniversaires du jour (premier vol / mise en service).
 *   - facts     : événements éditoriaux liés à un appareil (repli).
 *   - aircraft  : appareils avec photo pour le quiz.
 *
 * Mise en cache (Redis si disponible, mémoire sinon) 10 min, **clé par
 * jour** : un cache posé à 23 h 55 servirait sinon l'éphéméride de la veille.
 */
const cache = require('./cache');
const logger = require('../logger');
const { todayInParis } = require('./day');
const heroRepo = require('../repositories/hero');

// v3 : l'éphéméride porte la photo de l'appareil (accueil v4.17).
const CACHE_PREFIX = 'vdh:hero:v3';
const CACHE_TTL_S = 10 * 60;

// Fenêtre de repli quand la date du jour ne porte aucun anniversaire : la plus
// longue série de jours vides étant de 4, ±3 jours garantit toujours au moins
// un résultat (le widget dit alors « Cette semaine-là »).
const DAY_WINDOW = 3;
const EPHEMERIS_LIMIT = 12;

const cacheKeyFor = (day) => `${CACHE_PREFIX}:${day}`;

function buildPayload(day, { facts, aircraft, ephemeris }) {
  return {
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
      image_url: r.image_url,
      image_credit: r.image_credit,
      image_licence: r.image_licence,
    })),
  };
}

/**
 * JSON de la charge utile du jour ; `hit` vaut true s'il vient du cache.
 * Une panne du cache n'empêche jamais la réponse (lecture en base).
 */
async function loadPayloadJson(pool, { force = false } = {}) {
  const day = todayInParis();
  const cacheKey = cacheKeyFor(day);
  if (!force) {
    try {
      const cached = await cache.get(cacheKey);
      if (cached) return { json: cached, hit: true };
    } catch (err) {
      logger.warn('hero cache get failed', { error: err.message });
    }
  }
  // Requêtes et règles de l'éphéméride (année bissextile de référence,
  // dates au 1er du mois écartées) : voir repositories/hero.js.
  const rows = await heroRepo.loadDiscoveries(pool, { day, windowDays: DAY_WINDOW, limit: EPHEMERIS_LIMIT });
  const json = JSON.stringify(buildPayload(day, rows));
  try {
    await cache.set(cacheKey, json, CACHE_TTL_S);
  } catch (err) {
    logger.warn('hero cache set failed', { error: err.message });
  }
  return { json, hit: false };
}

async function invalidate() {
  await cache.del(cacheKeyFor(todayInParis()));
}

module.exports = { loadPayloadJson, buildPayload, invalidate, cacheKeyFor, CACHE_PREFIX, DAY_WINDOW, EPHEMERIS_LIMIT };
