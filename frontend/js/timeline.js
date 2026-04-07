document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* =========================================================================
     STATE
     ========================================================================= */

  const state = {
    allAircraft: [],
    filteredAircraft: [],
    currentGeneration: 'all',
    decades: []
  };

  /* =========================================================================
     ERA CONFIG
     ========================================================================= */

  const eraConfig = {
    1940: { color: '#d4a017', get label() { return i18n.t('timeline.era_1940_label'); }, get desc() { return i18n.t('timeline.era_1940_desc'); } },
    1950: { color: '#3aff6e', get label() { return i18n.t('timeline.era_1950_label'); }, get desc() { return i18n.t('timeline.era_1950_desc'); } },
    1960: { color: '#ff8c00', get label() { return i18n.t('timeline.era_1960_label'); }, get desc() { return i18n.t('timeline.era_1960_desc'); } },
    1970: { color: '#ff4500', get label() { return i18n.t('timeline.era_1970_label'); }, get desc() { return i18n.t('timeline.era_1970_desc'); } },
    1980: { color: '#C8A96E', get label() { return i18n.t('timeline.era_1980_label'); }, get desc() { return i18n.t('timeline.era_1980_desc'); } },
    1990: { color: '#7b5cf0', get label() { return i18n.t('timeline.era_1990_label'); }, get desc() { return i18n.t('timeline.era_1990_desc'); } },
    2000: { color: '#2979ff', get label() { return i18n.t('timeline.era_2000_label'); }, get desc() { return i18n.t('timeline.era_2000_desc'); } },
    2010: { color: '#e040fb', get label() { return i18n.t('timeline.era_2010_label'); }, get desc() { return i18n.t('timeline.era_2010_desc'); } },
    2020: { color: '#ff3d6e', get label() { return i18n.t('timeline.era_2020_label'); }, get desc() { return i18n.t('timeline.era_2020_desc'); } }
  };

  /* escapeHtml, showToast → utils.js | navigation → nav.js */

  function getDecade(year) { return Math.floor(year / 10) * 10; }

  /* =========================================================================
     LOAD DATA
     ========================================================================= */

  async function loadAllAircraft() {
    try {
      const page1Response = await auth.fetchWithTimeout('/api/airplanes?sort=service-date&page=1');
      const page1Data = await page1Response.json();
      let aircraft = page1Data.data || [];
      const totalPages = page1Data.pagination?.totalPages || 1;

      if (totalPages > 1) {
        const promises = [];
        for (let i = 2; i <= totalPages; i++) {
          promises.push(auth.fetchWithTimeout(`/api/airplanes?sort=service-date&page=${i}`));
        }
        const responses = await Promise.all(promises);
        const pagesData = await Promise.all(responses.map(res => res.json()));
        pagesData.forEach(pageData => { aircraft = aircraft.concat(pageData.data || []); });
      }

      state.allAircraft = aircraft
        .filter(a => a.date_operationel)
        .sort((a, b) => new Date(a.date_operationel) - new Date(b.date_operationel));

      state.filteredAircraft = [...state.allAircraft];

      document.getElementById('loading-state').style.display = 'none';

      if (state.allAircraft.length === 0) {
        document.getElementById('timeline-container').innerHTML =
          '<p style="text-align:center;padding:4rem;color:var(--text-secondary)">Aucun appareil avec une date opérationnelle.</p>';
        return;
      }

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

    } catch (error) {
      // Erreur gérée via toast
      showToast(i18n.t('common.loading_error'), 'error');
      document.getElementById('loading-state').innerHTML =
        '<p style="color:#e74c3c;font-family:\'DM Sans\',sans-serif;font-size:0.8rem;letter-spacing:2px">ERREUR — DONNÉES INACCESSIBLES</p>';
    }
  }

  function updateStats() {
    const years = state.allAircraft.map(a => new Date(a.date_operationel).getFullYear());
    const yearRange = years.length > 1 ? Math.max(...years) - Math.min(...years) : 0;
    animateCounter(document.getElementById('total-aircraft-timeline'), state.allAircraft.length);
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
      <button class="decade-chip${i === 0 ? ' active' : ''}" data-decade="${decade}">${decade}s</button>
    `).join('');
    nav.querySelectorAll('.decade-chip').forEach(btn => {
      btn.addEventListener('click', function() {
        scrollToDecade(parseInt(this.dataset.decade));
      });
    });
  }

  function scrollToDecade(decade) {
    const section = document.getElementById('decade-section-' + decade);
    if (!section) return;
    const offset = 130; // header (70px) + control bar (50px) + margin
    const top = section.getBoundingClientRect().top + window.pageYOffset - offset;
    window.scrollTo({ top, behavior: 'smooth' });
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

  document.getElementById('reset-filters-btn')?.addEventListener('click', () => {
    state.currentGeneration = 'all';
    state.filteredAircraft = [...state.allAircraft];
    genFilters.forEach(f => f.classList.remove('active'));
    document.querySelector('[data-gen="all"]')?.classList.add('active');
    renderTimeline();
  });

  /* =========================================================================
     RENDER TIMELINE — VERTICAL CHRONICLE
     ========================================================================= */

  function renderTimeline() {
    const container = document.getElementById('timeline-container');
    const emptyState = document.getElementById('empty-state');

    if (state.filteredAircraft.length === 0) {
      container.innerHTML = '';
      emptyState?.classList.remove('hidden');
      return;
    }
    emptyState?.classList.add('hidden');

    // Grouper par décennie
    const aircraftByDecade = {};
    state.filteredAircraft.forEach(aircraft => {
      const year = new Date(aircraft.date_operationel).getFullYear();
      const decade = getDecade(year);
      if (!aircraftByDecade[decade]) aircraftByDecade[decade] = [];
      aircraftByDecade[decade].push(aircraft);
    });

    const sortedDecades = Object.keys(aircraftByDecade).sort((a, b) => parseInt(a) - parseInt(b));

    container.innerHTML = sortedDecades.map(decade => {
      const aircraft = aircraftByDecade[decade];
      const era = eraConfig[parseInt(decade)] || { color: 'rgba(255,255,255,0.15)', label: '', desc: '' };
      const count = aircraft.length;
      const countLabel = `${count} ${count > 1 ? i18n.t('timeline.aircraft_plural') : i18n.t('timeline.aircraft_singular')}`;

      return `
        <section class="decade-section" id="decade-section-${decade}" data-decade="${decade}s" style="--era-color:${era.color}">
          <div class="decade-header">
            <div class="decade-bar"></div>
            <span class="decade-era">${era.label}</span>
            <span class="decade-sep-dot">·</span>
            <span class="decade-count">${countLabel}</span>
          </div>
          <div class="decade-divider"></div>
          <div class="decade-list">
            ${aircraft.map(plane => renderAircraftRow(plane)).join('')}
          </div>
        </section>
      `;
    }).join('');

    container.querySelectorAll('.aircraft-row').forEach(row => {
      row.addEventListener('click', function() {
        window.location.href = `/details?id=${this.dataset.id}`;
      });
    });

    observeRows();
    observeDecades();
  }

  function renderAircraftRow(plane) {
    const year = plane.date_operationel ? new Date(plane.date_operationel).getFullYear() : '—';
    const genClass = plane.generation ? `gen-${plane.generation}` : '';
    const genLabel = plane.generation ? `G${plane.generation}` : '';
    const imgSrc = plane.image_url || '';

    return `
      <div class="aircraft-row" data-id="${escapeHtml(String(plane.id))}">
        <span class="row-year">${year}</span>
        <div class="row-body">
          <span class="row-name">${escapeHtml(plane.name)}</span>
          ${plane.country_name ? `<span class="row-country">${escapeHtml(plane.country_name)}</span>` : ''}
        </div>
        ${genLabel ? `<span class="row-gen ${genClass}">${genLabel}</span>` : '<span></span>'}
        ${imgSrc ? `<div class="row-thumb"><img src="${escapeHtml(imgSrc)}" alt="${escapeHtml(plane.name)}" loading="lazy"></div>` : '<div class="row-thumb"></div>'}
      </div>
    `;
  }

  /* =========================================================================
     ROW ENTRY ANIMATIONS
     ========================================================================= */

  function observeRows() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.05 });

    document.querySelectorAll('.aircraft-row').forEach(row => observer.observe(row));

    // Rendre visibles les lignes déjà dans le viewport
    setTimeout(() => {
      document.querySelectorAll('.aircraft-row').forEach(row => {
        if (row.getBoundingClientRect().top < window.innerHeight) {
          row.classList.add('visible');
        }
      });
    }, 50);
  }

  /* =========================================================================
     DECADE SCROLL OBSERVER — met à jour le chip actif
     ========================================================================= */

  function observeDecades() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const decade = entry.target.id.replace('decade-section-', '');
          document.querySelectorAll('.decade-chip').forEach(chip => {
            chip.classList.toggle('active', chip.dataset.decade === decade);
          });
        }
      });
    }, { rootMargin: '-130px 0px -55% 0px', threshold: 0 });

    document.querySelectorAll('.decade-section').forEach(s => observer.observe(s));
  }

  /* =========================================================================
     INIT
     ========================================================================= */

  await loadAllAircraft();

  window.addEventListener('langChanged', () => {
    renderDecadeNav();
    renderTimeline();
  });

});
