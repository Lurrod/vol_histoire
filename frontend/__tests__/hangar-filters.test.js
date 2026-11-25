/**
 * Tests unitaires — frontend/js/hangar/filters.js et hangar/render.js
 *
 * L'état visuel de la barre de filtres doit suivre l'état réel, d'où qu'il
 * vienne (clic, URL, « Effacer tout ») : option retenue surlignée, bouton
 * doré quand son filtre porte une valeur. Et la pagination ne doit plus rien
 * déclencher pendant un chargement.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { t: (key) => key };
global.animateNumber = jest.fn();

const { loadMotion } = require('./helpers/motion-env');
const filters = require('../js/hangar/filters');
loadMotion(['.filter-dropdown']);
const render = require('../js/hangar/render');

const KEYS = ['country', 'generation', 'type', 'war', 'mission'];

function buildToolbar() {
  document.body.innerHTML = KEYS.map(k => `
    <div class="filter-group">
      <button type="button" class="filter-btn" id="${k}-filter-btn" aria-expanded="false"></button>
      <div id="${k}-dropdown" class="filter-dropdown hidden">
        <div class="filter-options" id="${k}-options"></div>
      </div>
    </div>`).join('') +
    '<button type="button" class="filter-btn" id="map-filter-btn"></button>' +
    '<div id="active-filters" class="active-filters hidden"></div>' +
    '<input id="search-input">' +
    '<div id="pagination-container" class="pagination"></div>';
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

const selected = (k) => Array.from(document.querySelectorAll(`#${k}-options .filter-option.selected`))
  .map(o => o.dataset.value);
const hasValue = (k) => document.getElementById(`${k}-filter-btn`).classList.contains('has-value');

beforeEach(() => {
  buildToolbar();
  sessionStorage.clear();
  window.history.replaceState(null, '', '/hangar');
  window.VH.hangar.data = { loadAircraft: jest.fn(), fetchFacets: jest.fn() };
});

describe('filtres du hangar — état visuel', () => {
  test('un filtre lu depuis l\'URL surligne son option et son bouton', () => {
    window.history.replaceState(null, '', '/hangar?gen=4&country=Su%C3%A8de');
    const state = makeState();
    filters.readStateFromUrl(state);
    filters.populateFilterOptions(state);

    // La génération arrive en nombre depuis l'URL, en chaîne dans data-value.
    expect(selected('generation')).toEqual(['4']);
    expect(selected('country')).toEqual(['Suède']);
    expect(hasValue('generation')).toBe(true);
    expect(hasValue('country')).toBe(true);
    expect(hasValue('type')).toBe(false);
    expect(selected('type')).toEqual([]);
  });

  test('cliquer une option la sélectionne, recliquer la retire', () => {
    const state = makeState();
    filters.populateFilterOptions(state);
    const opt = document.querySelector('#generation-options .filter-option[data-value="5"]');

    opt.click();
    expect(state.filters.generation).toBe(5);
    expect(selected('generation')).toEqual(['5']);
    expect(hasValue('generation')).toBe(true);
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalled();

    opt.click();
    expect(state.filters.generation).toBeNull();
    expect(selected('generation')).toEqual([]);
    expect(hasValue('generation')).toBe(false);
  });

  test('« Effacer tout » remet la barre à zéro', () => {
    const state = makeState();
    state.filters.type = 'Chasseur';
    state.filters.mission = 'Supériorité aérienne';
    filters.populateFilterOptions(state);
    filters.updateActiveFilters(state);
    expect(hasValue('type')).toBe(true);
    expect(hasValue('mission')).toBe(true);

    filters.clearAllFilters(state);
    KEYS.forEach(k => {
      expect(hasValue(k)).toBe(false);
      expect(selected(k)).toEqual([]);
    });
  });

  test('ne touche pas à .active, réservée au bouton « Carte » (panneau ouvert)', () => {
    const state = makeState();
    const mapBtn = document.getElementById('map-filter-btn');
    mapBtn.classList.add('active');
    state.filters.country = 'France';
    filters.syncFilterUi(state);
    expect(mapBtn.classList.contains('active')).toBe(true);
    expect(document.getElementById('country-filter-btn').classList.contains('active')).toBe(false);
  });
});

describe('URL du hangar et session', () => {
  test('urlDescribesFilters : un filtre ou une recherche dans l\'URL, pas la vue ni la page', () => {
    expect(filters.urlDescribesFilters('?decade=1950')).toBe(true);
    expect(filters.urlDescribesFilters('?q=mira')).toBe(true);
    expect(filters.urlDescribesFilters('?country=France&page=2')).toBe(true);
    expect(filters.urlDescribesFilters('?view=list&page=3&compare=1,2')).toBe(false);
    expect(filters.urlDescribesFilters('')).toBe(false);
  });

  test('lien de la frise : la session ne se mélange pas au filtre de l\'URL', () => {
    const state = { filters: { country: null, generation: null, type: 'Chasseur', war: null, mission: null, decade: null, search: 'x' }, sort: 'name', currentPage: 3 };
    filters.resetUrlState(state);
    window.history.replaceState(null, '', '/hangar?decade=1950');
    filters.readStateFromUrl(state);
    expect(state.filters).toMatchObject({ type: null, decade: 1950, search: '' });
    expect(state.currentPage).toBe(1);
    window.history.replaceState(null, '', '/hangar?decade=1955');
    const other = { filters: { decade: null }, currentPage: 1 };
    filters.readStateFromUrl(other);
    expect(other.filters.decade).toBeNull(); // décennie hors de la frise ignorée
    window.history.replaceState(null, '', '/hangar');
  });
});

describe('pagination du hangar', () => {
  test('verrouillée pendant le chargement, réactivée au rendu suivant', () => {
    const state = makeState({ total: 30, currentPage: 2 });
    render.renderPagination(state);
    const container = document.getElementById('pagination-container');
    const off = (el) => el.getAttribute('aria-disabled') === 'true';
    expect(off(container.querySelector('.next-page-btn'))).toBe(false);

    render.lockPagination();
    expect(container.getAttribute('aria-busy')).toBe('true');
    container.querySelectorAll('.page-link').forEach(a => expect(off(a)).toBe(true));

    // Un changement de page demandé pendant le chargement est ignoré.
    render.changePage(state, 3);
    expect(state.currentPage).toBe(2);

    render.renderPagination(state);
    expect(container.hasAttribute('aria-busy')).toBe(false);
    expect(off(container.querySelector('.prev-page-btn'))).toBe(false);
    expect(off(container.querySelector('.next-page-btn'))).toBe(false);
  });
});
