/**
 * Tests — cache des fichiers statiques versionnés (utils/asset-cache.js).
 *
 * CSS, JS et images portent ?v=<version> : en production, une URL ne change
 * jamais de contenu, d'où un an de cache immuable. En développement la
 * version ne bouge pas d'une modification à l'autre : le navigateur
 * gardait l'ancienne feuille pendant un an. Il revalide donc à chaque fois.
 */
const { isDevelopment, versionedAssetCache } = require('../utils/asset-cache');

describe('isDevelopment', () => {
  test('ni production ni test', () => {
    expect(isDevelopment({ NODE_ENV: 'development' })).toBe(true);
    expect(isDevelopment({})).toBe(true);
    expect(isDevelopment({ NODE_ENV: 'production' })).toBe(false);
    expect(isDevelopment({ NODE_ENV: 'test' })).toBe(false);
  });
});

describe('versionedAssetCache', () => {
  test('production et tests : un an, immuable', () => {
    expect(versionedAssetCache({ NODE_ENV: 'production' })).toBe('public, max-age=31536000, immutable');
    expect(versionedAssetCache({ NODE_ENV: 'test' })).toBe('public, max-age=31536000, immutable');
  });

  test('développement : revalidation à chaque chargement', () => {
    expect(versionedAssetCache({ NODE_ENV: 'development' })).toBe('no-cache');
  });
});

describe('assetVersion (valeur de ?v= dans les pages)', () => {
  const { assetVersion } = require('../utils/asset-cache');
  test('production et tests : la version du package, telle quelle', () => {
    expect(assetVersion('4.17.0', { NODE_ENV: 'production' }, 1)).toBe('4.17.0');
    expect(assetVersion('4.17.0', { NODE_ENV: 'test' }, 1)).toBe('4.17.0');
  });

  test('développement : change à chaque démarrage (les copies déjà en cache ne servent plus)', () => {
    const a = assetVersion('4.17.0', { NODE_ENV: 'development' }, 1700000000000);
    const b = assetVersion('4.17.0', { NODE_ENV: 'development' }, 1700000005000);
    expect(a).toMatch(/^4\.17\.0-dev[0-9a-z]+$/);
    expect(a).not.toBe(b);
    expect(a.length).toBeLessThanOrEqual(32); // borne de scriptVersion (sw-register.js)
  });
});

describe('currentAssetVersion', () => {
  test('calculée une fois par processus (tests : version du package)', () => {
    const { currentAssetVersion } = require('../utils/asset-cache');
    const v = currentAssetVersion();
    expect(v).toBe(require('../package.json').version);
    expect(currentAssetVersion()).toBe(v);
  });
});
