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
    const startIndex = (state.currentPage - 1) * state.itemsPerPage;
    const pageAircraft = state.filteredAircraft.slice(startIndex, startIndex + state.itemsPerPage);

    if (pageAircraft.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-plane-slash"></i>
          <h3>Aucun avion trouvé</h3>
          <p>Essayez de modifier vos filtres ou votre recherche</p>
        </div>`;
      return;
    }

    container.innerHTML = pageAircraft.map(a => VH.shared.renderAircraftCard(a)).join('');
    VH.shared.bindCardNavigation(container);
  }

  function renderPagination(state) {
    const container = document.getElementById('pagination-container');
    const totalPages = Math.ceil(state.filteredAircraft.length / state.itemsPerPage);
    if (totalPages === 0) { container.innerHTML = ''; return; }

    container.innerHTML = `
      <button class="prev-page-btn" ${state.currentPage === 1 || totalPages === 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>
      <span class="page-info">${i18n.t('hangar.page_info', { current: state.currentPage, total: totalPages })}</span>
      <button class="next-page-btn" ${state.currentPage === totalPages || totalPages === 1 ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>
    `;
    container.querySelector('.prev-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage - 1));
    container.querySelector('.next-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage + 1));
  }

  function changePage(state, page) {
    state.currentPage = page;
    renderAircraft(state);
    renderPagination(state);
    // Persister page + filters en URL et session → permet au user
    // de revenir à la bonne page après visite d'une fiche.
    VH.hangar.filters.writeStateToUrl(state);
    // Clé alignée avec hangar/filters.js (SESSION_KEY = 'hangar_filters')
    try {
      sessionStorage.setItem('hangar_filters', JSON.stringify({
        filters: state.filters, sort: state.sort, currentPage: state.currentPage,
      }));
    } catch (_) { /* quota plein : on ignore */ }
    const toolbar = document.querySelector('.hangar-toolbar');
    const offset = toolbar ? toolbar.offsetTop - 80 : 0;
    window.scrollTo({ top: offset, behavior: 'smooth' });
  }

  function updateStats(state) {
    const uniqueCountries = new Set(state.aircraft.map(a => a.country_name).filter(Boolean));
    const uniqueGenerations = new Set(state.aircraft.map(a => a.generation).filter(Boolean));
    animateNumber(document.getElementById('total-aircraft'), state.aircraft.length);
    animateNumber(document.getElementById('total-countries'), uniqueCountries.size);
    animateNumber(document.getElementById('total-generations'), uniqueGenerations.size);
  }

  function updateResultsCount(state) {
    const count = state.filteredAircraft.length;
    const text = count === 0 ? i18n.t('hangar.results_none') :
                 count === 1 ? i18n.t('hangar.results_one') :
                 i18n.t('hangar.results', { count });
    const el = document.getElementById('results-count');
    if (el) el.textContent = text;
  }

  function observeCards() {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });
    document.querySelectorAll('.aircraft-card').forEach(card => {
      card.style.opacity = '0';
      card.style.transform = 'translateY(20px)';
      card.style.transition = 'all 0.5s ease';
      observer.observe(card);
    });
  }

  VH.hangar.render = {
    renderSkeletons, renderAircraft, renderPagination, changePage,
    updateStats, updateResultsCount, observeCards,
  };
})();
