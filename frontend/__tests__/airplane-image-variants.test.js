/**
 * Déclinaisons des photos d'appareils (scripts/convert-images.js). Un <source>
 * de <picture> qui répond 404 ne retombe pas sur l'<img> : il laisserait un
 * cadre vide. Chaque photo doit donc avoir ses vignettes 320 px et sa
 * version 800 px (PERF-001).
 */
const fs = require('fs');
const path = require('path');

const DIR = path.join(__dirname, '..', 'assets', 'airplanes');
const photos = fs.readdirSync(DIR).filter((f) => /\.(jpe?g|png)$/i.test(f)).map((f) => f.replace(/\.(jpe?g|png)$/i, ''));

test('des photos sont présentes', () => {
  expect(photos.length).toBeGreaterThan(0);
});

test.each([
  ['thumbs', '.avif'],
  ['thumbs', '.webp'],
  ['m800', '.avif'],
])('chaque photo a sa déclinaison %s/*%s (sinon : node scripts/convert-images.js)', (sub, ext) => {
  const missing = photos.filter((name) => !fs.existsSync(path.join(DIR, sub, name + ext)));
  expect(missing).toEqual([]);
});

test('aucun WebP pleine taille plus lourd que sa source (PERF-002)', () => {
  const heavier = photos.filter((name) => {
    const src = ['.jpg', '.jpeg', '.png'].map((e) => path.join(DIR, name + e)).find((f) => fs.existsSync(f));
    const webp = path.join(DIR, name + '.webp');
    return src && fs.existsSync(webp) && fs.statSync(webp).size > fs.statSync(src).size;
  });
  expect(heavier).toEqual([]);
});
