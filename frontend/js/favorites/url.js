/* Favoris — synchronisation état ↔ URL (?country=&gen=&type=&q=&sort=),
 * pour le lien profond et le bouton Précédent. */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const DEFAULT_SORT = 'recent';

  function createState() {
    return {
      favorites: [],
      filtered: [],
      sort: DEFAULT_SORT,
      search: '',
      filters: { country: null, generation: null, type: null },
    };
  }

  /* Remet filtres, recherche et tri à zéro : un paramètre retiré de l'URL
   * doit effacer le filtre correspondant. */
  function resetState(state) {
    state.filters = { country: null, generation: null, type: null };
    state.search = '';
    state.sort = DEFAULT_SORT;
  }

  function readStateFromUrl(state, search = location.search) {
    const p = new URLSearchParams(search);
    if (p.has('country')) state.filters.country    = p.get('country');
    if (p.has('gen'))     state.filters.generation = Number(p.get('gen'));
    if (p.has('type'))    state.filters.type       = p.get('type');
    if (p.has('q'))       state.search             = p.get('q').toLowerCase();
    if (p.has('sort'))    state.sort               = p.get('sort');
  }

  function buildQuery(state) {
    const p = new URLSearchParams();
    if (state.filters.country)    p.set('country', state.filters.country);
    if (state.filters.generation) p.set('gen', String(state.filters.generation));
    if (state.filters.type)       p.set('type', state.filters.type);
    if (state.search)             p.set('q', state.search);
    if (state.sort && state.sort !== DEFAULT_SORT) p.set('sort', state.sort);
    return p.toString();
  }

  function writeStateToUrl(state) {
    const qs = buildQuery(state);
    const url = qs ? `${location.pathname}?${qs}` : location.pathname;
    try { history.replaceState(null, '', url); } catch { /* ignore */ }
  }

  /* Recopie l'état dans les contrôles de la barre d'outils. */
  function syncControls(state) {
    const searchInput = document.getElementById('search-input');
    const sortSelect = document.getElementById('sort-select');
    if (searchInput) searchInput.value = state.search;
    if (sortSelect) sortSelect.value = state.sort;
  }

  function bindHistory(state) {
    window.addEventListener('popstate', () => {
      resetState(state);
      readStateFromUrl(state);
      syncControls(state);
      VH.favorites.render.applyFiltersAndRender(state);
      VH.favorites.toolbar.updateActiveFilters(state);
    });
  }

  const api = {
    DEFAULT_SORT,
    createState,
    resetState,
    readStateFromUrl,
    buildQuery,
    writeStateToUrl,
    bindHistory,
  };
  window.VH.favorites.url = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
