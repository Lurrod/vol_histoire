/**
 * Tests — frontend/js/hangar/render.js
 *
 * Cartes, squelettes, état vide, pagination (libellés i18n, bornes, URL et
 * session synchronisées au changement de page), compteurs.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { t: (key, p) => (p ? `${key}:${JSON.stringify(p)}` : key) };
global.animateNumber = jest.fn();

const filters = require('../js/hangar/filters');
const render = require('../js/hangar/render');

function makeState(overrides = {}) {
  return {
    filters: { country: 'France', generation: null, type: null, war: null, mission: null, search: '' },
    sort: 'default', view: 'grid', currentPage: 1, itemsPerPage: 6, total: 0, aircraft: [],
    countries: [{}, {}, {}], generations: [3, 4],
    ...overrides,
  };
}

beforeEach(() => {
  document.body.innerHTML = `
    <div class="hangar-toolbar"></div>
    <div id="airplanes-container"></div>
    <div id="pagination-container"></div>
    <span id="results-count"></span>
    <span id="total-aircraft"></span><span id="total-countries"></span><span id="total-generations"></span>`;
  sessionStorage.clear();
  window.history.replaceState(null, '', '/hangar?compare=4');
  window.scrollTo = jest.fn();
  window.VH.shared = {
    renderAircraftCard: jest.fn((a, o) => `<article class="aircraft-card" data-id="${a.id}" data-opt="${o && o.compare}"></article>`),
  };
  window.VH.hangar.data = { loadAircraft: jest.fn() };
  window.VH.hangar.filters = filters;
  global.animateNumber.mockClear();
});

describe('cartes', () => {
  test('six squelettes pendant le chargement', () => {
    render.renderSkeletons();
    expect(document.querySelectorAll('#airplanes-container .skeleton-card')).toHaveLength(6);
  });

  test('une carte par appareil, avec la case du comparateur demandée', () => {
    render.renderAircraft(makeState({ aircraft: [{ id: 1 }, { id: 2 }] }));
    const cards = document.querySelectorAll('#airplanes-container .aircraft-card');
    expect(cards).toHaveLength(2);
    expect(cards[0].dataset.opt).toBe('true');
    expect(window.VH.shared.renderAircraftCard).toHaveBeenCalledWith({ id: 1 }, { compare: true });
  });

  test('aucun résultat : état vide explicite', () => {
    render.renderAircraft(makeState());
    const empty = document.querySelector('#airplanes-container .empty-state');
    expect(empty).not.toBeNull();
    expect(empty.querySelector('h3').textContent).toBe('Aucun avion trouvé');
  });

  test('sans conteneur, aucun rendu ne lève d\'erreur', () => {
    document.body.innerHTML = '';
    expect(() => {
      render.renderSkeletons();
      render.renderAircraft(makeState({ aircraft: [{ id: 1 }] }));
      render.renderPagination(makeState({ total: 10 }));
      render.lockPagination();
      render.updateResultsCount(makeState());
    }).not.toThrow();
    expect(window.VH.shared.renderAircraftCard).not.toHaveBeenCalled();
  });
});

describe('pagination', () => {
  test('libellés traduits et bornes : précédent désactivé en page 1, suivant en dernière page', () => {
    render.renderPagination(makeState({ total: 13, currentPage: 1 }));
    const c = document.getElementById('pagination-container');
    expect(c.querySelector('.page-info').textContent).toBe('hangar.page_info:{"current":1,"total":3}');
    expect(c.querySelector('.prev-page-btn').disabled).toBe(true);
    expect(c.querySelector('.next-page-btn').disabled).toBe(false);
    expect(c.querySelector('.prev-page-btn').textContent).toContain('hangar.prev_page');
    expect(c.querySelector('.next-page-btn').textContent).toContain('hangar.next_page');

    render.renderPagination(makeState({ total: 13, currentPage: 3 }));
    expect(c.querySelector('.next-page-btn').disabled).toBe(true);
    expect(c.querySelector('.prev-page-btn').disabled).toBe(false);
  });

  test('total nul ou non numérique : pagination vide', () => {
    const c = document.getElementById('pagination-container');
    c.innerHTML = '<button>x</button>';
    render.renderPagination(makeState({ total: 0 }));
    expect(c.innerHTML).toBe('');
    c.innerHTML = '<button>x</button>';
    render.renderPagination(makeState({ total: NaN }));
    expect(c.innerHTML).toBe('');
  });

  test('« Suivant » : page +1, URL et session à jour, ?compare= conservé, défilement vers la barre', () => {
    const state = makeState({ total: 20, currentPage: 1 });
    render.renderPagination(state);
    document.querySelector('.next-page-btn').click();

    expect(state.currentPage).toBe(2);
    const p = new window.URLSearchParams(window.location.search);
    expect(p.get('page')).toBe('2');
    expect(p.get('country')).toBe('France');
    expect(p.get('compare')).toBe('4');
    const saved = JSON.parse(sessionStorage.getItem('hangar_filters'));
    expect(saved.currentPage).toBe(2);
    expect(saved.filters.country).toBe('France');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalledWith(state);
    expect(window.scrollTo).toHaveBeenCalledWith({ top: expect.any(Number), behavior: 'smooth' });
  });

  test('« Précédent » recule d\'une page', () => {
    const state = makeState({ total: 20, currentPage: 3 });
    render.renderPagination(state);
    document.querySelector('.prev-page-btn').click();
    expect(state.currentPage).toBe(2);
  });

  test('changePage borne la page demandée entre 1 et la dernière', () => {
    const state = makeState({ total: 20 });
    render.changePage(state, 99);
    expect(state.currentPage).toBe(4);
    render.changePage(state, -3);
    expect(state.currentPage).toBe(1);
    // Page 1 : le paramètre page disparaît de l'URL
    expect(new window.URLSearchParams(window.location.search).has('page')).toBe(false);
  });

  test('sans barre d\'outils ni total : page 1, défilement en haut', () => {
    document.querySelector('.hangar-toolbar').remove();
    const state = makeState({ total: undefined });
    render.changePage(state, 2);
    expect(state.currentPage).toBe(1);
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });

  test('stockage de session plein : la page change quand même', () => {
    const spy = jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('quota'); });
    const state = makeState({ total: 20 });
    expect(() => render.changePage(state, 2)).not.toThrow();
    expect(state.currentPage).toBe(2);
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalled();
    spy.mockRestore();
  });
});

describe('compteurs', () => {
  test('résultats : aucun, un, plusieurs (pluriel i18n)', () => {
    const el = document.getElementById('results-count');
    render.updateResultsCount(makeState({ total: 0 }));
    expect(el.textContent).toBe('hangar.results_none');
    render.updateResultsCount(makeState({ total: 1 }));
    expect(el.textContent).toBe('hangar.results_one');
    render.updateResultsCount(makeState({ total: 42 }));
    expect(el.textContent).toBe('hangar.results:{"count":42}');
    // Total absent : longueur de la page
    render.updateResultsCount(makeState({ total: undefined, aircraft: [{}, {}] }));
    expect(el.textContent).toBe('hangar.results:{"count":2}');
  });

  test('statistiques : total global, nombre de pays et de générations du référentiel', () => {
    render.updateStats(makeState({ total: 434 }));
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-aircraft'), 434);
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-countries'), 3);
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-generations'), 2);
  });

  test('statistiques sans total ni référentiel', () => {
    render.updateStats(makeState({ total: undefined, aircraft: [{}], countries: undefined, generations: undefined }));
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-aircraft'), 1);
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-countries'), 0);
    expect(global.animateNumber).toHaveBeenCalledWith(document.getElementById('total-generations'), 0);
  });
});
