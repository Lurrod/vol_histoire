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
  // Core partagé — chargé sur toutes les pages principales.
  // vendor/purify.min.js est chargé en <script defer> séparé (déjà minifié, cache immutable).
  // sentry-init.js est chargé en <script defer> séparé après app.min.js (non-critique).
  'app.min.js': [
    'app-version.js',
    'i18n.js',
    'auth.js',
    'utils.js',
    'nav.js',
    'cookies.js',
    'shared/alpha3.js',
    'shared/picture.js',
    'shared/card.js',
  ],

  // Sous-ensemble d'icones Font Awesome (genere par scripts/build-icons.py).
  // Sorti du bundle commun : il pesait 87,8 Ko sur les 111,6 Ko d'app.min.js,
  // soit 79 % d'un fichier charge sur toutes les pages, alors qu'il ne change
  // qu'a l'ajout d'une icone. Separe, il se met en cache pour un an de son cote
  // et ne repart plus a chaque modification du code applicatif.
  //
  // Pourquoi pas un sous-ensemble PAR PAGE (15 a 71 icones sur 164 selon les
  // pages) : quatre appels construisent leur classe a l'execution
  // (`fa-${icon}` dans cookies.js:417, utils.js:119, details/radar.js:94), donc
  // aucune analyse statique ne peut garantir la liste. Une icone manquante ne
  // produit aucune erreur, juste un bouton vide — le projet s'y est deja brule.
  'icons.min.js': ['icons.js'],

  // Pages principales
  'home.min.js': [
    'home/hero-daily.js',
    'script.js',
    'onboarding.js',
    'nations-map.js',
  ],

  'hangar.min.js': [
    'shared/compare.js',
    'nations-map.js',
    'hangar/data.js',
    'hangar/filters.js',
    'hangar/render.js',
    'hangar/admin.js',
    'hangar/compare.js',
    'hangar/view-toggle.js',
    'hangar/mobile-sheet.js',
    'hangar/nations-map-filter.js',
    'hangar.js',
  ],

  'details.min.js': [
    'shared/compare.js',
    'details/markdown.js',
    'details/data.js',
    'details/render.js',
    'details/radar.js',
    'details/favorites.js',
    'details/admin.js',
    'details/lineage.js',
    'details/compare.js',
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
    'settings-cookies.js',
  ],

  'timeline.min.js': [
    'timeline.js',
  ],

  'favorites.min.js': [
    'favorites.js',
  ],

  'contact.min.js': [
    'captcha.js',
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
