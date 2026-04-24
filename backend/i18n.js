'use strict';

// ============================================================================
// Backend i18n — Sélection de langue pour les contenus DB
// ============================================================================
// Stratégie : colonnes dupliquées (_en). Si lang=en, on retourne le champ _en.
// Si _en est NULL, on retourne "Translation needed" (pas de fallback FR).
// Si lang=fr (ou absent), on retourne le champ original (FR).
// ============================================================================

const SUPPORTED_LANGS = ['fr', 'en'];
const DEFAULT_LANG = 'fr';
const TRANSLATION_NEEDED = 'Translation needed';

/**
 * Extrait la langue de la requête : query param `?lang=` prioritaire,
 * puis header Accept-Language, fallback sur 'fr'.
 */
function resolveLang(req) {
  const queryLang = req.query && req.query.lang;
  if (queryLang && SUPPORTED_LANGS.includes(queryLang)) return queryLang;

  const header = req.headers && req.headers['accept-language'];
  if (header) {
    // Ex: "en-US,en;q=0.9,fr;q=0.8" → on prend la première langue supportée
    const tags = header.split(',').map(s => s.trim().split(';')[0].split('-')[0].toLowerCase());
    for (const tag of tags) {
      if (SUPPORTED_LANGS.includes(tag)) return tag;
    }
  }
  return DEFAULT_LANG;
}

/**
 * Middleware Express : attache `req.lang` et l'utilise dans toutes les routes.
 */
function langMiddleware(req, res, next) {
  req.lang = resolveLang(req);
  next();
}

/**
 * Applique la langue à une ligne SQL. Les champs traduisibles doivent être
 * listés dans `fields`. Si lang=en et que `field_en` est NULL, retourne
 * "Translation needed".
 *
 * @param {object} row - ligne SQL brute avec colonnes {field, field_en, ...}
 * @param {string} lang - 'fr' ou 'en'
 * @param {string[]} fields - noms des champs traduisibles (sans le suffixe _en)
 * @returns {object} - nouvelle ligne avec les champs résolus
 *
 * Exemple :
 *   pickLang({name: 'Rafale', name_en: null, description: 'Un avion', description_en: null},
 *            'en', ['name', 'description'])
 *   → {name: 'Rafale', description: 'Translation needed'}
 *   (name est un nom propre, donc name_en NULL retourne name FR — voir note)
 *
 * NOTE : pour les NOMS propres (airplanes.name, manufacturer.name, ...),
 * on fallback sur le FR car traduire "Rafale" en EN donnerait "Rafale".
 * Pour les DESCRIPTIONS, on affiche "Translation needed" explicitement.
 * Le paramètre `fallbackFields` précise quels champs font du fallback FR.
 */
function pickLang(row, lang, fields, fallbackFields = []) {
  if (!row || typeof row !== 'object') return row;
  if (lang === 'fr' || lang == null) {
    // Mode FR : supprimer les colonnes _en du résultat, garder les originales
    const clean = { ...row };
    for (const field of fields) {
      delete clean[`${field}_en`];
    }
    return clean;
  }

  // Mode EN : remplacer chaque champ par sa version _en (ou fallback)
  const result = { ...row };
  for (const field of fields) {
    const enValue = row[`${field}_en`];
    const frValue = row[field];
    if (enValue != null && enValue !== '') {
      result[field] = enValue;
    } else if (fallbackFields.includes(field)) {
      // Nom propre sans traduction → garde l'original FR (déjà dans result[field])
    } else if (frValue == null || frValue === '') {
      // FR et EN absents → rien à traduire, on préserve la valeur vide
      result[field] = frValue;
    } else {
      result[field] = TRANSLATION_NEEDED;
    }
    delete result[`${field}_en`];
  }
  return result;
}

/**
 * Applique pickLang à un tableau de lignes.
 */
function pickLangMany(rows, lang, fields, fallbackFields = []) {
  if (!Array.isArray(rows)) return rows;
  return rows.map(row => pickLang(row, lang, fields, fallbackFields));
}

module.exports = {
  SUPPORTED_LANGS,
  DEFAULT_LANG,
  TRANSLATION_NEEDED,
  resolveLang,
  langMiddleware,
  pickLang,
  pickLangMany,
};
