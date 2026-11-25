/* Généré par scripts/build-js.js depuis backend/utils/markdown.js — ne pas éditer.
 * Parser Markdown minimaliste des récits : même rendu que le serveur (SEO-001).
 * Sortie repassée par DOMPurify (safeSetHTML). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  // Langue du texte : celle demandée, sinon celle de l'interface.
  function resolveLang(lang) {
    if (typeof lang === 'string') return lang;
    if (window.i18n && typeof window.i18n.currentLang === 'string') return window.i18n.currentLang;
    return (document.documentElement && document.documentElement.lang) || '';
  }

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

  window.VH.details.markdown = { parse, typographyFr, isMarkdown };
  if (typeof module !== 'undefined' && module.exports) module.exports = window.VH.details.markdown;
})();
