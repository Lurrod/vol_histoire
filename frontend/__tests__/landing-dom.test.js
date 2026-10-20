/**
 * Tests DOM (jsdom) — accueil v4.10.0
 *   - combobox de la recherche du hero (js/home/search-suggest.js)
 *   - familles de missions et fin de page (js/home/landing.js)
 *
 * auth, escapeHtml et VH.shared sont des globaux fournis par app.min.js dans
 * le navigateur : on les remplace ici par des doublures minimales.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

require('../js/shared/picture');
window.VH.shared.buildDetailsPath = (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`;
require('../js/home/text');
const suggest = require('../js/home/search-suggest');
const landing = require('../js/home/landing');

const AIRCRAFT = [
  { id: 30, name: 'Rafale', complete_name: 'Dassault Rafale', image_url: '/assets/airplanes/rafale.jpg', country_name: 'France', generation: 4, type_name: 'Multirôle' },
  { id: 31, name: 'Rafale EH', complete_name: 'Dassault Rafale EH', image_url: '/assets/airplanes/rafale-eh.jpg', country_name: 'Inde', generation: 4, type_name: 'Multirôle' },
  { id: 9, name: 'MiG-15', complete_name: 'Mikoyan-Gourevitch MiG-15', image_url: '/assets/airplanes/mig15.jpg', country_name: 'Russie', generation: 1, type_name: 'Chasseur' },
];

const jsonResponse = (body, ok = true) => Promise.resolve({ ok, status: ok ? 200 : 500, json: () => Promise.resolve(body) });
const flush = () => new Promise((r) => setTimeout(r, 0));

function mountSearch() {
  document.body.innerHTML = `
    <form id="hero-search" action="/hangar" method="get" role="search">
      <input id="hero-search-input" type="search" name="q" role="combobox" aria-expanded="false" aria-controls="hero-suggest">
      <div class="hero-suggest" hidden>
        <ul id="hero-suggest" role="listbox"></ul>
        <div class="hero-suggest-footer"></div>
      </div>
      <p id="hero-suggest-status" role="status"></p>
    </form>`;
  const form = document.getElementById('hero-search');
  suggest.mount(form);
  const list = document.getElementById('hero-suggest');
  return { input: document.getElementById('hero-search-input'), list, panel: list.closest('.hero-suggest') };
}

async function type(input, value) {
  input.value = value;
  input.dispatchEvent(new Event('input'));
  jest.advanceTimersByTime(150); // anti-rebond de 120 ms
  jest.useRealTimers();
  await flush(); await flush(); await flush();
  jest.useFakeTimers();
}

const key = (input, k) => input.dispatchEvent(new KeyboardEvent('keydown', { key: k, bubbles: true }));

describe('search-suggest — combobox', () => {
  beforeAll(() => {
    // Un seul catalogue d'une page : l'index est chargé une fois pour toute la suite.
    global.auth = { fetchWithTimeout: jest.fn(() => jsonResponse({ data: AIRCRAFT, total: AIRCRAFT.length })) };
    window.Element.prototype.scrollIntoView = jest.fn();
  });
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  test('affiche les suggestions, vignettes comprises, et ouvre la liste', async () => {
    const { input, list, panel } = mountSearch();
    await type(input, 'raf');
    expect(panel.hidden).toBe(false);
    expect(input.getAttribute('aria-expanded')).toBe('true');
    const options = list.querySelectorAll('[role="option"]');
    expect([...options].map((o) => o.querySelector('.hero-suggest-name').textContent)).toEqual(['Rafale', 'Rafale EH']);
    expect(options[0].innerHTML).toContain('/assets/airplanes/thumbs/rafale.avif');
    expect(options[0].querySelector('.hero-suggest-meta').textContent).toBe('France · 4e gén. · Multirôle');
    expect(document.getElementById('hero-suggest-status').textContent).toBe('2 suggestions. Flèches pour parcourir.');
  });

  test('l\'index n\'est chargé qu\'une fois', () => {
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
    expect(auth.fetchWithTimeout.mock.calls[0][0]).toBe('/api/airplanes?limit=100&page=1');
  });

  test('flèches : l\'option active est reflétée par aria-activedescendant, en boucle', async () => {
    const { input } = mountSearch();
    await type(input, 'raf');
    key(input, 'ArrowDown');
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-0');
    key(input, 'ArrowDown');
    key(input, 'ArrowDown');
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-0');
    key(input, 'ArrowUp');
    expect(input.getAttribute('aria-activedescendant')).toBe('hero-suggest-opt-1');
    expect(document.getElementById('hero-suggest-opt-1').getAttribute('aria-selected')).toBe('true');
  });

  test('Échap ferme la liste', async () => {
    const { input, panel } = mountSearch();
    await type(input, 'mig');
    key(input, 'Escape');
    expect(panel.hidden).toBe(true);
    expect(input.getAttribute('aria-expanded')).toBe('false');
    expect(input.hasAttribute('aria-activedescendant')).toBe(false);
  });

  test('aucune correspondance : message hors du listbox, listbox masqué', async () => {
    const { input, list, panel } = mountSearch();
    await type(input, 'zzzz');
    expect(list.querySelectorAll('[role="option"]')).toHaveLength(0);
    expect(list.hidden).toBe(true);
    expect(panel.querySelector('.hero-suggest-empty').textContent).toBe('Aucun appareil ne correspond.');
  });

  test('champ vidé : la liste se ferme', async () => {
    const { input, panel } = mountSearch();
    await type(input, 'raf');
    await type(input, '');
    expect(panel.hidden).toBe(true);
  });

  test('le listbox ne contient que des options ; le pied échappe la saisie', async () => {
    const { input, list, panel } = mountSearch();
    await type(input, 'raf');
    expect([...list.children].every((li) => li.getAttribute('role') === 'option')).toBe(true);
    expect(panel.querySelector('.hero-suggest-all').textContent).toBe('Rechercher « raf » dans le hangar');
    await type(input, 'raf<img>');
    expect(panel.innerHTML).not.toContain('<img>');
  });
});

describe('landing — familles de missions', () => {
  test('rend les familles avec liens filtrés et noms traduits', () => {
    document.body.innerHTML = '<div id="mission-families"></div>';
    const root = document.getElementById('mission-families');
    landing.renderMissions(root, { Chasseur: 63, Transport: 37 }, { Chasseur: 'Fighter' });
    const families = root.querySelectorAll('.mission-family');
    expect(families).toHaveLength(2);
    expect(families[0].querySelector('.mission-family-title').textContent).toContain('63 fiches');
    const link = root.querySelector('.mission-type');
    expect(link.getAttribute('href')).toBe('/hangar?type=Chasseur');
    expect(link.querySelector('.mission-type-name').textContent).toBe('Fighter');
    // Sans traduction disponible, le nom canonique reste affiché.
    expect(families[1].querySelector('.mission-type-name').textContent).toBe('Transport');
  });

  test('loadFacets remplit compteurs et familles, signale un échec', async () => {
    document.body.innerHTML = `
      <span data-gen-count="1"></span><span data-gen-count="5"></span>
      <div id="mission-families"></div><p id="missions-status"></p>`;
    global.auth = {
      fetchWithTimeout: jest.fn((url) => (url === '/api/referentials'
        ? jsonResponse({ types: [{ name: 'Fighter', name_fr: 'Chasseur' }] })
        : jsonResponse({ generations: { 1: 89, 5: 1 }, types: { Chasseur: 63 } }))),
    };
    await landing.loadFacets();
    const counts = [...document.querySelectorAll('[data-gen-count]')].map((el) => el.textContent);
    expect(counts).toEqual(['89 fiches', '1 fiche']);
    expect(document.querySelector('.mission-type-name').textContent).toBe('Fighter');

    auth.fetchWithTimeout = jest.fn(() => jsonResponse({}, false));
    await landing.loadFacets();
    expect(document.getElementById('missions-status').textContent).toBe('Les catégories n\'ont pas pu être chargées.');
  });
});

describe('landing — fin de page selon la session', () => {
  const END = `
    <h2 id="home-end-title" data-i18n-html="home.landing.end_title">Gardez vos appareils<br>sous la main</h2>
    <p id="home-end-text" data-i18n="home.landing.end_text">…</p>
    <div id="home-end-favs" hidden></div>
    <div id="home-end-actions"><a href="/login">Créer un compte</a></div>`;

  test('avec favoris : prénom, vignettes et lien vers les favoris', () => {
    document.body.innerHTML = END;
    landing.renderSignedIn({ name: 'Ada Lovelace' }, AIRCRAFT);
    expect(document.getElementById('home-end-title').textContent).toBe('Bon retour, Ada');
    // L'attribut i18n est retiré, sinon applyToDOM() remettrait l'invitation.
    expect(document.getElementById('home-end-title').hasAttribute('data-i18n-html')).toBe(false);
    expect(document.getElementById('home-end-text').textContent).toBe('3 appareils en favoris. Les derniers ajoutés :');
    const favs = document.getElementById('home-end-favs');
    expect(favs.hidden).toBe(false);
    expect(favs.querySelectorAll('.home-end-fav')).toHaveLength(3);
    expect(favs.innerHTML).toContain('/assets/airplanes/thumbs/rafale.avif');
    expect(document.getElementById('home-end-actions').textContent).toContain('Voir mes 3 favoris');
  });

  test('sans favori : collection vide et seul le hangar est proposé', () => {
    document.body.innerHTML = END;
    landing.renderSignedIn({}, []);
    expect(document.getElementById('home-end-title').textContent).toBe('Bon retour');
    expect(document.getElementById('home-end-favs').hidden).toBe(true);
    const links = document.querySelectorAll('#home-end-actions a');
    expect(links).toHaveLength(1);
    expect(links[0].getAttribute('href')).toBe('/hangar');
  });

  test('visiteur anonyme : la page statique reste en place', async () => {
    document.body.innerHTML = END;
    global.auth = { init: jest.fn(() => Promise.resolve(null)), authFetch: jest.fn() };
    await landing.personalizeEnd();
    expect(auth.authFetch).not.toHaveBeenCalled();
    expect(document.getElementById('home-end-actions').textContent).toContain('Créer un compte');
  });

  test('session : favoris chargés et rendus', async () => {
    document.body.innerHTML = END;
    global.auth = {
      init: jest.fn(() => Promise.resolve({ id: 1 })),
      authFetch: jest.fn(() => jsonResponse(AIRCRAFT.slice(0, 1))),
      getUserInfo: () => ({ name: 'Ada' }),
    };
    await landing.personalizeEnd();
    expect(document.getElementById('home-end-title').textContent).toBe('Bon retour, Ada');
    expect(document.getElementById('home-end-actions').textContent).toContain('Voir mon favori');
  });
});
