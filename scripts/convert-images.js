#!/usr/bin/env node
/* Convertit frontend/assets/airplanes/*.{jpg,jpeg,png} en .webp + .avif,
 * plus une vignette 320 px de chaque (thumbs/<nom>.webp + .avif) pour les
 * listes à petite image : ~4 Ko au lieu de ~60 Ko pour la photo pleine.
 * Skip si le fichier cible est plus récent que la source.
 * Usage : node scripts/convert-images.js [--force] [--only <glob>]
 */
'use strict';

const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const SOURCE_DIR = path.join(__dirname, '..', 'frontend', 'assets', 'airplanes');
const SOURCE_EXT = /\.(jpe?g|png)$/i;

const WEBP_OPTS = { quality: 82, effort: 5 };
const AVIF_OPTS = { quality: 55, effort: 4, chromaSubsampling: '4:2:0' };

// Vignettes : 320 px couvrent un affichage jusqu'à 160 px de large en écran 2x.
// Elles doivent exister pour CHAQUE photo : un <source> de <picture> qui 404 ne
// retombe pas sur l'<img>, la vignette manquante laisserait un cadre vide.
const THUMB_DIR = path.join(SOURCE_DIR, 'thumbs');
const THUMB_WIDTH = 320;
const THUMB_WEBP_OPTS = { quality: 72, effort: 5 };
const THUMB_AVIF_OPTS = { quality: 50, effort: 4, chromaSubsampling: '4:2:0' };

const args = process.argv.slice(2);
const force = args.includes('--force');
const onlyIdx = args.indexOf('--only');
const onlyPattern = onlyIdx >= 0 ? args[onlyIdx + 1] : null;

function isStale(source, target) {
  if (force) return true;
  if (!fs.existsSync(target)) return true;
  return fs.statSync(source).mtimeMs > fs.statSync(target).mtimeMs;
}

async function convertOne(filename) {
  const srcPath = path.join(SOURCE_DIR, filename);
  const base = filename.replace(SOURCE_EXT, '');
  const webpPath = path.join(SOURCE_DIR, base + '.webp');
  const avifPath = path.join(SOURCE_DIR, base + '.avif');

  const srcSize = fs.statSync(srcPath).size;
  const tasks = [];
  const results = { file: filename, srcSize, skipped: [] };

  if (isStale(srcPath, webpPath)) {
    tasks.push(
      sharp(srcPath).webp(WEBP_OPTS).toFile(webpPath).then(info => {
        results.webp = info.size;
      })
    );
  } else {
    results.skipped.push('webp');
    results.webp = fs.statSync(webpPath).size;
  }

  if (isStale(srcPath, avifPath)) {
    tasks.push(
      sharp(srcPath).avif(AVIF_OPTS).toFile(avifPath).then(info => {
        results.avif = info.size;
      })
    );
  } else {
    results.skipped.push('avif');
    results.avif = fs.statSync(avifPath).size;
  }

  results.thumb = 0;
  const thumbs = [
    [path.join(THUMB_DIR, base + '.webp'), (img) => img.webp(THUMB_WEBP_OPTS)],
    [path.join(THUMB_DIR, base + '.avif'), (img) => img.avif(THUMB_AVIF_OPTS)],
  ];
  for (const [thumbPath, encode] of thumbs) {
    if (isStale(srcPath, thumbPath)) {
      const img = sharp(srcPath).resize({ width: THUMB_WIDTH, withoutEnlargement: true });
      tasks.push(encode(img).toFile(thumbPath).then(info => {
        results.thumb += info.size;
      }));
    } else {
      results.skipped.push('thumb');
      results.thumb += fs.statSync(thumbPath).size;
    }
  }

  await Promise.all(tasks);
  return results;
}

function fmtKo(bytes) {
  return (bytes / 1024).toFixed(1) + ' Ko';
}

function fmtPct(orig, out) {
  return '-' + Math.round((1 - out / orig) * 100) + '%';
}

async function main() {
  if (!fs.existsSync(SOURCE_DIR)) {
    console.error('Répertoire introuvable :', SOURCE_DIR);
    process.exit(1);
  }

  const all = fs.readdirSync(SOURCE_DIR).filter(f => SOURCE_EXT.test(f));
  const files = onlyPattern
    ? all.filter(f => f.includes(onlyPattern))
    : all;

  if (files.length === 0) {
    console.log('Aucun fichier à convertir.');
    return;
  }

  fs.mkdirSync(THUMB_DIR, { recursive: true });

  console.log(`Conversion de ${files.length} image(s)${force ? ' (force)' : ''}...`);
  const start = Date.now();

  // webp + avif + 2 vignettes : un fichier est « à jour » quand les 4 sont sautés.
  const OUTPUTS_PER_FILE = 4;
  let totalSrc = 0;
  let totalWebp = 0;
  let totalAvif = 0;
  let totalThumb = 0;
  let converted = 0;

  // Sériel (sharp utilise libvips en natif, pas besoin de paralléliser).
  for (const file of files) {
    try {
      const r = await convertOne(file);
      totalSrc += r.srcSize;
      totalWebp += r.webp || 0;
      totalAvif += r.avif || 0;
      totalThumb += r.thumb || 0;
      const tag = r.skipped.length === OUTPUTS_PER_FILE ? '·' : '✓';
      console.log(
        `  ${tag} ${file.padEnd(40)} ${fmtKo(r.srcSize).padStart(9)}` +
        `  → webp ${fmtKo(r.webp).padStart(9)} (${fmtPct(r.srcSize, r.webp)})` +
        `  avif ${fmtKo(r.avif).padStart(9)} (${fmtPct(r.srcSize, r.avif)})` +
        `  vignettes ${fmtKo(r.thumb).padStart(8)}` +
        (r.skipped.length ? `  [skip: ${r.skipped.join(',')}]` : '')
      );
      if (r.skipped.length < OUTPUTS_PER_FILE) converted++;
    } catch (err) {
      console.error(`  ✗ ${file} — ${err.message}`);
      process.exitCode = 1;
    }
  }

  const elapsed = ((Date.now() - start) / 1000).toFixed(1);
  console.log('');
  console.log(`Terminé en ${elapsed}s — ${converted}/${files.length} converties.`);
  console.log(`Total source : ${fmtKo(totalSrc)}`);
  console.log(`Total WebP   : ${fmtKo(totalWebp)} (${fmtPct(totalSrc, totalWebp)})`);
  console.log(`Total AVIF   : ${fmtKo(totalAvif)} (${fmtPct(totalSrc, totalAvif)})`);
  console.log(`Vignettes    : ${fmtKo(totalThumb)} (webp + avif, ${THUMB_WIDTH} px)`);
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
