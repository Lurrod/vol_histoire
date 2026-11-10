'use strict';

/**
 * Helpers partagés par les rendus serveur (routes/details-ssr.js,
 * routes/conflicts-ssr.js) : échappement, URL absolues, réécriture des balises
 * de tête et des blocs JSON-LD d'un gabarit HTML.
 *
 * Tous les remplacements passent par une fonction : un « $& » ou « $1 » dans
 * un nom d'appareil ou de conflit reste du texte au lieu d'être interprété par
 * String.prototype.replace.
 */

const SITE_URL = 'https://vol-histoire.titouan-borde.com';
// Visuel de partage par défaut (1200 × 630) et logo carré de l'éditeur.
const DEFAULT_OG_IMAGE = `${SITE_URL}/og-default.jpg`;
const PUBLISHER_LOGO = `${SITE_URL}/assets/logo/icon-512.png`;
const OG_LOCALES = { fr: 'fr_FR', en: 'en_US' };

function escapeHtml(str) {
  return String(str == null ? '' : str).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

// Échappe ce qui pourrait rompre un <script type="application/ld+json"> :
// caractères de contrôle, séparateurs de ligne Unicode, et surtout '<' — sans
// lui, un nom d'appareil contenant </script> refermerait le bloc et le reste
// serait interprété comme du HTML.
function escapeJson(str) {
  return String(str || '')
    .replace(/[\u0000-\u001f\u2028\u2029]/g, c => `\\u${c.charCodeAt(0).toString(16).padStart(4, '0')}`)
    .replace(/</g, '\\u003c');
}

function truncate(text, max) {
  const t = String(text || '').replace(/\s+/g, ' ').trim();
  if (t.length <= max) return t;
  const cut = t.slice(0, max - 1).replace(/[\s,;:]+\S*$/, '');
  // Coupé juste après une fin de phrase : pas de « ….» redondant.
  return /[.!?…]$/.test(cut) ? cut : `${cut}…`;
}

/**
 * URL d'une page dans une langue. Le français est servi à l'URL nue (qui est
 * aussi la version x-default), l'anglais à `?lang=en` : chaque version a sa
 * propre URL, rendue côté serveur dans sa langue et canonique sur elle-même.
 * @param {string} url - URL sans paramètre de langue
 * @param {'fr'|'en'} lang
 */
function langUrl(url, lang) {
  if (lang !== 'en') return url;
  return `${url}${url.includes('?') ? '&' : '?'}lang=en`;
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

/**
 * URL absolue en HTTPS, exigée par og:image et les données structurées.
 *  - http://…  → https://…  (les robots sociaux refusent le HTTP)
 *  - /chemin   → SITE_URL/chemin
 *  - autre (data:, https://…) → inchangé
 */
function toAbsoluteUrl(raw) {
  const url = String(raw || '');
  if (!url) return '';
  if (url.startsWith('http://')) return url.replace(/^http:\/\//, 'https://');
  if (url.startsWith('/')) return SITE_URL + url;
  return url;
}

/** Bloc <script type="application/ld+json" id="…"> sûr. */
function jsonLdScript(id, data) {
  return `<script type="application/ld+json" id="${escapeHtml(id)}">${escapeJson(JSON.stringify(data))}</script>`;
}

function breadcrumbLd(items) {
  return {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: items.map((it, i) => ({
      '@type': 'ListItem', position: i + 1, name: it.name, item: it.url,
    })),
  };
}

function replaceTag(html, re, tag) {
  return html.replace(re, () => tag);
}

/**
 * Réécrit les balises de tête d'un gabarit. Les balises absentes du gabarit
 * sont ignorées (aucune n'est créée) : le gabarit déclare ce qu'il publie.
 *
 * Langue : `meta.url` est l'URL sans paramètre de langue. Le canonical et
 * og:url visent la version servie (auto-référents : `?lang=en` pour
 * l'anglais), les hreflang fr / en / x-default sont réciproques.
 *
 * @param {string} html
 * @param {object} meta - { title, description, url, image?, imageAlt?, lang? }
 */
function applyHeadMeta(html, meta) {
  const t = escapeHtml(meta.title);
  const d = escapeHtml(meta.description);
  const lang = meta.lang === 'en' ? 'en' : 'fr';
  const base = escapeHtml(meta.url);
  const self = escapeHtml(langUrl(meta.url, lang));
  const en = escapeHtml(langUrl(meta.url, 'en'));
  let out = html;
  out = replaceTag(out, /<title[^>]*>[^<]*<\/title>/, `<title>${t}</title>`);
  out = replaceTag(out, /<meta name="description" content="[^"]*">/, `<meta name="description" content="${d}">`);
  out = replaceTag(out, /<link rel="canonical" href="[^"]*">/, `<link rel="canonical" href="${self}">`);
  out = replaceTag(out, /<link rel="alternate" hreflang="fr" href="[^"]*">/, `<link rel="alternate" hreflang="fr" href="${base}">`);
  out = replaceTag(out, /<link rel="alternate" hreflang="en" href="[^"]*">/, `<link rel="alternate" hreflang="en" href="${en}">`);
  out = replaceTag(out, /<link rel="alternate" hreflang="x-default" href="[^"]*">/, `<link rel="alternate" hreflang="x-default" href="${base}">`);
  out = replaceTag(out, /<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${t}">`);
  out = replaceTag(out, /<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${d}">`);
  out = replaceTag(out, /<meta property="og:url" content="[^"]*">/, `<meta property="og:url" content="${self}">`);
  out = replaceTag(out, /<meta property="og:locale" content="[^"]*">/, `<meta property="og:locale" content="${OG_LOCALES[lang]}">`);
  out = replaceTag(out, /<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${t}">`);
  out = replaceTag(out, /<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${d}">`);
  if (meta.image) {
    const img = escapeHtml(meta.image);
    out = replaceTag(out, /<meta property="og:image" content="[^"]*">/, `<meta property="og:image" content="${img}">`);
    out = replaceTag(out, /<meta name="twitter:image" content="[^"]*">/, `<meta name="twitter:image" content="${img}">`);
  }
  if (meta.imageAlt) {
    const alt = escapeHtml(meta.imageAlt);
    out = replaceTag(out, /<meta property="og:image:alt" content="[^"]*">/, `<meta property="og:image:alt" content="${alt}">`);
    out = replaceTag(out, /<meta name="twitter:image:alt" content="[^"]*">/, `<meta name="twitter:image:alt" content="${alt}">`);
  }
  if (lang === 'en') out = out.replace(/<html lang="fr">/, () => '<html lang="en">');
  return out;
}

/**
 * Remplace TOUS les blocs JSON-LD du gabarit par `scripts` (déjà sérialisés),
 * insérés à la place du premier. Sans bloc dans le gabarit, ils vont avant
 * </head>. Évite qu'un fil d'Ariane du gabarit coexiste avec celui du serveur.
 */
function replaceJsonLd(html, scripts) {
  const block = scripts.join('\n  ');
  let inserted = false;
  const out = html.replace(/\s*<script type="application\/ld\+json"[^>]*>[\s\S]*?<\/script>/g, () => {
    if (inserted) return '';
    inserted = true;
    return '\n  ' + block;
  });
  if (inserted) return out;
  return out.replace(/<\/head>/, () => `  ${block}\n</head>`);
}

/** Envoie un rendu SSR : nonce CSP, cache partagé variant selon la langue. */
function sendSsrHtml(req, res, html) {
  res.set('Content-Type', 'text/html; charset=utf-8');
  // 1h côté navigateur, 2h côté CDN ; stale-while-revalidate pour éviter
  // qu'une régénération lente ne bloque un crawler.
  res.set('Cache-Control', 'public, max-age=3600, s-maxage=7200, stale-while-revalidate=86400');
  // La langue vient aussi d'Accept-Language : un cache partagé ne doit pas
  // servir la version anglaise à un visiteur francophone.
  res.vary('Accept-Language');
  const inject = req.app.injectCspNonce;
  res.send(typeof inject === 'function' ? inject(html, res.locals.cspNonce) : html);
}

module.exports = {
  SITE_URL,
  DEFAULT_OG_IMAGE,
  PUBLISHER_LOGO,
  escapeHtml,
  escapeJson,
  truncate,
  langUrl,
  markdownToText,
  buildDescription,
  typographyFr,
  toAbsoluteUrl,
  jsonLdScript,
  breadcrumbLd,
  applyHeadMeta,
  replaceJsonLd,
  sendSsrHtml,
};
