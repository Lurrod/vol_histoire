#!/usr/bin/env node
/* Génère les icônes PWA PNG à partir de frontend/assets/logo/favicon.svg.
 *
 * Deux familles, déclarées séparément dans manifest.webmanifest :
 *  - icon-<taille>.png (purpose "any") : rendu fidèle du favicon, coins
 *    arrondis transparents compris — c'est l'icône telle qu'on la dessine.
 *  - icon-maskable-<taille>.png (purpose "maskable") : fond charcoal OPAQUE
 *    bord à bord et pictogramme réduit dans la zone de sécurité. Le lanceur
 *    Android découpe l'icône (cercle, squircle, carré) : seul le disque
 *    centré de rayon 40 % est garanti visible. Le point le plus éloigné du
 *    pictogramme (extrémité d'aile) est ramené à ~34 % du côté.
 *
 * Le fond et la couleur du pictogramme reprennent tokens.css (--night,
 * champagne #C8A96E), comme theme_color et background_color du manifest.
 * À relancer si favicon.svg change.
 */
const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const SRC = path.join(__dirname, '../frontend/assets/logo/favicon.svg');
const OUT_DIR = path.join(__dirname, '../frontend/assets/logo');

const SIZES = [192, 512];
const NIGHT = '#0D0D0D';         // tokens.css --night
const NIGHT_RGB = { r: 13, g: 13, b: 13, alpha: 1 };

// Facteur d'échelle du pictogramme dans l'icône maskable (viewBox 64).
// Point le plus éloigné du centre : (12, 49) → 26,2 unités, soit 41 % du côté
// à l'échelle 1, hors de la zone de sécurité. À 0,82 : ~21,5 unités (34 %).
const MASKABLE_SCALE = 0.82;

/** Extrait les tracés du pictogramme (contenu du <g>) du SVG source. */
function extractGlyph(svg) {
  const m = svg.match(/<g\b[^>]*>([\s\S]*?)<\/g>/);
  if (!m) throw new Error('Pictogramme introuvable dans favicon.svg (<g> attendu)');
  const fill = (svg.match(/<g\b[^>]*fill="([^"]+)"/) || [])[1] || '#C8A96E';
  return { paths: m[1], fill };
}

/** SVG maskable : fond plein carré, pictogramme mis à l'échelle et recentré. */
function maskableSvg(svg) {
  const { paths, fill } = extractGlyph(svg);
  // Boîte du pictogramme : x 12→52, y 14→52, centre (32, 33) → recentré en (32, 32).
  const s = MASKABLE_SCALE;
  const tx = 32 - 32 * s;
  const ty = 32 - 33 * s;
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">`
    + `<rect width="64" height="64" fill="${NIGHT}"/>`
    + `<g fill="${fill}" transform="translate(${tx.toFixed(3)} ${ty.toFixed(3)}) scale(${s})">${paths}</g>`
    + '</svg>';
}

async function render(svgBuffer, size, out, opts = {}) {
  let pipeline = sharp(svgBuffer, { density: Math.ceil(size * 72 / 64) })
    .resize(size, size, { fit: 'contain', background: NIGHT_RGB });
  if (opts.flatten) pipeline = pipeline.flatten({ background: NIGHT_RGB });
  await pipeline.png({ compressionLevel: 9 }).toFile(out);
  const kb = (fs.statSync(out).size / 1024).toFixed(1);
  console.log(`  ${path.basename(out).padEnd(24)} ${kb.padStart(6)} KB`);
}

async function main() {
  if (!fs.existsSync(SRC)) {
    console.error(`Source introuvable : ${SRC}`);
    process.exit(1);
  }
  const svg = fs.readFileSync(SRC, 'utf8');
  const maskable = Buffer.from(maskableSvg(svg));
  for (const size of SIZES) {
    await render(Buffer.from(svg), size, path.join(OUT_DIR, `icon-${size}.png`));
    await render(maskable, size, path.join(OUT_DIR, `icon-maskable-${size}.png`), { flatten: true });
  }
  console.log(`\n  ${SIZES.length * 2} icônes PNG écrites dans frontend/assets/logo/`);
}

if (require.main === module) {
  main().catch(err => { console.error(err); process.exit(1); });
}

module.exports = { maskableSvg, extractGlyph, MASKABLE_SCALE };
