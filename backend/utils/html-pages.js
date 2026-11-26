'use strict';
const fs = require('fs');
const path = require('path');
const logger = require('../logger');
const { buildHtmlCache } = require('../middleware/serveHtml');
const { injectCspNonce } = require('../middleware/security-headers');
const { keepBareCanonical } = require('./ssr-head');

// Réponse 404 unique, deux formats seulement : JSON sous /api, page 404 du
// site partout ailleurs (fichiers de dev bloqués, ressources absentes, méthodes
// non routées). Les pages par défaut d'Express (« Cannot GET /api/login ») et
// le « Not Found » en texte brut signalaient la pile et ce qui était caché.
const API_NOT_FOUND = Object.freeze({ message: 'Ressource introuvable' });

function isApiPath(urlPath) {
  return urlPath === '/api' || urlPath.startsWith('/api/');
}

/**
 * Cache HTML : au boot, on lit tous les *.html et on injecte ?v=<version>
 * sur les références asset (css/js/fonts) pour bust le cache navigateur à
 * chaque déploiement. Coût runtime = 0 (lecture une fois, sert depuis Map).
 * @param {{ frontendRoot: string, assetVersion: string }} options
 */
function createHtmlPages({ frontendRoot, assetVersion }) {
  const htmlCache = buildHtmlCache(frontendRoot, assetVersion);
  if (logger.info) logger.info('HTML cache initialisé', { count: htmlCache.count, version: assetVersion });
  // Marqueur <!-- @include x --> sans fragment frontend/partials/x.html : la
  // page est servie avec le marqueur, l'oubli doit se voir au démarrage.
  htmlCache.warnings.forEach((w) => logger.warn && logger.warn('Inclusion HTML non résolue', { detail: w }));
  // Page impossible à préparer : elle partirait brute (sans inclusions, sans
  // ?v=, sans version anglaise). Journalisée ; en production le démarrage est
  // refusé, ce qui fait échouer les tests de fumée et déclenche le retour
  // arrière du déploiement (JS-006).
  if (htmlCache.errors && htmlCache.errors.length) {
    htmlCache.errors.forEach((e) => logger.error && logger.error('Page HTML non préparée', e));
    if (process.env.NODE_ENV === 'production') {
      throw new Error(`Pages HTML non préparées : ${htmlCache.errors.map((e) => e.file).join(', ')}`);
    }
  }

  function sendCachedHtml(res, filePath) {
    // Variante anglaise (lang, title, description, og, canonical) si req.lang === 'en' :
    // la langue vient de ?lang= puis d'Accept-Language, d'où le Vary.
    const cached = htmlCache.get(filePath, res.req && res.req.lang);
    if (cached !== null) {
      res.vary('Accept-Language');
      res.set('Content-Type', 'text/html; charset=utf-8');
      return res.send(injectCspNonce(keepBareCanonical(cached, res.req), res.locals.cspNonce));
    }
    // Fallback : fichier ajouté après le boot. Lu puis nonçé comme les autres :
    // servi brut, ses scripts seraient bloqués par 'strict-dynamic'.
    return fs.promises.readFile(filePath, 'utf8')
      .then((html) => {
        res.set('Content-Type', 'text/html; charset=utf-8');
        res.send(injectCspNonce(html, res.locals.cspNonce));
      })
      .catch(() => res.status(404).send('Page non trouvée'));
  }

  function sendNotFound(req, res) {
    res.status(404);
    if (isApiPath(req.baseUrl + req.path)) return res.json(API_NOT_FOUND);
    return sendCachedHtml(res, path.join(frontendRoot, '404.html'));
  }

  // Page rendue côté serveur à partir de la page en cache : le HTML produit
  // est gardé par langue tant que la charge utile ne change pas ; seule
  // l'injection du nonce reste faite à chaque requête.
  function sendRenderedPage(res, html) {
    res.vary('Accept-Language');
    res.set('Content-Type', 'text/html; charset=utf-8');
    res.send(injectCspNonce(keepBareCanonical(html, res.req), res.locals.cspNonce));
  }

  return { htmlCache, sendCachedHtml, sendNotFound, sendRenderedPage };
}

module.exports = { createHtmlPages, isApiPath };
