'use strict';

/**
 * Liens explorables des pages de conflit, écrits par le serveur (SEO-005).
 *
 * La grille de /conflits et la liste des appareils engagés d'un conflit
 * n'existaient qu'après le JavaScript : le HTML servi ne contenait aucun lien
 * vers les 61 pages de conflit, ni vers les fiches des appareils engagés. Le
 * serveur écrit désormais le même balisage que frontend/js/conflicts.js
 * (renderList) et frontend/js/conflicts/detail.js (sidesHtml) ; le client le
 * réécrit ensuite, en remplaçant les vignettes par sa <picture> AVIF/WebP.
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
      dictionaries[lang] = JSON.parse(fs.readFileSync(file, 'utf8')).conflicts || {};
    } catch {
      dictionaries[lang] = {};
    }
  }
  return dictionaries[lang];
}

function tr(lang, key, fallback, params = {}) {
  const raw = strings(lang)[key] || fallback;
  return Object.keys(params).reduce((s, k) => s.split(`{${k}}`).join(String(params[k])), raw);
}

const year = (d) => (d ? new Date(d).getFullYear() : null);

/** « 1955 – 1975 », « depuis 2022 », « 1982 » : comme period() de conflicts.js. */
function period(w, lang) {
  const a = year(w.date_start);
  const b = year(w.date_end);
  if (!a) return '';
  if (!b) return tr(lang, 'since', lang === 'en' ? 'since {year}' : 'depuis {year}', { year: a });
  return a === b ? String(a) : `${a} – ${b}`;
}

/** Texte dans la langue demandée, repli sur le français (comme routes/wars.js). */
function inLang(row, field, lang) {
  const en = row[`${field}_en`];
  return lang === 'en' && en ? en : (row[field] || null);
}

// ── Liste des conflits ────────────────────────────────────────────────────

/** Cartes de la grille /conflits (wars : listWithCounts). */
function listHtml(wars, lang) {
  return wars.filter((w) => w.count > 0).map((row) => {
    const w = pickLang(row, lang, ['name', 'description']);
    const label = tr(lang, w.count > 1 ? 'aircraft_many' : 'aircraft_one', '{count}', { count: w.count });
    return `
      <a class="conflict-card" href="/conflits/${encodeURIComponent(slugify(row.name))}${lang === 'en' ? '?lang=en' : ''}">
        <span class="conflict-period">${escapeHtml(period(w, lang))}</span>
        <h2 class="conflict-name">${escapeHtml(w.name)}</h2>
        ${w.description ? `<p class="conflict-desc">${escapeHtml(w.description)}</p>` : ''}
        <span class="conflict-count"><i class="fas fa-plane" aria-hidden="true"></i>
          ${escapeHtml(label)}</span>
      </a>`;
  }).join('');
}

/** Grille de /conflits écrite dans le gabarit, silhouettes de chargement masquées. */
function applyList(html, wars, lang) {
  const cards = listHtml(wars, lang);
  if (!cards) return html;
  return html
    .replace('<div id="conflicts-loading" class="conflicts-grid"', '<div id="conflicts-loading" class="conflicts-grid hidden"')
    .replace('<div id="conflicts-list" class="conflicts-grid hidden"></div>',
      () => `<div id="conflicts-list" class="conflicts-grid">${cards}</div>`);
}

// ── Appareils engagés d'un conflit ────────────────────────────────────────

/** Rôle : typographie française, échappé, *italique* (comme inline() de detail.js). */
function inline(text, lang) {
  const source = lang === 'fr' ? markdown.typographyFr(String(text == null ? '' : text)) : text;
  return escapeHtml(source).replace(/\*([^*]+)\*/g, '<em>$1</em>');
}

function sourceHost(url) {
  try {
    return new URL(url).hostname.replace(/^www\./, '');
  } catch {
    return '';
  }
}

function splitSources(text) {
  return String(text || '').split(/\r?\n/).map((s) => s.trim()).filter((s) => /^https?:\/\/\S+$/i.test(s));
}

/** Vignette : la version 320 px en WebP (le client pose ensuite sa <picture>). */
function thumbHtml(imageUrl) {
  if (!imageUrl) return '<span class="role-thumb-empty"><i class="fas fa-plane" aria-hidden="true"></i></span>';
  const name = String(imageUrl).replace(/^\/assets\/airplanes\//, '').replace(/\.(jpe?g|png|webp|avif)$/i, '');
  return `<img src="/assets/airplanes/thumbs/${escapeHtml(name)}.webp" alt="" width="160" height="107" loading="lazy" decoding="async">`;
}

function roleCardHtml(row, lang) {
  const a = pickLang(row, lang, ['name', 'country_name', 'type_name'], ['name', 'country_name']);
  const href = escapeHtml(`/details/${slugify(row.name)}-${row.id}${lang === 'en' ? '?lang=en' : ''}`);
  const meta = [a.type_name, a.country_name].filter(Boolean).map(escapeHtml).join(' · ');
  const hosts = new Map();
  splitSources(row.role_sources).forEach((url) => {
    const host = sourceHost(url);
    if (host && !hosts.has(host)) hosts.set(host, url);
  });
  const sources = Array.from(hosts).slice(0, 3)
    .map(([host, url]) => `<a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(host)}</a>`)
    .join(', ');
  return `<li class="role-card" data-morph-id="${escapeHtml(row.id)}">
      <a class="role-thumb" href="${href}" tabindex="-1" aria-hidden="true" data-morph="photo">${thumbHtml(row.image_url)}</a>
      <div class="role-body">
        <h4 class="role-name"><a href="${href}">${escapeHtml(a.name)}</a></h4>
        ${meta ? `<p class="role-meta">${meta}</p>` : ''}
        <p class="role-text">${inline(inLang(row, 'role', lang), lang)}</p>
        ${sources ? `<p class="role-sources">${escapeHtml(tr(lang, 'source_label', 'Source'))} : ${sources}</p>` : ''}
      </div>
    </li>`;
}

/**
 * Camps et appareils avec un rôle (même regroupement que groupBySide de
 * detail.js : un groupe par camp, puis « Dans plusieurs camps »).
 * @param {object[]} airplanes - findAirplanes
 * @param {object[]} sides - findSides
 */
function sidesHtml(airplanes, sides, lang) {
  const withRole = airplanes.filter((a) => a.role);
  const groups = sides.map((s) => ({
    key: s.side_key, name: inLang(s, 'name', lang), members: inLang(s, 'members', lang),
    airplanes: withRole.filter((a) => a.side_key === s.side_key),
  })).filter((g) => g.airplanes.length);
  const several = withRole.filter((a) => !a.side_key || !sides.some((s) => s.side_key === a.side_key));
  if (several.length) {
    groups.push({ key: '', name: tr(lang, 'several_sides', lang === 'en' ? 'On several sides' : 'Dans plusieurs camps'), members: '', airplanes: several });
  }
  return groups.map((g) => `<section class="conflict-side"${g.key ? ` data-side="${escapeHtml(g.key)}"` : ''}>
      <header class="conflict-side-head">
        <h3 class="conflict-side-name">${escapeHtml(g.name)} <span class="conflict-side-count">${escapeHtml(g.airplanes.length)}</span></h3>
        ${g.members && g.members !== g.name ? `<p class="conflict-side-members">${escapeHtml(g.members)}</p>` : ''}
      </header>
      <ul class="role-list">${g.airplanes.map((a) => roleCardHtml(a, lang)).join('')}</ul>
    </section>`).join('');
}

/** Appareils engagés écrits dans la page d'un conflit (section #appareils). */
function applySides(html, airplanes, sides, lang) {
  const content = sidesHtml(airplanes || [], sides || [], lang);
  if (!content) return html;
  return html.replace('<div id="conflict-sides" class="conflict-sides hidden"></div>',
    () => `<div id="conflict-sides" class="conflict-sides">${content}</div>`);
}

module.exports = { applyList, listHtml, applySides, sidesHtml, period };
