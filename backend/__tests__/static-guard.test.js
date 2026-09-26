/**
 * Tests unitaires — utils/static-guard.js
 *
 * express.static sert tout frontend/ : les fichiers de dev (node_modules,
 * tests, manifestes npm, docs, coverage) ne doivent jamais être publics.
 */
const { isPrivateStaticPath, blockPrivateStatic } = require('../utils/static-guard');

describe('isPrivateStaticPath', () => {
  test.each([
    '/node_modules/hasown/package.json',
    '/node_modules',
    '/__tests__/auth.test.js',
    '/coverage/lcov-report/index.html',
    '/package.json',
    '/package-lock.json',
    '/jest.config.json',
    '/css/README.md',
    '/README.md',
    '/css/.ruff_cache/CACHEDIR.TAG',
  ])('bloque %s', (p) => {
    expect(isPrivateStaticPath(p)).toBe(true);
  });

  test.each([
    '/',
    '/index.html',
    '/hangar.html',
    '/sw.js',
    '/robots.txt',
    '/manifest.webmanifest',
    '/locales/fr.json',
    '/js/dist/app.min.js',
    '/css/core.min.css',
    '/assets/logo/logo.webp',
    '/.well-known/security.txt',
  ])('laisse passer %s', (p) => {
    expect(isPrivateStaticPath(p)).toBe(false);
  });

  test('décode l\'URL avant de comparer (contournement par encodage)', () => {
    expect(isPrivateStaticPath('/node%5Fmodules/x.js')).toBe(true);
    expect(isPrivateStaticPath('/package%2Ejson')).toBe(true);
    expect(isPrivateStaticPath('/%5F%5Ftests%5F%5F/auth.test.js')).toBe(true);
  });

  test('ignore la casse', () => {
    expect(isPrivateStaticPath('/NODE_MODULES/x.js')).toBe(true);
    expect(isPrivateStaticPath('/Package.JSON')).toBe(true);
  });

  test('encodage invalide → bloqué par précaution', () => {
    expect(isPrivateStaticPath('/%E0%A4%A')).toBe(true);
  });
});

describe('blockPrivateStatic', () => {
  function run(path) {
    const res = { sendStatus: jest.fn() };
    const next = jest.fn();
    blockPrivateStatic({ path }, res, next);
    return { res, next };
  }

  test('répond 404 sans appeler next pour un chemin privé', () => {
    const { res, next } = run('/package.json');
    expect(res.sendStatus).toHaveBeenCalledWith(404);
    expect(next).not.toHaveBeenCalled();
  });

  test('appelle next pour un chemin public', () => {
    const { res, next } = run('/hangar.html');
    expect(next).toHaveBeenCalledTimes(1);
    expect(res.sendStatus).not.toHaveBeenCalled();
  });
});
