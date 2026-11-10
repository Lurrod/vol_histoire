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

/** Appareils d'un conflit, du premier vol le plus ancien au plus récent. */
async function findAirplanes(db, warId) {
  return (await db.query(`
      SELECT a.id, a.name, a.name_en, a.little_description, a.little_description_en,
             a.image_url, a.date_first_fly, a.date_operationel,
             c.code AS country_code, c.name AS country_name, c.name_en AS country_name_en,
             t.name AS type_name, t.name_en AS type_name_en, g.generation
      FROM airplane_wars aw
      JOIN airplanes a ON a.id = aw.id_airplane
      LEFT JOIN countries c ON c.id = a.country_id
      LEFT JOIN type t ON t.id = a.type
      LEFT JOIN generation g ON g.id = a.id_generation
      WHERE aw.id_wars = $1
      ORDER BY a.date_first_fly ASC NULLS LAST, a.name ASC
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

module.exports = { listWithCounts, findAirplanes, listLinkedNames };
