'use strict';

/**
 * Fiche appareil : faits du héros et chiffres clés écrits par le serveur
 * (PERF-004). Le fil d'Ariane (« Chargement... »), le sous-titre, la ligne
 * pays · constructeur · année · génération et les quatre chiffres clés
 * n'arrivaient qu'avec le JavaScript : en remplissant le gabarit, ils
 * faisaient grandir le héros et décalaient la page (CLS). Le serveur écrit
 * désormais les mêmes valeurs que frontend/js/details/render.js ; le client
 * les réécrit à l'identique, sans décalage.
 */
const fs = require('fs');
const path = require('path');
const { pickLang } = require('../i18n');
const { escapeHtml } = require('./ssr-head');
const { yearOf } = require('./calendar-date');

// Mêmes champs traduits que GET /api/airplanes/:id (routes/airplanes.js).
const TRANSLATED = ['name', 'complete_name', 'status', 'manufacturer_name', 'country_name'];
const PROPER_NOUNS = ['name', 'complete_name', 'manufacturer_name', 'country_name'];

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

/** Valeurs affichées par le client (render.js), dans la langue demandée. */
function heroFacts(aircraft, lang) {
  const isEn = lang === 'en';
  const a = pickLang(aircraft, isEn ? 'en' : 'fr', TRANSLATED, PROPER_NOUNS);
  const s = strings(isEn ? 'en' : 'fr');
  const notSpecified = s.not_specified || (isEn ? 'Not specified' : 'Non spécifié');
  const num = (n) => new Intl.NumberFormat(isEn ? 'en' : 'fr', { maximumFractionDigits: 2 }).format(Number(n));

  let year = null;
  const service = yearOf(a.date_operationel);
  const firstFlight = yearOf(a.date_first_fly);
  if (service) year = String(service);
  else if (firstFlight) year = (s.hero_first_flight || (isEn ? 'First flight {year}' : '1er vol en {year}')).replace('{year}', firstFlight);

  const g = Number(a.generation);
  const generation = g
    ? (isEn ? `${g}${['st', 'nd', 'rd'][g - 1] || 'th'} generation` : `${g}e génération`)
    : null;

  return {
    name: a.name || 'N/A',
    completeName: a.complete_name || '',
    country: a.country_name || notSpecified,
    manufacturer: a.manufacturer_name || notSpecified,
    year,
    generation,
    speed: a.max_speed ? `${num(a.max_speed)} km/h` : 'N/A',
    range: a.max_range ? `${num(a.max_range)} km` : 'N/A',
    weight: a.empty_weight ? `${num(a.empty_weight)} kg` : 'N/A',
    status: a.status || notSpecified,
  };
}

/** Remplace le contenu texte d'un élément identifié (gabarit details.html). */
function fillText(html, id, text) {
  const re = new RegExp(`(<(\\w+) [^>]*id="${id}"[^>]*>)[^<]*(</\\2>)`);
  return html.replace(re, (m, open, tag, close) => `${open}${escapeHtml(text)}${close}`);
}

/**
 * Écrit les faits du héros et les chiffres clés dans le gabarit.
 * @param {string} html - gabarit details.html (déjà passé par applyHero)
 * @param {object} aircraft - ligne de repositories/ssr-details.js
 * @param {'fr'|'en'} lang
 */
function applyHeroFacts(html, aircraft, lang) {
  const f = heroFacts(aircraft, lang);
  let out = html;
  out = fillText(out, 'breadcrumb-name', f.name);
  out = fillText(out, 'aircraft-complete-name', f.completeName);
  out = fillText(out, 'hero-country', f.country);
  out = fillText(out, 'hero-manufacturer', f.manufacturer);
  if (f.year) {
    out = fillText(out, 'hero-year', f.year);
  } else {
    // Ni mise en service ni premier vol : l'élément est masqué (comme le client).
    out = out.replace(/<div class="meta-item"><i class="fas fa-calendar"><\/i><span id="hero-year">/,
      () => '<div class="meta-item" hidden><i class="fas fa-calendar"></i><span id="hero-year">');
  }
  if (f.generation) {
    out = out.replace(/<div class="meta-item" id="hero-generation-item" hidden>/,
      () => '<div class="meta-item" id="hero-generation-item">');
    out = fillText(out, 'hero-generation', f.generation);
  }
  out = fillText(out, 'stat-speed', f.speed);
  out = fillText(out, 'stat-range', f.range);
  out = fillText(out, 'stat-weight', f.weight);
  out = fillText(out, 'stat-status', f.status);
  return out;
}

module.exports = { applyHeroFacts, heroFacts };
