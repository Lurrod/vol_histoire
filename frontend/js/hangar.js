/* Hangar — orchestrateur.
 * Crée le state, appelle les modules VH.hangar.* dans l'ordre.
 * Modules chargés avant ce fichier via <script defer> dans hangar.html.
 */
document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  const state = {
    aircraft: [],
    total: 0,
    currentPage: 1,
    itemsPerPage: 6,
    filters: { country: null, generation: null, type: null, search: '' },
    sort: 'default',
    countries: [],
    generations: [],
    types: [],
    manufacturers: [],
    facets: null,
    view: localStorage.getItem('vh_hangar_view') || 'grid',
    compareIds: JSON.parse(localStorage.getItem('vh_compare_ids') || '[]'),
  };

  nav.updateAuthUI();

  // Afficher le bouton d'ajout pour admin/editeur
  const payload = auth.getPayload();
  if (payload) {
    const userRole = Number(payload.role);
    if (userRole === 1 || userRole === 2) {
      document.getElementById('add-airplane-btn')?.classList.remove('hidden');
    }
  }

  // Initialiser les sous-modules
  VH.hangar.filters.setupDropdowns(state);
  VH.hangar.filters.setupSearchAndSort(state);
  VH.hangar.admin.setupAdminModal(state);

  // Restauration session → URL (URL prioritaire) — appliquées AVANT le premier
  // loadAircraft pour éviter un double appel /api/airplanes au boot.
  VH.hangar.filters.restoreFiltersFromSession(state);
  VH.hangar.filters.readStateFromUrl(state);
  const searchInput = document.getElementById('search-input');
  const sortSelect = document.getElementById('sort-select');
  if (searchInput && state.filters.search) searchInput.value = state.filters.search;
  if (sortSelect && state.sort !== 'default') sortSelect.value = state.sort;

  await VH.hangar.data.loadReferentialData(state);
  await VH.hangar.data.loadAircraft(state);

  VH.hangar.filters.updateActiveFilters(state);

  // Observer pour animations d'entrée
  const cardObserver = setInterval(() => {
    if (document.querySelectorAll('.aircraft-card').length > 0) {
      VH.hangar.render.observeCards();
      clearInterval(cardObserver);
    }
  }, 100);

  // Re-render sur changement de langue
  window.addEventListener('langChanged', () => {
    VH.hangar.render.updateResultsCount(state);
    if (state.aircraft.length > 0) VH.hangar.render.renderAircraft(state);
  });

  // V2 : URL state (override session)
  VH.hangar.filters.readStateFromUrl(state);
  if (searchInput && state.filters.search) searchInput.value = state.filters.search;
  if (sortSelect) sortSelect.value = state.sort;
  VH.hangar.filters.applyFiltersAndRender(state);
  VH.hangar.filters.updateActiveFilters(state);

  // V2 : facettes, vue, comparaison, sheet mobile
  VH.hangar.data.fetchFacets(state);
  VH.hangar.viewToggle.init(state);
  VH.hangar.compare.init(state);
  VH.hangar.mobileSheet.init(state);

  // Raccourcis clavier
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      VH.hangar.admin.closeModal();
      VH.hangar.filters.closeAllDropdowns();
    }
    if (e.key === '/' && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      searchInput?.focus();
    }
  });

  // Swipe up → ferme le menu mobile
  let touchStartY = 0;
  document.addEventListener('touchstart', (e) => {
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });
  document.addEventListener('touchend', (e) => {
    const touchEndY = e.changedTouches[0].screenY;
    if (touchStartY - touchEndY > 100 && document.querySelector('.nav-links')?.classList.contains('show')) {
      nav.closeMenu();
    }
  }, { passive: true });
});
