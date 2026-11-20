#!/usr/bin/env node
/* Contrôle de cohérence d'une version (lancé par la CI, job quality).
 *
 * La version de package.json (racine) fait foi. Elle doit se retrouver
 * partout où elle est recopiée à la main, et avoir son entrée datée dans
 * CHANGELOG.md. Un oubli faisait partir en production une version sans
 * trace, ou un service worker qui ne se renouvelait pas.
 *
 *   node scripts/check-release.js          → code 1 et liste des écarts
 *
 * Fichiers générés (app-version.js) : vérifiés par le contrôle « fichiers
 * générés à jour » de la CI, pas ici. */
'use strict';

const fs = require('fs');
const path = require('path');

/** Échappe une version pour une expression régulière. */
function esc(v) {
  return String(v).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function read(root, rel) {
  try {
    return fs.readFileSync(path.join(root, rel), 'utf8');
  } catch {
    return null;
  }
}

const DAY_MS = 24 * 60 * 60 * 1000;

/**
 * « Expires » de security.txt (RFC 9116) : obligatoire, à moins d'un an, et
 * pas à moins de 30 jours — la CI échoue à temps pour le renouveler.
 * @returns {string|null} erreur, ou null
 */
function checkSecurityTxtExpiry(content, now) {
  const m = /^Expires:\s*(\S+)\s*$/m.exec(content);
  const at = m ? Date.parse(m[1]) : NaN;
  if (!Number.isFinite(at)) return 'ligne « Expires: » absente ou illisible';
  if (at < now + 30 * DAY_MS) return `« Expires » (${m[1]}) échoit dans moins de 30 jours : la repousser (moins d'un an)`;
  if (at > now + 366 * DAY_MS) return `« Expires » (${m[1]}) à plus d'un an : la RFC 9116 recommande moins d'un an`;
  return null;
}

/**
 * CHANGELOG au format Keep a Changelog 1.1.0 : section « ## [Unreleased] »,
 * entrée « ## [x.y.z] - AAAA-MM-JJ » (« [YANKED] » permis) pour la version
 * courante, et une référence de lien en bas de fichier pour chaque version
 * listée (« Versions and sections should be linkable »).
 * @returns {string[]} erreurs
 */
function checkChangelog(content, version) {
  const errors = [];
  const v = esc(version);
  if (!new RegExp(`^## \\[${v}\\] - \\d{4}-\\d{2}-\\d{2}( \\[YANKED\\])?\\s*$`, 'm').test(content)) {
    errors.push(`aucune entrée « ## [${version}] - AAAA-MM-JJ »`);
  }
  if (!/^## \[Unreleased\]\s*$/m.test(content)) {
    errors.push('section « ## [Unreleased] » manquante (en tête, pour les changements à venir)');
  }
  const labels = [...content.matchAll(/^## \[([^\]]+)\]/gm)].map((m) => m[1]);
  for (const label of labels) {
    const ref = new RegExp(`^\\[${esc(label.toLowerCase())}\\]: https?://\\S+\\s*$`, 'mi');
    if (!ref.test(content)) errors.push(`référence de lien manquante en bas de fichier : « [${label.toLowerCase()}]: … »`);
  }
  return errors;
}

/**
 * @param {string} root - racine du dépôt
 * @param {number} [now] - horodatage de référence (tests)
 * @returns {{ version: string|null, errors: string[] }}
 */
function checkRelease(root, now = Date.now()) {
  const errors = [];
  const pkg = read(root, 'package.json');
  if (!pkg) return { version: null, errors: ['package.json introuvable'] };
  const version = JSON.parse(pkg).version;
  if (!/^\d+\.\d+\.\d+$/.test(version || '')) {
    return { version, errors: [`version de package.json invalide : « ${version} »`] };
  }
  const v = esc(version);

  const expect = (rel, test, what) => {
    const content = read(root, rel);
    if (content == null) errors.push(`${rel} : fichier introuvable`);
    else if (!test(content)) errors.push(`${rel} : ${what}`);
  };

  for (const rel of ['backend/package.json', 'e2e/package.json']) {
    expect(rel, (c) => JSON.parse(c).version === version, `version différente de ${version}`);
  }
  expect('backend/package-lock.json', (c) => {
    const lock = JSON.parse(c);
    return lock.version === version && lock.packages && lock.packages[''] && lock.packages[''].version === version;
  }, `version du verrou différente de ${version} (lancer « npm install » dans backend/)`);
  expect('frontend/sw.js', (c) => new RegExp(`CACHE_VERSION\\s*=\\s*['"]v${v}['"]`).test(c),
    `CACHE_VERSION doit valoir 'v${version}'`);
  expect('backend/openapi.yaml', (c) => new RegExp(`^\\s+version:\\s*${v}\\s*$`, 'm').test(c),
    `info.version doit valoir ${version}`);
  expect('README.md', (c) => new RegExp(`badge/version-${v}-`).test(c),
    `badge de version différent de ${version}`);
  // Format Keep a Changelog 1.1.0 (https://keepachangelog.com/fr/1.1.0/).
  const changelog = read(root, 'CHANGELOG.md');
  if (changelog == null) errors.push('CHANGELOG.md : fichier introuvable');
  else errors.push(...checkChangelog(changelog, version).map((e) => `CHANGELOG.md : ${e}`));
  const security = read(root, 'frontend/.well-known/security.txt');
  const expiry = security == null ? 'fichier introuvable' : checkSecurityTxtExpiry(security, now);
  if (expiry) errors.push(`frontend/.well-known/security.txt : ${expiry}`);

  return { version, errors };
}

if (require.main === module) {
  const { version, errors } = checkRelease(path.join(__dirname, '..'));
  if (errors.length) {
    console.error(`✗ Version ${version} incohérente :`);
    errors.forEach((e) => console.error(`  - ${e}`));
    process.exit(1);
  }
  console.log(`✓ Version ${version} cohérente (packages, verrou, service worker, OpenAPI, README, CHANGELOG, security.txt)`);
}

module.exports = { checkRelease, checkSecurityTxtExpiry, checkChangelog };
