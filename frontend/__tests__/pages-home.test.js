/**
 * Tests — accueil : cas limites de js/home/landing.js et de
 * js/home/search-suggest.js non couverts par landing-dom.test.js
 * (échecs réseau, index sur plusieurs pages, souris, Entrée, rouverture).
 */
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

require('../js/shared/picture');
window.VH.shared.buildDetailsPath = (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`;
require('../js/home/text');
const suggest = require('../js/home/search-suggest');
const landing = require('../js/home/landing');

const jsonResponse = (body, ok = true) => Promise.resolve({ ok, status: ok ? 200 : 500, json: () => Promise.resolve(body) });
const flushReal = () => new Promise((r) => setTimeout(r, 0));

const fleet = (n, from = 1) => Array.from({ length: n }, (_, i) => ({
  id: from + i, name: `Avion ${from + i}`, complete_name: `Constructeur Avion ${from + i}`,
  image_url: `/assets/airplanes/a${from + i}.jpg`, generation: (i % 5) + 1,
}));

// =============================================================================
// landing.js
// =============================================================================
describe('landing — référentiel et facettes, cas d’échec', () => {
  const PAGE = `<span data-gen-count="2"></span><div id="mission-families"></div><p id="missions-status"></p>`;

  test('référentiel en erreur HTTP : noms français conservés', async () => {
    document.body.innerHTML = PAGE;
    global.auth = {
      fetchWithTimeout: jest.fn((url) => (url === '/api/referentials'
        ? jsonResponse({}, false)
        : jsonResponse({ generations: {}, types: { Chasseur: 3 } }))),
    };
    await landing.loadFacets();
    expect(document.querySelector('.mission-type-name').textContent).toBe('Chasseur');
    expect(document.querySelector('[data-gen-count="2"]').textContent).toBe('');
  });

  test('référentiel injoignable ou mal formé : noms français conservés', async () => {
    document.body.innerHTML = PAGE;
    global.auth = {
      fetchWithTimeout: jest.fn((url) => (url === '/api/referentials'
        ? Promise.reject(new TypeError('Failed to fetch'))
        : jsonResponse({ types: { Transport: 2 } }))),
    };
    await landing.loadFacets();
    expect(document.querySelector('.mission-type-name').textContent).toBe('Transport');

    global.auth.fetchWithTimeout = jest.fn((url) => (url === '/api/referentials'
      ? jsonResponse({ types: [{ name: 'Fighter' }, { name: 'Tanker', name_fr: 'Ravitailleur' }] })
      : jsonResponse({ types: { Ravitailleur: 1, Chasseur: 1 } })));
    await landing.loadFacets();
    const names = [...document.querySelectorAll('.mission-type-name')].map((el) => el.textContent);
    expect(names).toEqual(['Chasseur', 'Tanker']);

    global.auth.fetchWithTimeout = jest.fn((url) => (url === '/api/referentials'
      ? jsonResponse({ types: 'pas une liste' })
      : jsonResponse({ types: { Chasseur: 1 } })));
    await landing.loadFacets();
    expect(document.querySelector('.mission-type-name').textContent).toBe('Chasseur');
  });

  test('page sans conteneur de missions ni zone d’état : compteurs seuls, échec silencieux', async () => {
    document.body.innerHTML = '<span data-gen-count="1"></span>';
    global.auth = { fetchWithTimeout: jest.fn(() => jsonResponse({ generations: { 1: 2 } })) };
    await landing.loadFacets();
    expect(document.querySelector('[data-gen-count]').textContent).toBe('2 fiches');
    global.auth.fetchWithTimeout = jest.fn(() => Promise.reject(new Error('x')));
    await expect(landing.loadFacets()).resolves.toBeUndefined();
  });

  test('un type inconnu des familles tombe dans « Autres » au lieu de disparaître', () => {
    const groups = landing.groupTypes({ Chasseur: 2, Hydravion: 1, Vide: 0 });
    expect(groups.map((g) => g.key)).toEqual(['family_combat', 'family_other']);
    expect(groups[1].items).toEqual([['Hydravion', 1]]);
  });
});

describe('landing — fin de page, cas d’échec', () => {
  const END = `
    <h2 id="home-end-title" data-i18n-html="k">Invitation</h2>
    <p id="home-end-text" data-i18n="k">…</p>
    <div id="home-end-favs" hidden></div>
    <div id="home-end-actions"><a href="/login">Créer un compte</a></div>`;

  test('favoris en erreur : l’invitation reste', async () => {
    document.body.innerHTML = END;
    global.auth = { init: jest.fn(() => Promise.resolve({ id: 1 })), authFetch: jest.fn(() => jsonResponse([], false)) };
    await landing.personalizeEnd();
    expect(document.getElementById('home-end-title').textContent).toBe('Invitation');
  });

  test('session qui échoue : l’invitation reste, aucune exception', async () => {
    document.body.innerHTML = END;
    global.auth = { init: jest.fn(() => Promise.reject(new Error('réseau'))), authFetch: jest.fn() };
    await expect(landing.personalizeEnd()).resolves.toBeUndefined();
    expect(document.getElementById('home-end-title').textContent).toBe('Invitation');
  });

  test('réponse inattendue ou infos utilisateur absentes : collection vide, accueil anonyme', async () => {
    document.body.innerHTML = END;
    global.auth = {
      init: jest.fn(() => Promise.resolve({ id: 1 })),
      authFetch: jest.fn(() => jsonResponse({ data: 'pas une liste' })),
      getUserInfo: () => null,
    };
    await landing.personalizeEnd();
    expect(document.getElementById('home-end-title').textContent).toBe('Bon retour');
    expect(document.querySelectorAll('#home-end-actions a')).toHaveLength(1);
  });

  test('plus de quatre favoris : quatre vignettes seulement', () => {
    document.body.innerHTML = END;
    landing.renderSignedIn({ name: 'Ada' }, fleet(6));
    expect(document.querySelectorAll('.home-end-fav')).toHaveLength(4);
    expect(document.getElementById('home-end-text').textContent).toContain('6');
  });

  test('page sans bloc de fin : rien n’est écrit', () => {
    document.body.innerHTML = '<h2 id="home-end-title">Titre</h2>';
    landing.renderSignedIn({ name: 'Ada' }, []);
    expect(document.getElementById('home-end-title').textContent).toBe('Titre');
  });

  test('init lance facettes, fin de page et suggestions', () => {
    document.body.innerHTML = '<form id="hero-search"></form>';
    global.auth = { fetchWithTimeout: jest.fn(() => new Promise(() => {})), init: jest.fn(() => new Promise(() => {})) };
    const mount = jest.spyOn(window.VH.home.searchSuggest, 'mount');
    landing.init();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/airplanes/facets');
    expect(auth.init).toHaveBeenCalled();
    expect(mount).toHaveBeenCalledWith(document.getElementById('hero-search'));
    mount.mockRestore();
  });

  test('init sans formulaire de recherche : pas de suggestions', () => {
    document.body.innerHTML = '';
    global.auth = { fetchWithTimeout: jest.fn(() => new Promise(() => {})), init: jest.fn(() => new Promise(() => {})) };
    const mount = jest.spyOn(window.VH.home.searchSuggest, 'mount');
    landing.init();
    expect(mount).not.toHaveBeenCalled();
    mount.mockRestore();
  });
});

// =============================================================================
// search-suggest.js
// =============================================================================
function mountSearch() {
  document.body.innerHTML = `
    <form id="hero-search" action="/hangar" method="get" role="search">
      <input id="hero-search-input" type="search" name="q" role="combobox" aria-expanded="false" aria-controls="hero-suggest">
      <div class="hero-suggest" hidden>
        <ul id="hero-suggest" role="listbox"></ul>
        <div class="hero-suggest-footer"></div>
      </div>
    </form>`;
  suggest.mount(document.getElementById('hero-search'));
  const list = document.getElementById('hero-suggest');
  return { input: document.getElementById('hero-search-input'), list, panel: list.closest('.hero-suggest') };
}

async function type(input, value) {
  input.value = value;
  input.dispatchEvent(new Event('input'));
  jest.advanceTimersByTime(150);
  jest.useRealTimers();
  await flushReal(); await flushReal(); await flushReal();
  jest.useFakeTimers();
}
const key = (input, k) => {
  const ev = new KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true });
  input.dispatchEvent(ev);
  return ev;
};

describe('search-suggest — index et montage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    window.Element.prototype.scrollIntoView = jest.fn();
  });
  afterEach(() => jest.useRealTimers());

  test('structure incomplète : mount ne branche rien', () => {
    document.body.innerHTML = '<form id="f"><input role="combobox" aria-controls="absent"></form>';
    expect(() => suggest.mount(document.getElementById('f'))).not.toThrow();
    expect(() => suggest.mount(null)).not.toThrow();
  });

  test('catalogue de plusieurs pages : toutes les pages sont chargées (100 par page)', async () => {
    global.auth = {
      fetchWithTimeout: jest.fn((url) => {
        const page = Number(/page=(\d+)/.exec(url)[1]);
        return jsonResponse(page === 1 ? { data: fleet(100), total: 230 }
          : page === 2 ? { data: fleet(100, 101), total: 230 } : { total: 230 });
      }),
    };
    jest.isolateModules(() => {
      const fresh = require('../js/home/search-suggest');
      document.body.innerHTML = `<form id="hero-search"><input id="q" role="combobox" aria-controls="l">
        <div class="hero-suggest" hidden><ul id="l" role="listbox"></ul><div class="hero-suggest-footer"></div></div></form>`;
      fresh.mount(document.getElementById('hero-search'));
    });
    await type(document.getElementById('q'), 'avion 15');
    const urls = auth.fetchWithTimeout.mock.calls.map(([u]) => u);
    expect(urls).toEqual(['/api/airplanes?limit=100&page=1', '/api/airplanes?limit=100&page=2', '/api/airplanes?limit=100&page=3']);
    expect(document.querySelector('[role="option"] .hero-suggest-name').textContent).toBe('Avion 15');
  });

  test('index en échec : liste fermée, nouvel essai à la frappe suivante', async () => {
    let fail = true;
    global.auth = {
      fetchWithTimeout: jest.fn(() => (fail ? jsonResponse({}, false) : jsonResponse({ data: fleet(3) }))),
    };
    jest.isolateModules(() => {
      const fresh = require('../js/home/search-suggest');
      document.body.innerHTML = `<form id="hero-search"><input id="q" role="combobox" aria-controls="l">
        <div class="hero-suggest" hidden><ul id="l" role="listbox"></ul><div class="hero-suggest-footer"></div></div></form>`;
      fresh.mount(document.getElementById('hero-search'));
    });
    const input = document.getElementById('q');
    input.dispatchEvent(new Event('focus')); // préchargement en échec, avalé
    await type(input, 'avion');
    expect(input.getAttribute('aria-expanded')).toBe('false');
    fail = false;
    await type(input, 'avion 2');
    expect(input.getAttribute('aria-expanded')).toBe('true');
    // Index sans total : une seule page.
    expect(auth.fetchWithTimeout.mock.calls.filter(([u]) => u.endsWith('page=2'))).toHaveLength(0);
  });
});

describe('search-suggest — interactions', () => {
  const AIRCRAFT = [
    { id: 1, name: 'Mirage 2000', complete_name: 'Dassault Mirage 2000', generation: '4', country_name: 'France', type_name: 'Multirôle' },
    { id: 2, name: 'Mirage III', complete_name: 'Dassault Mirage III', generation: 2 },
    { id: 3, name: 'Mirage F1', complete_name: 'Dassault Mirage F1' },
    { id: 4, name: 'Mirage I', complete_name: 'Dassault MD 550 Mirage I', generation: 1 },
  ];
  let nav;

  beforeAll(() => {
    global.auth = { fetchWithTimeout: jest.fn(() => jsonResponse({ data: AIRCRAFT, total: AIRCRAFT.length })) };
    window.Element.prototype.scrollIntoView = jest.fn();
  });
  beforeEach(() => {
    jest.useFakeTimers();
    const errors = jest.spyOn(console, 'error').mockImplementation(() => {});
    nav = () => errors.mock.calls.filter(([e]) => /navigation/.test(String(e && e.message))).length;
  });
  afterEach(() => {
    jest.useRealTimers();
    jest.restoreAllMocks();
  });

  test('métadonnées : génération 1 ou autre, champs absents ignorés', async () => {
    const { input, list } = mountSearch();
    await type(input, 'mirage');
    const metas = [...list.querySelectorAll('.hero-suggest-meta')].map((el) => el.textContent);
    // Tri : nom le plus court d'abord.
    expect(metas).toEqual(['1re gén.', '', '2e gén.', 'France · 4e gén. · Multirôle']);
  });

  test('Entrée sur l’option active : navigation vers la fiche', async () => {
    const { input } = mountSearch();
    await type(input, 'mirage');
    expect(key(input, 'Enter').defaultPrevented).toBe(false); // aucune option active : envoi normal
    key(input, 'ArrowDown');
    expect(key(input, 'Enter').defaultPrevented).toBe(true);
    expect(nav()).toBe(1);
  });

  test('↑ depuis aucune option : dernière option', async () => {
    const { input } = mountSearch();
    await type(input, 'mirage');
    key(input, 'ArrowUp');
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-3');
    key(input, 'ArrowUp');
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-2');
  });

  test('aucun résultat : les flèches ne font rien', async () => {
    const { input } = mountSearch();
    await type(input, 'zzz');
    expect(key(input, 'ArrowDown').defaultPrevented).toBe(false);
    expect(key(input, 'ArrowUp').defaultPrevented).toBe(false);
    expect(input.hasAttribute('aria-activedescendant')).toBe(false);
  });

  test('liste fermée : ↓ la rouvre si le champ contient du texte', async () => {
    const { input, panel } = mountSearch();
    await type(input, 'mirage');
    key(input, 'Escape');
    jest.advanceTimersByTime(200);
    expect(panel.hidden).toBe(true);
    key(input, 'ArrowDown');
    jest.useRealTimers();
    await flushReal(); await flushReal();
    jest.useFakeTimers();
    expect(panel.hidden).toBe(false);

    input.value = '';
    key(input, 'Escape');
    jest.advanceTimersByTime(200);
    expect(key(input, 'ArrowDown').defaultPrevented).toBe(false);
    expect(key(input, 'Enter').defaultPrevented).toBe(false);
  });

  test('Échap pendant le fondu de fermeture : pas de double minuterie', async () => {
    const { input, panel } = mountSearch();
    await type(input, 'mirage');
    key(input, 'Escape');
    expect(panel.classList.contains('is-closing')).toBe(true);
    input.dispatchEvent(new Event('blur'));
    jest.advanceTimersByTime(150);
    expect(panel.hidden).toBe(true);
  });

  test('souris : survol active l’option, clic navigue, clic sur « tout voir » laisse le formulaire', async () => {
    const { input, panel, list } = mountSearch();
    await type(input, 'mirage');
    const second = list.querySelectorAll('[role="option"]')[1];
    second.querySelector('.hero-suggest-name').dispatchEvent(new window.MouseEvent('mousemove', { bubbles: true }));
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-1');
    second.dispatchEvent(new window.MouseEvent('mousemove', { bubbles: true })); // même option : rien ne change
    list.dispatchEvent(new window.MouseEvent('mousemove', { bubbles: true })); // hors option

    const down = new window.MouseEvent('mousedown', { bubbles: true, cancelable: true });
    second.dispatchEvent(down);
    expect(down.defaultPrevented).toBe(true); // le champ garde le focus
    expect(nav()).toBe(1);

    const all = new window.MouseEvent('mousedown', { bubbles: true, cancelable: true });
    panel.querySelector('.hero-suggest-all').dispatchEvent(all);
    expect(all.defaultPrevented).toBe(true);
    expect(nav()).toBe(1);

    const outside = new window.MouseEvent('mousedown', { bubbles: true, cancelable: true });
    panel.querySelector('.hero-suggest-footer').dispatchEvent(outside);
    expect(outside.defaultPrevented).toBe(false);
  });

  test('une frappe plus récente l’emporte sur une réponse en retard', async () => {
    const { input, list } = mountSearch();
    input.value = 'mirage 2000';
    input.dispatchEvent(new Event('input'));
    jest.advanceTimersByTime(150);
    input.value = 'mirage f';
    jest.useRealTimers();
    await flushReal(); await flushReal();
    jest.useFakeTimers();
    expect(list.querySelectorAll('[role="option"]')).toHaveLength(0);
  });
});

// =============================================================================
// text.js — langue courante et attente d'i18n
// =============================================================================
describe('home/text — langue et attente', () => {
  const text = window.VH.home.text;
  afterEach(() => { delete window.i18n; jest.useRealTimers(); });

  test('currentLang : celle d’i18n, sinon le français', () => {
    expect(text.currentLang()).toBe('fr');
    window.i18n = { currentLang: 'en' };
    expect(text.currentLang()).toBe('en');
    window.i18n = {};
    expect(text.currentLang()).toBe('fr');
  });

  test('whenReady résout dès que la langue est chargée, ou au délai maximal', async () => {
    jest.useFakeTimers();
    window.i18n = { isLoaded: false };
    let done = false;
    text.whenReady(100).then(() => { done = true; });
    jest.advanceTimersByTime(50);
    await Promise.resolve();
    expect(done).toBe(false);
    window.i18n.isLoaded = true;
    jest.advanceTimersByTime(25);
    await Promise.resolve();
    expect(done).toBe(true);

    window.i18n = { isLoaded: false };
    let late = false;
    text.whenReady(100).then(() => { late = true; });
    jest.advanceTimersByTime(125);
    await Promise.resolve();
    expect(late).toBe(true);
  });

  test('tr : clé inconnue sans i18n, paramètre absent laissé tel quel', () => {
    expect(text.tr('cle_inconnue')).toBe('home.landing.cle_inconnue');
    expect(text.tr('search_all', {})).toContain('{q}');
    window.i18n = { t: (k) => (k === 'home.landing.search_empty' ? 'No aircraft' : k) };
    expect(text.tr('search_empty')).toBe('No aircraft');
    expect(text.tr('types_error')).toBe('Les catégories n\'ont pas pu être chargées.');
  });
});
