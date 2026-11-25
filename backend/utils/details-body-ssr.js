'use strict';

/**
 * Fiche appareil : récit écrit par le serveur (SEO-001). La section
 * Description n'arrivait qu'avec le JavaScript : le HTML servi ne contenait
 * que « Chargement de la description... », si bien que les robots qui
 * n'exécutent pas de script (robots IA, aperçus, moteurs secondaires) ne
 * voyaient des 733 fiches qu'une coquille. Le serveur écrit désormais le
 * récit dans la langue demandée, avec le même parser et le même balisage que
 * frontend/js/details/render.js ; le client le réécrit à l'identique. Les
 * appareils liés (prédécesseur, successeur, rival) deviennent de vrais liens ;
 * le client remplace ensuite leurs images par sa <picture> AVIF/WebP.
 */
const fs = require('fs');
const path = require('path');
const { pickLang } = require('../i18n');
const { escapeHtml } = require('./ssr-head');
const { slugify } = require('./url');
const markdown = require('./markdown');

const dictionaries = {};
function strings(lang) {
  if (!dictionaries[lang]) {
    try {
      const file = path.join(__dirname, '../../frontend/locales', `${lang}.json`);
      dictionaries[lang] = JSON.parse(fs.readFileSync(file, 'utf8')).details || {};
    } catch {
      dictionaries[lang] = {};
    }
  }
  return dictionaries[lang];
}

function noDescription(lang) {
  return strings(lang).no_description || (lang === 'en' ? 'No description available.' : 'Aucune description disponible.');
}

/** Contenu de #aircraft-description : HTML et classe du conteneur. */
function descriptionBody(aircraft, lang) {
  const isEn = lang === 'en';
  // Même choix de langue que GET /api/airplanes/:id (routes/airplanes.js).
  const { description } = pickLang(aircraft, isEn ? 'en' : 'fr', ['description']);
  if (markdown.isMarkdown(description)) {
    return { markdown: true, html: markdown.parse(description, { lang: isEn ? 'en' : 'fr' }) };
  }
  const text = description || noDescription(isEn ? 'en' : 'fr');
  return { markdown: false, html: `<p>${escapeHtml(text)}</p>` };
}

/**
 * Remplace le texte d'attente de la section Description par le récit. Le
 * data-i18n du gabarit est retiré : i18n ne doit pas y remettre « Chargement
 * de la description... ».
 * @param {string} html - gabarit details.html
 * @param {object} aircraft - ligne de repositories/ssr-details.js
 * @param {'fr'|'en'} lang
 */
function applyDescription(html, aircraft, lang) {
  const body = descriptionBody(aircraft, lang);
  const cls = body.markdown ? 'description-body markdown-body' : 'description-body';
  return html.replace(
    /<div id="aircraft-description" class="description-body"[^>]*>[^<]*<\/div>/,
    () => `<div id="aircraft-description" class="${cls}">${body.html}</div>`
  );
}

const RELATIONS = [
  ['predecessor', 'related_predecessor', 'Prédécesseur', 'Predecessor'],
  ['successor', 'related_successor', 'Successeur', 'Successor'],
  ['rival', 'related_rival', 'Rival', 'Rival'],
];

/** Cartes « Appareils liés » : même structure que renderRelatedAircraft. */
function relatedCards(aircraft, lang) {
  const isEn = lang === 'en';
  const s = strings(isEn ? 'en' : 'fr');
  return RELATIONS.map(([rel, key, fr, en]) => {
    const id = Number(aircraft[`${rel}_id`]);
    const frName = aircraft[`${rel}_name`];
    if (!id || !frName) return '';
    const name = (isEn && aircraft[`${rel}_name_en`]) || frName;
    // Slug canonique (nom français) : pas de redirection 301 au clic.
    const href = `/details/${slugify(frName)}-${id}${isEn ? '?lang=en' : ''}`;
    const img = aircraft[`${rel}_image`] || `/assets/logo/placeholder-airplane-${isEn ? 'en' : 'fr'}.svg`;
    return `<a class="related-card" href="${escapeHtml(href)}" data-morph-id="${id}">`
      + `<span class="related-relation">${escapeHtml(s[key] || (isEn ? en : fr))}</span>`
      + `<div class="related-img" data-morph="photo"><img src="${escapeHtml(img)}" alt="" loading="lazy" width="300" height="200"></div>`
      + `<h3>${escapeHtml(name)}</h3>`
      + '<span class="related-arrow"><i class="fas fa-arrow-right"></i></span>'
      + '</a>';
  }).join('');
}

/** Section « Appareils liés » : affichée et remplie s'il y a au moins un lien. */
function applyRelated(html, aircraft, lang) {
  const cards = relatedCards(aircraft, lang);
  if (!cards) return html;
  return html
    .replace('<section class="content-section related-section hidden" id="related-aircraft-section">',
      () => '<section class="content-section related-section" id="related-aircraft-section">')
    .replace('<div class="related-grid" id="related-grid"></div>',
      () => `<div class="related-grid" id="related-grid">${cards}</div>`);
}

module.exports = { applyDescription, descriptionBody, applyRelated, relatedCards };
