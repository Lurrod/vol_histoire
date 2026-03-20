document.addEventListener("DOMContentLoaded", async () => {

  /* =========================================================================
     STATE
     ========================================================================= */

  const state = {
    allAircraft: [],
    filteredAircraft: [],
    currentGeneration: 'all',
    decades: [],
    currentPanelIndex: 0
  };

  /* =========================================================================
     ERA CONFIG
     ========================================================================= */

  const eraConfig = {
    1940: { color: '#d4a017', get label() { return i18n.t('timeline.era_1940_label'); }, get desc() { return i18n.t('timeline.era_1940_desc'); } },
    1950: { color: '#3aff6e', get label() { return i18n.t('timeline.era_1950_label'); }, get desc() { return i18n.t('timeline.era_1950_desc'); } },
    1960: { color: '#ff8c00', get label() { return i18n.t('timeline.era_1960_label'); }, get desc() { return i18n.t('timeline.era_1960_desc'); } },
    1970: { color: '#ff4500', get label() { return i18n.t('timeline.era_1970_label'); }, get desc() { return i18n.t('timeline.era_1970_desc'); } },
    1980: { color: '#00e5ff', get label() { return i18n.t('timeline.era_1980_label'); }, get desc() { return i18n.t('timeline.era_1980_desc'); } },
    1990: { color: '#7b5cf0', get label() { return i18n.t('timeline.era_1990_label'); }, get desc() { return i18n.t('timeline.era_1990_desc'); } },
    2000: { color: '#2979ff', get label() { return i18n.t('timeline.era_2000_label'); }, get desc() { return i18n.t('timeline.era_2000_desc'); } },
    2010: { color: '#e040fb', get label() { return i18n.t('timeline.era_2010_label'); }, get desc() { return i18n.t('timeline.era_2010_desc'); } },
    2020: { color: '#ff3d6e', get label() { return i18n.t('timeline.era_2020_label'); }, get desc() { return i18n.t('timeline.era_2020_desc'); } }
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
    const icon = type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle';
    toast.innerHTML = `<i class="fas fa-${icon}"></i><span>${escapeHtml(message)}</span>`;
    container.appendChild(toast);
    setTimeout(() => { toast.classList.add('fade-out'); setTimeout(() => toast.remove(), 300); }, 3000);
  }

  function getDecade(year) { return Math.floor(year / 10) * 10; }

  /* =========================================================================
     NAVIGATION & AUTH
     ========================================================================= */

  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.querySelector('.user-dropdown');

  window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.pageYOffset > 100);
  }, { passive: true });

  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', (e) => {
      if (link.id === 'login-icon') return;
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

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

  const updateAuthUI = () => {
    const payload = auth.getPayload();
    if (payload) {
      const userNameEl = document.getElementById('user-name');
      const userRoleEl = document.querySelector('.user-role');
      if (userNameEl) userNameEl.textContent = payload.name || i18n.t('nav.user_default');
      if (userRoleEl) {
        const role = Number(payload.role);
        userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') : role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
      }
      userDropdown?.classList.remove('hidden');
    }
  };

  userToggle?.addEventListener('click', (e) => {
    e.preventDefault(); e.stopPropagation();
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
    if (!auth.getToken()) { e.preventDefault(); window.location.href = '/login'; }
  });

  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault(); window.location.href = '/settings';
  });

  document.querySelectorAll('#logout-icon, #logout-btn').forEach(btn => {
    btn?.addEventListener('click', async (e) => {
      e.preventDefault();
      await auth.logout();
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => window.location.href = '/', 1000);
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
    if (e.key === 'ArrowRight') scrollPanel(1);
    if (e.key === 'ArrowLeft') scrollPanel(-1);
  });

  updateAuthUI();

  /* =========================================================================
     LOAD DATA
     ========================================================================= */

  async function loadAllAircraft() {
    try {
      const page1Response = await fetch('/api/airplanes?sort=service-date&page=1');
      const page1Data = await page1Response.json();
      let aircraft = page1Data.data || [];
      const totalPages = page1Data.pagination?.totalPages || 1;

      if (totalPages > 1) {
        const promises = [];
        for (let i = 2; i <= totalPages; i++) {
          promises.push(fetch(`/api/airplanes?sort=service-date&page=${i}`));
        }
        const responses = await Promise.all(promises);
        const pagesData = await Promise.all(responses.map(res => res.json()));
        pagesData.forEach(pageData => { aircraft = aircraft.concat(pageData.data || []); });
      }

      state.allAircraft = aircraft
        .filter(a => a.date_operationel)
        .sort((a, b) => new Date(a.date_operationel) - new Date(b.date_operationel));

      state.filteredAircraft = [...state.allAircraft];

      const years = state.allAircraft.map(a => new Date(a.date_operationel).getFullYear());
      const minYear = Math.min(...years);
      const maxYear = Math.max(...years);

      state.decades = [];
      for (let d = getDecade(minYear); d <= getDecade(maxYear); d += 10) {
        state.decades.push(d);
      }

      updateStats();
      renderDecadeNav();
      renderTimeline();

      document.getElementById('loading-state').style.display = 'none';

    } catch (error) {
      console.error('Error loading aircraft:', error);
      showToast(i18n.t('common.loading_error'), 'error');
      document.getElementById('loading-state').innerHTML =
        '<p style="color:#e74c3c;font-family:\'Share Tech Mono\',monospace;font-size:0.8rem;letter-spacing:2px">ERREUR — DONNÉES INACCESSIBLES</p>';
    }
  }

  function updateStats() {
    const totalAircraft = state.allAircraft.length;
    const years = state.allAircraft.map(a => new Date(a.date_operationel).getFullYear());
    const yearRange = Math.max(...years) - Math.min(...years);
    animateCounter(document.getElementById('total-aircraft-timeline'), totalAircraft);
    animateCounter(document.getElementById('total-years'), yearRange);
  }

  function animateCounter(element, target, duration = 1500) {
    if (!element) return;
    const increment = target / (duration / 16);
    let current = 0;
    const animate = () => {
      current += increment;
      if (current >= target) { element.textContent = target; return; }
      element.textContent = Math.floor(current);
      requestAnimationFrame(animate);
    };
    requestAnimationFrame(animate);
  }

  /* =========================================================================
     DECADE NAVIGATION
     ========================================================================= */

  function renderDecadeNav() {
    const nav = document.getElementById('decade-nav');
    if (!nav) return;

    nav.innerHTML = state.decades.map((decade, i) => `
      <button class="decade-btn${i === 0 ? ' active' : ''}" data-decade="${decade}" data-index="${i}">
        ${decade}s
      </button>
    `).join('');

    document.querySelectorAll('.decade-btn').forEach(btn => {
      btn.addEventListener('click', function() {
        const index = parseInt(this.dataset.index);
        scrollToPanel(index);
      });
    });
  }

  function scrollToPanel(index) {
    const container = document.getElementById('timeline-container');
    if (!container) return;
    const panelWidth = window.innerWidth;
    container.scrollTo({ left: index * panelWidth, behavior: 'smooth' });
    updateActiveDecade(index);
    state.currentPanelIndex = index;
  }

  function scrollToDecade(decade) {
    const index = state.decades.indexOf(decade);
    if (index >= 0) scrollToPanel(index);
  }

  function updateActiveDecade(index) {
    document.querySelectorAll('.decade-btn').forEach((btn, i) => {
      btn.classList.toggle('active', i === index);
    });
    // Update progress dots
    document.querySelectorAll('.progress-dot').forEach((dot, i) => {
      dot.classList.toggle('active', i === index);
    });
    const progressLabel = document.querySelector('.progress-label');
    if (progressLabel && state.decades[index]) {
      progressLabel.textContent = state.decades[index] + 's';
    }
  }

  // Arrow navigation
  const navPrev = document.getElementById('nav-prev');
  const navNext = document.getElementById('nav-next');

  function scrollPanel(dir) {
    const newIndex = Math.max(0, Math.min(state.currentPanelIndex + dir, state.decades.length - 1));
    if (newIndex !== state.currentPanelIndex) scrollToPanel(newIndex);
  }

  navPrev?.addEventListener('click', () => scrollPanel(-1));
  navNext?.addEventListener('click', () => scrollPanel(1));

  // Track scroll position in timeline container
  function trackHorizontalScroll() {
    const container = document.getElementById('timeline-container');
    if (!container) return;
    container.addEventListener('scroll', () => {
      const panelWidth = window.innerWidth;
      const index = Math.round(container.scrollLeft / panelWidth);
      if (index !== state.currentPanelIndex) {
        state.currentPanelIndex = index;
        updateActiveDecade(index);
        navPrev.disabled = index === 0;
        navNext.disabled = index >= state.decades.length - 1;
      }
    }, { passive: true });
  }

  /* =========================================================================
     GENERATION FILTERS
     ========================================================================= */

  const genFilters = document.querySelectorAll('.gen-filter');

  genFilters.forEach(filter => {
    filter.addEventListener('click', function() {
      const gen = this.dataset.gen;
      state.currentGeneration = gen;
      genFilters.forEach(f => f.classList.remove('active'));
      this.classList.add('active');

      if (gen === 'all') {
        state.filteredAircraft = [...state.allAircraft];
      } else {
        state.filteredAircraft = state.allAircraft.filter(a => a.generation === parseInt(gen));
      }

      renderTimeline();
    });
  });

  window.resetFilters = () => {
    state.currentGeneration = 'all';
    state.filteredAircraft = [...state.allAircraft];
    genFilters.forEach(f => f.classList.remove('active'));
    document.querySelector('[data-gen="all"]')?.classList.add('active');
    renderTimeline();
  };

  /* =========================================================================
     RENDER TIMELINE — HORIZONTAL DECADE PANELS
     ========================================================================= */

  function renderTimeline() {
    const container = document.getElementById('timeline-container');
    const emptyState = document.getElementById('empty-state');
    const progress = document.getElementById('timeline-progress');

    if (state.filteredAircraft.length === 0) {
      container.innerHTML = '';
      emptyState?.classList.remove('hidden');
      progress.style.display = 'none';
      return;
    }

    emptyState?.classList.add('hidden');

    // Group by decade
    const aircraftByDecade = {};
    state.filteredAircraft.forEach(aircraft => {
      const year = new Date(aircraft.date_operationel).getFullYear();
      const decade = getDecade(year);
      if (!aircraftByDecade[decade]) aircraftByDecade[decade] = [];
      aircraftByDecade[decade].push(aircraft);
    });

    const sortedDecades = Object.keys(aircraftByDecade).sort((a, b) => parseInt(a) - parseInt(b));

    // Build progress dots
    progress.innerHTML = sortedDecades.map((decade, i) => `
      <div class="progress-dot${i === 0 ? ' active' : ''}" data-index="${i}" title="${decade}s"></div>
    `).join('') + `<div class="progress-label">${sortedDecades[0]}s</div>`;
    progress.style.display = 'flex';

    document.querySelectorAll('.progress-dot').forEach(dot => {
      dot.addEventListener('click', function() {
        scrollToPanel(parseInt(this.dataset.index));
      });
    });

    // Generate panels
    container.innerHTML = sortedDecades.map((decade, panelIndex) => {
      const aircraft = aircraftByDecade[decade];
      const era = eraConfig[parseInt(decade)] || { color: '#00e5ff', label: 'Ère moderne', desc: '...' };
      const decadeKey = parseInt(decade);

      return `
        <div class="decade-panel" data-decade-section="${decade}" data-era="${decade}" style="--era-color:${era.color}">
          <div class="era-watermark">${decade}s</div>
          <div class="panel-inner">
            <div class="panel-header">
              <div class="decade-number">${decade}s</div>
              <div class="decade-meta">
                <h2>${era.label.toUpperCase()}</h2>
                <p class="decade-description">${era.desc}</p>
              </div>
              <div class="decade-count">
                <span class="count-num">${aircraft.length}</span>
                <span class="count-lbl">Appareils</span>
              </div>
            </div>
            <div class="aircraft-grid">
              ${aircraft.map((plane, i) => renderDossierCard(plane, i, era.color)).join('')}
            </div>
          </div>
        </div>
      `;
    }).join('');

    // Click handlers
    document.querySelectorAll('.dossier-card').forEach(card => {
      card.addEventListener('click', function() {
        window.location.href = `/details?id=${this.dataset.id}`;
      });
    });

    // Animate cards visible in viewport
    observeCards();

    // Set up scroll tracking
    trackHorizontalScroll();

    // Scroll back to current panel
    const container2 = document.getElementById('timeline-container');
    if (container2 && state.currentPanelIndex > 0) {
      container2.scrollLeft = state.currentPanelIndex * window.innerWidth;
    }
  }

  function renderDossierCard(plane, index, eraColor) {
    const year = plane.date_operationel ? new Date(plane.date_operationel).getFullYear() : '—';
    const genClass = plane.generation ? `gen-${plane.generation}` : '';
    const genLabel = plane.generation ? `G${plane.generation}` : '—';
    const refNum = plane.id ? plane.id.toString().padStart(4, '0') : '0000';
    const speed = plane.max_speed ? `${escapeHtml(plane.max_speed)} km/h` : '—';
    const range = plane.max_range ? `${escapeHtml(plane.max_range)} km` : '—';
    const imgSrc = plane.image_url || 'https://via.placeholder.com/400x200/0f1626/00e5ff?text=IMG';
    const delay = (index % 6) * 0.08;

    return `
      <div class="dossier-card" data-id="${plane.id}" style="transition-delay:${delay}s">
        <div class="card-topbar">
          <span class="card-ref">REF-${refNum}</span>
          <span class="card-gen ${genClass}">${genLabel}</span>
        </div>
        <div class="card-image">
          <img src="${escapeHtml(imgSrc)}" alt="${escapeHtml(plane.name)}" loading="lazy">
          <div class="card-scan"></div>
          <div class="card-year">${year}</div>
          ${plane.country_name ? `<div class="card-country-flag">${escapeHtml(plane.country_name).substring(0,3).toUpperCase()}</div>` : ''}
        </div>
        <div class="card-body">
          <div class="card-name">${escapeHtml(plane.name)}</div>
          <div class="card-desc">${escapeHtml(plane.little_description) || i18n.t('details.no_desc_available')}</div>
          <div class="card-specs">
            <div class="spec-item">
              <div class="spec-val">${speed}</div>
              <div class="spec-key">Vitesse max</div>
            </div>
            ${plane.max_range ? `
            <div class="spec-item">
              <div class="spec-val">${range}</div>
              <div class="spec-key">Rayon d'action</div>
            </div>` : ''}
          </div>
        </div>
      </div>
    `;
  }

  /* =========================================================================
     CARD ENTRY ANIMATIONS
     ========================================================================= */

  function observeCards() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.05, rootMargin: '0px 100px 0px 0px' });

    document.querySelectorAll('.dossier-card').forEach(card => {
      observer.observe(card);
    });

    // Also trigger for the first panel immediately
    setTimeout(() => {
      const firstPanel = document.querySelector('.decade-panel');
      if (firstPanel) {
        firstPanel.querySelectorAll('.dossier-card').forEach(card => {
          card.classList.add('visible');
        });
      }
    }, 100);
  }

  /* =========================================================================
     KEYBOARD + TOUCH SWIPE
     ========================================================================= */

  let touchStartX = 0;
  document.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
  }, { passive: true });

  document.addEventListener('touchend', (e) => {
    const diff = touchStartX - e.changedTouches[0].screenX;
    if (Math.abs(diff) > 80) scrollPanel(diff > 0 ? 1 : -1);
  }, { passive: true });

  /* =========================================================================
     INIT
     ========================================================================= */

  await loadAllAircraft();
  // Re-render on language change
  window.addEventListener('langChanged', () => {
    renderDecadeNav();
    renderTimeline();
  });

  console.log('Timeline v2 — Salle d\'Opérations — initialized');
});