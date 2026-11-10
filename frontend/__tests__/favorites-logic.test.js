/**
 * Tests unitaires — frontend/js/favorites/{filters,url}.js et
 * render.formatRelativeDate : recherche, filtres, tri, facettes
 * leave-one-out, statistiques, synchronisation avec l'URL.
 */

global.escapeHtml = (s) => String(s == null ? '' : s);
global.i18n = {
  currentLang: 'fr',
  t: (key, params) => (params ? `${key} ${JSON.stringify(params)}` : key),
};

const filters = require('../js/favorites/filters');
const url = require('../js/favorites/url');
const render = require('../js/favorites/render');

const FAVS = [
  { id: 1, name: 'Rafale', complete_name: 'Dassault Rafale', country_name: 'France', generation: 4, type_name: 'Chasseur', favorited_at: '2026-01-03', little_description: 'Omnirôle' },
  { id: 2, name: 'F-22 Raptor', country_name: 'États-Unis', generation: 5, type_name: 'Chasseur', favorited_at: '2026-01-05' },
  { id: 3, name: 'Mirage IV', country_name: 'France', generation: 2, type_name: 'Bombardier', favorited_at: '2026-01-01' },
  { id: 4, name: 'Atlantique', country_name: null, generation: null, type_name: null, favorited_at: '2026-01-04' },
];

function makeState(over = {}) {
  return { ...url.createState(), favorites: FAVS, ...over, filters: { country: null, generation: null, type: null, ...(over.filters || {}) } };
}

describe('filters — recherche et filtres', () => {
  test('matchesSearch : nom, nom complet, pays ou description', () => {
    expect(filters.matchesSearch(FAVS[0], '')).toBe(true);
    expect(filters.matchesSearch(FAVS[0], 'dassault')).toBe(true);
    expect(filters.matchesSearch(FAVS[0], 'omni')).toBe(true);
    expect(filters.matchesSearch(FAVS[1], 'états')).toBe(true);
    expect(filters.matchesSearch(FAVS[3], 'france')).toBe(false);
  });

  test('matchesFilters : pays, génération (nombre ou chaîne), type', () => {
    const f = { country: 'France', generation: 4, type: 'Chasseur' };
    expect(filters.matchesFilters(FAVS[0], f)).toBe(true);
    expect(filters.matchesFilters({ ...FAVS[0], generation: '4' }, f)).toBe(true);
    expect(filters.matchesFilters(FAVS[2], f)).toBe(false);
    expect(filters.matchesFilters(FAVS[1], f)).toBe(false);
  });

  test('matchesFilters ignore la dimension exclue', () => {
    const f = { country: 'France', generation: 4, type: 'Chasseur' };
    expect(filters.matchesFilters(FAVS[2], f, 'generation')).toBe(false); // type différent
    expect(filters.matchesFilters({ ...FAVS[2], type_name: 'Chasseur' }, f, 'generation')).toBe(true);
    expect(filters.matchesFilters(FAVS[1], f, 'country')).toBe(false); // génération 5
    expect(filters.matchesFilters({ ...FAVS[0], type_name: 'X' }, f, 'type')).toBe(true);
  });
});

describe('filters — tri', () => {
  const names = (list) => list.map(a => a.name);

  test.each([
    ['recent', ['F-22 Raptor', 'Atlantique', 'Rafale', 'Mirage IV']],
    ['alphabetical', ['Atlantique', 'F-22 Raptor', 'Mirage IV', 'Rafale']],
    ['nation', ['Atlantique', 'F-22 Raptor', 'Rafale', 'Mirage IV']],
    ['generation', ['F-22 Raptor', 'Rafale', 'Mirage IV', 'Atlantique']],
  ])('tri %s', (sort, expected) => {
    expect(names(filters.sortFavorites(FAVS, sort))).toEqual(expected);
  });

  test('tri inconnu (y compris propriété héritée) : ordre reçu, copie neuve', () => {
    for (const sort of ['inconnu', 'constructor', '__proto__', undefined]) {
      const out = filters.sortFavorites(FAVS, sort);
      expect(out).toEqual(FAVS);
      expect(out).not.toBe(FAVS);
    }
  });

  test('selectFavorites combine recherche, filtres et tri', () => {
    const state = makeState({ search: 'r', sort: 'alphabetical', filters: { country: 'France' } });
    expect(names(filters.selectFavorites(state))).toEqual(['Mirage IV', 'Rafale']);
  });
});

describe('filters — facettes, valeurs, statistiques', () => {
  test('computeFacets : chaque dimension ignore son propre filtre', () => {
    const state = makeState({ filters: { country: 'France', type: 'Chasseur' } });
    expect(filters.computeFacets(state)).toEqual({
      countries: { France: 1, 'États-Unis': 1 },
      generations: { 4: 1 },
      types: { Chasseur: 1, Bombardier: 1 },
    });
  });

  test('computeFacets applique la recherche à toutes les dimensions', () => {
    const state = makeState({ search: 'mirage' });
    expect(filters.computeFacets(state)).toEqual({
      countries: { France: 1 }, generations: { 2: 1 }, types: { Bombardier: 1 },
    });
  });

  test('filterValues : valeurs distinctes triées, vides exclues', () => {
    expect(filters.filterValues(FAVS)).toEqual({
      countries: ['France', 'États-Unis'],
      generations: [2, 4, 5],
      types: ['Bombardier', 'Chasseur'],
    });
  });

  test('computeStats compte favoris, nations et générations', () => {
    expect(filters.computeStats(FAVS)).toEqual({ total: 4, countries: 2, generations: 3 });
    expect(filters.computeStats([])).toEqual({ total: 0, countries: 0, generations: 0 });
  });
});

describe('url', () => {
  afterEach(() => window.history.replaceState(null, '', '/favorites'));

  test('createState et resetState', () => {
    const state = url.createState();
    expect(state).toEqual({ favorites: [], filtered: [], sort: 'recent', search: '', filters: { country: null, generation: null, type: null } });
    Object.assign(state, { sort: 'nation', search: 'x', filters: { country: 'France', generation: 4, type: 'T' } });
    url.resetState(state);
    expect(state.sort).toBe('recent');
    expect(state.search).toBe('');
    expect(state.filters).toEqual({ country: null, generation: null, type: null });
  });

  test('readStateFromUrl : génération en nombre, recherche en minuscules', () => {
    const state = url.createState();
    url.readStateFromUrl(state, '?country=France&gen=4&type=Chasseur&q=RaFaLe&sort=nation');
    expect(state.filters).toEqual({ country: 'France', generation: 4, type: 'Chasseur' });
    expect(state.search).toBe('rafale');
    expect(state.sort).toBe('nation');
  });

  test('readStateFromUrl lit location.search par défaut et laisse le reste', () => {
    window.history.replaceState(null, '', '/favorites?type=Bombardier');
    const state = url.createState();
    url.readStateFromUrl(state);
    expect(state.filters.type).toBe('Bombardier');
    expect(state.filters.country).toBeNull();
    expect(state.sort).toBe('recent');
  });

  test('buildQuery omet les valeurs vides et le tri par défaut', () => {
    const state = url.createState();
    expect(url.buildQuery(state)).toBe('');
    Object.assign(state, { search: 'mig', sort: 'nation', filters: { country: 'France', generation: 4, type: 'Chasseur' } });
    expect(url.buildQuery(state)).toBe('country=France&gen=4&type=Chasseur&q=mig&sort=nation');
  });

  test('writeStateToUrl réécrit l\'adresse sans historique', () => {
    window.history.replaceState(null, '', '/favorites?q=x');
    const state = url.createState();
    url.writeStateToUrl(state);
    expect(window.location.search).toBe('');
    state.filters.generation = 5;
    url.writeStateToUrl(state);
    expect(window.location.pathname + window.location.search).toBe('/favorites?gen=5');
  });

  test('writeStateToUrl avale une erreur de replaceState', () => {
    const spy = jest.spyOn(window.history, 'replaceState').mockImplementation(() => { throw new Error('SecurityError'); });
    expect(() => url.writeStateToUrl(url.createState())).not.toThrow();
    spy.mockRestore();
  });
});

describe('render.formatRelativeDate', () => {
  const now = new Date('2026-06-15T12:00:00Z');
  const daysAgo = (n) => new Date(now.getTime() - n * 86400000).toISOString();

  test.each([
    [0, 'favorites.added_today'],
    [1, 'favorites.added_yesterday'],
    [5, 'favorites.added_days_ago {"days":5}'],
    [35, 'favorites.added_month_ago'],
    [100, 'favorites.added_months_ago {"months":3}'],
  ])('il y a %i jour(s)', (n, expected) => {
    expect(render.formatRelativeDate(daysAgo(n), now)).toBe(expected);
  });

  test('au-delà d\'un an : date complète selon la langue', () => {
    expect(render.formatRelativeDate('2024-03-02T12:00:00Z', now)).toBe('favorites.added_on {"date":"02/03/2024"}');
    i18n.currentLang = 'en';
    expect(render.formatRelativeDate('2024-03-02T12:00:00Z', now)).toBe('favorites.added_on {"date":"02/03/2024"}');
    i18n.currentLang = 'fr';
  });

  test('sans date : chaîne vide ; sans référence : maintenant', () => {
    expect(render.formatRelativeDate(null)).toBe('');
    expect(render.formatRelativeDate(new Date().toISOString())).toBe('favorites.added_today');
  });
});
