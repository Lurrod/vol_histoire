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
const warsRepo = require('../repositories/wars');
const logger = require('../logger');
const { applyList, applySides } = require('../utils/conflicts-links-ssr');
const { yearOf } = require('../utils/calendar-date');

const FRONTEND_DIR = path.join(__dirname, '../../frontend');
const MAX_DESC = 160;
const LIST_URL = `${SITE_URL}/conflits`;

// Même ?v= que les pages en cache (en développement : change à chaque
// démarrage, utils/asset-cache.js).
function readVersion() {
  return require('../utils/asset-cache').currentAssetVersion();
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
  // Conflit rédigé : son issue dit davantage que la description d'une ligne.
  const desc = (isEn && war.outcome_en) || war.outcome
    || (isEn && war.description_en) || war.description || '';
  const y1 = yearOf(war.date_start);
  const y2 = yearOf(war.date_end);
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
    content: {
      outcome: (isEn && war.outcome_en) || war.outcome || null,
      context: (isEn && war.context_en) || war.context || null,
      narrative: (isEn && war.narrative_en) || war.narrative || null,
    },
  };
}

/**
 * Markdown des récits → HTML minimal pour le rendu serveur : paragraphes,
 * titres ##/###, **gras**, *italique*. Tout est échappé d'abord ; le script
 * de la page refait ensuite le rendu complet (typographie, listes, liens).
 */
function proseHtml(markdown) {
  const inline = (text) => escapeHtml(text)
    .replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>')
    .replace(/\*([^*\n]+)\*/g, '<em>$1</em>');
  return String(markdown || '')
    .replace(/\r\n/g, '\n')
    .split(/\n{2,}/)
    .map((block) => block.trim())
    .filter(Boolean)
    .map((block) => {
      const h = /^(#{2,3})\s+(.+)$/.exec(block);
      if (h) return h[1].length === 2 ? `<h3 class="md-section">${inline(h[2])}</h3>` : `<h4 class="md-subsection">${inline(h[2])}</h4>`;
      return `<p>${inline(block.replace(/\n/g, ' '))}</p>`;
    })
    .join('');
}

/**
 * Page d'un conflit rédigé : issue, contexte et récit écrits dans le HTML
 * (robots, visiteurs sans JavaScript, premier affichage) ; la vue « conflit »
 * est montrée d'emblée et les silhouettes de chargement masquées.
 */
function injectContent(html, content) {
  if (!content || !(content.outcome || content.context || content.narrative)) return html;
  let out = html
    .replace('<div id="conflicts-loading" class="conflicts-grid"', '<div id="conflicts-loading" class="conflicts-grid hidden"')
    .replace('<div id="conflict-detail" class="hidden">', '<div id="conflict-detail">');
  if (content.outcome) {
    out = out
      .replace('<p class="conflict-outcome hidden" id="conflict-outcome">', '<p class="conflict-outcome" id="conflict-outcome">')
      .replace('<span id="conflict-outcome-text"></span>', () => `<span id="conflict-outcome-text">${proseHtml(content.outcome).replace(/^<p>|<\/p>$/g, '')}</span>`);
  }
  [['contexte', 'conflict-context', content.context], ['guerre-aerienne', 'conflict-narrative', content.narrative]]
    .forEach(([sectionId, targetId, text]) => {
      if (!text) return;
      out = out
        .replace(`<section class="conflict-block hidden" id="${sectionId}"`, `<section class="conflict-block" id="${sectionId}"`)
        .replace(`<div class="conflict-prose" id="${targetId}"></div>`, () => `<div class="conflict-prose" id="${targetId}">${proseHtml(text)}</div>`);
    });
  return out;
}

/**
 * Gabarit conflits.html → HTML de la page.
 * @param {string} template
 * @param {object} meta - buildConflictsIndexMeta ou buildConflictMeta
 * @param {string} [h1] - titre de la page de conflit (absent pour la liste)
 */
function renderHtml(template, meta, h1) {
  let html = injectContent(applyHeadMeta(template, meta), meta.content);
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
  // Un gabarit par langue : textes d'interface traduits côté serveur (SEO-002).
  const version = readVersion();
  const templates = {
    fr: renderTemplate(FRONTEND_DIR, 'conflits.html', version, 'fr'),
    en: renderTemplate(FRONTEND_DIR, 'conflits.html', version, 'en'),
  };
  const templateFor = (req) => templates[req.lang === 'en' ? 'en' : 'fr'];

  // Liste : grille de liens vers chaque conflit écrite dans le HTML (SEO-005).
  router.get('/conflits', async (req, res, next) => {
    try {
      const template = templateFor(req);
      if (!template) return next();
      const lang = req.lang === 'en' ? 'en' : 'fr';
      // Base indisponible : la page part sans la grille, que le navigateur
      // remplira par l'API comme avant ; seule la liste manque aux robots.
      let wars = [];
      try {
        wars = await warsRepo.listWithCounts(getPool());
      } catch (err) {
        logger.warn('Grille des conflits non rendue par le serveur', { error: err.message, route: 'GET /conflits' });
      }
      sendSsrHtml(req, res, applyList(renderHtml(template, buildConflictsIndexMeta(req.lang)), wars, lang));
    } catch (err) {
      next(err);
    }
  });

  router.get('/conflits/:slug', async (req, res, next) => {
    try {
      const template = templateFor(req);
      if (!template) return next();
      const slug = String(req.params.slug || '');
      if (!/^[a-z0-9-]{1,120}$/.test(slug)) return next();

      const rows = await listEngagedWars(getPool());
      const war = rows.find(r => slugify(r.name) === slug);
      if (!war) return next(); // 404 standard

      const meta = buildConflictMeta(war, slug, req.lang);
      // Appareils engagés, par camp, en liens vers leurs fiches (SEO-005).
      const pool = getPool();
      const [airplanes, sides] = await Promise.all([
        warsRepo.findAirplanes(pool, war.id),
        warsRepo.findSides(pool, war.id),
      ]);
      const lang = req.lang === 'en' ? 'en' : 'fr';
      sendSsrHtml(req, res, applySides(renderHtml(template, meta, meta.name), airplanes, sides, lang));
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
module.exports.proseHtml = proseHtml;
module.exports.injectContent = injectContent;
