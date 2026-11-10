'use strict';

/**
 * Requêtes du rendu serveur des pages de conflit (routes/conflicts-ssr.js).
 */

/**
 * Conflits auxquels au moins un appareil est rattaché — les seuls qui ont une
 * page. Chaque ligne porte aussi la photo d'un appareil engagé (le plus ancien
 * en service, à défaut le premier identifiant), qui sert d'image de partage.
 * Le slug n'existe pas en base : il est dérivé du nom par l'appelant.
 * @param {import('pg').Pool} pool
 * @returns {Promise<object[]>}
 */
async function listEngagedWars(pool) {
  const { rows } = await pool.query(`
    SELECT w.id, w.name, w.name_en, w.description, w.description_en,
           w.date_start, w.date_end, img.image_url
    FROM wars w
    LEFT JOIN LATERAL (
      SELECT a.image_url
      FROM airplane_wars aw
      JOIN airplanes a ON a.id = aw.id_airplane
      WHERE aw.id_wars = w.id AND a.image_url IS NOT NULL AND a.image_url <> ''
      ORDER BY a.date_operationel NULLS LAST, a.id
      LIMIT 1
    ) img ON true
    WHERE EXISTS (SELECT 1 FROM airplane_wars aw WHERE aw.id_wars = w.id)
  `);
  return rows;
}

module.exports = { listEngagedWars };
