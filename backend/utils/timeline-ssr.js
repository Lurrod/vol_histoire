'use strict';

/**
 * Rendu serveur des chapitres de la frise (/timeline).
 *
 * Sans lui, la page ne contenait que sa couverture pour un robot qui
 * n'exécute pas de script : récits, événements, conflits et appareils
 * étaient rendus en JavaScript seulement. Le serveur écrit désormais le
 * texte de chaque chapitre, dans la langue de la requête, avec les mêmes
 * classes que le rendu client (js/timeline/render.js), qui le remplace par la
 * version interactive (photos, barres de durée, filtres).
 */
const fs = require('fs');
const path = require('path');
const { escapeHtml } = require('./ssr-head');
const { buildDetailsPath } = require('./url');

const LOCALES_DIR = path.join(__dirname, '../../frontend/locales');
const MARKER = '<!-- @tl-chapters -->';
const START_YEAR = 1945;

const dictionaries = new Map();

function dictionary(lang) {
  const key = lang === 'en' ? 'en' : 'fr';
  if (!dictionaries.has(key)) {
    let dict = {};
    try { dict = JSON.parse(fs.readFileSync(path.join(LOCALES_DIR, `${key}.json`), 'utf8')); } catch { /* vide */ }
    dictionaries.set(key, dict.timeline || {});
  }
  return dictionaries.get(key);
}

/** Traduction `timeline.<key>`, paramètres {x} remplacés, repli sinon. */
function tr(dict, key, fallback, params = {}) {
  const raw = typeof dict[key] === 'string' ? dict[key] : fallback;
  return Object.entries(params).reduce((s, [k, v]) => s.split(`{${k}}`).join(String(v)), raw);
}

function pick(obj, field, lang) {
  return (lang === 'en' && obj[`${field}_en`]) || obj[`${field}_fr`] || obj[field] || '';
}

function yearOf(value) {
  const y = parseInt(String(value || '').slice(0, 4), 10);
  return Number.isFinite(y) ? y : '';
}

function tagFor(a, dict) {
  if (a.year_source !== 'first_flight') return '';
  if (a.status === 'Annulé') return tr(dict, 'tag_cancelled', 'Annulé');
  if (a.status === 'En développement') return tr(dict, 'tag_in_development', 'En développement');
  return tr(dict, 'tag_first_flight', '1er vol');
}

function renderEvent(ev, dict, lang) {
  const kind = tr(dict, `kind_${ev.kind || 'milestone'}`, '');
  const author = pick(ev, 'quote_author', lang);
  const plane = ev.airplane
    ? `<a class="tl-event-plane" href="${escapeHtml(buildDetailsPath(ev.airplane.id, ev.airplane.name))}"><span class="tl-event-plane-name">${escapeHtml(pick(ev.airplane, 'name', lang))}</span></a>`
    : '';
  return `<article class="tl-event" data-year="${yearOf(ev.event_date)}">` +
    `<div class="tl-event-rail"><span class="tl-event-year">${yearOf(ev.event_date)}</span>` +
    `<span class="tl-event-kind">${escapeHtml(kind)}</span></div>` +
    `<div class="tl-event-body"><h3 class="tl-event-title">${escapeHtml(pick(ev, 'title', lang))}</h3>` +
    `<p class="tl-event-text">${escapeHtml(pick(ev, 'body', lang))}</p>` +
    (author ? `<cite class="tl-event-author">— ${escapeHtml(author)}</cite>` : '') +
    `${plane}</div></article>`;
}

function renderWar(w, dict, lang) {
  const n = (w.aircraft_ids || []).length;
  const count = tr(dict, n === 1 ? 'conflict_aircraft_one' : 'conflict_aircraft_other', `${n}`, { n });
  let years = `${w.start_year}–`;
  if (Number.isFinite(w.end_year)) years = w.end_year === w.start_year ? String(w.start_year) : `${w.start_year}–${w.end_year}`;
  return `<li class="tl-conflict"><a class="tl-conflict-link" href="/conflits/${encodeURIComponent(w.slug)}">` +
    `<span class="tl-conflict-name">${escapeHtml(pick(w, 'name', lang))}</span>` +
    `<span class="tl-conflict-meta">${escapeHtml(years)} · ${escapeHtml(count)}</span></a></li>`;
}

function renderChip(a, dict, lang) {
  const tag = tagFor(a, dict);
  const country = lang === 'en' && a.country_name_en ? a.country_name_en : (a.country_name || '');
  return `<li><a class="tl-chip${tag ? ' is-proto' : ''}" href="${escapeHtml(buildDetailsPath(a.id, a.name))}">` +
    `<span class="tl-chip-text"><span class="tl-chip-name">${escapeHtml(pick(a, 'name', lang))}</span>` +
    `<span class="tl-chip-meta">${escapeHtml(country)}${tag ? ` · <span class="tl-chip-tag">${escapeHtml(tag)}</span>` : ''}</span>` +
    '</span></a></li>';
}

function renderAircraft(bucket, dict, lang) {
  const aircraft = bucket.aircraft || [];
  if (aircraft.length === 0) return '';
  const years = new Map();
  aircraft.forEach(a => {
    if (!years.has(a.year)) years.set(a.year, []);
    years.get(a.year).push(a);
  });
  const rows = Array.from(years.entries()).sort((x, y) => x[0] - y[0]).map(([year, list]) =>
    `<li class="tl-runway-row" data-year="${year}"><span class="tl-runway-year">${year}</span>` +
    `<ul class="tl-chips">${list.map(a => renderChip(a, dict, lang)).join('')}</ul></li>`).join('');
  const more = tr(dict, 'hangar_link', `${aircraft.length}`, { n: aircraft.length, decade: bucket.decade });
  return '<div class="tl-aircraft-section">' +
    `<span class="tl-section-label">${escapeHtml(tr(dict, 'chapter_aircraft_label', 'Appareils'))} · <strong>${aircraft.length}</strong></span>` +
    `<div class="tl-runway"><ol class="tl-runway-list">${rows}</ol></div>` +
    `<a class="tl-hangar-link" href="/hangar?decade=${bucket.decade}">${escapeHtml(more)}</a></div>`;
}

function renderChapter(bucket, idx, wars, dict, lang) {
  const dec = bucket.decade;
  const events = bucket.events || [];
  const decadeWars = wars.filter(w => w.era_decade === dec);
  return `<section class="tl-chapter tl-chapter--ssr" id="ch-${dec}" data-decade="${dec}" aria-labelledby="ch-${dec}-title">` +
    '<header class="tl-title-card"><div class="tl-title-card-inner">' +
    `<div class="tl-title-meta"><span class="tl-title-chapter">${escapeHtml(tr(dict, 'chapter_label', 'Chapitre'))} · ${String(idx + 1).padStart(2, '0')}</span>` +
    `<span class="tl-title-span">${Math.max(dec, START_YEAR)}–${dec + 9}</span></div>` +
    `<span class="tl-title-label">${escapeHtml(tr(dict, `era_${dec}_label2`, ''))}</span>` +
    `<h2 class="tl-title-era" id="ch-${dec}-title">${escapeHtml(tr(dict, `era_${dec}_title2`, String(dec)))}</h2>` +
    '</div></header>' +
    `<div class="tl-narrative"><p class="tl-narrative-text">${escapeHtml(tr(dict, `era_${dec}_narrative`, ''))}</p></div>` +
    (events.length ? `<div class="tl-events"><span class="tl-section-label">${escapeHtml(tr(dict, 'chapter_events_label', ''))} · <strong>${events.length}</strong></span><div class="tl-events-list">${events.map(e => renderEvent(e, dict, lang)).join('')}</div></div>` : '') +
    (decadeWars.length ? `<div class="tl-conflicts"><span class="tl-section-label">${escapeHtml(tr(dict, 'chapter_conflicts_label', ''))} · <strong>${decadeWars.length}</strong></span><ul class="tl-conflict-list">${decadeWars.map(w => renderWar(w, dict, lang)).join('')}</ul></div>` : '') +
    renderAircraft(bucket, dict, lang) +
    '</section>';
}

/**
 * HTML des chapitres (décennies non vides) d'une charge utile de la frise.
 * @param {{ decades: object[], wars?: object[] }} payload
 * @param {'fr'|'en'} lang
 */
function renderChaptersHtml(payload, lang) {
  const dict = dictionary(lang);
  const wars = payload.wars || [];
  return (payload.decades || [])
    .filter(d => (d.events && d.events.length) || (d.aircraft && d.aircraft.length))
    .map((d, i) => renderChapter(d, i, wars, dict, lang))
    .join('');
}

/** Insère les chapitres au marqueur de timeline.html (sinon, page inchangée). */
function injectChapters(html, payload, lang) {
  if (!html.includes(MARKER)) return html;
  const chapters = renderChaptersHtml(payload, lang);
  return html.replace(MARKER, () => chapters);
}

module.exports = { MARKER, renderChaptersHtml, injectChapters, _tr: tr };
