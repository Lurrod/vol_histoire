/**
 * @jest-environment node
 *
 * sw.js : logique du service worker isolée de ses événements (MOB-003 à
 * MOB-006). Les stratégies reçoivent fetch et CacheStorage par injection.
 */
/* global URL */
const path = require('path');
const sw = require('../sw.js');

const ORIGIN = 'https://vol-histoire.test';
const abs = (u) => new URL(typeof u === 'string' ? u : u.url, ORIGIN).href;

/** Réponse factice « basic » (celles du navigateur ne sont pas constructibles ainsi). */
function res(body = 'ok', { status = 200, type = 'basic' } = {}) {
  return { body, status, type, clone() { return res(body, { status, type }); } };
}

/** CacheStorage minimal, ordre d'insertion conservé (comme le navigateur). */
function fakeCaches() {
  const stores = new Map();
  function open(name) {
    if (!stores.has(name)) {
      const entries = new Map();
      stores.set(name, {
        entries,
        async put(req, response) { entries.delete(abs(req)); entries.set(abs(req), response); },
        async match(req, opts) {
          if (!(opts && opts.ignoreSearch)) return entries.get(abs(req));
          const bare = (u) => u.split('?')[0];
          const hit = [...entries.keys()].find((k) => bare(k) === bare(abs(req)));
          return hit && entries.get(hit);
        },
        async keys() { return [...entries.keys()].map((url) => ({ url })); },
        async delete(req) { return entries.delete(abs(req)); },
      });
    }
    return stores.get(name);
  }
  return {
    stores,
    open: async (name) => open(name),
    async match(req, opts) {
      for (const c of stores.values()) {
        const hit = await c.match(req, opts);
        if (hit) return hit;
      }
      return undefined;
    },
    async keys() { return [...stores.keys()]; },
    async delete(name) { return stores.delete(name); },
  };
}

const req = (url, extra = {}) => ({ url: abs(url), method: 'GET', mode: 'no-cors', destination: '', ...extra });
const names = sw.cacheNames('4.13.1');

describe('version', () => {
  test('CACHE_VERSION reste aligné sur package.json (repli de sw.js)', () => {
    const pkg = require(path.join(__dirname, '../../package.json'));
    expect(sw.CACHE_VERSION).toBe(`v${pkg.version}`);
  });

  test('resolveVersion lit ?v= de l\'URL du script, sinon le repli', () => {
    expect(sw.resolveVersion(`${ORIGIN}/sw.js?v=4.14.0`)).toBe('4.14.0');
    expect(sw.resolveVersion(`${ORIGIN}/sw.js`)).toBe(sw.CACHE_VERSION.slice(1));
    expect(sw.resolveVersion(`${ORIGIN}/sw.js?v=%3Cx%3E`)).toBe(sw.CACHE_VERSION.slice(1));
    expect(sw.resolveVersion('pas une url')).toBe(sw.CACHE_VERSION.slice(1));
  });

  test('noms de caches suffixés par la version', () => {
    expect(names).toEqual({
      shell: 'vh-shell-v4.13.1', pages: 'vh-pages-v4.13.1',
      static: 'vh-static-v4.13.1', images: 'vh-images-v4.13.1',
    });
  });
});

describe('shellAssets (MOB-003, MOB-004, MOB-005)', () => {
  const list = sw.shellAssets('4.13.1');
  test('CSS et JS pré-cachés sous l\'URL versionnée réellement servie', () => {
    expect(list).toEqual(expect.arrayContaining([
      '/css/core.min.css?v=4.13.1', '/css/home.min.css?v=4.13.1',
      '/js/dist/app.min.js?v=4.13.1', '/js/dist/icons.min.js?v=4.13.1',
      '/js/dist/home.min.js?v=4.13.1', '/js/vendor/purify.min.js?v=4.13.1',
    ]));
    expect(list.filter((u) => /\.(css|js)$/.test(u))).toEqual([]);
  });
  test('locales, page d\'accueil et page hors ligne pré-cachées', () => {
    expect(list).toEqual(expect.arrayContaining(['/', '/offline', '/locales/fr.json', '/locales/en.json']));
  });
  test('polices sans ?v= (appelées sans paramètre par core.min.css)', () => {
    expect(list).toContain('/fonts/DMSans.woff2');
    expect(list.filter((u) => u.startsWith('/fonts/') && u.includes('?'))).toEqual([]);
  });
});

describe('routeFor', () => {
  test.each([
    [req('/hangar', { mode: 'navigate' }), 'page'],
    [req('/x', { destination: 'document' }), 'page'],
    [req('/locales/fr.json'), 'locale'],
    [req('/assets/airplanes/rafale.avif?v=4.13.1'), 'image'],
    [req('/css/core.min.css?v=4.13.1'), 'immutable'],
    [req('/js/dist/app.min.js?v=4.13.1'), 'immutable'],
    [req('/js/gtm.js'), 'static'],
    [req('/fonts/DMSans.woff2'), 'static'],
    [req('/manifest.webmanifest'), 'static'],
    [req('/api/airplanes', { mode: 'navigate' }), 'none'],
    [req('/sw.js?v=1'), 'none'],
    [req('/robots.txt'), 'none'],
    [{ ...req('/hangar'), method: 'POST' }, 'none'],
    [{ ...req('/x.js'), url: 'https://cdn.example/x.js' }, 'none'],
  ])('%o → %s', (request, expected) => {
    expect(sw.routeFor(request, ORIGIN)).toBe(expected);
  });
});

describe('isCacheable', () => {
  test('200 même origine seulement', () => {
    expect(sw.isCacheable(res())).toBe(true);
    expect(sw.isCacheable(res('', { status: 206 }))).toBe(false);
    expect(sw.isCacheable(res('', { type: 'opaque' }))).toBe(false);
    expect(sw.isCacheable(null)).toBe(false);
    expect(sw.isCacheable({ ...res(), redirected: true })).toBe(false);
  });
});

describe('trimCache / store (MOB-006)', () => {
  test('éviction FIFO au-delà du plafond', async () => {
    const caches = fakeCaches();
    for (let i = 1; i <= 5; i++) await sw.store(caches, 'c', `/p${i}`, res(`p${i}`), 3);
    const keys = (await (await caches.open('c')).keys()).map((k) => new URL(k.url).pathname);
    expect(keys).toEqual(['/p3', '/p4', '/p5']);
    expect(await sw.trimCache(caches, 'c', 3)).toBe(0);
  });

  test('plafond 0 : pas de rognage (cache du shell)', async () => {
    const caches = fakeCaches();
    for (let i = 1; i <= 4; i++) await sw.store(caches, 'c', `/p${i}`, res(), 0);
    expect(await (await caches.open('c')).keys()).toHaveLength(4);
  });

  test('stockage indisponible : n\'échoue pas', async () => {
    const broken = { open: async () => { throw new Error('quota'); } };
    await expect(sw.store(broken, 'c', '/x', res(), 2)).resolves.toBeUndefined();
  });

  test('plafonds définis pour chaque cache runtime', () => {
    expect(sw.LIMITS.images).toBeGreaterThan(0);
    expect(sw.LIMITS.pages).toBeGreaterThan(0);
    expect(sw.LIMITS.static).toBeGreaterThan(0);
  });
});

describe('stratégies', () => {
  function setup(fetchImpl) {
    const caches = fakeCaches();
    const fetchFn = jest.fn(fetchImpl || (async () => res('net')));
    const kept = [];
    const s = sw.createStrategies({ fetchFn, cacheStorage: caches, names });
    const keep = (p) => kept.push(p);
    const settle = () => Promise.all(kept);
    return { caches, fetchFn, s, keep, settle };
  }

  test('page : réseau d\'abord, mise en cache dans vh-pages', async () => {
    const { caches, s, keep, settle } = setup();
    const out = await s.handle('page', req('/hangar', { mode: 'navigate' }), keep);
    expect(out.body).toBe('net');
    await settle();
    expect(await (await caches.open(names.pages)).match('/hangar')).toBeDefined();
  });

  test('page hors ligne : version en cache, sinon /offline, sinon 503', async () => {
    const { caches, s } = setup(async () => { throw new TypeError('offline'); });
    await (await caches.open(names.pages)).put('/hangar', res('hangar en cache'));
    expect((await s.handle('page', req('/hangar', { mode: 'navigate' }))).body).toBe('hangar en cache');

    // start_url du manifest (/?source=pwa), ou filtres : même page sans la requête.
    await (await caches.open(names.shell)).put('/', res('accueil'));
    expect((await s.handle('page', req('/?source=pwa', { mode: 'navigate' }))).body).toBe('accueil');
    expect((await s.handle('page', req('/hangar?country=France', { mode: 'navigate' }))).body).toBe('hangar en cache');

    const bare = await s.handle('page', req('/details/x-1', { mode: 'navigate' }));
    expect(bare.status).toBe(503);

    await (await caches.open(names.shell)).put('/offline', res('page hors ligne'));
    expect((await s.handle('page', req('/details/x-1', { mode: 'navigate' }))).body).toBe('page hors ligne');
  });

  test('page en erreur HTTP : transmise, jamais mise en cache', async () => {
    const { caches, s, keep, settle } = setup(async () => res('boom', { status: 500 }));
    const out = await s.handle('page', req('/hangar', { mode: 'navigate' }), keep);
    expect(out.status).toBe(500);
    await settle();
    expect(await caches.match('/hangar')).toBeUndefined();
  });

  test('immuable : cache d\'abord, réseau une seule fois', async () => {
    const { s, fetchFn, keep, settle } = setup();
    const r = req('/css/core.min.css?v=4.13.1');
    expect((await s.handle('immutable', r, keep)).body).toBe('net');
    await settle();
    expect((await s.handle('immutable', r, keep)).body).toBe('net');
    expect(fetchFn).toHaveBeenCalledTimes(1);
  });

  test('locale : servie du cache du shell, revalidée en arrière-plan', async () => {
    const { caches, s, fetchFn, keep, settle } = setup(async () => res('{"v":2}'));
    await (await caches.open(names.shell)).put('/locales/fr.json', res('{"v":1}'));
    expect((await s.handle('locale', req('/locales/fr.json'), keep)).body).toBe('{"v":1}');
    await settle();
    expect(fetchFn).toHaveBeenCalledTimes(1);
    expect((await caches.match('/locales/fr.json')).body).toBe('{"v":2}');
  });

  test('locale hors ligne et sans cache : erreur réseau, pas d\'exception', async () => {
    const { s } = setup(async () => { throw new TypeError('offline'); });
    const out = await s.handle('locale', req('/locales/en.json'));
    expect(out.type).toBe('error');
  });

  test('image : cache plafonné à LIMITS.images', async () => {
    const { caches, s, keep, settle } = setup();
    for (let i = 0; i < sw.LIMITS.images + 5; i++) {
      await s.handle('image', req(`/assets/airplanes/a${i}.avif`), keep);
    }
    await settle();
    const keys = await (await caches.open(names.images)).keys();
    expect(keys).toHaveLength(sw.LIMITS.images);
    expect(keys[0].url).toBe(abs('/assets/airplanes/a5.avif'));
  });

  test('statique : stale-while-revalidate dans vh-static', async () => {
    const { caches, s, keep, settle } = setup();
    expect((await s.handle('static', req('/js/gtm.js'), keep)).body).toBe('net');
    await settle();
    expect(await (await caches.open(names.static)).match('/js/gtm.js')).toBeDefined();
  });
});

describe('precache / purgeOldCaches', () => {
  test('pré-cache tolérant : un 404 n\'empêche pas le reste', async () => {
    const caches = fakeCaches();
    const fetchFn = jest.fn(async (url) => (url === '/offline' ? res('', { status: 404 }) : res(url)));
    const failed = await sw.precache(caches, names.shell, ['/', '/offline', '/locales/fr.json'], fetchFn);
    expect(failed).toBe(1);
    expect(fetchFn).toHaveBeenCalledWith('/', { cache: 'reload' });
    const keys = (await (await caches.open(names.shell)).keys()).map((k) => new URL(k.url).pathname);
    expect(keys).toEqual(['/', '/locales/fr.json']);
  });

  test('purge les caches du site d\'une autre version, pas ceux d\'autrui', async () => {
    const caches = fakeCaches();
    ['vh-shell-v4.13.0', 'vh-runtime-v4.13.1', 'autre-app', ...Object.values(names)].forEach((n) => caches.open(n));
    const removed = await sw.purgeOldCaches(caches, Object.values(names));
    expect(removed.sort()).toEqual(['vh-runtime-v4.13.1', 'vh-shell-v4.13.0']);
    expect((await caches.keys()).sort()).toEqual(['autre-app', ...Object.values(names)].sort());
  });
});
