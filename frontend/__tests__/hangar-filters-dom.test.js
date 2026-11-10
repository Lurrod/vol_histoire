/**
 * Tests DOM — frontend/js/hangar/filters.js (suite de hangar-filters.test.js)
 *
 * Options échappées, pastilles actives, URL et session synchronisées
 * (?country=, ?war=, ?mission=, ?compare= conservé), listes déroulantes
 * (aria-expanded, clic dehors, transition), recherche différée, tri, popstate.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { t: (key) => key };

const filters = require('../js/hangar/filters');

const KEYS = ['country', 'generation', 'type', 'war', 'mission'];

function buildToolbar() {
  document.body.innerHTML = KEYS.map(k => `
    <div class="filter-group">
      <button type="button" class="filter-btn" id="${k}-filter-btn" aria-expanded="false"></button>
      <div id="${k}-dropdown" class="filter-dropdown hidden">
        <div class="filter-options" id="${k}-options"></div>
      </div>
    </div>`).join('') +
    '<div id="active-filters" class="active-filters hidden"></div>' +
    '<input id="search-input">';
}

function makeState(overrides = {}) {
  return {
    filters: { country: null, generation: null, type: null, war: null, mission: null, search: '' },
    sort: 'default',
    view: 'grid',
    currentPage: 1,
    itemsPerPage: 6,
    total: 0,
    aircraft: [],
    countries: [{ name: 'France', name_fr: 'France' }, { name: 'Sweden', name_fr: 'Suède' }],
    generations: [3, 4, 5],
    types: [{ name: 'Fighter', name_fr: 'Chasseur' }],
    wars: [],
    missions: [{ name: 'Air superiority', name_fr: 'Supériorité aérienne' }],
    ...overrides,
  };
}

const qs = () => new window.URLSearchParams(window.location.search);

beforeEach(() => {
  buildToolbar();
  sessionStorage.clear();
  window.history.replaceState(null, '', '/hangar');
  window.VH.hangar.data = { loadAircraft: jest.fn(), fetchFacets: jest.fn() };
});

describe('options et pastilles actives', () => {
  test('les libellés venus de l\'API sont échappés, la valeur est le nom FR canonique', () => {
    const state = makeState({
      countries: [{ name: '<img src=x onerror=alert(1)>', name_fr: 'Pays"><b>' }],
      wars: [{ name: 'Guerre du Golfe', name_fr: 'Guerre du Golfe', date_start: '1990-08-02', date_end: '1991-02-28' }],
    });
    filters.populateFilterOptions(state);
    const opt = document.querySelector('#country-options .filter-option');
    expect(document.querySelector('#country-options img')).toBeNull();
    expect(document.querySelector('#country-options b')).toBeNull();
    expect(opt.textContent.trim()).toBe('<img src=x onerror=alert(1)>');
    expect(opt.dataset.value).toBe('Pays"><b>');
    expect(opt.tagName).toBe('BUTTON');
    expect(opt.getAttribute('aria-pressed')).toBe('false');
    // Période du conflit en complément du nom
    expect(document.querySelector('#war-options .filter-option-meta').textContent).toBe('1990–1991');
  });

  test('un conflit en cours affiche une période ouverte ; sans name_fr, le nom sert de valeur', () => {
    filters.populateFilterOptions(makeState({
      wars: [{ name: 'Ukraine', date_start: '2022-02-24', date_end: null }],
      missions: [{ name: 'Interception' }],
      types: [{ name: 'Drone' }],
      countries: [{ name: 'Chili' }],
    }));
    expect(document.querySelector('#war-options .filter-option-meta').textContent).toBe('2022–');
    expect(document.querySelector('#war-options .filter-option').dataset.value).toBe('Ukraine');
    expect(document.querySelector('#mission-options .filter-option').dataset.value).toBe('Interception');
    expect(document.querySelector('#type-options .filter-option').dataset.value).toBe('Drone');
    expect(document.querySelector('#country-options .filter-option').dataset.value).toBe('Chili');
  });

  test('conflits et missions absents du state : listes vides, pas d\'erreur', () => {
    filters.populateFilterOptions(makeState({ wars: undefined, missions: undefined }));
    expect(document.getElementById('war-options').children).toHaveLength(0);
    expect(document.getElementById('mission-options').children).toHaveLength(0);
  });

  test('page sans listes (ex. favoris) : rien n\'est rendu, rien ne casse', () => {
    document.body.innerHTML = '';
    expect(() => filters.populateFilterOptions(makeState())).not.toThrow();
  });

  test('cliquer un conflit pose ?war= (nom FR) dans l\'URL et la session, relance chargement et facettes', () => {
    const state = makeState({ wars: [{ name: 'Gulf War', name_fr: 'Guerre du Golfe' }], currentPage: 4 });
    filters.populateFilterOptions(state);
    document.querySelector('#war-options .filter-option').click();

    expect(state.filters.war).toBe('Guerre du Golfe');
    expect(state.currentPage).toBe(1);
    expect(qs().get('war')).toBe('Guerre du Golfe');
    expect(JSON.parse(sessionStorage.getItem('hangar_filters')).filters.war).toBe('Guerre du Golfe');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
    expect(window.VH.hangar.data.fetchFacets).toHaveBeenCalledWith(state);
    expect(document.querySelector('#war-options .filter-option').getAttribute('aria-pressed')).toBe('true');
  });

  test('cliquer une mission pose ?mission=', () => {
    const state = makeState();
    filters.populateFilterOptions(state);
    document.querySelector('#mission-options .filter-option').click();
    expect(qs().get('mission')).toBe('Supériorité aérienne');
  });

  test('pastilles : libellé traduit, échappé, et bouton de retrait par filtre', () => {
    const state = makeState({ wars: [{ name: 'Gulf <War>', name_fr: 'Guerre du Golfe' }] });
    state.filters = {
      country: 'Suède', generation: 4, type: 'Chasseur', war: 'Guerre du Golfe', mission: 'Supériorité aérienne', search: '',
    };
    filters.updateActiveFilters(state);
    const box = document.getElementById('active-filters');
    expect(box.classList.contains('hidden')).toBe(false);
    const labels = Array.from(box.querySelectorAll('.active-filter span')).map(s => s.textContent);
    expect(labels).toEqual(['Sweden', '4e Génération', 'Fighter', 'Gulf <War>', 'Air superiority']);
    expect(box.querySelector('War')).toBeNull();

    box.querySelector('.remove-filter-btn[data-filter-type="country"]').click();
    expect(state.filters.country).toBeNull();
    expect(state.currentPage).toBe(1);
    expect(qs().has('country')).toBe(false);
    expect(qs().get('war')).toBe('Guerre du Golfe');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
    expect(box.querySelectorAll('.active-filter')).toHaveLength(4);
  });

  test('valeur inconnue du référentiel (lien ancien) : la pastille montre la valeur brute', () => {
    const state = makeState({ countries: [], types: [], wars: undefined, missions: undefined });
    state.filters.country = 'Atlantide';
    state.filters.type = 'Dirigeable';
    state.filters.war = 'Guerre de Troie';
    state.filters.mission = 'Pêche';
    filters.updateActiveFilters(state);
    const labels = Array.from(document.querySelectorAll('.active-filter span')).map(s => s.textContent);
    expect(labels).toEqual(['Atlantide', 'Dirigeable', 'Guerre de Troie', 'Pêche']);
  });

  test('aucun filtre : le bandeau est masqué et vidé', () => {
    const box = document.getElementById('active-filters');
    box.classList.remove('hidden');
    box.innerHTML = '<span>reste</span>';
    filters.updateActiveFilters(makeState());
    expect(box.classList.contains('hidden')).toBe(true);
    expect(box.innerHTML).toBe('');
  });

  test('sans bandeau dans la page, seuls les boutons sont synchronisés', () => {
    document.getElementById('active-filters').remove();
    const state = makeState();
    state.filters.type = 'Chasseur';
    expect(() => filters.updateActiveFilters(state)).not.toThrow();
    expect(document.getElementById('type-filter-btn').classList.contains('has-value')).toBe(true);
  });

  test('« Effacer tout » vide aussi la recherche, son champ et l\'URL', () => {
    window.history.replaceState(null, '', '/hangar?q=mig&country=France');
    const state = makeState();
    filters.readStateFromUrl(state);
    document.getElementById('search-input').value = 'mig';
    filters.updateActiveFilters(state);
    document.querySelector('.clear-all-filters').click();
    expect(state.filters.search).toBe('');
    expect(document.getElementById('search-input').value).toBe('');
    expect(window.location.search).toBe('');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
  });

  test('« Effacer tout » sans champ de recherche dans la page', () => {
    document.getElementById('search-input').remove();
    const state = makeState();
    state.filters.country = 'France';
    expect(() => filters.clearAllFilters(state)).not.toThrow();
    expect(state.filters.country).toBeNull();
  });

  test('applyFiltersAndRender délègue à loadAircraft', () => {
    const state = makeState();
    filters.applyFiltersAndRender(state);
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
  });
});

describe('URL et session', () => {
  test('writeStateToUrl écrit chaque filtre, la vue liste et la page, et garde ?compare=', () => {
    window.history.replaceState(null, '', '/hangar?compare=12,30');
    const state = makeState({ sort: 'name', view: 'list', currentPage: 3 });
    state.filters = { country: 'France', generation: 5, type: 'Chasseur', war: 'Kosovo', mission: 'Interception', search: 'rafale' };
    filters.writeStateToUrl(state);
    const p = qs();
    expect(window.location.pathname).toBe('/hangar');
    expect(p.get('country')).toBe('France');
    expect(p.get('gen')).toBe('5');
    expect(p.get('type')).toBe('Chasseur');
    expect(p.get('war')).toBe('Kosovo');
    expect(p.get('mission')).toBe('Interception');
    expect(p.get('q')).toBe('rafale');
    expect(p.get('sort')).toBe('name');
    expect(p.get('view')).toBe('list');
    expect(p.get('page')).toBe('3');
    expect(p.get('compare')).toBe('12,30');
  });

  test('état par défaut : URL nue, sans « ? »', () => {
    window.history.replaceState(null, '', '/hangar?country=France');
    filters.writeStateToUrl(makeState());
    expect(window.location.search).toBe('');
    expect(window.location.pathname).toBe('/hangar');
  });

  test('history.replaceState indisponible : l\'écriture d\'URL échoue sans bruit', () => {
    const spy = jest.spyOn(window.history, 'replaceState').mockImplementation(() => { throw new Error('SecurityError'); });
    const state = makeState();
    state.filters.country = 'France';
    expect(() => filters.writeStateToUrl(state)).not.toThrow();
    spy.mockRestore();
  });

  test('readStateFromUrl lit vue, page, mission et conflit ; page ou vue invalides → défauts', () => {
    window.history.replaceState(null, '', '/hangar?view=list&page=abc&mission=Interception&war=Kosovo&type=Chasseur');
    const state = makeState();
    filters.readStateFromUrl(state);
    expect(state.view).toBe('list');
    expect(state.currentPage).toBe(1);
    expect(state.filters.mission).toBe('Interception');
    expect(state.filters.war).toBe('Kosovo');
    expect(state.filters.type).toBe('Chasseur');

    window.history.replaceState(null, '', '/hangar?view=mosaic&page=-4');
    filters.readStateFromUrl(state);
    expect(state.view).toBe('grid');
    expect(state.currentPage).toBe(1);

    window.history.replaceState(null, '', '/hangar?page=3');
    filters.readStateFromUrl(state);
    expect(state.currentPage).toBe(3);
  });

  test('restoreFiltersFromSession reprend filtres, tri et page', () => {
    sessionStorage.setItem('hangar_filters', JSON.stringify({
      filters: { type: 'Bombardier' }, sort: 'year', currentPage: 4,
    }));
    const state = makeState();
    filters.restoreFiltersFromSession(state);
    expect(state.filters.type).toBe('Bombardier');
    expect(state.filters.country).toBeNull();
    expect(state.sort).toBe('year');
    expect(state.currentPage).toBe(4);
  });

  test('session absente : rien ne change ; session corrompue : purgée', () => {
    const state = makeState();
    filters.restoreFiltersFromSession(state);
    expect(state).toEqual(makeState());

    sessionStorage.setItem('hangar_filters', '{pas du json');
    filters.restoreFiltersFromSession(state);
    expect(sessionStorage.getItem('hangar_filters')).toBeNull();
    expect(state.sort).toBe('default');
  });

  test('session partielle (sans filtres, tri ni page) : valeurs par défaut conservées', () => {
    sessionStorage.setItem('hangar_filters', JSON.stringify({}));
    const state = makeState();
    filters.restoreFiltersFromSession(state);
    expect(state).toEqual(makeState());
  });
});

describe('listes déroulantes', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    document.body.insertAdjacentHTML('beforeend', '<button class="close-dropdown" id="cd"></button><p id="outside">dehors</p>');
    filters.setupDropdowns();
  });
  afterEach(() => {
    jest.runOnlyPendingTimers();
    jest.useRealTimers();
  });

  const dd = (k) => document.getElementById(`${k}-dropdown`);
  const btn = (k) => document.getElementById(`${k}-filter-btn`);

  test('ouvrir une liste : visible, aria-expanded="true", la précédente se referme', () => {
    btn('country').click();
    expect(dd('country').classList.contains('hidden')).toBe(false);
    jest.advanceTimersByTime(20);
    expect(dd('country').classList.contains('show')).toBe(true);
    expect(btn('country').getAttribute('aria-expanded')).toBe('true');

    btn('type').click();
    jest.advanceTimersByTime(20);
    expect(dd('type').classList.contains('show')).toBe(true);
    expect(dd('country').classList.contains('show')).toBe(false);
    expect(btn('country').getAttribute('aria-expanded')).toBe('false');
    expect(btn('type').getAttribute('aria-expanded')).toBe('true');
    jest.advanceTimersByTime(300);
    expect(dd('country').classList.contains('hidden')).toBe(true);
    expect(dd('type').classList.contains('hidden')).toBe(false);
  });

  // Régression (filters.js, setupDropdowns) : recliquer le bouton d'une liste
  // OUVERTE ne la refermait pas (aria-expanded restait à "true", WCAG 4.1.2).
  test('recliquer le bouton referme la liste après sa transition', () => {
    btn('war').click();
    jest.advanceTimersByTime(20);
    btn('war').click();
    expect(dd('war').classList.contains('show')).toBe(false);
    expect(btn('war').getAttribute('aria-expanded')).toBe('false');
    expect(dd('war').classList.contains('hidden')).toBe(false);
    jest.advanceTimersByTime(300);
    expect(dd('war').classList.contains('hidden')).toBe(true);
  });

  test('rouvrir pendant la transition de fermeture annule le masquage', () => {
    btn('mission').click();
    jest.advanceTimersByTime(20);
    document.getElementById('outside').click();
    jest.advanceTimersByTime(100);
    btn('mission').click();
    jest.advanceTimersByTime(400);
    expect(dd('mission').classList.contains('hidden')).toBe(false);
    expect(dd('mission').classList.contains('show')).toBe(true);
  });

  test('clic dehors ou sur « fermer » referme ; clic dans la liste la garde ouverte', () => {
    btn('generation').click();
    jest.advanceTimersByTime(20);
    dd('generation').click();
    expect(dd('generation').classList.contains('show')).toBe(true);

    document.getElementById('outside').click();
    expect(dd('generation').classList.contains('show')).toBe(false);
    expect(btn('generation').getAttribute('aria-expanded')).toBe('false');

    btn('generation').click();
    jest.advanceTimersByTime(20);
    document.getElementById('cd').click();
    expect(dd('generation').classList.contains('show')).toBe(false);
  });
});

describe('recherche, tri, historique', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    document.body.insertAdjacentHTML('beforeend',
      '<select id="sort-select"><option value="default">D</option><option value="name">N</option><option value="year">A</option></select>');
  });
  afterEach(() => jest.useRealTimers());

  test('la saisie est mise en minuscules et n\'interroge l\'API qu\'après 300 ms de pause', () => {
    const state = makeState({ currentPage: 3 });
    filters.setupSearchAndSort(state);
    const input = document.getElementById('search-input');
    input.value = 'Mi';
    input.dispatchEvent(new Event('input'));
    input.value = 'MIRAGE';
    input.dispatchEvent(new Event('input'));
    expect(state.filters.search).toBe('mirage');
    expect(state.currentPage).toBe(1);
    expect(window.VH.hangar.data.loadAircraft).not.toHaveBeenCalled();

    jest.advanceTimersByTime(300);
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledTimes(1);
    expect(qs().get('q')).toBe('mirage');
  });

  test('changer le tri recharge la page 1 et écrit ?sort=', () => {
    const state = makeState({ currentPage: 2 });
    filters.setupSearchAndSort(state);
    const sel = document.getElementById('sort-select');
    sel.value = 'year';
    sel.dispatchEvent(new Event('change'));
    expect(state.sort).toBe('year');
    expect(state.currentPage).toBe(1);
    expect(qs().get('sort')).toBe('year');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
  });

  test('popstate relit l\'URL, recale les champs et recharge', () => {
    const state = makeState();
    filters.setupSearchAndSort(state);
    window.history.replaceState(null, '', '/hangar?q=f-16&sort=name&mission=Interception');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(state.filters.search).toBe('f-16');
    expect(state.filters.mission).toBe('Interception');
    expect(document.getElementById('search-input').value).toBe('f-16');
    expect(document.getElementById('sort-select').value).toBe('name');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
    expect(document.getElementById('mission-filter-btn').classList.contains('has-value')).toBe(true);
  });

  test('page sans champ de recherche ni tri : rien ne casse', () => {
    document.getElementById('search-input').remove();
    document.getElementById('sort-select').remove();
    const state = makeState();
    filters.setupSearchAndSort(state);
    window.history.replaceState(null, '', '/hangar?q=x');
    expect(() => window.dispatchEvent(new window.PopStateEvent('popstate'))).not.toThrow();
    expect(state.filters.search).toBe('x');
  });

  // Régression (filters.js, popstate) : readStateFromUrl n'applique que les
  // paramètres PRÉSENTS. Au retour arrière vers une entrée d'historique sans
  // ?country= ni ?q=, le filtre et la recherche restaient posés alors que
  // l'URL ne les portait plus.
  test('popstate vers une URL sans filtre retire les filtres absents et vide la recherche', () => {
    const state = makeState();
    filters.setupSearchAndSort(state);
    state.filters.country = 'France';
    state.filters.search = 'mirage';
    state.sort = 'name';
    document.getElementById('search-input').value = 'mirage';
    window.history.replaceState(null, '', '/hangar');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(state.filters.country).toBeNull();
    expect(state.filters.search).toBe('');
    expect(state.sort).toBe('default');
    expect(document.getElementById('search-input').value).toBe('');
    expect(document.getElementById('sort-select').value).toBe('default');
    expect(document.getElementById('country-filter-btn').classList.contains('has-value')).toBe(false);
  });
});
