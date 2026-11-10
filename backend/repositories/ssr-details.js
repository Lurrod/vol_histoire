'use strict';

/**
 * Requêtes du rendu serveur des fiches (routes/details-ssr.js).
 * Fonctions pures : elles reçoivent le pool et renvoient des lignes, sans
 * rien savoir de HTTP ni du HTML produit.
 */

/**
 * Appareil et libellés de référentiel nécessaires aux balises de tête et au
 * JSON-LD de la fiche, dans les deux langues.
 * @param {import('pg').Pool} pool
 * @param {number} id
 * @returns {Promise<object|null>}
 */
async function findAircraftForSsr(pool, id) {
  const { rows } = await pool.query(
    `SELECT a.id, a.name, a.name_en, a.complete_name, a.complete_name_en,
            a.little_description, a.little_description_en,
            a.description, a.description_en,
            a.image_url, a.max_speed, a.max_range, a.empty_weight,
            a.date_operationel, a.date_first_fly,
            a.created_at, a.updated_at,
            c.name AS country_name, c.name_en AS country_name_en, c.code AS country_code,
            g.generation, t.name AS type_name, t.name_en AS type_name_en,
            m.name AS manufacturer_name
     FROM airplanes a
     LEFT JOIN countries c ON a.country_id = c.id
     LEFT JOIN generation g ON a.id_generation = g.id
     LEFT JOIN type t ON a.type = t.id
     LEFT JOIN manufacturer m ON a.id_manufacturer = m.id
     WHERE a.id = $1`,
    [id]
  );
  return rows[0] || null;
}

module.exports = { findAircraftForSsr };
