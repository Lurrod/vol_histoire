'use strict';

/**
 * Sanitize-logs — remplace les valeurs des champs sensibles par [REDACTED]
 * avant qu'elles n'atteignent un logger (console, fichier, Sentry).
 *
 * Appelé par logger.js sur tout objet meta passé à logger.{info,warn,error,debug}.
 *
 * Pourquoi : si un appelant fait par erreur
 *   logger.error('bad login', { email, password })
 * le mot de passe ne doit pas se retrouver en clair dans les logs JSON ni
 * dans Sentry. Ce module agit comme filet de sécurité global (défense en
 * profondeur — les appelants restent responsables de ne pas logger du PII).
 *
 * Règles :
 *  - Matching case-insensitive sur les CLÉS (pas les valeurs)
 *  - Matching par sous-chaîne : `password` match `password`, `new_password`,
 *    `confirmPassword`, `passwordHash`...
 *  - Récursif sur objets imbriqués + tableaux
 *  - Protection contre les références circulaires
 *  - Limite de profondeur (8) contre les arbres pathologiques
 *  - Error instances → préserve name/message/stack (tout le reste scrubé)
 *  - Valeurs primitives → renvoyées telles quelles (on ne touche pas aux
 *    strings libres, uniquement aux valeurs des clés sensibles)
 */

const SENSITIVE_FIELDS = Object.freeze([
  // Mots de passe
  'password', 'passwd', 'pwd',
  // Tokens
  'token', 'access_token', 'refresh_token', 'bearer', 'jwt', 'jti',
  'id_token', 'refresh_cookie',
  // Secrets & clés API
  'secret', 'api_key', 'apikey', 'private_key', 'client_secret',
  'jwt_secret', 'refresh_secret',
  // Auth headers
  'authorization',
  // Cookies & sessions
  'cookie', 'set-cookie', 'session',
  // Données bancaires & PII critique
  'credit_card', 'creditcard', 'cvv', 'cvc', 'ssn', 'pin',
  // hCaptcha
  'h-captcha-response', 'hcaptcha_secret',
]);

const REDACTED = '[REDACTED]';
const MAX_DEPTH = 8;

/**
 * Détermine si un nom de clé est considéré sensible.
 * Retourne true si la clé (en minuscules) contient l'un des mots sensibles.
 */
function isSensitiveKey(key) {
  if (typeof key !== 'string' || key.length === 0) return false;
  const lower = key.toLowerCase();
  for (const field of SENSITIVE_FIELDS) {
    if (lower.includes(field)) return true;
  }
  return false;
}

/**
 * Scrub récursif.
 * @param {*} value — primitive, objet, tableau, Error
 * @param {number} depth — profondeur courante (interne)
 * @param {WeakSet} seen — anti-cycle (interne)
 * @returns {*} — valeur sanitisée (NOUVELLE structure, l'original n'est jamais muté)
 */
function scrub(value, depth = 0, seen = new WeakSet()) {
  if (depth > MAX_DEPTH) return '[TOO_DEEP]';
  if (value === null || value === undefined) return value;

  const type = typeof value;
  if (type !== 'object') return value; // string, number, boolean, bigint, symbol, function

  // Références circulaires
  if (seen.has(value)) return '[CIRCULAR]';
  seen.add(value);

  // Error — on préserve name/message/stack mais on scrub les propriétés custom
  if (value instanceof Error) {
    const errOut = {
      name: value.name,
      message: value.message,
      stack: value.stack,
    };
    // Certains errors ajoutent des champs custom (status, code, etc.) — on scrub
    for (const key of Object.keys(value)) {
      if (key === 'name' || key === 'message' || key === 'stack') continue;
      errOut[key] = isSensitiveKey(key) ? REDACTED : scrub(value[key], depth + 1, seen);
    }
    return errOut;
  }

  // Array
  if (Array.isArray(value)) {
    return value.map(item => scrub(item, depth + 1, seen));
  }

  // Plain object
  const out = {};
  for (const key of Object.keys(value)) {
    if (isSensitiveKey(key)) {
      out[key] = REDACTED;
    } else {
      out[key] = scrub(value[key], depth + 1, seen);
    }
  }
  return out;
}

module.exports = {
  scrub,
  isSensitiveKey,
  SENSITIVE_FIELDS,
  REDACTED,
  MAX_DEPTH,
};
