'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — frise chronologique (GET /api/timeline, SSR /timeline).
// -----------------------------------------------------------------------------

// Événements éditoriaux ordonnés par décennie puis date ; LEFT JOIN airplanes
// pour hydrater la fiche liée si présente.
async function findEvents(db) {
  return (await db.query(`
      SELECT
        e.id,
        to_char(e.event_date, 'YYYY-MM-DD') AS event_date,
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

// Appareils placés sur la frise : à leur mise en service, ou, à défaut, à leur
// premier vol (prototypes, projets annulés : 123 fiches sur 554 n'avaient pas de
// mise en service et n'apparaissaient nulle part). `year_source` dit lequel.
// Un avion opérationnel en 1968 appartient à la décennie 1960.
async function findAircraft(db) {
  return (await db.query(`
      SELECT
        a.id,
        a.name,
        a.name_en,
        a.image_url,
        a.status,
        a.units_built,
        EXTRACT(YEAR FROM COALESCE(a.date_operationel, a.date_first_fly))::int AS year,
        CASE WHEN a.date_operationel IS NOT NULL THEN 'service' ELSE 'first_flight' END AS year_source,
        EXTRACT(YEAR FROM COALESCE(a.date_operationel, a.date_first_fly))::int / 10 * 10 AS era_decade,
        c.name    AS country_name,
        c.name_en AS country_name_en,
        g.generation,
        t.name    AS type_name,
        t.name_en AS type_name_en
      FROM airplanes a
      LEFT JOIN countries  c ON a.country_id    = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type       t ON a.type          = t.id
      WHERE COALESCE(a.date_operationel, a.date_first_fly) IS NOT NULL
      ORDER BY COALESCE(a.date_operationel, a.date_first_fly), a.id
    `)).rows;
}

// Conflits datés qui ont au moins un appareil rattaché (les autres n'ont pas
// de page /conflits/<slug>), avec les identifiants de ces appareils : la frise
// s'en sert pour n'afficher, sous un filtre, que les conflits concernés.
// Dates clés de la page du conflit (dépliant de la frise) : date en texte,
// comme les événements (un DATE lu en objet Date glisse d'un jour selon le
// fuseau), triées, liste vide pour un conflit non rédigé.
async function findWars(db) {
  return (await db.query(`
      SELECT
        w.id,
        w.name,
        w.name_en,
        to_char(w.date_start, 'YYYY-MM-DD') AS date_start,
        to_char(w.date_end, 'YYYY-MM-DD') AS date_end,
        array_agg(aw.id_airplane ORDER BY aw.id_airplane) AS aircraft_ids,
        COALESCE((
          SELECT json_agg(json_build_object(
                   'date', to_char(e.event_date, 'YYYY-MM-DD'), 'precision', e.date_precision,
                   'title', e.title, 'title_en', e.title_en)
                 ORDER BY e.event_date, e.id)
          FROM war_events e WHERE e.war_id = w.id
        ), '[]'::json) AS events
      FROM wars w
      JOIN airplane_wars aw ON aw.id_wars = w.id
      WHERE w.date_start IS NOT NULL
      GROUP BY w.id
      ORDER BY w.date_start, w.name
    `)).rows;
}

/** Événements, appareils et conflits, en parallèle. */
async function loadTimeline(db) {
  const [events, aircraft, wars] = await Promise.all([findEvents(db), findAircraft(db), findWars(db)]);
  return { events, aircraft, wars };
}

module.exports = { findEvents, findAircraft, findWars, loadTimeline };
