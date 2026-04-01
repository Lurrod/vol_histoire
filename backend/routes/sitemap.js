const express = require('express');

module.exports = function createSitemapRouter(getPool) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Sitemap dynamique
  // -----------------------------------------------------------------------------
  router.get('/sitemap.xml', async (req, res) => {
    const BASE_URL = 'https://vol-histoire.titouan-borde.com';
    const today = new Date().toISOString().split('T')[0];

    const staticPages = [
      { loc: '/',                          changefreq: 'weekly',  priority: '1.0' },
      { loc: '/hangar',                    changefreq: 'weekly',  priority: '0.9' },
      { loc: '/timeline',                  changefreq: 'monthly', priority: '0.8' },
      { loc: '/a-propos',                  changefreq: 'monthly', priority: '0.6' },
      { loc: '/contact',                   changefreq: 'yearly',  priority: '0.5' },
      { loc: '/faq',                       changefreq: 'monthly', priority: '0.5' },
      { loc: '/support',                   changefreq: 'monthly', priority: '0.4' },
      { loc: '/mentions-legales',          changefreq: 'yearly',  priority: '0.2' },
      { loc: '/politique-confidentialite', changefreq: 'yearly',  priority: '0.2' },
      { loc: '/cgu',                       changefreq: 'yearly',  priority: '0.2' },
    ];

    try {
      const result = await getPool().query('SELECT id FROM airplanes ORDER BY id ASC');

      const staticUrls = staticPages.map(p => `
  <url>
    <loc>${BASE_URL}${p.loc}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>${p.changefreq}</changefreq>
    <priority>${p.priority}</priority>
  </url>`).join('');

      const airplaneUrls = result.rows.map(row => `
  <url>
    <loc>${BASE_URL}/details?id=${row.id}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>`).join('');

      const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${staticUrls}${airplaneUrls}
</urlset>`;

      res.set('Content-Type', 'application/xml');
      res.send(xml);
    } catch (error) {
      res.status(500).send('Erreur serveur');
    }
  });

  return router;
};
