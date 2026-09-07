/* ======================================================================
   COMPARATEUR — magasin d'ids + barre flottante + modale.
   Source de vérité unique, partagée par le hangar et la fiche.

   Le comparateur vivait dans js/hangar/compare.js, donc :
     - impossible d'ajouter un appareil depuis sa fiche ;
     - sélection stockée en localStorage seulement, donc impartageable.
   Ce module garde l'état (localStorage + paramètre d'URL `compare`) et
   construit l'UI ; hangar/compare.js n'a plus que les cases à cocher des
   cartes, details/compare.js n'a plus qu'un bouton.
   ====================================================================== */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  const STORAGE_KEY = 'vh_compare_ids';
  const URL_PARAM = 'compare';
  const MAX = 3;

  const listeners = [];
  let ids = [];
  // Le hangar est la seule page qui reflète la sélection dans son URL : c'est
  // là qu'un lien /hangar?compare=12,30,24 a un sens. Sur une fiche, l'URL
  // canonique doit rester celle de l'appareil.
  let urlSync = false;

  // ── Magasin ────────────────────────────────────────────────────────

  function sanitize(list) {
    const seen = new Set();
    const out = [];
    (Array.isArray(list) ? list : []).forEach((raw) => {
      const id = Number(raw);
      if (!Number.isInteger(id) || id <= 0 || seen.has(id)) return;
      seen.add(id);
      if (out.length < MAX) out.push(id);
    });
    return out;
  }

  function readStorage() {
    try { return sanitize(JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]')); }
    catch { return []; }
  }

  function writeStorage() {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(ids)); }
    catch { /* mode privé : la sélection ne survivra pas au rechargement */ }
  }

  function readUrl() {
    try {
      const raw = new URLSearchParams(location.search).get(URL_PARAM);
      return raw ? sanitize(raw.split(',')) : [];
    } catch { return []; }
  }

  /* N'écrit que le paramètre `compare` : les filtres du hangar écrivent les
   * leurs de leur côté, on ne doit pas les effacer au passage. */
  function writeUrl() {
    if (!urlSync) return;
    try {
      const params = new URLSearchParams(location.search);
      if (ids.length > 0) params.set(URL_PARAM, ids.join(','));
      else params.delete(URL_PARAM);
      // URLSearchParams encode la virgule en %2C : lisible par la machine, laid
      // dans une barre d'adresse qu'on destine au copier-coller.
      const qs = params.toString().replace(/%2C/g, ',');
      history.replaceState(null, '', qs ? `${location.pathname}?${qs}` : location.pathname);
    } catch { /* ignore */ }
  }

  function commit() {
    writeStorage();
    writeUrl();
    renderBar();
    listeners.forEach((fn) => { try { fn(getIds()); } catch { /* ignore */ } });
  }

  function getIds() { return ids.slice(); }
  function has(id) { return ids.includes(Number(id)); }
  function isFull() { return ids.length >= MAX; }

  /* Retourne 'added' | 'removed' | 'full' pour que l'appelant choisisse son
   * message — la formulation diffère entre une case à cocher et un bouton. */
  function toggle(id) {
    const n = Number(id);
    if (!Number.isInteger(n)) return 'full';
    if (has(n)) {
      ids = ids.filter((x) => x !== n);
      commit();
      return 'removed';
    }
    if (isFull()) return 'full';
    ids = ids.concat(n);
    commit();
    return 'added';
  }

  function remove(id) {
    const n = Number(id);
    if (!has(n)) return;
    ids = ids.filter((x) => x !== n);
    commit();
  }

  function clear() {
    ids = [];
    commit();
  }

  function onChange(fn) { if (typeof fn === 'function') listeners.push(fn); }

  // ── UI : barre flottante + modale ──────────────────────────────────

  /* i18n.t renvoie la clé elle-même quand la traduction manque ; on rattrape ce
   * cas pour afficher un libellé lisible plutôt que « hangar.compare_view ». */
  function t(key, fallback, vars) {
    if (!window.i18n || typeof i18n.t !== 'function') return fallback || key;
    const out = i18n.t(key, vars || {});
    return (out === key && fallback) ? fallback : out;
  }

  function ensureUi() {
    if (document.getElementById('compare-bar')) return;

    const bar = document.createElement('div');
    bar.id = 'compare-bar';
    bar.className = 'compare-bar hidden';
    bar.style.display = 'none';
    bar.innerHTML =
      '<span id="compare-count"></span>' +
      '<button type="button" id="compare-share" class="btn btn-secondary btn-sm">' + escapeHtml(t('hangar.compare_share', 'Copier le lien')) + '</button>' +
      '<button type="button" id="compare-clear" class="btn btn-secondary btn-sm">' + escapeHtml(t('hangar.compare_clear', 'Effacer')) + '</button>' +
      '<button type="button" id="compare-view" class="btn btn-primary btn-sm">' + escapeHtml(t('hangar.compare_view', 'Comparer')) + '</button>';
    document.body.appendChild(bar);

    const dlg = document.createElement('dialog');
    dlg.id = 'compare-modal';
    dlg.className = 'compare-modal';
    dlg.setAttribute('aria-labelledby', 'compare-modal-title');
    dlg.innerHTML =
      '<div class="compare-modal-header">' +
        '<h2 id="compare-modal-title"><i class="fas fa-crosshairs"></i><span>' + escapeHtml(t('hangar.compare_title', 'Comparaison')) + '</span></h2>' +
        '<button type="button" class="compare-modal-close" aria-label="' + escapeHtml(t('common.close', 'Fermer')) + '"><i class="fas fa-times"></i></button>' +
      '</div>' +
      '<div id="compare-modal-body"></div>';
    document.body.appendChild(dlg);

    document.getElementById('compare-clear').addEventListener('click', clear);
    document.getElementById('compare-view').addEventListener('click', open);
    document.getElementById('compare-share').addEventListener('click', shareLink);
    dlg.querySelectorAll('.compare-modal-close').forEach((btn) => {
      btn.addEventListener('click', () => dlg.close());
    });

    watchConsentBanner(bar);
  }

  /* Le bandeau de consentement occupe le bas de l'écran avec un z-index de
   * 9999 : tant qu'il n'a pas reçu de réponse, il recouvre entièrement la barre
   * du comparateur, qui devient inatteignable. On remonte la barre au-dessus de
   * lui plutôt que de disputer l'ordre d'empilement — le consentement doit
   * rester au premier plan. */
  function clearOfConsentBanner(bar) {
    const banner = document.querySelector('.cookie-banner.show');
    bar.style.bottom = banner
      ? (banner.getBoundingClientRect().height + 24) + 'px'
      : '';
  }

  function watchConsentBanner(bar) {
    const banner = document.querySelector('.cookie-banner');
    if (!banner || typeof MutationObserver === 'undefined') return;
    new MutationObserver(() => clearOfConsentBanner(bar))
      .observe(banner, { attributes: true, attributeFilter: ['class'] });
  }

  function renderBar() {
    const bar = document.getElementById('compare-bar');
    if (!bar) return;
    clearOfConsentBanner(bar);
    const n = ids.length;
    bar.classList.toggle('hidden', n === 0);
    bar.style.display = n === 0 ? 'none' : 'flex';
    const cnt = document.getElementById('compare-count');
    if (cnt) {
      const key = n > 1 ? 'hangar.compare_selected_many' : 'hangar.compare_selected_one';
      cnt.textContent = t(key, String(n) + ' ✓', { n });
    }
    if (n === 0) {
      const dlg = document.getElementById('compare-modal');
      if (dlg && dlg.open) dlg.close();
    }
  }

  /* Le lien pointe toujours vers le hangar : c'est la page qui sait ouvrir une
   * sélection reçue par URL. */
  function shareLink() {
    if (ids.length === 0) return;
    const url = `${location.origin}/hangar?${URL_PARAM}=${ids.join(',')}`;
    const done = () => { if (typeof showToast === 'function') showToast(t('hangar.compare_link_copied', 'Lien copié'), 'success'); };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(url).then(done).catch(() => {
        if (typeof showToast === 'function') showToast(url, 'info');
      });
    } else if (typeof showToast === 'function') {
      showToast(url, 'info');
    }
  }

  VH.shared.compare = {
    MAX,
    getIds, has, isFull, toggle, remove, clear, onChange,
    renderBar, ensureUi, shareLink,
    /* init({ urlSync, autoOpen }) — appelé une fois par page.
     * Les ids de l'URL priment sur ceux du stockage : un lien partagé doit
     * afficher la comparaison qu'il transporte, pas celle du visiteur. */
    init(options = {}) {
      urlSync = options.urlSync === true;
      const fromUrl = urlSync ? readUrl() : [];
      const hadUrlIds = fromUrl.length > 0;
      ids = hadUrlIds ? fromUrl : readStorage();
      ensureUi();
      commit();
      if (hadUrlIds && options.autoOpen !== false) open();
      return { fromUrl: hadUrlIds };
    },
    open,
  };

  // ── Modale : chargement des données et rendu ───────────────────────

  function fmt(v, suffix) {
    if (v == null || v === '') return '<span class="cmp-dash">—</span>';
    return escapeHtml(String(v)) + (suffix ? '<span class="cmp-unit"> ' + suffix + '</span>' : '');
  }

  function yearFrom(dateStr) {
    if (!dateStr) return null;
    const y = new Date(dateStr).getFullYear();
    return isNaN(y) ? null : y;
  }

  function extreme(items, key, highest) {
    let best = null;
    items.forEach((item) => {
      const v = Number(item[key]);
      if (isNaN(v)) return;
      if (best === null || (highest ? v > best : v < best)) best = v;
    });
    return best;
  }

  function bestClass(items, item, key, higherIsBetter) {
    const v = Number(item[key]);
    if (isNaN(v)) return '';
    const target = extreme(items, key, higherIsBetter);
    return (target !== null && v === target) ? ' cmp-best' : '';
  }

  // Les dimensions dynamiques passent par data-* puis par l'API DOM :
  // un attribut style="..." serait bloqué par la CSP.
  function barHtml(value, max, color) {
    if (value == null || isNaN(value) || max == null || max === 0) return '';
    const pct = Math.min(Math.round((value / max) * 100), 100);
    return '<div class="cmp-bar-track"><div class="cmp-bar-fill" data-pct="' + pct + '" data-bg="' + escapeHtml(color || 'var(--hud-cyan)') + '"></div></div>';
  }

  function applyCssVars(root) {
    root.querySelectorAll('.cmp-bar-fill[data-pct]').forEach((el) => {
      el.style.width = el.dataset.pct + '%';
      el.style.background = el.dataset.bg || 'var(--hud-cyan)';
    });
    root.querySelectorAll('[data-cmp-cols]').forEach((el) => {
      el.style.setProperty('--cmp-cols', el.dataset.cmpCols);
    });
  }

  async function fetchOne(id) {
    const res = await fetch(`/api/airplanes/${id}`);
    if (!res.ok) return null; // fiche supprimée depuis la mise en favori du lien
    const base = await res.json();
    const [armament, tech] = await Promise.all([
      fetch(`/api/airplanes/${id}/armament`).then((r) => r.json()).catch(() => []),
      fetch(`/api/airplanes/${id}/tech`).then((r) => r.json()).catch(() => []),
    ]);
    return Object.assign({}, base, { armament, tech });
  }

  async function open() {
    if (ids.length === 0) return;
    ensureUi();
    const dlg = document.getElementById('compare-modal');
    const body = document.getElementById('compare-modal-body');
    body.innerHTML = '<div class="cmp-loading"><i class="fas fa-circle-notch fa-spin"></i> ' + escapeHtml(t('common.loading', 'Chargement')) + '</div>';
    if (!dlg.open) dlg.showModal();

    try {
      const loaded = await Promise.all(ids.map(fetchOne));
      // Un id qui ne répond plus est purgé ici — c'est le seul endroit où l'on
      // sait vraiment qu'il n'existe pas (l'ancienne purge comparait à la page
      // courante du hangar et supprimait des ids parfaitement valides).
      const items = loaded.filter(Boolean);
      if (items.length !== ids.length) {
        ids = sanitize(items.map((a) => a.id));
        commit();
      }
      if (items.length === 0) { dlg.close(); return; }

      renderModal(body, items);
    } catch {
      body.innerHTML = '<div class="cmp-loading cmp-error"><i class="fas fa-triangle-exclamation"></i> ' + escapeHtml(t('common.loading_error', 'Erreur de chargement')) + '</div>';
    }
  }

  function renderModal(body, items) {
    const n = items.length;
    const maxSpeed = extreme(items, 'max_speed', true) || 1;
    const maxRange = extreme(items, 'max_range', true) || 1;
    const maxWeight = extreme(items, 'empty_weight', true) || 1;

    const headers = items.map((a) =>
      '<div class="cmp-col-head">' +
        '<button type="button" class="cmp-remove" data-remove="' + a.id + '" aria-label="' + escapeHtml(t('common.remove', 'Retirer')) + '"><i class="fas fa-times"></i></button>' +
        '<div class="cmp-img-wrap">' +
          (a.image_url
            ? VH.shared.picture.pictureHtml(a.image_url, { alt: a.name || '', loading: 'lazy', width: '300', height: '200' })
            : '<div class="cmp-img-placeholder"><i class="fas fa-plane"></i></div>') +
        '</div>' +
        '<div class="cmp-col-title">' +
          '<h3>' + escapeHtml(a.name || '—') + '</h3>' +
          (a.complete_name ? '<p>' + escapeHtml(a.complete_name) + '</p>' : '') +
        '</div>' +
        '<div class="cmp-col-meta">' +
          (a.country_name ? '<span class="cmp-chip"><i class="fas fa-globe"></i> ' + escapeHtml(a.country_name) + '</span>' : '') +
          (a.generation ? '<span class="cmp-chip cmp-chip-accent">Gen ' + escapeHtml(String(a.generation)) + '</span>' : '') +
          (a.type_name ? '<span class="cmp-chip"><i class="fas fa-tags"></i> ' + escapeHtml(a.type_name) + '</span>' : '') +
        '</div>' +
      '</div>'
    ).join('');

    function perfRow(label, key, unit, max, higherIsBetter) {
      const cells = items.map((a) => {
        const v = Number(a[key]);
        const cls = bestClass(items, a, key, higherIsBetter);
        const valStr = isNaN(v) ? '<span class="cmp-dash">—</span>' : fmt(a[key], unit);
        const barStr = isNaN(v) ? '' : barHtml(v, max, cls ? 'var(--hud-cyan)' : 'rgba(255,255,255,0.12)');
        return '<div class="cmp-cell cmp-cell-perf' + cls + '">' + valStr + barStr + '</div>';
      }).join('');
      return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
    }

    function textRow(label, fn) {
      const cells = items.map((a) => '<div class="cmp-cell">' + fn(a) + '</div>').join('');
      return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
    }

    function tagRow(label, key) {
      const cells = items.map((a) => {
        const list = a[key] || [];
        if (list.length === 0) return '<div class="cmp-cell"><span class="cmp-dash">—</span></div>';
        const tags = list.map((x) => '<span class="cmp-tag">' + escapeHtml(x.name || '') + '</span>').join('');
        return '<div class="cmp-cell cmp-cell-tags">' + tags + '</div>';
      }).join('');
      return '<div class="cmp-row cmp-row-tags" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
    }

    const group = (title, icon, rowsHtml) =>
      '<div class="cmp-group">' +
        '<div class="cmp-group-header"><i class="fas ' + icon + '"></i><span>' + title + '</span></div>' +
        rowsHtml +
      '</div>';

    body.innerHTML =
      '<div class="cmp-summary">' +
        '<span class="cmp-eyebrow"><i class="fas fa-crosshairs"></i> ' + escapeHtml(t('hangar.compare_eyebrow', 'Analyse comparée')) + '</span>' +
        '<span class="cmp-summary-count">' + n + ' ' + escapeHtml(n > 1 ? t('hangar.compare_aircraft_plural', 'appareils') : t('hangar.compare_aircraft_single', 'appareil')) + '</span>' +
      '</div>' +
      '<div class="cmp-cols" data-cmp-cols="' + n + '">' + headers + '</div>' +
      '<div class="cmp-body">' +
        group(t('hangar.compare_classification', 'Classification'), 'fa-tags',
          textRow(t('hangar.compare_manufacturer', 'Constructeur'), (a) => fmt(a.manufacturer_name)) +
          textRow(t('hangar.compare_type', 'Type'), (a) => fmt(a.type_name)) +
          textRow(t('hangar.compare_status', 'Statut'), (a) => fmt(a.status))
        ) +
        group(t('hangar.compare_timeline', 'Chronologie'), 'fa-calendar',
          textRow(t('hangar.compare_concept', 'Conception'), (a) => fmt(yearFrom(a.date_concept))) +
          textRow(t('hangar.compare_first_flight', 'Premier vol'), (a) => fmt(yearFrom(a.date_first_fly))) +
          textRow(t('hangar.compare_service', 'Mise en service'), (a) => fmt(yearFrom(a.date_operationel || a.date_operational)))
        ) +
        group(t('hangar.compare_performance', 'Performances'), 'fa-gauge-high',
          perfRow(t('hangar.compare_speed', 'Vitesse max'), 'max_speed', 'km/h', maxSpeed, true) +
          perfRow(t('hangar.compare_range', 'Portée max'), 'max_range', 'km', maxRange, true) +
          perfRow(t('hangar.compare_weight', 'Poids à vide'), 'empty_weight', 'kg', maxWeight, false)
        ) +
        group(t('hangar.compare_armament', 'Armement'), 'fa-burst',
          tagRow(t('hangar.compare_weapons', 'Systèmes'), 'armament')
        ) +
        group(t('hangar.compare_tech', 'Technologies'), 'fa-microchip',
          tagRow(t('hangar.compare_systems', 'Systèmes'), 'tech')
        ) +
      '</div>';

    const headerTitle = document.querySelector('#compare-modal-title span');
    if (headerTitle) headerTitle.textContent = t('hangar.compare_title', 'Comparaison') + ' — ' + n;

    applyCssVars(body);

    body.querySelectorAll('.cmp-remove').forEach((btn) => {
      btn.addEventListener('click', () => {
        remove(Number(btn.dataset.remove));
        if (ids.length > 0) open();
      });
    });
  }

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.compare;
  }
})();
