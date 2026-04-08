/**
 * Cache-busting HTML middleware.
 *
 * Au boot, lit tous les *.html du dossier frontend/, ajoute `?v=<version>`
 * sur chaque référence à css/, js/ ou fonts/, puis cache le résultat en mémoire.
 *
 * Bénéfices :
 *  - Cache navigateur ultra-long (1 an) sans risque de servir un vieux JS
 *    après un déploiement : le query string change → URL différente → re-fetch
 *  - 0 coût runtime : la transformation est faite une fois au démarrage
 *  - Aucune modification des HTML sources sur disque (dev workflow intact)
 */

const fs = require('fs');
const path = require('path');

const ASSET_PATTERNS = [
  // <link rel="stylesheet" href="css/foo.css">  ou  href="/css/foo.css"
  { re: /(<link[^>]+href=")(\/?css\/[^"?]+\.css)(")/g, kind: 'css' },
  // <link rel="preload" href="fonts/foo.woff2"  ou href="/fonts/..."
  { re: /(<link[^>]+href=")(\/?fonts\/[^"?]+\.woff2?)(")/g, kind: 'font' },
  // <script src="js/foo.js">  ou  src="/js/foo.js"
  { re: /(<script[^>]+src=")(\/?js\/[^"?]+\.js)(")/g, kind: 'js' },
  // <img src="...">  (rare en HTML statique mais on couvre)
  { re: /(<img[^>]+src=")(\/?(?:images|img)\/[^"?]+\.(?:png|jpe?g|webp|avif|svg))(")/g, kind: 'img' },
];

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
 * @param {string} frontendDir - chemin absolu vers frontend/
 * @param {string} version - version à utiliser dans ?v=
 * @returns {{ get: (filePath: string) => string|null, has: (filePath: string) => boolean, version: string, count: number }}
 */
function buildHtmlCache(frontendDir, version) {
  const cache = new Map();
  let count = 0;

  function walk(dir) {
    let entries;
    try { entries = fs.readdirSync(dir, { withFileTypes: true }); }
    catch { return; }
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        // Skip node_modules, fonts, dist, .git
        if (['node_modules', 'fonts', 'dist', '.git'].includes(entry.name)) continue;
        walk(full);
        continue;
      }
      if (!entry.isFile()) continue;
      if (!entry.name.endsWith('.html')) continue;
      try {
        const raw = fs.readFileSync(full, 'utf8');
        cache.set(full, rewrite(raw, version));
        count++;
      } catch { /* ignore */ }
    }
  }

  walk(frontendDir);

  return {
    version,
    count,
    has: (p) => cache.has(p),
    get: (p) => cache.get(p) || null,
    rewrite: (html) => rewrite(html, version),
  };
}

module.exports = { buildHtmlCache, rewrite };
