'use strict';

/**
 * SSR léger pour /conflits et /conflits/:slug.
 *
 * Même principe que details-ssr.js : sans réécriture côté serveur, chaque
 * conflit serait indexé sous le titre et la description génériques de
 * conflits.html. On injecte <title>, meta description, canonical, og:*,
 * twitter:* et le <h1> du conflit ; le contenu est ensuite rendu en JS.
 * Un slug inconnu tombe dans le 404 standard (next()).
 */

const fs = require('fs');
const path = require('path');
const express = require('express');
const { rewrite: rewriteAssets } = require('../middleware/serveHtml');
const { slugify } = require('../utils/url');

const SITE_URL = 'https://vol-histoire.titouan-borde.com';
const MAX_DESC = 160;

function escapeHtml(str) {
  return String(str || '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

function truncate(text, max) {
  const t = String(text || '').replace(/\s+/g, ' ').trim();
  if (t.length <= max) return t;
  return t.slice(0, max - 1).replace(/\s+\S*$/, '') + '…';
}

module.exports = function createConflictsSsrRouter(getPool) {
  const router = express.Router();

  const templatePath = path.join(__dirname, '../../frontend/conflits.html');
  let template = '';
  try {
    let pkgVersion = 'dev';
    try { pkgVersion = require('../package.json').version || 'dev'; } catch { /* dev */ }
    template = rewriteAssets(fs.readFileSync(templatePath, 'utf8'), pkgVersion);
  } catch {
    template = ''; // tests : fichier absent, non bloquant
  }

  // Réécrit les balises de tête et le titre de la page.
  function renderHtml({ title, description, url, h1, lang }) {
    let html = template;
    const t = escapeHtml(title);
    const d = escapeHtml(description);
    const u = escapeHtml(url);
    html = html
      .replace(/<title>[^<]*<\/title>/, `<title>${t}</title>`)
      .replace(/<meta name="description" content="[^"]*">/, `<meta name="description" content="${d}">`)
      .replace(/<link rel="canonical" href="[^"]*">/, `<link rel="canonical" href="${u}">`)
      .replace(/<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${t}">`)
      .replace(/<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${d}">`)
      .replace(/<meta property="og:url" content="[^"]*">/, `<meta property="og:url" content="${u}">`)
      .replace(/<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${t}">`)
      .replace(/<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${d}">`);
    if (h1) {
      // Le titre du conflit est en dur pour les robots ; data-i18n-html est
      // retiré pour que la traduction côté client ne le remplace pas.
      html = html.replace(
        /<h1 id="page-hero-heading"[^>]*>[\s\S]*?<\/h1>/,
        `<h1 id="page-hero-heading">${escapeHtml(h1)}</h1>`
      );
    }
    if (lang === 'en') html = html.replace(/<html lang="fr">/, '<html lang="en">');
    return html;
  }

  function send(req, res, html) {
    res.set('Content-Type', 'text/html; charset=utf-8');
    res.set('Cache-Control', 'public, max-age=3600, s-maxage=7200, stale-while-revalidate=86400');
    const inject = req.app.injectCspNonce;
    res.send(typeof inject === 'function' ? inject(html, res.locals.cspNonce) : html);
  }

  router.get('/conflits', (req, res, next) => {
    if (!template) return next();
    const isEn = req.lang === 'en';
    send(req, res, renderHtml({
      title: isEn ? "Conflicts | Vol d'Histoire" : "Conflits | Vol d'Histoire",
      description: isEn
        ? 'Armed conflicts since 1945 and the military aircraft committed to them, from Indochina to Ukraine.'
        : "Les conflits armés depuis 1945 et les appareils militaires qui y ont été engagés, de la guerre d'Indochine à l'Ukraine.",
      url: `${SITE_URL}/conflits`,
      lang: req.lang,
    }));
  });

  router.get('/conflits/:slug', async (req, res, next) => {
    try {
      if (!template) return next();
      const slug = String(req.params.slug || '');
      if (!/^[a-z0-9-]{1,120}$/.test(slug)) return next();

      const { rows } = await getPool().query(`
        SELECT w.name, w.name_en, w.description, w.description_en, w.date_start, w.date_end
        FROM wars w
        WHERE EXISTS (SELECT 1 FROM airplane_wars aw WHERE aw.id_wars = w.id)
      `);
      const war = rows.find(r => slugify(r.name) === slug);
      if (!war) return next(); // 404 standard

      const isEn = req.lang === 'en';
      const name = (isEn && war.name_en) || war.name;
      const desc = (isEn && war.description_en) || war.description || '';
      const y1 = war.date_start ? new Date(war.date_start).getFullYear() : null;
      const y2 = war.date_end ? new Date(war.date_end).getFullYear() : null;
      const years = y1 ? (y2 && y2 !== y1 ? ` (${y1}-${y2})` : (y2 ? ` (${y1})` : ` (${isEn ? 'since' : 'depuis'} ${y1})`)) : '';

      send(req, res, renderHtml({
        title: `${name}${years} | Vol d'Histoire`,
        description: truncate(desc || (isEn
          ? `The military aircraft committed to the ${name}.`
          : `Les appareils militaires engagés : ${name}.`), MAX_DESC),
        url: `${SITE_URL}/conflits/${slug}`,
        h1: name,
        lang: req.lang,
      }));
    } catch (err) {
      next(err);
    }
  });

  return router;
};
