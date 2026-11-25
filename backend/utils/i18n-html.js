'use strict';

/**
 * Traduction côté serveur des textes d'interface d'une page (SEO-002).
 *
 * Les pages portent leurs textes en français, marqués data-i18n ; seul le
 * navigateur les traduisait (frontend/js/i18n.js, applyToDOM). Une page
 * servie en anglais (?lang=en) livrait donc menus, titres de section et
 * textes d'attente en français aux robots qui n'exécutent pas de script.
 * Mêmes règles que applyToDOM :
 *   - data-i18n : le texte est remplacé ; une icône <i> en tête est gardée
 *     (« <i …></i> Texte » → icône, espace, traduction) ;
 *   - data-i18n-html : le contenu est remplacé par la traduction, qui vient
 *     des fichiers de langue du dépôt ;
 *   - data-i18n-placeholder / data-i18n-aria : attributs placeholder et
 *     aria-label.
 * Une clé absente du dictionnaire laisse le texte français, comme le
 * navigateur. Un élément au contenu plus riche (balises imbriquées) est
 * laissé au navigateur, comme une traduction qui attend une variable que
 * seul le script connaît ({count}…) : elle s'afficherait avec ses accolades.
 */

function lookup(dict, key) {
  const value = String(key).split('.')
    .reduce((o, k) => (o && typeof o === 'object' ? o[k] : undefined), dict);
  return typeof value === 'string' ? value : null;
}

/**
 * Traduction prête à écrire : variables globales remplacées comme dans
 * i18n.js (GLOBAL_PARAMS : {year}) ; null si la clé manque ou si une autre
 * variable reste à remplir.
 */
function translate(dict, key) {
  const raw = lookup(dict, key);
  if (raw === null) return null;
  const out = raw.replace(/\{year\}/g, String(new Date().getFullYear()));
  return /\{\w+\}/.test(out) ? null : out;
}

function escapeText(str) {
  return String(str).replace(/[&<>]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]));
}

function escapeAttr(str) {
  return String(str).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

// <tag … data-i18n="clé" …>[<i …></i>]texte</tag> ; le <title> est traité
// par localizeHead (middleware/serveHtml.js).
const TEXT_RE = /(<([a-zA-Z][a-zA-Z0-9]*)\b[^>]*\sdata-i18n="([^"]+)"[^>]*>)(\s*<i\b[^>]*><\/i>)?([^<]*)(<\/\2>)/g;
const HTML_RE = /(<([a-zA-Z][a-zA-Z0-9]*)\b[^>]*\sdata-i18n-html="([^"]+)"[^>]*>)([\s\S]*?)(<\/\2>)/g;

/** Remplace (ou ajoute) un attribut dans une balise ouvrante. */
function setAttr(tag, name, value) {
  const v = escapeAttr(value);
  const re = new RegExp(`\\s${name}="[^"]*"`);
  if (re.test(tag)) return tag.replace(re, () => ` ${name}="${v}"`);
  return tag.replace(/\s*(\/?)>$/, (m, slash) => ` ${name}="${v}"${slash ? ' /' : ''}>`);
}

/**
 * @param {string} html - page ou gabarit en français
 * @param {object} dict - locales/<lang>.json de la langue cible
 * @returns {string}
 */
function localizeBody(html, dict) {
  if (!dict || typeof html !== 'string') return html;
  let out = html.replace(TEXT_RE, (m, open, tag, key, icon, text, close) => {
    if (tag.toLowerCase() === 'title') return m;
    const translated = translate(dict, key);
    if (translated === null) return m;
    return icon
      ? `${open}${icon.trim()} ${escapeText(translated)}${close}`
      : `${open}${escapeText(translated)}${close}`;
  });
  out = out.replace(HTML_RE, (m, open, tag, key, inner, close) => {
    // Balise de même nom imbriquée : la fin trouvée ne serait pas la bonne.
    if (new RegExp(`<${tag}\\b`, 'i').test(inner)) return m;
    const translated = translate(dict, key);
    return translated === null ? m : `${open}${translated}${close}`;
  });
  out = out.replace(/<[a-zA-Z][^>]*\sdata-i18n-placeholder="([^"]+)"[^>]*>/g, (tag, key) => {
    const translated = translate(dict, key);
    return translated === null ? tag : setAttr(tag, 'placeholder', translated);
  });
  out = out.replace(/<[a-zA-Z][^>]*\sdata-i18n-aria="([^"]+)"[^>]*>/g, (tag, key) => {
    const translated = translate(dict, key);
    return translated === null ? tag : setAttr(tag, 'aria-label', translated);
  });
  return out;
}

module.exports = { localizeBody, lookup };
