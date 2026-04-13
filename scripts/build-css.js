#!/usr/bin/env node
/**
 * Build CSS bundles : génère un core partagé + un bundle par page.
 *
 * Stratégie :
 *   1. core.min.css  — tokens, icons, base, shared, fonts, cookies (~30 KB min)
 *   2. <page>.min.css — CSS spécifique à chaque page (~10-25 KB min chacun)
 *
 * Chaque page HTML charge : core.min.css (bloquant) + <page>.min.css (bloquant).
 * Le total par page est inférieur à l'ancien app.min.css monolithique (218 KB).
 *
 * Usage : node scripts/build-css.js
 */

const fs = require('fs');
const path = require('path');

const CSS_DIR = path.join(__dirname, '..', 'frontend', 'css');

// ── Définition des bundles ─────────────────────────────────────────────

const BUNDLES = {
  // Core partagé — chargé sur toutes les pages
  'core.min.css': [
    'tokens.css',
    'icons.css',
    'base.css',
    'shared.css',
    'fonts.css',
    'cookies.css',
  ],

  // Page-specific
  'home.min.css': ['style.css'],
  'hangar.min.css': ['hangar.css'],
  'details.min.css': ['details.css'],
  'timeline.min.css': ['timeline.css'],
  'favorites.min.css': ['favorites.css'],
  'login.min.css': ['login.css'],
  'settings.min.css': ['settings.css'],
  'legal.min.css': ['legal.css'],
};

// ── Minification ──────────────────────────────────────────────────────

function minify(css) {
  return css
    .replace(/\/\*[\s\S]*?\*\//g, '')
    .replace(/\s+/g, ' ')
    .replace(/\s*([{}:;,>+~])\s*/g, '$1')
    .replace(/^\s+|\s+$/g, '')
    .replace(/;}/g, '}')
    .replace(/}@/g, '}\n@');
}

// ── Build ─────────────────────────────────────────────────────────────

function main() {
  let totalIn = 0;
  let totalOut = 0;

  for (const [outName, files] of Object.entries(BUNDLES)) {
    let raw = '';
    const missing = [];

    for (const file of files) {
      const fp = path.join(CSS_DIR, file);
      if (!fs.existsSync(fp)) {
        missing.push(file);
        continue;
      }
      const content = fs.readFileSync(fp, 'utf8');
      totalIn += content.length;
      raw += `\n/* === ${file} === */\n` + content;
    }

    if (missing.length) {
      console.warn(`  ${outName}: fichiers manquants (skip) :`, missing.join(', '));
    }

    const minified = minify(raw);
    const outPath = path.join(CSS_DIR, outName);
    fs.writeFileSync(outPath, minified, 'utf8');
    totalOut += minified.length;

    const inKB = (Buffer.byteLength(raw, 'utf8') / 1024).toFixed(1);
    const outKB = (minified.length / 1024).toFixed(1);
    const ratio = raw.length > 0
      ? ((1 - minified.length / Buffer.byteLength(raw, 'utf8')) * 100).toFixed(0)
      : 0;

    console.log(`  ${outName.padEnd(22)} ${inKB.padStart(7)} KB → ${outKB.padStart(7)} KB  (−${ratio}%)`);
  }

  console.log('');
  console.log(`  TOTAL${' '.repeat(16)} ${(totalIn / 1024).toFixed(1).padStart(7)} KB → ${(totalOut / 1024).toFixed(1).padStart(7)} KB  (−${((1 - totalOut / totalIn) * 100).toFixed(0)}%)`);
  console.log(`\n  ${Object.keys(BUNDLES).length} bundles écrits dans frontend/css/`);
}

main();
