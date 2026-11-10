/**
 * Tests DOM — frontend/js/favorites/{toolbar,dropdowns,render,remove,data,url}.js
 * et favorites.js : barre de filtres, listes déroulantes, grille, retrait
 * avec annulation, chargement, retour arrière et démarrage de la page.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { currentLang: 'fr', t: (key, params) => (params ? `${key}:${JSON.stringify(params)}` : key) };
global.showToast = jest.fn();
global.animateNumber = jest.fn((el, n) => { if (el) el.textContent = String(n); });

window.VH = {
  shared: {
    buildDetailsPath: jest.fn((id, name) => `/details/${name}-${id}`),
    renderAircraftCard: (a, opts) => `
      <article class="aircraft-card" data-id="${a.id}">
        ${opts.removeBtn ? `<button class="favorite-remove" data-airplane-id="${a.id}"></button>` : ''}
        <h3><a class="aircraft-card-link" href="/details/${a.id}">${escapeHtml(a.name)}</a></h3>
        ${opts.footerHtml}
      </article>`,
  },
};

const PAGE_HTML = `
  <section class="page-hero"></section>
  <section id="auth-gate" class="hidden"></section>
  <section id="favorites-content" class="hidden">
    <input id="search-input">
    <select id="sort-select">
      <option value="recent">r</option><option value="alphabetical">a</option>
      <option value="nation">n</option><option value="generation">g</option>
    </select>
    ${['country', 'generation', 'type'].map(k => `
      <button type="button" class="filter-btn" id="${k}-filter-btn" aria-expanded="false"></button>
      <div id="${k}-dropdown" class="filter-dropdown hidden">
        <button type="button" class="close-dropdown"></button>
        <div class="filter-options" id="${k}-options"></div>
      </div>`).join('')}
    <div id="active-filters" class="active-filters hidden"></div>
    <span id="results-count"></span>
    <section id="favorites-container"></section>
    <div id="empty-state" class="hidden"></div>
  </section>
  <span id="total-favorites"></span><span id="total-countries"></span><span id="total-generations"></span>
  <div id="toast-container"></div>`;

const FAVS = [
  { id: 1, name: 'Rafale', country_name: 'France', generation: 4, type_name: 'Chasseur', favorited_at: '2026-01-03' },
  { id: 2, name: 'F-22 Raptor', country_name: 'États-Unis', generation: 5, type_name: 'Chasseur', favorited_at: '2026-01-05' },
  { id: 3, name: 'Mirage IV', country_name: 'France', generation: 2, type_name: 'Bombardier', favorited_at: '2026-01-01' },
];

/* Charge les modules à neuf (écouteurs document compris) sur une page neuve. */
function loadModules() {
  jest.resetModules();
  document.body.innerHTML = PAGE_HTML;
  const F = {
    filters: require('../js/favorites/filters'),
    url: require('../js/favorites/url'),
    render: require('../js/favorites/render'),
    remove: require('../js/favorites/remove'),
    data: require('../js/favorites/data'),
    dropdowns: require('../js/favorites/dropdowns'),
    toolbar: require('../js/favorites/toolbar'),
  };
  return F;
}

function makeState(F, favorites = FAVS) {
  const state = F.url.createState();
  state.favorites = favorites.map(a => ({ ...a }));
  return state;
}

function okJson(body) {
  return Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve(body) });
}

beforeEach(() => {
  window.history.replaceState(null, '', '/favorites');
  showToast.mockClear();
  global.animateNumber.mockClear();
  global.auth = {
    authFetch: jest.fn(() => okJson(FAVS)),
    clearSession: jest.fn(),
  };
});

afterEach(() => {
  jest.useRealTimers();
});

describe('render', () => {
  test('squelettes : six cartes, conteneur visible', () => {
    const F = loadModules();
    document.getElementById('favorites-container').classList.add('hidden');
    F.render.renderSkeletons();
    expect(document.querySelectorAll('.skeleton-card')).toHaveLength(6);
    expect(document.getElementById('favorites-container').classList.contains('hidden')).toBe(false);
    document.body.innerHTML = '';
    expect(() => F.render.renderSkeletons()).not.toThrow();
  });

  test('aucun favori : état vide de la page', () => {
    const F = loadModules();
    const state = makeState(F, []);
    F.render.applyFiltersAndRender(state);
    expect(document.getElementById('favorites-container').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('empty-state').classList.contains('hidden')).toBe(false);
    expect(document.getElementById('results-count').textContent).toBe('favorites.results_none');
  });

  test('filtre sans résultat : message dans la grille', () => {
    const F = loadModules();
    const state = makeState(F);
    state.search = 'zzz';
    F.render.applyFiltersAndRender(state);
    expect(document.querySelector('#favorites-container .empty-state h3').textContent).toBe('Aucun résultat');
    expect(document.getElementById('empty-state').classList.contains('hidden')).toBe(true);
  });

  test('cartes triées, date relative en pied, compteur', () => {
    const F = loadModules();
    const state = makeState(F);
    F.render.applyFiltersAndRender(state);
    const cards = document.querySelectorAll('.aircraft-card');
    expect([...cards].map(c => c.dataset.id)).toEqual(['2', '1', '3']);
    expect(cards[0].querySelector('.favorited-date span').textContent).toMatch(/^favorites\./);
    expect(document.getElementById('results-count').textContent).toBe('favorites.results:{"count":3}');
    state.filtered = [FAVS[0]];
    F.render.updateResultsCount(state);
    expect(document.getElementById('results-count').textContent).toBe('favorites.results_one');
  });

  test('la carte ne porte plus de gestionnaire de navigation : le lien du titre suffit', () => {
    const F = loadModules();
    const state = makeState(F);
    const spy = jest.spyOn(HTMLElement.prototype, 'addEventListener');
    F.render.applyFiltersAndRender(state);
    const bound = spy.mock.contexts.map(el => el.className);
    spy.mockRestore();
    expect(bound).not.toContain('aircraft-card');
    expect(bound.filter(c => c === 'favorite-remove')).toHaveLength(3);

    const nav = jest.fn();
    document.addEventListener('click', nav);
    document.querySelector('.aircraft-card').click(); // clic hors lien : rien
    expect(window.VH.shared.buildDetailsPath).not.toHaveBeenCalled();
    document.removeEventListener('click', nav);
    expect(nav).toHaveBeenCalledTimes(1);
  });

  test('le bouton de retrait déclenche le retrait sans remonter le clic', () => {
    const F = loadModules();
    const state = makeState(F);
    F.render.applyFiltersAndRender(state);
    const remove = jest.spyOn(F.remove, 'removeWithUndo').mockImplementation(() => {});
    const bubbled = jest.fn();
    document.addEventListener('click', bubbled);
    document.querySelector('.favorite-remove').click();
    document.removeEventListener('click', bubbled);
    expect(remove).toHaveBeenCalledWith(state, document.querySelector('.favorite-remove'));
    expect(bubbled).not.toHaveBeenCalled();
  });
});

describe('toolbar', () => {
  function setup() {
    const F = loadModules();
    const state = makeState(F);
    F.toolbar.populateFilterOptions(state);
    F.render.applyFiltersAndRender(state);
    return { F, state };
  }
  const option = (key, value) => document.querySelector(`#${key}-options .filter-option[data-value="${value}"]`);

  test('options : valeurs distinctes, libellé de génération, compteurs', () => {
    setup();
    expect([...document.querySelectorAll('#country-options .filter-option')].map(o => o.dataset.value)).toEqual(['France', 'États-Unis']);
    expect(option('generation', '4').firstChild.textContent).toBe('4e Génération');
    expect(option('country', 'France').querySelector('.fc').textContent).toBe(' (2)');
    expect(option('type', 'Bombardier').getAttribute('aria-pressed')).toBe('false');
  });

  test('choisir une option filtre, écrit l\'URL, affiche le filtre actif ; re-cliquer l\'enlève', () => {
    jest.useFakeTimers();
    const { state } = setup();
    option('generation', '4').click();
    expect(state.filters.generation).toBe(4);
    expect(window.location.search).toBe('?gen=4');
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(1);
    expect(option('generation', '4').classList.contains('selected')).toBe(true);
    expect(option('generation', '4').getAttribute('aria-pressed')).toBe('true');
    expect(document.getElementById('generation-filter-btn').classList.contains('has-value')).toBe(true);
    expect(document.querySelector('.active-filter span').textContent).toBe('4e Génération');
    // Facettes leave-one-out : les autres pays restent comptés sous ce filtre
    expect(option('country', 'États-Unis').classList.contains('filter-option-empty')).toBe(true);
    option('generation', '4').click();
    expect(state.filters.generation).toBeNull();
    expect(document.getElementById('active-filters').classList.contains('hidden')).toBe(true);
  });

  test('une option grisée ne fait rien', () => {
    const { state } = setup();
    option('country', 'France').click();
    expect(option('country', 'États-Unis').classList.contains('filter-option-empty')).toBe(false);
    state.search = 'rafale';
    const { decorateFacetCounts } = window.VH.favorites.toolbar;
    decorateFacetCounts(state);
    expect(option('type', 'Bombardier').classList.contains('filter-option-empty')).toBe(true);
    option('type', 'Bombardier').click();
    expect(state.filters.type).toBeNull();
  });

  test('retirer un filtre actif, puis tout effacer', () => {
    const { F, state } = setup();
    state.filters = { country: 'France', generation: 4, type: 'Chasseur' };
    F.toolbar.updateActiveFilters(state);
    expect([...document.querySelectorAll('.active-filter')].map(f => f.dataset.type)).toEqual(['country', 'generation', 'type']);
    document.querySelector('.remove-filter-btn[data-filter-type="type"]').click();
    expect(state.filters.type).toBeNull();
    expect(window.location.search).toBe('?country=France&gen=4');
    document.querySelector('.clear-all-filters').click();
    expect(state.filters).toEqual({ country: null, generation: null, type: null });
    expect(window.location.search).toBe('');
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(3);
  });

  test('activeFilterList dans l\'ordre pays, génération, type', () => {
    const { F } = setup();
    expect(F.toolbar.activeFilterList({ country: null, generation: 2, type: 'X' })).toEqual([
      { type: 'generation', label: '2e Génération' }, { type: 'type', label: 'X' },
    ]);
  });

  test('recherche et tri', () => {
    const { F, state } = setup();
    F.toolbar.setupSearchAndSort(state);
    const input = document.getElementById('search-input');
    input.value = 'MIRAGE';
    input.dispatchEvent(new Event('input'));
    expect(state.search).toBe('mirage');
    expect(window.location.search).toBe('?q=mirage');
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(1);
    expect(option('country', 'États-Unis').querySelector('.fc').textContent).toBe(' (0)');

    input.value = '';
    input.dispatchEvent(new Event('input'));
    const select = document.getElementById('sort-select');
    select.value = 'alphabetical';
    select.dispatchEvent(new Event('change'));
    expect(state.sort).toBe('alphabetical');
    expect(window.location.search).toBe('?sort=alphabetical');
    expect(document.querySelector('.aircraft-card h3').textContent).toBe('F-22 Raptor');
  });
});

describe('dropdowns', () => {
  test('ouvrir, refermer par le bouton, la croix ou un clic extérieur', () => {
    jest.useFakeTimers();
    const F = loadModules();
    F.dropdowns.setupDropdowns();
    const btn = document.getElementById('country-filter-btn');
    const dd = document.getElementById('country-dropdown');

    btn.click();
    expect(dd.classList.contains('hidden')).toBe(false);
    expect(btn.getAttribute('aria-expanded')).toBe('true');
    jest.advanceTimersByTime(10);
    expect(dd.classList.contains('show')).toBe(true);

    btn.click(); // deuxième clic : fermeture
    expect(dd.classList.contains('show')).toBe(false);
    expect(btn.getAttribute('aria-expanded')).toBe('false');
    jest.advanceTimersByTime(300);
    expect(dd.classList.contains('hidden')).toBe(true);

    btn.click();
    jest.advanceTimersByTime(10);
    dd.querySelector('.close-dropdown').click();
    expect(dd.classList.contains('show')).toBe(false);

    btn.click();
    jest.advanceTimersByTime(10);
    dd.click(); // clic dans la liste : reste ouverte
    expect(dd.classList.contains('show')).toBe(true);
    document.body.click();
    expect(dd.classList.contains('show')).toBe(false);
  });

  test('rouvrir pendant la fermeture annule le masquage programmé', () => {
    jest.useFakeTimers();
    const F = loadModules();
    F.dropdowns.setupDropdowns();
    const btn = document.getElementById('type-filter-btn');
    const dd = document.getElementById('type-dropdown');
    btn.click();
    jest.advanceTimersByTime(10);
    F.dropdowns.closeAllDropdowns();
    btn.click();
    jest.advanceTimersByTime(400);
    expect(dd.classList.contains('hidden')).toBe(false);
    expect(dd.classList.contains('show')).toBe(true);
  });
});

describe('remove', () => {
  function setup() {
    const F = loadModules();
    const state = makeState(F);
    F.toolbar.populateFilterOptions(state);
    F.render.applyFiltersAndRender(state);
    return { F, state };
  }
  const removeBtn = (id) => document.querySelector(`.favorite-remove[data-airplane-id="${id}"]`);

  test('retrait optimiste, puis DELETE après 5 s', async () => {
    jest.useFakeTimers();
    const { state } = setup();
    auth.authFetch.mockImplementation(() => Promise.resolve({ ok: true }));
    removeBtn(1).click();
    expect(state.favorites.map(a => a.id)).toEqual([2, 3]);
    expect(document.getElementById('results-count').textContent).toBe('favorites.results:{"count":2}');
    const card = removeBtn(1).closest('.aircraft-card');
    expect(card.classList.contains('is-removing')).toBe(true);
    expect(card.getAttribute('aria-hidden')).toBe('true');
    expect(document.querySelector('.toast .toast-msg').textContent).toBe('favorites.removed');

    removeBtn(1).click(); // déjà en attente : ignoré
    expect(document.querySelectorAll('.toast')).toHaveLength(1);

    jest.advanceTimersByTime(300);
    expect(card.classList.contains('is-removed')).toBe(true);
    await jest.advanceTimersByTimeAsync(4700);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/favorites/1', { method: 'DELETE' });
    expect(document.getElementById('total-favorites').textContent).toBe('2');
    jest.advanceTimersByTime(300);
    expect(document.querySelector('.toast')).toBeNull();
  });

  test('« Annuler » restaure l\'appareil et aucun DELETE ne part', async () => {
    jest.useFakeTimers();
    const { state } = setup();
    removeBtn(3).click();
    document.querySelector('.toast-undo-btn').click();
    expect(state.favorites.map(a => a.id).sort()).toEqual([1, 2, 3]);
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(3);
    await jest.advanceTimersByTimeAsync(6000);
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('échec du DELETE : restauration et toast d\'erreur', async () => {
    jest.useFakeTimers();
    const { state } = setup();
    auth.authFetch.mockImplementation(() => Promise.resolve({ ok: false }));
    removeBtn(2).click();
    await jest.advanceTimersByTimeAsync(5000);
    expect(state.favorites.some(a => a.id === 2)).toBe(true);
    expect(showToast).toHaveBeenCalledWith('common.error', 'error');
  });

  test('dernière carte affichée : nouveau rendu vers l\'état « aucun résultat »', () => {
    jest.useFakeTimers();
    const { F, state } = setup();
    state.search = 'rafale';
    F.render.applyFiltersAndRender(state);
    removeBtn(1).click();
    jest.advanceTimersByTime(300);
    expect(document.querySelector('#favorites-container .empty-state')).not.toBeNull();
  });

  test('carte en cours de retrait : inert, hors du parcours clavier', () => {
    jest.useFakeTimers();
    setup();
    const card = removeBtn(1).closest('.aircraft-card');
    removeBtn(1).click();
    expect(card.inert).toBe(true);
    expect(card.hasAttribute('tabindex')).toBe(false);
  });

  test('focus clavier reporté sur le lien de la carte voisine', () => {
    jest.useFakeTimers();
    setup();
    removeBtn(2).focus();
    removeBtn(2).click();
    jest.advanceTimersByTime(300);
    expect(document.activeElement.classList.contains('aircraft-card-link')).toBe(true);
    expect(document.activeElement.closest('.aircraft-card').dataset.id).toBe('1');
  });

  test('focus reporté même si le navigateur retire le focus du bouton désactivé', () => {
    // Chrome retire le focus d'un bouton dès qu'il passe disabled : le focus
    // doit donc être relevé AVANT de désactiver le bouton.
    jest.useFakeTimers();
    setup();
    const btn = removeBtn(2);
    Object.defineProperty(btn, 'disabled', {
      configurable: true,
      get() { return this.hasAttribute('disabled'); },
      set(v) { if (v) { this.blur(); this.setAttribute('disabled', ''); } else this.removeAttribute('disabled'); },
    });
    btn.focus();
    btn.click();
    expect(document.activeElement).not.toBe(btn); // focus perdu, comme dans Chrome
    jest.advanceTimersByTime(300);
    expect(document.activeElement.classList.contains('aircraft-card-link')).toBe(true);
    expect(document.activeElement.closest('.aircraft-card').dataset.id).toBe('1');
  });

  test('focus hors de la carte retirée : on n\'y touche pas', () => {
    jest.useFakeTimers();
    setup();
    const input = document.getElementById('search-input');
    input.focus();
    removeBtn(2).click();
    jest.advanceTimersByTime(300);
    expect(document.activeElement).toBe(input);
  });

  test('id inconnu : rien ne se passe ; collapseCard sans carte non plus', () => {
    const { F, state } = setup();
    const btn = document.createElement('button');
    btn.dataset.airplaneId = '999';
    F.remove.removeWithUndo(state, btn);
    expect(btn.disabled).toBe(false);
    expect(() => F.render.collapseCard(state, null)).not.toThrow();
  });

  test('carte remplacée avant la fin de la transition : rien à faire', () => {
    jest.useFakeTimers();
    const { F, state } = setup();
    const card = document.querySelector('.aircraft-card');
    F.render.collapseCard(state, card);
    F.render.renderFavorites(state);
    jest.advanceTimersByTime(300);
    expect(card.classList.contains('is-removed')).toBe(false);
  });

  test('showUndoToast.cancel ferme le toast', () => {
    jest.useFakeTimers();
    const F = loadModules();
    const handle = F.remove.showUndoToast('<b>x</b>', jest.fn());
    expect(document.querySelector('.toast-msg').textContent).toBe('<b>x</b>');
    handle.cancel();
    jest.advanceTimersByTime(300);
    expect(document.querySelector('.toast')).toBeNull();
  });
});

describe('data', () => {
  test('chargement : options, cartes, statistiques', async () => {
    const F = loadModules();
    const state = makeState(F, []);
    await F.data.loadFavorites(state);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/favorites');
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(3);
    expect(document.querySelectorAll('#type-options .filter-option')).toHaveLength(2);
    expect(document.getElementById('total-countries').textContent).toBe('2');
    expect(document.getElementById('total-generations').textContent).toBe('3');
  });

  test('réponse non tableau : liste vide', async () => {
    const F = loadModules();
    auth.authFetch.mockImplementation(() => okJson({ error: 'x' }));
    const state = makeState(F, []);
    await F.data.loadFavorites(state);
    expect(state.favorites).toEqual([]);
    expect(document.getElementById('empty-state').classList.contains('hidden')).toBe(false);
  });

  test('session expirée : toast, session effacée, redirection programmée', async () => {
    jest.useFakeTimers();
    const F = loadModules();
    auth.authFetch.mockImplementation(() => Promise.resolve({ ok: false, status: 401 }));
    await F.data.loadFavorites(makeState(F, []));
    expect(showToast).toHaveBeenCalledWith('common.session_expired', 'error');
    expect(auth.clearSession).toHaveBeenCalled();
    expect(jest.getTimerCount()).toBe(1);
  });

  test('erreur serveur : toast de chargement', async () => {
    const F = loadModules();
    auth.authFetch.mockImplementation(() => Promise.resolve({ ok: false, status: 500 }));
    await F.data.loadFavorites(makeState(F, []));
    expect(showToast).toHaveBeenCalledWith('common.loading_error', 'error');
  });
});

describe('url.bindHistory', () => {
  test('retour arrière : état relu depuis l\'URL, contrôles et rendu à jour', () => {
    const F = loadModules();
    const state = makeState(F);
    state.filters.country = 'France';
    F.url.bindHistory(state);
    window.history.replaceState(null, '', '/favorites?q=raptor&sort=nation');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(state.filters.country).toBeNull();
    expect(state.search).toBe('raptor');
    expect(document.getElementById('search-input').value).toBe('raptor');
    expect(document.getElementById('sort-select').value).toBe('nation');
    expect(document.querySelectorAll('.aircraft-card')).toHaveLength(1);
  });
});

describe('favorites.js — démarrage', () => {
  async function boot({ token = 'jwt', payload = { id: 1 }, search = '' } = {}) {
    loadModules();
    window.history.replaceState(null, '', `/favorites${search}`);
    global.auth = {
      init: jest.fn(() => Promise.resolve()),
      getToken: () => token,
      getPayload: () => payload,
      authFetch: jest.fn(() => okJson(FAVS)),
      clearSession: jest.fn(),
    };
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/favorites');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
  }

  test('non connecté : barrière visible, aucun appel API', async () => {
    await boot({ token: null });
    expect(document.getElementById('auth-gate').classList.contains('hidden')).toBe(false);
    expect(document.getElementById('favorites-content').classList.contains('hidden')).toBe(true);
    expect(document.querySelector('.page-hero').classList.contains('hidden')).toBe(true);
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('connecté : état de l\'URL appliqué au premier rendu', async () => {
    await boot({ search: '?country=France&sort=alphabetical&q=r' });
    expect(document.getElementById('auth-gate').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('favorites-content').classList.contains('hidden')).toBe(false);
    expect(document.getElementById('search-input').value).toBe('r');
    expect(document.getElementById('sort-select').value).toBe('alphabetical');
    expect([...document.querySelectorAll('.aircraft-card h3')].map(h => h.textContent)).toEqual(['Mirage IV', 'Rafale']);
    expect(document.querySelector('.active-filter span').textContent).toBe('France');
  });

  test('« / » donne le focus à la recherche ; changement de langue : nouveau rendu', async () => {
    await boot();
    const e = new KeyboardEvent('keydown', { key: '/', cancelable: true });
    document.dispatchEvent(e);
    expect(e.defaultPrevented).toBe(true);
    expect(document.activeElement.id).toBe('search-input');
    const before = document.querySelector('.aircraft-card');
    window.dispatchEvent(new Event('langChanged'));
    expect(document.querySelector('.aircraft-card')).not.toBe(before);
  });
});
