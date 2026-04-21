/* Filtres, tri, dropdowns, recherche, persistence session/URL.
 * Exporte les fonctions utilisées par data/render/index. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  const SESSION_KEY = 'hangar_filters';
  const dropdownTimeouts = new Map();

  function populateFilterOptions(state) {
    const countryOptions = document.getElementById('country-options');
    const generationOptions = document.getElementById('generation-options');
    const typeOptions = document.getElementById('type-options');

    if (countryOptions) {
      countryOptions.innerHTML = state.countries.map(c => `
        <div class="filter-option" data-value="${escapeHtml(c.name_fr || c.name)}">
          ${escapeHtml(c.name)}
        </div>`).join('');
    }
    if (generationOptions) {
      generationOptions.innerHTML = state.generations.map(gen => `
        <div class="filter-option" data-value="${gen}">
          ${gen}e Génération
        </div>`).join('');
    }
    if (typeOptions) {
      typeOptions.innerHTML = state.types.map(t => `
        <div class="filter-option" data-value="${escapeHtml(t.name_fr || t.name)}">
          ${escapeHtml(t.name)}
        </div>`).join('');
    }

    document.querySelectorAll('.filter-option').forEach(option => {
      option.addEventListener('click', function () {
        const filterType = this.closest('.filter-dropdown').id.replace('-dropdown', '');
        const value = this.dataset.value;
        state.filters[filterType] = state.filters[filterType] === value ? null : value;
        state.currentPage = 1;
        saveFiltersToSession(state);
        closeAllDropdowns();
        updateActiveFilters(state);
        VH.hangar.data.loadAircraft(state);
      });
    });
  }

  // Depuis la pagination serveur, tout filtre / recherche / tri déclenche
  // un nouvel appel API. On garde l'alias `applyFiltersAndRender` pour
  // compatibilité avec les callers existants (hangar.js, popstate, langChanged).
  function applyFiltersAndRender(state) {
    VH.hangar.data.loadAircraft(state);
  }

  function updateActiveFilters(state) {
    const container = document.getElementById('active-filters');
    if (!container) return;
    const filters = [];
    if (state.filters.country) {
      const c = state.countries.find(x => (x.name_fr || x.name) === state.filters.country);
      filters.push({ type: 'country', label: c ? c.name : state.filters.country });
    }
    if (state.filters.generation) {
      filters.push({ type: 'generation', label: `${state.filters.generation}e Génération` });
    }
    if (state.filters.type) {
      const t = state.types.find(x => (x.name_fr || x.name) === state.filters.type);
      filters.push({ type: 'type', label: t ? t.name : state.filters.type });
    }
    if (filters.length === 0) {
      container.classList.add('hidden');
      container.innerHTML = '';
      return;
    }
    container.classList.remove('hidden');
    container.innerHTML = `
      <div class="active-filters-label">Filtres actifs:</div>
      ${filters.map(f => `
        <div class="active-filter" data-type="${f.type}">
          <span>${escapeHtml(f.label)}</span>
          <button class="remove-filter-btn" data-filter-type="${f.type}"><i class="fas fa-times"></i></button>
        </div>`).join('')}
      <button class="clear-all-filters">Effacer tout</button>
    `;
    container.querySelectorAll('.remove-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => removeFilter(state, btn.dataset.filterType));
    });
    container.querySelector('.clear-all-filters')?.addEventListener('click', () => clearAllFilters(state));
  }

  function removeFilter(state, type) {
    state.filters[type] = null;
    state.currentPage = 1;
    saveFiltersToSession(state);
    updateActiveFilters(state);
    VH.hangar.data.loadAircraft(state);
  }

  function clearAllFilters(state) {
    state.filters.country = null;
    state.filters.generation = null;
    state.filters.type = null;
    state.filters.search = '';
    state.currentPage = 1;
    saveFiltersToSession(state);
    updateActiveFilters(state);
    const searchInput = document.getElementById('search-input');
    if (searchInput) searchInput.value = '';
    VH.hangar.data.loadAircraft(state);
  }

  function saveFiltersToSession(state) {
    sessionStorage.setItem(SESSION_KEY, JSON.stringify({
      filters: state.filters, sort: state.sort, currentPage: state.currentPage,
    }));
    writeStateToUrl(state);
    VH.hangar.data.fetchFacets(state);
  }

  function writeStateToUrl(state) {
    const p = new URLSearchParams();
    if (state.filters.country)    p.set('country', state.filters.country);
    if (state.filters.generation) p.set('gen', String(state.filters.generation));
    if (state.filters.type)       p.set('type', state.filters.type);
    if (state.filters.search)     p.set('q', state.filters.search);
    if (state.sort && state.sort !== 'default') p.set('sort', state.sort);
    if (state.view === 'list')    p.set('view', 'list');
    if (state.currentPage > 1)    p.set('page', String(state.currentPage));
    const qs = p.toString();
    const url = qs ? `${location.pathname}?${qs}` : location.pathname;
    try { history.replaceState(null, '', url); } catch (_) { /* ignore */ }
  }

  function readStateFromUrl(state) {
    const p = new URLSearchParams(location.search);
    if (p.has('country')) state.filters.country = p.get('country');
    if (p.has('gen'))     state.filters.generation = Number(p.get('gen'));
    if (p.has('type'))    state.filters.type = p.get('type');
    if (p.has('q'))       state.filters.search = p.get('q');
    if (p.has('sort'))    state.sort = p.get('sort');
    if (p.has('view'))    state.view = p.get('view') === 'list' ? 'list' : 'grid';
    if (p.has('page'))    state.currentPage = Math.max(1, Number(p.get('page')) || 1);
  }

  function restoreFiltersFromSession(state) {
    const saved = sessionStorage.getItem(SESSION_KEY);
    if (!saved) return;
    try {
      const { filters, sort, currentPage } = JSON.parse(saved);
      if (filters) Object.assign(state.filters, filters);
      if (sort) state.sort = sort;
      if (currentPage) state.currentPage = currentPage;
    } catch (_) {
      sessionStorage.removeItem(SESSION_KEY);
    }
  }

  function setupDropdowns(state) {
    const filterButtons = {
      'country-filter-btn': 'country-dropdown',
      'generation-filter-btn': 'generation-dropdown',
      'type-filter-btn': 'type-dropdown'
    };
    Object.entries(filterButtons).forEach(([btnId, dropdownId]) => {
      document.getElementById(btnId)?.addEventListener('click', (e) => {
        e.stopPropagation();
        const btn = document.getElementById(btnId);
        const dropdown = document.getElementById(dropdownId);
        const isOpen = dropdown.classList.contains('show');
        closeAllDropdowns(dropdownId);
        if (!isOpen) {
          if (dropdownTimeouts.has(dropdownId)) {
            clearTimeout(dropdownTimeouts.get(dropdownId));
            dropdownTimeouts.delete(dropdownId);
          }
          dropdown.classList.remove('hidden');
          setTimeout(() => dropdown.classList.add('show'), 10);
          btn?.setAttribute('aria-expanded', 'true');
        }
      });
    });
    document.querySelectorAll('.close-dropdown').forEach(btn => {
      btn.addEventListener('click', () => closeAllDropdowns());
    });
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.filter-btn') && !e.target.closest('.filter-dropdown')) {
        closeAllDropdowns();
      }
    });
    document.querySelectorAll('.filter-dropdown').forEach(dd => {
      dd.addEventListener('click', (e) => e.stopPropagation());
    });
  }

  function closeAllDropdowns(exceptId = null) {
    document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
      if (exceptId && dropdown.id === exceptId) return;
      dropdown.classList.remove('show');
      // Synchroniser aria-expanded sur le bouton associé
      const btnId = dropdown.id.replace('-dropdown', '-filter-btn');
      document.getElementById(btnId)?.setAttribute('aria-expanded', 'false');
      if (dropdownTimeouts.has(dropdown.id)) clearTimeout(dropdownTimeouts.get(dropdown.id));
      const timeoutId = setTimeout(() => {
        dropdown.classList.add('hidden');
        dropdownTimeouts.delete(dropdown.id);
      }, 300);
      dropdownTimeouts.set(dropdown.id, timeoutId);
    });
  }

  function setupSearchAndSort(state) {
    const searchInput = document.getElementById('search-input');
    let searchDebounceTimer = null;
    searchInput?.addEventListener('input', (e) => {
      state.filters.search = e.target.value.toLowerCase();
      state.currentPage = 1;
      clearTimeout(searchDebounceTimer);
      searchDebounceTimer = setTimeout(() => {
        saveFiltersToSession(state);
        VH.hangar.data.loadAircraft(state);
      }, 300);
    });

    const sortSelect = document.getElementById('sort-select');
    sortSelect?.addEventListener('change', (e) => {
      state.sort = e.target.value;
      state.currentPage = 1;
      saveFiltersToSession(state);
      VH.hangar.data.loadAircraft(state);
    });

    window.addEventListener('popstate', () => {
      readStateFromUrl(state);
      if (searchInput && state.filters.search) searchInput.value = state.filters.search;
      if (sortSelect) sortSelect.value = state.sort;
      applyFiltersAndRender(state);
      updateActiveFilters(state);
    });
  }

  VH.hangar.filters = {
    populateFilterOptions, applyFiltersAndRender, updateActiveFilters,
    saveFiltersToSession, readStateFromUrl, restoreFiltersFromSession,
    writeStateToUrl,
    setupDropdowns, setupSearchAndSort, closeAllDropdowns,
    removeFilter, clearAllFilters,
  };
})();
