/* Favoris — logique pure : recherche, filtres, tri, facettes, statistiques.
 * Aucune lecture du DOM : tout part de `state` (ou de ses morceaux). */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const SEARCH_FIELDS = ['name', 'complete_name', 'country_name', 'little_description'];

  // `search` est déjà en minuscules (voir url.js et la saisie).
  function matchesSearch(a, search) {
    if (!search) return true;
    return SEARCH_FIELDS.some(field => a[field]?.toLowerCase().includes(search));
  }

  /* Vrai si l'appareil passe les filtres, sauf la dimension `except`
   * (null : toutes). La génération se compare en chaîne : nombre dans
   * l'état, nombre ou chaîne dans les données. */
  function matchesFilters(a, filters, except = null) {
    if (except !== 'country' && filters.country && a.country_name !== filters.country) return false;
    if (except !== 'generation' && filters.generation && String(a.generation) !== String(filters.generation)) return false;
    if (except !== 'type' && filters.type && a.type_name !== filters.type) return false;
    return true;
  }

  const SORTERS = {
    recent: (a, b) => new Date(b.favorited_at) - new Date(a.favorited_at),
    alphabetical: (a, b) => a.name.localeCompare(b.name),
    nation: (a, b) => (a.country_name || '').localeCompare(b.country_name || ''),
    generation: (a, b) => (b.generation || 0) - (a.generation || 0),
  };

  /* Copie triée ; un tri inconnu (URL bricolée) garde l'ordre reçu. */
  function sortFavorites(list, sort) {
    const copy = [...list];
    if (Object.prototype.hasOwnProperty.call(SORTERS, sort)) copy.sort(SORTERS[sort]);
    return copy;
  }

  function selectFavorites(state) {
    const kept = state.favorites.filter(a =>
      matchesSearch(a, state.search) && matchesFilters(a, state.filters));
    return sortFavorites(kept, state.sort);
  }

  /* Facettes côté client (leave-one-out) : pour chaque dimension, le nombre
   * de favoris qui correspondraient si l'on remplaçait juste ce filtre. Les
   * options à 0 sont grisées et non cliquables. Même comportement que /hangar. */
  function computeFacets(state) {
    const facets = { countries: {}, generations: {}, types: {} };
    const bump = (bucket, key) => { bucket[key] = (bucket[key] || 0) + 1; };
    state.favorites
      .filter(a => matchesSearch(a, state.search))
      .forEach(a => {
        if (matchesFilters(a, state.filters, 'country') && a.country_name) bump(facets.countries, a.country_name);
        if (matchesFilters(a, state.filters, 'generation') && a.generation != null) bump(facets.generations, a.generation);
        if (matchesFilters(a, state.filters, 'type') && a.type_name) bump(facets.types, a.type_name);
      });
    return facets;
  }

  /* Valeurs distinctes proposées dans les listes de filtres. */
  function filterValues(favorites) {
    const distinct = (key) => [...new Set(favorites.map(a => a[key]).filter(Boolean))];
    return {
      countries: distinct('country_name').sort(),
      generations: distinct('generation').sort((a, b) => a - b),
      types: distinct('type_name').sort(),
    };
  }

  function computeStats(favorites) {
    return {
      total: favorites.length,
      countries: new Set(favorites.map(a => a.country_name).filter(Boolean)).size,
      generations: new Set(favorites.map(a => a.generation).filter(Boolean)).size,
    };
  }

  const api = {
    matchesSearch,
    matchesFilters,
    sortFavorites,
    selectFavorites,
    computeFacets,
    filterValues,
    computeStats,
  };
  window.VH.favorites.filters = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
