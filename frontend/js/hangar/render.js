/* Rendu des cartes + pagination + stats. Délègue le template à VH.shared.renderAircraftCard. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function renderSkeletons() {
    const container = document.getElementById('airplanes-container');
    if (!container) return;
    container.innerHTML = Array.from({ length: 6 }).map(() => `
      <div class="skeleton-card">
        <div class="skeleton-image"></div>
        <div class="skeleton-content">
          <div class="skeleton-line medium"></div>
          <div class="skeleton-line short"></div>
          <div class="skeleton-line"></div>
          <div class="skeleton-line short"></div>
        </div>
      </div>
    `).join('');
  }

  function renderAircraft(state) {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

    if (state.aircraft.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-plane-slash"></i>
          <h3>Aucun avion trouvé</h3>
          <p>Essayez de modifier vos filtres ou votre recherche</p>
        </div>`;
      return;
    }

    container.innerHTML = state.aircraft.map(a => VH.shared.renderAircraftCard(a)).join('');
    VH.shared.bindCardNavigation(container);
  }

  function renderPagination(state) {
    const container = document.getElementById('pagination-container');
    if (!container) return;
    const total = Number.isFinite(state.total) ? state.total : 0;
    const totalPages = Math.max(1, Math.ceil(total / state.itemsPerPage));
    container.removeAttribute('aria-busy');
    if (total === 0) { container.innerHTML = ''; return; }

    container.innerHTML = `
      <button class="prev-page-btn" ${state.currentPage <= 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>
      <span class="page-info">${i18n.t('hangar.page_info', { current: state.currentPage, total: totalPages })}</span>
      <button class="next-page-btn" ${state.currentPage >= totalPages ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>
    `;
    container.querySelector('.prev-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage - 1));
    container.querySelector('.next-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage + 1));
  }

  function changePage(state, page) {
    // Un chargement est déjà en cours : on ignore le clic.
    if (document.getElementById('pagination-container')?.getAttribute('aria-busy') === 'true') return;
    const total = Number.isFinite(state.total) ? state.total : 0;
    const totalPages = Math.max(1, Math.ceil(total / state.itemsPerPage));
    state.currentPage = Math.min(Math.max(1, page), totalPages);
    // Persister page + filters en URL et session → permet au user
    // de revenir à la bonne page après visite d'une fiche.
    VH.hangar.filters.writeStateToUrl(state);
    try {
      sessionStorage.setItem('hangar_filters', JSON.stringify({
        filters: state.filters, sort: state.sort, currentPage: state.currentPage,
      }));
    } catch { /* quota plein : on ignore */ }
    VH.hangar.data.loadAircraft(state);
    const toolbar = document.querySelector('.hangar-toolbar');
    const offset = toolbar ? toolbar.offsetTop - 80 : 0;
    window.scrollTo({ top: offset, behavior: 'smooth' });
  }

  // Avec la pagination serveur, state.aircraft ne contient qu'une page :
  // on prend state.total pour le compteur global, et les référentiels
  // (déjà filtrés en BDD aux entités utilisées) pour countries / generations.
  function updateStats(state) {
    const total = Number.isFinite(state.total) ? state.total : state.aircraft.length;
    animateNumber(document.getElementById('total-aircraft'), total);
    animateNumber(document.getElementById('total-countries'), (state.countries || []).length);
    animateNumber(document.getElementById('total-generations'), (state.generations || []).length);
  }

  function updateResultsCount(state) {
    const count = Number.isFinite(state.total) ? state.total : state.aircraft.length;
    const text = count === 0 ? i18n.t('hangar.results_none') :
                 count === 1 ? i18n.t('hangar.results_one') :
                 i18n.t('hangar.results', { count });
    const el = document.getElementById('results-count');
    if (el) el.textContent = text;
  }

  /* Pendant un chargement, la pagination ne doit plus rien déclencher : un
   * second clic partirait sur une page calculée avant la réponse. Les boutons
   * sont recréés par renderPagination() à l'arrivée des résultats (ou en cas
   * d'erreur), ce qui les réactive.
   * L'entrée des cartes, elle, est purement CSS (#airplanes-container >
   * .aircraft-card, hangar.css) : chaque carte insérée s'anime, à chaque
   * rendu — plus seulement au premier chargement. */
  function lockPagination() {
    const container = document.getElementById('pagination-container');
    if (!container) return;
    container.setAttribute('aria-busy', 'true');
    container.querySelectorAll('button').forEach((btn) => { btn.disabled = true; });
  }

  VH.hangar.render = {
    renderSkeletons, renderAircraft, renderPagination, changePage,
    updateStats, updateResultsCount, lockPagination,
  };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.hangar.render;
  }
})();
