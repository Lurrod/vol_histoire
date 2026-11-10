/* Favoris — orchestrateur.
 * Barrière d'authentification, état, puis modules VH.favorites.* (filters,
 * url, render, remove, data, dropdowns, toolbar), concaténés avant ce
 * fichier dans favorites.min.js (scripts/build-js.js).
 * ALPHA3_TO_ALPHA2 fourni par js/shared/alpha3.js — chargé avant ce script.
 * escapeHtml, showToast, animateNumber → utils.js | navigation → nav.js */

document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  const F = VH.favorites;
  const currentUser = auth.getPayload();
  const authGate = document.getElementById('auth-gate');
  const favoritesContent = document.getElementById('favorites-content');

  if (!auth.getToken() || !currentUser) {
    // Non connecté : barrière visible, favoris masqués
    authGate?.classList.remove('hidden');
    favoritesContent?.classList.add('hidden');
    document.querySelector('.page-hero')?.classList.add('hidden');
    return;
  }

  authGate?.classList.add('hidden');
  favoritesContent?.classList.remove('hidden');

  const state = F.url.createState();
  const searchInput = document.getElementById('search-input');
  const sortSelect = document.getElementById('sort-select');

  F.url.bindHistory(state);
  F.toolbar.setupSearchAndSort(state);
  F.dropdowns.setupDropdowns();

  // Raccourci clavier : « / » place le curseur dans la recherche
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      searchInput?.focus();
    }
  });

  // Lire l'état depuis l'URL avant le premier load (permet le deep-linking)
  F.url.readStateFromUrl(state);
  if (searchInput && state.search) searchInput.value = state.search;
  if (sortSelect) sortSelect.value = state.sort;

  await F.data.loadFavorites(state);

  // Afficher les filtres actifs restaurés depuis l'URL
  F.toolbar.updateActiveFilters(state);

  // Re-render on language change
  window.addEventListener('langChanged', () => {
    F.render.updateResultsCount(state);
    F.render.renderFavorites(state);
  });
});
