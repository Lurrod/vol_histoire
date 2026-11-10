'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — référentiels (pays, générations, types, constructeurs,
// conflits et missions vus du hangar). Lignes brutes ; la traduction et les
// clés dérivées (name_fr, slug) sont ajoutées par routes/airplanes.js.
// -----------------------------------------------------------------------------

/** Pays ayant au moins une fiche. */
async function listCountriesWithAirplanes(db) {
  return (await db.query(
    'SELECT id, name, name_en FROM countries WHERE id IN (SELECT DISTINCT country_id FROM airplanes WHERE country_id IS NOT NULL) ORDER BY name ASC'
  )).rows;
}

/** Nations de conception et nombre de fiches (carte de l'accueil). */
async function listNations(db) {
  return (await db.query(
    `SELECT c.code, c.name, c.name_en, COUNT(a.id)::int AS count
     FROM countries c
     JOIN airplanes a ON a.country_id = c.id
     GROUP BY c.code, c.name, c.name_en
     ORDER BY count DESC, c.name ASC`
  )).rows;
}

async function listGenerations(db) {
  return (await db.query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC')).rows;
}

async function listTypes(db) {
  return (await db.query(
    'SELECT id, name, name_en, description, description_en FROM type ORDER BY name ASC'
  )).rows;
}

async function listManufacturers(db) {
  return (await db.query(`
      SELECT m.id, m.name, m.name_en, m.code, m.country_id,
             c.name AS country_name, c.name_en AS country_name_en
      FROM manufacturer m
      JOIN countries c ON m.country_id = c.id
      ORDER BY m.name ASC
    `)).rows;
}

/** Conflits rattachés à au moins un appareil, par date de début. */
async function listLinkedWars(db) {
  return (await db.query(`
        SELECT w.name, w.name_en, w.date_start, w.date_end
        FROM wars w
        WHERE EXISTS (SELECT 1 FROM airplane_wars aw WHERE aw.id_wars = w.id)
        ORDER BY w.date_start ASC, w.name ASC
      `)).rows;
}

/** Missions rattachées à au moins un appareil. */
async function listLinkedMissions(db) {
  return (await db.query(`
        SELECT m.name, m.name_en
        FROM missions m
        WHERE EXISTS (SELECT 1 FROM airplane_missions am WHERE am.id_mission = m.id)
        ORDER BY m.name ASC
      `)).rows;
}

/** Les six référentiels du hangar en parallèle (GET /referentials). */
async function loadAll(db) {
  const [countries, generations, types, manufacturers, wars, missions] = await Promise.all([
    listCountriesWithAirplanes(db),
    listGenerations(db),
    listTypes(db),
    listManufacturers(db),
    listLinkedWars(db),
    listLinkedMissions(db),
  ]);
  return { countries, generations, types, manufacturers, wars, missions };
}

module.exports = {
  listCountriesWithAirplanes,
  listNations,
  listGenerations,
  listTypes,
  listManufacturers,
  listLinkedWars,
  listLinkedMissions,
  loadAll,
};
