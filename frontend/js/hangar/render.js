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

  /* Chargement : au premier affichage (aucune carte), des squelettes ; ensuite
   * les cartes déjà là restent, estompées (.is-loading), jusqu'à la réponse :
   * elles glisseront vers leur nouvelle place au lieu de disparaître. */
  function showLoading() {
    const container = document.getElementById('airplanes-container');
    if (!container) return;
    if (container.querySelector('.aircraft-card')) {
      container.classList.add('is-loading');
      container.setAttribute('aria-busy', 'true');
      return;
    }
    renderSkeletons();
  }

  function clearLoading() {
    const container = document.getElementById('airplanes-container');
    if (!container) return;
    container.classList.remove('is-loading');
    container.removeAttribute('aria-busy');
  }

  /**
   * Pose les résultats par morphing (VH.viewMorph.swap) : depuis les squelettes,
   * chaque squelette devient la carte de même rang ; sinon un appareil encore
   * présent glisse vers sa nouvelle place, les autres sortent ou entrent —
   * par la droite pour la page suivante, par la gauche pour la précédente.
   * @param {object} state
   * @param {'next'|'prev'|null} [direction] sens de pagination
   * @returns {Promise<void>} résolue une fois les cartes dans le DOM
   */
  function showResults(state, direction) {
    const container = document.getElementById('airplanes-container');
    if (!container) return Promise.resolve();
    const fromSkeleton = !!container.querySelector('.skeleton-card');
    const dir = direction === 'next' || direction === 'prev' ? ` vh-dir-${direction}` : '';
    return VH.viewMorph.swap({
      root: container,
      slots: fromSkeleton ? '.skeleton-card, .aircraft-card' : undefined,
      // vh-hangar-morph coupe l'entrée CSS des cartes : le morphing la remplace.
      rootClass: `vh-hangar-morph${dir}`,
      update: () => {
        renderAircraft(state);
        clearLoading();
      },
    });
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

    // Chaque carte est un lien (titre étendu à la carte) : aucun gestionnaire
    // de navigation à poser. La case « Comparer <nom> » est rendue avec la
    // carte ; hangar/compare.js la coche d'après la sélection.
    container.innerHTML = state.aircraft.map(a => VH.shared.renderAircraftCard(a, { compare: true })).join('');
  }

  function renderPagination(state) {
    const container = document.getElementById('pagination-container');
    if (!container) return;
    const total = Number.isFinite(state.total) ? state.total : 0;
    const totalPages = Math.max(1, Math.ceil(total / state.itemsPerPage));
    container.removeAttribute('aria-busy');
    if (total === 0) { container.innerHTML = ''; return; }

    // Le compteur de page reste DANS le DOM d'un rendu à l'autre : seuls les
    // boutons sont remplacés. Détaché puis réinséré, il perdrait son style de
    // départ et le chiffre sauterait au lieu de glisser (VH.rollingNumber).
    const prevHtml = `<button class="prev-page-btn" ${state.currentPage <= 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>`;
    const nextHtml = `<button class="next-page-btn" ${state.currentPage >= totalPages ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>`;
    let info = container.querySelector('.page-info');
    if (info) {
      const fresh = document.createElement('div');
      fresh.innerHTML = prevHtml + nextHtml;
      const [prev, next] = fresh.children;
      container.querySelector('.prev-page-btn')?.replaceWith(prev);
      container.querySelector('.next-page-btn')?.replaceWith(next);
    } else {
      container.innerHTML = `${prevHtml}<span class="page-info"></span>${nextHtml}`;
      info = container.querySelector('.page-info');
    }
    VH.rollingNumber.setText(info, i18n.t('hangar.page_info', { current: state.currentPage, total: totalPages }));
    container.querySelector('.prev-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage - 1));
    container.querySelector('.next-page-btn')?.addEventListener('click', () => changePage(state, state.currentPage + 1));
  }

  function changePage(state, page) {
    // Un chargement est déjà en cours : on ignore le clic.
    if (document.getElementById('pagination-container')?.getAttribute('aria-busy') === 'true') return;
    const total = Number.isFinite(state.total) ? state.total : 0;
    const totalPages = Math.max(1, Math.ceil(total / state.itemsPerPage));
    const next = Math.min(Math.max(1, page), totalPages);
    // Sens de la pagination : les cartes de la nouvelle page arrivent de ce côté.
    state.pageDirection = next > state.currentPage ? 'next' : next < state.currentPage ? 'prev' : null;
    state.currentPage = next;
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
    // Compteur « odomètre » : la valeur glisse de l'ancienne à la nouvelle
    // au lieu de recompter depuis zéro à chaque filtre.
    const roll = VH.rollingNumber.set;
    roll(document.getElementById('total-aircraft'), total);
    roll(document.getElementById('total-countries'), (state.countries || []).length);
    roll(document.getElementById('total-generations'), (state.generations || []).length);
  }

  function updateResultsCount(state) {
    const count = Number.isFinite(state.total) ? state.total : state.aircraft.length;
    const text = count === 0 ? i18n.t('hangar.results_none') :
                 count === 1 ? i18n.t('hangar.results_one') :
                 i18n.t('hangar.results', { count });
    // Le nouveau texte se pose (vh-text-swap) quand le nombre change.
    VH.motion.swapText(document.getElementById('results-count'), text);
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
    showLoading, clearLoading, showResults,
  };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.hangar.render;
  }
})();
