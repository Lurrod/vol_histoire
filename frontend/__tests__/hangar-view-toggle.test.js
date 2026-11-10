/**
 * Tests — frontend/js/hangar/view-toggle.js
 *
 * Bascule grille / liste : groupe de deux boutons à aria-pressed exclusif,
 * classes du conteneur, persistance localStorage et écriture dans l'URL.
 */

let filters;

function boot(view = 'grid', { toolbar = true } = {}) {
  jest.resetModules();
  document.body.innerHTML = `
    ${toolbar ? '<div class="toolbar-right"><select id="sort-select"></select></div>' : ''}
    <div id="airplanes-container"></div>`;
  filters = { saveFiltersToSession: jest.fn() };
  window.VH = { hangar: { filters } };
  require('../js/hangar/view-toggle');
  const state = { view };
  window.VH.hangar.viewToggle.init(state);
  return state;
}

const container = () => document.getElementById('airplanes-container');
const pressed = (id) => document.getElementById(id).getAttribute('aria-pressed');

beforeEach(() => localStorage.clear());

describe('bascule grille / liste', () => {
  test('insère un groupe nommé de deux boutons avant le tri', () => {
    boot();
    const group = document.getElementById('view-toggle');
    expect(group.getAttribute('role')).toBe('group');
    expect(group.getAttribute('aria-label')).toBe('Vue');
    expect(group.nextElementSibling.id).toBe('sort-select');
    expect(document.getElementById('view-grid').getAttribute('aria-label')).toBe('Vue grille');
    expect(document.getElementById('view-list').getAttribute('aria-label')).toBe('Vue liste');
  });

  test('vue initiale grille : classes et aria-pressed cohérents', () => {
    boot('grid');
    expect(container().classList.contains('aircraft-grid')).toBe(true);
    expect(container().classList.contains('aircraft-list')).toBe(false);
    expect(pressed('view-grid')).toBe('true');
    expect(pressed('view-list')).toBe('false');
  });

  test('vue initiale liste (URL ou stockage)', () => {
    boot('list');
    expect(container().classList.contains('aircraft-list')).toBe(true);
    expect(pressed('view-list')).toBe('true');
    expect(pressed('view-grid')).toBe('false');
  });

  test('passer en liste puis en grille : état, stockage, URL et aria-pressed suivent', () => {
    const state = boot('grid');
    document.getElementById('view-list').click();
    expect(state.view).toBe('list');
    expect(localStorage.getItem('vh_hangar_view')).toBe('list');
    expect(container().classList.contains('aircraft-list')).toBe(true);
    expect(pressed('view-list')).toBe('true');
    expect(pressed('view-grid')).toBe('false');
    expect(filters.saveFiltersToSession).toHaveBeenCalledWith(state);

    document.getElementById('view-grid').click();
    expect(state.view).toBe('grid');
    expect(localStorage.getItem('vh_hangar_view')).toBe('grid');
    expect(container().classList.contains('aircraft-grid')).toBe(true);
    expect(pressed('view-grid')).toBe('true');
    expect(filters.saveFiltersToSession).toHaveBeenCalledTimes(2);
  });

  test('un second init ne duplique pas les boutons', () => {
    const state = boot();
    window.VH.hangar.viewToggle.init(state);
    expect(document.querySelectorAll('#view-toggle')).toHaveLength(1);
  });

  test('sans barre d\'outils : pas de boutons, mais la vue est appliquée', () => {
    boot('list', { toolbar: false });
    expect(document.getElementById('view-toggle')).toBeNull();
    expect(container().classList.contains('aircraft-list')).toBe(true);
  });

  test('sans conteneur de cartes : rien n\'est créé', () => {
    jest.resetModules();
    document.body.innerHTML = '<div class="toolbar-right"><select id="sort-select"></select></div>';
    window.VH = { hangar: {} };
    require('../js/hangar/view-toggle');
    window.VH.hangar.viewToggle.init({ view: 'grid' });
    expect(document.getElementById('view-toggle')).toBeNull();
  });
});
