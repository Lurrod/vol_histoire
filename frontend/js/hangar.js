const ALPHA3_TO_ALPHA2 = {
  USA: 'us', RUS: 'ru', CHN: 'cn', FRA: 'fr', GBR: 'gb',
  DEU: 'de', ITA: 'it', SWE: 'se', IND: 'in', JPN: 'jp',
  BRA: 'br', ISR: 'il', VNM: 'vn', AFG: 'af', IRQ: 'iq',
  YUG: 'rs', KOR: 'kr', FLK: 'fk', LBN: 'lb', DZA: 'dz',
  SYR: 'sy', IRN: 'ir'
};

document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* =========================================================================
     STATE MANAGEMENT
     ========================================================================= */
  
  const state = {
    aircraft: [],
    filteredAircraft: [],
    currentPage: 1,
    itemsPerPage: 6,
    filters: {
      country: null,
      generation: null,
      type: null,
      search: ''
    },
    sort: 'default',
    countries: [],
    generations: [],
    types: [],
    manufacturers: [],
    facets: null,
    view: localStorage.getItem('vh_hangar_view') || 'grid',
    compareIds: JSON.parse(localStorage.getItem('vh_compare_ids') || '[]'),
  };

  /* escapeHtml, showToast, animateNumber → utils.js | navigation → nav.js */

  /* =========================================================================
     DATA LOADING
     ========================================================================= */
  
  async function loadReferentialData() {
    try {
      // 1 round-trip HTTP au lieu de 4 (endpoint combiné /api/referentials)
      const response = await auth.fetchWithTimeout('/api/referentials');
      if (!response.ok) {
        throw new Error('Erreur chargement référentiels');
      }
      const { countries, generations, types, manufacturers } = await response.json();

      state.countries = Array.isArray(countries) ? countries : [];
      state.generations = Array.isArray(generations) ? generations : [];
      state.types = Array.isArray(types) ? types : [];
      state.manufacturers = Array.isArray(manufacturers) ? manufacturers : [];

      populateFilterOptions();
      populateFormSelects();
    } catch (error) {
      // Erreur gérée via toast
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  function populateFilterOptions() {
    const countryOptions = document.getElementById('country-options');
    const generationOptions = document.getElementById('generation-options');
    const typeOptions = document.getElementById('type-options');

    if (countryOptions) {
      countryOptions.innerHTML = state.countries.map(country => `
        <div class="filter-option" data-value="${escapeHtml(country.name)}">
          ${escapeHtml(country.name)}
        </div>
      `).join('');
    }

    if (generationOptions) {
      generationOptions.innerHTML = state.generations.map(gen => `
        <div class="filter-option" data-value="${gen}">
          ${gen}e Génération
        </div>
      `).join('');
    }

    if (typeOptions) {
      typeOptions.innerHTML = state.types.map(type => `
        <div class="filter-option" data-value="${escapeHtml(type.name)}">
          ${escapeHtml(type.name)}
        </div>
      `).join('');
    }

    // Add click handlers
    document.querySelectorAll('.filter-option').forEach(option => {
      option.addEventListener('click', function() {
        const filterType = this.closest('.filter-dropdown').id.replace('-dropdown', '');
        const value = this.dataset.value;
        
        state.filters[filterType] = state.filters[filterType] === value ? null : value;
        state.currentPage = 1;
        saveFiltersToSession();
        closeAllDropdowns();
        updateActiveFilters();
        loadAircraft();
      });
    });
  }

  function populateFormSelects() {
    const countrySelect = document.getElementById('aircraft-country');
    const manufacturerSelect = document.getElementById('aircraft-manufacturer');
    const generationSelect = document.getElementById('aircraft-generation');
    const typeSelect = document.getElementById('aircraft-type');

    if (countrySelect) {
      countrySelect.innerHTML = `<option value="">${i18n.t('hangar.select')}</option>` +
        state.countries.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');
    }

    if (manufacturerSelect) {
      manufacturerSelect.innerHTML = `<option value="">${i18n.t('hangar.select')}</option>` +
        state.manufacturers.map(m => `<option value="${m.id}">${escapeHtml(m.name)}${m.country_name ? ` (${escapeHtml(m.country_name)})` : ''}</option>`).join('');
    }

    if (generationSelect) {
      generationSelect.innerHTML = `<option value="">${i18n.t('hangar.select')}</option>` +
        state.generations.map(g => `<option value="${g}">${g}e Génération</option>`).join('');
    }

    if (typeSelect) {
      typeSelect.innerHTML = `<option value="">${i18n.t('hangar.select')}</option>` +
        state.types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
    }
  }

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

  async function loadAircraft() {
    renderSkeletons();
    try {
      const params = new URLSearchParams({
        sort: state.sort,
        ...(state.filters.country && { country: state.filters.country }),
        ...(state.filters.generation && { generation: state.filters.generation }),
        ...(state.filters.type && { type: state.filters.type })
      });

      const response = await auth.fetchWithTimeout(`/api/airplanes?${params}`);
      if (!response.ok) throw new Error('Erreur serveur');
      const data = await response.json();

      state.aircraft = Array.isArray(data.data) ? data.data : [];
      applyFiltersAndRender();
      updateStats();

    } catch (error) {
      // Erreur gérée via toast
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  function updateStats() {
    const uniqueCountries = new Set(state.aircraft.map(a => a.country_name).filter(Boolean));
    const uniqueGenerations = new Set(state.aircraft.map(a => a.generation).filter(Boolean));

    animateNumber(document.getElementById('total-aircraft'), state.aircraft.length);
    animateNumber(document.getElementById('total-countries'), uniqueCountries.size);
    animateNumber(document.getElementById('total-generations'), uniqueGenerations.size);
  }

  /* =========================================================================
     FILTERS & SEARCH
     ========================================================================= */
  
  const searchInput = document.getElementById('search-input');
  let searchDebounceTimer = null;

  searchInput?.addEventListener('input', (e) => {
    state.filters.search = e.target.value.toLowerCase();
    state.currentPage = 1;
    clearTimeout(searchDebounceTimer);
    searchDebounceTimer = setTimeout(() => {
      saveFiltersToSession();
      applyFiltersAndRender();
    }, 300);
  });


  function applyFiltersAndRender() {
    let filtered = [...state.aircraft];

    // Apply search filter
    if (state.filters.search) {
      filtered = filtered.filter(aircraft => 
        aircraft.name?.toLowerCase().includes(state.filters.search) ||
        aircraft.complete_name?.toLowerCase().includes(state.filters.search) ||
        aircraft.country_name?.toLowerCase().includes(state.filters.search) ||
        aircraft.little_description?.toLowerCase().includes(state.filters.search)
      );
    }

    // Apply country filter
    if (state.filters.country) {
      filtered = filtered.filter(aircraft => aircraft.country_name === state.filters.country);
    }

    // Apply generation filter
    if (state.filters.generation) {
      filtered = filtered.filter(aircraft => aircraft.generation === parseInt(state.filters.generation));
    }

    // Apply type filter
    if (state.filters.type) {
      filtered = filtered.filter(aircraft => aircraft.type_name === state.filters.type);
    }

    // Apply sorting
    filtered = sortAircraft(filtered);

    state.filteredAircraft = filtered;
    renderAircraft();
    renderPagination();
    updateResultsCount();
  }

  function sortAircraft(aircraft) {
    switch (state.sort) {
      case 'alphabetical':
        return aircraft.sort((a, b) => a.name.localeCompare(b.name));
      case 'nation':
        return aircraft.sort((a, b) => (a.country_name || '').localeCompare(b.country_name || ''));
      case 'service-date':
        return aircraft.sort((a, b) => {
          const dateA = a.date_operationel ? new Date(a.date_operationel) : new Date(0);
          const dateB = b.date_operationel ? new Date(b.date_operationel) : new Date(0);
          return dateB - dateA;
        });
      case 'generation':
        return aircraft.sort((a, b) => (b.generation || 0) - (a.generation || 0));
      case 'type':
        return aircraft.sort((a, b) => (a.type_name || '').localeCompare(b.type_name || ''));
      default:
        return aircraft;
    }
  }

  function updateResultsCount() {
    const count = state.filteredAircraft.length;
    const text = count === 0 ? i18n.t('hangar.results_none') : 
                 count === 1 ? i18n.t('hangar.results_one') : 
                 i18n.t('hangar.results', { count });
    document.getElementById('results-count').textContent = text;
  }

  function updateActiveFilters() {
    const container = document.getElementById('active-filters');
    const filters = [];

    if (state.filters.country) {
      filters.push({ type: 'country', label: state.filters.country });
    }
    if (state.filters.generation) {
      filters.push({ type: 'generation', label: `${state.filters.generation}e Génération` });
    }
    if (state.filters.type) {
      filters.push({ type: 'type', label: state.filters.type });
    }

    if (filters.length === 0) {
      container.classList.add('hidden');
      container.innerHTML = '';
      return;
    }

    container.classList.remove('hidden');
    container.innerHTML = `
      <div class="active-filters-label">Filtres actifs:</div>
      ${filters.map(filter => `
        <div class="active-filter" data-type="${filter.type}">
          <span>${escapeHtml(filter.label)}</span>
          <button class="remove-filter-btn" data-filter-type="${filter.type}">
            <i class="fas fa-times"></i>
          </button>
        </div>
      `).join('')}
      <button class="clear-all-filters">
        Effacer tout
      </button>
    `;

    container.querySelectorAll('.remove-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => window.removeFilter(btn.dataset.filterType));
    });
    container.querySelector('.clear-all-filters')?.addEventListener('click', () => window.clearAllFilters());
  }

  window.removeFilter = (type) => {
    state.filters[type] = null;
    state.currentPage = 1;
    saveFiltersToSession();
    updateActiveFilters();
    loadAircraft();
  };

  window.clearAllFilters = () => {
    state.filters.country = null;
    state.filters.generation = null;
    state.filters.type = null;
    state.filters.search = '';
    state.currentPage = 1;
    saveFiltersToSession();
    updateActiveFilters();
    if (searchInput) searchInput.value = '';
    loadAircraft();
  };

  /* =========================================================================
     SESSION PERSISTENCE
     ========================================================================= */

  const SESSION_KEY = 'hangar_filters';

  function saveFiltersToSession() {
    sessionStorage.setItem(SESSION_KEY, JSON.stringify({
      filters: state.filters,
      sort: state.sort,
      currentPage: state.currentPage,
    }));
    writeStateToUrl();
  }

  function writeStateToUrl() {
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
    try { history.replaceState(null, '', url); } catch (e) { /* ignore */ }
  }

  function readStateFromUrl() {
    const p = new URLSearchParams(location.search);
    if (p.has('country')) state.filters.country = p.get('country');
    if (p.has('gen'))     state.filters.generation = Number(p.get('gen'));
    if (p.has('type'))    state.filters.type = p.get('type');
    if (p.has('q'))       state.filters.search = p.get('q');
    if (p.has('sort'))    state.sort = p.get('sort');
    if (p.has('view'))    state.view = p.get('view') === 'list' ? 'list' : 'grid';
    if (p.has('page'))    state.currentPage = Math.max(1, Number(p.get('page')) || 1);
  }

  window.addEventListener('popstate', () => {
    readStateFromUrl();
    if (searchInput && state.filters.search) searchInput.value = state.filters.search;
    if (sortSelect) sortSelect.value = state.sort;
    applyFiltersAndRender();
    updateActiveFilters();
  });

  function restoreFiltersFromSession() {
    const saved = sessionStorage.getItem(SESSION_KEY);
    if (!saved) return;
    try {
      const { filters, sort, currentPage } = JSON.parse(saved);
      if (filters) Object.assign(state.filters, filters);
      if (sort) state.sort = sort;
      if (currentPage) state.currentPage = currentPage;
    } catch (e) {
      sessionStorage.removeItem(SESSION_KEY);
    }
  }

  /* =========================================================================
     FILTER DROPDOWNS
     ========================================================================= */
  
  const filterButtons = {
    'country-filter-btn': 'country-dropdown',
    'generation-filter-btn': 'generation-dropdown',
    'type-filter-btn': 'type-dropdown'
  };

  // Stocker les timeouts pour pouvoir les annuler
  const dropdownTimeouts = new Map();

  Object.entries(filterButtons).forEach(([btnId, dropdownId]) => {
    document.getElementById(btnId)?.addEventListener('click', (e) => {
      e.stopPropagation();
      const dropdown = document.getElementById(dropdownId);
      const isOpen = dropdown.classList.contains('show');
      
      // Fermer tous les autres dropdowns sauf celui-ci
      closeAllDropdowns(dropdownId);
      
      if (!isOpen) {
        // Annuler tout timeout existant pour ce dropdown
        if (dropdownTimeouts.has(dropdownId)) {
          clearTimeout(dropdownTimeouts.get(dropdownId));
          dropdownTimeouts.delete(dropdownId);
        }
        
        // Ouvrir le dropdown
        dropdown.classList.remove('hidden');
        setTimeout(() => dropdown.classList.add('show'), 10);
      }
    });
  });

  document.querySelectorAll('.close-dropdown').forEach(btn => {
    btn.addEventListener('click', () => {
      closeAllDropdowns();
    });
  });

  function closeAllDropdowns(exceptId = null) {
    document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
      // Ne pas fermer le dropdown spécifié
      if (exceptId && dropdown.id === exceptId) {
        return;
      }
      
      dropdown.classList.remove('show');
      
      // Annuler tout timeout existant pour ce dropdown
      if (dropdownTimeouts.has(dropdown.id)) {
        clearTimeout(dropdownTimeouts.get(dropdown.id));
      }
      
      // Créer un nouveau timeout et le stocker
      const timeoutId = setTimeout(() => {
        dropdown.classList.add('hidden');
        dropdownTimeouts.delete(dropdown.id);
      }, 300);
      
      dropdownTimeouts.set(dropdown.id, timeoutId);
    });
  }

  document.addEventListener('click', (e) => {
    if (!e.target.closest('.filter-btn') && !e.target.closest('.filter-dropdown')) {
      closeAllDropdowns();
    }
  });

  // Prevent dropdown close when clicking inside
  document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
    dropdown.addEventListener('click', (e) => {
      e.stopPropagation();
    });
  });

  /* =========================================================================
     SORT & VIEW
     ========================================================================= */
  
  const sortSelect = document.getElementById('sort-select');
  sortSelect?.addEventListener('change', (e) => {
    state.sort = e.target.value;
    saveFiltersToSession();
    applyFiltersAndRender();
  });


  /* =========================================================================
     RENDERING
     ========================================================================= */
  
  function renderAircraft() {
    const container = document.getElementById('airplanes-container');
    const startIndex = (state.currentPage - 1) * state.itemsPerPage;
    const endIndex = startIndex + state.itemsPerPage;
    const pageAircraft = state.filteredAircraft.slice(startIndex, endIndex);

    if (pageAircraft.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-plane-slash"></i>
          <h3>Aucun avion trouvé</h3>
          <p>Essayez de modifier vos filtres ou votre recherche</p>
        </div>
      `;
      return;
    }

    container.innerHTML = pageAircraft.map(aircraft => `
      <article class="aircraft-card" data-id="${aircraft.id}" tabindex="0" role="link" aria-label="${escapeHtml(aircraft.name)}">
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
                ${aircraft.country_code && ALPHA3_TO_ALPHA2[aircraft.country_code] ? `<img class="country-flag" src="https://flagcdn.com/w40/${ALPHA3_TO_ALPHA2[aircraft.country_code]}.png" alt="${escapeHtml(aircraft.country_name)}" width="24" height="18">` : ''}
              </div>
            </div>
          </div>
          <p class="aircraft-description">
            ${escapeHtml(aircraft.little_description) || i18n.t('details.no_desc_available')}
          </p>
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
        </div>
      </article>
    `).join('');

    // Add click handlers - CORRECTED TO USE /details
    document.querySelectorAll('.aircraft-card').forEach(card => {
      card.addEventListener('click', () => {
        const id = card.dataset.id;
        window.location.href = `/details?id=${id}`;
      });

      // Keyboard navigation - Enter key
      card.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          const id = card.dataset.id;
          window.location.href = `/details?id=${id}`;
        }
      });
    });
  }


  function renderPagination() {
    const container = document.getElementById('pagination-container');
    const totalPages = Math.ceil(state.filteredAircraft.length / state.itemsPerPage);

    // Toujours afficher la pagination pour un meilleur feedback visuel
    if (totalPages === 0) {
      container.innerHTML = '';
      return;
    }

    container.innerHTML = `
      <button class="prev-page-btn" ${state.currentPage === 1 || totalPages === 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>
      <span class="page-info">${i18n.t('hangar.page_info', { current: state.currentPage, total: totalPages })}</span>
      <button class="next-page-btn" ${state.currentPage === totalPages || totalPages === 1 ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>
    `;

    container.querySelector('.prev-page-btn')?.addEventListener('click', () => window.changePage(state.currentPage - 1));
    container.querySelector('.next-page-btn')?.addEventListener('click', () => window.changePage(state.currentPage + 1));
  }

  window.changePage = (page) => {
    state.currentPage = page;
    renderAircraft();
    renderPagination();

    // Scroll au début de la toolbar (juste au-dessus des cartes)
    const toolbar = document.querySelector('.hangar-toolbar');
    const offset = toolbar ? toolbar.offsetTop - 80 : 0;
    window.scrollTo({ top: offset, behavior: 'smooth' });
  };

  /* =========================================================================
     MODAL
     ========================================================================= */
  
  const modal = document.getElementById('aircraft-modal');
  const modalForm = document.getElementById('aircraft-form');
  const addBtn = document.getElementById('add-airplane-btn');
  const cancelBtn = document.getElementById('cancel-btn');
  const modalClose = document.querySelector('.modal-close');

  addBtn?.addEventListener('click', () => {
    openModal();
  });

  [cancelBtn, modalClose].forEach(btn => {
    btn?.addEventListener('click', () => closeModal());
  });

  modal?.addEventListener('click', (e) => {
    if (e.target === modal || e.target.classList.contains('modal-backdrop')) {
      closeModal();
    }
  });

  function openModal() {
    modal?.classList.add('show');
    document.body.style.overflow = 'hidden';
  }

  function closeModal() {
    modal?.classList.remove('show');
    document.body.style.overflow = '';
    modalForm?.reset();
  }

  modalForm?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const payload = auth.getPayload();
    if (!payload) {
      showToast(i18n.t('common.unauthorized'), 'error');
      return;
    }

    const userRole = Number(payload.role);
    if (userRole !== 1 && userRole !== 2) {
      showToast(i18n.t('common.unauthorized'), 'error');
      return;
    }

    const formData = {
      name: document.getElementById('aircraft-name').value,
      complete_name: document.getElementById('aircraft-complete-name').value,
      little_description: document.getElementById('aircraft-little-description').value,
      image_url: document.getElementById('aircraft-image-url').value,
      description: document.getElementById('aircraft-description').value,
      country_id: parseInt(document.getElementById('aircraft-country').value),
      id_manufacturer: parseInt(document.getElementById('aircraft-manufacturer').value) || null,
      id_generation: parseInt(document.getElementById('aircraft-generation').value),
      type: parseInt(document.getElementById('aircraft-type').value),
      status: document.getElementById('aircraft-status').value,
      date_concept: document.getElementById('aircraft-date-concept').value || null,
      date_first_fly: document.getElementById('aircraft-date-first-fly').value || null,
      date_operationel: document.getElementById('aircraft-date-operational').value || null,
      max_speed: parseFloat(document.getElementById('aircraft-max-speed').value) || null,
      max_range: parseFloat(document.getElementById('aircraft-max-range').value) || null,
      weight: parseFloat(document.getElementById('aircraft-weight').value) || null
    };

    try {
      const response = await auth.authFetch('/api/airplanes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        throw new Error(i18n.t('common.create_error'));
      }

      showToast(i18n.t('common.added'), 'success');
      closeModal();
      loadAircraft();
      
    } catch (error) {
      // Erreur gérée via toast
      showToast(error.message || i18n.t('common.create_error'), 'error');
    }
  });

  /* =========================================================================
     KEYBOARD SHORTCUTS
     ========================================================================= */
  
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeModal();
      closeAllDropdowns();
    }
    
    if (e.key === '/' && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      searchInput?.focus();
    }
  });

  /* =========================================================================
     ANIMATIONS & PERFORMANCE
     ========================================================================= */

  // Reduce animations on low-power devices
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const observeElements = () => {
    // Skip animations if user prefers reduced motion
    if (prefersReducedMotion) {
      return;
    }

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
  };

  // Touch-friendly improvements
  let touchStartY = 0;
  let touchEndY = 0;

  // Add passive event listeners for better scroll performance
  document.addEventListener('touchstart', (e) => {
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  document.addEventListener('touchend', (e) => {
    touchEndY = e.changedTouches[0].screenY;
    handleSwipe();
  }, { passive: true });

  function handleSwipe() {
    const swipeThreshold = 100;
    const diff = touchStartY - touchEndY;

    // Close mobile menu on swipe up (when menu is open)
    if (diff > swipeThreshold && document.querySelector('.nav-links')?.classList.contains('show')) {
      nav.closeMenu();
    }
  }

  // Optimize scroll performance
  let ticking = false;
  window.addEventListener('scroll', () => {
    if (!ticking) {
      window.requestAnimationFrame(() => {
        // Your scroll logic here (already exists above)
        ticking = false;
      });
      ticking = true;
    }
  }, { passive: true });

  /* =========================================================================
     INITIALIZE
     ========================================================================= */
  
  // Initialize auth UI
  nav.updateAuthUI();

  // Show add button for admin/editor
  const payload = auth.getPayload();
  if (payload) {
    const userRole = Number(payload.role);
    if (userRole === 1 || userRole === 2) {
      document.getElementById('add-airplane-btn')?.classList.remove('hidden');
    }
  }

  // Restaurer les filtres/tri depuis la session avant le chargement
  restoreFiltersFromSession();
  if (searchInput && state.filters.search) searchInput.value = state.filters.search;
  if (sortSelect && state.sort !== 'default') sortSelect.value = state.sort;

  await loadReferentialData();
  await loadAircraft();

  // Afficher les filtres actifs restaurés
  updateActiveFilters();
  
  // Observe cards for animations
  const cardObserver = setInterval(() => {
    if (document.querySelectorAll('.aircraft-card').length > 0) {
      observeElements();
      clearInterval(cardObserver);
    }
  }, 100);

  // Re-render on language change (seulement si les données sont chargées)
  window.addEventListener('langChanged', () => {
    updateResultsCount();
    if (state.aircraft.length > 0) renderAircraft();
  });

  /* =========================================================================
     V2 — URL state, facet counts, compare, view toggle, mobile sheet
     ========================================================================= */

  // Apply URL state on first load (overrides session)
  readStateFromUrl();
  if (searchInput && state.filters.search) searchInput.value = state.filters.search;
  if (sortSelect) sortSelect.value = state.sort;
  applyFiltersAndRender();
  updateActiveFilters();

  // --- Facet counts ----------------------------------------------------------
  async function fetchFacets() {
    const p = new URLSearchParams();
    if (state.filters.country)    p.set('country', state.filters.country);
    if (state.filters.generation) p.set('generation', String(state.filters.generation));
    if (state.filters.type)       p.set('type', state.filters.type);
    try {
      const res = await fetch('/api/airplanes/facets?' + p.toString());
      if (!res.ok) return;
      state.facets = await res.json();
      decorateFacetCounts();
    } catch (_) { /* ignore */ }
  }

  function decorateFacetCounts() {
    if (!state.facets) return;
    document.querySelectorAll('#country-options .filter-option').forEach(el => {
      const name = el.dataset.value;
      const n = state.facets.countries[name] || 0;
      let tag = el.querySelector('.fc');
      if (!tag) { tag = document.createElement('span'); tag.className = 'fc'; el.appendChild(tag); }
      tag.textContent = ' (' + n + ')';
      el.classList.toggle('filter-option-empty', n === 0);
    });
    document.querySelectorAll('#generation-options .filter-option').forEach(el => {
      const g = Number(el.dataset.value);
      const n = state.facets.generations[g] || 0;
      let tag = el.querySelector('.fc');
      if (!tag) { tag = document.createElement('span'); tag.className = 'fc'; el.appendChild(tag); }
      tag.textContent = ' (' + n + ')';
      el.classList.toggle('filter-option-empty', n === 0);
    });
    document.querySelectorAll('#type-options .filter-option').forEach(el => {
      const name = el.dataset.value;
      const n = state.facets.types[name] || 0;
      let tag = el.querySelector('.fc');
      if (!tag) { tag = document.createElement('span'); tag.className = 'fc'; el.appendChild(tag); }
      tag.textContent = ' (' + n + ')';
      el.classList.toggle('filter-option-empty', n === 0);
    });
  }

  fetchFacets();
  // Re-fetch facets whenever filters change
  const origSave = saveFiltersToSession;
  saveFiltersToSession = function () { origSave(); fetchFacets(); };

  // --- View toggle -----------------------------------------------------------
  (function setupViewToggle() {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

    // Inject toggle buttons into toolbar-right before the sort-select
    const toolbar = document.querySelector('.toolbar-right');
    const sortSel = document.getElementById('sort-select');
    if (toolbar && sortSel && !document.getElementById('view-toggle')) {
      const wrap = document.createElement('div');
      wrap.id = 'view-toggle';
      wrap.className = 'view-toggle';
      wrap.setAttribute('role', 'group');
      wrap.setAttribute('aria-label', 'Vue');
      wrap.innerHTML =
        '<button id="view-grid" class="view-btn" aria-pressed="true" aria-label="Vue grille"><i class="fas fa-th"></i></button>' +
        '<button id="view-list" class="view-btn" aria-pressed="false" aria-label="Vue liste"><i class="fas fa-list"></i></button>';
      toolbar.insertBefore(wrap, sortSel);
    }

    function applyView() {
      container.classList.toggle('aircraft-list', state.view === 'list');
      container.classList.toggle('aircraft-grid', state.view === 'grid');
      const g = document.getElementById('view-grid');
      const l = document.getElementById('view-list');
      if (g) g.setAttribute('aria-pressed', String(state.view === 'grid'));
      if (l) l.setAttribute('aria-pressed', String(state.view === 'list'));
    }
    applyView();

    document.getElementById('view-grid')?.addEventListener('click', () => {
      state.view = 'grid';
      localStorage.setItem('vh_hangar_view', 'grid');
      applyView();
      writeStateToUrl();
    });
    document.getElementById('view-list')?.addEventListener('click', () => {
      state.view = 'list';
      localStorage.setItem('vh_hangar_view', 'list');
      applyView();
      writeStateToUrl();
    });
  })();

  // --- Compare mode ----------------------------------------------------------
  (function setupCompare() {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

    function addCheckboxes() {
      container.querySelectorAll('.aircraft-card').forEach(card => {
        if (card.querySelector('.compare-check')) return;
        const id = Number(card.dataset.id);
        const label = document.createElement('label');
        label.className = 'compare-check';
        label.innerHTML =
          '<input type="checkbox" data-compare-id="' + id + '"' +
          (state.compareIds.includes(id) ? ' checked' : '') + '>' +
          '<span>Comparer</span>';
        label.addEventListener('click', e => e.stopPropagation());
        card.appendChild(label);
      });
    }

    // Observe container re-renders
    const mo = new MutationObserver(addCheckboxes);
    mo.observe(container, { childList: true });
    addCheckboxes();

    container.addEventListener('change', e => {
      const cb = e.target.closest('[data-compare-id]');
      if (!cb) return;
      const id = Number(cb.dataset.compareId);
      if (cb.checked) {
        if (state.compareIds.length >= 3) {
          cb.checked = false;
          if (typeof showToast === 'function') showToast('Maximum 3 avions en comparaison', 'warning');
          return;
        }
        state.compareIds.push(id);
      } else {
        state.compareIds = state.compareIds.filter(x => x !== id);
      }
      localStorage.setItem('vh_compare_ids', JSON.stringify(state.compareIds));
      renderCompareBar();
    });

    // Floating bar + modal
    let bar = document.getElementById('compare-bar');
    if (!bar) {
      bar = document.createElement('div');
      bar.id = 'compare-bar';
      bar.className = 'compare-bar hidden';
      bar.innerHTML =
        '<span id="compare-count">0 sélectionnés</span>' +
        '<button id="compare-clear" class="btn btn-secondary btn-sm">Effacer</button>' +
        '<button id="compare-view" class="btn btn-primary btn-sm">Voir la comparaison</button>';
      document.body.appendChild(bar);

      const dlg = document.createElement('dialog');
      dlg.id = 'compare-modal';
      dlg.className = 'compare-modal';
      dlg.innerHTML =
        '<button class="compare-modal-close" aria-label="Fermer"><i class="fas fa-times"></i></button>' +
        '<div id="compare-modal-body"></div>';
      document.body.appendChild(dlg);
    }

    window.renderCompareBar = function () {
      const n = state.compareIds.length;
      bar.classList.toggle('hidden', n === 0);
      const cnt = document.getElementById('compare-count');
      if (cnt) cnt.textContent = n + ' sélectionné' + (n > 1 ? 's' : '');
    };

    document.getElementById('compare-clear').addEventListener('click', () => {
      state.compareIds = [];
      localStorage.setItem('vh_compare_ids', '[]');
      container.querySelectorAll('[data-compare-id]').forEach(cb => { cb.checked = false; });
      renderCompareBar();
    });

    document.getElementById('compare-view').addEventListener('click', async () => {
      if (state.compareIds.length === 0) return;
      try {
        const items = await Promise.all(
          state.compareIds.map(id => fetch('/api/airplanes/' + id).then(r => r.json()))
        );
        const fields = [
          ['Image',         a => a.image_url ? '<img src="' + escapeHtml(a.image_url) + '" alt="" style="width:100%;max-height:120px;object-fit:cover;border-radius:4px">' : '-'],
          ['Nom',           a => escapeHtml(a.name || '-')],
          ['Pays',          a => escapeHtml(a.country_name || '-')],
          ['Constructeur',  a => escapeHtml(a.manufacturer_name || '-')],
          ['Génération',    a => a.generation ? a.generation + 'e' : '-'],
          ['Type',          a => escapeHtml(a.type_name || '-')],
          ['Vitesse max',   a => a.max_speed ? a.max_speed + ' km/h' : '-'],
          ['Portée max',    a => a.max_range ? a.max_range + ' km' : '-'],
          ['Poids',         a => a.weight ? a.weight + ' kg' : '-'],
          ['Statut',        a => escapeHtml(a.status || '-')],
        ];
        const rows = fields.map(f =>
          '<tr><th>' + f[0] + '</th>' + items.map(a => '<td>' + f[1](a) + '</td>').join('') + '</tr>'
        ).join('');
        document.getElementById('compare-modal-body').innerHTML =
          '<h2 style="margin-bottom:16px">Comparaison</h2>' +
          '<table class="compare-table"><tbody>' + rows + '</tbody></table>';
        document.getElementById('compare-modal').showModal();
      } catch (err) { /* ignore */ }
    });

    document.querySelector('#compare-modal .compare-modal-close').addEventListener('click', () => {
      document.getElementById('compare-modal').close();
    });

    renderCompareBar();
  })();

  // --- Mobile filter sheet ---------------------------------------------------
  (function setupMobileSheet() {
    function isMobile() { return window.matchMedia('(max-width: 767px)').matches; }
    if (document.getElementById('filter-sheet')) return;

    const dlg = document.createElement('dialog');
    dlg.id = 'filter-sheet';
    dlg.className = 'filter-sheet';
    dlg.innerHTML =
      '<div class="filter-sheet-header"><h3>Filtres</h3><button class="filter-sheet-close" aria-label="Fermer"><i class="fas fa-times"></i></button></div>' +
      '<div class="filter-sheet-tabs">' +
        '<button class="fs-tab active" data-tab="country">Pays</button>' +
        '<button class="fs-tab" data-tab="generation">Génération</button>' +
        '<button class="fs-tab" data-tab="type">Type</button>' +
      '</div>' +
      '<div class="filter-sheet-body"></div>' +
      '<div class="filter-sheet-footer"><button class="btn btn-primary" id="fs-apply">Appliquer</button></div>';
    document.body.appendChild(dlg);

    let currentTab = 'country';

    function renderTab() {
      const body = dlg.querySelector('.filter-sheet-body');
      dlg.querySelectorAll('.fs-tab').forEach(t =>
        t.classList.toggle('active', t.dataset.tab === currentTab));
      let items = [];
      if (currentTab === 'country')    items = state.countries.map(c => ({ k: c.name, l: c.name }));
      if (currentTab === 'generation') items = state.generations.map(g => ({ k: g, l: g + 'e Génération' }));
      if (currentTab === 'type')       items = state.types.map(t => ({ k: t.name, l: t.name }));
      body.innerHTML = items.map(it => {
        const active = String(state.filters[currentTab]) === String(it.k);
        return '<button class="fs-item' + (active ? ' active' : '') +
               '" data-key="' + escapeHtml(String(it.k)) + '">' + escapeHtml(it.l) + '</button>';
      }).join('');
      body.querySelectorAll('.fs-item').forEach(btn => {
        btn.addEventListener('click', () => {
          const k = btn.dataset.key;
          state.filters[currentTab] = String(state.filters[currentTab]) === k ? null : (currentTab === 'generation' ? Number(k) : k);
          renderTab();
        });
      });
    }

    dlg.querySelectorAll('.fs-tab').forEach(t => {
      t.addEventListener('click', () => { currentTab = t.dataset.tab; renderTab(); });
    });
    dlg.querySelector('.filter-sheet-close').addEventListener('click', () => dlg.close());
    dlg.querySelector('#fs-apply').addEventListener('click', () => {
      dlg.close();
      state.currentPage = 1;
      saveFiltersToSession();
      applyFiltersAndRender();
      updateActiveFilters();
    });

    ['country-filter-btn', 'generation-filter-btn', 'type-filter-btn'].forEach(id => {
      const btn = document.getElementById(id);
      if (!btn) return;
      btn.addEventListener('click', e => {
        if (isMobile()) {
          e.stopImmediatePropagation();
          e.preventDefault();
          currentTab = id.split('-')[0];
          renderTab();
          try { dlg.showModal(); } catch (_) { dlg.setAttribute('open', ''); }
        }
      }, true);
    });
  })();

});