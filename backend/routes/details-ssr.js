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
const { rewrite: rewriteAssets } = require('../middleware/serveHtml');

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

  // Lire details.html une fois au démarrage et appliquer le cache busting
  // sur les références asset (même version que celle injectée par serveHtml.js).
  const templatePath = path.join(__dirname, '../../frontend/details.html');
  let template = '';
  try {
    const raw = fs.readFileSync(templatePath, 'utf8');
    let pkgVersion = 'dev';
    try { pkgVersion = require('../package.json').version || 'dev'; } catch (_) {}
    template = rewriteAssets(raw, pkgVersion);
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

    // OG image : image de l'avion, fallback default.
    // - HTTP → HTTPS (crawlers sociaux stricts refusent HTTP).
    // - Chemin relatif (/assets/airplanes/...) → préfixer SITE_URL
    //   (les OG tags exigent une URL absolue).
    const rawImage = aircraft.image_url || DEFAULT_OG;
    let ogImage;
    if (rawImage.startsWith('http://')) {
      ogImage = rawImage.replace(/^http:\/\//, 'https://');
    } else if (rawImage.startsWith('/')) {
      ogImage = SITE_URL + rawImage;
    } else {
      ogImage = rawImage;
    }

    // Preload LCP : image hero AVIF (si asset local). Le browser lance la requête
    // avant que le JS n'ait résolu l'URL via l'API — gain typique 300-800 ms sur LCP.
    // On préload AVIF uniquement (Safari 16+ / Chrome / Firefox 113+) ; navigateurs
    // plus anciens retombent sur JPG via le <picture> normal.
    let heroPreloadTag = '';
    const localAssetMatch = /^\/assets\/airplanes\/([^/?#]+)\.(jpe?g|png)(\?.*)?$/i.exec(rawImage);
    if (localAssetMatch) {
      const avifHref = `/assets/airplanes/${localAssetMatch[1]}.avif`;
      heroPreloadTag = `  <link rel="preload" as="image" href="${escapeHtml(avifHref)}" type="image/avif" fetchpriority="high">\n`;
    }

    // Alt descriptif par fiche : "F-16 Fighting Falcon — chasseur 4e gen · États-Unis"
    const altParts = [name];
    if (generation) altParts.push(isEn ? `${generation}th gen fighter` : `chasseur ${generation}e gen`);
    if (country) altParts.push(country);
    const ogImageAlt = altParts.join(' — ');

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

    // hreflang fr / en / x-default — toutes pointent vers la même URL
    // (le site sert le même HTML, l'i18n est résolue côté client via cookie/lang)
    html = html.replace(
      /<link rel="alternate" hreflang="fr" href="[^"]*">/,
      `<link rel="alternate" hreflang="fr" href="${escapeHtml(url)}">`
    );
    html = html.replace(
      /<link rel="alternate" hreflang="en" href="[^"]*">/,
      `<link rel="alternate" hreflang="en" href="${escapeHtml(url)}">`
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
    // og:image:alt → texte contextualisé (SEO + accessibilité partage social)
    html = html.replace(
      /<meta property="og:image:alt" content="[^"]*">/,
      `<meta property="og:image:alt" content="${escapeHtml(ogImageAlt)}">`
    );

    // twitter:title / twitter:description / twitter:image + alt
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
    html = html.replace(
      /<meta name="twitter:image:alt" content="[^"]*">/,
      `<meta name="twitter:image:alt" content="${escapeHtml(ogImageAlt)}">`
    );

    // Remplacer le bloc JSON-LD existant par notre Article + BreadcrumbList
    html = html.replace(
      /<script type="application\/ld\+json">[\s\S]*?<\/script>/,
      ldJsonScript
    );

    // Injecter le preload AVIF du hero juste après les preloads de fonts.
    // Idempotent : on remplace tout preload image existant pour éviter les doublons
    // lors de re-rendus ou de tests.
    html = html.replace(
      /\s*<link rel="preload"[^>]*as="image"[^>]*>/g,
      ''
    );
    if (heroPreloadTag) {
      html = html.replace(
        /(<link rel="preload" href="[^"]*BarlowCondensed[^"]*"[^>]*>\s*)/,
        `$1${heroPreloadTag}`
      );
    }

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

  // Construit la querystring canonique à préserver lors d'une 301
  // (ex. ?lang=en doit survivre, ?id=X doit être retiré).
  function buildExtraQuery(query) {
    const extras = {};
    for (const [k, v] of Object.entries(query || {})) {
      if (k === 'id') continue;
      extras[k] = v;
    }
    const qs = new URLSearchParams(extras).toString();
    return qs ? `?${qs}` : '';
  }

  async function handle(req, res, next) {
    try {
      // Extraction de l'id : depuis le slug d'URL ou ?id=
      const slugParam = req.params && req.params.slug ? req.params.slug : null;
      const queryIdRaw = req.query && req.query.id ? req.query.id : null;

      let id = null;
      if (slugParam) id = idFromSlug(slugParam);
      if (!id && queryIdRaw) id = Number(queryIdRaw);

      // Pas d'id → laisser le HTML statique se charger (le JS gérera la redirection)
      if (!id || isNaN(id)) {
        return next();
      }

      const aircraft = await fetchAircraft(id);
      if (!aircraft) {
        return next(); // 404 standard
      }

      // Slug canonique basé sur le nom réel en base + id.
      const canonicalSlug = `${slugify(aircraft.name)}-${aircraft.id}`;
      const extraQs = buildExtraQuery(req.query);

      // Cas 1 : URL legacy /details?id=X → 301 vers /details/<slug>-<id>
      // Cas 2 : /details/<mauvais-slug>-X (slug ne correspond plus au nom actuel)
      //         → 301 vers le slug canonique. Évite la double-indexation.
      if (!slugParam || slugParam !== canonicalSlug) {
        return res.redirect(301, `/details/${canonicalSlug}${extraQs}`);
      }

      const lang = req.lang || 'fr';
      const html = renderHtml(aircraft, lang);
      if (!html) return next();

      res.set('Content-Type', 'text/html; charset=utf-8');
      // 1h côté navigateur, 2h côté CDN ; stale-while-revalidate pour éviter
      // qu'une régénération lente ne bloque un crawler.
      res.set('Cache-Control', 'public, max-age=3600, s-maxage=7200, stale-while-revalidate=86400');
      const inject = req.app.injectCspNonce;
      res.send(typeof inject === 'function' ? inject(html, res.locals.cspNonce) : html);
    } catch (err) {
      next(err);
    }
  }

  router.get('/details/:slug', handle);
  router.get('/details', handle);

  return router;
};
