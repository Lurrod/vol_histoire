'use strict';

/**
 * SSR léger pour /conflits et /conflits/:slug.
 *
 * Même principe que details-ssr.js : sans réécriture côté serveur, chaque
 * conflit serait indexé sous le titre et la description génériques de
 * conflits.html. On injecte <title>, meta description, canonical, hreflang,
 * og:* (image comprise), twitter:*, un fil d'Ariane JSON-LD et le <h1> du
 * conflit, dans la langue de la requête ; le contenu est ensuite rendu en JS.
 * Un slug inconnu tombe dans le 404 standard (next()).
 */

const path = require('path');
const express = require('express');
const { renderTemplate } = require('../middleware/serveHtml');
const { slugify } = require('../utils/url');
const {
  SITE_URL, DEFAULT_OG_IMAGE,
  escapeHtml, truncate, toAbsoluteUrl, jsonLdScript, breadcrumbLd, langUrl,
  applyHeadMeta, replaceJsonLd, sendSsrHtml,
} = require('../utils/ssr-head');
const { listEngagedWars } = require('../repositories/ssr-conflicts');

const FRONTEND_DIR = path.join(__dirname, '../../frontend');
const MAX_DESC = 160;
const LIST_URL = `${SITE_URL}/conflits`;

function readVersion() {
  try { return require('../package.json').version || 'dev'; } catch { return 'dev'; }
}

// Fil d'Ariane : chaque maillon vise la version de la page dans la langue
// servie (l'URL nue en français, ?lang=en en anglais).
function crumbs(lang, last) {
  const isEn = lang === 'en';
  const items = [
    { name: isEn ? 'Home' : 'Accueil', url: `${SITE_URL}/` },
    { name: isEn ? 'Conflicts' : 'Conflits', url: LIST_URL },
  ];
  if (last) items.push(last);
  return breadcrumbLd(items.map(it => ({ ...it, url: langUrl(it.url, lang) })));
}

/** Données de tête de la liste des conflits. */
function buildConflictsIndexMeta(lang) {
  const isEn = lang === 'en';
  return {
    lang: isEn ? 'en' : 'fr',
    title: isEn ? "Conflicts | Vol d'Histoire" : "Conflits | Vol d'Histoire",
    description: isEn
      ? 'Armed conflicts since 1945 and the military aircraft committed to them, from Indochina to Ukraine.'
      : "Les conflits armés depuis 1945 et les appareils militaires qui y ont été engagés, de la guerre d'Indochine à l'Ukraine.",
    url: LIST_URL,
    image: DEFAULT_OG_IMAGE,
    imageAlt: isEn ? "Vol d'Histoire — military aviation encyclopedia" : "Vol d'Histoire — encyclopédie de l'aviation militaire",
    breadcrumb: crumbs(lang),
  };
}

/**
 * Données de tête d'une page de conflit.
 * @param {object} war - ligne de listEngagedWars
 * @param {string} slug - slug canonique (dérivé du nom français)
 * @param {'fr'|'en'} lang
 */
function buildConflictMeta(war, slug, lang) {
  const isEn = lang === 'en';
  const name = (isEn && war.name_en) || war.name;
  const desc = (isEn && war.description_en) || war.description || '';
  const y1 = war.date_start ? new Date(war.date_start).getFullYear() : null;
  const y2 = war.date_end ? new Date(war.date_end).getFullYear() : null;
  let years = '';
  if (y1) {
    if (y2 && y2 !== y1) years = ` (${y1}-${y2})`;
    else if (y2) years = ` (${y1})`;
    else years = ` (${isEn ? 'since' : 'depuis'} ${y1})`;
  }
  const url = `${LIST_URL}/${slug}`;
  return {
    lang: isEn ? 'en' : 'fr',
    name,
    title: `${name}${years} | Vol d'Histoire`,
    description: truncate(desc || (isEn
      ? `The military aircraft committed to the ${name}.`
      : `Les appareils militaires engagés : ${name}.`), MAX_DESC),
    url,
    // Photo d'un appareil engagé, à défaut le visuel par défaut du site.
    image: war.image_url ? toAbsoluteUrl(war.image_url) : DEFAULT_OG_IMAGE,
    imageAlt: name,
    breadcrumb: crumbs(lang, { name, url }),
  };
}

/**
 * Gabarit conflits.html → HTML de la page.
 * @param {string} template
 * @param {object} meta - buildConflictsIndexMeta ou buildConflictMeta
 * @param {string} [h1] - titre de la page de conflit (absent pour la liste)
 */
function renderHtml(template, meta, h1) {
  let html = applyHeadMeta(template, meta);
  html = replaceJsonLd(html, [jsonLdScript('jsonld-breadcrumb', meta.breadcrumb)]);
  if (h1) {
    // Le titre du conflit est en dur pour les robots ; data-i18n-html est
    // retiré pour que la traduction côté client ne le remplace pas.
    html = html.replace(
      /<h1 id="page-hero-heading"[^>]*>[\s\S]*?<\/h1>/,
      () => `<h1 id="page-hero-heading">${escapeHtml(h1)}</h1>`
    );
  }
  return html;
}

function createConflictsSsrRouter(getPool) {
  const router = express.Router();
  const template = renderTemplate(FRONTEND_DIR, 'conflits.html', readVersion());

  router.get('/conflits', (req, res, next) => {
    if (!template) return next();
    sendSsrHtml(req, res, renderHtml(template, buildConflictsIndexMeta(req.lang)));
  });

  router.get('/conflits/:slug', async (req, res, next) => {
    try {
      if (!template) return next();
      const slug = String(req.params.slug || '');
      if (!/^[a-z0-9-]{1,120}$/.test(slug)) return next();

      const rows = await listEngagedWars(getPool());
      const war = rows.find(r => slugify(r.name) === slug);
      if (!war) return next(); // 404 standard

      const meta = buildConflictMeta(war, slug, req.lang);
      sendSsrHtml(req, res, renderHtml(template, meta, meta.name));
    } catch (err) {
      next(err);
    }
  });

  return router;
}

module.exports = createConflictsSsrRouter;
module.exports.buildConflictMeta = buildConflictMeta;
module.exports.buildConflictsIndexMeta = buildConflictsIndexMeta;
module.exports.renderHtml = renderHtml;
