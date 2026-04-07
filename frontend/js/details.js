document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* escapeHtml, showToast → utils.js | navigation → nav.js */

  function formatDate(dateString) {
    if (!dateString) return i18n.t('details.not_specified');
    const date = new Date(dateString);
    return date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  }


  const payload = auth.getPayload();
  let userRole = null;

  if (payload) {
    userRole = Number(payload.role);
    
    const userNameEl = document.getElementById('user-name');
    if (userNameEl) userNameEl.textContent = payload.name;
    document.querySelector('.user-role').textContent = 
      userRole === 1 ? i18n.t('common.role_admin') : userRole === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
    
    document.querySelector('.user-dropdown')?.classList.remove('hidden');

    if (userRole === 1 || userRole === 2) {
      document.getElementById('edit-btn')?.classList.remove('hidden');
      document.getElementById('delete-btn')?.classList.remove('hidden');
    }
  }

  /* settings navigation, touch gestures → nav.js */

  /* =========================================================================
     GET AIRCRAFT ID
     ========================================================================= */

  function slugify(text) {
    return text
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  // Support deux formats d'URL :
  // - /details?id=14          (navigation interne)
  // - /details/f-22-raptor-14 (URL SEO, ID en suffixe)
  const urlParams = new URLSearchParams(window.location.search);
  let aircraftId = urlParams.get('id');

  if (!aircraftId) {
    const pathSegment = window.location.pathname.split('/').filter(Boolean).pop();
    if (pathSegment) {
      const match = pathSegment.match(/-(\d+)$/);
      if (match) aircraftId = match[1];
    }
  }

  if (!aircraftId || !/^\d+$/.test(aircraftId)) {
    window.location.href = '/404';
    return;
  }

  /* =========================================================================
     LOAD AIRCRAFT DATA
     ========================================================================= */

  let aircraftData = null;

  async function loadAircraftDetails() {
    try {
      const response = await auth.fetchWithTimeout(`/api/airplanes/${aircraftId}`);
      
      if (!response.ok) {
        throw new Error(i18n.t('details.not_found'));
      }

      aircraftData = await response.json();
      renderAircraftDetails();
      loadRelatedData();
      checkFavoriteStatus();
      
    } catch (error) {
      // Erreur gérée via redirection
      window.location.href = '/404';
    }
  }

  function updateSeoMeta(name, description, imageUrl, pageUrl) {
    const fullTitle = `${name} | Vol d'Histoire`;
    const desc = description
      ? description.substring(0, 155).trimEnd() + (description.length > 155 ? '...' : '')
      : 'Découvrez les spécifications détaillées, l\'armement et l\'historique de cet avion de chasse.';

    // Canonical
    let canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical) { canonical = document.createElement('link'); canonical.setAttribute('rel', 'canonical'); document.head.appendChild(canonical); }
    canonical.href = pageUrl;

    // Hreflang
    ['fr', 'x-default'].forEach(lang => {
      let el = document.querySelector(`link[rel="alternate"][hreflang="${lang}"]`);
      if (el) el.href = pageUrl;
    });

    // Meta description
    let metaDesc = document.querySelector('meta[name="description"]');
    if (!metaDesc) { metaDesc = document.createElement('meta'); metaDesc.setAttribute('name', 'description'); document.head.appendChild(metaDesc); }
    metaDesc.content = desc;

    // Open Graph
    const ogProps = { 'og:title': fullTitle, 'og:description': desc, 'og:url': pageUrl, 'og:image': imageUrl };
    Object.entries(ogProps).forEach(([prop, val]) => {
      let el = document.querySelector(`meta[property="${prop}"]`);
      if (!el) { el = document.createElement('meta'); el.setAttribute('property', prop); document.head.appendChild(el); }
      el.content = val;
    });

    // Twitter Card
    const twitterProps = { 'twitter:title': fullTitle, 'twitter:description': desc, 'twitter:image': imageUrl };
    Object.entries(twitterProps).forEach(([name, val]) => {
      let el = document.querySelector(`meta[name="${name}"]`);
      if (!el) { el = document.createElement('meta'); el.setAttribute('name', name); document.head.appendChild(el); }
      el.content = val;
    });

    // JSON-LD structured data
    let ldScript = document.querySelector('script[type="application/ld+json"]');
    if (!ldScript) { ldScript = document.createElement('script'); ldScript.type = 'application/ld+json'; document.head.appendChild(ldScript); }
    const ldData = {
      '@context': 'https://schema.org',
      '@type': 'Thing',
      'name': name,
      'description': desc,
      'image': imageUrl,
      'url': pageUrl,
      'isPartOf': { '@type': 'WebSite', 'name': 'Vol d\'Histoire', 'url': 'https://vol-histoire.titouan-borde.com/' }
    };
    if (aircraftData.complete_name) ldData.alternateName = aircraftData.complete_name;
    ldScript.textContent = JSON.stringify(ldData);
  }

  function renderAircraftDetails() {
    // Update page title
    document.title = `${aircraftData.name} | Vol d'Histoire`;

    // Mise à jour des balises SEO dynamiques
    const slug = slugify(aircraftData.name);
    const cleanPath = `/details/${slug}-${aircraftId}`;
    history.pushState({ id: aircraftId }, document.title, cleanPath);
    const pageUrl = `https://vol-histoire.titouan-borde.com${cleanPath}`;
    const imageUrl = aircraftData.image_url || 'https://i.postimg.cc/gcysXwvG/a10-thunderbolt-2.jpg';
    updateSeoMeta(aircraftData.name, aircraftData.description, imageUrl, pageUrl);

    // Breadcrumb
    document.getElementById('breadcrumb-name').textContent = aircraftData.name;

    // Hero section
    document.getElementById('aircraft-name').textContent = aircraftData.name || 'N/A';
    document.getElementById('aircraft-complete-name').textContent = aircraftData.complete_name || '';
    
    const badge = document.getElementById('hero-badge');
    if (aircraftData.generation) {
      badge.innerHTML = `
        <i class="fas fa-layer-group"></i>
        <span>${escapeHtml(aircraftData.generation)}${i18n.currentLang === 'en' ? (['st','nd','rd'][aircraftData.generation-1]||'th') + ' Generation' : 'e Génération'}</span>
      `;
    }

    document.getElementById('hero-country').textContent = aircraftData.country_name || i18n.t('details.not_specified');
    document.getElementById('hero-manufacturer').textContent = aircraftData.manufacturer_name || i18n.t('details.not_specified');
    
    if (aircraftData.date_operationel) {
      const year = new Date(aircraftData.date_operationel).getFullYear();
      document.getElementById('hero-year').textContent = year;
    }

    // Hero image
    const heroImage = document.getElementById('hero-image');
    heroImage.src = aircraftData.image_url || 'https://via.placeholder.com/800x500?text=No+Image';
    heroImage.alt = aircraftData.name;
    heroImage.loading = 'lazy';

    // Quick stats
    document.getElementById('stat-speed').textContent = 
      aircraftData.max_speed ? `${aircraftData.max_speed} km/h` : 'N/A';
    document.getElementById('stat-range').textContent = 
      aircraftData.max_range ? `${aircraftData.max_range} km` : 'N/A';
    document.getElementById('stat-weight').textContent = 
      aircraftData.weight ? `${aircraftData.weight} kg` : 'N/A';
    document.getElementById('stat-status').textContent = 
      aircraftData.status || i18n.t('details.not_specified');

    // Description
    document.getElementById('aircraft-description').textContent = 
      aircraftData.description || i18n.t('details.no_description');

    // Timeline dates
    const conceptEl = document.getElementById('date-concept');
    conceptEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_concept);

    const firstFlyEl = document.getElementById('date-first-fly');
    firstFlyEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_first_fly);

    const operationalEl = document.getElementById('date-operational');
    operationalEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_operationel);
  }

  async function loadRelatedData() {
    try {
      const response = await auth.fetchWithTimeout(`/api/airplanes/${aircraftId}/related`);
      if (!response.ok) throw new Error('Erreur serveur');
      const { armament, tech, missions, wars } = await response.json();

      renderArmament(armament);
      renderTechnologies(tech);
      renderMissions(missions);
      renderWars(wars);
      renderRadarChart(armament, tech, missions);

    } catch (error) {
      // Erreur silencieuse — données secondaires
    }
  }

  /* =========================================================================
     RADAR CHART
     ========================================================================= */

  function renderRadarChart(armament, tech, missions) {
    const chartEl = document.getElementById('radar-chart');
    const legendEl = document.getElementById('radar-legend');
    if (!chartEl || !legendEl || !aircraftData) return;

    // Valeurs de référence pour normalisation (max connus de la base)
    const REF_SPEED = 3529;   // SR-71 Blackbird
    const REF_RANGE = 15000;  // Bombardiers stratégiques
    const REF_ARMAMENT = 10;
    const REF_MISSIONS = 8;
    const REF_TECH = 8;

    const axes = [
      {
        label: i18n.t('details.radar_speed'),
        icon: 'gauge-high',
        score: Math.min((aircraftData.max_speed || 0) / REF_SPEED * 100, 100),
        raw: aircraftData.max_speed ? `${Number(aircraftData.max_speed).toLocaleString()} km/h` : 'N/A',
      },
      {
        label: i18n.t('details.radar_range'),
        icon: 'route',
        score: Math.min((aircraftData.max_range || 0) / REF_RANGE * 100, 100),
        raw: aircraftData.max_range ? `${Number(aircraftData.max_range).toLocaleString()} km` : 'N/A',
      },
      {
        label: i18n.t('details.radar_armament'),
        icon: 'crosshairs',
        score: Math.min((armament.length || 0) / REF_ARMAMENT * 100, 100),
        raw: `${armament.length} ${i18n.currentLang === 'en' ? (armament.length !== 1 ? 'systems' : 'system') : (armament.length > 1 ? 'systèmes' : 'système')}`,
      },
      {
        label: i18n.t('details.radar_versatility'),
        icon: 'bullseye',
        score: Math.min((missions.length || 0) / REF_MISSIONS * 100, 100),
        raw: `${missions.length} ${i18n.currentLang === 'en' ? (missions.length !== 1 ? 'missions' : 'mission') : (missions.length > 1 ? 'missions' : 'mission')}`,
      },
      {
        label: i18n.t('details.radar_technology'),
        icon: 'microchip',
        score: Math.min((tech.length || 0) / REF_TECH * 100, 100),
        raw: `${tech.length} tech${tech.length > 1 ? 's' : ''}`,
      },
    ];

    // ---- SVG ----
    const cx = 150, cy = 150, r = 95;
    const n = axes.length;
    const angles = axes.map((_, i) => -Math.PI / 2 + (i * 2 * Math.PI / n));

    function pt(angle, val) {
      return [
        +(cx + (val / 100) * r * Math.cos(angle)).toFixed(2),
        +(cy + (val / 100) * r * Math.sin(angle)).toFixed(2),
      ];
    }

    // Polygones de grille
    const gridLevels = [20, 40, 60, 80, 100];
    const gridPolygons = gridLevels.map((level, gi) => {
      const pts = angles.map(a => pt(a, level).join(',')).join(' ');
      const isOuter = gi === 4;
      const fill = gi % 2 === 0 && !isOuter ? 'rgba(200,169,110,0.02)' : 'none';
      const stroke = isOuter ? 'rgba(200,169,110,0.25)' : 'rgba(255,255,255,0.07)';
      const sw = isOuter ? 1.5 : 1;
      return `<polygon points="${pts}" fill="${fill}" stroke="${stroke}" stroke-width="${sw}" />`;
    }).join('');

    // Lignes d'axes
    const axisLines = angles.map(a => {
      const [x2, y2] = pt(a, 100);
      return `<line x1="${cx}" y1="${cy}" x2="${x2}" y2="${y2}" stroke="rgba(255,255,255,0.12)" stroke-width="1" />`;
    }).join('');

    // Polygone de données
    const dataPolygonPts = angles.map((a, i) => pt(a, axes[i].score).join(',')).join(' ');

    // Points de données
    const dataDots = angles.map((a, i) => {
      const [x, y] = pt(a, axes[i].score);
      return `<circle cx="${x}" cy="${y}" r="4.5" fill="#C8A96E" stroke="#0D0D0D" stroke-width="2" />`;
    }).join('');

    // Labels des axes (5 positions autour du radar)
    const labelR = 118;
    const textAnchors = ['middle', 'start', 'start', 'end', 'end'];
    const dyOffsets = [-6, 4, 4, 4, 4];
    const axisLabels = angles.map((a, i) => {
      const lx = +(cx + labelR * Math.cos(a)).toFixed(2);
      const ly = +(cy + labelR * Math.sin(a) + dyOffsets[i]).toFixed(2);
      return `<text x="${lx}" y="${ly}" text-anchor="${textAnchors[i]}" dominant-baseline="middle" fill="rgba(255,255,255,0.6)" font-size="9" font-family="DM Sans, sans-serif" font-weight="600" letter-spacing="0.05em">${axes[i].label.toUpperCase()}</text>`;
    }).join('');

    chartEl.innerHTML = `
      <svg viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:auto;overflow:visible;">
        <defs>
          <radialGradient id="radarFill_${aircraftId}" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stop-color="rgba(200,169,110,0.3)" />
            <stop offset="100%" stop-color="rgba(200,169,110,0.04)" />
          </radialGradient>
        </defs>
        ${gridPolygons}
        ${axisLines}
        <polygon points="${dataPolygonPts}"
          fill="url(#radarFill_${aircraftId})"
          stroke="#C8A96E" stroke-width="2" stroke-linejoin="round" stroke-opacity="0.85"
          style="transition: all 0.5s ease;" />
        ${dataDots}
        ${axisLabels}
      </svg>
    `;

    // ---- Légende ----
    legendEl.innerHTML = axes.map(axis => `
      <div class="radar-stat">
        <div class="radar-stat-head">
          <div class="radar-stat-icon"><i class="fas fa-${axis.icon}"></i></div>
          <div class="radar-stat-info">
            <span class="radar-stat-label">${escapeHtml(axis.label)}</span>
            <span class="radar-stat-value">${escapeHtml(axis.raw)}</span>
          </div>
          <span class="radar-stat-pct">${Math.round(axis.score)}%</span>
        </div>
        <div class="radar-bar">
          <div class="radar-bar-fill" data-target="${axis.score.toFixed(1)}"></div>
        </div>
      </div>
    `).join('');

    // Animation des barres
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        legendEl.querySelectorAll('.radar-bar-fill').forEach(bar => {
          bar.style.width = bar.dataset.target + '%';
        });
      });
    });
  }

  function renderArmament(armament) {
    const container = document.getElementById('armament-list');
    
    if (!armament || armament.length === 0) {
      container.innerHTML = `<p style="color: var(--text-secondary); text-align: center;">${i18n.t('details.no_armament')}</p>`;
      return;
    }

    container.innerHTML = armament.map(item => `
      <div class="feature-card">
        <h4>${escapeHtml(item.name)}</h4>
        <p>${escapeHtml(item.description) || i18n.t('details.no_desc_available')}</p>
      </div>
    `).join('');
  }

  function renderTechnologies(technologies) {
    const container = document.getElementById('tech-list');
    
    if (!technologies || technologies.length === 0) {
      container.innerHTML = `<p style="color: var(--text-secondary); text-align: center;">${i18n.t('details.no_tech')}</p>`;
      return;
    }

    container.innerHTML = technologies.map(item => `
      <div class="feature-card">
        <h4>${escapeHtml(item.name)}</h4>
        <p>${escapeHtml(item.description) || i18n.t('details.no_desc_available')}</p>
      </div>
    `).join('');
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

    container.innerHTML = missions.map(item => `
      <div class="mission-card">
        <div class="mission-icon">
          <i class="fas fa-${missionIcons[item.name] || 'bullseye'}"></i>
        </div>
        <h4>${escapeHtml(item.name)}</h4>
        <p>${escapeHtml(item.description) || ''}</p>
      </div>
    `).join('');
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
          <div class="war-period">
            <i class="fas fa-calendar-days"></i>
            <span>${startYear} - ${endYear}</span>
          </div>
          <p>${escapeHtml(war.description) || i18n.t('details.no_desc_available')}</p>
        </div>
      `;
    }).join('');
  }

  /* =========================================================================
     FAVORITE FUNCTIONALITY
     ========================================================================= */
  
  const favoriteBtn = document.getElementById('favorite-btn');
  let isFavorite = false;

  async function checkFavoriteStatus() {
    if (!auth.getToken()) return;

    try {
      const response = await auth.authFetch(`/api/airplanes/${aircraftId}/favorite`);

      const data = await response.json();
      isFavorite = data.isFavorite;
      updateFavoriteButton();

    } catch (error) {
      // Erreur silencieuse — statut favori
    }
  }

  function updateFavoriteButton() {
    if (!favoriteBtn) return;

    if (isFavorite) {
      favoriteBtn.classList.add('favorited');
      favoriteBtn.innerHTML = `
        <i class="fas fa-heart"></i>
        <span>${i18n.t('details.remove_favorite')}</span>
      `;
    } else {
      favoriteBtn.classList.remove('favorited');
      favoriteBtn.innerHTML = `
        <i class="far fa-heart"></i>
        <span>${i18n.t('details.add_favorite')}</span>
      `;
    }
  }

  favoriteBtn?.addEventListener('click', async () => {
    if (!auth.getToken()) {
      showToast(i18n.t('common.login_to_favorite'), 'info');
      setTimeout(() => window.location.href = '/login', 1500);
      return;
    }

    try {
      const method = isFavorite ? 'DELETE' : 'POST';
      const response = await auth.authFetch(`/api/favorites/${aircraftId}`, { method });

      if (!response.ok) {
        throw new Error(i18n.t('common.favorite_error'));
      }

      isFavorite = !isFavorite;
      updateFavoriteButton();
      showToast(
        isFavorite ? i18n.t('common.favorite_added') : i18n.t('common.favorite_removed'),
        'success'
      );

    } catch (error) {
      // Erreur gérée via toast
      showToast(error.message, 'error');
    }
  });

  /* =========================================================================
     EDIT & DELETE FUNCTIONALITY
     ========================================================================= */
  
  const editBtn = document.getElementById('edit-btn');
  const deleteBtn = document.getElementById('delete-btn');
  const editModal = document.getElementById('edit-modal');
  const editForm = document.getElementById('edit-form');
  const cancelEditBtn = document.getElementById('cancel-edit-btn');
  const modalClose = document.querySelector('.modal-close');

  editBtn?.addEventListener('click', () => {
    openEditModal();
  });

  [cancelEditBtn, modalClose].forEach(btn => {
    btn?.addEventListener('click', () => closeEditModal());
  });

  editModal?.addEventListener('click', (e) => {
    if (e.target === editModal || e.target.classList.contains('modal-backdrop')) {
      closeEditModal();
    }
  });

  async function openEditModal() {
    if (!aircraftData) return;

    // Populate form
    document.getElementById('edit-name').value = aircraftData.name || '';
    document.getElementById('edit-complete-name').value = aircraftData.complete_name || '';
    document.getElementById('edit-little-description').value = aircraftData.little_description || '';
    document.getElementById('edit-image-url').value = aircraftData.image_url || '';
    document.getElementById('edit-description').value = aircraftData.description || '';
    document.getElementById('edit-status').value = aircraftData.status || '';
    document.getElementById('edit-date-concept').value = aircraftData.date_concept?.split('T')[0] || '';
    document.getElementById('edit-date-first-fly').value = aircraftData.date_first_fly?.split('T')[0] || '';
    document.getElementById('edit-date-operationel').value = aircraftData.date_operationel?.split('T')[0] || '';
    document.getElementById('edit-max-speed').value = aircraftData.max_speed || '';
    document.getElementById('edit-max-range').value = aircraftData.max_range || '';
    document.getElementById('edit-weight').value = aircraftData.weight || '';

    // Load and populate selects
    await loadFormSelects();

    document.getElementById('edit-country-id').value = aircraftData.country_id || '';
    document.getElementById('edit-manufacturer-id').value = aircraftData.id_manufacturer || '';
    document.getElementById('edit-generation-id').value = aircraftData.id_generation || '';
    document.getElementById('edit-type').value = aircraftData.type || '';

    editModal.classList.add('show');
    document.body.style.overflow = 'hidden';
  }

  function closeEditModal() {
    editModal.classList.remove('show');
    document.body.style.overflow = '';
  }

  async function loadFormSelects() {
    try {
      // 1 round-trip HTTP au lieu de 3 (endpoint combiné /api/referentials)
      const response = await auth.fetchWithTimeout('/api/referentials');
      if (!response.ok) throw new Error('Erreur chargement référentiels');
      const { countries, manufacturers, types } = await response.json();

      document.getElementById('edit-country-id').innerHTML = 
        `<option value="">${i18n.t('details.select')}</option>` +
        countries.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');

      document.getElementById('edit-manufacturer-id').innerHTML = 
        `<option value="">${i18n.t('details.select')}</option>` +
        manufacturers.map(m => `<option value="${m.id}">${escapeHtml(m.name)}</option>`).join('');

      document.getElementById('edit-type').innerHTML = 
        `<option value="">${i18n.t('details.select')}</option>` +
        types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');

      document.getElementById('edit-generation-id').innerHTML = 
        `<option value="">${i18n.t('details.select')}</option>` +
        [1, 2, 3, 4, 5].map(g => `<option value="${g}">${g}${i18n.currentLang === 'en' ? (['st','nd','rd'][g-1]||'th') + ' Generation' : 'e Génération'}</option>`).join('');

    } catch (error) {
      // Erreur silencieuse — selects du formulaire
    }
  }

  editForm?.addEventListener('submit', async (e) => {
    e.preventDefault();

    if (!auth.getToken() || (userRole !== 1 && userRole !== 2)) {
      showToast(i18n.t('common.unauthorized'), 'error');
      return;
    }

    const formData = {
      name: document.getElementById('edit-name').value,
      complete_name: document.getElementById('edit-complete-name').value,
      little_description: document.getElementById('edit-little-description').value,
      image_url: document.getElementById('edit-image-url').value,
      description: document.getElementById('edit-description').value,
      country_id: parseInt(document.getElementById('edit-country-id').value) || null,
      id_manufacturer: parseInt(document.getElementById('edit-manufacturer-id').value) || null,
      id_generation: parseInt(document.getElementById('edit-generation-id').value) || null,
      type: parseInt(document.getElementById('edit-type').value) || null,
      status: document.getElementById('edit-status').value,
      date_concept: document.getElementById('edit-date-concept').value || null,
      date_first_fly: document.getElementById('edit-date-first-fly').value || null,
      date_operationel: document.getElementById('edit-date-operationel').value || null,
      max_speed: parseFloat(document.getElementById('edit-max-speed').value) || null,
      max_range: parseFloat(document.getElementById('edit-max-range').value) || null,
      weight: parseFloat(document.getElementById('edit-weight').value) || null
    };

    try {
      const response = await auth.authFetch(`/api/airplanes/${aircraftId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        throw new Error(i18n.t('common.update_error'));
      }

      showToast(i18n.t('common.saved'), 'success');
      closeEditModal();
      
      // Reload data
      await loadAircraftDetails();

    } catch (error) {
      // Erreur gérée via toast
      showToast(error.message || i18n.t('common.update_error'), 'error');
    }
  });

  deleteBtn?.addEventListener('click', async () => {
    if (!confirm(i18n.t('common.confirm_delete') + ` "${aircraftData.name}" ?`)) {
      return;
    }

    try {
      const response = await auth.authFetch(`/api/airplanes/${aircraftId}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error(i18n.t('common.delete_error'));
      }

      showToast(i18n.t('common.deleted'), 'success');
      setTimeout(() => window.location.href = '/hangar', 1500);

    } catch (error) {
      // Erreur gérée via toast
      showToast(error.message || i18n.t('common.delete_error'), 'error');
    }
  });

  /* =========================================================================
     PDF EXPORT
     ========================================================================= */

  document.getElementById('pdf-btn')?.addEventListener('click', () => {
    // Forcer toutes les sections visibles (IntersectionObserver peut avoir opacity:0 sur les sections hors viewport)
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(section => {
      section.style.opacity = '1';
      section.style.transform = 'none';
      section.style.transition = 'none';
    });

    // Laisser le navigateur appliquer les styles avant d'ouvrir la boîte d'impression
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        window.print();
        // Restaurer les transitions après impression
        sections.forEach(section => {
          section.style.transition = 'all 0.5s ease';
        });
      });
    });
  });

  // Backup pour Ctrl+P direct
  window.addEventListener('beforeprint', () => {
    document.querySelectorAll('.content-section').forEach(section => {
      section.style.opacity = '1';
      section.style.transform = 'none';
      section.style.transition = 'none';
    });
  });

  /* =========================================================================
     KEYBOARD SHORTCUTS
     ========================================================================= */

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeEditModal();
    }
  });

  /* =========================================================================
     ANIMATIONS
     ========================================================================= */
  
  const observeElements = () => {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    document.querySelectorAll('.content-section').forEach(section => {
      section.style.opacity = '0';
      section.style.transform = 'translateY(20px)';
      section.style.transition = 'all 0.5s ease';
      observer.observe(section);
    });
  };

  /* =========================================================================
     INITIALIZE
     ========================================================================= */

  await loadAircraftDetails();
  observeElements();

  // Re-render on language change
  window.addEventListener('langChanged', () => {
    if (aircraftData) {
      renderAircraftDetails();
      loadRelatedData();
      updateFavoriteButton();
    }
  });

});