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
    manufacturers: []
  };

  /* escapeHtml, showToast, animateNumber → utils.js | navigation → nav.js */

  /* =========================================================================
     DATA LOADING
     ========================================================================= */
  
  async function loadReferentialData() {
    try {
      const [countriesRes, generationsRes, typesRes, manufacturersRes] = await Promise.all([
        auth.fetchWithTimeout('/api/countries'),
        auth.fetchWithTimeout('/api/generations'),
        auth.fetchWithTimeout('/api/types'),
        auth.fetchWithTimeout('/api/manufacturers')
      ]);

      if (!countriesRes.ok || !generationsRes.ok || !typesRes.ok || !manufacturersRes.ok) {
        throw new Error('Erreur chargement référentiels');
      }

      const [countries, generations, types, manufacturers] = await Promise.all([
        countriesRes.json(), generationsRes.json(), typesRes.json(), manufacturersRes.json()
      ]);

      state.countries = Array.isArray(countries) ? countries : [];
      state.generations = Array.isArray(generations) ? generations : [];
      state.types = Array.isArray(types) ? types : [];
      state.manufacturers = Array.isArray(manufacturers) ? manufacturers : [];

      populateFilterOptions();
      populateFormSelects();
    } catch (error) {
      console.error('Error loading referential data:', error);
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
      console.error('Error loading aircraft:', error);
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
  }

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
                ${aircraft.country_code && ALPHA3_TO_ALPHA2[aircraft.country_code] ? `<img class="country-flag" src="https://flagcdn.com/w40/${ALPHA3_TO_ALPHA2[aircraft.country_code]}.png" alt="${escapeHtml(aircraft.country_name)}" width="20" height="15">` : ''}
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
      console.error('Error creating aircraft:', error);
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

});