document.addEventListener("DOMContentLoaded", async () => {
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
    view: 'grid',
    countries: [],
    generations: [],
    types: [],
    manufacturers: []
  };

  /* =========================================================================
     UTILITIES
     ========================================================================= */

  function escapeHtml(text) {
    if (text == null) return '';
    const div = document.createElement('div');
    div.textContent = String(text);
    return div.innerHTML;
  }

  function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    const icon = type === 'success' ? 'check-circle' : 
                 type === 'error' ? 'exclamation-circle' : 
                 'info-circle';
    
    toast.innerHTML = `
      <i class="fas fa-${icon}"></i>
      <span>${escapeHtml(message)}</span>
    `;
    
    container.appendChild(toast);
    
    setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  /* =========================================================================
     NAVIGATION & AUTH
     ========================================================================= */
  
  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.querySelector('.user-dropdown');

  // Header scroll effect
  let lastScroll = 0;
  window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
    
    lastScroll = currentScroll;
  });

  // Mobile menu toggle
  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Close mobile menu on link click (except login icon)
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', (e) => {
      // Ne pas fermer le menu si c'est l'icône de login
      if (link.id === 'login-icon') {
        return;
      }
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close mobile menu on window resize
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      if (window.innerWidth > 992) {
        navLinks?.classList.remove('show');
        hamburger?.classList.remove('active');
        document.body.style.overflow = '';
        closeAllDropdowns();
      }
    }, 250); // Debounce resize events
  });

  // User Authentication & Menu
  const updateAuthUI = () => {
    const payload = auth.getPayload();
    
    if (payload) {
      const userNameEl = document.getElementById('user-name');
      const userRoleEl = document.querySelector('.user-role');
      
      if (userNameEl) {
        userNameEl.textContent = payload.name || i18n.t('nav.user_default');
      }
      
      if (userRoleEl) {
        const role = Number(payload.role);
        userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') :
                                 role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
      }
      
      userDropdown?.classList.remove('hidden');

      // Show add button for admin/editor
      const userRole = Number(payload.role);
      if (userRole === 1 || userRole === 2) {
        document.getElementById('add-airplane-btn')?.classList.remove('hidden');
      }
    }
  };

  // User dropdown toggle
  userToggle?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    if (userDropdown?.classList.contains('show')) {
      userDropdown.classList.remove('show');
      setTimeout(() => {
        userDropdown.classList.add('hidden');
      }, 300);
    } else {
      userDropdown?.classList.remove('hidden');
      setTimeout(() => {
        userDropdown?.classList.add('show');
      }, 10);
    }
  });

  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!userToggle?.contains(e.target) && !userDropdown?.contains(e.target)) {
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
    }
  });

  // Login redirect
  loginIcon?.addEventListener('click', (e) => {
    if (!auth.getToken()) {
      e.preventDefault();
      window.location.href = '/login';
    }
  });

  // Settings navigation
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = '/settings';
  });

  // Logout handlers
  const logoutButtons = document.querySelectorAll('#logout-icon, #logout-btn');
  logoutButtons.forEach(btn => {
    btn?.addEventListener('click', async (e) => {
      e.preventDefault();
      await auth.logout();
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => {
        window.location.href = '/';
      }, 1000);
    });
  });

  // Keyboard navigation - ESC to close menus
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
      document.body.style.overflow = '';
    }
  });

  /* =========================================================================
     DATA LOADING
     ========================================================================= */
  
  async function loadReferentialData() {
    try {
      const [countriesRes, generationsRes, typesRes, manufacturersRes] = await Promise.all([
        fetch('/api/countries'),
        fetch('/api/generations'),
        fetch('/api/types'),
        fetch('/api/manufacturers')
      ]);

      state.countries = await countriesRes.json();
      state.generations = await generationsRes.json();
      state.types = await typesRes.json();
      state.manufacturers = await manufacturersRes.json();

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
        
        applyFiltersAndRender();
        closeAllDropdowns();
        updateActiveFilters();
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
        state.generations.map((g, i) => `<option value="${i + 1}">${g}e Génération</option>`).join('');
    }

    if (typeSelect) {
      typeSelect.innerHTML = `<option value="">${i18n.t('hangar.select')}</option>` +
        state.types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
    }
  }

  async function loadAircraft() {
    showSkeletonLoaders();
    
    try {
      const params = new URLSearchParams({
        sort: state.sort,
        ...(state.filters.country && { country: state.filters.country }),
        ...(state.filters.generation && { generation: state.filters.generation }),
        ...(state.filters.type && { type: state.filters.type })
      });

      const response = await fetch(`/api/airplanes?${params}`);
      const data = await response.json();
      
      state.aircraft = data.data || [];
      applyFiltersAndRender();
      updateStats();
      
    } catch (error) {
      console.error('Error loading aircraft:', error);
      showToast(i18n.t('common.loading_error'), 'error');
      hideSkeletonLoaders();
    }
  }

  function showSkeletonLoaders() {
    const container = document.getElementById('airplanes-container');
    container.innerHTML = Array(8).fill(0).map(() => `
      <div class="aircraft-card skeleton">
        <div class="skeleton-image"></div>
        <div class="skeleton-content">
          <div class="skeleton-title"></div>
          <div class="skeleton-text"></div>
          <div class="skeleton-text short"></div>
        </div>
      </div>
    `).join('');
  }

  function hideSkeletonLoaders() {
    const skeletons = document.querySelectorAll('.skeleton');
    skeletons.forEach(skeleton => skeleton.remove());
  }

  function animateNumber(el, target) {
    if (!el) return;
    const duration = 1400;
    const start = performance.now();
    function step(now) {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.round(eased * target);
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
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

  searchInput?.addEventListener('input', (e) => {
    state.filters.search = e.target.value.toLowerCase();
    state.currentPage = 1;
    applyFiltersAndRender();
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
      return;
    }

    container.classList.remove('hidden');
    container.innerHTML = `
      <div class="active-filters-label">Filtres actifs:</div>
      ${filters.map(filter => `
        <div class="active-filter" data-type="${filter.type}">
          <span>${escapeHtml(filter.label)}</span>
          <button onclick="removeFilter('${filter.type}')">
            <i class="fas fa-times"></i>
          </button>
        </div>
      `).join('')}
      <button class="clear-all-filters" onclick="clearAllFilters()">
        Effacer tout
      </button>
    `;
  }

  window.removeFilter = (type) => {
    state.filters[type] = null;
    state.currentPage = 1;
    applyFiltersAndRender();
    updateActiveFilters();
  };

  window.clearAllFilters = () => {
    state.filters.country = null;
    state.filters.generation = null;
    state.filters.type = null;
    state.currentPage = 1;
    applyFiltersAndRender();
    updateActiveFilters();
  };

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
    applyFiltersAndRender();
  });

  const viewButtons = document.querySelectorAll('.view-btn');
  viewButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const view = btn.dataset.view;
      state.view = view;

      viewButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const container = document.getElementById('airplanes-container');
      container.className = view === 'grid' ? 'aircraft-grid' : 'aircraft-list';

      // Save view preference
      localStorage.setItem('preferredView', view);
    });
  });

  // Restore view preference on load
  const savedView = localStorage.getItem('preferredView');
  if (savedView && window.innerWidth > 768) {
    const viewBtn = document.querySelector(`.view-btn[data-view="${savedView}"]`);
    if (viewBtn) {
      viewBtn.click();
    }
  }

  /* =========================================================================
     RENDERING
     ========================================================================= */
  
  function renderAircraft() {
    const container = document.getElementById('airplanes-container');
    const startIndex = (state.currentPage - 1) * state.itemsPerPage;
    const endIndex = startIndex + state.itemsPerPage;
    const pageAircraft = state.filteredAircraft.slice(startIndex, endIndex);

    hideSkeletonLoaders();

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
      <article class="aircraft-card" data-id="${aircraft.id}">
        <div class="aircraft-image">
          <img src="${escapeHtml(aircraft.image_url) || 'https://via.placeholder.com/400x300?text=No+Image'}" 
               alt="${escapeHtml(aircraft.name)}"
               loading="lazy">
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
              <h3>${escapeHtml(aircraft.name)}</h3>
              ${aircraft.country_name ? `
                <div class="aircraft-country">
                  <i class="fas fa-globe"></i>
                  <span>${escapeHtml(aircraft.country_name)}</span>
                </div>
              ` : ''}
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
      <button ${state.currentPage === 1 || totalPages === 1 ? 'disabled' : ''} onclick="changePage(${state.currentPage - 1})">
        <i class="fas fa-chevron-left"></i> Précédent
      </button>
      <span class="page-info">Page ${state.currentPage} sur ${totalPages}</span>
      <button ${state.currentPage === totalPages || totalPages === 1 ? 'disabled' : ''} onclick="changePage(${state.currentPage + 1})">
        Suivant <i class="fas fa-chevron-right"></i>
      </button>
    `;
  }

  window.changePage = (page) => {
    state.currentPage = page;
    renderAircraft();
    renderPagination();

    // Scroll to top of content, accounting for sticky header
    const filtersSection = document.querySelector('.filters-section');
    const offset = filtersSection ? filtersSection.offsetTop - 70 : 0;
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
    if (diff > swipeThreshold && navLinks?.classList.contains('show')) {
      navLinks.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
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
  updateAuthUI();
  
  await loadReferentialData();
  await loadAircraft();
  
  // Observe cards for animations
  const cardObserver = setInterval(() => {
    if (document.querySelectorAll('.aircraft-card').length > 0) {
      observeElements();
      clearInterval(cardObserver);
    }
  }, 100);

  // Re-render on language change
  window.addEventListener('langChanged', () => {
    updateResultsCount();
    renderAircraft();
  });

  console.log('Hangar page initialized successfully');
});