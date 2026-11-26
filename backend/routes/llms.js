const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const { buildDetailsPath, slugify } = require('../utils/url');
const cache = require('../utils/cache');
const logger = require('../logger');
const sitemapRepo = require('../repositories/sitemap');
const warsRepo = require('../repositories/wars');

/* /llms.txt — présentation du site aux modèles de langage (format
 * https://llmstxt.org : titre, résumé en citation, sections de liens).
 * Généré depuis la base comme le sitemap : pages, API publique, conflits et
 * la liste complète des fiches. Mis en cache 24 h (invalidé avec le sitemap
 * à chaque écriture d'appareil) ; version minimale si la base ne répond pas. */

const LLMS_CACHE_KEY = 'vdh:llms:txt';
const LLMS_TTL_SECONDS = 24 * 60 * 60;
const LLMS_BROWSER_MAX_AGE = 60 * 60;
const LLMS_FALLBACK_MAX_AGE = 5 * 60;

const BASE_URL = 'https://vol-histoire.titouan-borde.com';

/** Neutralise ce qui casserait un lien Markdown : crochets et retours à la ligne. */
function mdText(value) {
  return String(value == null ? '' : value).replace(/[[\]\r\n]+/g, ' ').replace(/\s{2,}/g, ' ').trim();
}

function header({ aircraft, wars }) {
  const counts = aircraft != null
    ? `${aircraft} fiches d'appareils, ${wars} conflits`
    : 'des centaines de fiches d\'appareils et de conflits';
  return `# Vol d'Histoire

> Encyclopédie bilingue (français, anglais) de l'aviation militaire de 1945 à nos jours : ${counts}. Chaque fiche réunit caractéristiques, motorisation, production, filiation (prédécesseur, successeur, rival), engagements et récit historique, avec une photo sous licence libre.

Le français est servi à l'URL nue, l'anglais avec le paramètre \`?lang=en\` (ex. ${BASE_URL}/hangar?lang=en). Les données sont aussi disponibles en JSON par l'API publique, sans authentification.

Réutilisation : les textes et la base de données sont la propriété de Vol d'Histoire (reproduction interdite sans accord écrit, voir les conditions d'utilisation) ; chaque photo reste sous sa propre licence (domaine public, CC0 ou Creative Commons), indiquée sur la fiche et sur la page des crédits.

## Pages principales

- [Accueil](${BASE_URL}/): recherche, appareil du jour, carte des nations de conception
- [Hangar](${BASE_URL}/hangar): catalogue complet, filtrable par pays, génération, type, conflit, mission et décennie, avec recherche plein texte (\`/hangar?q=mirage\`)
- [Chronologie](${BASE_URL}/timeline): frise de 1940 à aujourd'hui, par décennie, avec les conflits et les appareils marquants
- [Conflits](${BASE_URL}/conflits): conflits armés et appareils qui y ont été engagés
- [Crédits photo](${BASE_URL}/credits): auteur et licence de chaque photo

## API publique (JSON)

- [Appareils](${BASE_URL}/api/airplanes?page=1&limit=100): liste paginée (100 par page au plus) ; filtres \`search\`, \`country\` (nom français du pays), \`generation\`, \`type\`, \`war\`, \`mission\`, \`decade\` ; \`lang=en\` pour l'anglais
- [Nations](${BASE_URL}/api/nations): nations de conception et nombre de fiches
- [Conflits](${BASE_URL}/api/wars): conflits et nombre d'appareils rattachés
- Fiche détaillée : \`${BASE_URL}/api/airplanes/{id}\` ; filiation complète : \`${BASE_URL}/api/airplanes/{id}/lineage\`
`;
}

function footer() {
  return `
## Optional

- [Plan du site](${BASE_URL}/sitemap.xml): toutes les pages, en français et en anglais
- [Conditions d'utilisation](${BASE_URL}/cgu)
- [Mentions légales](${BASE_URL}/mentions-legales)
- [Politique de confidentialité](${BASE_URL}/politique-confidentialite)
- [Contact](${BASE_URL}/contact)
`;
}

/** llms.txt minimal, sans base de données. */
function buildStaticLlmsTxt() {
  return header({ aircraft: null, wars: null }) + footer();
}

/** Ligne d'une fiche : « Chasseur, France, 2001 » (parties connues seulement). */
function airplaneLine(row) {
  const details = [row.type_name, row.country_name, row.year].filter((v) => v != null && v !== '').map(mdText);
  const link = `- [${mdText(row.name)}](${BASE_URL}${buildDetailsPath(row.id, row.name)})`;
  return details.length ? `${link}: ${details.join(', ')}` : link;
}

async function buildLlmsTxt(getPool) {
  const pool = getPool();
  const [airplanes, wars] = await Promise.all([
    sitemapRepo.listAirplanesForLlms(pool),
    warsRepo.listWithCounts(pool),
  ]);
  const linked = wars.filter((w) => w.count > 0);
  const warLines = linked.map((w) => {
    const start = w.date_start ? new Date(w.date_start).getUTCFullYear() : null;
    const end = w.date_end ? new Date(w.date_end).getUTCFullYear() : null;
    // Sans date de fin, le conflit dure encore : « depuis 1948 », pas « 1948 ».
    let period = null;
    if (start && !end) period = `depuis ${start}`;
    else if (start) period = end !== start ? `${start}-${end}` : `${start}`;
    const details = [period, `${w.count} appareil${w.count > 1 ? 's' : ''}`].filter(Boolean).join(', ');
    return `- [${mdText(w.name)}](${BASE_URL}/conflits/${slugify(w.name)}): ${details}`;
  });

  return header({ aircraft: airplanes.length, wars: linked.length })
    + `\n## Conflits\n\n${warLines.join('\n')}\n`
    + `\n## Fiches d'appareils\n\nType, pays de conception et année de mise en service (à défaut, de premier vol).\n\n`
    + `${airplanes.map(airplaneLine).join('\n')}\n`
    + footer();
}

function send(res, body, maxAge, cacheStatus) {
  res.set('Content-Type', 'text/plain; charset=utf-8');
  res.set('Cache-Control', `public, max-age=${maxAge}, s-maxage=${maxAge}`);
  res.set('X-Cache', cacheStatus);
  res.send(body);
}

module.exports = function createLlmsRouter(getPool) {
  const router = express.Router();

  router.get('/llms.txt', asyncHandler(async (req, res) => {
    const cached = await cache.get(LLMS_CACHE_KEY);
    if (cached) return send(res, cached, LLMS_BROWSER_MAX_AGE, 'HIT');
    try {
      const text = await buildLlmsTxt(getPool);
      await cache.set(LLMS_CACHE_KEY, text, LLMS_TTL_SECONDS);
      send(res, text, LLMS_BROWSER_MAX_AGE, 'MISS');
    } catch (err) {
      logger.warn('llms.txt dynamique indisponible, version minimale', { error: err && err.message });
      send(res, buildStaticLlmsTxt(), LLMS_FALLBACK_MAX_AGE, 'FALLBACK');
    }
  }));

  return router;
};

module.exports.LLMS_CACHE_KEY = LLMS_CACHE_KEY;
module.exports.invalidateLlms = () => cache.del(LLMS_CACHE_KEY);
module.exports.buildLlmsTxt = buildLlmsTxt;
module.exports.buildStaticLlmsTxt = buildStaticLlmsTxt;
