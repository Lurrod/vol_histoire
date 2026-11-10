/* Chargement fiche avion + related + mise à jour SEO (JSON-LD Article sur un Vehicle + BreadcrumbList). */
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
    // Le h1 rendu par le serveur (sans data-i18n) porte déjà le nom : il reste
    // en place, pour les robots qui rendent la page comme pour le visiteur.
    const name = document.getElementById('aircraft-name');
    if (name && (name.hasAttribute('data-i18n') || !name.textContent.trim())) {
      name.innerHTML = '<span class="skeleton-line skeleton-inline-xl"></span>';
    }
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

  /* Seul un appareil réellement inexistant mène à /404 (404, ou 400 pour un
   * identifiant hors plage). Une erreur passagère — 429 du limiteur, 5xx,
   * délai dépassé, réseau coupé — garde la page : le serveur en a déjà rendu
   * le titre, l'image et les méta, et une redirection vers /404 (noindex)
   * transformait une fiche valide en page introuvable (SEO-005). */
  const NOT_FOUND_STATUSES = [400, 404];

  async function loadAircraftDetails(state) {
    clearLoadError();
    mountDetailsSkeletons();
    let response;
    try {
      response = await auth.fetchWithTimeout(`/api/airplanes/${state.aircraftId}`);
    } catch {
      showLoadError(state);
      return;
    }
    if (NOT_FOUND_STATUSES.includes(response.status)) {
      window.location.href = '/404';
      return;
    }
    try {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      state.aircraftData = await response.json();
      VH.details.render.renderAircraftDetails(state);
    } catch {
      showLoadError(state);
      return;
    }
    loadRelatedData(state);
    VH.details.lineage.load(state);
    VH.details.favorites.checkFavoriteStatus(state);
  }

  /* Texte traduit + data-i18n : si l'erreur survient avant le chargement des
   * traductions (429 immédiat), applyToDOM() le traduira à leur arrivée. */
  function setText(el, key) {
    el.setAttribute('data-i18n', key);
    el.textContent = i18n.t(key);
  }

  /* État d'erreur : squelettes retirés, message et bouton « Réessayer » à la
   * place de la description. Construit en DOM (textContent), sans HTML. */
  function showLoadError(state) {
    document.querySelectorAll('.skeleton-line').forEach((el) => el.remove());
    const name = document.getElementById('aircraft-name');
    if (name && !name.textContent.trim()) name.textContent = i18n.t('details.aircraft_default_title');
    const desc = document.getElementById('aircraft-description');
    if (!desc || !desc.parentNode) return;
    clearLoadError();
    const box = document.createElement('div');
    box.className = 'empty-state details-load-error';
    box.id = 'details-load-error';
    box.setAttribute('role', 'alert');
    const icon = document.createElement('i');
    icon.className = 'fas fa-triangle-exclamation';
    icon.setAttribute('aria-hidden', 'true');
    const title = document.createElement('h3');
    setText(title, 'details.load_error_title');
    // <div> et non <p> : la section applique une lettrine au premier <p>.
    const text = document.createElement('div');
    text.className = 'details-load-error-text';
    setText(text, 'details.load_error_desc');
    const retry = document.createElement('button');
    retry.type = 'button';
    retry.className = 'btn btn-primary';
    const retryLabel = document.createElement('span');
    setText(retryLabel, 'details.retry');
    // Pas d'icône dans le bouton : la règle .empty-state .icon (4rem) la
    // grossirait.
    retry.append(retryLabel);
    retry.addEventListener('click', () => {
      retry.disabled = true;
      retry.setAttribute('aria-busy', 'true');
      loadAircraftDetails(state);
    });
    box.append(icon, title, text, retry);
    desc.hidden = true;
    // Après la description masquée : elle reste le premier <p> de la section,
    // seul à recevoir la lettrine (p:first-of-type::first-letter).
    desc.after(box);
  }

  function clearLoadError() {
    const box = document.getElementById('details-load-error');
    if (box) box.remove();
    const desc = document.getElementById('aircraft-description');
    if (desc) desc.hidden = false;
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

  const SITE_URL = 'https://vol-histoire.titouan-borde.com';

  /* og:image et JSON-LD exigent une URL absolue. */
  function toAbsoluteUrl(url) {
    const u = String(url || '');
    if (u.startsWith('/')) return SITE_URL + u;
    return u.replace(/^http:\/\//, 'https://');
  }

  /* Texte brut du premier paragraphe d'un récit Markdown (titres, emphase,
   * liens, code et puces retirés) — même règle que backend/utils/ssr-head.js. */
  function markdownToText(md) {
    const para = [];
    for (const raw of String(md || '').replace(/\r\n?/g, '\n').split('\n')) {
      const line = raw.trim();
      if (!line) { if (para.length) break; continue; }
      if (/^#{1,6}\s/.test(line)) { if (para.length) break; continue; }
      para.push(line.replace(/^(?:[-*+>]|\d+[.)])\s+/, ''));
    }
    return para.join(' ')
      .replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1')
      .replace(/(\*\*|__)(.+?)\1/g, '$2')
      .replace(/(^|[^\w*])\*(?!\s)([^*]+?)\*(?!\w)/g, '$1$2')
      .replace(/`([^`]*)`/g, '$1')
      .replace(/\s+/g, ' ')
      .trim();
  }

  /* Meta description sans Markdown : accroche + début du récit, coupée sur
   * un mot, 155 caractères au plus. */
  function plainDescription(lead, narrative, max = 155) {
    let head = String(lead || '').replace(/\s+/g, ' ').trim();
    if (head && !/[.!?…]$/.test(head)) head += '.';
    const text = [head, markdownToText(narrative)].filter(Boolean).join(' ');
    if (text.length <= max) return text;
    const cut = text.slice(0, max - 1).replace(/[\s,;:]+\S*$/, '');
    return /[.!?…]$/.test(cut) ? cut : `${cut}…`;
  }

  /* La page a-t-elle été rendue par le serveur pour cette fiche ? Le
   * canonical du rendu serveur vise l'URL de la fiche (…?lang=en pour la
   * version anglaise) — et ne porte pas data-client, marque du repli posé
   * ci-dessous. */
  function isServerRendered(pageUrl) {
    const canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical || canonical.hasAttribute('data-client')) return false;
    const href = canonical.getAttribute('href');
    return href === pageUrl || href === `${pageUrl}?lang=en`;
  }

  /* Balises SEO + JSON-LD.
   * Le serveur est la source de vérité de la tête de page (titre, description,
   * canonical, hreflang, og:*, twitter:*, JSON-LD) : quand il a rendu la
   * fiche, le client n'y touche plus et rétablit seulement le titre d'onglet
   * du serveur (render.js l'écrase). Auparavant, le client remplaçait la
   * description par le récit Markdown brut (« ## Genèse… », SEO-006) et
   * réécrivait canonical et hreflang (SEO-002).
   * Repli sans rendu serveur : balises posées ici (description sans Markdown,
   * hreflang du gabarit laissés tels quels). Les blocs JSON-LD portent les
   * mêmes id que ceux du rendu serveur (routes/details-ssr.js) : mis à jour
   * sur place, jamais doublés ; l'Article a le Vehicle pour objet. */
  function updateSeoMeta(state, name, description, imageUrl, pageUrl) {
    if (isServerRendered(pageUrl)) {
      const ogTitle = document.querySelector('meta[property="og:title"]');
      if (ogTitle && ogTitle.content) document.title = ogTitle.content;
      return;
    }
    imageUrl = toAbsoluteUrl(imageUrl);
    const fullTitle = `${name} | Vol d'Histoire`;
    document.title = fullTitle;
    const lead = state && state.aircraftData ? state.aircraftData.little_description : '';
    const desc = plainDescription(lead, description)
      || 'Fiche technique, armement, production et histoire de cet appareil militaire.';

    // Canonical
    let canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical) { canonical = document.createElement('link'); canonical.setAttribute('rel', 'canonical'); document.head.appendChild(canonical); }
    canonical.href = pageUrl;
    canonical.setAttribute('data-client', '');

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

    // JSON-LD : l'Article du serveur garde ses champs propres (headline,
    // dates, éditeur) ; on lui (re)donne son objet Vehicle et l'URL courante.
    const vehicle = buildVehicleLd(state, name, desc, imageUrl, pageUrl);
    upsertJsonLd('jsonld-article', buildArticleLd(readJsonLd('jsonld-article'), vehicle, name, desc, imageUrl, pageUrl));
    upsertJsonLd('jsonld-breadcrumb', buildBreadcrumbLd(name, pageUrl));
    // Ancien bloc Vehicle autonome (versions précédentes) : retiré s'il existe.
    const legacy = document.getElementById('jsonld-vehicle');
    if (legacy) legacy.remove();
  }

  function readJsonLd(id) {
    const el = document.getElementById(id);
    if (!el) return null;
    try { return JSON.parse(el.textContent); } catch { return null; }
  }

  /* Article de la fiche : on part de celui du serveur s'il existe (sans le
   * modifier : on en construit une copie), sinon d'un Article minimal. */
  function buildArticleLd(existing, vehicle, name, desc, imageUrl, pageUrl) {
    const base = existing && existing['@type'] === 'Article'
      ? existing
      : { '@context': 'https://schema.org', '@type': 'Article', headline: name };
    const lang = (window.i18n && i18n.currentLang) || 'fr';
    // Objet imbriqué : le @context est porté par l'Article.
    const about = Object.fromEntries(Object.entries(vehicle).filter(([k]) => k !== '@context'));
    return { ...base, name, description: desc, image: imageUrl, url: pageUrl, inLanguage: lang, about };
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
    if (a.empty_weight) {
      ld.weight = { '@type': 'QuantitativeValue', value: Number(a.empty_weight), unitCode: 'KGM' };
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

  VH.details.data = {
    loadAircraftDetails, loadRelatedData, updateSeoMeta, slugify, buildVehicleLd, buildArticleLd,
    markdownToText, plainDescription, showLoadError,
  };
})();
