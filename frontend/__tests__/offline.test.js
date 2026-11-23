/**
 * @jest-environment jsdom
 *
 * js/offline.js : page hors ligne servie par le service worker (MOB-005),
 * version « lecture d'abord » (2026-11-22).
 */
/* global EventTarget */
const offline = require('../js/offline.js');

const ORIGIN = 'http://localhost';

function html(title, image) {
  const og = image ? `<meta property="og:image" content="https://vol-histoire.titouan-borde.com/assets/airplanes/${image}.jpg">` : '';
  return `<!DOCTYPE html><html><head><title>${title}</title>${og}</head><body></body></html>`;
}

/** CacheStorage factice : { nom: { url: html } }. */
function fakeCaches(content) {
  return {
    async keys() { return Object.keys(content); },
    async open(name) {
      const entries = content[name];
      return {
        async keys() { return Object.keys(entries).map((url) => ({ url })); },
        async match(r) {
          const body = entries[r.url];
          return body === undefined ? undefined : { text: async () => body };
        },
      };
    },
  };
}

function mountPage() {
  document.body.innerHTML = `
    <p id="offline-state"><span id="offline-state-text" data-i18n="offline.state_offline">Hors ligne</span></p>
    <button id="offline-retry" type="button">Réessayer</button>
    <span id="offline-count" hidden></span>
    <div id="offline-groups" hidden></div>
    <div id="offline-empty">Rien d'enregistré</div>`;
}

beforeEach(mountPage);

afterEach(() => {
  delete global.i18n;
});

describe('titleOf / imageOf / splitTitle', () => {
  test('titre sans le suffixe du site, entités décodées', () => {
    expect(offline.titleOf(html('Hangar | Vol d&#39;Histoire'))).toBe('Hangar');
    expect(offline.titleOf(html('Rafale &amp; Mirage — Vol d\'Histoire'))).toBe('Rafale & Mirage');
    expect(offline.titleOf('<html></html>')).toBe('');
    expect(offline.titleOf(null)).toBe('');
  });

  test('photo de la fiche lue dans og:image', () => {
    expect(offline.imageOf(html('Rafale', 'rafale'))).toBe('rafale');
    expect(offline.imageOf('<meta property="og:image" content="https://x.test/og-default.jpg">')).toBe('');
    expect(offline.imageOf('<meta property="og:image" content="http://[">')).toBe('');
    expect(offline.imageOf(html('Hangar'))).toBe('');
    expect(offline.imageOf(null)).toBe('');
  });

  test('« nom — type, pays (année) » coupé en nom et précision', () => {
    expect(offline.splitTitle('Rafale — chasseur, France (1986)')).toEqual({ name: 'Rafale', meta: 'chasseur, France (1986)' });
    expect(offline.splitTitle('Hangar')).toEqual({ name: 'Hangar', meta: '' });
    expect(offline.splitTitle(null)).toEqual({ name: '', meta: '' });
  });
});

describe('listCachedPages / listCachedImages', () => {
  test('pages des caches vh-pages-*, dédoublonnées, sans /offline ni autre origine', async () => {
    const caches = fakeCaches({
      'vh-pages-v4.13.1': {
        [`${ORIGIN}/hangar`]: html('Hangar | Vol d\'Histoire'),
        [`${ORIGIN}/offline`]: html('Hors ligne'),
        [`${ORIGIN}/details/rafale-30`]: html('Rafale — chasseur | Vol d\'Histoire', 'rafale'),
        'https://ailleurs.test/x': html('X'),
      },
      'vh-pages-v4.13.0': { [`${ORIGIN}/hangar`]: html('Hangar (ancien)') },
      'vh-shell-v4.13.1': { [`${ORIGIN}/`]: html('Accueil') },
    });
    expect(await offline.listCachedPages(caches, ORIGIN)).toEqual([
      { href: '/hangar', title: 'Hangar', image: '' },
      { href: '/details/rafale-30', title: 'Rafale — chasseur', image: 'rafale' },
    ]);
  });

  test('entrée sans réponse : l\'URL sert de titre', async () => {
    const caches = {
      keys: async () => ['vh-pages-v1'],
      open: async () => ({ keys: async () => [{ url: `${ORIGIN}/timeline` }], match: async () => undefined }),
    };
    expect(await offline.listCachedPages(caches, ORIGIN)).toEqual([{ href: '/timeline', title: '/timeline', image: '' }]);
  });

  test('photos en cache : la vignette l\'emporte, autres origines et fichiers ignorés', async () => {
    const caches = fakeCaches({
      'vh-images-v1': {
        [`${ORIGIN}/assets/airplanes/rafale.avif?v=1`]: '',
        [`${ORIGIN}/assets/airplanes/thumbs/rafale.webp?v=1`]: '',
        [`${ORIGIN}/assets/airplanes/thumbs/f22.avif?v=1`]: '',
        [`${ORIGIN}/assets/airplanes/f22.jpg?v=1`]: '',
        [`${ORIGIN}/assets/logo/logo.svg`]: '',
        'https://ailleurs.test/assets/airplanes/x.jpg': '',
      },
      'vh-static-v1': { [`${ORIGIN}/assets/airplanes/mig.jpg`]: '' },
    });
    expect(await offline.listCachedImages(caches, ORIGIN)).toEqual({
      rafale: '/assets/airplanes/thumbs/rafale.webp?v=1',
      f22: '/assets/airplanes/thumbs/f22.avif?v=1',
    });
  });
});

describe('kindOf / groupPages', () => {
  test('fiches, conflits, autres pages', () => {
    expect(offline.kindOf('/details/rafale-30')).toBe('aircraft');
    expect(offline.kindOf('/conflits')).toBe('conflicts');
    expect(offline.kindOf('/conflits/guerre-du-golfe?lang=en')).toBe('conflicts');
    expect(offline.kindOf('/conflitsx')).toBe('pages');
    expect(offline.kindOf(null)).toBe('pages');
  });

  test('pages rangées et triées par titre', () => {
    const groups = offline.groupPages([
      { href: '/hangar', title: 'Hangar' },
      { href: '/details/rafale-30', title: 'Rafale' },
      { href: '/details/f-16-12', title: 'F-16' },
      { href: '/cgu', title: 'CGU' },
    ]);
    expect(groups.aircraft.map((p) => p.title)).toEqual(['F-16', 'Rafale']);
    expect(groups.conflicts).toEqual([]);
    expect(groups.pages.map((p) => p.title)).toEqual(['CGU', 'Hangar']);
  });
});

describe('render', () => {
  const PAGES = [
    { href: '/hangar', title: '<b>Hangar</b>', image: '' },
    { href: '/details/rafale-30', title: 'Rafale — chasseur, France (1986)', image: 'rafale' },
    { href: '/details/su-27-40', title: 'Su-27', image: 'su27' },
    { href: '/conflits/guerre-du-golfe', title: 'Guerre du Golfe', image: '' },
  ];

  test('fiches en cartes (photo en cache, sinon pictogramme), conflits et pages en listes', () => {
    offline.render(document, PAGES, { rafale: '/assets/airplanes/thumbs/rafale.webp?v=1' });
    const cards = document.querySelectorAll('.offline-card');
    expect(cards).toHaveLength(2);
    const rafale = cards[0];
    expect(rafale.getAttribute('href')).toBe('/details/rafale-30');
    expect(rafale.querySelector('img').getAttribute('src')).toBe('/assets/airplanes/thumbs/rafale.webp?v=1');
    expect(rafale.querySelector('img').alt).toBe('');
    expect(rafale.querySelector('.offline-card-name').textContent).toBe('Rafale');
    expect(rafale.querySelector('.offline-card-meta').textContent).toBe('chasseur, France (1986)');
    const su27 = cards[1];
    expect(su27.querySelector('img')).toBeNull();
    expect(su27.querySelector('.offline-card-media').classList.contains('is-empty')).toBe(true);
    expect(su27.querySelector('.offline-card-meta')).toBeNull();

    const titles = Array.from(document.querySelectorAll('.offline-group-title')).map((h) => h.textContent);
    expect(titles).toEqual(['Fiches2', 'Conflits1', 'Pages1']);
    const page = document.querySelector('.offline-links a[href="/hangar"]');
    expect(page.textContent).toBe('<b>Hangar</b>');
    expect(document.getElementById('offline-groups').hidden).toBe(false);
    expect(document.getElementById('offline-empty').hidden).toBe(true);
    expect(document.getElementById('offline-count').textContent).toBe('4');
    expect(document.getElementById('offline-count').hidden).toBe(false);
  });

  test('sans fiche ni liste : groupes absents ; sans table de photos : pictogramme', () => {
    offline.render(document, [{ href: '/details/x-1', title: 'X', image: 'x' }]);
    expect(document.querySelector('.offline-lists')).toBeNull();
    expect(document.querySelector('.offline-card img')).toBeNull();
    offline.render(document, [{ href: '/cgu', title: 'CGU', image: '' }], {});
    expect(document.querySelector('.offline-cards')).toBeNull();
    expect(document.querySelectorAll('.offline-links a')).toHaveLength(1);
  });

  test('libellés traduits quand la langue est chargée', () => {
    global.i18n = { t: (k) => (k === 'offline.group_aircraft' ? 'Aircraft' : k) };
    offline.render(document, [{ href: '/details/rafale-30', title: 'Rafale', image: '' }], {});
    expect(document.querySelector('.offline-group-title').textContent).toContain('Aircraft');
  });

  test('aucune page : état vide affiché, total masqué', () => {
    offline.render(document, [], {});
    expect(document.getElementById('offline-groups').hidden).toBe(true);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
    expect(document.getElementById('offline-count').hidden).toBe(true);
  });

  test('sans les éléments de la page : ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => offline.render(document, [], {})).not.toThrow();
  });
});

describe('setState', () => {
  test('pastille : hors ligne, rétablie, toujours hors ligne', () => {
    const box = document.getElementById('offline-state');
    const text = document.getElementById('offline-state-text');
    offline.setState(document, 'online');
    expect(box.classList.contains('is-online')).toBe(true);
    expect(text.textContent).toMatch(/rétablie/);
    expect(text.hasAttribute('data-i18n')).toBe(false);
    offline.setState(document, 'still');
    expect(box.classList.contains('is-online')).toBe(false);
    expect(box.classList.contains('is-still')).toBe(true);
    expect(text.textContent).toBe('Toujours hors ligne');
    offline.setState(document, 'inconnu');
    expect(text.textContent).toBe('Hors ligne');
    expect(box.classList.contains('is-still')).toBe(false);
  });

  test('sans pastille : ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => offline.setState(document, 'online')).not.toThrow();
  });
});

describe('probe', () => {
  test('serveur joignable : true, requête sans cache', async () => {
    const fetchImpl = jest.fn(async () => ({ ok: true }));
    await expect(offline.probe(fetchImpl, 50)).resolves.toBe(true);
    expect(fetchImpl).toHaveBeenCalledWith('/api/live', expect.objectContaining({ cache: 'no-store' }));
  });

  test('réponse en erreur, échec réseau ou délai dépassé : false', async () => {
    await expect(offline.probe(async () => ({ ok: false }), 50)).resolves.toBe(false);
    await expect(offline.probe(async () => { throw new TypeError('Failed to fetch'); }, 50)).resolves.toBe(false);
    const hanging = (url, opts) => new Promise((resolve, reject) => {
      opts.signal.addEventListener('abort', () => reject(new Error('abort')));
    });
    await expect(offline.probe(hanging, 10)).resolves.toBe(false);
  });
});

describe('init', () => {
  function ctx(extra = {}) {
    const win = new EventTarget();
    win.VH = { busyButton: { start: jest.fn(), stop: jest.fn() } };
    return {
      window: win,
      document,
      location: { origin: ORIGIN, reload: jest.fn() },
      caches: fakeCaches({
        'vh-pages-v1': { [`${ORIGIN}/details/rafale-30`]: html('Rafale — chasseur | Vol d\'Histoire', 'rafale') },
        'vh-images-v1': { [`${ORIGIN}/assets/airplanes/thumbs/rafale.avif?v=1`]: '' },
      }),
      fetch: jest.fn(async () => ({ ok: true })),
      timeoutMs: 50,
      ...extra,
    };
  }

  test('affiche les fiches en cache avec leur photo, relibellées à l\'arrivée de la langue', async () => {
    const c = ctx();
    const pages = await offline.init(c);
    expect(pages).toEqual([{ href: '/details/rafale-30', title: 'Rafale — chasseur', image: 'rafale' }]);
    expect(document.querySelector('.offline-card img').getAttribute('src')).toBe('/assets/airplanes/thumbs/rafale.avif?v=1');
    global.i18n = { t: (k) => (k === 'offline.group_aircraft' ? 'Aircraft' : k) };
    c.window.dispatchEvent(new Event('i18nReady'));
    expect(document.querySelector('.offline-group-title').textContent).toContain('Aircraft');
    expect(document.querySelector('.offline-card img')).not.toBeNull();
  });

  test('photos illisibles : les fiches s\'affichent quand même', async () => {
    const base = ctx().caches;
    const caches = {
      keys: base.keys,
      open: async (name) => {
        if (name.startsWith('vh-images-')) throw new Error('cache illisible');
        return base.open(name);
      },
    };
    const pages = await offline.init(ctx({ caches }));
    expect(pages).toHaveLength(1);
    expect(document.querySelector('.offline-card img')).toBeNull();
  });

  test('« Réessayer » en ligne : bouton occupé, pastille rétablie, rechargement', async () => {
    const c = ctx();
    await offline.init(c);
    const button = document.getElementById('offline-retry');
    await expect(offline.retry(c, button)).resolves.toBe(true);
    expect(c.window.VH.busyButton.start).toHaveBeenCalledWith(button);
    expect(c.location.reload).toHaveBeenCalledTimes(1);
    expect(document.getElementById('offline-state').classList.contains('is-online')).toBe(true);
  });

  test('« Réessayer » hors ligne : pas de rechargement, « toujours hors ligne »', async () => {
    const c = ctx({ fetch: jest.fn(async () => { throw new TypeError('offline'); }) });
    await offline.init(c);
    const button = document.getElementById('offline-retry');
    await expect(offline.retry(c, button)).resolves.toBe(false);
    expect(c.location.reload).not.toHaveBeenCalled();
    expect(c.window.VH.busyButton.stop).toHaveBeenCalledWith(button);
    expect(document.getElementById('offline-state').classList.contains('is-still')).toBe(true);
  });

  test('clic sur « Réessayer » : un seul essai à la fois', async () => {
    let release;
    const c = ctx({ fetch: jest.fn(() => new Promise((resolve) => { release = resolve; })) });
    await offline.init(c);
    const button = document.getElementById('offline-retry');
    button.click();
    button.click();
    expect(c.fetch).toHaveBeenCalledTimes(1);
    release({ ok: false });
    await new Promise((r) => setTimeout(r, 0));
    button.click();
    expect(c.fetch).toHaveBeenCalledTimes(2);
  });

  test('sans bouton occupé (VH absent) : l\'essai fonctionne quand même', async () => {
    const c = ctx();
    c.window.VH = undefined;
    await expect(offline.retry(c, document.getElementById('offline-retry'))).resolves.toBe(true);
  });

  test('retour du réseau : pastille rétablie et rechargement ; perte : pastille hors ligne', async () => {
    const c = ctx();
    await offline.init(c);
    offline.setState(document, 'still');
    c.window.dispatchEvent(new Event('offline'));
    expect(document.getElementById('offline-state').classList.contains('is-still')).toBe(false);
    c.window.dispatchEvent(new Event('online'));
    expect(c.location.reload).toHaveBeenCalledTimes(1);
    expect(document.getElementById('offline-state').classList.contains('is-online')).toBe(true);
  });

  test('sans Cache API ou en erreur : état vide', async () => {
    expect(await offline.init(ctx({ caches: undefined }))).toEqual([]);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
    mountPage();
    const broken = { keys: async () => { throw new Error('x'); } };
    expect(await offline.init(ctx({ caches: broken }))).toEqual([]);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
  });

  test('sans bouton Réessayer : pas d\'erreur', async () => {
    document.getElementById('offline-retry').remove();
    await expect(offline.init(ctx())).resolves.toHaveLength(1);
  });
});

describe('boot', () => {
  test('DOM prêt : initialise tout de suite ; sinon au DOMContentLoaded', () => {
    const win = new EventTarget();
    win.location = { origin: ORIGIN, reload: jest.fn() };
    win.caches = undefined;
    win.fetch = jest.fn(async () => ({ ok: false }));
    offline.boot(win, document);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
    document.getElementById('offline-retry').click();
    expect(win.fetch).toHaveBeenCalledWith('/api/live', expect.any(Object));

    mountPage();
    const doc = new EventTarget();
    doc.readyState = 'loading';
    doc.getElementById = (id) => document.getElementById(id);
    offline.boot(win, doc);
    document.getElementById('offline-empty').hidden = true;
    doc.dispatchEvent(new Event('DOMContentLoaded'));
    expect(document.getElementById('offline-empty').hidden).toBe(false);
  });
});
