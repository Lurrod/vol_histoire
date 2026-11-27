/* Rendu de la fiche avion + sections related (armament, tech, missions, wars). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  /* Sans mise en service (prototype, projet annulé : 123 fiches), l'année du
   * hero restait un squelette de chargement. On donne l'année du premier vol,
   * ou l'on retire l'élément s'il n'y a aucune date. Une année déjà écrite
   * (rendu serveur) est conservée. */
  function renderHeroFirstFlight(a) {
    const year = document.getElementById('hero-year');
    if (!year) return;
    const pending = year.querySelector('.skeleton-inline-meta') || ['', '-'].includes(year.textContent.trim());
    if (!pending) return;
    if (a.date_first_fly) {
      const y = window.VH.calendarDate.year(a.date_first_fly);
      const label = i18n.t('details.hero_first_flight', { year: y });
      year.textContent = label === 'details.hero_first_flight' ? `1er vol en ${y}` : label;
    } else {
      const item = year.closest('.meta-item');
      if (item) item.hidden = true;
    }
  }

  /* Génération : dernier élément de la ligne pays · constructeur · année
   * (« 4e génération », « 4th generation »), masqué si elle est inconnue.
   * Elle était dans une ligne d'accroche au-dessus du titre, supprimée. */
  function renderHeroGeneration(a) {
    const item = document.getElementById('hero-generation-item');
    const text = document.getElementById('hero-generation');
    if (!item || !text) return;
    const g = Number(a.generation);
    if (!g) { item.hidden = true; return; }
    text.textContent = i18n.currentLang === 'en'
      ? `${g}${['st', 'nd', 'rd'][g - 1] || 'th'} generation`
      : `${g}e génération`;
    item.hidden = false;
  }

  function renderAircraftDetails(state) {
    const a = state.aircraftData;

    const slug = VH.details.data.slugify(a.name);
    const cleanPath = `/details/${slug}-${state.aircraftId}`;
    // ?lang=en désigne la version anglaise indexée (SEO-001) : on la garde ;
    // l'ancien ?id= disparaît au profit du chemin propre. Le titre est posé
    // par updateSeoMeta (celui du serveur quand la page a été rendue en SSR).
    const lang = new URLSearchParams(location.search).get('lang');
    const query = lang ? `?lang=${encodeURIComponent(lang)}` : '';
    history.replaceState({ id: state.aircraftId }, '', cleanPath + query);
    const pageUrl = `https://vol-histoire.titouan-borde.com${cleanPath}`;
    const imageUrl = a.image_url || 'https://vol-histoire.titouan-borde.com/assets/airplanes/a10-thunderbolt-2.jpg';
    VH.details.data.updateSeoMeta(state, a.name, a.description, imageUrl, pageUrl);

    document.getElementById('breadcrumb-name').textContent = a.name;
    document.getElementById('aircraft-name').textContent = a.name || 'N/A';
    document.getElementById('aircraft-complete-name').textContent = a.complete_name || '';

    renderHeroGeneration(a);

    document.getElementById('hero-country').textContent = a.country_name || i18n.t('details.not_specified');
    document.getElementById('hero-manufacturer').textContent = a.manufacturer_name || i18n.t('details.not_specified');
    if (a.date_operationel) {
      document.getElementById('hero-year').textContent = window.VH.calendarDate.year(a.date_operationel);
    } else {
      renderHeroFirstFlight(a);
    }

    renderHeroImage(a);

    renderImageCredit(a);

    const num = VH.details.data.formatNumber;
    document.getElementById('stat-speed').textContent = a.max_speed ? `${num(a.max_speed)} km/h` : 'N/A';
    document.getElementById('stat-range').textContent = a.max_range ? `${num(a.max_range)} km` : 'N/A';
    document.getElementById('stat-weight').textContent = a.empty_weight ? `${num(a.empty_weight)} kg` : 'N/A';
    document.getElementById('stat-status').textContent = a.status || i18n.t('details.not_specified');

    // Dates clés : précision réelle de chaque date et écart entre jalons.
    VH.details.keyDates.render(a);

    // Description : Markdown (titres, listes) ou texte simple dans un <p>.
    // Même balisage que le rendu serveur (utils/details-body-ssr.js, SEO-001) :
    // la fiche ne bouge pas quand le client la réécrit.
    const descEl = document.getElementById('aircraft-description');
    if (descEl) {
      // Contenu final : i18n ne doit plus y remettre le texte d'attente.
      descEl.removeAttribute('data-i18n');
      if (VH.details.markdown.isMarkdown(a.description)) {
        const html = VH.details.markdown.parse(a.description);
        descEl.classList.add('markdown-body');
        if (typeof safeSetHTML === 'function') safeSetHTML(descEl, html);
        else descEl.innerHTML = html;
      } else {
        descEl.classList.remove('markdown-body');
        const p = document.createElement('p');
        p.textContent = a.description || i18n.t('details.no_description');
        descEl.replaceChildren(p);
      }
    }

    // Nouvelles sections (strates 1-3-4-6)
    renderSpecs(a);
    renderProduction(a);
    renderRelatedAircraft(a);
    renderSources(a);
  }

  // Attribution de la photo. Les licences Creative Commons imposent de citer
  // l'auteur : sans crédit renseigné, la légende reste masquée.
  function placeholderUrl() {
    return `/assets/logo/placeholder-airplane-${i18n.currentLang === 'en' ? 'en' : 'fr'}.svg`;
  }

  /* Image hero = élément LCP de la fiche : le SSR la pose avec
   * fetchpriority="high". Elle ne doit jamais repasser en loading="lazy"
   * (PERF-005), y compris sur le repli /details?id=X où le JS la remplit. */
  function renderHeroImage(a) {
    const heroImage = document.getElementById('hero-image');
    if (!heroImage) return;
    VH.shared.picture.applySourcesTo(heroImage, a.image_url || placeholderUrl());
    heroImage.alt = [a.name, a.manufacturer_name, a.country_name].filter(Boolean).join(' — ');
    heroImage.loading = 'eager';
  }

  /* Repli d'image sans gestionnaire en ligne : la CSP (script-src sans
   * 'unsafe-inline') bloque tout attribut onerror="…" (JS-005). Les erreurs de
   * chargement d'image ne remontent pas : l'écouteur délégué est posé en phase
   * de capture. Première erreur : placeholder SVG localisé (les <source>
   * AVIF / WebP sont retirées, un <source> en 404 ne retombant pas sur
   * l'<img>) ; si le placeholder échoue aussi, l'image est masquée. */
  const _fallbackBound = new WeakSet();
  function bindImageFallback(container) {
    if (!container || _fallbackBound.has(container)) return;
    _fallbackBound.add(container);
    container.addEventListener('error', (e) => {
      const img = e.target;
      if (!img || img.tagName !== 'IMG') return;
      const pic = img.closest('picture');
      if (img.dataset.fallback === '1') {
        (pic || img).hidden = true;
        return;
      }
      img.dataset.fallback = '1';
      if (pic) pic.querySelectorAll('source').forEach((src) => src.remove());
      img.src = placeholderUrl();
    }, true);
  }

  function renderImageCredit(a) {
    const el = document.getElementById('image-credit');
    if (!el) return;
    const photoCredit = VH.shared && VH.shared.photoCredit;
    if (photoCredit) {
      // Auteur, lien vers la licence et mention des modifications (LEGAL-003).
      const shown = photoCredit.fillCredit(el, { author: a.image_credit, licence: a.image_licence }, (k) => i18n.t(k));
      el.hidden = !shown;
      return;
    }
    // Repli sans le module partagé : texte seul.
    const licence = a.image_licence === 'Public domain'
      ? i18n.t('details.licence_public_domain')
      : a.image_licence;
    const parts = [a.image_credit, licence].filter(Boolean);
    if (parts.length === 0) { el.hidden = true; el.textContent = ''; return; }
    el.textContent = `${i18n.t('details.photo')} : ${parts.join(' — ')}`;
    el.hidden = false;
  }

  // ── Strate 1 + 2 : Fiche technique étendue ──────────────────────
  /* Une ligne « libellé — valeur » (dt / dd), valeur déjà formatée. */
  function specRow(labelKey, value, translated = false) {
    const label = translated ? labelKey : i18n.t(labelKey);
    return `<div class="spec-row"><dt class="spec-label">${escapeHtml(label)}</dt>` +
      `<dd class="spec-value">${escapeHtml(String(value))}</dd></div>`;
  }

  const present = (v) => v != null && v !== '';

  /* Nombre strictement positif (l'API renvoie des nombres, des chaînes pour
   * les BIGINT, ou null) ; null sinon. */
  function positive(v) {
    if (!present(v)) return null;
    const n = Number(v);
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  /* Valeurs calculées à partir des colonnes existantes. La poussée est
   * stockée PAR MOTEUR (B-52 : 8 × 75,6 kN) ; la plus forte des deux
   * (post-combustion si elle existe) sert aux totaux et au rapport. Les
   * rapports sont pris à la masse maximale au décollage, seule masse
   * « chargée » connue pour tout le catalogue — le libellé le dit. */
  const G = 9.80665;
  /* Motorisation mixte, écrite « A + 8 B » ou « A (+ 2 B d'appoint) »
   * (Mirage III V, Do 31, Yak-38, Trident…) : la poussée stockée est celle
   * du moteur principal, la multiplier par le nombre de moteurs serait faux. */
  const MIXED_ENGINES = /\s\+\s|\(\+/;
  const derived = {
    maxThrust: (a) => positive(a.thrust_wet) || positive(a.thrust_dry),
    totalThrust(a) {
      if (MIXED_ENGINES.test(String(a.engine_name || ''))) return null;
      const per = derived.maxThrust(a);
      const count = positive(a.engine_count);
      return per && count ? per * count : null;
    },
    payload(a) {
      const mtow = positive(a.mtow);
      const empty = positive(a.empty_weight);
      return mtow && empty && mtow > empty ? mtow - empty : null;
    },
    wingLoading(a) {
      const mtow = positive(a.mtow);
      const area = positive(a.wing_area);
      return mtow && area ? mtow / area : null;
    },
    thrustToWeight(a) {
      const total = derived.totalThrust(a);
      const mtow = positive(a.mtow);
      return total && mtow ? (total * 1000) / (mtow * G) : null;
    },
  };

  /* Fabriques de lignes : chacune renvoie la valeur affichée, ou null pour
   * ne pas afficher la ligne. `num` est formatNumber (langue du site). */
  const col = (field, unit = null, digits = 2) => (a, num) => {
    const v = a[field];
    if (!present(v)) return null;
    if (typeof v !== 'number') return String(v);
    return unit ? `${num(v, digits)} ${unit}` : num(v, digits);
  };
  const calc = (fn, unit, digits) => (a, num) => {
    const v = fn(a);
    return v == null ? null : `${num(v, digits)}${unit ? ` ${unit}` : ''}`;
  };
  const yesNo = (v) => i18n.t(v ? 'details.spec_yes' : 'details.spec_no');

  /* Poussée par moteur : précisé dès qu'il y a plusieurs moteurs ; « moteur
   * principal » si la motorisation est mixte (Mirage III V : la poussée est
   * celle du TF106, pas celle des huit réacteurs de sustentation). */
  const perEngine = (labelKey) => (a) => {
    const label = i18n.t(labelKey);
    if (Number(a.engine_count) <= 1) return label;
    const mixed = MIXED_ENGINES.test(String(a.engine_name || ''));
    return `${label} (${i18n.t(mixed ? 'details.spec_main_engine' : 'details.spec_per_engine')})`;
  };

  /* Groupes de lignes « libellé — valeur » (17 tuiles à icône auparavant :
   * sur téléphone, 2 400 px pour la seule fiche). Une ligne = [libellé
   * (clé, ou fonction de la fiche), lecture de la valeur]. Les colonnes de
   * la strate 7 (Mach, convoyage, emport, radar, carburant) s'affichent
   * dès qu'elles sont renseignées. */
  const SPEC_GROUPS = [
    ['details.spec_group_airframe', [
      ['details.spec_length', col('length', 'm')],
      ['details.spec_wingspan', col('wingspan', 'm')],
      ['details.spec_height', col('height', 'm')],
      ['details.spec_wing_area', col('wing_area', 'm²')],
      ['details.spec_empty_weight', col('empty_weight', 'kg')],
      ['details.spec_mtow', col('mtow', 'kg')],
      ['details.spec_payload', calc(derived.payload, 'kg', 0)],
      ['details.spec_internal_fuel', col('internal_fuel', 'kg', 0)],
      ['details.spec_crew', col('crew')],
    ]],
    ['details.spec_group_performance', [
      ['details.spec_max_speed', col('max_speed', 'km/h', 0)],
      ['details.spec_mach_max', (a, num) => (positive(a.mach_max) ? `Mach ${num(a.mach_max, 2)}` : null)],
      // Sans objet pour un appareil subsonique : affichée si elle est
      // confirmée, ou si l'appareil passe Mach 1.
      ['details.spec_supercruise', (a) => {
        if (a.supercruise === true) return yesNo(true);
        return a.supercruise === false && Number(a.mach_max) >= 1 ? yesNo(false) : null;
      }],
      ['details.spec_max_range', col('max_range', 'km', 0)],
      ['details.spec_ferry_range', col('ferry_range', 'km', 0)],
      ['details.spec_combat_radius', col('combat_radius', 'km', 0)],
      ['details.spec_ceiling', col('service_ceiling', 'm')],
      ['details.spec_climb_rate', col('climb_rate', 'm/s')],
      ['details.spec_g_pos', col('g_limit_pos', 'g')],
      ['details.spec_g_neg', col('g_limit_neg', 'g')],
    ]],
    ['details.spec_group_propulsion', [
      ['details.spec_engine', col('engine_name')],
      ['details.spec_engine_count', col('engine_count')],
      ['details.spec_engine_type', col('engine_type')],
      [perEngine('details.spec_thrust_dry'), col('thrust_dry', 'kN')],
      [perEngine('details.spec_thrust_wet'), col('thrust_wet', 'kN')],
      // Utile seulement à plusieurs moteurs : « 151,24 kN (2 × 75,62) ».
      ['details.spec_thrust_total', (a, num) => {
        const count = Number(a.engine_count);
        const total = derived.totalThrust(a);
        return count > 1 && total ? `${num(total, 1)} kN (${count} × ${num(derived.maxThrust(a), 2)})` : null;
      }],
    ]],
    ['details.spec_group_ratios', [
      ['details.spec_wing_loading', calc(derived.wingLoading, 'kg/m²', 0)],
      ['details.spec_thrust_weight', calc(derived.thrustToWeight, null, 2)],
    ]],
    ['details.spec_group_stores', [
      ['details.spec_hardpoints', col('hardpoints')],
      ['details.spec_weapons_bay', (a) => (typeof a.internal_weapons_bay === 'boolean' ? yesNo(a.internal_weapons_bay) : null)],
      ['details.spec_radar', col('radar_model')],
    ]],
  ];

  function renderSpecs(a) {
    const section = document.getElementById('specs-section');
    const grid = document.getElementById('specs-grid');
    if (!section || !grid) return;

    const num = VH.details.data.formatNumber;
    const groups = SPEC_GROUPS.map(([titleKey, fields]) => {
      const rows = fields
        .map(([label, read]) => [label, read(a, num)])
        .filter(([, shown]) => shown != null && shown !== '')
        .map(([label, shown]) => (typeof label === 'function'
          ? specRow(label(a), shown, true)
          : specRow(label, shown)));
      if (rows.length === 0) return '';
      return `<section class="spec-group"><h3 class="spec-group-title">${escapeHtml(i18n.t(titleKey))}</h3>` +
        `<dl class="spec-list">${rows.join('')}</dl></section>`;
    }).filter(Boolean);

    if (groups.length === 0) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    grid.innerHTML = groups.join('');
  }

  // ── Strate 3 : Production & Service ──────────────────────────────
  function renderProduction(a) {
    const section = document.getElementById('production-section');
    const grid = document.getElementById('production-grid');
    if (!section || !grid) return;

    // Séparateur décimal et abréviation selon la langue : « 2,1 Md $ » en
    // français, « 2.1 B $ » en anglais. Repli français tant que les locales
    // ne sont pas chargées (i18n.t() renvoie alors la clé).
    const locale = i18n.currentLang === 'en' ? 'en' : 'fr';
    const unitLabel = (key, fallback) => {
      const value = i18n.t(key);
      return value && value !== key ? value : fallback;
    };
    const fmtNumber = (n, maxDigits) =>
      new Intl.NumberFormat(locale, { minimumFractionDigits: 0, maximumFractionDigits: maxDigits }).format(n);
    const fmtCost = (raw) => {
      if (raw == null) return null;
      const usd = Number(raw); // BIGINT : pg le renvoie en chaîne
      if (usd >= 1_000_000_000) return `${fmtNumber(usd / 1_000_000_000, 2)} ${unitLabel('details.cost_billion', 'Md $')}`;
      if (usd >= 1_000_000) return `${fmtNumber(usd / 1_000_000, 1)} ${unitLabel('details.cost_million', 'M $')}`;
      return `${fmtNumber(usd, 0)} $`;
    };

    const prodYears = a.production_start
      ? (a.production_end
          ? `${a.production_start} – ${a.production_end}`
          : `${a.production_start} – ${i18n.t('details.prod_today')}`)
      : null;
    const costStr = a.unit_cost_usd
      ? fmtCost(a.unit_cost_usd) + (a.unit_cost_year ? ` (${a.unit_cost_year})` : '')
      : null;

    const items = [
      ['details.prod_years', prodYears],
      ['details.prod_units_built', a.units_built != null ? fmtNumber(a.units_built, 0) : null],
      ['details.prod_unit_cost', costStr],
      ['details.prod_operators', a.operators_count],
      ['details.prod_stealth', a.stealth_level ? stealthLabel(a.stealth_level) : null],
      ['details.prod_nickname', a.nickname],
    ];
    const rows = items.filter(([, v]) => present(v)).map(([labelKey, value]) => specRow(labelKey, value));

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

    if (rows.length === 0 && !a.variants) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    grid.innerHTML = rows.length ? `<dl class="spec-list">${rows.join('')}</dl>` : '';
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
      // Pas d'image en base : placeholder SVG localisé, comme shared/card.js.
      const relPic = VH.shared.picture.pictureHtml(img || placeholderUrl(), {
        alt: '',
        loading: 'lazy',
        width: '300',
        height: '200',
      });
      cards.push(`
        <a class="related-card" href="${href}" data-morph-id="${Number(id)}">
          <span class="related-relation">${relation}</span>
          <div class="related-img" data-morph="photo">${relPic}</div>
          <h3>${escapeHtml(name)}</h3>
          <span class="related-arrow"><i class="fas fa-arrow-right"></i></span>
        </a>
      `);
    }
    addCard(i18n.t('details.related_predecessor'), a.predecessor_id, a.predecessor_name, a.predecessor_image);
    addCard(i18n.t('details.related_successor'), a.successor_id, a.successor_name, a.successor_image);
    addCard(i18n.t('details.related_rival'), a.rival_id, a.rival_name, a.rival_image);

    if (cards.length === 0) { section.classList.add('hidden'); return; }
    section.classList.remove('hidden');
    bindImageFallback(grid);
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

  // hrefFor(item) : lien optionnel sur le nom (missions → hangar filtré).
  function renderCapabilityList(items, listId, countId, columnId, hrefFor) {
    const list = document.getElementById(listId);
    const column = document.getElementById(columnId);
    const count = document.getElementById(countId);
    if (!list || !column) return 0;
    if (!items || items.length === 0) {
      column.classList.add('hidden');
      list.innerHTML = '';
      if (count) count.textContent = '';
      return 0;
    }
    column.classList.remove('hidden');
    if (count) count.textContent = String(items.length);
    list.innerHTML = items.map(item => {
      const name = escapeHtml(item.name || '');
      const desc = escapeHtml(item.description || '');
      const href = hrefFor ? hrefFor(item) : null;
      const label = href
        ? `<a class="capability-name capability-link" href="${escapeHtml(href)}">${name}</a>`
        : `<span class="capability-name">${name}</span>`;
      return `<li class="capability-item">
        ${label}
        ${desc ? `<span class="capability-desc">${desc}</span>` : ''}
      </li>`;
    }).join('');
    return items.length;
  }

  function renderArmament(armament) {
    return renderCapabilityList(armament, 'armament-list', 'armament-count', 'col-armament');
  }

  function renderTechnologies(tech) {
    return renderCapabilityList(tech, 'tech-list', 'tech-count', 'col-tech');
  }

  // Chaque mission ouvre le hangar filtré sur elle (clé : nom FR canonique).
  function renderMissions(missions) {
    return renderCapabilityList(missions, 'missions-list', 'missions-count', 'col-missions',
      (m) => (m.name_fr ? `/hangar?mission=${encodeURIComponent(m.name_fr)}` : null));
  }

  function finalizeCapabilities() {
    const section = document.getElementById('capabilities-section');
    if (!section) return;
    const cols = ['col-armament', 'col-tech', 'col-missions']
      .map(id => document.getElementById(id))
      .filter(Boolean);
    const allHidden = cols.length > 0 && cols.every(c => c.classList.contains('hidden'));
    section.classList.toggle('hidden', allHidden);
  }

  function renderWars(wars) {
    const container = document.getElementById('wars-list');
    if (!wars || wars.length === 0) {
      container.innerHTML = `<p class="details-empty-hint">${i18n.t('details.no_war')}</p>`;
      return;
    }
    const html = wars.map(war => {
      const startYear = window.VH.calendarDate.year(war.date_start) || '?';
      // Sans date de fin mais avec un début : conflit en cours.
      const endYear = war.date_end
        ? window.VH.calendarDate.year(war.date_end)
        : (war.date_start ? i18n.t('details.war_ongoing') : '?');
      // Conflit d'une seule année : « 1999 », pas « 1999 – 1999 ».
      const period = startYear === endYear && startYear !== '?' ? String(startYear) : `${startYear} – ${endYear}`;
      // La carte entière mène à la page du conflit (lien étiré, voir details.css).
      const title = war.slug
        ? `<a class="war-link" href="/conflits/${encodeURIComponent(war.slug)}">${escapeHtml(war.name)}</a>`
        : escapeHtml(war.name);
      // Période en surtitre, puis le nom : les cartes se lisent comme une
      // chronologie sans trait ni pastille (grille, details.css).
      // Rôle de CET appareil dans le conflit (page de conflit) ; à défaut, la
      // description générale du conflit. Camp absent : plusieurs camps ou
      // non renseigné, on n'affiche rien.
      const side = war.side_name
        ? `<p class="war-side"><span class="war-side-label">${i18n.t('details.war_side')}</span> ${escapeHtml(war.side_name)}</p>`
        : '';
      const body = war.role
        ? `<div class="war-role">${warRoleHtml(war.role)}</div>`
        : `<p>${escapeHtml(war.description) || i18n.t('details.no_desc_available')}</p>`;
      return `
        <div class="war-card${war.slug ? ' war-card-linked' : ''}">
          <div class="war-period"><span>${period}</span></div>
          <h3>${title}</h3>
          ${side}
          ${body}
          ${war.slug ? `<span class="war-more" aria-hidden="true">${i18n.t('details.war_see_aircraft')} <i class="fas fa-arrow-right"></i></span>` : ''}
        </div>
      `;
    }).join('');
    if (typeof safeSetHTML === 'function') safeSetHTML(container, html);
    else container.innerHTML = html;
  }

  // Rôle en Markdown (italiques des opérations) ; le parseur échappe tout.
  function warRoleHtml(role) {
    const md = VH.details.markdown;
    return md && typeof md.parse === 'function' ? md.parse(role) : `<p>${escapeHtml(role)}</p>`;
  }

  VH.details.render = {
    renderAircraftDetails, renderArmament, renderTechnologies, renderMissions, finalizeCapabilities,
    renderWars, renderImageCredit, renderHeroImage, renderRelatedAircraft,
  };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.details.render;
  }
})();
