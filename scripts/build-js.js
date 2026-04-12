#!/usr/bin/env node
/**
 * Build JS bundles : concatène les scripts dans le bon ordre, minifie via
 * esbuild, écrit les bundles dans frontend/js/dist/.
 *
 * Stratégie :
 *   1. app.min.js    — core partagé (purify, auth, i18n, icons, nav, utils…)
 *   2. <page>.min.js — scripts spécifiques par page
 *
 * Les fichiers source restent intacts pour le dev local.
 * Usage : node scripts/build-js.js
 */

const fs = require('fs');
const path = require('path');
const esbuild = require('esbuild');

const JS   = path.join(__dirname, '..', 'frontend', 'js');
const DIST = path.join(JS, 'dist');

// ── Définition des bundles ─────────────────────────────────────────────

const BUNDLES = {
  // Core partagé — chargé sur toutes les pages principales
  'app.min.js': [
    'vendor/purify.min.js',
    'app-version.js',
    'sentry-init.js',
    'i18n.js',
    'icons.js',
    'auth.js',
    'utils.js',
    'nav.js',
    'cookies.js',
    'shared/alpha3.js',
    'shared/card.js',
  ],

  // Pages principales
  'home.min.js': [
    'script.js',
  ],

  'hangar.min.js': [
    'hangar/data.js',
    'hangar/filters.js',
    'hangar/render.js',
    'hangar/admin.js',
    'hangar/compare.js',
    'hangar/view-toggle.js',
    'hangar/mobile-sheet.js',
    'hangar.js',
  ],

  'details.min.js': [
    'details/data.js',
    'details/render.js',
    'details/radar.js',
    'details/favorites.js',
    'details/admin.js',
    'details/ui.js',
    'details.js',
  ],

  'login.min.js': [
    'captcha.js',
    'login.js',
  ],

  'settings.min.js': [
    'settings.js',
    'settings-admin.js',
    'settings-dashboard.js',
  ],

  'timeline.min.js': [
    'timeline.js',
  ],

  'favorites.min.js': [
    'favorites.js',
  ],

  'contact.min.js': [
    'contact.js',
  ],
};

// ── Build ──────────────────────────────────────────────────────────────

async function build() {
  // Créer le dossier dist/
  if (!fs.existsSync(DIST)) fs.mkdirSync(DIST, { recursive: true });

  let totalSrc = 0;
  let totalMin = 0;

  for (const [outName, files] of Object.entries(BUNDLES)) {
    // Concaténer les fichiers source dans l'ordre
    const parts = files.map(f => {
      const full = path.join(JS, f);
      if (!fs.existsSync(full)) {
        console.error(`  ERREUR : ${f} introuvable`);
        process.exit(1);
      }
      return fs.readFileSync(full, 'utf8');
    });

    const concat = parts.join('\n;\n');
    totalSrc += Buffer.byteLength(concat, 'utf8');

    // Minifier via esbuild (pas de bundling, juste transform)
    // Pas de format: 'iife' — les scripts utilisent des globals (auth, i18n, etc.)
    // qui doivent rester accessibles entre bundles.
    const { code } = await esbuild.transform(concat, {
      minify: true,
      target: 'es2020',
    });

    const outPath = path.join(DIST, outName);
    fs.writeFileSync(outPath, code, 'utf8');

    const srcKB = (Buffer.byteLength(concat, 'utf8') / 1024).toFixed(1);
    const minKB = (Buffer.byteLength(code, 'utf8') / 1024).toFixed(1);
    const ratio = ((1 - Buffer.byteLength(code, 'utf8') / Buffer.byteLength(concat, 'utf8')) * 100).toFixed(0);
    totalMin += Buffer.byteLength(code, 'utf8');

    console.log(`  ${outName.padEnd(22)} ${srcKB.padStart(7)} KB → ${minKB.padStart(7)} KB  (−${ratio}%)`);
  }

  console.log('');
  console.log(`  TOTAL${' '.repeat(16)} ${(totalSrc / 1024).toFixed(1).padStart(7)} KB → ${(totalMin / 1024).toFixed(1).padStart(7)} KB  (−${((1 - totalMin / totalSrc) * 100).toFixed(0)}%)`);
  console.log(`\n  ${Object.keys(BUNDLES).length} bundles écrits dans frontend/js/dist/`);
}

build().catch(err => {
  console.error(err);
  process.exit(1);
});
