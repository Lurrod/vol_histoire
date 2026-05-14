const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const { buildDetailsPath } = require('../utils/url');
const cache = require('../utils/cache');
const logger = require('../logger');

const SITEMAP_CACHE_KEY = 'vdh:sitemap:xml';
const SITEMAP_TTL_SECONDS = 24 * 60 * 60; // 24h côté serveur
const SITEMAP_BROWSER_MAX_AGE = 60 * 60;  // 1h côté client/CDN
const SITEMAP_FALLBACK_MAX_AGE = 5 * 60;  // 5min en fallback DB (cache court pour reprise rapide)

const BASE_URL = 'https://vol-histoire.titouan-borde.com';
const STATIC_PAGES = [
  { loc: '/',                          changefreq: 'weekly',  priority: '1.0' },
  { loc: '/hangar',                    changefreq: 'weekly',  priority: '0.9' },
  { loc: '/timeline',                  changefreq: 'monthly', priority: '0.8' },
  { loc: '/contact',                   changefreq: 'yearly',  priority: '0.5' },
  { loc: '/mentions-legales',          changefreq: 'yearly',  priority: '0.2' },
  { loc: '/politique-confidentialite', changefreq: 'yearly',  priority: '0.2' },
  { loc: '/cgu',                       changefreq: 'yearly',  priority: '0.2' },
];

function renderUrlEntry(loc, today, changefreq, priority) {
  const url = `${BASE_URL}${loc}`;
  return `
  <url>
    <loc>${url}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>${changefreq}</changefreq>
    <priority>${priority}</priority>
    <xhtml:link rel="alternate" hreflang="fr" href="${url}?lang=fr" />
    <xhtml:link rel="alternate" hreflang="en" href="${url}?lang=en" />
    <xhtml:link rel="alternate" hreflang="x-default" href="${url}" />
  </url>`;
}

function wrapSitemap(urlsXml) {
  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">${urlsXml}
</urlset>`;
}

// Sitemap minimal sans BDD — fallback résilient si la DB est indisponible.
function buildStaticSitemapXml() {
  const today = new Date().toISOString().split('T')[0];
  const staticUrls = STATIC_PAGES
    .map(p => renderUrlEntry(p.loc, today, p.changefreq, p.priority))
    .join('');
  return wrapSitemap(staticUrls);
}

async function buildSitemapXml(getPool) {
  const today = new Date().toISOString().split('T')[0];
  const result = await getPool().query('SELECT id, name FROM airplanes ORDER BY id ASC');

  const staticUrls = STATIC_PAGES
    .map(p => renderUrlEntry(p.loc, today, p.changefreq, p.priority))
    .join('');
  const airplaneUrls = result.rows
    .map(row => renderUrlEntry(buildDetailsPath(row.id, row.name), today, 'monthly', '0.8'))
    .join('');

  return wrapSitemap(staticUrls + airplaneUrls);
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
