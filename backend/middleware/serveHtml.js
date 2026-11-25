/**
 * Cache HTML : inclusions partagées + cache-busting.
 *
 * Au boot, lit tous les *.html du dossier frontend/, puis :
 *  1. remplace chaque marqueur `<!-- @include <nom> -->` par le fragment
 *     frontend/partials/<nom>.html (en-tête et pied de page uniques), avec le
 *     lien actif calculé d'après la page ;
 *  2. ajoute `?v=<version>` sur chaque référence à css/ ou js/ ;
 *  3. garde le résultat en mémoire.
 *
 * Bénéfices :
 *  - Cache navigateur ultra-long (1 an) sans risque de servir un vieux JS
 *    après un déploiement : le query string change → URL différente → re-fetch
 *  - 0 coût runtime : la transformation est faite une fois au démarrage
 *  - Aucune modification des HTML sources sur disque (dev workflow intact)
 *  - Un seul en-tête et un seul pied de page à maintenir, au lieu de 13 copies
 *
 * Conséquence : les pages ne sont complètes que servies par le backend. Ouvertes
 * en fichier ou par un serveur statique (live-server), elles n'ont ni en-tête
 * ni pied de page.
 */

const fs = require('fs');
const path = require('path');
const { localizeBody, lookup } = require('../utils/i18n-html');

const PARTIALS_DIR = 'partials';

// Les polices ne sont PAS versionnées : les @font-face de core.min.css les
// appellent sans paramètre. Un preload `fonts/x.woff2?v=…` est une autre URL
// pour le navigateur : il n'était jamais consommé et chaque police était
// téléchargée deux fois. Leurs noms sont stables et leur cache déjà immuable.
const ASSET_PATTERNS = [
  // <link rel="stylesheet" href="css/foo.css">  ou  href="/css/foo.css"
  { re: /(<link[^>]+href=")(\/?css\/[^"?]+\.css)(")/g, kind: 'css' },
  // <script src="js/foo.js">  ou  src="/js/foo.js"
  { re: /(<script[^>]+src=")(\/?js\/[^"?]+\.js)(")/g, kind: 'js' },
  // <img src="...">  (rare en HTML statique mais on couvre)
  { re: /(<img[^>]+src=")(\/?(?:images|img)\/[^"?]+\.(?:png|jpe?g|webp|avif|svg))(")/g, kind: 'img' },
];

// Lien actif et variantes de l'en-tête, par page (nom du fichier sans .html).
// active  : href du lien de navigation principal à marquer comme page courante
// current : entrée du menu compte à marquer (login, settings)
const PAGE_OPTIONS = {
  index: { active: '/' },
  hangar: { active: '/hangar' },
  timeline: { active: '/timeline' },
  favorites: { active: '/favorites' },
  login: { current: 'login', active: '/login' },
  settings: { current: 'settings', active: '/settings' },
  conflits: { active: '/conflits' },
};

/* Opt-in des transitions entre pages (frontend/css/shared-morph.css),
 * répété EN LIGNE en tête de <head> : une extension qui fait calculer les
 * styles avant l'arrivée de core.min.css (bloqueur de bandeaux cookies du
 * propriétaire) laissait Chrome voir une page sans opt-in, et la transition
 * était annulée à l'arrivée (« ViewTransition opt-in disabled »). Le nonce
 * CSP est posé à l'envoi (injectCspNonce, app.js). */
const MORPH_OPT_IN = '<style>@view-transition{navigation:auto}' +
  '@media (prefers-reduced-motion:reduce){@view-transition{navigation:none}}</style>';

/** Insère MORPH_OPT_IN juste après <head>, une seule fois. */
function injectMorphOptIn(html) {
  if (html.includes('@view-transition{navigation:auto}')) return html;
  return html.replace(/<head(\s[^>]*)?>/i, (m) => `${m}\n  ${MORPH_OPT_IN}`);
}

/* Recherche du site proposée par le navigateur (frontend/opensearch.xml). */
const OPENSEARCH_LINK = '<link rel="search" type="application/opensearchdescription+xml" ' +
  'title="Vol d&#39;Histoire" href="/opensearch.xml">';

/** Insère OPENSEARCH_LINK juste avant </head>, une seule fois. */
function injectOpenSearchLink(html) {
  if (html.includes('rel="search"')) return html;
  return html.replace(/<\/head>/i, (m) => `  ${OPENSEARCH_LINK}\n${m}`);
}

/** Ajouts communs à toutes les pages servies (gabarits SSR compris). */
function injectHeadExtras(html) {
  return injectOpenSearchLink(injectMorphOptIn(html));
}

const INCLUDE_RE = /^[ \t]*<!--\s*@include\s+([a-z0-9-]+)\s*-->[ \t]*(\r?)$/gm;

function rewrite(html, version) {
  let out = html;
  for (const { re } of ASSET_PATTERNS) {
    out = out.replace(re, (_, before, url, after) => {
      // N'ajoute pas le query string si déjà présent
      if (url.includes('?')) return before + url + after;
      return `${before}${url}?v=${version}${after}`;
    });
  }
  return out;
}

/**
 * Lit les fragments de frontend/partials/ (sans le retour à la ligne final).
 * @returns {Map<string, string>} nom → contenu, fins de ligne en LF
 */
function loadPartials(frontendDir) {
  const partials = new Map();
  const dir = path.join(frontendDir, PARTIALS_DIR);
  let entries = [];
  try { entries = fs.readdirSync(dir); } catch { return partials; }
  for (const file of entries) {
    if (!file.endsWith('.html')) continue;
    const content = fs.readFileSync(path.join(dir, file), 'utf8')
      .replace(/\r\n/g, '\n')
      .replace(/\n+$/, '');
    partials.set(file.slice(0, -5), content);
  }
  return partials;
}

/** Applique les variantes de page aux marqueurs {{active:…}} / {{current:…}}. */
function applyPageOptions(content, pageName) {
  const opts = PAGE_OPTIONS[pageName] || {};
  return content
    .replace(/\{\{active:([^}]+)\}\}/g, (_, href) =>
      (opts.active === href ? ' class="active" aria-current="page"' : ''))
    .replace(/\{\{current:([a-z-]+)\}\}/g, (_, key) => (opts.current === key ? ' active' : ''));
}

/**
 * Remplace les marqueurs `<!-- @include nom -->` (seuls sur leur ligne) par le
 * fragment correspondant. Un nom inconnu laisse le marqueur en place et est
 * signalé dans `warnings` : la page reste servie, l'oubli se voit au boot.
 *
 * @param {string} html - page source
 * @param {string} pageName - nom du fichier sans .html (index, hangar…)
 * @param {Map<string, string>} partials - fragments chargés par loadPartials
 * @param {string[]} [warnings] - collecte des marqueurs non résolus
 */
function resolveIncludes(html, pageName, partials, warnings = []) {
  const crlf = html.includes('\r\n');
  return html.replace(INCLUDE_RE, (marker, name, cr) => {
    const partial = partials.get(name);
    if (partial === undefined) {
      warnings.push(`${pageName}: fragment inconnu « ${name} »`);
      return marker;
    }
    const content = applyPageOptions(partial, pageName);
    return (crlf ? content.replace(/\n/g, '\r\n') : content) + cr;
  });
}

// ---------------------------------------------------------------------------
// Versions linguistiques des pages statiques
// ---------------------------------------------------------------------------
// Chaque page existe en deux versions : le français à l'URL nue (aussi
// x-default), l'anglais à ?lang=en. La version anglaise est servie avec
// <html lang="en">, le titre et la description traduits (frontend/locales/
// en.json : clé data-i18n du <title>, seo.description.<page>), og:locale
// en_US, et un canonical auto-référent (…?lang=en) : une URL alternative qui
// se canonicalise ailleurs est ignorée par les moteurs.

const SUPPORTED_LANGS = ['fr', 'en'];

function loadDictionary(frontendDir, lang) {
  try {
    return JSON.parse(fs.readFileSync(path.join(frontendDir, 'locales', `${lang}.json`), 'utf8'));
  } catch {
    return {};
  }
}


function escapeAttr(str) {
  return String(str).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

// Types de page dont le nom est celui de la page (le WebSite garde le nom du site).
const JSONLD_PAGE_TYPES = new Set(['WebPage', 'CollectionPage', 'ContactPage', 'AboutPage']);

/**
 * Libellés de navigation français → anglais (fil d'Ariane des JSON-LD :
 * « Accueil » → « Home », « Conflits » → « Conflicts »…).
 */
function navLabels(frDict, enDict) {
  const map = new Map();
  const fr = (frDict && frDict.nav) || {};
  const en = (enDict && enDict.nav) || {};
  Object.keys(fr).forEach((k) => { if (typeof en[k] === 'string') map.set(fr[k], en[k]); });
  return map;
}

/**
 * Données structurées en anglais (HTML-003) : inLanguage, nom et description
 * de la page, libellés du fil d'Ariane. Un bloc illisible reste tel quel.
 */
function localizeJsonLd(html, { title, description, labels }) {
  const translate = (node, isRoot) => {
    if (Array.isArray(node)) return node.map((n) => translate(n, false));
    if (!node || typeof node !== 'object') return node;
    const out = {};
    Object.entries(node).forEach(([k, v]) => { out[k] = translate(v, false); });
    if (out.inLanguage === 'fr') out.inLanguage = 'en';
    if (isRoot && description && typeof out.description === 'string') out.description = description;
    if (isRoot && title && JSONLD_PAGE_TYPES.has(out['@type'])) out.name = title;
    if (out['@type'] === 'ListItem' && labels.has(out.name)) out.name = labels.get(out.name);
    return out;
  };
  return html.replace(/(<script type="application\/ld\+json"[^>]*>)([\s\S]*?)(<\/script>)/g, (match, open, body, close) => {
    let data;
    try { data = JSON.parse(body); } catch { return match; }
    const json = JSON.stringify(translate(data, true), null, 2).replace(/</g, '\\u003c');
    return `${open}\n${json}\n  ${close}`;
  });
}

/**
 * Réécrit la tête d'une page dans une langue. Tous les remplacements passent
 * par une fonction (un « $& » d'une traduction reste du texte).
 * @param {string} html - page déjà assemblée (inclusions, ?v=)
 * @param {string} pageName - nom du fichier sans .html
 * @param {'fr'|'en'} lang
 * @param {object} dict - traductions de la langue (locales/<lang>.json)
 */
/** Manifeste PWA anglais (MOB-001) : nom des raccourcis, description, captures. */
function localizeManifest(html) {
  return html.replace('<link rel="manifest" href="/manifest.webmanifest">', () => '<link rel="manifest" href="/manifest.en.webmanifest">');
}

function localizeHead(html, pageName, lang, dict, frDict = {}) {
  let out = html;
  const canonical = /<link rel="canonical" href="([^"?#]+)">/.exec(out);
  const base = canonical ? canonical[1] : null;
  // hreflang fr : l'URL nue, servie en français (même URL que x-default).
  if (base) {
    out = out.replace(/<link rel="alternate" hreflang="fr" href="[^"]*">/,
      () => `<link rel="alternate" hreflang="fr" href="${base}">`);
  }
  if (lang !== 'en') return out;

  out = out.replace(/<html lang="fr">/, () => '<html lang="en">');
  out = localizeManifest(out);
  out = out.replace(/<meta property="og:locale" content="[^"]*">/,
    () => '<meta property="og:locale" content="en_US">');
  if (base) {
    const self = `${base}?lang=en`;
    out = out.replace(/<link rel="canonical" href="[^"]*">/, () => `<link rel="canonical" href="${self}">`);
    out = out.replace(/<meta property="og:url" content="[^"]*">/, () => `<meta property="og:url" content="${self}">`);
  }
  const titleKey = /<title data-i18n="([^"]+)">/.exec(out);
  const title = titleKey && lookup(dict, titleKey[1]);
  if (title) {
    const t = escapeAttr(title);
    out = out.replace(/(<title data-i18n="[^"]+">)[^<]*(<\/title>)/, (_, open, close) => open + t + close);
    out = out.replace(/<meta property="og:title" content="[^"]*">/, () => `<meta property="og:title" content="${t}">`);
    out = out.replace(/<meta name="twitter:title" content="[^"]*">/, () => `<meta name="twitter:title" content="${t}">`);
  }
  const description = lookup(dict, `seo.description.${pageName}`);
  if (description) {
    const d = escapeAttr(description);
    out = out.replace(/<meta name="description" content="[^"]*">/, () => `<meta name="description" content="${d}">`);
    out = out.replace(/<meta property="og:description" content="[^"]*">/, () => `<meta property="og:description" content="${d}">`);
    out = out.replace(/<meta name="twitter:description" content="[^"]*">/, () => `<meta name="twitter:description" content="${d}">`);
  }
  // Texte alternatif de l'image de partage (pages statiques : og-default.jpg).
  const imageAlt = lookup(dict, 'seo.og_image_alt');
  if (imageAlt) {
    const a = escapeAttr(imageAlt);
    out = out.replace(/<meta property="og:image:alt" content="[^"]*">/, () => `<meta property="og:image:alt" content="${a}">`);
    out = out.replace(/<meta name="twitter:image:alt" content="[^"]*">/, () => `<meta name="twitter:image:alt" content="${a}">`);
  }
  return localizeJsonLd(out, { title, description, labels: navLabels(frDict, dict) });
}

/**
 * Lit une page de frontend/ et lui applique inclusions + cache-busting.
 * Utilisé par les routes SSR (details, conflits) pour leur gabarit. En
 * anglais, les textes d'interface du corps sont traduits (SEO-002) ; le
 * contenu propre à la page est écrit ensuite par la route.
 * @param {'fr'|'en'} [lang='fr']
 * @returns {string} '' si le fichier est absent (tests)
 */
function renderTemplate(frontendDir, fileName, version, lang = 'fr') {
  try {
    const raw = fs.readFileSync(path.join(frontendDir, fileName), 'utf8');
    const html = injectHeadExtras(rewrite(resolveIncludes(raw, path.basename(fileName, '.html'), loadPartials(frontendDir)), version));
    return lang === 'en' ? localizeManifest(localizeBody(html, loadDictionary(frontendDir, 'en'))) : html;
  } catch {
    return '';
  }
}

/**
 * @param {string} frontendDir - chemin absolu vers frontend/
 * @param {string} version - version à utiliser dans ?v=
 * @returns {{ get: (filePath: string, lang?: string) => string|null, has: (filePath: string) => boolean, version: string, count: number, warnings: string[] }}
 *   get(filePath, lang) : version 'en' si lang === 'en', française sinon.
 */
function buildHtmlCache(frontendDir, version) {
  const cache = new Map();
  const partials = loadPartials(frontendDir);
  const dictionaries = { en: loadDictionary(frontendDir, 'en'), fr: loadDictionary(frontendDir, 'fr') };
  const warnings = [];
  // Pages impossibles à préparer (lecture, inclusions, localisation) : elles
  // ne sont pas mises en cache et seraient servies brutes (JS-006).
  const errors = [];
  let count = 0;

  function walk(dir) {
    let entries;
    try { entries = fs.readdirSync(dir, { withFileTypes: true }); }
    catch { return; }
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        // Skip node_modules, fonts, dist, .git — et les fragments, qui ne
        // sont pas des pages.
        if (['node_modules', 'fonts', 'dist', '.git', PARTIALS_DIR].includes(entry.name)) continue;
        walk(full);
        continue;
      }
      if (!entry.isFile()) continue;
      if (!entry.name.endsWith('.html')) continue;
      try {
        const raw = fs.readFileSync(full, 'utf8');
        const pageName = entry.name.slice(0, -5);
        const html = injectHeadExtras(rewrite(resolveIncludes(raw, pageName, partials, warnings), version));
        cache.set(full, {
          fr: localizeHead(html, pageName, 'fr', {}),
          // Tête et corps traduits : menus, titres, textes d'attente (SEO-002).
          en: localizeBody(localizeHead(html, pageName, 'en', dictionaries.en, dictionaries.fr), dictionaries.en),
        });
        count++;
      } catch (err) {
        errors.push({ file: path.relative(frontendDir, full), message: err.message });
      }
    }
  }

  walk(frontendDir);

  return {
    version,
    count,
    warnings,
    errors,
    has: (p) => cache.has(p),
    get: (p, lang) => {
      const variants = cache.get(p);
      if (!variants) return null;
      return variants[SUPPORTED_LANGS.includes(lang) ? lang : 'fr'];
    },
    rewrite: (html) => rewrite(html, version),
  };
}

module.exports = {
  buildHtmlCache, rewrite, resolveIncludes, loadPartials, renderTemplate, localizeHead, localizeJsonLd, PAGE_OPTIONS,
  injectMorphOptIn, MORPH_OPT_IN, injectOpenSearchLink, OPENSEARCH_LINK, injectHeadExtras,
};
