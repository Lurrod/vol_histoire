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

// Meta description (troncature, Markdown → texte, typographie) : module
// partagé avec le navigateur (ARCH-003).
const { truncate, markdownToText, buildDescription, typographyFr } = require('./meta-description');

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

/** Envoie un rendu SSR : nonce CSP, cache du seul navigateur, variant selon la langue. */
function sendSsrHtml(req, res, html) {
  res.set('Content-Type', 'text/html; charset=utf-8');
  // La page porte le nonce CSP de cette réponse (en-tête et corps). Un cache
  // partagé (proxy, CDN) servirait le même nonce à tous les visiteurs
  // pendant des heures : lisible sur la page publique, il redeviendrait
  // utilisable par un script injecté (SEC-003). Seul le navigateur garde
  // donc sa copie (1 h, son propre nonce).
  res.set('Cache-Control', 'private, max-age=3600');
  // La langue vient aussi d'Accept-Language : la copie du navigateur ne
  // doit pas resservir la version anglaise après un changement de langue.
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
