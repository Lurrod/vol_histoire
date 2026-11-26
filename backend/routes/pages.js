'use strict';
const fs = require('fs');
const path = require('path');
const express = require('express');
const logger = require('../logger');
const timelinePayload = require('../utils/timeline-payload');
const timelineSsr = require('../utils/timeline-ssr');
const heroPayload = require('../utils/hero-payload');
const homeSsr = require('../utils/home-ssr');

// Pages servies depuis le cache HTML sous leur URL propre.
const HTML_PAGES = [
  'hangar', 'timeline', 'favorites', 'login', 'settings',
  'contact', 'mentions-legales',
  'politique-confidentialite', 'cgu',
];

// Pages personnelles, jamais indexées : noindex aussi en en-tête HTTP
// (SEO-006), en plus de la balise meta de la page.
const NOINDEX_PAGES = new Set(['favorites', 'login', 'settings']);

// Anciennes pages des liens email (activation, mot de passe oublié, « vérifiez
// votre boîte ») : tout passe désormais par un code saisi sur /login. Les liens
// déjà envoyés et les favoris mènent à la connexion ; le jeton éventuel n'est
// jamais recopié dans la redirection, la réponse n'est pas mise en cache et ne
// transmet aucun Referer.
const LEGACY_AUTH_PAGES = {
  'verify-email': '/login',
  'check-email': '/login',
  'reset-password': '/login#mot-de-passe-oublie',
  'forgot-password': '/login#mot-de-passe-oublie',
};

/**
 * Rendu serveur mémorisé : la page en cache reçoit la charge utile rendue
 * dans la langue de la requête. Le HTML produit est gardé par langue tant que
 * la charge utile et la page ne changent pas.
 */
function memoRenderer(render) {
  const memo = new Map();
  return (page, json, lang) => {
    const hit = memo.get(lang);
    if (hit && hit.json === json && hit.page === page) return hit.html;
    const html = render(page, JSON.parse(json), lang);
    memo.set(lang, { json, page, html });
    return html;
  };
}

/**
 * Routes des pages HTML : accueil et frise rendues côté serveur, pages
 * statiques, anciennes pages d'authentification.
 * @param {{ getPool: Function, frontendRoot: string, assetVersion: string,
 *           pages: ReturnType<import('../utils/html-pages').createHtmlPages> }} deps
 */
function createPagesRouter({ getPool, frontendRoot, assetVersion, pages }) {
  const router = express.Router();
  const { htmlCache, sendCachedHtml, sendRenderedPage } = pages;

  // /timeline : la page en cache reçoit le texte des chapitres (récits,
  // événements, conflits, appareils), rendu par le serveur dans la langue de la
  // requête — sans lui, un robot qui n'exécute pas de script n'en voyait que la
  // couverture. Échec de la base ou du rendu : la page part sans chapitres, le
  // script les charge comme avant.
  const renderTimeline = memoRenderer((page, payload, lang) => timelineSsr.injectChapters(page, payload, lang));
  router.get('/timeline', async (req, res, next) => {
    const cached = htmlCache.get(path.join(frontendRoot, 'timeline.html'), req.lang);
    if (cached === null) return next();
    let html = cached;
    try {
      const { json } = await timelinePayload.loadPayloadJson(getPool());
      html = renderTimeline(cached, json, req.lang === 'en' ? 'en' : 'fr');
    } catch (err) {
      logger.warn('timeline : rendu serveur des chapitres impossible', { error: err.message });
    }
    return sendRenderedPage(res, html);
  });

  HTML_PAGES.forEach((page) => {
    router.get(`/${page}`, (req, res) => {
      if (NOINDEX_PAGES.has(page)) res.setHeader('X-Robots-Tag', 'noindex, nofollow');
      sendCachedHtml(res, path.join(frontendRoot, `${page}.html`));
    });
  });

  Object.entries(LEGACY_AUTH_PAGES).forEach(([page, target]) => {
    router.get(`/${page}`, (req, res) => {
      res.setHeader('Cache-Control', 'no-store');
      res.setHeader('Referrer-Policy', 'no-referrer');
      res.redirect(301, target);
    });
  });

  // Accueil : la photo de l'appareil du jour (élément LCP) est écrite dans le
  // HTML par le serveur (utils/home-ssr.js), pour que le navigateur la demande
  // dès la lecture de la page. Échec de la base : page servie sans, le script
  // la pose comme avant.
  const renderHome = memoRenderer((page, payload, lang) =>
    homeSsr.injectDayPhoto(page, payload, { lang, version: assetVersion }));
  router.get('/', async (req, res) => {
    const indexPath = path.join(frontendRoot, 'index.html');
    const cached = htmlCache.get(indexPath, req.lang);
    if (cached === null) return sendCachedHtml(res, indexPath);
    let html = cached;
    try {
      const { json } = await heroPayload.loadPayloadJson(getPool());
      html = renderHome(cached, json, req.lang === 'en' ? 'en' : 'fr');
    } catch (err) {
      logger.warn('accueil : photo du jour non écrite par le serveur', { error: err.message });
    }
    return sendRenderedPage(res, html);
  });

  return router;
}

// Pages physiques mais NON exposées en URL propre (fragments chargés par JS, fichiers de vérif tiers).
// Le fichier .html reste accessible via express.static (consommé par cookies.js fetch), mais
// l'URL propre /cookie-consent renvoie 404 — évite l'indexation d'un partial sans <html lang>.
const HIDDEN_CLEAN_URLS = new Set(['/cookie-consent']);

/**
 * Catch-all des URL propres : /hangar → hangar.html, etc. La redirection 301
 * des variantes (.html, majuscules, slash final) est faite par
 * canonicalPageRedirect, avant express.static. Express 5 / path-to-regexp v6
 * rejette le wildcard '*' tel quel : un middleware en dernière position joue
 * le même rôle.
 */
function createCleanUrlFallback({ frontendRoot, pages }) {
  const { sendCachedHtml, sendNotFound } = pages;
  // Liste des pages HTML valides construite au démarrage (évite fs à chaque requête)
  const validPages = new Set();
  try {
    fs.readdirSync(frontendRoot).forEach((file) => {
      if (!file.endsWith('.html')) return;
      const cleanUrl = '/' + file.slice(0, -5); // /hangar, /details, /a-propos, etc.
      if (!HIDDEN_CLEAN_URLS.has(cleanUrl)) validPages.add(cleanUrl);
    });
  } catch { /* Silencieux si le dossier n'existe pas encore (tests) */ }

  return async function cleanUrlFallback(req, res, next) {
    if (req.method !== 'GET' && req.method !== 'HEAD') return next();
    // Ignorer les requêtes API et les fichiers avec extension
    if (req.path.startsWith('/api/') || path.extname(req.path)) return next();

    // URLs propres masquées (fragment cookie-consent etc.) : 404 immédiat sans
    // tomber sur le fichier .html, qui reste atteignable uniquement via /xxx.html.
    // /404 est une vraie page d'erreur : statut 404, jamais un 200 indexable.
    if (HIDDEN_CLEAN_URLS.has(req.path) || req.path === '/404') return sendNotFound(req, res);

    if (validPages.has(req.path)) {
      return sendCachedHtml(res, path.join(frontendRoot, req.path + '.html'));
    }

    // Fallback async pour les pages ajoutées dynamiquement après le démarrage
    const htmlFile = path.join(frontendRoot, req.path + '.html');
    try {
      await fs.promises.access(htmlFile, fs.constants.F_OK);
      return sendCachedHtml(res, htmlFile);
    } catch {
      return sendNotFound(req, res);
    }
  };
}

module.exports = { createPagesRouter, createCleanUrlFallback };
