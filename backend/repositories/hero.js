'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — widgets de l'accueil (GET /api/hero/discoveries).
// -----------------------------------------------------------------------------

/**
 * Anniversaires proches d'une date.
 *
 * Les deux dates sont ramenées à une année commune pour comparer des jours et
 * non des années, et l'écart est circulaire : le 30 décembre est à 3 jours du
 * 2 janvier. Cette année est **bissextile** (2000) : sur une année commune, le
 * 29 février n'existe pas et la conversion lève une erreur. C'était le cas avec
 * 2001 — le premier vol du MiG 1.44 (29/02/2000) faisait tomber la route en 500
 * tous les jours. Contrepartie assumée : entre le 28 février et le 1er mars,
 * l'écart compte un jour de trop les années communes, ce que la fenêtre de
 * ±3 jours absorbe.
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
    SELECT make_date(2000, EXTRACT(MONTH FROM $1::date)::int, EXTRACT(DAY FROM $1::date)::int) AS ref_day
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
  gaps AS (
    SELECT d.id, d.name, d.name_en, d.event_date, d.kind,
           make_date(2000, EXTRACT(MONTH FROM d.event_date)::int, EXTRACT(DAY FROM d.event_date)::int)
             - r.ref_day AS raw_gap
      FROM dedup d CROSS JOIN ref r
  ),
  scored AS (
    SELECT id, name, name_en, event_date, kind,
           LEAST(ABS(raw_gap), 366 - ABS(raw_gap)) AS day_gap
      FROM gaps
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

/**
 * @param {string} day date de référence AAAA-MM-JJ
 * @param {number} windowDays écart maximal en jours
 * @param {number} limit nombre maximal de lignes
 */
async function findEphemeris(db, day, windowDays, limit) {
  return (await db.query(EPHEMERIS_SQL, [day, windowDays, limit])).rows;
}

// Événements éditoriaux liés à un appareil (lien « Voir la fiche » cohérent).
// Le titre (160 caractères) sert de phrase courte ; le corps est trop long
// pour ce widget.
async function findLinkedFacts(db) {
  return (await db.query(`
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
    `)).rows;
}

// Appareils illustrés, pour le quiz : génération et type permettent de piocher
// des leurres crédibles. ORDER BY a.id : l'ordre doit être stable.
async function findQuizAircraft(db) {
  return (await db.query(`
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
    `)).rows;
}

/** Les trois jeux de données du payload, en parallèle. */
async function loadDiscoveries(db, { day, windowDays, limit }) {
  const [facts, aircraft, ephemeris] = await Promise.all([
    findLinkedFacts(db),
    findQuizAircraft(db),
    findEphemeris(db, day, windowDays, limit),
  ]);
  return { facts, aircraft, ephemeris };
}

module.exports = {
  EPHEMERIS_SQL,
  findEphemeris,
  findLinkedFacts,
  findQuizAircraft,
  loadDiscoveries,
};
