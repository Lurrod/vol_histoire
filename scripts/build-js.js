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
    'home/text.js',
    'home/search-suggest.js',
    'home/landing.js',
    'home/hero-helpers.js',
    'home/hero-data.js',
    'home/hero-today.js',
    'home/hero-quiz.js',
    'home/hero-stats.js',
    'home/page-effects.js',
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
    'shared/airplane-options.js',
    'shared/airplane-fields.js',
    'shared/airplane-form.js',
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
    'shared/photo-credit.js',
    'details/render.js',
    'details/radar.js',
    'details/favorites.js',
    'shared/airplane-options.js',
    'shared/airplane-fields.js',
    'shared/airplane-form.js',
    'details/admin.js',
    'details/lineage.js',
    'details/compare.js',
    'details/ui.js',
    'details.js',
  ],

  'login.min.js': [
    'captcha.js',
    'login/state.js',
    'login/strength.js',
    'login/tabs.js',
    'login/ui.js',
    'login/forms.js',
    'login.js',
  ],

  'settings.min.js': [
    'settings/ui.js',
    'settings/tabs.js',
    'settings/account.js',
    'settings/profile.js',
    'settings/security.js',
    'settings/danger-zone.js',
    'settings/admin.js',
    'settings/dashboard.js',
    'settings/cookies.js',
    'settings/data-export.js',
    'settings.js',
  ],

  'timeline.min.js': [
    'timeline/util.js',
    'timeline/era.js',
    'timeline/data.js',
    'timeline/render.js',
    'timeline/observers.js',
    'timeline/effects.js',
    'timeline/keyboard.js',
    'timeline.js',
  ],

  'conflicts.min.js': [
    'conflicts.js',
  ],

  // Page Crédits photo (LEGAL-003) : attribution de toutes les photos.
  'credits.min.js': [
    'shared/photo-credit.js',
    'credits.js',
  ],
  'favorites.min.js': [
    'favorites/filters.js',
    'favorites/url.js',
    'favorites/render.js',
    'favorites/remove.js',
    'favorites/data.js',
    'favorites/dropdowns.js',
    'favorites/toolbar.js',
    'favorites.js',
  ],

  'contact.min.js': [
    'captcha.js',
    'contact.js',
  ],
};

// ── Version applicative ────────────────────────────────────────────────

/* app-version.js est concaténé en tête d'app.min.js : la version publiée est
 * donc celle du BUILD. Il était réécrit au démarrage du serveur, ce qui ne
 * changeait rien au bundle déjà construit (la 4.13.1 tournait avec
 * APP_VERSION="4.13.0", d'où une mauvaise release dans Sentry, JS-004) et
 * laissait un fichier suivi modifié sur le serveur à chaque boot.
 * Source : package.json racine, celui que la procédure de release incrémente.
 * Contenu déterministe (pas d'horodatage) : rebuild à version égale = aucun
 * diff dans les fichiers versionnés. */
function writeAppVersion() {
  const pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8'));
  if (typeof pkg.version !== 'string' || !/^\d+\.\d+\.\d+/.test(pkg.version)) {
    throw new Error(`Version invalide dans package.json : ${pkg.version}`);
  }
  const out = [
    '/* Généré par scripts/build-js.js depuis package.json — ne pas éditer */',
    `window.APP_VERSION = ${JSON.stringify(pkg.version)};`,
    '',
  ].join('\n');
  const file = path.join(JS, 'app-version.js');
  const current = fs.existsSync(file) ? fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n') : null;
  if (current !== out) fs.writeFileSync(file, out, 'utf8');
  return pkg.version;
}

// ── Champs du formulaire d'appareil ────────────────────────────────────

/* Le formulaire d'appareil (shared/airplane-form.js, modales de création et
 * d'édition) décrit ses champs d'après la table du backend,
 * backend/utils/airplane-fields.js, source unique qui pilote aussi l'INSERT
 * et l'UPDATE (ARCH-007). Ce fichier backend est du CommonJS : il ne peut pas
 * être concaténé tel quel dans un bundle navigateur. On le recopie donc en
 * shared/airplane-fields.js, versionné, régénéré à chaque build.
 * frontend/__tests__/airplane-form.test.js compare les deux : un build oublié
 * après l'ajout d'une colonne fait échouer les tests. Contenu déterministe. */
function jsLiteral(value) {
  if (Array.isArray(value)) return `[${value.map(jsLiteral).join(', ')}]`;
  if (typeof value === 'string') return `'${value.replace(/\\/g, '\\\\').replace(/'/g, "\\'")}'`;
  if (typeof value === 'boolean' || typeof value === 'number') return String(value);
  throw new Error(`Valeur inattendue dans AIRPLANE_FIELDS : ${JSON.stringify(value)}`);
}

function writeAirplaneFields() {
  const { AIRPLANE_FIELDS } = require(path.join(__dirname, '..', 'backend', 'utils', 'airplane-fields.js'));
  const lines = AIRPLANE_FIELDS.map((field) => {
    const props = Object.entries(field).map(([key, value]) => `${key}: ${jsLiteral(value)}`);
    return `    { ${props.join(', ')} },`;
  });
  const out = [
    '/* Généré par scripts/build-js.js depuis backend/utils/airplane-fields.js — ne pas éditer.',
    ' * Champs éditables d\'une fiche appareil, dans l\'ordre de la table backend. */',
    '(function () {',
    '  window.VH = window.VH || {};',
    '  window.VH.shared = window.VH.shared || {};',
    '  const AIRPLANE_FIELDS = [',
    ...lines,
    '  ];',
    '  VH.shared.AIRPLANE_FIELDS = AIRPLANE_FIELDS;',
    '  if (typeof module !== \'undefined\' && module.exports) module.exports = AIRPLANE_FIELDS;',
    '})();',
    '',
  ].join('\n');
  const file = path.join(JS, 'shared', 'airplane-fields.js');
  const current = fs.existsSync(file) ? fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n') : null;
  if (current !== out) fs.writeFileSync(file, out, 'utf8');
  return AIRPLANE_FIELDS.length;
}

// ── Bibliothèques tierces (frontend/js/vendor/) ────────────────────────

/* DOMPurify et @sentry/browser étaient recopiés à la main dans vendor/ :
 * aucun package.json ne les déclarait, npm audit et npm outdated ne les
 * voyaient pas (JS-009). Ils sont désormais en devDependencies de
 * frontend/package.json et vendor/ est produit ici depuis node_modules.
 * Les pages chargent toujours js/vendor/purify.min.js (<script defer>) et
 * sentry-init.js charge js/vendor/sentry.min.js à la demande : chemins
 * inchangés. Prérequis : `cd frontend && npm install`. */
const FRONTEND = path.join(__dirname, '..', 'frontend');
const VENDOR = path.join(JS, 'vendor');

function frontendPackage(name) {
  const dir = path.join(FRONTEND, 'node_modules', ...name.split('/'));
  const pkgFile = path.join(dir, 'package.json');
  if (!fs.existsSync(pkgFile)) {
    throw new Error(`${name} introuvable dans frontend/node_modules : lancer « cd frontend && npm install ».`);
  }
  return { dir, version: JSON.parse(fs.readFileSync(pkgFile, 'utf8')).version };
}

function writeIfChanged(file, content) {
  const current = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : null;
  if (current !== content) fs.writeFileSync(file, content, 'utf8');
}

async function buildVendor() {
  if (!fs.existsSync(VENDOR)) fs.mkdirSync(VENDOR, { recursive: true });

  // DOMPurify : le build UMD minifié du paquet, tel quel (expose window.DOMPurify).
  const purify = frontendPackage('dompurify');
  writeIfChanged(
    path.join(VENDOR, 'purify.min.js'),
    fs.readFileSync(path.join(purify.dir, 'dist', 'purify.min.js'), 'utf8')
  );

  // @sentry/browser : le paquet npm ne contient pas les bundles du CDN. On
  // reconstruit l'équivalent du bundle de base (bundle.min.js : intégrations
  // par défaut, sans tracing ni replay) en n'exposant que ce que
  // sentry-init.js appelle. IIFE + globalName → window.Sentry, comme avant.
  const sentry = frontendPackage('@sentry/browser');
  const result = await esbuild.build({
    stdin: {
      contents: "export { init, captureException } from '@sentry/browser';",
      resolveDir: FRONTEND,
      loader: 'js',
    },
    bundle: true,
    format: 'iife',
    globalName: 'Sentry',
    minify: true,
    target: 'es2020',
    platform: 'browser',
    write: false,
    legalComments: 'none',
    define: {
      __SENTRY_DEBUG__: 'false',
      __SENTRY_BROWSER_BUNDLE__: 'true',
    },
    banner: { js: `/*! @sentry/browser ${sentry.version} | MIT | https://github.com/getsentry/sentry-javascript */` },
  });
  writeIfChanged(path.join(VENDOR, 'sentry.min.js'), result.outputFiles[0].text);

  console.log(`  vendor/purify.min.js   DOMPurify ${purify.version}`);
  console.log(`  vendor/sentry.min.js   @sentry/browser ${sentry.version}`);
}

// ── Build ──────────────────────────────────────────────────────────────

async function build() {
  // Créer le dossier dist/
  if (!fs.existsSync(DIST)) fs.mkdirSync(DIST, { recursive: true });

  const version = writeAppVersion();
  console.log(`  app-version.js         ${version}`);
  console.log(`  airplane-fields.js     ${writeAirplaneFields()} champs`);
  await buildVendor();
  console.log('');

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
