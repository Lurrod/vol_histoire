const ALPHA3_TO_ALPHA2 = {
  USA: 'us', RUS: 'ru', CHN: 'cn', FRA: 'fr', GBR: 'gb',
  DEU: 'de', ITA: 'it', SWE: 'se', IND: 'in', JPN: 'jp',
  BRA: 'br', ISR: 'il', VNM: 'vn', AFG: 'af', IRQ: 'iq',
  YUG: 'rs', KOR: 'kr', FLK: 'fk', LBN: 'lb', DZA: 'dz',
  SYR: 'sy', IRN: 'ir'
};

document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* escapeHtml, showToast → utils.js | navigation → nav.js */

  function showUndoToast(message, onUndo) {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast toast-info';
    toast.setAttribute('role', 'status');
    toast.innerHTML = `
      <i class="fas fa-heart-broken" aria-hidden="true"></i>
      <span style="flex:1">${escapeHtml(message)}</span>
      <button class="toast-undo-btn" style="background:none;border:1px solid currentColor;border-radius:6px;padding:0.2rem 0.6rem;cursor:pointer;font-weight:700;color:inherit;font-size:0.85rem">${escapeHtml(i18n.t('favorites.undo'))}</button>
    `;

    let undone = false;
    toast.querySelector('.toast-undo-btn').addEventListener('click', () => {
      undone = true;
      onUndo();
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    });

    container.appendChild(toast);

    const timer = setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, 5000);

    return { cancel: () => { clearTimeout(timer); if (!undone) { toast.classList.add('fade-out'); setTimeout(() => toast.remove(), 300); } } };
  }

  function formatRelativeDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now - date;
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

    if (diffDays === 0) return i18n.t('favorites.added_today');
    if (diffDays === 1) return i18n.t('favorites.added_yesterday');
    if (diffDays < 30) return i18n.t('favorites.added_days_ago', { days: diffDays });
    const diffMonths = Math.floor(diffDays / 30);
    if (diffMonths === 1) return i18n.t('favorites.added_month_ago');
    if (diffMonths < 12) return i18n.t('favorites.added_months_ago', { months: diffMonths });
    return i18n.t('favorites.added_on', { date: date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR') });
  }

  /* =========================================================================
     AUTH GATE
     ========================================================================= */

  const currentUser = auth.getPayload();

  const authGate = document.getElementById('auth-gate');
  const favoritesContent = document.getElementById('favorites-content');

  if (!auth.getToken() || !currentUser) {
    // Not logged in — show auth gate, hide favorites
    authGate?.classList.remove('hidden');
    favoritesContent?.classList.add('hidden');
    document.querySelector('.page-hero')?.classList.add('hidden');
    return; // Stop here
  }

  // Logged in — show favorites, hide auth gate
  authGate?.classList.add('hidden');
  favoritesContent?.classList.remove('hidden');

  /* =========================================================================
     STATE
     ========================================================================= */

  const state = {
    favorites: [],
    filtered: [],
    sort: 'recent',
    search: '',
    filters: {
      country: null,
      generation: null,
      type: null
    }
  };

  /* =========================================================================
     DATA LOADING
     ========================================================================= */

  function renderSkeletons() {
    const container = document.getElementById('favorites-container');
    if (!container) return;
    container.classList.remove('hidden');
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

  async function loadFavorites() {
    renderSkeletons();
    try {
      const response = await auth.authFetch('/api/favorites');

      if (response.status === 401 || response.status === 403) {
        showToast(i18n.t('common.session_expired'), 'error');
        auth.clearSession();
        setTimeout(() => { window.location.href = '/login'; }, 1500);
        return;
      }

      if (!response.ok) throw new Error('Erreur serveur');

      const data = await response.json();
      state.favorites = Array.isArray(data) ? data : [];
      populateFilterOptions();
      applyFiltersAndRender();
      updateStats();

    } catch (error) {
      // Erreur gérée via toast
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  /* animateNumber → utils.js */

  function updateStats() {
    const uniqueCountries = new Set(state.favorites.map(a => a.country_name).filter(Boolean));
    const uniqueGenerations = new Set(state.favorites.map(a => a.generation).filter(Boolean));

    animateNumber(document.getElementById('total-favorites'), state.favorites.length);
    animateNumber(document.getElementById('total-countries'), uniqueCountries.size);
    animateNumber(document.getElementById('total-generations'), uniqueGenerations.size);
  }

  /* =========================================================================
     FILTERS, SORT & RENDER
     ========================================================================= */

  const searchInput = document.getElementById('search-input');
  const sortSelect = document.getElementById('sort-select');

  searchInput?.addEventListener('input', (e) => {
    state.search = e.target.value.toLowerCase();
    applyFiltersAndRender();
  });

  sortSelect?.addEventListener('change', (e) => {
    state.sort = e.target.value;
    applyFiltersAndRender();
  });

  /* =========================================================================
     FILTER DROPDOWNS (pays, génération, type)
     ========================================================================= */

  function populateFilterOptions() {
    const countries = [...new Set(state.favorites.map(a => a.country_name).filter(Boolean))].sort();
    const generations = [...new Set(state.favorites.map(a => a.generation).filter(Boolean))].sort((a, b) => a - b);
    const types = [...new Set(state.favorites.map(a => a.type_name).filter(Boolean))].sort();

    const countryOptions = document.getElementById('country-options');
    const generationOptions = document.getElementById('generation-options');
    const typeOptions = document.getElementById('type-options');

    if (countryOptions) {
      countryOptions.innerHTML = countries.map(c => `<div class="filter-option" data-value="${escapeHtml(c)}">${escapeHtml(c)}</div>`).join('');
    }
    if (generationOptions) {
      generationOptions.innerHTML = generations.map(g => `<div class="filter-option" data-value="${g}">${g}e Génération</div>`).join('');
    }
    if (typeOptions) {
      typeOptions.innerHTML = types.map(t => `<div class="filter-option" data-value="${escapeHtml(t)}">${escapeHtml(t)}</div>`).join('');
    }

    // Click handlers pour les options
    document.querySelectorAll('.filter-option').forEach(option => {
      option.addEventListener('click', function () {
        const dropdown = this.closest('.filter-dropdown');
        const filterType = dropdown.id.replace('-dropdown', '');
        const value = this.dataset.value;

        state.filters[filterType] = state.filters[filterType] === value ? null : value;
        applyFiltersAndRender();
        closeAllDropdowns();
        updateActiveFilters();
      });
    });
  }

  // Dropdown toggle
  const filterButtons = {
    'country-filter-btn': 'country-dropdown',
    'generation-filter-btn': 'generation-dropdown',
    'type-filter-btn': 'type-dropdown'
  };

  const dropdownTimeouts = new Map();

  Object.entries(filterButtons).forEach(([btnId, dropdownId]) => {
    document.getElementById(btnId)?.addEventListener('click', (e) => {
      e.stopPropagation();
      const dropdown = document.getElementById(dropdownId);
      const isOpen = dropdown.classList.contains('show');
      closeAllDropdowns();
      if (!isOpen) {
        // Annuler le timeout hidden programmé par closeAllDropdowns
        if (dropdownTimeouts.has(dropdownId)) {
          clearTimeout(dropdownTimeouts.get(dropdownId));
          dropdownTimeouts.delete(dropdownId);
        }
        dropdown.classList.remove('hidden');
        setTimeout(() => dropdown.classList.add('show'), 10);
      }
    });
  });

  document.querySelectorAll('.close-dropdown').forEach(btn => {
    btn.addEventListener('click', () => closeAllDropdowns());
  });

  function closeAllDropdowns() {
    document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
      dropdown.classList.remove('show');
      const id = dropdown.id;
      if (dropdownTimeouts.has(id)) clearTimeout(dropdownTimeouts.get(id));
      const timeout = setTimeout(() => {
        dropdown.classList.add('hidden');
        dropdownTimeouts.delete(id);
      }, 300);
      dropdownTimeouts.set(id, timeout);
    });
  }

  document.addEventListener('click', (e) => {
    if (!e.target.closest('.filter-btn') && !e.target.closest('.filter-dropdown')) {
      closeAllDropdowns();
    }
  });

  // Active filters display
  function updateActiveFilters() {
    const container = document.getElementById('active-filters');
    const filters = [];

    if (state.filters.country) filters.push({ type: 'country', label: state.filters.country });
    if (state.filters.generation) filters.push({ type: 'generation', label: `${state.filters.generation}e Génération` });
    if (state.filters.type) filters.push({ type: 'type', label: state.filters.type });

    if (filters.length === 0) {
      container.classList.add('hidden');
      container.innerHTML = '';
      return;
    }

    container.classList.remove('hidden');
    container.innerHTML = `
      <div class="active-filters-label">Filtres :</div>
      ${filters.map(f => `
        <div class="active-filter" data-type="${f.type}">
          <span>${escapeHtml(f.label)}</span>
          <button class="remove-filter-btn" data-filter-type="${f.type}"><i class="fas fa-times"></i></button>
        </div>
      `).join('')}
      <button class="clear-all-filters">Effacer tout</button>
    `;

    container.querySelectorAll('.remove-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        state.filters[btn.dataset.filterType] = null;
        applyFiltersAndRender();
        updateActiveFilters();
      });
    });
    container.querySelector('.clear-all-filters')?.addEventListener('click', () => {
      state.filters.country = null;
      state.filters.generation = null;
      state.filters.type = null;
      applyFiltersAndRender();
      updateActiveFilters();
    });
  }

  function applyFiltersAndRender() {
    let filtered = [...state.favorites];

    // Search
    if (state.search) {
      filtered = filtered.filter(a =>
        a.name?.toLowerCase().includes(state.search) ||
        a.complete_name?.toLowerCase().includes(state.search) ||
        a.country_name?.toLowerCase().includes(state.search) ||
        a.little_description?.toLowerCase().includes(state.search)
      );
    }

    // Country filter
    if (state.filters.country) {
      filtered = filtered.filter(a => a.country_name === state.filters.country);
    }

    // Generation filter
    if (state.filters.generation) {
      filtered = filtered.filter(a => String(a.generation) === String(state.filters.generation));
    }

    // Type filter
    if (state.filters.type) {
      filtered = filtered.filter(a => a.type_name === state.filters.type);
    }

    // Sort
    switch (state.sort) {
      case 'recent':
        filtered.sort((a, b) => new Date(b.favorited_at) - new Date(a.favorited_at));
        break;
      case 'alphabetical':
        filtered.sort((a, b) => a.name.localeCompare(b.name));
        break;
      case 'nation':
        filtered.sort((a, b) => (a.country_name || '').localeCompare(b.country_name || ''));
        break;
      case 'generation':
        filtered.sort((a, b) => (b.generation || 0) - (a.generation || 0));
        break;
    }

    state.filtered = filtered;
    renderFavorites();
    updateResultsCount();
  }

  function updateResultsCount() {
    const count = state.filtered.length;
    const text = count === 0 ? i18n.t('favorites.results_none') :
                 count === 1 ? i18n.t('favorites.results_one') :
                 i18n.t('favorites.results', { count });
    document.getElementById('results-count').textContent = text;
  }

  function renderFavorites() {
    const container = document.getElementById('favorites-container');
    const emptyState = document.getElementById('empty-state');

    // Show/hide empty state
    if (state.favorites.length === 0) {
      container.classList.add('hidden');
      emptyState?.classList.remove('hidden');
      return;
    }

    container.classList.remove('hidden');
    emptyState?.classList.add('hidden');

    if (state.filtered.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-search"></i>
          <h3>Aucun résultat</h3>
          <p>Aucun favori ne correspond à votre recherche</p>
        </div>
      `;
      return;
    }

    container.innerHTML = state.filtered.map(aircraft => `
      <article class="aircraft-card" data-id="${aircraft.id}" tabindex="0" role="link" aria-label="${escapeHtml(aircraft.name)}">
        <button class="favorite-remove" data-airplane-id="${aircraft.id}" title="${i18n.t('details.remove_favorite')}">
          <i class="fas fa-heart-broken"></i>
        </button>
        <div class="aircraft-image">
          <img src="${escapeHtml(aircraft.image_url) || 'https://via.placeholder.com/400x300?text=No+Image'}"
               alt="${escapeHtml(aircraft.name)}"
               loading="lazy" width="400" height="300">
          <div class="aircraft-overlay">
            <div class="aircraft-badges">
              ${aircraft.generation ? `<span class="aircraft-badge generation">${escapeHtml(aircraft.generation)}e Gén</span>` : ''}
              ${aircraft.type_name ? `<span class="aircraft-badge type">${escapeHtml(aircraft.type_name)}</span>` : ''}
            </div>
          </div>
        </div>
        <div class="aircraft-content">
          <div class="aircraft-header">
            <div class="aircraft-title">
              <div class="aircraft-name-row">
                <h3>${escapeHtml(aircraft.name)}</h3>
                ${aircraft.country_code && ALPHA3_TO_ALPHA2[aircraft.country_code] ? `<img class="country-flag" src="https://flagcdn.com/w80/${ALPHA3_TO_ALPHA2[aircraft.country_code]}.png" alt="${escapeHtml(aircraft.country_name)}" width="24" height="18">` : ''}
              </div>
            </div>
          </div>
          <div class="aircraft-specs">
            ${aircraft.max_speed ? `
              <div class="spec-item">
                <i class="fas fa-gauge-high"></i>
                <span>${escapeHtml(aircraft.max_speed)} km/h</span>
              </div>
            ` : ''}
            ${aircraft.date_operationel ? `
              <div class="spec-item">
                <i class="fas fa-calendar"></i>
                <span>${new Date(aircraft.date_operationel).getFullYear()}</span>
              </div>
            ` : ''}
          </div>
          <div class="favorited-date">
            <i class="fas fa-heart"></i>
            <span>${formatRelativeDate(aircraft.favorited_at)}</span>
          </div>
        </div>
      </article>
    `).join('');

    // Navigate to detail on card click
    container.querySelectorAll('.aircraft-card').forEach(card => {
      card.addEventListener('click', (e) => {
        // Don't navigate if clicking remove button
        if (e.target.closest('.favorite-remove')) return;
        const id = card.dataset.id;
        window.location.href = `/details?id=${id}`;
      });
    });

    // Remove from favorites (undo toast)
    container.querySelectorAll('.favorite-remove').forEach(btn => {
      btn.addEventListener('click', async (e) => {
        e.stopPropagation();
        const airplaneId = btn.dataset.airplaneId;

        // Snapshot pour undo
        const snapshot = [...state.favorites];

        // Retrait optimiste de l'état et de la carte
        state.favorites = state.favorites.filter(a => a.id !== parseInt(airplaneId));
        const card = btn.closest('.aircraft-card');
        if (card) {
          card.style.transition = 'all 0.3s ease';
          card.style.transform = 'scale(0.85)';
          card.style.opacity = '0';
        }

        let undone = false;
        showUndoToast(i18n.t('favorites.removed'), () => {
          undone = true;
          state.favorites = snapshot;
          applyFiltersAndRender();
          updateStats();
        });

        // API call après le délai undo
        setTimeout(async () => {
          if (undone) return;
          try {
            const response = await auth.authFetch(`/api/favorites/${airplaneId}`, { method: 'DELETE' });
            if (!response.ok) throw new Error();
            applyFiltersAndRender();
            updateStats();
          } catch {
            state.favorites = snapshot;
            applyFiltersAndRender();
            updateStats();
            showToast(i18n.t('common.error'), 'error');
          }
        }, 5000);
      });
    });
  }


  /* =========================================================================
     KEYBOARD SHORTCUTS
     ========================================================================= */

  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      searchInput?.focus();
    }
  });

  /* =========================================================================
     INITIALIZE
     ========================================================================= */

  await loadFavorites();

  // Re-render on language change
  window.addEventListener('langChanged', () => {
    updateResultsCount();
    renderFavorites();
  });

});