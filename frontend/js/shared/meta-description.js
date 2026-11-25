/* Généré par scripts/build-js.js depuis backend/utils/meta-description.js — ne pas éditer.
 * Meta description d'une fiche : même règle que le rendu serveur. */
(function () {
  function truncate(text, max) {
    const t = String(text || '').replace(/\s+/g, ' ').trim();
    if (t.length <= max) return t;
    const cut = t.slice(0, max - 1).replace(/[\s,;:]+\S*$/, '');
    // Coupé juste après une fin de phrase : pas de « ….» redondant.
    return /[.!?…]$/.test(cut) ? cut : `${cut}…`;
  }

  /**
   * Premier paragraphe d'un récit Markdown, en texte brut : titres sautés,
   * emphase, liens, code et puces retirés. Sert aux meta descriptions, qui ne
   * doivent jamais publier « ## Genèse » ou des astérisques.
   */
  function markdownToText(md) {
    const lines = String(md || '').replace(/\r\n?/g, '\n').split('\n');
    const para = [];
    for (const raw of lines) {
      const line = raw.trim();
      if (!line) { if (para.length) break; continue; }
      if (/^#{1,6}\s/.test(line) || /^(-{3,}|\*{3,}|_{3,})$/.test(line)) {
        if (para.length) break;
        continue;
      }
      para.push(line.replace(/^(?:[-*+>]|\d+[.)])\s+/, ''));
    }
    return para.join(' ')
      .replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1')
      .replace(/(\*\*|__)(.+?)\1/g, '$2')
      .replace(/(^|[^\w*])\*(?!\s)([^*]+?)\*(?!\w)/g, '$1$2')
      .replace(/`([^`]*)`/g, '$1')
      .replace(/\s+/g, ' ')
      .trim();
  }

  /**
   * Meta description d'environ 140-160 caractères : la phrase d'accroche,
   * complétée du début du récit (ou, à défaut, d'une phrase de repli), coupée
   * sur un mot.
   * @param {string} lead - accroche courte (little_description)
   * @param {string} narrative - récit Markdown
   * @param {string} filler - phrase ajoutée quand il n'y a pas de récit
   * @param {number} [max=158]
   */
  function buildDescription(lead, narrative, filler, max = 158, lang = 'fr') {
    let head = String(lead || '').replace(/\s+/g, ' ').trim();
    if (head && !/[.!?…]$/.test(head)) head += '.';
    const body = markdownToText(narrative) || filler || '';
    // Typographie appliquée après la coupe : truncate() normalise les blancs
    // (\s couvre les espaces insécables) et les effacerait.
    const text = truncate([head, body].filter(Boolean).join(' '), max);
    return lang === 'fr' ? typographyFr(text) : text;
  }

  // Typographie française, même règle que frontend/js/details/markdown.js :
  // espace fine insécable avant ; ? !, insécable avant : et dans les « »,
  // apostrophe ’ entre deux lettres. Seule une espace existante est remplacée
  // (« 12:30 », « :// » ne bougent pas) ; les URL sont mises de côté.
  const NBSP = '\u00A0';
  const NNBSP = '\u202F';
  const URL_RE = /(\bhttps?:\/\/[^\s)\]]+|\bwww\.[^\s)\]]+)/g;

  function typographyFr(text) {
    return String(text || '').split(URL_RE).map((part, i) => (i % 2 ? part : part
      .replace(/[ \t]+(?=[;!?])/g, NNBSP)
      .replace(/[ \t]+(?=:)/g, NBSP)
      .replace(/«[ \t\u00A0\u202F]*/g, `«${NBSP}`)
      .replace(/[ \t\u00A0\u202F]*»/g, `${NBSP}»`)
      .replace(/(\p{L})'(?=[\p{L}\p{N}«])/gu, '$1’'))).join('');
  }

  const api = { truncate, markdownToText, buildDescription, typographyFr };
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};
  window.VH.shared.metaDescription = api;
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
})();
