document.addEventListener("DOMContentLoaded", async () => {
  /* =========================================================================
     UTILITIES
     ========================================================================= */

  function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;

    const icon = type === 'success' ? 'check-circle' :
                 type === 'error' ? 'exclamation-circle' :
                 'info-circle';

    toast.innerHTML = `
      <i class="fas fa-${icon}"></i>
      <span>${message}</span>
    `;

    container.appendChild(toast);

    setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
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
     NAVIGATION & AUTH
     ========================================================================= */

  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.querySelector('.user-dropdown');

  // Header scroll effect
  window.addEventListener('scroll', () => {
    if (window.pageYOffset > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // Mobile menu toggle
  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Close mobile menu on link click
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => {
      if (link.id === 'login-icon') return;
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close mobile menu on resize
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      if (window.innerWidth > 992) {
        navLinks?.classList.remove('show');
        hamburger?.classList.remove('active');
        document.body.style.overflow = '';
      }
    }, 250);
  });

  // Token expiration check utility
  function isTokenExpired(token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      if (!payload.exp) return false;
      // exp is in seconds, Date.now() in ms — add 30s buffer
      return Date.now() >= payload.exp * 1000;
    } catch {
      return true;
    }
  }

  // User Authentication & Menu
  let token = localStorage.getItem('token');
  let currentUser = null;

  // If the token exists but is expired, clean up and treat as logged out
  if (token && isTokenExpired(token)) {
    console.warn('Token expiré, nettoyage de la session');
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    token = null;
  }

  if (token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      currentUser = payload;

      const userNameEl = document.getElementById('user-name');
      const userRoleEl = document.querySelector('.user-role');

      if (userNameEl) userNameEl.textContent = payload.name || i18n.t('nav.user_default');
      if (userRoleEl) {
        const role = Number(payload.role);
        userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') :
                                 role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
      }

      userDropdown?.classList.remove('hidden');
    } catch (error) {
      console.error('Token parsing error:', error);
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    }
  }

  // User dropdown toggle
  userToggle?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (userDropdown?.classList.contains('show')) {
      userDropdown.classList.remove('show');
      setTimeout(() => userDropdown.classList.add('hidden'), 300);
    } else {
      userDropdown?.classList.remove('hidden');
      setTimeout(() => userDropdown?.classList.add('show'), 10);
    }
  });

  document.addEventListener('click', (e) => {
    if (!userToggle?.contains(e.target) && !userDropdown?.contains(e.target)) {
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
    }
  });

  loginIcon?.addEventListener('click', (e) => {
    if (!token) { e.preventDefault(); window.location.href = '/login'; }
  });

  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault(); window.location.href = '/settings';
  });

  document.querySelectorAll('#logout-icon, #logout-btn').forEach(btn => {
    btn?.addEventListener('click', (e) => {
      e.preventDefault();
      localStorage.removeItem('token');
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => { window.location.href = '/'; }, 1000);
    });
  });

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
     AUTH GATE
     ========================================================================= */

  const authGate = document.getElementById('auth-gate');
  const favoritesContent = document.getElementById('favorites-content');

  if (!token || !currentUser) {
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
    search: ''
  };

  /* =========================================================================
     DATA LOADING
     ========================================================================= */

  async function loadFavorites() {
    showSkeletonLoaders();

    try {
      const response = await fetch('/api/favorites', {
        headers: { 'Authorization': `Bearer ${token}` }
      });

      if (response.status === 401 || response.status === 403) {
        showToast(i18n.t('common.session_expired'), 'error');
        localStorage.removeItem('token');
        setTimeout(() => { window.location.href = '/login'; }, 1500);
        return;
      }

      if (!response.ok) throw new Error('Erreur serveur');

      state.favorites = await response.json();
      applyFiltersAndRender();
      updateStats();

    } catch (error) {
      console.error('Error loading favorites:', error);
      showToast(i18n.t('common.loading_error'), 'error');
      hideSkeletonLoaders();
    }
  }

  function showSkeletonLoaders() {
    const container = document.getElementById('favorites-container');
    container.innerHTML = Array(6).fill(0).map(() => `
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
    document.querySelectorAll('.skeleton').forEach(s => s.remove());
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

    hideSkeletonLoaders();

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
      <article class="aircraft-card" data-id="${aircraft.id}">
        <button class="favorite-remove" data-airplane-id="${aircraft.id}" title="${i18n.t('details.remove_favorite')}">
          <i class="fas fa-heart-broken"></i>
        </button>
        <div class="aircraft-image">
          <img src="${aircraft.image_url || 'https://via.placeholder.com/400x300?text=No+Image'}"
               alt="${aircraft.name}"
               loading="lazy">
          <div class="aircraft-overlay">
            <div class="aircraft-badges">
              ${aircraft.generation ? `<span class="aircraft-badge generation">${aircraft.generation}e Gén</span>` : ''}
              ${aircraft.type_name ? `<span class="aircraft-badge type">${aircraft.type_name}</span>` : ''}
            </div>
          </div>
        </div>
        <div class="aircraft-content">
          <div class="aircraft-header">
            <div class="aircraft-title">
              <h3>${aircraft.name}</h3>
              ${aircraft.country_name ? `
                <div class="aircraft-country">
                  <i class="fas fa-globe"></i>
                  <span>${aircraft.country_name}</span>
                </div>
              ` : ''}
            </div>
          </div>
          <p class="aircraft-description">
            ${aircraft.little_description || i18n.t('details.no_desc_available')}
          </p>
          <div class="aircraft-specs">
            ${aircraft.max_speed ? `
              <div class="spec-item">
                <i class="fas fa-gauge-high"></i>
                <span>${aircraft.max_speed} km/h</span>
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

    // Remove from favorites
    container.querySelectorAll('.favorite-remove').forEach(btn => {
      btn.addEventListener('click', async (e) => {
        e.stopPropagation();
        const airplaneId = btn.dataset.airplaneId;
        await removeFavorite(airplaneId);
      });
    });
  }

  /* =========================================================================
     REMOVE FAVORITE
     ========================================================================= */

  async function removeFavorite(airplaneId) {
    try {
      const response = await fetch(`/api/favorites/${airplaneId}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      });

      if (!response.ok) throw new Error('Erreur');

      // Remove from state
      state.favorites = state.favorites.filter(a => a.id !== parseInt(airplaneId));

      // Animate card removal
      const card = document.querySelector(`.aircraft-card[data-id="${airplaneId}"]`);
      if (card) {
        card.style.transition = 'all 0.4s ease';
        card.style.transform = 'scale(0.8)';
        card.style.opacity = '0';
        setTimeout(() => {
          applyFiltersAndRender();
          updateStats();
        }, 400);
      } else {
        applyFiltersAndRender();
        updateStats();
      }

      showToast(i18n.t('common.favorite_removed'), 'success');

    } catch (error) {
      console.error('Error removing favorite:', error);
      showToast(i18n.t('common.delete_error'), 'error');
    }
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

  console.log('Favoris page initialized successfully');
});