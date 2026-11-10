/* Favoris — barre d'outils : options des filtres et leurs compteurs,
 * filtres actifs, recherche et tri. Chaque changement écrit l'URL puis
 * relance le rendu (VH.favorites.render.applyFiltersAndRender). */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const FILTER_KEYS = ['country', 'generation', 'type'];

  function generationLabel(g) {
    return `${g}e Génération`;
  }

  function optionButton(value, label) {
    return `<button type="button" class="filter-option" aria-pressed="false" data-value="${value}">${label}</button>`;
  }

  function fillOptions(id, html) {
    const el = document.getElementById(id);
    if (el) el.innerHTML = html;
  }

  function onOptionClick(state, option) {
    // Option grisée (count 0) : ignore le clic
    if (option.classList.contains('filter-option-empty')) return;
    const filterType = option.closest('.filter-dropdown').id.replace('-dropdown', '');
    const value = option.dataset.value;

    // String() : la génération est un nombre dans l'état, une chaîne ici.
    const newVal = String(state.filters[filterType]) === value ? null : value;
    // Normaliser la génération en nombre pour cohérence URL/état
    state.filters[filterType] = (filterType === 'generation' && newVal != null) ? Number(newVal) : newVal;
    VH.favorites.url.writeStateToUrl(state);
    VH.favorites.render.applyFiltersAndRender(state);
    VH.favorites.dropdowns.closeAllDropdowns();
    updateActiveFilters(state);
    decorateFacetCounts(state);
  }

  function populateFilterOptions(state) {
    const values = VH.favorites.filters.filterValues(state.favorites);
    fillOptions('country-options', values.countries.map(c => optionButton(escapeHtml(c), escapeHtml(c))).join(''));
    fillOptions('generation-options', values.generations.map(g => optionButton(g, generationLabel(g))).join(''));
    fillOptions('type-options', values.types.map(t => optionButton(escapeHtml(t), escapeHtml(t))).join(''));

    // Click handlers pour les options
    document.querySelectorAll('.filter-option').forEach(option => {
      option.addEventListener('click', () => onOptionClick(state, option));
    });

    decorateFacetCounts(state);
    syncFilterUi(state);
  }

  /* Reflète l'état des filtres dans la barre : option retenue surlignée
   * (.selected + aria-pressed), bouton doré quand son filtre porte une
   * valeur (.has-value). */
  function syncFilterUi(state) {
    FILTER_KEYS.forEach((key) => {
      const value = state.filters[key];
      const hasValue = value != null && value !== '';
      document.getElementById(`${key}-filter-btn`)?.classList.toggle('has-value', hasValue);
      document.querySelectorAll(`#${key}-options .filter-option`).forEach((opt) => {
        const on = hasValue && opt.dataset.value === String(value);
        opt.classList.toggle('selected', on);
        opt.setAttribute('aria-pressed', on ? 'true' : 'false');
      });
    });
  }

  /* Ajoute « (n) » à chaque option et grise celles à 0. */
  function decorateFacetCounts(state) {
    const facets = VH.favorites.filters.computeFacets(state);
    const apply = (selector, lookup) => {
      document.querySelectorAll(selector).forEach(el => {
        const n = lookup(el) || 0;
        let tag = el.querySelector('.fc');
        if (!tag) { tag = document.createElement('span'); tag.className = 'fc'; el.appendChild(tag); }
        tag.textContent = ' (' + n + ')';
        el.classList.toggle('filter-option-empty', n === 0);
      });
    };
    apply('#country-options .filter-option', el => facets.countries[el.dataset.value]);
    apply('#generation-options .filter-option', el => facets.generations[Number(el.dataset.value)]);
    apply('#type-options .filter-option', el => facets.types[el.dataset.value]);
  }

  function activeFilterList(filters) {
    const list = [];
    if (filters.country) list.push({ type: 'country', label: filters.country });
    if (filters.generation) list.push({ type: 'generation', label: generationLabel(filters.generation) });
    if (filters.type) list.push({ type: 'type', label: filters.type });
    return list;
  }

  function activeFiltersHtml(list) {
    return `
      <div class="active-filters-label">Filtres :</div>
      ${list.map(f => `
        <div class="active-filter" data-type="${f.type}">
          <span>${escapeHtml(f.label)}</span>
          <button class="remove-filter-btn" data-filter-type="${f.type}"><i class="fas fa-times"></i></button>
        </div>
      `).join('')}
      <button class="clear-all-filters">Effacer tout</button>
    `;
  }

  function onFiltersCleared(state) {
    VH.favorites.url.writeStateToUrl(state);
    VH.favorites.render.applyFiltersAndRender(state);
    updateActiveFilters(state);
    decorateFacetCounts(state);
  }

  function bindActiveFilters(container, state) {
    container.querySelectorAll('.remove-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        state.filters[btn.dataset.filterType] = null;
        onFiltersCleared(state);
      });
    });
    container.querySelector('.clear-all-filters')?.addEventListener('click', () => {
      state.filters.country = null;
      state.filters.generation = null;
      state.filters.type = null;
      onFiltersCleared(state);
    });
  }

  function updateActiveFilters(state) {
    syncFilterUi(state);
    const container = document.getElementById('active-filters');
    const list = activeFilterList(state.filters);

    if (list.length === 0) {
      container.classList.add('hidden');
      container.innerHTML = '';
      return;
    }

    container.classList.remove('hidden');
    container.innerHTML = activeFiltersHtml(list);
    bindActiveFilters(container, state);
  }

  function setupSearchAndSort(state) {
    document.getElementById('search-input')?.addEventListener('input', (e) => {
      state.search = e.target.value.toLowerCase();
      VH.favorites.url.writeStateToUrl(state);
      VH.favorites.render.applyFiltersAndRender(state);
      decorateFacetCounts(state);
    });

    document.getElementById('sort-select')?.addEventListener('change', (e) => {
      state.sort = e.target.value;
      VH.favorites.url.writeStateToUrl(state);
      VH.favorites.render.applyFiltersAndRender(state);
    });
  }

  const api = {
    populateFilterOptions,
    syncFilterUi,
    decorateFacetCounts,
    activeFilterList,
    updateActiveFilters,
    setupSearchAndSort,
  };
  window.VH.favorites.toolbar = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
