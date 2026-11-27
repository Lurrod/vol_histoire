'use strict';

/**
 * Charge utile de la frise (GET /api/timeline et rendu serveur de /timeline).
 *
 *   {
 *     generated_at,
 *     decades: [{ decade, events: [...], aircraft: [...] }],   // 1940 → 2020
 *     wars:    [{ id, slug, name, name_en, start_year, end_year, era_decade, aircraft_ids,
 *                events: [{ date, precision, title, title_en }] }]
 *   }
 *
 * Mise en cache (Redis si disponible, mémoire sinon) 30 min ; la clé change
 * avec la forme de la charge utile.
 */
const cache = require('./cache');
const logger = require('../logger');
const { slugify } = require('./url');
const timelineRepo = require('../repositories/timeline');

const CACHE_KEY = 'vdh:timeline:v3';
const CACHE_TTL_S = 30 * 60;
const DECADES = Object.freeze([1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020]);

// Année d'une date PostgreSQL (« AAAA-MM-JJ » ou objet Date).
const { yearOf } = require('./calendar-date');

function toEvent(row) {
  return {
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
  };
}

function toAircraft(row) {
  return {
    id: row.id,
    name: row.name,
    name_en: row.name_en,
    image_url: row.image_url,
    year: Number(row.year),
    year_source: row.year_source === 'first_flight' ? 'first_flight' : 'service',
    status: row.status || null,
    units_built: row.units_built === null || row.units_built === undefined ? null : Number(row.units_built),
    country_name: row.country_name,
    country_name_en: row.country_name_en,
    generation: row.generation,
    type_name: row.type_name,
    type_name_en: row.type_name_en,
  };
}

function toWar(row) {
  const start = yearOf(row.date_start);
  return {
    id: row.id,
    slug: slugify(row.name),
    name: row.name,
    name_en: row.name_en,
    start_year: start,
    end_year: yearOf(row.date_end),
    era_decade: Math.floor(start / 10) * 10,
    aircraft_ids: (row.aircraft_ids || []).map(Number),
    events: (Array.isArray(row.events) ? row.events : []).map(e => ({
      date: e.date, precision: e.precision, title: e.title, title_en: e.title_en,
    })),
  };
}

/**
 * Regroupe les lignes du dépôt par décennie. Une ligne hors des décennies
 * couvertes (avant 1940) est ignorée.
 * @param {{ events: object[], aircraft: object[], wars?: object[] }} rows
 */
function buildPayload({ events, aircraft, wars = [] }) {
  const byDecade = new Map(DECADES.map(d => [d, { decade: d, events: [], aircraft: [] }]));
  for (const row of events) {
    const bucket = byDecade.get(Number(row.era_decade));
    if (bucket) bucket.events.push(toEvent(row));
  }
  for (const row of aircraft) {
    const bucket = byDecade.get(Number(row.era_decade));
    if (bucket) bucket.aircraft.push(toAircraft(row));
  }
  return {
    generated_at: new Date().toISOString(),
    decades: Array.from(byDecade.values()),
    wars: wars.map(toWar).filter(w => w.start_year !== null && byDecade.has(w.era_decade)),
  };
}

/**
 * Charge utile sérialisée, depuis le cache ou la base.
 * @param {import('pg').Pool} pool
 * @param {{ force?: boolean }} [opts]
 * @returns {Promise<{ json: string, hit: boolean }>}
 */
async function loadPayloadJson(pool, { force = false } = {}) {
  if (!force) {
    try {
      const cached = await cache.get(CACHE_KEY);
      if (cached) return { json: cached, hit: true };
    } catch (err) {
      logger.warn('timeline cache get failed', { error: err.message });
    }
  }
  const json = JSON.stringify(buildPayload(await timelineRepo.loadTimeline(pool)));
  try {
    await cache.set(CACHE_KEY, json, CACHE_TTL_S);
  } catch (err) {
    logger.warn('timeline cache set failed', { error: err.message });
  }
  return { json, hit: false };
}

async function invalidate() {
  // cache.del journalise et retente lui-même un échec Redis (JS-005).
  await cache.del(CACHE_KEY);
}

module.exports = { CACHE_KEY, DECADES, yearOf, buildPayload, loadPayloadJson, invalidate };
