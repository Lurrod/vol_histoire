/**
 * @jest-environment jsdom
 *
 * js/offline.js : page hors ligne servie par le service worker (MOB-005).
 */
/* global EventTarget */
const offline = require('../js/offline.js');

const ORIGIN = 'http://localhost';

function html(title) {
  return `<!DOCTYPE html><html><head><title>${title}</title></head><body></body></html>`;
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
    <button id="offline-retry" type="button">Réessayer</button>
    <ul id="offline-visited" hidden></ul>
    <p id="offline-empty">Aucune page</p>`;
}

beforeEach(mountPage);

describe('titleOf', () => {
  test('retire le suffixe du site et décode les entités', () => {
    expect(offline.titleOf(html('Hangar | Vol d&#39;Histoire'))).toBe('Hangar');
    expect(offline.titleOf(html('Rafale &amp; Mirage — Vol d\'Histoire'))).toBe('Rafale & Mirage');
  });
  test('chaîne vide sans <title>', () => {
    expect(offline.titleOf('<html></html>')).toBe('');
    expect(offline.titleOf(null)).toBe('');
  });
});

describe('listCachedPages', () => {
  test('pages des caches vh-pages-*, dédoublonnées, sans /offline ni autre origine', async () => {
    const caches = fakeCaches({
      'vh-pages-v4.13.1': {
        [`${ORIGIN}/hangar`]: html('Hangar | Vol d\'Histoire'),
        [`${ORIGIN}/offline`]: html('Hors ligne'),
        [`${ORIGIN}/details/rafale-30`]: '<html>sans titre</html>',
        'https://ailleurs.test/x': html('X'),
      },
      'vh-pages-v4.13.0': { [`${ORIGIN}/hangar`]: html('Hangar (ancien)') },
      'vh-shell-v4.13.1': { [`${ORIGIN}/`]: html('Accueil') },
    });
    const pages = await offline.listCachedPages(caches, ORIGIN);
    expect(pages).toEqual([
      { href: '/hangar', title: 'Hangar' },
      { href: '/details/rafale-30', title: '/details/rafale-30' },
    ]);
  });

  test('entrée sans réponse : l\'URL sert de titre', async () => {
    const caches = {
      keys: async () => ['vh-pages-v1'],
      open: async () => ({ keys: async () => [{ url: `${ORIGIN}/timeline` }], match: async () => undefined }),
    };
    expect(await offline.listCachedPages(caches, ORIGIN)).toEqual([{ href: '/timeline', title: '/timeline' }]);
  });
});

describe('render', () => {
  test('liste les pages (textContent) et masque le message vide', () => {
    offline.render(document, [{ href: '/hangar', title: '<b>Hangar</b>' }]);
    const links = document.querySelectorAll('#offline-visited a');
    expect(links).toHaveLength(1);
    expect(links[0].getAttribute('href')).toBe('/hangar');
    expect(links[0].textContent).toBe('<b>Hangar</b>');
    expect(document.getElementById('offline-visited').hidden).toBe(false);
    expect(document.getElementById('offline-empty').hidden).toBe(true);
  });

  test('aucune page : message vide affiché', () => {
    offline.render(document, []);
    expect(document.getElementById('offline-visited').hidden).toBe(true);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
  });

  test('sans les éléments de la page : ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => offline.render(document, [])).not.toThrow();
  });
});

describe('init', () => {
  function ctx(extra = {}) {
    return {
      window: new EventTarget(),
      document,
      location: { origin: ORIGIN, reload: jest.fn() },
      caches: fakeCaches({ 'vh-pages-v1': { [`${ORIGIN}/cgu`]: html('CGU | Vol d\'Histoire') } }),
      ...extra,
    };
  }

  test('affiche les pages en cache', async () => {
    const pages = await offline.init(ctx());
    expect(pages).toEqual([{ href: '/cgu', title: 'CGU' }]);
    expect(document.querySelector('#offline-visited a').textContent).toBe('CGU');
  });

  test('« Réessayer » et le retour du réseau rechargent la page', async () => {
    const c = ctx();
    await offline.init(c);
    document.getElementById('offline-retry').click();
    c.window.dispatchEvent(new Event('online'));
    expect(c.location.reload).toHaveBeenCalledTimes(2);
  });

  test('sans Cache API ou en erreur : liste vide', async () => {
    expect(await offline.init(ctx({ caches: undefined }))).toEqual([]);
    expect(document.getElementById('offline-empty').hidden).toBe(false);
    mountPage();
    const broken = { keys: async () => { throw new Error('x'); } };
    expect(await offline.init(ctx({ caches: broken }))).toEqual([]);
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
    offline.boot(win, document);
    expect(document.getElementById('offline-empty').hidden).toBe(false);

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
