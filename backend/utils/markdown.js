/* Parser Markdown minimaliste des récits de fiche : source unique du serveur
 * (rendu SSR de la fiche, utils/details-body-ssr.js — SEO-001) et du
 * navigateur (frontend/js/details/markdown.js, recopié par
 * scripts/build-js.js). Le corps entre les deux repères est recopié tel quel ;
 * seule la langue par défaut (resolveLang) diffère d'un côté à l'autre.
 *
 * Gère :
 *   - ## Titres   → <h3 class="md-section">
 *   - ### Titres  → <h4 class="md-subsection">
 *   - **gras**    → <strong>
 *   - *italique*  → <em>
 *   - Paragraphes (double saut de ligne)
 *   - Listes - item → <ul><li>
 *   - Liens [texte](url) → <a href rel="noopener"> (http/https seulement)
 *   - Typographie française au rendu (texte en français seulement) :
 *     insécables avant « : ; ? ! » et dans les « », apostrophe ’
 *
 * Tout le texte est échappé avant que les motifs reconnus soient réactivés :
 * la sortie ne contient que les balises ci-dessus. Le navigateur la repasse
 * en plus par DOMPurify (safeSetHTML).
 */
'use strict';

/** Serveur : la langue du texte est toujours fournie par l'appelant. */
function resolveLang(lang) {
  return typeof lang === 'string' ? lang : '';
}

// >>> partagé avec le navigateur
function escapeHtmlLocal(str) {
  return String(str).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

// ── Typographie française, appliquée au rendu ─────────────────────────────
// Les récits sont saisis avec une espace ordinaire avant « : ; ? ! » et des
// apostrophes droites ; plutôt que de réécrire les fiches, on corrige à
// l'affichage, en français seulement :
//   - espace fine insécable (U+202F) avant ; ? !
//   - espace insécable (U+00A0) avant : et à l'intérieur des « »
//   - apostrophe typographique ’ entre deux lettres (l'avion → l’avion)
// On ne remplace qu'une espace EXISTANTE : « 12:30 », « :// » ou « Mach 2! »
// ne bougent pas. Les URL (dans un lien Markdown ou en clair) et le code
// entre accents graves sont mis de côté avant le traitement.
const NBSP = ' ';
const NNBSP = ' ';
const PROTECTED = /(`[^`\n]*`|\]\([^)\n]*\)|\bhttps?:\/\/[^\s)\]]+|\bwww\.[^\s)\]]+)/g;

function typographyFrText(text) {
  return text
    // Guillemets droits "x" → « x » (CONT-005) ; le code et les URL sont
    // déjà mis de côté par typographyFr.
    .replace(/"([^"\n]+)"/g, '«' + NBSP + '$1' + NBSP + '»')
    .replace(/[ \t]+(?=[;!?])/g, NNBSP)
    .replace(/[ \t]+(?=:)/g, NBSP)
    .replace(/«[ \t  ]*/g, '«' + NBSP)
    .replace(/[ \t  ]*»/g, NBSP + '»')
    .replace(/(\p{L})'(?=[\p{L}\p{N}*_«])/gu, '$1’');
}

function typographyFr(text) {
  if (typeof text !== 'string' || text === '') return '';
  // split() avec groupe capturant : indices pairs = texte, impairs = protégé.
  return text.split(PROTECTED)
    .map((part, i) => (i % 2 === 1 ? part : typographyFrText(part)))
    .join('');
}

/** Le récit contient-il du Markdown (titre ou liste) ? Sinon : texte simple. */
function isMarkdown(text) {
  return typeof text === 'string' && /(^|\n)(##|###|\s*-\s)/.test(text);
}

function parseInline(text, frenchTypography) {
  // Typographie sur le texte brut (avant échappement : l'apostrophe y est
  // encore un caractère, pas l'entité &#39;).
  const source = frenchTypography ? typographyFr(text) : text;
  // Échappement d'abord, puis on ré-active les patterns reconnus.
  let s = escapeHtmlLocal(source);
  // Liens [texte](url) — n'accepte que http/https, bloque javascript:.
  // `url` provient du texte DÉJÀ échappé (" → &quot;, & → &amp;) : le
  // ré-échapper transformerait « & » en « &amp;amp; » dans le href.
  s = s.replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g,
    (_, label, url) => `<a href="${url}" target="_blank" rel="noopener noreferrer">${label}</a>`);
  // **gras**
  s = s.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
  // *italique* (non greedy, évite conflits avec **)
  // L'apostrophe typographique ouvre aussi un italique : l’*Atlantique*.
  s = s.replace(/(^|[\s(’])\*([^*\n]+)\*(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
  return s;
}

/**
 * @param {string} markdown
 * @param {{lang?: string}} [options] langue du texte (navigateur : à défaut,
 *   celle de l'interface). Typographie française seulement si elle commence
 *   par « fr ».
 */
function parse(markdown, options) {
  if (!markdown || typeof markdown !== 'string') return '';
  const lang = resolveLang(options && options.lang);
  const fr = /^fr\b/i.test(lang);
  const inline = (text) => parseInline(text, fr);
  const lines = markdown.replace(/\r\n/g, '\n').split('\n');
  const out = [];
  let paragraph = [];
  let listBuffer = [];

  function flushParagraph() {
    if (paragraph.length > 0) {
      out.push(`<p>${inline(paragraph.join(' '))}</p>`);
      paragraph = [];
    }
  }
  function flushList() {
    if (listBuffer.length > 0) {
      out.push(`<ul>${listBuffer.map(item => `<li>${inline(item)}</li>`).join('')}</ul>`);
      listBuffer = [];
    }
  }

  for (const rawLine of lines) {
    const line = rawLine.trimEnd();

    // Titre niveau 2 (##)
    if (/^##\s+/.test(line)) {
      flushParagraph(); flushList();
      out.push(`<h3 class="md-section">${inline(line.replace(/^##\s+/, ''))}</h3>`);
      continue;
    }
    // Titre niveau 3 (###)
    if (/^###\s+/.test(line)) {
      flushParagraph(); flushList();
      out.push(`<h4 class="md-subsection">${inline(line.replace(/^###\s+/, ''))}</h4>`);
      continue;
    }
    // Liste - item
    if (/^\s*-\s+/.test(line)) {
      flushParagraph();
      listBuffer.push(line.replace(/^\s*-\s+/, ''));
      continue;
    }
    // Ligne vide → fermer paragraphe/liste courante
    if (line.trim() === '') {
      flushParagraph(); flushList();
      continue;
    }
    // Texte ordinaire → agréger en paragraphe
    flushList();
    paragraph.push(line);
  }
  flushParagraph(); flushList();
  return out.join('\n');
}
// <<< partagé avec le navigateur

module.exports = { parse, typographyFr, isMarkdown };
