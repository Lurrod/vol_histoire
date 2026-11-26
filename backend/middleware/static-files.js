'use strict';
const path = require('path');
const { versionedAssetCache } = require('../utils/asset-cache');

// -----------------------------------------------------------------------------
// Fichiers statiques : en-têtes de cache et URL canoniques des pages
// -----------------------------------------------------------------------------
// Cache headers : 30 jours sur fonts (immutable), 1 an sur les fichiers dont
// l'URL porte un ?v= (le bump de version suffit à invalider), 1 jour sur le
// reste, pas de cache sur HTML (rendu dynamique potentiel + invalidation rapide).
const IMAGE_EXTS = new Set(['.svg', '.png', '.jpg', '.jpeg', '.webp', '.avif', '.ico']);

function isVersionedRequest(req) {
  const url = (req && (req.originalUrl || req.url)) || '';
  const q = url.indexOf('?');
  return q >= 0 && /(?:^|&)v=[^&]+/.test(url.slice(q + 1));
}

// -----------------------------------------------------------------------------
// URL canoniques des pages : 301 AVANT express.static
// -----------------------------------------------------------------------------
// Sans cela, express.static servait /index.html, /hangar.html… tels quels :
// hors du cache HTML, donc sans ?v= sur les assets ni nonce sur le <style>
// critique (bloqué par la CSP), et sans en-tête ni pied de page (inclusions).
// Express ignorant la casse et le slash final, /HANGAR et /hangar/ répondaient
// aussi 200 : autant d'URL en double.
// Exceptions : les fichiers qui ne sont demandés que sous leur nom complet.
const HTML_FILE_EXCEPTIONS = new Set([
  '/cookie-consent.html',          // fragment chargé par cookies.js (fetch)
  '/googleb250c8eb3ae5dfa7.html',  // vérification Google Search Console
]);

function canonicalPagePath(p) {
  let target = p;
  if (/\.html$/i.test(target)) target = target.slice(0, -5);
  // Seules les pages (sans extension) sont normalisées : un asset garde sa casse.
  if (!path.extname(target)) {
    target = target.toLowerCase();
    if (target.length > 1) target = target.replace(/\/+$/, '');
    if (target === '' || target === '/index') target = '/';
  }
  return target;
}

function canonicalPageRedirect(req, res, next) {
  if (req.method !== 'GET' && req.method !== 'HEAD') return next();
  const p = req.path;
  if (p === '/api' || p.startsWith('/api/') || p.startsWith('/.well-known/')) return next();
  if (HTML_FILE_EXCEPTIONS.has(p)) return next();
  // Garde anti-redirection ouverte : « //domaine » ou « /\domaine » dans un
  // Location serait lu comme une URL d'un autre site.
  if (p.startsWith('//') || p.includes('\\')) return next();
  const target = canonicalPagePath(p);
  if (target === p) return next();
  const query = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
  return res.redirect(301, target + query);
}

function setStaticHeaders(res, filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const base = path.basename(filePath).toLowerCase();
  if (base === 'sw.js') {
    // Service worker : pas de cache pour que les updates soient déployées
    // immédiatement. Les browsers capent de toute façon la revérification à 24h.
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    res.setHeader('Service-Worker-Allowed', '/');
  } else if (base === 'opensearch.xml') {
    // Description OpenSearch : type exigé par les navigateurs pour proposer
    // la recherche du site dans la barre d'adresse.
    res.setHeader('Content-Type', 'application/opensearchdescription+xml; charset=utf-8');
    res.setHeader('Cache-Control', 'public, max-age=86400');
  } else if (ext === '.webmanifest') {
    // Manifest PWA : revalider à chaque nav. Assez petit pour que ce ne soit
    // pas un souci bandwidth.
    res.setHeader('Cache-Control', 'public, max-age=3600, must-revalidate');
    res.setHeader('Content-Type', 'application/manifest+json; charset=utf-8');
  } else if (ext === '.html') {
    res.setHeader('Cache-Control', 'no-cache');
  } else if (ext === '.woff2' || ext === '.woff') {
    // Fonts : long cache + immutable (le contenu ne change jamais)
    res.setHeader('Cache-Control', 'public, max-age=2592000, immutable');
  } else if (ext === '.css' || ext === '.js') {
    // Les CSS et JS sont servis avec ?v=<version> : le contenu d'une URL
    // donnée ne change jamais, donc un an de cache immuable — sauf en
    // développement, où la version ne bouge pas (utils/asset-cache.js).
    res.setHeader('Cache-Control', versionedAssetCache(process.env));
  } else if (IMAGE_EXTS.has(ext)) {
    // Images : une URL versionnée (?v=, posé par shared/picture.js et le
    // SSR des fiches) change à chaque release, donc un an immuable. Sans
    // version (og:image, JSON-LD, favicons, logos), une photo peut être
    // remplacée sous le même nom : une journée, revalidée en arrière-plan.
    res.setHeader('Cache-Control', isVersionedRequest(res.req)
      ? versionedAssetCache(process.env)
      : 'public, max-age=86400, s-maxage=604800, stale-while-revalidate=604800');
  }
}

const STATIC_OPTS = {
  // Pas de 301 « répertoire → répertoire/ » : canonicalPageRedirect retire le
  // slash final, les deux se renvoyaient la balle (/css/ ↔ /css) à l'infini.
  // Un répertoire n'a rien à servir (pas d'index) : il finit en 404.
  redirect: false,
  setHeaders: setStaticHeaders,
};

module.exports = { STATIC_OPTS, canonicalPageRedirect, canonicalPagePath, isVersionedRequest };
