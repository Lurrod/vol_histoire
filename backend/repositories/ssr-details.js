'use strict';

/**
 * Requêtes du rendu serveur des fiches (routes/details-ssr.js).
 * Fonctions pures : elles reçoivent le pool et renvoient des lignes, sans
 * rien savoir de HTTP ni du HTML produit.
 */

/**
 * Appareil et libellés de référentiel nécessaires aux balises de tête, au
 * JSON-LD et au corps de la fiche (récit, appareils liés), dans les deux
 * langues.
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
            a.date_operationel, a.date_first_fly, a.status, a.status_en,
            a.created_at, a.updated_at,
            c.name AS country_name, c.name_en AS country_name_en, c.code AS country_code,
            g.generation, t.name AS type_name, t.name_en AS type_name_en,
            m.name AS manufacturer_name, m.name_en AS manufacturer_name_en,
            pre.id AS predecessor_id, pre.name AS predecessor_name, pre.name_en AS predecessor_name_en, pre.image_url AS predecessor_image,
            suc.id AS successor_id, suc.name AS successor_name, suc.name_en AS successor_name_en, suc.image_url AS successor_image,
            riv.id AS rival_id, riv.name AS rival_name, riv.name_en AS rival_name_en, riv.image_url AS rival_image
     FROM airplanes a
     LEFT JOIN countries c ON a.country_id = c.id
     LEFT JOIN generation g ON a.id_generation = g.id
     LEFT JOIN type t ON a.type = t.id
     LEFT JOIN manufacturer m ON a.id_manufacturer = m.id
     -- Appareils liés, écrits en liens dans la fiche (SEO-001).
     LEFT JOIN airplanes pre ON a.predecessor_id = pre.id
     LEFT JOIN airplanes suc ON a.successor_id = suc.id
     LEFT JOIN airplanes riv ON a.rival_id = riv.id
     WHERE a.id = $1`,
    [id]
  );
  return rows[0] || null;
}

module.exports = { findAircraftForSsr };
