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

const CACHE_PREFIX = 'vdh:hero:v2';
const CACHE_TTL_S = 10 * 60; // 10 minutes

// Fenêtre de repli quand la date du jour ne porte aucun anniversaire.
// Sur les 383 fiches : 359 premiers vols au jour près (220 jours distincts) et
// 107 mises en service exploitables, soit 253 jours de l'année couverts. La plus
// longue série de jours vides étant de 4, une fenêtre de ±3 garantit toujours au
// moins un résultat. Le widget affiche alors « Cette semaine-là » plutôt que
// « Ce jour-là » — la date exacte étant de toute façon écrite dans la carte.
const DAY_WINDOW = 3;
const EPHEMERIS_LIMIT = 12;

const cacheKeyFor = (day) => `${CACHE_PREFIX}:${day}`;

/**
 * Anniversaires proches de la date du jour.
 *
 * Les deux dates sont ramenées à une année commune (2001, non bissextile) pour
 * comparer des jours et non des années, et l'écart est circulaire : le 30
 * décembre est à 3 jours du 2 janvier.
 *
 * Les dates tombant le 1er du mois sont écartées, et ce n'est pas un détail :
 * 223 des 330 mises en service sont saisies au 1er du mois parce que la source
 * ne donne que le mois, et 21 premiers vols au 1er janvier parce qu'elle ne
 * donne que l'année. Les publier reviendrait à inventer un anniversaire précis
 * — exactement ce qu'une encyclopédie ne doit pas faire.
 *
 * DISTINCT ON : quelques fiches portent premier vol et mise en service à la même
 * date ; on n'en garde qu'une (premier vol, qui trie avant 'service').
 */
const EPHEMERIS_SQL = `
  WITH ref AS (
    SELECT to_date(to_char($1::date, 'MM-DD') || '-2001', 'MM-DD-YYYY') AS ref_day
  ),
  events AS (
    SELECT a.id, a.name, a.name_en, a.date_first_fly AS event_date, 'first_flight' AS kind
      FROM airplanes a
     WHERE a.date_first_fly IS NOT NULL
       AND to_char(a.date_first_fly, 'DD') <> '01'
    UNION ALL
    SELECT a.id, a.name, a.name_en, a.date_operationel AS event_date, 'service' AS kind
      FROM airplanes a
     WHERE a.date_operationel IS NOT NULL
       AND to_char(a.date_operationel, 'DD') <> '01'
  ),
  dedup AS (
    SELECT DISTINCT ON (id, event_date) id, name, name_en, event_date, kind
      FROM events
     ORDER BY id, event_date, kind
  ),
  scored AS (
    SELECT d.id, d.name, d.name_en, d.event_date, d.kind,
           LEAST(
             ABS(to_date(to_char(d.event_date, 'MM-DD') || '-2001', 'MM-DD-YYYY') - r.ref_day),
             365 - ABS(to_date(to_char(d.event_date, 'MM-DD') || '-2001', 'MM-DD-YYYY') - r.ref_day)
           ) AS day_gap
      FROM dedup d CROSS JOIN ref r
  )
  SELECT id AS airplane_id,
         name AS airplane_name,
         name_en AS airplane_name_en,
         kind,
         day_gap,
         to_char(event_date, 'YYYY-MM-DD') AS event_date,
         EXTRACT(YEAR FROM event_date)::int AS year
    FROM scored
   WHERE day_gap <= $2
   ORDER BY day_gap, event_date
   LIMIT $3
`;

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
    // ORDER BY a.id : l'ordre doit être stable, l'appareil du jour est un index
    // calculé sur cette liste.
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

    const ephemerisPromise = pool.query(EPHEMERIS_SQL, [day, DAY_WINDOW, EPHEMERIS_LIMIT]);

    const [factsRes, aircraftRes, ephemerisRes] = await Promise.all([
      factsPromise, aircraftPromise, ephemerisPromise,
    ]);

    const payload = {
      generated_at: new Date().toISOString(),
      day,
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
      ephemeris: ephemerisRes.rows.map(r => ({
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
