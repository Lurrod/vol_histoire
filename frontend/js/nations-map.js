/* ======================================================================
   CARTE DES NATIONS DE CONCEPTION
   Planisphère cliquable, monté à deux endroits :

     - accueil, en mode `navigate` : le clic ouvre le hangar filtré ;
     - hangar, en mode `filter` (js/hangar/nations-map-filter.js) : le clic
       pose le filtre pays sur place, combinable avec génération et type.

   Le tracé vient de /assets/map/world-nations.svg (généré par
   scripts/build-map.js) et n'est chargé qu'à la demande : 76 Ko n'ont pas à
   peser sur le premier rendu. Le service worker le met ensuite en cache, donc
   le second montage est gratuit.
   ====================================================================== */
(function () {
  window.VH = window.VH || {};

  const SVG_URL = '/assets/map/world-nations.svg';
  // Le filtre `country` de /api/airplanes compare sur le nom FR canonique,
  // jamais sur le code ni sur la traduction.
  const HANGAR_URL = (nameFr) => `/hangar?country=${encodeURIComponent(nameFr)}`;
  const TIERS = 4;

  function tierOf(count, max) {
    if (!count || max <= 0) return 0;
    // Échelle racine : sans elle, les États-Unis et la Russie écrasent tout et
    // les trente autres nations se ressemblent toutes.
    const ratio = Math.sqrt(count) / Math.sqrt(max);
    return Math.min(TIERS, Math.max(1, Math.ceil(ratio * TIERS)));
  }

  function plural(n, key) {
    return i18n.t(n > 1 ? key + '_many' : key + '_one', { n });
  }

  /* Les données ne changent qu'aux ajouts de fiches : une seule requête et un
   * seul téléchargement du SVG, même si la carte est montée deux fois. */
  let dataPromise = null;

  function fetchMapData() {
    if (!dataPromise) {
      dataPromise = Promise.all([
        auth.fetchWithTimeout('/api/nations').then(r => {
          if (!r.ok) throw new Error('Erreur serveur');
          return r.json();
        }),
        fetch(SVG_URL).then(r => {
          if (!r.ok) throw new Error('Erreur serveur');
          return r.text();
        }),
      ]).catch(err => { dataPromise = null; throw err; }); // réessayable
    }
    return dataPromise;
  }

  /* mount(root, options)
   *   root       : conteneur portant .nations-map-canvas et .nations-map-tooltip
   *   onSelect   : (nation) => void ; défaut = navigation vers le hangar
   *   summary    : rend la ligne de synthèse si le conteneur en porte une
   * Retourne une promesse résolue une fois la carte en place (false si échec).
   */
  async function mount(root, options = {}) {
    if (!root || root.dataset.mapMounted === '1') return true;
    root.dataset.mapMounted = '1';

    const holder = root.querySelector('.nations-map-canvas');
    const status = root.querySelector('.nations-map-status');
    if (!holder) return false;

    let nations, svgText;
    try {
      [nations, svgText] = await fetchMapData();
    } catch {
      // La carte est un raccourci, pas un passage obligé : on la retire et les
      // autres chemins vers le filtre pays restent.
      root.dataset.mapMounted = '';
      root.classList.add('nations-map-failed');
      if (status) status.textContent = i18n.t('home.nations_map_error');
      return false;
    }

    const byCode = new Map(nations.map(n => [n.code, n]));
    const max = nations.reduce((m, n) => Math.max(m, Number(n.count) || 0), 0);

    holder.innerHTML = svgText;
    const svg = holder.querySelector('svg');
    if (!svg) return false;
    // Le SVG généré est marqué aria-hidden : une fois les nations rendues
    // navigables au clavier, il porte du contenu et ne doit plus l'être.
    svg.removeAttribute('aria-hidden');
    svg.setAttribute('aria-label', i18n.t('home.nations_map_aria'));

    svg.querySelectorAll('.wm-nation').forEach(path => {
      const data = byCode.get(path.dataset.code);
      if (!data) {
        // Pays du référentiel sans aucune fiche (présents comme lieu de
        // conflit) : ils redeviennent du décor.
        path.classList.add('wm-nation-empty');
        return;
      }
      const count = Number(data.count) || 0;
      path.classList.add('wm-nation-active', 'wm-tier-' + tierOf(count, max));
      path.setAttribute('tabindex', '0');
      path.setAttribute('role', options.onSelect ? 'button' : 'link');
      path.setAttribute('aria-label', `${data.name} — ${plural(count, 'home.nations_map_count')}`);
      path.dataset.name = data.name;
      path.dataset.nameFr = data.name_fr || data.name;
      path.dataset.count = String(count);
    });

    setupInteractions(root, svg, options.onSelect);
    renderSummary(root, nations, max);
    return true;
  }

  function setupInteractions(root, svg, onSelect) {
    const tooltip = root.querySelector('.nations-map-tooltip');
    const frame = root.querySelector('.nations-map-frame');

    /* Point d'ancrage calculé au build (centroïde de la plus grande masse
     * terrestre du pays). Le centre de la boîte englobante ne conviendrait pas :
     * celle de la France, Guyane comprise, tombe dans l'Atlantique. */
    function anchorPoint(path) {
      const cx = Number(path.dataset.cx);
      const cy = Number(path.dataset.cy);
      const ctm = svg.getScreenCTM();
      if (!ctm || !Number.isFinite(cx) || !Number.isFinite(cy)) {
        const box = path.getBoundingClientRect();
        return { x: box.left + box.width / 2, y: box.top };
      }
      const pt = svg.createSVGPoint();
      pt.x = cx;
      pt.y = cy;
      return pt.matrixTransform(ctm);
    }

    function place(x, y) {
      const host = frame.getBoundingClientRect();
      tooltip.style.left = (x - host.left) + 'px';
      tooltip.style.top = (y - host.top) + 'px';
    }

    function showTooltip(path, at) {
      if (!tooltip) return;
      tooltip.innerHTML =
        `<strong>${escapeHtml(path.dataset.name)}</strong>` +
        `<span>${escapeHtml(plural(Number(path.dataset.count), 'home.nations_map_count'))}</span>`;
      tooltip.classList.add('is-visible');
      const point = at || anchorPoint(path);
      place(point.x, point.y);
    }

    function hideTooltip() {
      if (tooltip) tooltip.classList.remove('is-visible');
    }

    function activate(path) {
      const nation = {
        code: path.dataset.code,
        name: path.dataset.name,
        nameFr: path.dataset.nameFr,
        count: Number(path.dataset.count),
      };
      if (onSelect) onSelect(nation);
      else window.location.href = HANGAR_URL(nation.nameFr);
    }

    // À la souris, l'infobulle suit le curseur : plus juste pour un pays
    // étendu, et sans surprise pour l'utilisateur.
    svg.addEventListener('pointermove', e => {
      const path = e.target.closest('.wm-nation-active');
      if (path) showTooltip(path, { x: e.clientX, y: e.clientY - 6 });
      else hideTooltip();
    });
    svg.addEventListener('pointerover', e => {
      const path = e.target.closest('.wm-nation-active');
      if (path) showTooltip(path, { x: e.clientX, y: e.clientY - 6 });
    });
    svg.addEventListener('pointerout', hideTooltip);
    svg.addEventListener('click', e => {
      const path = e.target.closest('.wm-nation-active');
      if (path) activate(path);
    });
    svg.addEventListener('focusin', e => {
      const path = e.target.closest('.wm-nation-active');
      if (path) showTooltip(path);
    });
    svg.addEventListener('focusout', hideTooltip);
    svg.addEventListener('keydown', e => {
      if (e.key !== 'Enter' && e.key !== ' ') return;
      const path = e.target.closest('.wm-nation-active');
      if (!path) return;
      e.preventDefault();
      activate(path);
    });
  }

  /* Ligne de synthèse sous la carte : le chiffre global et les trois premières
   * nations, lisibles sans survoler quoi que ce soit. Absente du panneau du
   * hangar, où la liste déroulante donne déjà tous les comptages. */
  function renderSummary(root, nations, max) {
    const legend = root.querySelector('.nations-map-legend-max');
    if (legend) legend.textContent = String(max);

    const chip = (n, extra) =>
      `<a class="nm-chip${extra || ''}" href="${escapeHtml(HANGAR_URL(n.name_fr || n.name))}">` +
        `${escapeHtml(n.name)}<span class="nm-chip-count">${escapeHtml(String(n.count))}</span>` +
      '</a>';

    const el = root.querySelector('.nations-map-summary');
    if (!el) return;
    el.innerHTML =
      `<span class="nm-total">${escapeHtml(plural(nations.length, 'home.nations_map_total'))}</span>` +
      nations.slice(0, 3).map(n => chip(n)).join('');
  }

  /* Accueil : montage différé à l'approche de la section. */
  function init() {
    const section = document.getElementById('nations-map-section');
    if (!section) return;

    if (!('IntersectionObserver' in window)) { mount(section); return; }
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        observer.disconnect();
        mount(section);
      });
    }, { rootMargin: '300px' });
    observer.observe(section);
  }

  VH.nationsMap = { init, mount, tierOf };

  document.addEventListener('DOMContentLoaded', init);

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.nationsMap;
  }
})();
