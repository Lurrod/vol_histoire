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
    const imageUrl = a.image_url || 'https://vol-histoire.titouan-borde.com/assets/airplanes/a10-thunderbolt-2.jpg';
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
    const heroUrl = a.image_url || 'https://via.placeholder.com/800x500?text=No+Image';
    VH.shared.picture.applySourcesTo(heroImage, heroUrl);
    heroImage.alt = [a.name, a.manufacturer_name, a.country_name].filter(Boolean).join(' — ');
    heroImage.loading = 'lazy';

    document.getElementById('stat-speed').textContent = a.max_speed ? `${a.max_speed} km/h` : 'N/A';
    document.getElementById('stat-range').textContent = a.max_range ? `${a.max_range} km` : 'N/A';
    document.getElementById('stat-weight').textContent = a.weight ? `${a.weight} kg` : 'N/A';
    document.getElementById('stat-status').textContent = a.status || i18n.t('details.not_specified');
    document.getElementById('aircraft-description').textContent = a.description || i18n.t('details.no_description');

    document.getElementById('date-concept').querySelector('.timeline-date').textContent = formatDate(a.date_concept);
    document.getElementById('date-first-fly').querySelector('.timeline-date').textContent = formatDate(a.date_first_fly);
    document.getElementById('date-operational').querySelector('.timeline-date').textContent = formatDate(a.date_operationel);

    // Description : support markdown si présence de ## / ** / - ou render plain sinon
    const descEl = document.getElementById('aircraft-description');
    if (descEl) {
      if (a.description && /(^|\n)(##|###|\s*-\s)/.test(a.description)) {
        const html = VH.details.markdown.parse(a.description);
        descEl.classList.add('markdown-body');
        if (typeof safeSetHTML === 'function') safeSetHTML(descEl, html);
        else descEl.innerHTML = html;
      } else {
        descEl.classList.remove('markdown-body');
        descEl.textContent = a.description || i18n.t('details.no_description');
      }
    }

    // Nouvelles sections (strates 1-3-4-6)
    renderSpecs(a);
    renderProduction(a);
    renderRelatedAircraft(a);
    renderSources(a);
  }

  // ── Strate 1 + 2 : Fiche technique étendue ──────────────────────
  function renderSpecs(a) {
    const section = document.getElementById('specs-section');
    const grid = document.getElementById('specs-grid');
    if (!section || !grid) return;

    const dims = [
      ['details.spec_length', a.length, 'm', 'fa-ruler-horizontal'],
      ['details.spec_wingspan', a.wingspan, 'm', 'fa-arrows-left-right'],
      ['details.spec_height', a.height, 'm', 'fa-ruler-vertical'],
      ['details.spec_wing_area', a.wing_area, 'm²', 'fa-feather-pointed'],
      ['details.spec_empty_weight', a.empty_weight, 'kg', 'fa-weight-hanging'],
      ['details.spec_mtow', a.mtow, 'kg', 'fa-scale-balanced'],
      ['details.spec_ceiling', a.service_ceiling, 'm', 'fa-chart-line'],
      ['details.spec_climb_rate', a.climb_rate, 'm/s', 'fa-arrow-trend-up'],
      ['details.spec_combat_radius', a.combat_radius, 'km', 'fa-location-crosshairs'],
      ['details.spec_g_pos', a.g_limit_pos, 'g', 'fa-arrow-up-wide-short'],
      ['details.spec_g_neg', a.g_limit_neg, 'g', 'fa-arrow-down-wide-short'],
      ['details.spec_crew', a.crew, null, 'fa-user-tie'],
      ['details.spec_engine', a.engine_name, null, 'fa-cogs'],
      ['details.spec_engine_count', a.engine_count, null, 'fa-gears'],
      ['details.spec_engine_type', a.engine_type, null, 'fa-bolt'],
      ['details.spec_thrust_dry', a.thrust_dry, 'kN', 'fa-rocket'],
      ['details.spec_thrust_wet', a.thrust_wet, 'kN', 'fa-fire'],
    ];
    const tiles = dims
      .filter(([, v]) => v != null && v !== '')
      .map(([labelKey, value, unit, icon]) => {
        const label = i18n.t(labelKey);
        const displayValue = typeof value === 'number'
          ? (unit ? `${value.toLocaleString(i18n.currentLang === 'en' ? 'en' : 'fr')} ${unit}` : value)
          : escapeHtml(String(value));
        return `<div class="spec-tile">
          <i class="fas ${icon}" aria-hidden="true"></i>
          <div class="spec-label">${escapeHtml(label)}</div>
          <div class="spec-value">${typeof displayValue === 'string' ? displayValue : escapeHtml(String(displayValue))}</div>
        </div>`;
      });

    if (tiles.length === 0) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    grid.innerHTML = tiles.join('');
  }

  // ── Strate 3 : Production & Service ──────────────────────────────
  function renderProduction(a) {
    const section = document.getElementById('production-section');
    const grid = document.getElementById('production-grid');
    if (!section || !grid) return;

    const fmtCost = (cents) => cents == null ? null : (
      cents >= 1_000_000_000
        ? `${(cents / 1_000_000_000).toFixed(2).replace(/\.00$/, '')} Md $`
        : cents >= 1_000_000
          ? `${(cents / 1_000_000).toFixed(1).replace(/\.0$/, '')} M $`
          : cents.toLocaleString(i18n.currentLang === 'en' ? 'en' : 'fr') + ' $'
    );

    const prodYears = a.production_start
      ? (a.production_end
          ? `${a.production_start} – ${a.production_end}`
          : `${a.production_start} – ${i18n.t('details.prod_today')}`)
      : null;
    const costStr = a.unit_cost_usd
      ? fmtCost(a.unit_cost_usd) + (a.unit_cost_year ? ` (${a.unit_cost_year})` : '')
      : null;

    const items = [
      ['details.prod_years', prodYears, 'fa-calendar-days'],
      ['details.prod_units_built', a.units_built != null ? a.units_built.toLocaleString() : null, 'fa-layer-group'],
      ['details.prod_unit_cost', costStr, 'fa-coins'],
      ['details.prod_operators', a.operators_count, 'fa-flag'],
      ['details.prod_stealth', a.stealth_level ? stealthLabel(a.stealth_level) : null, 'fa-eye-slash'],
      ['details.prod_nickname', a.nickname, 'fa-quote-right'],
    ];
    const tiles = items.filter(([, v]) => v != null && v !== '').map(([labelKey, value, icon]) => `
      <div class="spec-tile">
        <i class="fas ${icon}" aria-hidden="true"></i>
        <div class="spec-label">${escapeHtml(i18n.t(labelKey))}</div>
        <div class="spec-value">${escapeHtml(String(value))}</div>
      </div>
    `);

    const variantsBlock = document.getElementById('variants-block');
    const variantsContent = document.getElementById('variants-content');
    if (a.variants && variantsBlock && variantsContent) {
      const html = VH.details.markdown.parse(a.variants);
      if (typeof safeSetHTML === 'function') safeSetHTML(variantsContent, html);
      else variantsContent.innerHTML = html;
      variantsBlock.classList.remove('hidden');
    } else if (variantsBlock) {
      variantsBlock.classList.add('hidden');
    }

    if (tiles.length === 0 && !a.variants) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    grid.innerHTML = tiles.join('');
  }

  function stealthLabel(level) {
    const keyMap = {
      aucune: 'details.stealth_none',
      reduite: 'details.stealth_reduced',
      moderee: 'details.stealth_moderate',
      elevee: 'details.stealth_high',
      tres_elevee: 'details.stealth_very_high',
    };
    return keyMap[level] ? i18n.t(keyMap[level]) : level;
  }

  // ── Strate 4 : Appareils liés (predecessor / successor / rival) ──
  function renderRelatedAircraft(a) {
    const section = document.getElementById('related-aircraft-section');
    const grid = document.getElementById('related-grid');
    if (!section || !grid) return;

    const cards = [];
    function addCard(relation, id, name, img) {
      if (!id || !name) return;
      const slug = VH.details.data.slugify(name);
      const href = `/details/${slug}-${id}`;
      const imgSrc = img || '/assets/airplanes/placeholder.jpg';
      const relPic = VH.shared.picture.pictureHtml(imgSrc, {
        alt: '',
        loading: 'lazy',
        width: '300',
        height: '200',
        onerror: "this.closest('picture').style.display='none'",
      });
      cards.push(`
        <a class="related-card" href="${href}">
          <span class="related-relation">${relation}</span>
          <div class="related-img">${relPic}</div>
          <h4>${escapeHtml(name)}</h4>
          <span class="related-arrow"><i class="fas fa-arrow-right"></i></span>
        </a>
      `);
    }
    addCard(i18n.t('details.related_predecessor'), a.predecessor_id, a.predecessor_name, a.predecessor_image);
    addCard(i18n.t('details.related_successor'), a.successor_id, a.successor_name, a.successor_image);
    addCard(i18n.t('details.related_rival'), a.rival_id, a.rival_name, a.rival_image);

    if (cards.length === 0) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    grid.innerHTML = cards.join('');
  }

  // ── Strate 6 : Liens externes ────────────────────────────────────
  function renderSources(a) {
    const section = document.getElementById('sources-section');
    const list = document.getElementById('sources-list');
    if (!section || !list) return;

    const links = [
      ['details.source_wikipedia_fr', a.wikipedia_fr, 'fab fa-wikipedia-w'],
      ['details.source_wikipedia_en', a.wikipedia_en, 'fab fa-wikipedia-w'],
      ['details.source_youtube', a.youtube_showcase, 'fab fa-youtube'],
      ['details.source_manufacturer', a.manufacturer_page, 'fas fa-industry'],
    ];
    const items = links.filter(([, u]) => u).map(([labelKey, url, iconClasses]) => `
      <a class="source-link" href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">
        <i class="${iconClasses}" aria-hidden="true"></i>
        <span>${escapeHtml(i18n.t(labelKey))}</span>
        <i class="fas fa-arrow-up-right-from-square source-arrow" aria-hidden="true"></i>
      </a>
    `);
    if (items.length === 0) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    list.innerHTML = items.join('');
  }

  function renderChipGrid(container, items, iconClass, emptyMsg) {
    if (!container) return;
    if (!items || items.length === 0) {
      container.className = '';
      container.innerHTML = `<p class="details-empty-hint">${emptyMsg}</p>`;
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
      container.innerHTML = `<p class="details-empty-hint">${i18n.t('details.no_mission')}</p>`;
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
      container.innerHTML = `<p class="details-empty-hint">${i18n.t('details.no_war')}</p>`;
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
