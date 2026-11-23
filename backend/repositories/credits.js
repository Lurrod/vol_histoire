'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — crédits photo (auteur et licence de l'image de chaque fiche).
// -----------------------------------------------------------------------------

/** Toutes les fiches avec leur photo, son auteur et sa licence, par nom. */
async function listImageCredits(db) {
  return (await db.query(`
      SELECT id, name, name_en, image_url, image_credit, image_licence
      FROM airplanes
      ORDER BY name ASC
    `)).rows;
}

module.exports = { listImageCredits };
