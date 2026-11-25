// -----------------------------------------------------------------------------
// Fonctions de validation — extraites pour être testables unitairement
// -----------------------------------------------------------------------------

function isValidEmail(email) {
  if (typeof email !== 'string' || email.length > 255) return false;
  // Partie locale : caractères valides, pas de point en début/fin, pas de points consécutifs
  // Domaine : caractères valides, TLD alphabétique d'au moins 2 caractères
  return /^[a-zA-Z0-9_%+\-]+(\.[a-zA-Z0-9_%+\-]+)*@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,}$/.test(email);
}

function isValidName(name) {
  return typeof name === 'string' && name.trim().length >= 2 && name.length <= 255;
}

function isValidPassword(password) {
  if (typeof password !== 'string') return false;
  if (password.length < 8 || password.length > 128) return false;
  if (!/[a-z]/.test(password)) return false;
  if (!/[A-Z]/.test(password)) return false;
  if (!/[0-9]/.test(password)) return false;
  return true;
}

function isValidString(value, maxLength = 255) {
  return typeof value === 'string' && value.trim().length > 0 && value.length <= maxLength;
}

function isOptionalString(value, maxLength = 255) {
  return value == null || value === '' || (typeof value === 'string' && value.length <= maxLength);
}

function isOptionalText(value, maxLength = 10000) {
  return value == null || value === '' || (typeof value === 'string' && value.length <= maxLength);
}

// Caractères refusés tels quels dans une URL stockée : la valeur brute est
// réinjectée dans des attributs HTML (href="…"), et new URL() accepte
// https://ex.com/"onmouseover="… sans broncher. Guillemet double, chevrons,
// accent grave, blancs et caractères de contrôle n'ont rien à faire dans une
// URL légitime (ils s'écrivent encodés : %22, %3C…). L'apostrophe reste
// permise : elle figure dans des ancres Wikipédia réelles (« F-15I_Ra'am »)
// et escapeHtml() l'échappe côté front.
const URL_FORBIDDEN_CHARS = /[\s\u0000-\u001F\u007F"<>`]/;

function isOptionalUrl(value) {
  if (value == null || value === '') return true;
  if (typeof value !== 'string' || value.length > 2048) return false;
  if (URL_FORBIDDEN_CHARS.test(value)) return false;
  try {
    const url = new URL(value);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch {
    return false;
  }
}

// Image d'appareil : URL http(s) absolue, ou chemin local du site (/assets/…),
// format de toutes les fiches du catalogue. « //hote » est refusé : ce serait
// une URL vers un autre domaine déguisée en chemin.
function isOptionalImageUrl(value) {
  if (typeof value === 'string' && value.startsWith('/') && !value.startsWith('//')) {
    return value.length <= 2048 && !URL_FORBIDDEN_CHARS.test(value);
  }
  return isOptionalUrl(value);
}

function isOptionalDate(value) {
  if (value == null || value === '') return true;
  if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const [year, month, day] = value.split('-').map(Number);
  const d = new Date(value);
  return d.getFullYear() === year && d.getMonth() + 1 === month && d.getDate() === day;
}

function isOptionalPositiveNumber(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return !isNaN(num) && num >= 0;
}

// Plus grand entier d'une colonne INTEGER : au-delà, PostgreSQL lève une erreur (500)
const INT4_MAX = 2147483647;

function isOptionalId(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return Number.isInteger(num) && num > 0 && num <= INT4_MAX;
}

// Nombre signé (ex : g_limit_neg peut être négatif)
function isOptionalNumber(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return !isNaN(num) && isFinite(num);
}

// Année (SMALLINT) entre 1900 et 2100
function isOptionalYear(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return Number.isInteger(num) && num >= 1900 && num <= 2100;
}

// Entier positif ou nul (count, units, operators…)
function isOptionalNonNegativeInt(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return Number.isInteger(num) && num >= 0;
}

// Booléen facultatif : true, false, ou absent (NULL = non établi). Pas de
// chaîne « true » : le corps est du JSON, le formulaire envoie un vrai booléen.
function isOptionalBoolean(value) {
  return value == null || value === '' || typeof value === 'boolean';
}

// Identifiant de rôle : 1 (admin), 2 (éditeur) ou 3 (membre), en chaîne
// (paramètre de requête) ou en nombre. Rien d'autre : ni « 01 », ni « 1.0 »,
// ni tableau (?role=1&role=2).
function isValidRoleId(value) {
  if (typeof value !== 'string' && typeof value !== 'number') return false;
  return /^[123]$/.test(String(value));
}

// Champs de la strate 1 contrôlés comme nombres positifs, avec leur libellé.
const POSITIVE_FIELDS = [
  ['length', 'La longueur'],
  ['wingspan', "L'envergure"],
  ['height', 'La hauteur'],
  ['wing_area', 'La surface alaire'],
  ['empty_weight', 'Le poids à vide'],
  ['mtow', 'Le MTOW'],
  ['climb_rate', 'Le taux de montée'],
  ['combat_radius', 'Le rayon de combat'],
];
const STEALTH_LEVELS = ['aucune', 'reduite', 'moderee', 'elevee', 'tres_elevee'];
const MEDIA_URL_FIELDS = ['wikipedia_fr', 'wikipedia_en', 'youtube_showcase', 'manufacturer_page'];

const isBlank = (value) => value == null || value === '';
const isOptionalMach = (value) => isOptionalPositiveNumber(value)
  && (isBlank(value) || (Number(value) >= 0.1 && Number(value) <= 10));
const isOptionalHardpoints = (value) => isOptionalNonNegativeInt(value) && !(Number(value) > 30);
const isOptionalStealth = (value) => isBlank(value) || STEALTH_LEVELS.includes(value);
const isUrlWithinLimit = (value) => !(typeof value === 'string' && value.length > 500);
const maxString = (max) => (value) => isOptionalString(value, max);
const maxText = (max) => (value) => isOptionalText(value, max);

/**
 * Règles d'une fiche appareil, dans l'ordre des messages renvoyés :
 * [champ, contrôle (vrai = valide), message]. Les règles croisées (Mach,
 * points d'emport, discrétion, médias) sont des contrôles comme les autres.
 */
const AIRPLANE_RULES = [
  ['name', (value) => isValidString(value, 255), 'Le nom est requis (max 255 caractères).'],
  ['complete_name', maxString(255), 'Le nom complet ne doit pas dépasser 255 caractères.'],
  ['little_description', maxString(255), 'La description courte ne doit pas dépasser 255 caractères.'],
  ['image_url', isOptionalImageUrl, "L'URL de l'image doit être une URL valide (http/https, max 2048 caractères)."],
  ['description', maxText(10000), 'La description ne doit pas dépasser 10 000 caractères.'],
  ['country_id', isOptionalId, "L'ID du pays doit être un entier positif."],
  ['date_concept', isOptionalDate, 'La date de conception doit être une date valide.'],
  ['date_first_fly', isOptionalDate, 'La date du premier vol doit être une date valide.'],
  ['date_operationel', isOptionalDate, 'La date opérationnelle doit être une date valide.'],
  ['max_speed', isOptionalPositiveNumber, 'La vitesse max doit être un nombre positif.'],
  ['max_range', isOptionalPositiveNumber, 'La portée max doit être un nombre positif.'],
  ['id_manufacturer', isOptionalId, "L'ID du fabricant doit être un entier positif."],
  ['id_generation', isOptionalId, "L'ID de la génération doit être un entier positif."],
  ['type', isOptionalId, "L'ID du type doit être un entier positif."],
  ['image_credit', maxString(255), 'Le crédit photo ne doit pas dépasser 255 caractères.'],
  ['image_licence', maxString(100), 'La licence photo ne doit pas dépasser 100 caractères.'],
  ['status', maxString(50), 'Le statut ne doit pas dépasser 50 caractères.'],

  // ── Strate 1 : fiche technique étendue ─────────────────────────
  ...POSITIVE_FIELDS.map(([key, label]) => [key, isOptionalPositiveNumber, `${label} doit être un nombre positif.`]),
  ['service_ceiling', isOptionalNonNegativeInt, 'Le plafond opérationnel doit être un entier positif.'],
  ['g_limit_pos', isOptionalNumber, 'g_limit_pos invalide.'],
  ['g_limit_neg', isOptionalNumber, 'g_limit_neg invalide.'],
  ['crew', isOptionalNonNegativeInt, 'Le nombre de pilotes doit être un entier positif.'],

  // ── Strate 2 : motorisation ───────────────────────────────────
  ['engine_name', maxString(255), 'Nom du moteur > 255 caractères.'],
  ['engine_type', maxString(100), 'Type du moteur > 100 caractères.'],
  ['engine_type_en', maxString(100), 'Type du moteur (EN) > 100 caractères.'],
  ['engine_count', isOptionalNonNegativeInt, 'Le nombre de moteurs doit être un entier ≥ 0.'],
  ['thrust_dry', isOptionalPositiveNumber, 'La poussée sèche doit être un nombre positif.'],
  ['thrust_wet', isOptionalPositiveNumber, 'La poussée PC doit être un nombre positif.'],

  // ── Strate 7 : fiche technique avancée ────────────────────────
  ['mach_max', isOptionalMach, 'Le Mach max doit être compris entre 0,1 et 10.'],
  ['ferry_range', isOptionalPositiveNumber, 'La distance de convoyage doit être un nombre positif.'],
  ['internal_fuel', isOptionalPositiveNumber, 'Le carburant interne doit être un nombre positif.'],
  ['hardpoints', isOptionalHardpoints, "Le nombre de points d'emport doit être un entier entre 0 et 30."],
  ['supercruise', isOptionalBoolean, 'supercruise doit valoir true, false ou null.'],
  ['internal_weapons_bay', isOptionalBoolean, 'internal_weapons_bay doit valoir true, false ou null.'],
  ['radar_model', maxString(255), 'Modèle de radar > 255 caractères.'],

  // ── Strate 3 : production ─────────────────────────────────────
  ['production_start', isOptionalYear, 'Année de début de production invalide.'],
  ['production_end', isOptionalYear, 'Année de fin de production invalide.'],
  ['units_built', isOptionalNonNegativeInt, 'Unités produites doit être un entier ≥ 0.'],
  ['unit_cost_usd', isOptionalNonNegativeInt, 'Coût unitaire doit être un entier ≥ 0.'],
  ['unit_cost_year', isOptionalYear, 'Année de référence du coût invalide.'],
  ['operators_count', isOptionalNonNegativeInt, "Nombre d'opérateurs doit être un entier ≥ 0."],
  ['variants', maxText(5000), 'Variantes > 5000 caractères.'],
  ['variants_en', maxText(5000), 'Variants (EN) > 5000 caractères.'],

  // ── Strate 4 : qualitatif ─────────────────────────────────────
  ['stealth_level', isOptionalStealth, "stealth_level doit être l'une des valeurs : " + STEALTH_LEVELS.join(', ')],
  ['nickname', maxString(255), 'Surnom > 255 caractères.'],
  ['predecessor_id', isOptionalId, 'predecessor_id doit être un entier positif.'],
  ['successor_id', isOptionalId, 'successor_id doit être un entier positif.'],
  ['rival_id', isOptionalId, 'rival_id doit être un entier positif.'],

  // ── Strate 6 : médias externes (URL valide, puis longueur) ────
  ...MEDIA_URL_FIELDS.flatMap((key) => [
    [key, isOptionalUrl, `${key} doit être une URL http/https valide (max 500).`],
    [key, isUrlWithinLimit, `${key} > 500 caractères.`],
  ]),
];

function validateAirplaneData(body) {
  return AIRPLANE_RULES
    .filter(([key, isValid]) => !isValid(body[key]))
    .map(([, , message]) => message);
}

module.exports = {
  isValidEmail,
  isValidName,
  isValidPassword,
  isValidString,
  isOptionalString,
  isOptionalText,
  isOptionalUrl,
  isOptionalImageUrl,
  isOptionalNumber,
  isOptionalYear,
  isOptionalNonNegativeInt,
  isOptionalBoolean,
  isOptionalDate,
  isOptionalPositiveNumber,
  isOptionalId,
  isValidRoleId,
  validateAirplaneData,
};
