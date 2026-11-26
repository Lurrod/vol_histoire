/**
 * shared/admin-loader.js (JS-002) : le code d'administration n'est inséré
 * que pour les rôles admin / éditeur, une seule fois.
 */
let loader;

beforeEach(() => {
  jest.resetModules();
  document.head.innerHTML = '';
  window.APP_VERSION = '9.9.9';
  loader = require('../js/shared/admin-loader');
});

test('isEditor : rôles 1 et 2 seulement (nombre ou chaîne)', () => {
  expect(loader.isEditor({ role: 1 })).toBe(true);
  expect(loader.isEditor({ role: '2' })).toBe(true);
  expect(loader.isEditor({ role: 3 })).toBe(false);
  expect(loader.isEditor(null)).toBe(false);
});

test('load insère le bundle versionné une seule fois', async () => {
  const first = loader.load('hangar');
  const again = loader.load('hangar');
  expect(again).toBe(first);
  const scripts = document.head.querySelectorAll('script');
  expect(scripts).toHaveLength(1);
  expect(scripts[0].getAttribute('src')).toBe('/js/dist/admin-hangar.min.js?v=9.9.9');
  scripts[0].onload();
  await expect(first).resolves.toBeUndefined();
});

test('échec de chargement : promesse rejetée, nouvel essai possible', async () => {
  const first = loader.load('details');
  document.head.querySelector('script').onerror();
  await expect(first).rejects.toThrow('details');
  loader.load('details');
  expect(document.head.querySelectorAll('script')).toHaveLength(2);
});
