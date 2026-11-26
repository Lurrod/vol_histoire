/**
 * frontend/css/README.md (CSS-006) : la composition des bundles qu'il
 * documente doit rester celle de BUNDLES (scripts/build-css.js).
 */
const fs = require('fs');
const path = require('path');
const { BUNDLES } = require('../../scripts/build-css');

test('README des CSS : composition des bundles à jour', () => {
  const readme = fs.readFileSync(path.join(__dirname, '..', 'css', 'README.md'), 'utf8').replace(/\r\n/g, '\n');
  const block = readme.split('<!-- bundles:start -->')[1].split('<!-- bundles:end -->')[0];
  const pad = Math.max(...Object.keys(BUNDLES).map((k) => k.length));
  const expected = Object.entries(BUNDLES)
    .map(([bundle, files]) => `${bundle.padEnd(pad)} ← ${files.join(' + ')}`)
    .join('\n');
  expect(block.trim()).toBe('```\n' + expected + '\n```');
});

test('README des CSS : chaque source citée existe', () => {
  for (const files of Object.values(BUNDLES)) {
    for (const file of files) {
      expect(fs.existsSync(path.join(__dirname, '..', 'css', file))).toBe(true);
    }
  }
});
