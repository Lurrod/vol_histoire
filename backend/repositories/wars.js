'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — conflits (table wars et liaison airplane_wars).
// -----------------------------------------------------------------------------

/** Tous les conflits, avec leur nombre d'appareils rattachés (0 compris). */
async function listWithCounts(db) {
  return (await db.query(`
      SELECT w.id, w.name, w.name_en, w.date_start, w.date_end,
             w.description, w.description_en,
             COUNT(aw.id_airplane)::int AS count
      FROM wars w
      LEFT JOIN airplane_wars aw ON aw.id_wars = w.id
      GROUP BY w.id
      ORDER BY w.date_start ASC NULLS LAST, w.name ASC
    `)).rows;
}

/** Appareils d'un conflit (avec leur camp et leur rôle), du premier vol le plus ancien au plus récent. */
async function findAirplanes(db, warId) {
  return (await db.query(`
      SELECT a.id, a.name, a.name_en, a.little_description, a.little_description_en,
             a.image_url, a.date_first_fly, a.date_operationel,
             c.code AS country_code, c.name AS country_name, c.name_en AS country_name_en,
             t.name AS type_name, t.name_en AS type_name_en, g.generation,
             s.side_key, aw.role, aw.role_en, aw.sources AS role_sources
      FROM airplane_wars aw
      JOIN airplanes a ON a.id = aw.id_airplane
      LEFT JOIN war_sides s ON s.id = aw.side_id
      LEFT JOIN countries c ON c.id = a.country_id
      LEFT JOIN type t ON t.id = a.type
      LEFT JOIN generation g ON g.id = a.id_generation
      WHERE aw.id_wars = $1
      ORDER BY a.date_first_fly ASC NULLS LAST, a.name ASC
    `, [warId])).rows;
}

/** Contenu de la page d'un conflit : issue, contexte, récit aérien, sources. */
async function findContent(db, warId) {
  return (await db.query(`
      SELECT outcome, outcome_en, context, context_en, narrative, narrative_en, sources
      FROM wars WHERE id = $1
    `, [warId])).rows[0] || null;
}

/** Camps du conflit, dans l'ordre d'affichage. */
async function findSides(db, warId) {
  return (await db.query(`
      SELECT side_key, name, name_en, members, members_en
      FROM war_sides WHERE war_id = $1
      ORDER BY position ASC, id ASC
    `, [warId])).rows;
}

/** Dates clés du conflit. La date part en texte (AAAA-MM-JJ) : un objet Date
 *  passé en JSON serait décalé d'un jour par le fuseau du serveur. */
async function findEvents(db, warId) {
  return (await db.query(`
      SELECT to_char(e.event_date, 'YYYY-MM-DD') AS date, e.date_precision AS precision,
             e.title, e.title_en, e.body, e.body_en, e.source,
             a.id AS airplane_id, a.name AS airplane_name, a.name_en AS airplane_name_en
      FROM war_events e
      LEFT JOIN airplanes a ON a.id = e.airplane_id
      WHERE e.war_id = $1
      ORDER BY e.event_date ASC, e.id ASC
    `, [warId])).rows;
}

/** Noms des conflits rattachés à au moins un appareil (une page chacun) — sitemap. */
async function listLinkedNames(db) {
  const result = await db.query(`SELECT w.name FROM wars w
                WHERE EXISTS (SELECT 1 FROM airplane_wars aw WHERE aw.id_wars = w.id)
                ORDER BY w.date_start ASC NULLS LAST, w.name ASC`);
  // Tolère un résultat vide : le sitemap se construit alors sans pages de conflit.
  return (result && result.rows) || [];
}

module.exports = { listWithCounts, findAirplanes, findContent, findSides, findEvents, listLinkedNames };
