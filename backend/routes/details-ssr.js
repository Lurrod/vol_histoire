/**
 * SSR léger pour /details/:slug et /details?id=X
 * Injecte dynamiquement <title>, <meta description>, og:*, twitter:*,
 * canonical et JSON-LD (Article + BreadcrumbList) à partir de l'avion réel.
 *
 * Pourquoi : la page details.html contient des balises génériques. Sans ce
 * middleware, Googlebot indexe toutes les fiches sous le même titre/description,
 * ce qui tue le SEO. Le rendu JS côté client ne suffit pas pour les crawlers.
 */

const fs = require('fs');
const path = require('path');
const express = require('express');

const SITE_URL = 'https://vol-histoire.titouan-borde.com';
const DEFAULT_OG = `${SITE_URL}/og-default.jpg`;

function escapeHtml(str) {
  return String(str || '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

function escapeJson(str) {
  return String(str || '').replace(/[\u0000-\u001f\u2028\u2029]/g, c => `\\u${c.charCodeAt(0).toString(16).padStart(4, '0')}`);
}

function slugify(text) {
  return String(text || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

/**
 * Extrait l'id depuis un slug "f-16-fighting-falcon-12" → 12
 */
function idFromSlug(slug) {
  if (!slug) return null;
  const m = String(slug).match(/-?(\d+)$/);
  return m ? Number(m[1]) : null;
}

module.exports = function createDetailsSsrRouter(getPool) {
  const router = express.Router();

  // Lire details.html une fois au démarrage
  const templatePath = path.join(__dirname, '../../frontend/details.html');
  let template = '';
  try {
    template = fs.readFileSync(templatePath, 'utf8');
  } catch (err) {
    // En tests, le fichier peut être absent — pas bloquant
    template = '';
  }

  function renderHtml(aircraft, lang) {
    if (!template) return null;

    const isEn = lang === 'en';
    const name = aircraft.name || 'Avion';
    const completeName = aircraft.complete_name || name;
    const country = aircraft.country_name || '';
    const manufacturer = aircraft.manufacturer_name || '';
    const year = aircraft.date_operationel
      ? new Date(aircraft.date_operationel).getFullYear()
      : null;
    const generation = aircraft.generation;

    // Title : "F-16 Fighting Falcon — Chasseur 4e gen · États-Unis (1978) | Vol d'Histoire"
    const titleParts = [];
    titleParts.push(name);
    if (completeName && completeName !== name) {
      titleParts.push(`— ${completeName}`);
    }
    const subParts = [];
    if (generation) subParts.push(isEn ? `${generation}th gen fighter` : `Chasseur ${generation}e génération`);
    if (country) subParts.push(country);
    if (year) subParts.push(`(${year})`);
    if (subParts.length) titleParts.push('·', subParts.join(' · '));
    const title = `${titleParts.join(' ')} | Vol d'Histoire`;

    // Description : utiliser la description courte de l'avion
    const rawDesc = aircraft.little_description || aircraft.description || '';
    const cleanDesc = String(rawDesc).replace(/\s+/g, ' ').trim();
    const description = cleanDesc.length > 160
      ? cleanDesc.slice(0, 157) + '…'
      : cleanDesc || `Découvrez les spécifications, l'armement et l'historique du ${name}.`;

    // OG image : image de l'avion, fallback default
    const ogImage = aircraft.image_url || DEFAULT_OG;

    // URL canonique : /details/<slug>-<id>
    const slug = `${slugify(name)}-${aircraft.id}`;
    const url = `${SITE_URL}/details/${slug}`;

    // JSON-LD : Article + BreadcrumbList
    const articleLd = {
      '@context': 'https://schema.org',
      '@type': 'Article',
      headline: title.replace(' | Vol d\'Histoire', ''),
      name: name,
      description: description,
      image: ogImage,
      url: url,
      inLanguage: isEn ? 'en' : 'fr',
      author: {
        '@type': 'Organization',
        name: 'Vol d\'Histoire',
        url: SITE_URL,
      },
      publisher: {
        '@type': 'Organization',
        name: 'Vol d\'Histoire',
        url: SITE_URL,
        logo: {
          '@type': 'ImageObject',
          url: `${SITE_URL}/og-default.jpg`,
        },
      },
      isPartOf: {
        '@type': 'CollectionPage',
        name: 'Hangar — Collection d\'Avions',
        url: `${SITE_URL}/hangar`,
      },
      about: {
        '@type': 'Thing',
        name: name,
        description: description,
      },
    };
    if (year) articleLd.datePublished = `${year}-01-01`;

    const breadcrumbLd = {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      itemListElement: [
        {
          '@type': 'ListItem',
          position: 1,
          name: isEn ? 'Home' : 'Accueil',
          item: SITE_URL + '/',
        },
        {
          '@type': 'ListItem',
          position: 2,
          name: isEn ? 'Hangar' : 'Hangar',
          item: `${SITE_URL}/hangar`,
        },
        {
          '@type': 'ListItem',
          position: 3,
          name: name,
          item: url,
        },
      ],
    };

    const ldJsonScript =
      `<script type="application/ld+json">${escapeJson(JSON.stringify(articleLd))}</script>\n` +
      `  <script type="application/ld+json">${escapeJson(JSON.stringify(breadcrumbLd))}</script>`;

    // Substitution dans le template
    let html = template;

    // <title>
    html = html.replace(
      /<title[^>]*>[^<]*<\/title>/,
      `<title>${escapeHtml(title)}</title>`
    );

    // <meta name="description">
    html = html.replace(
      /<meta name="description" content="[^"]*">/,
      `<meta name="description" content="${escapeHtml(description)}">`
    );

    // canonical
    html = html.replace(
      /<link rel="canonical" href="[^"]*">/,
      `<link rel="canonical" href="${escapeHtml(url)}">`
    );

    // hreflang fr
    html = html.replace(
      /<link rel="alternate" hreflang="fr" href="[^"]*">/,
      `<link rel="alternate" hreflang="fr" href="${escapeHtml(url)}">`
    );
    html = html.replace(
      /<link rel="alternate" hreflang="x-default" href="[^"]*">/,
      `<link rel="alternate" hreflang="x-default" href="${escapeHtml(url)}">`
    );

    // og:title / og:description / og:url / og:image
    html = html.replace(
      /<meta property="og:title" content="[^"]*">/,
      `<meta property="og:title" content="${escapeHtml(title)}">`
    );
    html = html.replace(
      /<meta property="og:description" content="[^"]*">/,
      `<meta property="og:description" content="${escapeHtml(description)}">`
    );
    html = html.replace(
      /<meta property="og:url" content="[^"]*">/,
      `<meta property="og:url" content="${escapeHtml(url)}">`
    );
    html = html.replace(
      /<meta property="og:image" content="[^"]*">/,
      `<meta property="og:image" content="${escapeHtml(ogImage)}">`
    );

    // twitter:title / twitter:description / twitter:image
    html = html.replace(
      /<meta name="twitter:title" content="[^"]*">/,
      `<meta name="twitter:title" content="${escapeHtml(title)}">`
    );
    html = html.replace(
      /<meta name="twitter:description" content="[^"]*">/,
      `<meta name="twitter:description" content="${escapeHtml(description)}">`
    );
    html = html.replace(
      /<meta name="twitter:image" content="[^"]*">/,
      `<meta name="twitter:image" content="${escapeHtml(ogImage)}">`
    );

    // Remplacer le bloc JSON-LD existant par notre Article + BreadcrumbList
    html = html.replace(
      /<script type="application\/ld\+json">[\s\S]*?<\/script>/,
      ldJsonScript
    );

    // <html lang="..."> ajustement (default fr, switch en si besoin)
    if (isEn) {
      html = html.replace(/<html lang="fr">/, '<html lang="en">');
    }

    return html;
  }

  async function fetchAircraft(id) {
    const result = await getPool().query(
      `SELECT a.id, a.name, a.complete_name, a.little_description, a.description,
              a.image_url, a.max_speed, a.max_range, a.weight, a.date_operationel,
              c.name AS country_name, c.code AS country_code,
              g.generation, t.name AS type_name,
              m.name AS manufacturer_name
       FROM airplanes a
       LEFT JOIN countries c ON a.country_id = c.id
       LEFT JOIN generation g ON a.id_generation = g.id
       LEFT JOIN type t ON a.type = t.id
       LEFT JOIN manufacturer m ON a.id_manufacturer = m.id
       WHERE a.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async function handle(req, res, next) {
    try {
      // Extraction de l'id : depuis le slug d'URL ou ?id=
      let id = null;
      if (req.params && req.params.slug) {
        id = idFromSlug(req.params.slug);
      }
      if (!id && req.query && req.query.id) {
        id = Number(req.query.id);
      }

      // Pas d'id → laisser le HTML statique se charger (le JS gérera la redirection)
      if (!id || isNaN(id)) {
        return next();
      }

      const aircraft = await fetchAircraft(id);
      if (!aircraft) {
        return next(); // 404 standard
      }

      const lang = req.lang || 'fr';
      const html = renderHtml(aircraft, lang);
      if (!html) return next();

      res.set('Content-Type', 'text/html; charset=utf-8');
      res.set('Cache-Control', 'public, max-age=300, s-maxage=600');
      res.send(html);
    } catch (err) {
      next(err);
    }
  }

  router.get('/details/:slug', handle);
  router.get('/details', handle);

  return router;
};
