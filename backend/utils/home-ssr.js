'use strict';

/**
 * Accueil : photo de l'appareil du jour écrite par le serveur dans index.html.
 *
 * Cette photo est l'élément LCP de l'accueil. Posée par le script, elle
 * n'était demandée qu'après le chargement des bundles PUIS l'appel à
 * /api/hero/discoveries (≈ 2,6 s sur un téléphone en 4G lente) ; écrite dans
 * le HTML, le navigateur la demande dès la lecture de la page, en priorité
 * haute. Le script (js/home/hero-today.js) retrouve la même photo et n'y
 * touche pas (applySourcesTo compare les chemins sans ?v=).
 *
 * Choix de l'appareil : même règle que le client (js/home/hero-daily.js,
 * selectEphemeris) — la première entrée de l'écart au jour le plus petit.
 * Jour sans éphéméride (repli sur un fait éditorial) : la page part telle
 * quelle et le script choisit la photo.
 */

const LOCAL_IMG_RE = /^\/assets\/airplanes\/[^/?#"]+\.(jpe?g|png)$/i;
const EXT_RE = /\.(jpe?g|png)$/i;

// Gabarit exact de index.html : <picture> vide de la photo du jour.
const HERO_PICTURE_RE = /<picture><source type="image\/avif" srcset=""><source type="image\/webp" srcset=""><img id="hero-today-image"([^>]*?) src="[^"]*"([^>]*?) alt=""/;

function escapeAttr(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

/** Entrée affichée par le widget « Ce jour-là », ou null. */
function dayEntry(payload) {
  const list = payload && Array.isArray(payload.ephemeris) ? payload.ephemeris : [];
  if (!list.length) return null;
  const best = list.reduce((min, e) => Math.min(min, Number(e.day_gap) || 0), Infinity);
  return list.find(e => (Number(e.day_gap) || 0) === best) || null;
}

/** { avif, webp, fallback, alt } de la photo du jour, ou null. */
function dayPhoto(payload, { lang = 'fr', version = '' } = {}) {
  const entry = dayEntry(payload);
  const url = entry && entry.image_url;
  if (!url || !LOCAL_IMG_RE.test(url)) return null;
  const v = version ? `?v=${encodeURIComponent(version)}` : '';
  const base = url.replace(EXT_RE, '');
  const name = (lang === 'en' && entry.airplane_name_en) ? entry.airplane_name_en : entry.airplane_name;
  return { avif: `${base}.avif${v}`, webp: `${base}.webp${v}`, fallback: `${url}${v}`, alt: name || '' };
}

/** Écrit la photo du jour dans le <picture> du hero ; HTML inchangé sinon. */
function injectDayPhoto(html, payload, options) {
  const photo = dayPhoto(payload, options);
  if (!photo || !HERO_PICTURE_RE.test(html)) return html;
  return html.replace(HERO_PICTURE_RE, (_, before, after) =>
    `<picture><source type="image/avif" srcset="${escapeAttr(photo.avif)}">` +
    `<source type="image/webp" srcset="${escapeAttr(photo.webp)}">` +
    `<img id="hero-today-image"${before} src="${escapeAttr(photo.fallback)}"${after} alt="${escapeAttr(photo.alt)}"`);
}

module.exports = { dayEntry, dayPhoto, injectDayPhoto };
