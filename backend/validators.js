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

function isOptionalUrl(value) {
  if (value == null || value === '') return true;
  if (typeof value !== 'string' || value.length > 2048) return false;
  try {
    const url = new URL(value);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch {
    return false;
  }
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

function isOptionalId(value) {
  if (value == null || value === '') return true;
  const num = Number(value);
  return Number.isInteger(num) && num > 0;
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

function validateAirplaneData(body) {
  const errors = [];

  if (!isValidString(body.name, 255)) {
    errors.push('Le nom est requis (max 255 caractères).');
  }
  if (!isOptionalString(body.complete_name, 255)) {
    errors.push('Le nom complet ne doit pas dépasser 255 caractères.');
  }
  if (!isOptionalString(body.little_description, 255)) {
    errors.push('La description courte ne doit pas dépasser 255 caractères.');
  }
  if (!isOptionalUrl(body.image_url)) {
    errors.push("L'URL de l'image doit être une URL valide (http/https, max 2048 caractères).");
  }
  if (!isOptionalText(body.description, 10000)) {
    errors.push('La description ne doit pas dépasser 10 000 caractères.');
  }
  if (!isOptionalId(body.country_id)) {
    errors.push("L'ID du pays doit être un entier positif.");
  }
  if (!isOptionalDate(body.date_concept)) {
    errors.push('La date de conception doit être une date valide.');
  }
  if (!isOptionalDate(body.date_first_fly)) {
    errors.push('La date du premier vol doit être une date valide.');
  }
  if (!isOptionalDate(body.date_operationel)) {
    errors.push('La date opérationnelle doit être une date valide.');
  }
  if (!isOptionalPositiveNumber(body.max_speed)) {
    errors.push('La vitesse max doit être un nombre positif.');
  }
  if (!isOptionalPositiveNumber(body.max_range)) {
    errors.push('La portée max doit être un nombre positif.');
  }
  if (!isOptionalId(body.id_manufacturer)) {
    errors.push("L'ID du fabricant doit être un entier positif.");
  }
  if (!isOptionalId(body.id_generation)) {
    errors.push("L'ID de la génération doit être un entier positif.");
  }
  if (!isOptionalId(body.type)) {
    errors.push("L'ID du type doit être un entier positif.");
  }
  if (!isOptionalString(body.status, 50)) {
    errors.push('Le statut ne doit pas dépasser 50 caractères.');
  }
  if (!isOptionalPositiveNumber(body.weight)) {
    errors.push('Le poids doit être un nombre positif.');
  }

  // ── Strate 1 : fiche technique étendue ─────────────────────────
  const positiveFields = [
    ['length', 'La longueur'],
    ['wingspan', "L'envergure"],
    ['height', 'La hauteur'],
    ['wing_area', 'La surface alaire'],
    ['empty_weight', 'Le poids à vide'],
    ['mtow', 'Le MTOW'],
    ['climb_rate', 'Le taux de montée'],
    ['combat_radius', 'Le rayon de combat'],
  ];
  for (const [key, label] of positiveFields) {
    if (!isOptionalPositiveNumber(body[key])) {
      errors.push(`${label} doit être un nombre positif.`);
    }
  }
  if (!isOptionalNonNegativeInt(body.service_ceiling)) {
    errors.push('Le plafond opérationnel doit être un entier positif.');
  }
  if (!isOptionalNumber(body.g_limit_pos)) errors.push('g_limit_pos invalide.');
  if (!isOptionalNumber(body.g_limit_neg)) errors.push('g_limit_neg invalide.');
  if (!isOptionalNonNegativeInt(body.crew)) errors.push('Le nombre de pilotes doit être un entier positif.');

  // ── Strate 2 : motorisation ───────────────────────────────────
  if (!isOptionalString(body.engine_name, 255)) errors.push("Nom du moteur > 255 caractères.");
  if (!isOptionalString(body.engine_type, 100)) errors.push("Type du moteur > 100 caractères.");
  if (!isOptionalString(body.engine_type_en, 100)) errors.push("Type du moteur (EN) > 100 caractères.");
  if (!isOptionalNonNegativeInt(body.engine_count)) errors.push('Le nombre de moteurs doit être un entier ≥ 0.');
  if (!isOptionalPositiveNumber(body.thrust_dry)) errors.push('La poussée sèche doit être un nombre positif.');
  if (!isOptionalPositiveNumber(body.thrust_wet)) errors.push('La poussée PC doit être un nombre positif.');

  // ── Strate 3 : production ─────────────────────────────────────
  if (!isOptionalYear(body.production_start)) errors.push("Année de début de production invalide.");
  if (!isOptionalYear(body.production_end)) errors.push("Année de fin de production invalide.");
  if (!isOptionalNonNegativeInt(body.units_built)) errors.push('Unités produites doit être un entier ≥ 0.');
  if (!isOptionalNonNegativeInt(body.unit_cost_usd)) errors.push('Coût unitaire doit être un entier ≥ 0.');
  if (!isOptionalYear(body.unit_cost_year)) errors.push("Année de référence du coût invalide.");
  if (!isOptionalNonNegativeInt(body.operators_count)) errors.push('Nombre d\'opérateurs doit être un entier ≥ 0.');
  if (!isOptionalText(body.variants, 5000)) errors.push('Variantes > 5000 caractères.');
  if (!isOptionalText(body.variants_en, 5000)) errors.push('Variants (EN) > 5000 caractères.');

  // ── Strate 4 : qualitatif ─────────────────────────────────────
  const stealthEnum = ['aucune', 'reduite', 'moderee', 'elevee', 'tres_elevee'];
  if (body.stealth_level != null && body.stealth_level !== '' && !stealthEnum.includes(body.stealth_level)) {
    errors.push('stealth_level doit être l\'une des valeurs : ' + stealthEnum.join(', '));
  }
  if (!isOptionalString(body.nickname, 255)) errors.push('Surnom > 255 caractères.');
  if (!isOptionalId(body.predecessor_id)) errors.push("predecessor_id doit être un entier positif.");
  if (!isOptionalId(body.successor_id)) errors.push("successor_id doit être un entier positif.");
  if (!isOptionalId(body.rival_id)) errors.push("rival_id doit être un entier positif.");

  // ── Strate 6 : médias externes ────────────────────────────────
  for (const key of ['wikipedia_fr', 'wikipedia_en', 'youtube_showcase', 'manufacturer_page']) {
    if (!isOptionalUrl(body[key])) errors.push(`${key} doit être une URL http/https valide (max 500).`);
    if (body[key] != null && typeof body[key] === 'string' && body[key].length > 500) {
      errors.push(`${key} > 500 caractères.`);
    }
  }

  return errors;
}

module.exports = {
  isValidEmail,
  isValidName,
  isValidPassword,
  isValidString,
  isOptionalString,
  isOptionalText,
  isOptionalUrl,
  isOptionalNumber,
  isOptionalYear,
  isOptionalNonNegativeInt,
  isOptionalDate,
  isOptionalPositiveNumber,
  isOptionalId,
  validateAirplaneData,
};
