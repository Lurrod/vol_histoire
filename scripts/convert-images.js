#!/usr/bin/env node
/* Convertit frontend/assets/airplanes/*.{jpg,jpeg,png} en .webp + .avif.
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

  console.log(`Conversion de ${files.length} image(s)${force ? ' (force)' : ''}...`);
  const start = Date.now();

  let totalSrc = 0;
  let totalWebp = 0;
  let totalAvif = 0;
  let converted = 0;

  // Sériel (sharp utilise libvips en natif, pas besoin de paralléliser).
  for (const file of files) {
    try {
      const r = await convertOne(file);
      totalSrc += r.srcSize;
      totalWebp += r.webp || 0;
      totalAvif += r.avif || 0;
      const tag = r.skipped.length === 2 ? '·' : '✓';
      console.log(
        `  ${tag} ${file.padEnd(40)} ${fmtKo(r.srcSize).padStart(9)}` +
        `  → webp ${fmtKo(r.webp).padStart(9)} (${fmtPct(r.srcSize, r.webp)})` +
        `  avif ${fmtKo(r.avif).padStart(9)} (${fmtPct(r.srcSize, r.avif)})` +
        (r.skipped.length ? `  [skip: ${r.skipped.join(',')}]` : '')
      );
      if (r.skipped.length < 2) converted++;
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
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
