const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const { buildDetailsPath, slugify } = require('../utils/url');
const { langUrl } = require('../utils/ssr-head');
const cache = require('../utils/cache');
const logger = require('../logger');
const sitemapRepo = require('../repositories/sitemap');
const warsRepo = require('../repositories/wars');

const SITEMAP_CACHE_KEY = 'vdh:sitemap:xml';
const SITEMAP_TTL_SECONDS = 24 * 60 * 60; // 24h côté serveur
const SITEMAP_BROWSER_MAX_AGE = 60 * 60;  // 1h côté client/CDN
const SITEMAP_FALLBACK_MAX_AGE = 5 * 60;  // 5min en fallback DB (cache court pour reprise rapide)

const BASE_URL = 'https://vol-histoire.titouan-borde.com';
// Pages fixes indexables. changefreq et priority ne sont plus publiés :
// Google les ignore. lastmod n'est donné que lorsqu'il est connu (voir
// buildSitemapXml) — une date de génération répétée sur toutes les URL est
// ignorée par les moteurs et masque les vraies mises à jour.
const STATIC_PAGES = [
  '/',
  '/hangar',
  '/timeline',
  '/conflits',
  '/credits',
  '/contact',
  '/mentions-legales',
  '/politique-confidentialite',
  '/cgu',
];
// Pages dont le contenu est le catalogue lui-même : leur lastmod est celui
// de la fiche modifiée le plus récemment.
const CATALOGUE_PAGES = new Set(['/', '/hangar']);

/** Date W3C (AAAA-MM-JJ) d'une valeur de base, null si absente ou invalide. */
function toLastmod(value) {
  if (!value) return null;
  const d = value instanceof Date ? value : new Date(value);
  return Number.isNaN(d.getTime()) ? null : d.toISOString().slice(0, 10);
}

/**
 * Entrées d'une page : une <url> par langue (français à l'URL nue, anglais à
 * ?lang=en), chacune portant les trois alternates réciproques — le schéma
 * que Google attend pour des versions linguistiques déclarées par sitemap.
 */
function renderUrlEntries(loc, lastmod) {
  const base = `${BASE_URL}${loc}`;
  const alternates = [
    `    <xhtml:link rel="alternate" hreflang="fr" href="${base}" />`,
    `    <xhtml:link rel="alternate" hreflang="en" href="${langUrl(base, 'en')}" />`,
    `    <xhtml:link rel="alternate" hreflang="x-default" href="${base}" />`,
  ].join('\n');
  const lastmodTag = lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : '';
  return ['fr', 'en'].map(lang => `
  <url>
    <loc>${langUrl(base, lang)}</loc>${lastmodTag}
${alternates}
  </url>`).join('');
}

function wrapSitemap(urlsXml) {
  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">${urlsXml}
</urlset>`;
}

// Sitemap minimal sans BDD — fallback résilient si la DB est indisponible.
function buildStaticSitemapXml() {
  return wrapSitemap(STATIC_PAGES.map(loc => renderUrlEntries(loc, null)).join(''));
}

async function buildSitemapXml(getPool) {
  const pool = getPool();
  const [airplanes, wars] = await Promise.all([
    sitemapRepo.listAirplanesForSitemap(pool),
    // Une page par conflit rattaché à au moins un appareil (routes/wars.js).
    warsRepo.listLinkedNames(pool),
  ]);

  // Fiches : date de leur dernière écriture en base (updated_at).
  const airplaneUrls = airplanes
    .map(row => renderUrlEntries(buildDetailsPath(row.id, row.name), toLastmod(row.updated_at)))
    .join('');
  const catalogueLastmod = airplanes
    .map(row => toLastmod(row.updated_at))
    .filter(Boolean)
    .sort()
    .pop() || null;

  // Pages fixes et conflits : aucune date de modification n'est tenue en base
  // pour leur texte, lastmod est donc omis plutôt qu'inventé.
  const staticUrls = STATIC_PAGES
    .map(loc => renderUrlEntries(loc, CATALOGUE_PAGES.has(loc) ? catalogueLastmod : null))
    .join('');
  const warUrls = wars
    .map(row => renderUrlEntries(`/conflits/${slugify(row.name)}`, null))
    .join('');

  return wrapSitemap(staticUrls + warUrls + airplaneUrls);
}

module.exports = function createSitemapRouter(getPool) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Sitemap dynamique avec hreflang FR/EN — Redis 24h, navigateur/CDN 1h
  // -----------------------------------------------------------------------------
  router.get('/sitemap.xml', asyncHandler(async (req, res) => {
    const cached = await cache.get(SITEMAP_CACHE_KEY);
    if (cached) {
      res.set('Content-Type', 'application/xml');
      res.set('Cache-Control', `public, max-age=${SITEMAP_BROWSER_MAX_AGE}, s-maxage=${SITEMAP_BROWSER_MAX_AGE}`);
      res.set('X-Cache', 'HIT');
      return res.send(cached);
    }

    // Build avant de poser les headers : si la BDD plante, on retombe sur le
    // sitemap statique minimal plutôt que de renvoyer un 500 brut au crawler.
    try {
      const xml = await buildSitemapXml(getPool);
      await cache.set(SITEMAP_CACHE_KEY, xml, SITEMAP_TTL_SECONDS);
      res.set('Content-Type', 'application/xml');
      res.set('Cache-Control', `public, max-age=${SITEMAP_BROWSER_MAX_AGE}, s-maxage=${SITEMAP_BROWSER_MAX_AGE}`);
      res.set('X-Cache', 'MISS');
      res.send(xml);
    } catch (err) {
      logger.warn('Sitemap dynamique indisponible, fallback statique', { error: err && err.message });
      const fallback = buildStaticSitemapXml();
      res.set('Content-Type', 'application/xml');
      res.set('Cache-Control', `public, max-age=${SITEMAP_FALLBACK_MAX_AGE}, s-maxage=${SITEMAP_FALLBACK_MAX_AGE}`);
      res.set('X-Cache', 'FALLBACK');
      res.send(fallback);
    }
  }));

  return router;
};

// Exposé pour invalidation depuis les routes write (airplanes CRUD)
module.exports.SITEMAP_CACHE_KEY = SITEMAP_CACHE_KEY;
module.exports.invalidateSitemap = () => cache.del(SITEMAP_CACHE_KEY);
// Exposé pour les tests : permet de vérifier le fallback isolé.
module.exports.buildStaticSitemapXml = buildStaticSitemapXml;
module.exports.buildSitemapXml = buildSitemapXml;
