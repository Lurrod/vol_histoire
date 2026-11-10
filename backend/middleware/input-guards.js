'use strict';

// -----------------------------------------------------------------------------
// Garde-fous d'entrée communs à toutes les routes API (SEC-003).
//
// PostgreSQL rejette deux familles de valeurs avec une erreur, donc un 500 :
//   - un entier hors de la plage int4 (« integer out of range ») ;
//   - une chaîne contenant l'octet NUL (« invalid byte sequence for encoding
//     UTF8: 0x00 »).
// Les deux sont filtrées ici, avant toute requête : un visiteur anonyme ne
// peut plus produire d'erreur serveur (ni de ligne d'erreur dans les
// journaux) en jouant sur l'URL ou le corps.
// -----------------------------------------------------------------------------

/** Plus grand entier d'une colonne INTEGER / SERIAL PostgreSQL. */
const INT4_MAX = 2147483647;

/** Profondeur maximale explorée dans un corps JSON (au-delà : rejet). */
const MAX_SCAN_DEPTH = 20;

/**
 * Identifiant numérique acceptable pour une colonne SERIAL : chiffres
 * uniquement (ni signe, ni décimale, ni exposant), entre 1 et 2147483647.
 * « 0 » est accepté : il ne correspond à aucune ligne (404), sans erreur SQL.
 * @param {unknown} value
 * @returns {boolean}
 */
function isValidDbId(value) {
  if (typeof value !== 'string' && typeof value !== 'number') return false;
  const str = String(value);
  if (!/^\d{1,10}$/.test(str)) return false;
  return Number(str) <= INT4_MAX;
}

/**
 * Gestionnaire pour router.param : 400 si l'identifiant n'est pas un entier
 * int4 positif.
 * @param {string} [message]
 */
function idParam(message = 'ID invalide') {
  return (req, res, next, value) => {
    if (!isValidDbId(value)) {
      return res.status(400).json({ message });
    }
    next();
  };
}

/**
 * true si la valeur (chaîne, tableau ou objet, exploré récursivement)
 * contient un octet NUL. Une imbrication trop profonde compte comme suspecte.
 */
function containsNul(value, depth = 0) {
  if (typeof value === 'string') return value.includes('\u0000');
  if (depth > MAX_SCAN_DEPTH) return true;
  if (Array.isArray(value)) return value.some((v) => containsNul(v, depth + 1));
  if (value && typeof value === 'object') {
    return Object.keys(value).some((k) => k.includes('\u0000') || containsNul(value[k], depth + 1));
  }
  return false;
}

/**
 * Middleware : 400 si la chaîne de requête ou le corps JSON contient un
 * octet NUL. Aucun champ légitime du site n'en contient.
 */
function rejectNulBytes(req, res, next) {
  if (containsNul(req.query) || containsNul(req.body)) {
    return res.status(400).json({ message: 'Caractère interdit dans la requête', code: 'INVALID_CHARACTER' });
  }
  next();
}

// Caractères de contrôle C0 et DEL (tabulations et retours ligne compris) :
// sans valeur dans une saisie de recherche d'une ligne.
const CONTROL_CHARS = /[\u0000-\u001F\u007F]+/g;

/**
 * Normalise une saisie de recherche : caractères de contrôle remplacés par
 * une espace, espaces de bord retirées, longueur bornée (au-delà : chaîne
 * vide, comme une recherche absente).
 * @param {unknown} raw
 * @param {number} [maxLength]
 * @returns {string}
 */
function cleanSearch(raw, maxLength = 100) {
  if (typeof raw !== 'string') return '';
  const cleaned = raw.replace(CONTROL_CHARS, ' ').trim();
  return cleaned.length <= maxLength ? cleaned : '';
}

module.exports = {
  INT4_MAX,
  isValidDbId,
  idParam,
  containsNul,
  rejectNulBytes,
  cleanSearch,
};
