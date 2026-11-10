'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — appareils (table airplanes et ses liaisons).
//
// Chaque fonction reçoit `db` (le pool, ou un client de transaction) et renvoie
// des lignes brutes : la validation HTTP, la traduction (pickLang) et la forme
// de la réponse restent dans routes/airplanes.js. SQL paramétré uniquement.
// -----------------------------------------------------------------------------

const { prefixTsquery } = require('../utils/search');
const { AIRPLANE_COLUMNS, toDbValue, toDbValues, presentFields } = require('../utils/airplane-fields');

const LIST_COLUMNS = `
      SELECT a.id, a.name, a.name_en, a.complete_name, a.complete_name_en,
             a.little_description, a.little_description_en, a.image_url,
             a.max_speed, c.name as country_name, c.name_en as country_name_en,
             c.code as country_code,
             g.generation, t.name as type_name, t.name_en as type_name_en,
             a.date_operationel
      FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id
    `;

const COUNT_FROM = `SELECT COUNT(*) FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id`;

// Whitelist stricte du tri : seule une clé propre de l'objet choisit une
// expression SQL (Object.hasOwn : « constructor » ou « __proto__ » ne doivent
// pas remonter le prototype jusque dans la requête).
const SORT_SQL = Object.freeze({
  'nation': 'c.name ASC',
  'service-date': 'a.date_operationel DESC',
  'alphabetical': 'a.name ASC',
  'generation': 'g.generation DESC',
  'type': 't.name ASC',
});

/**
 * Conditions WHERE de la liste du hangar (filtres combinés en AND).
 * @returns {{ conditions: string[], params: Array, tsquerySql: string|null }}
 */
function buildListFilters({ country, generation, type, war, mission, search }) {
  const params = [];
  const conditions = [];

  if (country) {
    params.push(country);
    conditions.push(`c.name = $${params.length}`);
  }
  if (generation) {
    params.push(Number(generation));
    conditions.push(`g.generation = $${params.length}`);
  }
  if (type) {
    params.push(type);
    conditions.push(`t.name = $${params.length}`);
  }
  if (war) {
    params.push(war);
    conditions.push(`EXISTS (SELECT 1 FROM airplane_wars aw JOIN wars w ON w.id = aw.id_wars
        WHERE aw.id_airplane = a.id AND w.name = $${params.length})`);
  }
  if (mission) {
    params.push(mission);
    conditions.push(`EXISTS (SELECT 1 FROM airplane_missions am JOIN missions m ON m.id = am.id_mission
        WHERE am.id_airplane = a.id AND m.name = $${params.length})`);
  }

  // Plein texte sur search_vector (tsvector généré côté base).
  // websearch_to_tsquery accepte "F-16 chasseur", "rafale -mirage", "\"exact phrase\"" ;
  // on y ajoute en OU la variante « préfixe » (dernier mot incomplet : « mira »
  // trouve le Mirage) ; voir utils/search.js.
  let tsquerySql = null;
  if (search) {
    params.push(search);
    tsquerySql = `websearch_to_tsquery('simple', $${params.length})`;
    const prefix = prefixTsquery(search);
    if (prefix) {
      params.push(prefix);
      tsquerySql = `(${tsquerySql} || to_tsquery('simple', $${params.length}))`;
    }
    conditions.push(`a.search_vector @@ ${tsquerySql}`);
  }

  return { conditions, params, tsquerySql };
}

/**
 * Page de la liste du hangar et total avant pagination (deux requêtes, comptage
 * d'abord). Les valeurs de filtre doivent avoir été validées par l'appelant.
 * @param {object} filters { country, generation, type, war, mission, search, sort, limit, offset }
 * @returns {Promise<{ total: number, rows: object[] }>}
 */
async function findPage(db, filters) {
  const { conditions, params, tsquerySql } = buildListFilters(filters);
  const where = conditions.length > 0 ? ' WHERE ' + conditions.join(' AND ') : '';

  // Avec une recherche, tri par pertinence (ts_rank) ; sinon le tri demandé.
  const orderBy = tsquerySql
    ? ` ORDER BY ts_rank(a.search_vector, ${tsquerySql}) DESC, a.id ASC`
    : ' ORDER BY ' + (Object.hasOwn(SORT_SQL, filters.sort) ? SORT_SQL[filters.sort] : 'a.id ASC');

  const countResult = await db.query(COUNT_FROM + where, params);
  const total = parseInt(countResult.rows[0].count, 10);

  const listParams = [...params, filters.limit, filters.offset];
  const result = await db.query(
    LIST_COLUMNS + where + orderBy + ` LIMIT $${listParams.length - 1} OFFSET $${listParams.length}`,
    listParams
  );
  return { total, rows: result.rows };
}

/** Valeurs admises par les filtres generation / type / war / mission. */
async function loadFilterValues(db) {
  const [gens, types, wars, missions] = await Promise.all([
    db.query('SELECT DISTINCT generation FROM generation'),
    db.query('SELECT name FROM type'),
    db.query('SELECT name FROM wars'),
    db.query('SELECT name FROM missions'),
  ]);
  return {
    generations: gens.rows.map((r) => Number(r.generation)),
    typeNames: types.rows.map((r) => r.name),
    warNames: wars.rows.map((r) => r.name),
    missionNames: missions.rows.map((r) => r.name),
  };
}

/** Fiche complète avec ses jointures (constructeur, génération, filiation…). */
async function findById(db, id) {
  const result = await db.query(
    `SELECT airplanes.*,
            manufacturer.name AS manufacturer_name, manufacturer.name_en AS manufacturer_name_en,
            generation.generation,
            generation.description AS generation_description, generation.description_en AS generation_description_en,
            type.name AS type_name, type.name_en AS type_name_en,
            countries.name AS country_name, countries.name_en AS country_name_en,
            predecessor.name AS predecessor_name, predecessor.name_en AS predecessor_name_en, predecessor.image_url AS predecessor_image,
            successor.name AS successor_name, successor.name_en AS successor_name_en, successor.image_url AS successor_image,
            rival.name AS rival_name, rival.name_en AS rival_name_en, rival.image_url AS rival_image
     FROM airplanes
     LEFT JOIN manufacturer ON airplanes.id_manufacturer = manufacturer.id
     LEFT JOIN generation ON airplanes.id_generation = generation.id
     LEFT JOIN type ON airplanes.type = type.id
     LEFT JOIN countries ON airplanes.country_id = countries.id
     LEFT JOIN airplanes predecessor ON airplanes.predecessor_id = predecessor.id
     LEFT JOIN airplanes successor ON airplanes.successor_id = successor.id
     LEFT JOIN airplanes rival ON airplanes.rival_id = rival.id
     WHERE airplanes.id = $1`,
    [id]
  );
  return result.rows[0] || null;
}

// --- Liaisons n-n -------------------------------------------------------------

const ARMAMENT_SQL = `SELECT armement.name, armement.name_en, armement.description, armement.description_en
     FROM airplane_armement
     JOIN armement ON airplane_armement.id_armement = armement.id
     WHERE airplane_armement.id_airplane = $1`;

const TECH_SQL = `SELECT t.name, t.name_en, t.description, t.description_en
     FROM airplane_tech at
     JOIN tech t ON at.id_tech = t.id
     WHERE at.id_airplane = $1`;

const MISSIONS_SQL = `SELECT missions.name, missions.name_en, missions.description, missions.description_en
     FROM airplane_missions
     JOIN missions ON airplane_missions.id_mission = missions.id
     WHERE airplane_missions.id_airplane = $1`;

const WARS_SQL = `SELECT wars.name, wars.name_en, wars.date_start, wars.date_end, wars.description, wars.description_en
     FROM airplane_wars
     JOIN wars ON airplane_wars.id_wars = wars.id
     WHERE airplane_wars.id_airplane = $1`;

async function findArmament(db, id) {
  return (await db.query(ARMAMENT_SQL, [id])).rows;
}

async function findTech(db, id) {
  return (await db.query(TECH_SQL, [id])).rows;
}

async function findMissions(db, id) {
  return (await db.query(MISSIONS_SQL, [id])).rows;
}

/** @param {{ ordered?: boolean }} [opts] ordered : conflits triés par date de début */
async function findWars(db, id, { ordered = false } = {}) {
  return (await db.query(ordered ? `${WARS_SQL}\n     ORDER BY wars.date_start` : WARS_SQL, [id])).rows;
}

/** Les quatre liaisons d'un appareil, en parallèle. */
async function findRelated(db, id) {
  const [armament, tech, missions, wars] = await Promise.all([
    findArmament(db, id),
    findTech(db, id),
    findMissions(db, id),
    findWars(db, id, { ordered: true }),
  ]);
  return { armament, tech, missions, wars };
}

// --- Filiation ----------------------------------------------------------------

/**
 * Chaîne predecessor → … → appareil → … → successor.
 *
 * Les colonnes predecessor_id / successor_id ne portent qu'un maillon chacune ;
 * deux CTE récursives remontent la chaîne de proche en proche, avec deux
 * garde-fous : profondeur bornée à `maxDepth` et tableau `path` interdisant de
 * repasser sur un id déjà visité (rien en base n'empêche A → B → A).
 * `depth` vaut 0 pour l'appareil demandé, négatif en amont, positif en aval.
 * @returns {Promise<object[]>} vide si l'appareil n'existe pas
 */
async function findLineage(db, id, maxDepth) {
  const result = await db.query(
    `WITH RECURSIVE ancestors AS (
       SELECT a.id, a.predecessor_id, 0 AS depth, ARRAY[a.id] AS path
       FROM airplanes a WHERE a.id = $1
       UNION ALL
       SELECT p.id, p.predecessor_id, anc.depth - 1, anc.path || p.id
       FROM ancestors anc
       JOIN airplanes p ON p.id = anc.predecessor_id
       WHERE anc.depth > -$2::int AND NOT (p.id = ANY(anc.path))
     ),
     descendants AS (
       SELECT a.id, a.successor_id, 0 AS depth, ARRAY[a.id] AS path
       FROM airplanes a WHERE a.id = $1
       UNION ALL
       SELECT s.id, s.successor_id, des.depth + 1, des.path || s.id
       FROM descendants des
       JOIN airplanes s ON s.id = des.successor_id
       WHERE des.depth < $2::int AND NOT (s.id = ANY(des.path))
     ),
     chain AS (
       SELECT id, MIN(depth) AS depth FROM (
         SELECT id, depth FROM ancestors
         UNION ALL
         SELECT id, depth FROM descendants
       ) u GROUP BY id
     )
     SELECT a.id, a.name, a.name_en, a.image_url, chain.depth,
            c.code AS country_code,
            EXTRACT(YEAR FROM COALESCE(a.date_operationel, a.date_first_fly))::int AS year
     FROM chain
     JOIN airplanes a ON a.id = chain.id
     LEFT JOIN countries c ON a.country_id = c.id
     ORDER BY chain.depth ASC`,
    [id, maxDepth]
  );
  return result.rows;
}

// --- Écriture -----------------------------------------------------------------

/**
 * Existence des clés étrangères d'une fiche, en une requête.
 * @returns {Promise<{ country_ok: boolean, manufacturer_ok: boolean, generation_ok: boolean, type_ok: boolean }>}
 */
async function checkForeignKeys(db, { country_id, id_manufacturer, id_generation, type }) {
  const clean = (v) => (v === '' || v === undefined) ? null : v;
  const checks = await db.query(
    `SELECT
      ($1::integer IS NULL OR EXISTS(SELECT 1 FROM countries    WHERE id = $1)) AS country_ok,
      ($2::integer IS NULL OR EXISTS(SELECT 1 FROM manufacturer WHERE id = $2)) AS manufacturer_ok,
      ($3::integer IS NULL OR EXISTS(SELECT 1 FROM generation   WHERE id = $3)) AS generation_ok,
      ($4::integer IS NULL OR EXISTS(SELECT 1 FROM type         WHERE id = $4)) AS type_ok`,
    [clean(country_id), clean(id_manufacturer), clean(id_generation), clean(type)]
  );
  return checks.rows[0];
}

// Colonnes et marqueurs dérivés de utils/airplane-fields.js : un champ ajouté
// à la table y entre automatiquement, dans le même ordre.
const INSERT_SQL = `INSERT INTO airplanes (${AIRPLANE_COLUMNS.join(', ')})
       VALUES (${AIRPLANE_COLUMNS.map((_, i) => `$${i + 1}`).join(', ')})
       RETURNING *`;

/** Crée une fiche à partir d'un corps validé (champ absent → NULL). @returns la ligne insérée */
async function insert(db, body) {
  return (await db.query(INSERT_SQL, toDbValues(body))).rows[0];
}

/**
 * Modifie les seules colonnes PRÉSENTES dans le corps : un champ absent est
 * conservé tel quel, un champ présent à null ou '' est effacé. L'UPDATE
 * réécrivait autrefois toutes les colonnes, si bien qu'un formulaire qui
 * n'envoyait pas un champ (engine_type_en, variants_en depuis la fiche) le
 * remettait à NULL à chaque modification, sans erreur.
 * @returns la ligne modifiée, ou null si l'id n'existe pas
 */
async function update(db, id, body) {
  const fields = presentFields(body);
  if (fields.length === 0) {
    // Rien à écrire (ne se produit pas via la route : `name` est obligatoire).
    const result = await db.query('SELECT * FROM airplanes WHERE id = $1', [id]);
    return result.rows[0] || null;
  }
  const sets = fields.map((field, i) => `${field.column} = $${i + 1}`);
  const values = fields.map((field) => toDbValue(field, body[field.column]));
  const result = await db.query(
    `UPDATE airplanes SET ${sets.join(', ')} WHERE id = $${fields.length + 1} RETURNING *`,
    [...values, id]
  );
  return result.rows[0] || null;
}

/** @returns {Promise<{ id: number, name: string }|null>} */
async function remove(db, id) {
  const result = await db.query('DELETE FROM airplanes WHERE id = $1 RETURNING id, name', [id]);
  return result.rows[0] || null;
}

module.exports = {
  SORT_SQL,
  buildListFilters,
  findPage,
  loadFilterValues,
  findById,
  findArmament,
  findTech,
  findMissions,
  findWars,
  findRelated,
  findLineage,
  checkForeignKeys,
  insert,
  update,
  remove,
};
