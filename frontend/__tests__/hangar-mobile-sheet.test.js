/**
 * Tests — frontend/js/hangar/mobile-sheet.js
 *
 * Feuille de filtres mobile : onglets ARIA (tablist, aria-selected, roving
 * tabindex, flèches/Début/Fin), options échappées avec aria-pressed,
 * application des filtres (URL + chargement), fermeture animée (Échap, voile,
 * bouton) et interception des boutons de filtre sous 768 px seulement.
 *
 * jsdom n'implémente ni showModal() ni close() sur <dialog> : on les simule
 * en posant / retirant l'attribut `open`, ce que fait le navigateur.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

const proto = window.HTMLDialogElement.prototype;
const native = { showModal: proto.showModal, close: proto.close };

let mobile;
let reduced;

function setMatchMedia() {
  window.matchMedia = jest.fn((q) => ({
    matches: q.includes('max-width') ? mobile : (q.includes('reduced-motion') ? reduced : false),
  }));
}

function makeState() {
  return {
    filters: { country: null, generation: null, type: null, war: null, mission: null, search: '' },
    currentPage: 3,
    countries: [{ name: 'Sweden', name_fr: 'Suède' }, { name: '<b>Evil</b>', name_fr: 'Mal"' }],
    generations: [4, 5],
    types: [{ name: 'Fighter', name_fr: 'Chasseur' }],
    wars: [{ name: 'Gulf War', name_fr: 'Guerre du Golfe' }],
    missions: [{ name: 'Interception' }],
  };
}

let state;
let filters;

function boot({ withButtons = true } = {}) {
  jest.resetModules();
  document.body.innerHTML = withButtons
    ? ['country', 'generation', 'type', 'war', 'mission']
      .map(k => `<button id="${k}-filter-btn" class="filter-btn"></button>`).join('')
    : '';
  filters = {
    saveFiltersToSession: jest.fn(),
    applyFiltersAndRender: jest.fn(),
    updateActiveFilters: jest.fn(),
  };
  window.VH = { hangar: { filters } };
  require('../js/hangar/mobile-sheet');
  state = makeState();
  window.VH.hangar.mobileSheet.init(state);
  return document.getElementById('filter-sheet');
}

const tabs = () => Array.from(document.querySelectorAll('.fs-tab'));
const items = () => Array.from(document.querySelectorAll('.filter-sheet-body .fs-item'));
const key = (el, k) => el.dispatchEvent(new KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true }));

beforeEach(() => {
  mobile = true;
  reduced = false;
  setMatchMedia();
  proto.showModal = function () { this.setAttribute('open', ''); };
  proto.close = function () { this.removeAttribute('open'); };
});

afterEach(() => {
  jest.useRealTimers();
  proto.showModal = native.showModal;
  proto.close = native.close;
});

describe('structure et ouverture', () => {
  test('crée un seul <dialog> avec une liste d\'onglets nommée', () => {
    const dlg = boot();
    window.VH.hangar.mobileSheet.init(state);
    expect(document.querySelectorAll('#filter-sheet')).toHaveLength(1);
    expect(dlg.tagName).toBe('DIALOG');
    const list = dlg.querySelector('[role="tablist"]');
    expect(list.getAttribute('aria-label')).toBe('Catégorie de filtres');
    expect(tabs().map(t => t.dataset.tab)).toEqual(['country', 'generation', 'type', 'war', 'mission']);
    expect(dlg.querySelector('.filter-sheet-close').getAttribute('aria-label')).toBe('Fermer');
    expect(dlg.open).toBe(false);
  });

  test('sur mobile, le bouton « Type » ouvre la feuille sur l\'onglet Type et bloque la liste déroulante', () => {
    const dlg = boot();
    const bubbled = jest.fn();
    const btn = document.getElementById('type-filter-btn');
    btn.addEventListener('click', bubbled);
    btn.click();

    expect(dlg.open).toBe(true);
    expect(bubbled).not.toHaveBeenCalled();
    const typeTab = tabs().find(t => t.dataset.tab === 'type');
    expect(typeTab.getAttribute('aria-selected')).toBe('true');
    expect(typeTab.getAttribute('tabindex')).toBe('0');
    expect(tabs().filter(t => t.getAttribute('aria-selected') === 'true')).toHaveLength(1);
    const panel = dlg.querySelector('[role="tabpanel"]');
    expect(panel.id).toBe('fs-panel-type');
    expect(panel.getAttribute('aria-labelledby')).toBe('fs-tab-type');
    expect(items().map(b => b.textContent)).toEqual(['Fighter']);
  });

  test('sur ordinateur, les boutons gardent leur liste déroulante', () => {
    mobile = false;
    const dlg = boot();
    const bubbled = jest.fn();
    document.getElementById('country-filter-btn').addEventListener('click', bubbled);
    document.getElementById('country-filter-btn').click();
    expect(dlg.open).toBe(false);
    expect(bubbled).toHaveBeenCalled();
  });

  test('page sans boutons de filtre : la feuille existe, rien ne casse', () => {
    expect(() => boot({ withButtons: false })).not.toThrow();
    expect(document.getElementById('filter-sheet')).not.toBeNull();
  });

  test('ouvrir une feuille déjà ouverte ne relance pas showModal', () => {
    boot();
    const spy = jest.spyOn(proto, 'showModal');
    document.getElementById('country-filter-btn').click();
    document.getElementById('war-filter-btn').click();
    expect(spy).toHaveBeenCalledTimes(1);
  });

  test('showModal indisponible : la feuille s\'ouvre quand même (attribut open)', () => {
    proto.showModal = function () { throw new Error('InvalidStateError'); };
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    expect(dlg.hasAttribute('open')).toBe(true);
  });
});

describe('options', () => {
  test('noms échappés, valeur = nom FR canonique, aria-pressed suit l\'état', () => {
    boot();
    state.filters.country = 'Suède';
    document.getElementById('country-filter-btn').click();
    const [se, evil] = items();
    expect(document.querySelector('.filter-sheet-body b')).toBeNull();
    expect(evil.textContent).toBe('<b>Evil</b>');
    expect(evil.dataset.key).toBe('Mal"');
    expect(se.dataset.key).toBe('Suède');
    expect(se.getAttribute('aria-pressed')).toBe('true');
    expect(se.classList.contains('active')).toBe(true);
    expect(evil.getAttribute('aria-pressed')).toBe('false');
  });

  test('toucher une option la sélectionne en place (focus conservé), la retoucher la retire', () => {
    boot();
    document.getElementById('war-filter-btn').click();
    const [golfe] = items();
    golfe.focus();
    golfe.click();
    expect(state.filters.war).toBe('Guerre du Golfe');
    expect(golfe.getAttribute('aria-pressed')).toBe('true');
    expect(items()[0]).toBe(golfe);
    expect(document.activeElement).toBe(golfe);

    golfe.click();
    expect(state.filters.war).toBeNull();
    expect(golfe.getAttribute('aria-pressed')).toBe('false');
    expect(golfe.classList.contains('active')).toBe(false);
  });

  test('génération : la valeur est stockée en nombre', () => {
    boot();
    document.getElementById('generation-filter-btn').click();
    expect(items().map(b => b.textContent)).toEqual(['4e Génération', '5e Génération']);
    items()[1].click();
    expect(state.filters.generation).toBe(5);
    expect(items()[0].getAttribute('aria-pressed')).toBe('false');
  });

  test('mission sans name_fr : le nom sert de clé', () => {
    boot();
    document.getElementById('mission-filter-btn').click();
    items()[0].click();
    expect(state.filters.mission).toBe('Interception');
  });

  test('conflits et missions absents du state : onglets vides', () => {
    boot();
    delete state.wars;
    delete state.missions;
    document.getElementById('war-filter-btn').click();
    expect(items()).toHaveLength(0);
    tabs().find(t => t.dataset.tab === 'mission').click();
    expect(items()).toHaveLength(0);
  });
});

describe('navigation au clavier entre onglets', () => {
  test('flèches, Début et Fin déplacent sélection et focus (roving tabindex), en boucle', () => {
    boot();
    const [country, generation, , , mission] = tabs();
    country.focus();

    key(country, 'ArrowRight');
    expect(document.activeElement).toBe(generation);
    expect(generation.getAttribute('aria-selected')).toBe('true');
    expect(generation.getAttribute('tabindex')).toBe('0');
    expect(country.getAttribute('tabindex')).toBe('-1');

    key(generation, 'ArrowLeft');
    expect(document.activeElement).toBe(country);
    key(country, 'ArrowUp');
    expect(document.activeElement).toBe(mission);
    key(mission, 'ArrowDown');
    expect(document.activeElement).toBe(country);
    key(country, 'End');
    expect(document.activeElement).toBe(mission);
    key(mission, 'Home');
    expect(document.activeElement).toBe(country);
    expect(document.querySelector('[role="tabpanel"]').id).toBe('fs-panel-country');
  });

  test('une autre touche est laissée au navigateur', () => {
    boot();
    const [country] = tabs();
    const ev = new KeyboardEvent('keydown', { key: 'Tab', bubbles: true, cancelable: true });
    country.dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(false);
    expect(country.getAttribute('aria-selected')).toBe('true');
  });

  test('cliquer un onglet affiche ses options', () => {
    boot();
    tabs().find(t => t.dataset.tab === 'type').click();
    expect(items().map(b => b.dataset.key)).toEqual(['Chasseur']);
  });
});

describe('appliquer et fermer', () => {
  test('« Appliquer » remet la page 1, sauve (URL + session), recharge et met à jour les pastilles', () => {
    jest.useFakeTimers();
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    items()[0].click();
    dlg.querySelector('#fs-apply').click();

    expect(state.currentPage).toBe(1);
    expect(filters.saveFiltersToSession).toHaveBeenCalledWith(state);
    expect(filters.applyFiltersAndRender).toHaveBeenCalledWith(state);
    expect(filters.updateActiveFilters).toHaveBeenCalledWith(state);
    expect(dlg.classList.contains('is-closing')).toBe(true);
    jest.advanceTimersByTime(250);
    expect(dlg.open).toBe(false);
    expect(dlg.classList.contains('is-closing')).toBe(false);
  });

  test('Échap : fermeture animée, pas la fermeture sèche du navigateur', () => {
    jest.useFakeTimers();
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    const cancel = new Event('cancel', { cancelable: true });
    dlg.dispatchEvent(cancel);
    expect(cancel.defaultPrevented).toBe(true);
    expect(dlg.open).toBe(true);
    expect(dlg.classList.contains('is-closing')).toBe(true);
    // Un second appel pendant l'animation est ignoré
    dlg.querySelector('.filter-sheet-close').click();
    jest.advanceTimersByTime(250);
    expect(dlg.open).toBe(false);
  });

  test('toucher le voile referme ; toucher le panneau non', () => {
    jest.useFakeTimers();
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    dlg.querySelector('.filter-sheet-header').click();
    expect(dlg.classList.contains('is-closing')).toBe(false);
    dlg.click();
    expect(dlg.classList.contains('is-closing')).toBe(true);
  });

  test('mouvements réduits : fermeture immédiate', () => {
    reduced = true;
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    dlg.querySelector('.filter-sheet-close').click();
    expect(dlg.open).toBe(false);
    expect(dlg.classList.contains('is-closing')).toBe(false);
  });

  test('fermer une feuille déjà fermée ne fait rien', () => {
    const dlg = boot();
    dlg.querySelector('.filter-sheet-close').click();
    expect(dlg.classList.contains('is-closing')).toBe(false);
  });

  test('rouvrir pendant l\'animation de fermeture termine la fermeture puis rouvre', () => {
    jest.useFakeTimers();
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    dlg.querySelector('.filter-sheet-close').click();
    document.getElementById('type-filter-btn').click();
    expect(dlg.open).toBe(true);
    expect(dlg.classList.contains('is-closing')).toBe(false);
    jest.advanceTimersByTime(250);
    expect(dlg.open).toBe(true);
  });

  // À TRANCHER (comportement, pas un plantage) — mobile-sheet.js:174-186 : une
  // option touchée modifie state.filters immédiatement. Fermer la feuille
  // sans « Appliquer » (croix, Échap, voile) ne l'annule pas : la sélection
  // n'est ni chargée ni affichée en pastille, mais elle s'appliquera en
  // silence au prochain tri, recherche ou changement de page. On attendrait
  // que la fermeture sans application restaure les filtres d'avant.
  test.skip('fermer sans « Appliquer » abandonne la sélection en cours', () => {
    reduced = true;
    const dlg = boot();
    document.getElementById('country-filter-btn').click();
    items()[0].click();
    dlg.querySelector('.filter-sheet-close').click();
    expect(state.filters.country).toBeNull();
  });
});
