/* Rendu de la fiche avion + sections related (armament, tech, missions, wars). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function formatDate(dateString) {
    if (!dateString) return i18n.t('details.not_specified');
    const date = new Date(dateString);
    return date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR', {
      year: 'numeric', month: 'long', day: 'numeric'
    });
  }

  function renderAircraftDetails(state) {
    const a = state.aircraftData;
    document.title = `${a.name} | Vol d'Histoire`;

    const slug = VH.details.data.slugify(a.name);
    const cleanPath = `/details/${slug}-${state.aircraftId}`;
    history.replaceState({ id: state.aircraftId }, document.title, cleanPath);
    const pageUrl = `https://vol-histoire.titouan-borde.com${cleanPath}`;
    const imageUrl = a.image_url || 'https://i.postimg.cc/gcysXwvG/a10-thunderbolt-2.jpg';
    VH.details.data.updateSeoMeta(state, a.name, a.description, imageUrl, pageUrl);

    document.getElementById('breadcrumb-name').textContent = a.name;
    document.getElementById('aircraft-name').textContent = a.name || 'N/A';
    document.getElementById('aircraft-complete-name').textContent = a.complete_name || '';

    const badge = document.getElementById('hero-badge');
    if (a.generation) {
      badge.innerHTML = `
        <i class="fas fa-layer-group"></i>
        <span>${escapeHtml(a.generation)}${i18n.currentLang === 'en' ? (['st','nd','rd'][a.generation-1]||'th') + ' Generation' : 'e Génération'}</span>
      `;
    }

    document.getElementById('hero-country').textContent = a.country_name || i18n.t('details.not_specified');
    document.getElementById('hero-manufacturer').textContent = a.manufacturer_name || i18n.t('details.not_specified');
    if (a.date_operationel) {
      document.getElementById('hero-year').textContent = new Date(a.date_operationel).getFullYear();
    }

    const heroImage = document.getElementById('hero-image');
    heroImage.src = a.image_url || 'https://via.placeholder.com/800x500?text=No+Image';
    heroImage.alt = a.name;
    heroImage.loading = 'lazy';

    document.getElementById('stat-speed').textContent = a.max_speed ? `${a.max_speed} km/h` : 'N/A';
    document.getElementById('stat-range').textContent = a.max_range ? `${a.max_range} km` : 'N/A';
    document.getElementById('stat-weight').textContent = a.weight ? `${a.weight} kg` : 'N/A';
    document.getElementById('stat-status').textContent = a.status || i18n.t('details.not_specified');
    document.getElementById('aircraft-description').textContent = a.description || i18n.t('details.no_description');

    document.getElementById('date-concept').querySelector('.timeline-date').textContent = formatDate(a.date_concept);
    document.getElementById('date-first-fly').querySelector('.timeline-date').textContent = formatDate(a.date_first_fly);
    document.getElementById('date-operational').querySelector('.timeline-date').textContent = formatDate(a.date_operationel);
  }

  function renderChipGrid(container, items, iconClass, emptyMsg) {
    if (!container) return;
    if (!items || items.length === 0) {
      container.className = '';
      container.innerHTML = `<p style="color: var(--text-secondary); text-align: center;">${emptyMsg}</p>`;
      return;
    }
    container.className = 'chip-grid';
    container.innerHTML = items.map(item => {
      const name = escapeHtml(item.name || '');
      const desc = escapeHtml(item.description || '');
      return `<button class="chip" type="button" tabindex="0">
        <i class="fas ${iconClass}"></i>
        <span class="chip-label">${name}</span>
        ${desc ? `<span class="chip-tooltip" role="tooltip">${desc}</span>` : ''}
      </button>`;
    }).join('');
  }

  function renderArmament(armament) {
    renderChipGrid(document.getElementById('armament-list'), armament, 'fa-crosshairs', i18n.t('details.no_armament'));
  }

  function renderTechnologies(tech) {
    renderChipGrid(document.getElementById('tech-list'), tech, 'fa-microchip', i18n.t('details.no_tech'));
  }

  function renderMissions(missions) {
    const container = document.getElementById('missions-list');
    if (!missions || missions.length === 0) {
      container.innerHTML = `<p style="color: var(--text-secondary); text-align: center;">${i18n.t('details.no_mission')}</p>`;
      return;
    }
    const missionIcons = {
      'Appui aérien rapproché': 'crosshairs',
      'Frappe tactique': 'bomb',
      'Supériorité aérienne': 'jet-fighter',
      'Interception': 'bullseye',
      'Reconnaissance': 'binoculars',
      'Escorte': 'shield-halved'
    };
    container.className = 'chip-grid';
    container.innerHTML = missions.map(item => {
      const icon = missionIcons[item.name] || 'bullseye';
      const name = escapeHtml(item.name || '');
      const desc = escapeHtml(item.description || '');
      return `<button class="chip" type="button" tabindex="0">
        <i class="fas fa-${icon}"></i>
        <span class="chip-label">${name}</span>
        ${desc ? `<span class="chip-tooltip" role="tooltip">${desc}</span>` : ''}
      </button>`;
    }).join('');
  }

  function renderWars(wars) {
    const container = document.getElementById('wars-list');
    if (!wars || wars.length === 0) {
      container.innerHTML = `<p style="color: var(--text-secondary); text-align: center;">${i18n.t('details.no_war')}</p>`;
      return;
    }
    container.innerHTML = wars.map(war => {
      const startYear = war.date_start ? new Date(war.date_start).getFullYear() : '?';
      const endYear = war.date_end ? new Date(war.date_end).getFullYear() : '?';
      return `
        <div class="war-card">
          <h4>${escapeHtml(war.name)}</h4>
          <div class="war-period"><i class="fas fa-calendar-days"></i><span>${startYear} - ${endYear}</span></div>
          <p>${escapeHtml(war.description) || i18n.t('details.no_desc_available')}</p>
        </div>
      `;
    }).join('');
  }

  VH.details.render = { renderAircraftDetails, renderArmament, renderTechnologies, renderMissions, renderWars };
})();
