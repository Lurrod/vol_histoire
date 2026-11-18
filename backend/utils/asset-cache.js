'use strict';

// Cache des fichiers statiques versionnés (CSS, JS, images en ?v=<version>).
//
// En production, le bump de version change l'URL : son contenu ne change
// jamais, d'où un an de cache immuable. En développement, la version reste
// la même d'une modification à l'autre : avec ce cache, le navigateur
// gardait l'ancienne feuille et l'on « vérifiait » un rendu périmé. Il
// revalide donc à chaque chargement (ETag, réponse 304 si rien n'a bougé).

const IMMUTABLE = 'public, max-age=31536000, immutable';
const REVALIDATE = 'no-cache';

/** Développement = ni production ni tests (même règle que captchaKeys). */
function isDevelopment(env) {
  return env.NODE_ENV !== 'production' && env.NODE_ENV !== 'test';
}

function versionedAssetCache(env) {
  return isDevelopment(env) ? REVALIDATE : IMMUTABLE;
}

/** Valeur de ?v= posée dans les pages. En développement, elle change à
 *  chaque démarrage du serveur : les copies déjà mises en cache (y compris
 *  celles qu'un ancien en-tête « immutable » gardait un an) ne sont plus
 *  demandées. */
function assetVersion(pkgVersion, env, now = Date.now()) {
  return isDevelopment(env) ? `${pkgVersion}-dev${now.toString(36)}` : pkgVersion;
}

/** Version des assets de ce processus, calculée une fois : les pages en
 *  cache (app.js) et les rendus serveur (fiche, conflits) portent le même
 *  ?v=. */
let processVersion = null;
function currentAssetVersion() {
  if (processVersion === null) {
    let pkg = 'dev';
    try { pkg = require('../package.json').version || 'dev'; } catch { /* repli */ }
    processVersion = assetVersion(pkg, process.env);
  }
  return processVersion;
}

module.exports = { isDevelopment, versionedAssetCache, assetVersion, currentAssetVersion, IMMUTABLE };
