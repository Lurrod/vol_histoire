/* Chargement des référentiels, liste des avions, facettes.
 * Opère sur `state` partagé passé en argument. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  async function loadReferentialData(state) {
    try {
      const response = await auth.fetchWithTimeout('/api/referentials');
      if (!response.ok) throw new Error('Erreur chargement référentiels');
      const { countries, generations, types, manufacturers } = await response.json();
      state.countries = Array.isArray(countries) ? countries : [];
      state.generations = Array.isArray(generations) ? generations : [];
      state.types = Array.isArray(types) ? types : [];
      state.manufacturers = Array.isArray(manufacturers) ? manufacturers : [];
      VH.hangar.filters.populateFilterOptions(state);
      VH.hangar.admin.populateFormSelects(state);
    } catch (error) {
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  async function loadAircraft(state) {
    VH.hangar.render.renderSkeletons();
    try {
      const params = new URLSearchParams({
        sort: state.sort,
        page: String(state.currentPage),
        limit: String(state.itemsPerPage),
      });
      if (state.filters.country)    params.set('country', state.filters.country);
      if (state.filters.generation) params.set('generation', state.filters.generation);
      if (state.filters.type)       params.set('type', state.filters.type);
      if (state.filters.search)     params.set('search', state.filters.search);

      const response = await auth.fetchWithTimeout(`/api/airplanes?${params}`);
      if (!response.ok) throw new Error('Erreur serveur');
      const data = await response.json();
      state.aircraft = Array.isArray(data.data) ? data.data : [];
      state.total = Number.isFinite(data.total) ? data.total : state.aircraft.length;

      // Si la page demandée dépasse le total (après suppression ou filtre),
      // reculer à la dernière page valide et refetch une seule fois.
      const totalPages = Math.max(1, Math.ceil(state.total / state.itemsPerPage));
      if (state.currentPage > totalPages) {
        state.currentPage = totalPages;
        return loadAircraft(state);
      }

      VH.hangar.render.renderAircraft(state);
      VH.hangar.render.renderPagination(state);
      VH.hangar.render.updateResultsCount(state);
      VH.hangar.render.updateStats(state);
    } catch (error) {
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  async function fetchFacets(state) {
    const p = new URLSearchParams();
    if (state.filters.country)    p.set('country', state.filters.country);
    if (state.filters.generation) p.set('generation', String(state.filters.generation));
    if (state.filters.type)       p.set('type', state.filters.type);
    try {
      const res = await fetch('/api/airplanes/facets?' + p.toString());
      if (!res.ok) return;
      state.facets = await res.json();
      decorateFacetCounts(state);
    } catch (_) { /* ignore */ }
  }

  function decorateFacetCounts(state) {
    if (!state.facets) return;
    const applyTag = (selector, lookup) => {
      document.querySelectorAll(selector).forEach(el => {
        const n = lookup(el) || 0;
        let tag = el.querySelector('.fc');
        if (!tag) { tag = document.createElement('span'); tag.className = 'fc'; el.appendChild(tag); }
        tag.textContent = ' (' + n + ')';
        el.classList.toggle('filter-option-empty', n === 0);
      });
    };
    applyTag('#country-options .filter-option', el => state.facets.countries[el.dataset.value]);
    applyTag('#generation-options .filter-option', el => state.facets.generations[Number(el.dataset.value)]);
    applyTag('#type-options .filter-option', el => state.facets.types[el.dataset.value]);
  }

  VH.hangar.data = { loadReferentialData, loadAircraft, fetchFacets };
})();
