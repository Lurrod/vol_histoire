/**
 * Tests — scripts/check-release.js (cohérence d'une version, lancé par la CI).
 */
const fs = require('fs');
const os = require('os');
const path = require('path');
const { checkRelease, checkSecurityTxtExpiry, checkChangelog } = require('../../scripts/check-release');

const V = '4.23.1';
const NOW = Date.parse('2026-11-20T12:00:00Z');
const DAY = 24 * 60 * 60 * 1000;
const REPO = 'https://github.com/Lurrod/vol_histoire';
const expires = (ms) => `Contact: mailto:x@y.z\nExpires: ${new Date(ms).toISOString()}\n`;

/** CHANGELOG minimal au format Keep a Changelog, versions de la plus récente à la plus ancienne. */
function changelog(versions, { links = true } = {}) {
  const body = versions.map((v) => `## [${v}] - 2026-11-20\n\n### Fixed\n\n- x\n`);
  const refs = links
    ? [`[unreleased]: ${REPO}/compare/v${versions[0]}...HEAD`, ...versions.map((v) => `[${v}]: ${REPO}/releases/tag/v${v}`)]
    : [];
  return ['# Changelog', '', '## [Unreleased]', '', ...body, ...refs].join('\n') + '\n';
}

function writeRepo(overrides = {}) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'vh-release-'));
  const files = {
    'package.json': JSON.stringify({ name: 'vh', version: V }),
    'backend/package.json': JSON.stringify({ version: V }),
    'e2e/package.json': JSON.stringify({ version: V }),
    'backend/package-lock.json': JSON.stringify({ version: V, packages: { '': { version: V } } }),
    'frontend/sw.js': `const CACHE_VERSION = 'v${V}';\n`,
    'backend/openapi.yaml': `openapi: 3.0.3\ninfo:\n  title: VH\n  version: ${V}\n`,
    'README.md': `<img src="https://img.shields.io/badge/version-${V}-C8A96E">\n`,
    'CHANGELOG.md': changelog([V, '4.23.0']),
    'frontend/.well-known/security.txt': expires(NOW + 300 * DAY),
    ...overrides,
  };
  for (const [rel, content] of Object.entries(files)) {
    if (content == null) continue;
    fs.mkdirSync(path.dirname(path.join(dir, rel)), { recursive: true });
    fs.writeFileSync(path.join(dir, rel), content);
  }
  return dir;
}

test('dépôt cohérent : aucune erreur', () => {
  expect(checkRelease(writeRepo(), NOW)).toEqual({ version: V, errors: [] });
});

test('le dépôt réel est cohérent', () => {
  const { errors } = checkRelease(path.join(__dirname, '..', '..'));
  expect(errors).toEqual([]);
});

test('chaque copie oubliée est signalée', () => {
  const old = '4.23.0';
  const { errors } = checkRelease(writeRepo({
    'backend/package.json': JSON.stringify({ version: old }),
    'e2e/package.json': JSON.stringify({ version: old }),
    'backend/package-lock.json': JSON.stringify({ version: V, packages: { '': { version: old } } }),
    'frontend/sw.js': `const CACHE_VERSION = 'v${old}';\n`,
    'backend/openapi.yaml': `info:\n  version: ${old}\n`,
    'README.md': `badge/version-${old}-C8A96E\n`,
    'frontend/.well-known/security.txt': expires(NOW + 10 * DAY),
  }), NOW);
  expect(errors).toHaveLength(7);
  const all = errors.join('\n');
  expect(all).toMatch(/backend\/package\.json/);
  expect(all).toMatch(/e2e\/package\.json/);
  expect(all).toMatch(/verrou/);
  expect(all).toMatch(/CACHE_VERSION/);
  expect(all).toMatch(/openapi/);
  expect(all).toMatch(/README/);
  expect(all).toMatch(/security\.txt : « Expires »/);
});

test('CHANGELOG (Keep a Changelog) : entrée datée, [YANKED] permis, Unreleased et liens exigés', () => {
  expect(checkChangelog(changelog([V, '4.23.0']), V)).toEqual([]);
  // Version courante absente, titre sans date, ou tiret cadratin au lieu du tiret simple.
  expect(checkChangelog(changelog(['4.23.0']), V))
    .toEqual([expect.stringMatching(/aucune entrée « ## \[4\.23\.1\] - AAAA-MM-JJ »/)]);
  expect(checkChangelog(changelog([V]).replace(`## [${V}] - 2026-11-20`, `## [${V}]`), V)).toHaveLength(1);
  expect(checkChangelog(changelog([V]).replace(`## [${V}] - 2026-11-20`, `## [${V}] — 2026-11-20`), V)).toHaveLength(1);
  // Version retirée : reconnue.
  expect(checkChangelog(changelog([V]).replace(`## [${V}] - 2026-11-20`, `## [${V}] - 2026-11-20 [YANKED]`), V)).toEqual([]);
  // Section Unreleased obligatoire.
  expect(checkChangelog(changelog([V]).replace('## [Unreleased]\n', ''), V))
    .toEqual([expect.stringMatching(/\[Unreleased\]/)]);
  // Chaque section listée doit être liable.
  expect(checkChangelog(changelog([V, '4.23.0'], { links: false }), V)).toEqual([
    expect.stringMatching(/\[unreleased\]: …/),
    expect.stringMatching(/\[4\.23\.1\]: …/),
    expect.stringMatching(/\[4\.23\.0\]: …/),
  ]);
  // Une version qui en contient une autre (4.23.10) ne compte pas.
  expect(checkChangelog(changelog(['4.23.10']), V)).toHaveLength(1);
});

test('fichier absent ou version invalide', () => {
  const absent = checkRelease(writeRepo({ 'frontend/sw.js': null }), NOW);
  expect(absent.errors).toEqual([expect.stringMatching(/frontend\/sw\.js : fichier introuvable/)]);
  const sansChangelog = checkRelease(writeRepo({ 'CHANGELOG.md': null }), NOW);
  expect(sansChangelog.errors).toEqual(['CHANGELOG.md : fichier introuvable']);
  const invalide = checkRelease(writeRepo({ 'package.json': JSON.stringify({ version: 'v4' }) }), NOW);
  expect(invalide.errors).toEqual([expect.stringMatching(/invalide/)]);
  const sansPkg = checkRelease(fs.mkdtempSync(path.join(os.tmpdir(), 'vh-vide-')), NOW);
  expect(sansPkg).toEqual({ version: null, errors: ['package.json introuvable'] });
});

test('security.txt : expiration entre 30 jours et un an, ligne lisible, fichier présent', () => {
  expect(checkSecurityTxtExpiry(expires(NOW + 200 * DAY), NOW)).toBeNull();
  expect(checkSecurityTxtExpiry(expires(NOW + 29 * DAY), NOW)).toMatch(/moins de 30 jours/);
  expect(checkSecurityTxtExpiry(expires(NOW - DAY), NOW)).toMatch(/moins de 30 jours/);
  expect(checkSecurityTxtExpiry(expires(NOW + 400 * DAY), NOW)).toMatch(/plus d'un an/);
  expect(checkSecurityTxtExpiry('Contact: mailto:x@y.z\n', NOW)).toMatch(/absente ou illisible/);
  expect(checkSecurityTxtExpiry('Expires: demain\n', NOW)).toMatch(/absente ou illisible/);
  const sansFichier = checkRelease(writeRepo({ 'frontend/.well-known/security.txt': null }), NOW);
  expect(sansFichier.errors).toEqual(['frontend/.well-known/security.txt : fichier introuvable']);
});
