const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');

module.exports = function createSitemapRouter(getPool) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Sitemap dynamique avec hreflang FR/EN
  // -----------------------------------------------------------------------------
  router.get('/sitemap.xml', asyncHandler(async (req, res) => {
    const BASE_URL = 'https://vol-histoire.titouan-borde.com';
    const today = new Date().toISOString().split('T')[0];

    const staticPages = [
      { loc: '/',                          changefreq: 'weekly',  priority: '1.0' },
      { loc: '/hangar',                    changefreq: 'weekly',  priority: '0.9' },
      { loc: '/timeline',                  changefreq: 'monthly', priority: '0.8' },
      { loc: '/contact',                   changefreq: 'yearly',  priority: '0.5' },
      { loc: '/mentions-legales',          changefreq: 'yearly',  priority: '0.2' },
      { loc: '/politique-confidentialite', changefreq: 'yearly',  priority: '0.2' },
      { loc: '/cgu',                       changefreq: 'yearly',  priority: '0.2' },
    ];

    const result = await getPool().query('SELECT id FROM airplanes ORDER BY id ASC');

    const staticUrls = staticPages.map(p => {
      const url = `${BASE_URL}${p.loc}`;
      const sep = p.loc === '/' ? '?' : '?';
      return `
  <url>
    <loc>${url}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>${p.changefreq}</changefreq>
    <priority>${p.priority}</priority>
    <xhtml:link rel="alternate" hreflang="fr" href="${url}${sep}lang=fr" />
    <xhtml:link rel="alternate" hreflang="en" href="${url}${sep}lang=en" />
    <xhtml:link rel="alternate" hreflang="x-default" href="${url}" />
  </url>`;
    }).join('');

    const airplaneUrls = result.rows.map(row => {
      const url = `${BASE_URL}/details?id=${row.id}`;
      return `
  <url>
    <loc>${url}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
    <xhtml:link rel="alternate" hreflang="fr" href="${url}&amp;lang=fr" />
    <xhtml:link rel="alternate" hreflang="en" href="${url}&amp;lang=en" />
    <xhtml:link rel="alternate" hreflang="x-default" href="${url}" />
  </url>`;
    }).join('');

    const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">${staticUrls}${airplaneUrls}
</urlset>`;

    res.set('Content-Type', 'application/xml');
    res.send(xml);
  }));

  return router;
};
