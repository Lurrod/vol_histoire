'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — crédits photo (auteur et licence de l'image de chaque fiche).
// -----------------------------------------------------------------------------

/** Toutes les fiches avec l'auteur et la licence de leur photo, par nom. */
async function listImageCredits(db) {
  return (await db.query(`
      SELECT id, name, name_en, image_credit, image_licence
      FROM airplanes
      ORDER BY name ASC
    `)).rows;
}

module.exports = { listImageCredits };
