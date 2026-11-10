/**
 * Tests — démarrage du hangar (hangar.js), PERF-006 : un seul appel
 * /api/airplanes à l'ouverture. hangar.js relisait l'URL puis relançait
 * applyFiltersAndRender → loadAircraft une seconde fois, avec le même état.
 */

function stubModules() {
  const data = {
    loadReferentialData: jest.fn(() => Promise.resolve()),
    loadAircraft: jest.fn(() => Promise.resolve()),
    fetchFacets: jest.fn(),
  };
  const filters = {
    setupDropdowns: jest.fn(),
    setupSearchAndSort: jest.fn(),
    restoreFiltersFromSession: jest.fn(),
    readStateFromUrl: jest.fn((state) => {
      const p = new window.URLSearchParams(window.location.search);
      if (p.has('q')) state.filters.search = p.get('q');
      if (p.has('sort')) state.sort = p.get('sort');
    }),
    updateActiveFilters: jest.fn(),
    // Alias historique de loadAircraft (filters.js)
    applyFiltersAndRender: jest.fn((state) => data.loadAircraft(state)),
    closeAllDropdowns: jest.fn(),
  };
  window.VH = {
    hangar: {
      data,
      filters,
      admin: { setupAdminModal: jest.fn(), closeModal: jest.fn() },
      render: { updateResultsCount: jest.fn(), renderAircraft: jest.fn() },
      viewToggle: { init: jest.fn() },
      compare: { init: jest.fn() },
      mobileSheet: { init: jest.fn() },
      nationsMapFilter: { init: jest.fn() },
    },
  };
  return { data, filters };
}

// Écouteurs posés sur document / window par le démarrage : retirés après
// chaque test, sinon ceux des démarrages précédents réagiraient aussi.
let attached = [];

afterEach(() => {
  attached.forEach(([target, type, fn, opts]) => target.removeEventListener(type, fn, opts));
  attached = [];
});

async function boot(search = '', { payload = null } = {}) {
  jest.resetModules();
  window.history.replaceState(null, '', `/hangar${search}`);
  document.body.innerHTML = `
    <button id="add-airplane-btn" class="hidden"></button>
    <input id="search-input">
    <select id="sort-select"><option value="default">Défaut</option><option value="name">Nom</option></select>
    <ul class="nav-links"></ul>`;
  global.auth = { init: jest.fn(() => Promise.resolve()), getPayload: () => payload };
  global.nav = { updateAuthUI: jest.fn(), closeMenu: jest.fn() };
  const mods = stubModules();
  // On capte le gestionnaire DOMContentLoaded de CE chargement : ceux des
  // tests précédents restent attachés au document et fausseraient le compte.
  const docSpy = jest.spyOn(document, 'addEventListener');
  const winSpy = jest.spyOn(window, 'addEventListener');
  require('../js/hangar');
  const onReady = docSpy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
  await onReady();
  docSpy.mock.calls.forEach(([type, fn, opts]) => attached.push([document, type, fn, opts]));
  winSpy.mock.calls.forEach(([type, fn, opts]) => attached.push([window, type, fn, opts]));
  docSpy.mockRestore();
  winSpy.mockRestore();
  return mods;
}

describe('hangar.js — démarrage', () => {
  test('un seul chargement des appareils à l\'ouverture', async () => {
    const { data } = await boot();
    expect(data.loadReferentialData).toHaveBeenCalledTimes(1);
    expect(data.loadAircraft).toHaveBeenCalledTimes(1);
  });

  test('l\'état de l\'URL est appliqué avant ce chargement unique', async () => {
    const { data } = await boot('?q=mirage&sort=name');
    expect(data.loadAircraft).toHaveBeenCalledTimes(1);
    const state = data.loadAircraft.mock.calls[0][0];
    expect(state.filters.search).toBe('mirage');
    expect(state.sort).toBe('name');
    expect(document.getElementById('search-input').value).toBe('mirage');
    expect(document.getElementById('sort-select').value).toBe('name');
  });

  test('les modules secondaires sont toujours initialisés', async () => {
    const { data } = await boot();
    expect(data.fetchFacets).toHaveBeenCalledTimes(1);
    expect(window.VH.hangar.viewToggle.init).toHaveBeenCalledTimes(1);
    expect(window.VH.hangar.compare.init).toHaveBeenCalledTimes(1);
    expect(window.VH.hangar.mobileSheet.init).toHaveBeenCalledTimes(1);
    expect(window.VH.hangar.nationsMapFilter.init).toHaveBeenCalledTimes(1);
  });
});

describe('hangar.js — rôles, langue, clavier, geste', () => {
  test('le bouton d’ajout apparaît pour un admin et un éditeur, jamais pour un utilisateur', async () => {
    await boot('', { payload: { role: '1' } });
    expect(document.getElementById('add-airplane-btn').classList.contains('hidden')).toBe(false);
    await boot('', { payload: { role: 2 } });
    expect(document.getElementById('add-airplane-btn').classList.contains('hidden')).toBe(false);
    await boot('', { payload: { role: 3 } });
    expect(document.getElementById('add-airplane-btn').classList.contains('hidden')).toBe(true);
    await boot();
    expect(document.getElementById('add-airplane-btn').classList.contains('hidden')).toBe(true);
  });

  test('l’état initial du hangar : 6 par page, vue lue dans localStorage', async () => {
    localStorage.setItem('vh_hangar_view', 'list');
    const { data } = await boot();
    const state = data.loadAircraft.mock.calls[0][0];
    expect(state.itemsPerPage).toBe(6);
    expect(state.view).toBe('list');
    expect(state.filters).toEqual({ country: null, generation: null, type: null, war: null, mission: null, search: '' });
    localStorage.removeItem('vh_hangar_view');
  });

  test('tri par défaut : le select n’est pas touché', async () => {
    await boot('?q=');
    expect(document.getElementById('sort-select').value).toBe('default');
    expect(document.getElementById('search-input').value).toBe('');
  });

  test('changement de langue : compteur et cartes re-rendus (cartes seulement s’il y en a)', async () => {
    const { data } = await boot();
    const state = data.loadAircraft.mock.calls[0][0];
    const { render } = window.VH.hangar;
    window.dispatchEvent(new Event('langChanged'));
    expect(render.updateResultsCount).toHaveBeenCalledWith(state);
    expect(render.renderAircraft).not.toHaveBeenCalled();

    state.aircraft = [{ id: 1 }];
    window.dispatchEvent(new Event('langChanged'));
    expect(render.renderAircraft).toHaveBeenCalledWith(state);
  });

  test('Échap ferme la modale admin et les listes déroulantes', async () => {
    await boot();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    expect(window.VH.hangar.admin.closeModal).toHaveBeenCalledTimes(1);
    expect(window.VH.hangar.filters.closeAllDropdowns).toHaveBeenCalledTimes(1);
  });

  test('« / » place le focus dans la recherche ; Ctrl+/ est laissé au navigateur', async () => {
    await boot();
    const slash = new KeyboardEvent('keydown', { key: '/', cancelable: true });
    document.dispatchEvent(slash);
    expect(slash.defaultPrevented).toBe(true);
    expect(document.activeElement).toBe(document.getElementById('search-input'));

    document.activeElement.blur();
    const ctrl = new KeyboardEvent('keydown', { key: '/', ctrlKey: true, cancelable: true });
    document.dispatchEvent(ctrl);
    expect(ctrl.defaultPrevented).toBe(false);
    expect(document.activeElement).not.toBe(document.getElementById('search-input'));
  });

  function swipe(fromY, toY) {
    const ev = (type, y) => {
      const e = new Event(type);
      e.changedTouches = [{ screenY: y }];
      document.dispatchEvent(e);
    };
    ev('touchstart', fromY);
    ev('touchend', toY);
  }

  test('balayage vers le haut (> 100 px) referme le menu mobile ouvert', async () => {
    await boot();
    document.querySelector('.nav-links').classList.add('show');
    swipe(500, 300);
    expect(nav.closeMenu).toHaveBeenCalledTimes(1);
  });

  test('balayage court, ou menu fermé : rien ne se passe', async () => {
    await boot();
    document.querySelector('.nav-links').classList.add('show');
    swipe(500, 450);
    document.querySelector('.nav-links').classList.remove('show');
    swipe(500, 100);
    expect(nav.closeMenu).not.toHaveBeenCalled();
  });
});
