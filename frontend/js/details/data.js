/* Chargement fiche avion + related + mise à jour SEO (incluant JSON-LD Vehicle + BreadcrumbList). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function slugify(text) {
    return text
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  function mountDetailsSkeletons() {
    const name = document.getElementById('aircraft-name');
    if (name) name.innerHTML = '<span class="skeleton-line skeleton-inline-xl"></span>';
    const sub = document.getElementById('aircraft-complete-name');
    if (sub) sub.innerHTML = '<span class="skeleton-line skeleton-inline-md"></span>';
    ['hero-country', 'hero-manufacturer', 'hero-year'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.innerHTML = '<span class="skeleton-line skeleton-inline-meta"></span>';
    });
    ['stat-speed', 'stat-range', 'stat-weight', 'stat-status'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.innerHTML = '<span class="skeleton-line skeleton-inline-badge"></span>';
    });
    const desc = document.getElementById('aircraft-description');
    if (desc) desc.innerHTML =
      '<span class="skeleton-line skeleton-block"></span>' +
      '<span class="skeleton-line skeleton-block"></span>' +
      '<span class="skeleton-line medium skeleton-block-last"></span>';
  }

  async function loadAircraftDetails(state) {
    mountDetailsSkeletons();
    try {
      const response = await auth.fetchWithTimeout(`/api/airplanes/${state.aircraftId}`);
      if (!response.ok) throw new Error(i18n.t('details.not_found'));
      state.aircraftData = await response.json();
      VH.details.render.renderAircraftDetails(state);
      loadRelatedData(state);
      VH.details.favorites.checkFavoriteStatus(state);
    } catch {
      window.location.href = '/404';
    }
  }

  async function loadRelatedData(state) {
    try {
      const response = await auth.fetchWithTimeout(`/api/airplanes/${state.aircraftId}/related`);
      if (!response.ok) throw new Error('Erreur serveur');
      const { armament, tech, missions, wars } = await response.json();
      VH.details.render.renderArmament(armament);
      VH.details.render.renderTechnologies(tech);
      VH.details.render.renderMissions(missions);
      VH.details.render.finalizeCapabilities();
      VH.details.render.renderWars(wars);
      VH.details.radar.render(state, armament, tech, missions);
    } catch { /* silencieux */ }
  }

  /* Mise à jour des balises SEO dynamiques + JSON-LD Vehicle + BreadcrumbList.
   * Google consomme Vehicle pour les fiches techniques — plus riche que Thing. */
  function updateSeoMeta(state, name, description, imageUrl, pageUrl) {
    const fullTitle = `${name} | Vol d'Histoire`;
    const desc = description
      ? description.substring(0, 155).trimEnd() + (description.length > 155 ? '...' : '')
      : 'Découvrez les spécifications détaillées, l\'armement et l\'historique de cet avion de chasse.';

    // Canonical
    let canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical) { canonical = document.createElement('link'); canonical.setAttribute('rel', 'canonical'); document.head.appendChild(canonical); }
    canonical.href = pageUrl;

    // Hreflang (fr + x-default pointent vers la même URL canonique)
    ['fr', 'x-default'].forEach(lang => {
      let el = document.querySelector(`link[rel="alternate"][hreflang="${lang}"]`);
      if (el) el.href = pageUrl;
    });

    // Meta description
    let metaDesc = document.querySelector('meta[name="description"]');
    if (!metaDesc) { metaDesc = document.createElement('meta'); metaDesc.setAttribute('name', 'description'); document.head.appendChild(metaDesc); }
    metaDesc.content = desc;

    // Open Graph + Twitter
    const ogProps = { 'og:title': fullTitle, 'og:description': desc, 'og:url': pageUrl, 'og:image': imageUrl };
    Object.entries(ogProps).forEach(([prop, val]) => {
      let el = document.querySelector(`meta[property="${prop}"]`);
      if (!el) { el = document.createElement('meta'); el.setAttribute('property', prop); document.head.appendChild(el); }
      el.content = val;
    });
    const twitterProps = { 'twitter:title': fullTitle, 'twitter:description': desc, 'twitter:image': imageUrl };
    Object.entries(twitterProps).forEach(([n, val]) => {
      let el = document.querySelector(`meta[name="${n}"]`);
      if (!el) { el = document.createElement('meta'); el.setAttribute('name', n); document.head.appendChild(el); }
      el.content = val;
    });

    // JSON-LD — remplace l'ancien "Thing" par Vehicle + BreadcrumbList.
    // On injecte DEUX <script type="application/ld+json"> : l'un pour Vehicle,
    // l'autre pour BreadcrumbList — forme recommandée par Google Search Central.
    upsertJsonLd('jsonld-vehicle', buildVehicleLd(state, name, desc, imageUrl, pageUrl));
    upsertJsonLd('jsonld-breadcrumb', buildBreadcrumbLd(name, pageUrl));
  }

  function buildVehicleLd(state, name, desc, imageUrl, pageUrl) {
    const a = state.aircraftData || {};
    const ld = {
      '@context': 'https://schema.org',
      '@type': 'Vehicle',
      name,
      description: desc,
      image: imageUrl,
      url: pageUrl,
      vehicleConfiguration: a.type_name || undefined,
      vehicleModelDate: a.date_operationel ? new Date(a.date_operationel).getFullYear().toString() : undefined,
    };
    if (a.complete_name) ld.alternateName = a.complete_name;
    if (a.manufacturer_name) {
      ld.manufacturer = { '@type': 'Organization', name: a.manufacturer_name };
    }
    if (a.country_name) {
      ld.countryOfOrigin = { '@type': 'Country', name: a.country_name };
    }
    if (a.date_first_fly) {
      ld.productionDate = a.date_first_fly.split('T')[0];
    }
    if (a.max_speed) {
      ld.speed = { '@type': 'QuantitativeValue', value: Number(a.max_speed), unitCode: 'KMH' };
    }
    if (a.max_range) {
      // Schema.org n'a pas de champ 'range' natif pour Vehicle → additionalProperty
      ld.additionalProperty = ld.additionalProperty || [];
      ld.additionalProperty.push({ '@type': 'PropertyValue', name: 'Range', value: Number(a.max_range), unitCode: 'KMT' });
    }
    if (a.weight) {
      ld.weight = { '@type': 'QuantitativeValue', value: Number(a.weight), unitCode: 'KGM' };
    }
    // Supprime les undefined (Schema.org valide sans)
    Object.keys(ld).forEach(k => ld[k] === undefined && delete ld[k]);
    return ld;
  }

  function buildBreadcrumbLd(name, pageUrl) {
    return {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      itemListElement: [
        { '@type': 'ListItem', position: 1, name: i18n.t('nav.home'), item: 'https://vol-histoire.titouan-borde.com/' },
        { '@type': 'ListItem', position: 2, name: i18n.t('nav.hangar'), item: 'https://vol-histoire.titouan-borde.com/hangar' },
        { '@type': 'ListItem', position: 3, name, item: pageUrl },
      ],
    };
  }

  function upsertJsonLd(id, data) {
    let script = document.getElementById(id);
    if (!script) {
      script = document.createElement('script');
      script.type = 'application/ld+json';
      script.id = id;
      document.head.appendChild(script);
    }
    script.textContent = JSON.stringify(data);
  }

  VH.details.data = { loadAircraftDetails, loadRelatedData, updateSeoMeta, slugify };
})();
