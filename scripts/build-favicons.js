#!/usr/bin/env node
/* Génère les icônes matricielles et le visuel de partage par défaut :
 *   frontend/favicon.ico              16 / 32 / 48 px (PNG dans un conteneur ICO)
 *   frontend/assets/logo/icon-48.png  favicon PNG (Google : multiple de 48)
 *   frontend/apple-touch-icon.png     180 × 180, plein cadre (iOS arrondit lui-même)
 *   frontend/og-default.jpg           1200 × 630, image OG par défaut
 *
 * Sources : frontend/assets/logo/favicon.svg et favicon-16.svg (charte charcoal +
 * champagne), et la photo du F-15C (domaine public, USAF — Airman 1st Class
 * Matthew Seefeldt, voir backend/db_backup/f15_eagle.sql).
 * À relancer si le logo change. Dépendance : sharp (devDependency racine).
 */
const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const FRONT = path.join(__dirname, '../frontend');
const LOGO_DIR = path.join(FRONT, 'assets/logo');
const CHARCOAL = '#0B0B0C';
const CHAMPAGNE = '#C8A96E';
const PAPER = '#F0EDE8';

const svg16 = fs.readFileSync(path.join(LOGO_DIR, 'favicon-16.svg'));
const svg64 = fs.readFileSync(path.join(LOGO_DIR, 'favicon.svg'));
// Plein cadre pour iOS : coins carrés, le système applique son propre masque.
const svgSquare = Buffer.from(svg64.toString().replace(/rx="[^"]*"/, 'rx="0"'));

function pngFromSvg(svg, size, viewBox) {
  return sharp(svg, { density: Math.ceil(size * 72 / viewBox) })
    .resize(size, size)
    .png({ compressionLevel: 9 })
    .toBuffer();
}

/* Conteneur ICO dont chaque entrée est un PNG (accepté depuis Windows Vista
 * et par tous les navigateurs actuels). */
function buildIco(images) {
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0); // réservé
  header.writeUInt16LE(1, 2); // type : icône
  header.writeUInt16LE(images.length, 4);
  const dir = Buffer.alloc(16 * images.length);
  let offset = 6 + dir.length;
  images.forEach(({ size, data }, i) => {
    const o = i * 16;
    dir.writeUInt8(size >= 256 ? 0 : size, o);
    dir.writeUInt8(size >= 256 ? 0 : size, o + 1);
    dir.writeUInt8(0, o + 2); // palette
    dir.writeUInt8(0, o + 3); // réservé
    dir.writeUInt16LE(1, o + 4); // plans
    dir.writeUInt16LE(32, o + 6); // bits par pixel
    dir.writeUInt32LE(data.length, o + 8);
    dir.writeUInt32LE(offset, o + 12);
    offset += data.length;
  });
  return Buffer.concat([header, dir, ...images.map(i => i.data)]);
}

/* Bandeau texte du visuel OG. Polices système : le rendu SVG de sharp ne lit
 * pas les woff2 du site ; Arial Narrow approche Barlow Condensed. */
function ogOverlaySvg() {
  return Buffer.from(`<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630">
  <defs>
    <linearGradient id="fade" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="${CHARCOAL}" stop-opacity="1"/>
      <stop offset="0.42" stop-color="${CHARCOAL}" stop-opacity="0.94"/>
      <stop offset="0.7" stop-color="${CHARCOAL}" stop-opacity="0.35"/>
      <stop offset="1" stop-color="${CHARCOAL}" stop-opacity="0.15"/>
    </linearGradient>
  </defs>
  <rect width="1200" height="630" fill="url(#fade)"/>
  <rect x="0" y="0" width="1200" height="630" fill="none" stroke="${CHAMPAGNE}" stroke-opacity="0.35" stroke-width="2"/>
  <g transform="translate(80 150) scale(0.9)">
    <circle cx="64" cy="64" r="58" fill="none" stroke="${CHAMPAGNE}" stroke-width="1.5" opacity=".45"/>
    <circle cx="64" cy="64" r="44" fill="none" stroke="${CHAMPAGNE}" stroke-width="1" opacity=".3"/>
    <g fill="${CHAMPAGNE}">
      <path d="M64 22 L66.2 58 L66.2 82 L68.5 96 L64 94 L59.5 96 L61.8 82 L61.8 58 Z"/>
      <path d="M64 56 L100 86 L100 90 L64 78 L28 90 L28 86 Z"/>
      <path d="M64 86 L78 98 L78 100 L64 96 L50 100 L50 98 Z"/>
    </g>
  </g>
  <g font-family="'Arial Narrow', 'Barlow Condensed', Arial, sans-serif">
    <text x="80" y="350" font-size="84" fill="${PAPER}" letter-spacing="2">VOL</text>
    <text x="80" y="435" font-size="84" fill="${CHAMPAGNE}" letter-spacing="2">D'HISTOIRE</text>
    <text x="82" y="500" font-size="30" fill="${PAPER}" fill-opacity="0.8" letter-spacing="1">L'aviation militaire depuis 1945</text>
  </g>
  <rect x="82" y="530" width="120" height="3" fill="${CHAMPAGNE}"/>
</svg>`);
}

async function buildOgImage(out) {
  const photo = path.join(FRONT, 'assets/airplanes/f15c-eagle.jpg');
  // Photo désaturée et réchauffée pour tenir dans la charte, calée à droite.
  const plane = await sharp(photo)
    .resize({ height: 630 })
    .modulate({ saturation: 0.25, brightness: 0.8 })
    .tint({ r: 200, g: 180, b: 140 })
    .toBuffer({ resolveWithObject: true });
  const left = Math.max(0, 1200 - plane.info.width);
  await sharp({ create: { width: 1200, height: 630, channels: 3, background: CHARCOAL } })
    .composite([
      { input: plane.data, left, top: 0 },
      { input: ogOverlaySvg(), left: 0, top: 0 },
    ])
    .jpeg({ quality: 82, mozjpeg: true, chromaSubsampling: '4:2:0' })
    .toFile(out);
}

async function main() {
  const ico = buildIco([
    { size: 16, data: await pngFromSvg(svg16, 16, 16) },
    { size: 32, data: await pngFromSvg(svg64, 32, 64) },
    { size: 48, data: await pngFromSvg(svg64, 48, 64) },
  ]);
  fs.writeFileSync(path.join(FRONT, 'favicon.ico'), ico);

  fs.writeFileSync(path.join(LOGO_DIR, 'icon-48.png'), await pngFromSvg(svg64, 48, 64));
  fs.writeFileSync(path.join(FRONT, 'apple-touch-icon.png'), await pngFromSvg(svgSquare, 180, 64));
  await buildOgImage(path.join(FRONT, 'og-default.jpg'));

  for (const f of ['favicon.ico', 'assets/logo/icon-48.png', 'apple-touch-icon.png', 'og-default.jpg']) {
    const kb = (fs.statSync(path.join(FRONT, f)).size / 1024).toFixed(1);
    console.log(`  ${f.padEnd(26)} ${kb.padStart(6)} Ko`);
  }
}

main().catch(err => { console.error(err); process.exit(1); });
