/**
 * Tests — frontend/js/hangar/data.js
 *
 * Chargement des référentiels, de la liste paginée et des facettes. On vérifie
 * les paramètres envoyés à l'API (nom FR canonique pour pays, conflit et
 * mission), l'ordre des rendus, le recul de page quand le total a fondu, et
 * qu'une réponse périmée n'écrase jamais une demande plus récente.
 */

function jsonResponse(body, ok = true) {
  return { ok, json: () => Promise.resolve(body) };
}

function makeState(overrides = {}) {
  return {
    aircraft: [],
    total: 0,
    currentPage: 1,
    itemsPerPage: 6,
    filters: { country: null, generation: null, type: null, war: null, mission: null, search: '' },
    sort: 'default',
    countries: [], generations: [], types: [], manufacturers: [], wars: [], missions: [],
    facets: null,
    ...overrides,
  };
}

let data;
let render;

beforeEach(() => {
  jest.resetModules();
  global.showToast = jest.fn();
  global.i18n = { t: (k) => k };
  global.auth = { fetchWithTimeout: jest.fn() };
  render = {
    renderSkeletons: jest.fn(),
    lockPagination: jest.fn(),
    renderAircraft: jest.fn(),
    renderPagination: jest.fn(),
    updateResultsCount: jest.fn(),
    updateStats: jest.fn(),
  };
  window.VH = {
    hangar: {
      render,
      filters: { populateFilterOptions: jest.fn() },
      admin: { populateFormSelects: jest.fn() },
    },
  };
  require('../js/hangar/data');
  data = window.VH.hangar.data;
});

afterEach(() => { delete global.fetch; });

const lastUrl = () => auth.fetchWithTimeout.mock.calls.at(-1)[0];
const paramsOf = (url) => new window.URLSearchParams(url.split('?')[1]);

describe('loadReferentialData', () => {
  test('remplit le state puis peuple les filtres et le formulaire admin', async () => {
    const payload = {
      countries: [{ name: 'France' }], generations: [4, 5], types: [{ name: 'Chasseur' }],
      manufacturers: [{ name: 'Dassault' }], wars: [{ name: 'Golfe' }], missions: [{ name: 'Interception' }],
    };
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(payload));
    const state = makeState();
    await data.loadReferentialData(state);

    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/referentials');
    expect(state.countries).toEqual(payload.countries);
    expect(state.generations).toEqual([4, 5]);
    expect(state.wars).toEqual(payload.wars);
    expect(state.missions).toEqual(payload.missions);
    expect(window.VH.hangar.filters.populateFilterOptions).toHaveBeenCalledWith(state);
    expect(window.VH.hangar.admin.populateFormSelects).toHaveBeenCalledWith(state);
    expect(showToast).not.toHaveBeenCalled();
  });

  test('une réponse mal formée donne des listes vides, jamais undefined', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({ countries: 'x', wars: null }));
    const state = makeState();
    await data.loadReferentialData(state);
    ['countries', 'generations', 'types', 'manufacturers', 'wars', 'missions']
      .forEach(k => expect(state[k]).toEqual([]));
  });

  test('erreur serveur : toast d\'erreur, filtres non peuplés', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({}, false));
    await data.loadReferentialData(makeState());
    expect(showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    expect(window.VH.hangar.filters.populateFilterOptions).not.toHaveBeenCalled();
  });
});

describe('loadAircraft', () => {
  test('envoie tri, page, limite et tous les filtres actifs', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({ data: [{ id: 1 }], total: 13 }));
    const state = makeState({
      sort: 'name', currentPage: 2,
      filters: {
        country: 'Suède', generation: 4, type: 'Chasseur',
        war: 'Guerre du Golfe', mission: 'Supériorité aérienne', search: 'gripen',
      },
    });
    await data.loadAircraft(state);

    const url = lastUrl();
    expect(url.startsWith('/api/airplanes?')).toBe(true);
    const p = paramsOf(url);
    expect(p.get('sort')).toBe('name');
    expect(p.get('page')).toBe('2');
    expect(p.get('limit')).toBe('6');
    expect(p.get('country')).toBe('Suède');
    expect(p.get('generation')).toBe('4');
    expect(p.get('type')).toBe('Chasseur');
    expect(p.get('war')).toBe('Guerre du Golfe');
    expect(p.get('mission')).toBe('Supériorité aérienne');
    expect(p.get('search')).toBe('gripen');
  });

  test('sans filtre, aucun paramètre de filtre n\'est envoyé', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({ data: [], total: 0 }));
    await data.loadAircraft(makeState());
    const p = paramsOf(lastUrl());
    ['country', 'generation', 'type', 'war', 'mission', 'search'].forEach(k => expect(p.has(k)).toBe(false));
  });

  test('squelettes et verrou de pagination avant la requête, rendu complet après', async () => {
    const order = [];
    render.renderSkeletons.mockImplementation(() => order.push('skeletons'));
    render.lockPagination.mockImplementation(() => order.push('lock'));
    auth.fetchWithTimeout.mockImplementationOnce(() => {
      order.push('fetch');
      return Promise.resolve(jsonResponse({ data: [{ id: 1 }, { id: 2 }], total: 2 }));
    });
    render.renderAircraft.mockImplementation(() => order.push('cards'));
    const state = makeState();
    await data.loadAircraft(state);

    expect(order).toEqual(['skeletons', 'lock', 'fetch', 'cards']);
    expect(state.aircraft).toEqual([{ id: 1 }, { id: 2 }]);
    expect(state.total).toBe(2);
    expect(render.renderPagination).toHaveBeenCalledWith(state);
    expect(render.updateResultsCount).toHaveBeenCalledWith(state);
    expect(render.updateStats).toHaveBeenCalledWith(state);
  });

  test('total absent : on retombe sur la longueur de la page', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({ data: [{ id: 1 }, { id: 2 }, { id: 3 }] }));
    const state = makeState();
    await data.loadAircraft(state);
    expect(state.total).toBe(3);
  });

  test('data non tableau : liste vide', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({ data: null, total: 0 }));
    const state = makeState({ aircraft: [{ id: 9 }] });
    await data.loadAircraft(state);
    expect(state.aircraft).toEqual([]);
  });

  test('page au-delà du total : recule à la dernière page et refait UNE requête', async () => {
    auth.fetchWithTimeout
      .mockResolvedValueOnce(jsonResponse({ data: [], total: 7 }))
      .mockResolvedValueOnce(jsonResponse({ data: [{ id: 7 }], total: 7 }));
    const state = makeState({ currentPage: 5 });
    await data.loadAircraft(state);

    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(2);
    expect(paramsOf(lastUrl()).get('page')).toBe('2');
    expect(state.currentPage).toBe(2);
    expect(state.aircraft).toEqual([{ id: 7 }]);
    expect(render.renderAircraft).toHaveBeenCalledTimes(1);
  });

  test('une réponse périmée n\'écrase pas la demande plus récente', async () => {
    let resolveOld;
    auth.fetchWithTimeout
      .mockImplementationOnce(() => new Promise(r => { resolveOld = r; }))
      .mockResolvedValueOnce(jsonResponse({ data: [{ id: 'neuf' }], total: 1 }));
    const state = makeState();
    const old = data.loadAircraft(state);
    await data.loadAircraft(state);
    resolveOld(jsonResponse({ data: [{ id: 'ancien' }], total: 1 }));
    await old;

    expect(state.aircraft).toEqual([{ id: 'neuf' }]);
    expect(render.renderAircraft).toHaveBeenCalledTimes(1);
  });

  test('erreur : la pagination est rendue de nouveau (réessai possible) et un toast prévient', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse({}, false));
    const state = makeState();
    await data.loadAircraft(state);
    expect(render.renderPagination).toHaveBeenCalledWith(state);
    expect(render.renderAircraft).not.toHaveBeenCalled();
    expect(showToast).toHaveBeenCalledWith('common.loading_error', 'error');
  });

  test('une erreur périmée reste silencieuse', async () => {
    let rejectOld;
    auth.fetchWithTimeout
      .mockImplementationOnce(() => new Promise((_, rej) => { rejectOld = rej; }))
      .mockResolvedValueOnce(jsonResponse({ data: [], total: 0 }));
    const state = makeState();
    const old = data.loadAircraft(state);
    await data.loadAircraft(state);
    rejectOld(new Error('timeout'));
    await old;
    expect(showToast).not.toHaveBeenCalled();
  });
});

describe('fetchFacets', () => {
  function buildOptions() {
    document.body.innerHTML = `
      <div id="country-options"><button class="filter-option" data-value="France"></button><button class="filter-option" data-value="Suède"></button></div>
      <div id="generation-options"><button class="filter-option" data-value="4"></button></div>
      <div id="type-options"><button class="filter-option" data-value="Chasseur"></button></div>
      <div id="war-options"><button class="filter-option" data-value="Guerre du Golfe"></button></div>
      <div id="mission-options"><button class="filter-option" data-value="Interception"></button></div>`;
  }

  beforeEach(buildOptions);

  test('transmet les filtres actifs (sans recherche ni pagination)', async () => {
    global.fetch = jest.fn(() => Promise.resolve(jsonResponse({ countries: {}, generations: {}, types: {} })));
    await data.fetchFacets(makeState({
      filters: { country: 'France', generation: 4, type: 'Chasseur', war: 'Guerre du Golfe', mission: 'Interception', search: 'x' },
    }));
    const url = fetch.mock.calls[0][0];
    expect(url.startsWith('/api/airplanes/facets?')).toBe(true);
    const p = paramsOf(url);
    expect(p.get('country')).toBe('France');
    expect(p.get('generation')).toBe('4');
    expect(p.get('type')).toBe('Chasseur');
    expect(p.get('war')).toBe('Guerre du Golfe');
    expect(p.get('mission')).toBe('Interception');
    expect(p.has('search')).toBe(false);
  });

  test('pose le compte de chaque option et grise celles à zéro', async () => {
    global.fetch = jest.fn(() => Promise.resolve(jsonResponse({
      countries: { France: 12 }, generations: { 4: 3 }, types: { Chasseur: 0 },
      wars: { 'Guerre du Golfe': 5 }, missions: {},
    })));
    const state = makeState();
    await data.fetchFacets(state);

    const fr = document.querySelector('#country-options [data-value="France"]');
    const se = document.querySelector('#country-options [data-value="Suède"]');
    expect(fr.querySelector('.fc').textContent).toBe(' (12)');
    expect(fr.classList.contains('filter-option-empty')).toBe(false);
    expect(se.querySelector('.fc').textContent).toBe(' (0)');
    expect(se.classList.contains('filter-option-empty')).toBe(true);
    expect(document.querySelector('#generation-options .fc').textContent).toBe(' (3)');
    expect(document.querySelector('#type-options .filter-option').classList.contains('filter-option-empty')).toBe(true);
    expect(document.querySelector('#war-options .fc').textContent).toBe(' (5)');
    expect(document.querySelector('#mission-options .fc').textContent).toBe(' (0)');
    expect(state.facets.countries.France).toBe(12);
  });

  test('un second passage met à jour le compte sans dupliquer la pastille', async () => {
    global.fetch = jest.fn()
      .mockResolvedValueOnce(jsonResponse({ countries: { France: 12 }, generations: {}, types: {} }))
      .mockResolvedValueOnce(jsonResponse({ countries: { France: 2 }, generations: {}, types: {} }));
    const state = makeState();
    await data.fetchFacets(state);
    await data.fetchFacets(state);
    const fr = document.querySelector('#country-options [data-value="France"]');
    expect(fr.querySelectorAll('.fc')).toHaveLength(1);
    expect(fr.querySelector('.fc').textContent).toBe(' (2)');
  });

  test('facettes sans conflits ni missions (API antérieure) : comptes à zéro, pas d\'erreur', async () => {
    global.fetch = jest.fn(() => Promise.resolve(jsonResponse({ countries: {}, generations: {}, types: {} })));
    await data.fetchFacets(makeState());
    expect(document.querySelector('#war-options .fc').textContent).toBe(' (0)');
    expect(document.querySelector('#mission-options .fc').textContent).toBe(' (0)');
  });

  test('réponse en erreur ou réseau coupé : rien n\'est touché', async () => {
    const state = makeState();
    global.fetch = jest.fn(() => Promise.resolve(jsonResponse({}, false)));
    await data.fetchFacets(state);
    expect(state.facets).toBeNull();
    global.fetch = jest.fn(() => Promise.reject(new Error('offline')));
    await expect(data.fetchFacets(state)).resolves.toBeUndefined();
    expect(document.querySelector('.fc')).toBeNull();
  });
});
