'use strict';

// -----------------------------------------------------------------------------
// Champs éditables d'une fiche appareil — source unique.
//
// Cette table pilote, côté backend, la lecture du corps de POST/PUT
// /api/airplanes, la liste des colonnes de l'INSERT et celle de l'UPDATE.
// Ajouter une colonne éditable à `airplanes` = ajouter UNE ligne ici (plus la
// validation dans validators.js et la colonne dans db_backup/db.sql) : l'INSERT
// et l'UPDATE suivent d'eux-mêmes.
//
// POST : un champ absent du corps est inséré à NULL.
// PUT  : seuls les champs PRÉSENTS dans le corps sont écrits (presentFields) ;
//        un champ absent est conservé, un champ présent à null ou '' est effacé.
//
// Format d'une entrée (objets gelés, aucune dépendance, CommonJS pur — le
// fichier peut être chargé tel quel par un module frontend) :
//   column : nom de la colonne SQL, identique à la clé du corps JSON
//   kind   : 'text'   chaîne courte (≤ 255)      → <input type="text">
//            'longtext' texte long               → <textarea>
//            'url'    URL http(s)                → <input type="url">
//            'date'   date ISO AAAA-MM-JJ        → <input type="date">
//            'int'    entier                     → <input type="number" step="1">
//            'number' décimal                    → <input type="number" step="any">
//            'enum'   valeur d'une liste fermée  → <select> (voir `values`)
//            'ref'    id d'une autre table       → <select> (voir `ref`)
//   group  : strate éditoriale, pour regrouper les champs d'un formulaire
//            ('identity', 'dates', 'specs', 'engine', 'production',
//             'qualitative', 'media')
//   ref    : (kind 'ref') table visée : 'countries', 'manufacturer',
//            'generation', 'type' ou 'airplanes'
//   values : (kind 'enum') valeurs admises
//   required : true si le champ est obligatoire (seul `name` l'est)
//   trim   : true si la valeur est rognée avant écriture (seul `name` l'est)
//
// Conversion vers la base (toDbValue) : '' et undefined deviennent NULL, le
// reste passe tel quel — la conversion de type est faite par PostgreSQL, la
// validation par validators.js. C'est exactement le comportement historique.
// -----------------------------------------------------------------------------

const STEALTH_LEVELS = Object.freeze(['aucune', 'reduite', 'moderee', 'elevee', 'tres_elevee']);

const f = (column, kind, group, extra = {}) => Object.freeze({ column, kind, group, ...extra });

// L'ordre est celui des colonnes de l'INSERT et de l'UPDATE ($1 … $52).
const AIRPLANE_FIELDS = Object.freeze([
  f('name', 'text', 'identity', { required: true, trim: true }),
  f('complete_name', 'text', 'identity'),
  f('little_description', 'text', 'identity'),
  f('image_url', 'url', 'media'),
  f('description', 'longtext', 'identity'),
  f('country_id', 'ref', 'identity', { ref: 'countries' }),
  f('date_concept', 'date', 'dates'),
  f('date_first_fly', 'date', 'dates'),
  f('date_operationel', 'date', 'dates'),
  f('max_speed', 'number', 'specs'),
  f('max_range', 'number', 'specs'),
  f('id_manufacturer', 'ref', 'identity', { ref: 'manufacturer' }),
  f('id_generation', 'ref', 'identity', { ref: 'generation' }),
  f('type', 'ref', 'identity', { ref: 'type' }),
  f('status', 'text', 'identity'),
  // Strate 1 : fiche technique étendue
  f('length', 'number', 'specs'),
  f('wingspan', 'number', 'specs'),
  f('height', 'number', 'specs'),
  f('wing_area', 'number', 'specs'),
  f('empty_weight', 'number', 'specs'),
  f('mtow', 'number', 'specs'),
  f('service_ceiling', 'int', 'specs'),
  f('climb_rate', 'number', 'specs'),
  f('g_limit_pos', 'number', 'specs'),
  f('g_limit_neg', 'number', 'specs'),
  f('combat_radius', 'number', 'specs'),
  f('crew', 'int', 'specs'),
  // Strate 2 : motorisation
  f('engine_name', 'text', 'engine'),
  f('engine_count', 'int', 'engine'),
  f('engine_type', 'text', 'engine'),
  f('engine_type_en', 'text', 'engine'),
  f('thrust_dry', 'number', 'engine'),
  f('thrust_wet', 'number', 'engine'),
  // Strate 3 : production
  f('production_start', 'int', 'production'),
  f('production_end', 'int', 'production'),
  f('units_built', 'int', 'production'),
  f('unit_cost_usd', 'int', 'production'),
  f('unit_cost_year', 'int', 'production'),
  f('operators_count', 'int', 'production'),
  f('variants', 'longtext', 'production'),
  f('variants_en', 'longtext', 'production'),
  // Strate 4 : qualitatif
  f('stealth_level', 'enum', 'qualitative', { values: STEALTH_LEVELS }),
  f('nickname', 'text', 'qualitative'),
  f('predecessor_id', 'ref', 'qualitative', { ref: 'airplanes' }),
  f('successor_id', 'ref', 'qualitative', { ref: 'airplanes' }),
  f('rival_id', 'ref', 'qualitative', { ref: 'airplanes' }),
  // Strate 6 : médias externes
  f('wikipedia_fr', 'url', 'media'),
  f('wikipedia_en', 'url', 'media'),
  f('youtube_showcase', 'url', 'media'),
  f('manufacturer_page', 'url', 'media'),
  f('image_credit', 'text', 'media'),
  f('image_licence', 'text', 'media'),
]);

const AIRPLANE_COLUMNS = Object.freeze(AIRPLANE_FIELDS.map((field) => field.column));

/** Valeur prête pour un paramètre SQL : '' / undefined → NULL, `trim` appliqué. */
function toDbValue(field, raw) {
  if (field.trim && typeof raw === 'string') return raw.trim();
  return (raw === '' || raw === undefined) ? null : raw;
}

/**
 * Champs présents dans un corps de requête (clé propre, même à null), dans
 * l'ordre de AIRPLANE_FIELDS — ceux qu'un PUT doit écrire.
 * @param {object} body
 * @returns {ReadonlyArray<object>}
 */
function presentFields(body) {
  const source = body || {};
  return AIRPLANE_FIELDS.filter((field) => Object.hasOwn(source, field.column));
}

/**
 * Paramètres SQL, dans l'ordre de AIRPLANE_FIELDS, tirés d'un corps de requête.
 * @param {object} body
 * @returns {Array}
 */
function toDbValues(body) {
  const source = body || {};
  return AIRPLANE_FIELDS.map((field) => toDbValue(field, source[field.column]));
}

module.exports = {
  AIRPLANE_FIELDS,
  AIRPLANE_COLUMNS,
  STEALTH_LEVELS,
  toDbValue,
  toDbValues,
  presentFields,
};
