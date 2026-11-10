'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — favoris (table favorites).
// -----------------------------------------------------------------------------

/** Favoris d'un utilisateur, du plus récent au plus ancien, avec la fiche. */
async function listForUser(db, userId) {
  return (await db.query(
    `SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url,
            a.max_speed, a.date_operationel,
            c.name AS country_name, c.name_en AS country_name_en, c.code AS country_code,
            g.generation, t.name AS type_name, t.name_en AS type_name_en,
            f.created_at AS favorited_at
     FROM favorites f
     JOIN airplanes a ON f.airplane_id = a.id
     LEFT JOIN countries c ON a.country_id = c.id
     LEFT JOIN generation g ON a.id_generation = g.id
     LEFT JOIN type t ON a.type = t.id
     WHERE f.user_id = $1
     ORDER BY f.created_at DESC`,
    [userId]
  )).rows;
}

/** Favoris pour l'export des données (LEGAL-011), du plus ancien au plus récent. */
async function listForExport(db, userId) {
  return (await db.query(
    `SELECT f.airplane_id, a.name, f.created_at AS added_at
     FROM favorites f
     JOIN airplanes a ON a.id = f.airplane_id
     WHERE f.user_id = $1
     ORDER BY f.created_at, f.airplane_id`,
    [userId]
  )).rows;
}

async function exists(db, userId, airplaneId) {
  const result = await db.query(
    'SELECT 1 FROM favorites WHERE user_id = $1 AND airplane_id = $2',
    [userId, airplaneId]
  );
  return result.rows.length > 0;
}

/**
 * Ajoute un favori (sans effet s'il existe déjà).
 * @throws erreur PostgreSQL 23503 si l'appareil n'existe pas
 */
async function add(db, userId, airplaneId) {
  await db.query(
    'INSERT INTO favorites (user_id, airplane_id) VALUES ($1, $2) ON CONFLICT (user_id, airplane_id) DO NOTHING',
    [userId, airplaneId]
  );
}

/** @returns {Promise<boolean>} true si un favori a été retiré */
async function remove(db, userId, airplaneId) {
  const result = await db.query(
    'DELETE FROM favorites WHERE user_id = $1 AND airplane_id = $2',
    [userId, airplaneId]
  );
  return result.rowCount !== 0;
}

module.exports = { listForUser, listForExport, exists, add, remove };
