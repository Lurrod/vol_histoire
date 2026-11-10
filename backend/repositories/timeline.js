'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — frise chronologique (GET /api/timeline).
// -----------------------------------------------------------------------------

// Événements éditoriaux ordonnés par décennie puis date ; LEFT JOIN airplanes
// pour hydrater la fiche liée si présente.
async function findEvents(db) {
  return (await db.query(`
      SELECT
        e.id,
        e.event_date,
        e.era_decade,
        e.kind,
        e.title_fr,
        e.title_en,
        e.body_fr,
        e.body_en,
        e.quote_author_fr,
        e.quote_author_en,
        a.id             AS airplane_id,
        a.name           AS airplane_name,
        a.name_en        AS airplane_name_en,
        a.image_url      AS airplane_image_url,
        a.little_description AS airplane_little_description,
        a.little_description_en AS airplane_little_description_en
      FROM timeline_events e
      LEFT JOIN airplanes a ON e.airplane_id = a.id
      ORDER BY e.era_decade, e.event_date, e.id
    `)).rows;
}

// Appareils en service, avec leur décennie : un avion opérationnel en 1968
// appartient à la décennie 1960.
async function findAircraftByDecade(db) {
  return (await db.query(`
      SELECT
        a.id,
        a.name,
        a.name_en,
        a.image_url,
        a.little_description,
        a.little_description_en,
        a.date_operationel,
        EXTRACT(YEAR FROM a.date_operationel)::int / 10 * 10 AS era_decade,
        c.name    AS country_name,
        c.name_en AS country_name_en,
        g.generation,
        t.name    AS type_name,
        t.name_en AS type_name_en
      FROM airplanes a
      LEFT JOIN countries  c ON a.country_id    = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type       t ON a.type          = t.id
      WHERE a.date_operationel IS NOT NULL
      ORDER BY a.date_operationel, a.id
    `)).rows;
}

/** Événements et appareils, en parallèle. */
async function loadTimeline(db) {
  const [events, aircraft] = await Promise.all([findEvents(db), findAircraftByDecade(db)]);
  return { events, aircraft };
}

module.exports = { findEvents, findAircraftByDecade, loadTimeline };
