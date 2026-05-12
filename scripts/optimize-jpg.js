#!/usr/bin/env node
/* Optimise les JPG sources de frontend/assets/airplanes/ :
 *   - resize max 1600 px de largeur (sans agrandir)
 *   - mozjpeg q82 + chromaSubsampling 4:2:0
 *   - écrase le fichier source
 *
 * À utiliser après import d'un lot de nouvelles photos pour réduire le fallback
 * JPG servi via <picture> aux navigateurs sans AVIF/WebP (~3-5% du trafic) et
 * pour borner le poids du repo. Régénérer ensuite les WebP/AVIF :
 *
 *   node scripts/optimize-jpg.js          # seuil par défaut 200 Ko
 *   node scripts/optimize-jpg.js --min 0  # toutes les images, force re-encode
 *   node scripts/convert-images.js --force
 *
 * Sharp ne peut pas lire+écrire le même fichier → on passe par un buffer.
 */
'use strict';

const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const SOURCE_DIR = path.join(__dirname, '..', 'frontend', 'assets', 'airplanes');
const SOURCE_EXT = /\.jpe?g$/i;

const MAX_WIDTH = 1600;
const JPEG_OPTS = {
  quality: 82,
  mozjpeg: true,
  chromaSubsampling: '4:2:0',
  progressive: true,
};

const args = process.argv.slice(2);
const minIdx = args.indexOf('--min');
const minKb = minIdx >= 0 ? Number(args[minIdx + 1]) : 200;
const onlyIdx = args.indexOf('--only');
const onlyPattern = onlyIdx >= 0 ? args[onlyIdx + 1] : null;
const dryRun = args.includes('--dry');

function fmtKo(bytes) {
  return (bytes / 1024).toFixed(1) + ' Ko';
}

async function optimizeOne(filename) {
  const srcPath = path.join(SOURCE_DIR, filename);
  const srcSize = fs.statSync(srcPath).size;

  // Lire en buffer d'abord pour libérer le handle file avant de réécrire.
  // Sinon sous Windows : EBUSY/UNKNOWN sur fs.writeFileSync car libvips peut
  // garder le fd ouvert tant que le pipeline n'est pas drainé.
  const inBuf = fs.readFileSync(srcPath);

  const meta = await sharp(inBuf).metadata();
  const needsResize = meta.width > MAX_WIDTH;

  const pipeline = sharp(inBuf, { failOn: 'none' });
  if (needsResize) pipeline.resize({ width: MAX_WIDTH, withoutEnlargement: true });
  const outBuf = await pipeline.jpeg(JPEG_OPTS).toBuffer();

  if (!dryRun) fs.writeFileSync(srcPath, outBuf);

  return {
    file: filename,
    width: meta.width,
    resized: needsResize,
    srcSize,
    outSize: outBuf.length,
  };
}

async function main() {
  if (!fs.existsSync(SOURCE_DIR)) {
    console.error('Répertoire introuvable :', SOURCE_DIR);
    process.exit(1);
  }

  const minBytes = minKb * 1024;
  const all = fs.readdirSync(SOURCE_DIR)
    .filter(f => SOURCE_EXT.test(f))
    .filter(f => fs.statSync(path.join(SOURCE_DIR, f)).size > minBytes)
    .filter(f => !onlyPattern || f.includes(onlyPattern))
    .sort((a, b) => fs.statSync(path.join(SOURCE_DIR, b)).size - fs.statSync(path.join(SOURCE_DIR, a)).size);

  if (all.length === 0) {
    console.log(`Aucun JPG > ${minKb} Ko à optimiser.`);
    return;
  }

  console.log(`${all.length} JPG > ${minKb} Ko à optimiser${dryRun ? ' (dry-run)' : ''}.`);
  const start = Date.now();
  let totalIn = 0;
  let totalOut = 0;

  for (const file of all) {
    try {
      const r = await optimizeOne(file);
      totalIn += r.srcSize;
      totalOut += r.outSize;
      const diff = r.srcSize - r.outSize;
      const pct = Math.round((diff / r.srcSize) * 100);
      console.log(
        `  ${file.padEnd(40)}  ${fmtKo(r.srcSize).padStart(9)} → ${fmtKo(r.outSize).padStart(9)}` +
        `  (-${pct}%)` +
        (r.resized ? `  resized ${r.width}→${MAX_WIDTH}px` : '')
      );
    } catch (err) {
      console.error(`  ✗ ${file} — ${err.message}`);
      process.exitCode = 1;
    }
  }

  const elapsed = ((Date.now() - start) / 1000).toFixed(1);
  console.log('');
  console.log(`Terminé en ${elapsed}s.`);
  console.log(`Total source : ${fmtKo(totalIn)}`);
  console.log(`Total sortie : ${fmtKo(totalOut)} (-${Math.round((1 - totalOut / totalIn) * 100)}%)`);
  if (!dryRun) {
    console.log('');
    console.log('→ Régénérer maintenant les WebP/AVIF :');
    console.log('  node scripts/convert-images.js --force');
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
