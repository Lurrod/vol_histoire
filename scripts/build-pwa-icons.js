#!/usr/bin/env node
/* Génère les icônes PWA PNG (192/512) à partir de frontend/assets/logo/favicon.svg.
 * Le SVG source est full-bleed (fond charcoal couvrant 64×64) avec le logo champagne
 * centré dans la zone safe ~60-80 % — compatible avec purpose: "any maskable".
 * À relancer si favicon.svg change.
 */
const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const SRC = path.join(__dirname, '../frontend/assets/logo/favicon.svg');
const OUT_DIR = path.join(__dirname, '../frontend/assets/logo');

const SIZES = [192, 512];

async function main() {
  if (!fs.existsSync(SRC)) {
    console.error(`Source introuvable : ${SRC}`);
    process.exit(1);
  }
  const svg = fs.readFileSync(SRC);
  for (const size of SIZES) {
    const out = path.join(OUT_DIR, `icon-${size}.png`);
    await sharp(svg, { density: Math.ceil(size * 72 / 64) })
      .resize(size, size, { fit: 'contain', background: { r: 11, g: 11, b: 12, alpha: 1 } })
      .png({ compressionLevel: 9 })
      .toFile(out);
    const kb = (fs.statSync(out).size / 1024).toFixed(1);
    console.log(`  icon-${size}.png ${kb.padStart(6)} KB`);
  }
  console.log(`\n  ${SIZES.length} icônes PNG écrites dans frontend/assets/logo/`);
}

main().catch(err => { console.error(err); process.exit(1); });
