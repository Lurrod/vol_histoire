/**
 * Tests — frontend/js/hangar/nations-map-filter.js
 *
 * Le bouton « Carte » du hangar déplie le planisphère (aria-expanded,
 * .active, transition puis .hidden), le premier dépliage monte la carte en
 * mode filtre ; cliquer un pays pose ?country= (nom FR canonique), recliquer
 * le retire, et le focus revient au bouton. Échap referme.
 */

let filters;
let data;
let mount;
let onSelect;
let state;

function boot({ mountResult = true, withMap = true, withActive = true } = {}) {
  jest.resetModules();
  document.body.innerHTML = `
    <button id="map-filter-btn" aria-expanded="false" aria-controls="nations-map-panel">Carte</button>
    <section id="nations-map-panel" class="nations-map-panel hidden">
      <svg><path class="wm-nation wm-nation-active" data-name-fr="France"></path>
      <path class="wm-nation wm-nation-active" data-name-fr="Suède"></path></svg>
    </section>
    ${withActive ? '<div id="active-filters"></div>' : ''}`;
  filters = { saveFiltersToSession: jest.fn(), updateActiveFilters: jest.fn(), closeAllDropdowns: jest.fn() };
  data = { loadAircraft: jest.fn() };
  mount = jest.fn((root, opts) => { onSelect = opts.onSelect; return Promise.resolve(mountResult); });
  window.VH = { hangar: { filters, data } };
  if (withMap) window.VH.nationsMap = { mount };
  require('../js/hangar/nations-map-filter');
  state = { filters: { country: null }, currentPage: 4 };
  window.VH.hangar.nationsMapFilter.init(state);
}

const btn = () => document.getElementById('map-filter-btn');
const panel = () => document.getElementById('nations-map-panel');
const path = (name) => panel().querySelector(`[data-name-fr="${name}"]`);
const flush = () => new Promise(r => setTimeout(r, 0));

beforeEach(() => { jest.useFakeTimers(); });
afterEach(() => { jest.useRealTimers(); });

describe('ouverture et fermeture du panneau', () => {
  test('ouvrir : panneau visible, aria-expanded="true", bouton actif, listes fermées, carte montée en mode filtre', () => {
    boot();
    btn().click();
    expect(panel().classList.contains('hidden')).toBe(false);
    expect(panel().classList.contains('is-open')).toBe(true);
    expect(btn().getAttribute('aria-expanded')).toBe('true');
    expect(btn().classList.contains('active')).toBe(true);
    expect(filters.closeAllDropdowns).toHaveBeenCalled();
    expect(mount).toHaveBeenCalledWith(panel(), { onSelect: expect.any(Function) });
  });

  test('recliquer referme, puis masque après la transition', () => {
    boot();
    btn().click();
    btn().click();
    expect(panel().classList.contains('is-open')).toBe(false);
    expect(btn().getAttribute('aria-expanded')).toBe('false');
    expect(btn().classList.contains('active')).toBe(false);
    expect(panel().classList.contains('hidden')).toBe(false);
    jest.advanceTimersByTime(260);
    expect(panel().classList.contains('hidden')).toBe(true);
  });

  test('rouvrir pendant la transition annule le masquage', () => {
    boot();
    btn().click();
    btn().click();
    jest.advanceTimersByTime(100);
    btn().click();
    jest.advanceTimersByTime(300);
    expect(panel().classList.contains('hidden')).toBe(false);
    expect(panel().classList.contains('is-open')).toBe(true);
  });

  test('Échap referme le panneau ouvert et rend le focus au bouton', () => {
    boot();
    btn().click();
    document.body.focus();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    expect(btn().getAttribute('aria-expanded')).toBe('false');
    expect(document.activeElement).toBe(btn());
  });

  test('Échap panneau fermé, ou autre touche : rien ne change', () => {
    boot();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    expect(btn().getAttribute('aria-expanded')).toBe('false');
    btn().click();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter' }));
    expect(btn().getAttribute('aria-expanded')).toBe('true');
  });

  test('le clic sur le bouton ne remonte pas (le « clic dehors » des listes ne s\'en mêle pas)', () => {
    boot();
    const outside = jest.fn();
    document.body.addEventListener('click', outside);
    btn().click();
    expect(outside).not.toHaveBeenCalled();
    document.body.removeEventListener('click', outside);
  });
});

describe('sélection d\'un pays', () => {
  test('le pays du filtre courant est surligné une fois la carte montée', async () => {
    boot();
    state.filters.country = 'Suède';
    jest.useRealTimers();
    btn().click();
    await flush();
    expect(path('Suède').classList.contains('is-selected')).toBe(true);
    expect(path('France').classList.contains('is-selected')).toBe(false);
  });

  test('carte en échec : pas de surlignage tenté', async () => {
    boot({ mountResult: false });
    state.filters.country = 'Suède';
    jest.useRealTimers();
    btn().click();
    await flush();
    expect(path('Suède').classList.contains('is-selected')).toBe(false);
  });

  test('cliquer un pays filtre sur son nom FR, page 1, sauve, recharge, referme et rend le focus', () => {
    boot();
    btn().click();
    onSelect({ code: 'SWE', name: 'Sweden', nameFr: 'Suède', count: 12 });
    expect(state.filters.country).toBe('Suède');
    expect(state.currentPage).toBe(1);
    expect(filters.saveFiltersToSession).toHaveBeenCalledWith(state);
    expect(filters.updateActiveFilters).toHaveBeenCalledWith(state);
    expect(data.loadAircraft).toHaveBeenCalledWith(state);
    expect(path('Suède').classList.contains('is-selected')).toBe(true);
    expect(btn().getAttribute('aria-expanded')).toBe('false');
    expect(document.activeElement).toBe(btn());
  });

  test('recliquer le pays déjà filtré retire le filtre', () => {
    boot();
    state.filters.country = 'France';
    btn().click();
    onSelect({ nameFr: 'France' });
    expect(state.filters.country).toBeNull();
    expect(path('France').classList.contains('is-selected')).toBe(false);
  });

  test('un filtre posé ailleurs (liste, « Effacer tout ») se reflète sur la carte via #active-filters', async () => {
    jest.useRealTimers();
    boot();
    state.filters.country = 'France';
    document.getElementById('active-filters').innerHTML = '<span>France</span>';
    await flush();
    expect(path('France').classList.contains('is-selected')).toBe(true);
  });
});

describe('montage conditionnel', () => {
  test('sans module de carte, le bouton reste inerte', () => {
    boot({ withMap: false });
    btn().click();
    expect(btn().getAttribute('aria-expanded')).toBe('false');
    expect(panel().classList.contains('hidden')).toBe(true);
  });

  test('sans bandeau de filtres actifs : pas d\'observateur, pas d\'erreur', () => {
    expect(() => boot({ withActive: false })).not.toThrow();
  });

  test('sans panneau dans la page : rien n\'est branché', () => {
    jest.resetModules();
    document.body.innerHTML = '<button id="map-filter-btn"></button>';
    window.VH = { hangar: {}, nationsMap: { mount: jest.fn() } };
    require('../js/hangar/nations-map-filter');
    window.VH.hangar.nationsMapFilter.init({ filters: {} });
    document.getElementById('map-filter-btn').click();
    expect(window.VH.nationsMap.mount).not.toHaveBeenCalled();
  });
});
