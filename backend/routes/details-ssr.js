/**
 * SSR léger pour /details/:slug et /details?id=X
 * Injecte dynamiquement <title>, <meta description>, og:*, twitter:*,
 * canonical, hreflang et JSON-LD (Article dont l'objet est un Vehicle,
 * + BreadcrumbList) à partir de l'avion réel, dans la langue de la requête.
 *
 * Pourquoi : la page details.html contient des balises génériques. Sans ce
 * middleware, Googlebot indexe toutes les fiches sous le même titre/description,
 * ce qui tue le SEO. Le rendu JS côté client ne suffit pas pour les crawlers.
 *
 * Découpage : la requête SQL vit dans repositories/ssr-details.js, la
 * construction des données (meta, JSON-LD) dans les fonctions build* exportées
 * ci-dessous (testables sans HTTP), la réécriture du gabarit dans renderHtml.
 */

const path = require('path');
const express = require('express');
const { renderTemplate } = require('../middleware/serveHtml');
// Source unique des slugs : une copie locale a divergé en silence pendant
// des mois, et c'est elle qui fabrique les URL canoniques des 434 fiches.
const { slugify, idFromSlug } = require('../utils/url');
const {
  SITE_URL, DEFAULT_OG_IMAGE, PUBLISHER_LOGO,
  escapeHtml, toAbsoluteUrl, jsonLdScript, breadcrumbLd, langUrl, buildDescription,
  applyHeadMeta, replaceJsonLd, sendSsrHtml,
} = require('../utils/ssr-head');
const { findAircraftForSsr } = require('../repositories/ssr-details');
const { isValidDbId } = require('../middleware/input-guards');

const FRONTEND_DIR = path.join(__dirname, '../../frontend');
const LOCAL_IMAGE_RE = /^\/assets\/airplanes\/([^/?#]+)\.(jpe?g|png)(\?.*)?$/i;

function readVersion() {
  try { return require('../package.json').version || 'dev'; } catch { return 'dev'; }
}

/**
 * Sources du hero pour un asset local : AVIF / WebP / repli, versionnées par
 * ?v= comme les URL que produit frontend/js/shared/picture.js — sinon le
 * navigateur verrait deux URL et téléchargerait l'image LCP deux fois.
 * @returns {{avif: string, webp: string, img: string}|null}
 */
function buildHeroSources(rawImage, version) {
  const m = LOCAL_IMAGE_RE.exec(rawImage || '');
  if (!m) return null;
  const v = version ? `?v=${encodeURIComponent(version)}` : '';
  const base = `/assets/airplanes/${m[1]}`;
  const img = m[3] ? rawImage : `${rawImage}${v}`;
  return { avif: `${base}.avif${v}`, webp: `${base}.webp${v}`, img };
}

const TITLE_SUFFIX = " | Vol d'Histoire";
// Longueur visée pour <title> (suffixe compris) : au-delà, Google tronque.
const TITLE_MAX = 65;

function yearOf(date) {
  if (!date) return null;
  const y = new Date(date).getFullYear();
  return Number.isFinite(y) ? y : null;
}

/**
 * Titre de la fiche : « <nom> — <type>, <pays> (<année>) », le type venant
 * de la table `type` (chasseur, bombardier, transport, drone…). Les éléments
 * les moins utiles tombent un à un tant que le titre dépasse TITLE_MAX :
 * l'année, puis le pays, puis le type. Le nom complet du constructeur n'y
 * figure plus (il répétait presque toujours le nom) : il reste dans le h1,
 * la description et le JSON-LD (alternateName).
 * La génération n'y figure pas : elle n'a de sens que pour les chasseurs,
 * et l'accroche de la fiche la mentionne déjà quand elle compte.
 * @returns {string} titre sans le suffixe du site
 */
function buildHeadline(name, type, country, year) {
  const yearPart = year ? ` (${year})` : '';
  const candidates = [];
  if (type && country) candidates.push(`${name} — ${type}, ${country}${yearPart}`);
  if (type && country && year) candidates.push(`${name} — ${type}, ${country}`);
  if (type) candidates.push(`${name} — ${type}${yearPart}`);
  if (!type && country) candidates.push(`${name} — ${country}${yearPart}`);
  if (type) candidates.push(`${name} — ${type}`);
  if (year) candidates.push(`${name}${yearPart}`);
  candidates.push(name);
  return candidates.find(c => c.length + TITLE_SUFFIX.length <= TITLE_MAX)
    || candidates[candidates.length - 1];
}

/**
 * Données de tête d'une fiche (titre, description, image, URL canonique…).
 * @param {object} aircraft - ligne de findAircraftForSsr
 * @param {'fr'|'en'} lang
 * @param {string} version - version servie (cache-busting des images)
 */
function buildDetailsMeta(aircraft, lang, version) {
  const isEn = lang === 'en';
  const frName = aircraft.name || 'Avion';
  const name = (isEn && aircraft.name_en) || frName;
  const completeName = (isEn && aircraft.complete_name_en) || aircraft.complete_name || name;
  const country = (isEn && aircraft.country_name_en) || aircraft.country_name || '';
  const type = (isEn && aircraft.type_name_en) || aircraft.type_name || '';
  // Année de mise en service, à défaut celle du premier vol (prototypes et
  // projets annulés n'ont pas de mise en service).
  const year = yearOf(aircraft.date_operationel) || yearOf(aircraft.date_first_fly);

  const headline = buildHeadline(name, type, country, year);

  // Description (≈ 140-160 caractères) : l'accroche courte, complétée du
  // début du récit sans Markdown — l'accroche seule faisait 63 caractères en
  // médiane, trop peu pour un extrait de résultat.
  const lead = isEn ? aircraft.little_description_en : aircraft.little_description;
  const narrative = isEn ? aircraft.description_en : aircraft.description;
  const filler = isEn
    ? `Specifications, armament, production and history of the ${name}.`
    : `Fiche technique, armement, production et histoire : ${name}.`;
  const description = buildDescription(lead, narrative, filler, 158, isEn ? 'en' : 'fr');

  // og:image : URL absolue HTTPS, sans ?v= (les robots sociaux la gardent
  // en cache de leur côté ; elle doit rester stable).
  const rawImage = aircraft.image_url || DEFAULT_OG_IMAGE;
  const ogImage = toAbsoluteUrl(rawImage);

  // Alt descriptif : "F-16 Fighting Falcon — Multirôle — États-Unis"
  const altParts = [name];
  if (type) altParts.push(type);
  if (country) altParts.push(country);

  // URL de la fiche : /details/<slug>-<id>, slug du nom français quelle que
  // soit la langue ; la version anglaise est la même URL suivie de ?lang=en,
  // canonique sur elle-même (canonical).
  const url = `${SITE_URL}/details/${slugify(frName)}-${aircraft.id}`;

  return {
    lang: isEn ? 'en' : 'fr',
    name,
    completeName,
    country,
    title: `${headline}${TITLE_SUFFIX}`,
    headline,
    description,
    url,
    canonical: langUrl(url, isEn ? 'en' : 'fr'),
    rawImage,
    ogImage,
    ogImageAlt: altParts.join(' — '),
    hero: buildHeroSources(rawImage, version),
  };
}

/** Fiche technique Schema.org de l'appareil (objet de l'Article). */
function buildVehicleLd(aircraft, meta) {
  const isEn = meta.lang === 'en';
  const ld = {
    '@type': 'Vehicle',
    name: meta.name,
    description: meta.description,
    image: meta.ogImage,
    url: meta.canonical,
  };
  if (meta.completeName && meta.completeName !== meta.name) ld.alternateName = meta.completeName;
  const type = (isEn && aircraft.type_name_en) || aircraft.type_name;
  if (type) ld.vehicleConfiguration = type;
  if (aircraft.date_operationel) {
    ld.vehicleModelDate = String(new Date(aircraft.date_operationel).getFullYear());
  }
  if (aircraft.date_first_fly) {
    ld.productionDate = new Date(aircraft.date_first_fly).toISOString().slice(0, 10);
  }
  if (aircraft.manufacturer_name) {
    ld.manufacturer = { '@type': 'Organization', name: aircraft.manufacturer_name };
  }
  if (meta.country) ld.countryOfOrigin = { '@type': 'Country', name: meta.country };
  if (aircraft.max_speed) {
    ld.speed = { '@type': 'QuantitativeValue', value: Number(aircraft.max_speed), unitCode: 'KMH' };
  }
  if (aircraft.empty_weight) {
    ld.weight = { '@type': 'QuantitativeValue', value: Number(aircraft.empty_weight), unitCode: 'KGM' };
  }
  if (aircraft.max_range) {
    // Schema.org n'a pas de champ « autonomie » pour Vehicle.
    ld.additionalProperty = [{ '@type': 'PropertyValue', name: 'Range', value: Number(aircraft.max_range), unitCode: 'KMT' }];
  }
  return ld;
}

/**
 * Entité principale de la page : un Article (la fiche) dont l'objet (`about`)
 * est le Vehicle. Une seule entité principale, au lieu d'un Article et d'un
 * Vehicle concurrents.
 */
function buildArticleLd(aircraft, meta) {
  const isEn = meta.lang === 'en';
  const article = {
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: meta.headline,
    name: meta.name,
    description: meta.description,
    image: meta.ogImage,
    url: meta.canonical,
    inLanguage: meta.lang,
    author: { '@type': 'Organization', name: 'Vol d\'Histoire', url: SITE_URL },
    publisher: {
      '@type': 'Organization',
      name: 'Vol d\'Histoire',
      url: SITE_URL,
      logo: { '@type': 'ImageObject', url: PUBLISHER_LOGO, width: 512, height: 512 },
    },
    isPartOf: {
      '@type': 'CollectionPage',
      name: isEn ? 'Hangar — Aircraft collection' : 'Hangar — Collection d\'Avions',
      url: langUrl(`${SITE_URL}/hangar`, meta.lang),
    },
    about: buildVehicleLd(aircraft, meta),
  };
  // datePublished décrit la fiche, pas l'appareil : y mettre l'année de mise
  // en service faisait annoncer « publié en 1955 » pour un texte écrit en 2026.
  if (aircraft.created_at) {
    article.datePublished = new Date(aircraft.created_at).toISOString().slice(0, 10);
  }
  if (aircraft.updated_at) {
    article.dateModified = new Date(aircraft.updated_at).toISOString().slice(0, 10);
  }
  return article;
}

function buildDetailsBreadcrumbLd(meta) {
  return breadcrumbLd([
    { name: meta.lang === 'en' ? 'Home' : 'Accueil', url: langUrl(`${SITE_URL}/`, meta.lang) },
    { name: 'Hangar', url: langUrl(`${SITE_URL}/hangar`, meta.lang) },
    { name: meta.name, url: meta.canonical },
  ]);
}

/** Remplace le hero du gabarit (preload, <picture>, <h1>) pour un rendu sans JS. */
function applyHero(html, meta) {
  const { hero } = meta;
  let out = html;
  // Idempotent : retire tout preload image existant avant d'injecter le nôtre.
  out = out.replace(/\s*<link rel="preload"[^>]*as="image"[^>]*>/g, '');
  if (hero) {
    // Preload LCP : le navigateur lance la requête AVIF avant que le JS n'ait
    // résolu l'URL via l'API — gain typique 300-800 ms sur le LCP.
    const tag = `  <link rel="preload" as="image" href="${escapeHtml(hero.avif)}" type="image/avif" fetchpriority="high">\n`;
    out = out.replace(/(<link rel="preload" href="[^"]*BarlowCondensed[^"]*"[^>]*>\s*)/, (m) => m + tag);
  }
  // <h1> rempli pour les robots (les robots sociaux n'exécutent pas le JS) ;
  // le client réécrit ensuite la même donnée.
  out = out.replace(/<h1 id="aircraft-name"[^>]*>[^<]*<\/h1>/,
    () => `<h1 id="aircraft-name">${escapeHtml(meta.name)}</h1>`);
  out = out.replace(/<source id="hero-image-avif"[^>]*>/,
    () => `<source id="hero-image-avif" type="image/avif" srcset="${escapeHtml(hero ? hero.avif : '')}">`);
  out = out.replace(/<source id="hero-image-webp"[^>]*>/,
    () => `<source id="hero-image-webp" type="image/webp" srcset="${escapeHtml(hero ? hero.webp : '')}">`);
  const imgSrc = hero ? hero.img : meta.rawImage;
  out = out.replace(/<img id="hero-image"[^>]*>/,
    () => `<img id="hero-image" src="${escapeHtml(imgSrc)}" alt="${escapeHtml(meta.ogImageAlt)}" class="aircraft-image" width="800" height="500" fetchpriority="high" decoding="async">`);
  return out;
}

/**
 * Gabarit details.html → HTML de la fiche.
 * @returns {string|null} null si le gabarit est absent
 */
function renderHtml(template, aircraft, lang, version) {
  if (!template) return null;
  const meta = buildDetailsMeta(aircraft, lang, version);
  let html = applyHeadMeta(template, {
    title: meta.title,
    description: meta.description,
    url: meta.url,
    image: meta.ogImage,
    imageAlt: meta.ogImageAlt,
    lang: meta.lang,
  });
  html = replaceJsonLd(html, [
    jsonLdScript('jsonld-article', buildArticleLd(aircraft, meta)),
    jsonLdScript('jsonld-breadcrumb', buildDetailsBreadcrumbLd(meta)),
  ]);
  return applyHero(html, meta);
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

// Identifiant de fiche : entier strictement positif dans la plage int4 de
// PostgreSQL (au-delà, la requête échouerait en 500 au lieu d'un 404 —
// SEC-003). Même garde que les routes API (middleware/input-guards.js).
function parseId(raw) {
  if (raw == null || !isValidDbId(raw)) return null;
  const id = Number(raw);
  return id >= 1 ? id : null;
}

/**
 * Vraie réponse 404 (page 404 du site, statut 404). Sans elle, /details sans
 * identifiant ou /details?id=<inconnu> retombaient sur le gabarit générique
 * en 200 « index, follow » : une page vide indexable (soft 404).
 */
function sendNotFound(req, res) {
  res.status(404);
  const send = req.app && req.app.sendCachedHtml;
  if (typeof send === 'function') return send(res, path.join(FRONTEND_DIR, '404.html'));
  return res.send('Page non trouvée');
}

function createDetailsSsrRouter(getPool) {
  const router = express.Router();
  const version = readVersion();
  // Lu une fois au démarrage, avec l'en-tête et le pied de page partagés et
  // le cache busting des assets (même version que serveHtml.js).
  const template = renderTemplate(FRONTEND_DIR, 'details.html', version);

  async function handle(req, res, next) {
    try {
      // Extraction de l'id : depuis le slug d'URL ou ?id=
      const slugParam = req.params && req.params.slug ? req.params.slug : null;
      const queryIdRaw = req.query && req.query.id ? req.query.id : null;

      let id = null;
      if (slugParam) id = parseId(idFromSlug(slugParam));
      if (!id && queryIdRaw) id = parseId(queryIdRaw);

      // Pas d'identifiant exploitable, ou fiche inconnue : 404 réel.
      if (!id) return sendNotFound(req, res);
      const aircraft = await findAircraftForSsr(getPool(), id);
      if (!aircraft) return sendNotFound(req, res);

      // Slug canonique basé sur le nom réel en base + id.
      const canonicalSlug = `${slugify(aircraft.name)}-${aircraft.id}`;

      // Cas 1 : URL legacy /details?id=X → 301 vers /details/<slug>-<id>
      // Cas 2 : /details/<mauvais-slug>-X (slug ne correspond plus au nom actuel)
      //         → 301 vers le slug canonique. Évite la double-indexation.
      if (!slugParam || slugParam !== canonicalSlug) {
        return res.redirect(301, `/details/${canonicalSlug}${buildExtraQuery(req.query)}`);
      }

      const html = renderHtml(template, aircraft, req.lang || 'fr', version);
      if (!html) return next();
      sendSsrHtml(req, res, html);
    } catch (err) {
      next(err);
    }
  }

  router.get('/details/:slug', handle);
  router.get('/details', handle);

  return router;
}

module.exports = createDetailsSsrRouter;
module.exports.buildDetailsMeta = buildDetailsMeta;
module.exports.buildVehicleLd = buildVehicleLd;
module.exports.buildArticleLd = buildArticleLd;
module.exports.buildDetailsBreadcrumbLd = buildDetailsBreadcrumbLd;
module.exports.buildHeroSources = buildHeroSources;
module.exports.renderHtml = renderHtml;
