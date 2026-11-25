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
  // Photo de chaque appareil retenu (vignettes de la barre) : sans elle, une
  // sélection relue au chargement n'aurait que des icônes d'attente.
  const THUMBS_KEY = 'vh_compare_thumbs';
  const URL_PARAM = 'compare';
  const MAX = 3;

  const listeners = [];
  let ids = [];
  let thumbs = {}; // id → chemin local de la photo (persisté)
  let live = {};   // id → URL déjà chargée par la page (carte, hero), le temps de la session
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
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(ids));
      localStorage.setItem(THUMBS_KEY, JSON.stringify(thumbs));
    } catch { /* mode privé : la sélection ne survivra pas au rechargement */ }
  }

  // ── Vignettes de la barre ──────────────────────────────────────────

  /* Chemin local d'une photo (« /assets/… »), sans paramètres ; l'image
   * d'attente (placeholder-airplane-*.svg) n'en est pas une. */
  function safePath(src) {
    if (typeof src !== 'string' || !/^\/[^/\\]/.test(src) || /placeholder-airplane/.test(src)) return null;
    return src.split(/[?#]/)[0];
  }

  /* URL réellement affichée par la page (AVIF/WebP déjà en cache), de même
   * origine seulement. */
  function liveUrl(img) {
    const src = img.currentSrc || img.src || '';
    if (!src || /placeholder-airplane/.test(src)) return null;
    try { return new URL(src, location.href).origin === location.origin ? src : null; }
    catch { return null; }
  }

  function readThumbs() {
    try {
      const raw = JSON.parse(localStorage.getItem(THUMBS_KEY) || '{}');
      const out = {};
      Object.keys(raw || {}).forEach((k) => {
        const path = safePath(raw[k]);
        if (path && Number.isInteger(Number(k))) out[Number(k)] = path;
      });
      return out;
    } catch { return {}; }
  }

  /** Photo de l'appareil `id` dans la page : sa carte, ou le hero de sa fiche. */
  function pageImg(id) {
    const img = document.querySelector('[data-morph-id="' + id + '"] [data-morph="photo"] img');
    if (img) return img;
    const vm = window.VH.viewMorph;
    const self = vm && typeof vm.selfId === 'function' && vm.selfId() === String(id);
    return self ? document.querySelector('[data-morph-self] [data-morph="photo"] img') : null;
  }

  function rememberFromPage(id) {
    const img = pageImg(id);
    if (!img) return;
    const path = safePath(img.getAttribute('src'));
    if (!path) return;
    thumbs[id] = path;
    const url = liveUrl(img);
    if (url) live[id] = url;
  }

  function pruneThumbs() {
    const keep = (map) => ids.reduce((acc, id) => {
      if (map[id]) acc[id] = map[id];
      return acc;
    }, {});
    thumbs = keep(thumbs);
    live = keep(live);
  }

  function thumbInner(id) {
    if (live[id]) return '<img src="' + escapeHtml(live[id]) + '" alt="" width="48" height="36">';
    const pic = window.VH.shared.picture;
    const html = pic && (pic.thumbHtml || pic.pictureHtml);
    if (thumbs[id] && html) return html(thumbs[id], { alt: '', width: '48', height: '36' });
    return '<i class="fas fa-plane" aria-hidden="true"></i>';
  }

  /* Une vignette par appareil, dans l'ordre de la sélection. Les vignettes
   * gardées ne sont ni recréées ni réinsérées (l'image ne se recharge pas,
   * le morphing retrouve le même élément). */
  function renderThumbs(bar) {
    const box = bar.querySelector('.cmp-thumbs');
    if (!box) return;
    const kept = {};
    Array.from(box.children).forEach((el) => {
      const id = Number(el.getAttribute('data-cmp-thumb'));
      if (ids.includes(id)) kept[id] = el; else el.remove();
    });
    ids.forEach((id, i) => {
      if (!thumbs[id]) rememberFromPage(id);
      let el = kept[id];
      if (!el) {
        el = document.createElement('span');
        el.className = 'cmp-thumb';
        el.setAttribute('data-cmp-thumb', String(id));
      }
      const key = live[id] || thumbs[id] || '';
      if (el.getAttribute('data-src') !== key || !el.firstChild) {
        el.setAttribute('data-src', key);
        el.innerHTML = thumbInner(id);
      }
      if (box.children[i] !== el) box.insertBefore(el, box.children[i] || null);
    });
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

  function morphApi() { return window.VH.shared.compareMorph || null; }

  /* `morph` ({ id, dir }) : la barre se redessine par un morphing carte ↔
   * barre (compare-morph.js) ; sans lui, d'un coup. */
  function commit(morph) {
    pruneThumbs();
    writeStorage();
    writeUrl();
    const cm = morphApi();
    const bar = document.getElementById('compare-bar');
    if (morph && cm && bar) {
      cm.bar({ bar, id: morph.id, dir: morph.dir, update: renderBar, preload: live[morph.id] || null });
    } else {
      renderBar();
    }
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
      commit({ id: n, dir: 'remove' });
      return 'removed';
    }
    if (isFull()) return 'full';
    ids = ids.concat(n);
    rememberFromPage(n);
    commit({ id: n, dir: 'add' });
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
    // Le texte de repli reçoit les mêmes variables {nom} que la traduction.
    const fill = (str) => String(str).replace(/\{(\w+)\}/g, (m, k) => (vars && k in vars ? vars[k] : m));
    if (!window.i18n || typeof i18n.t !== 'function') return fallback ? fill(fallback) : key;
    const out = i18n.t(key, vars || {});
    return (out === key && fallback) ? fill(fallback) : out;
  }

  /* Maillon de chaîne + coche : deux groupes que compare.css fait permuter à la
   * copie du lien (le maillon se replie, la coche se trace). */
  const LINK_SVG =
    '<svg class="cmp-share-ico" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
    '<g class="cmp-link"><path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1"/>' +
    '<path d="M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1"/></g>' +
    '<path class="cmp-check" d="M5.5 12.5l4.2 4.2 8.8-9"/></svg>';

  function ensureUi() {
    if (document.getElementById('compare-bar')) return;

    const bar = document.createElement('div');
    bar.id = 'compare-bar';
    // `.hidden` suffit (display: none) : plus de style en ligne.
    bar.className = 'compare-bar hidden';
    // Vignettes décoratives (le compteur dit déjà combien) : cibles du
    // morphing carte → barre.
    bar.innerHTML =
      '<span class="cmp-thumbs" aria-hidden="true"></span>' +
      '<span id="compare-count"></span>' +
      '<button type="button" id="compare-share" class="btn btn-secondary btn-sm">' + LINK_SVG +
        '<span class="cmp-share-label">' + escapeHtml(t('hangar.compare_share', 'Copier le lien')) + '</span></button>' +
      '<button type="button" id="compare-clear" class="btn btn-secondary btn-sm"><span class="cmp-clear-label">' +
        escapeHtml(t('hangar.compare_clear', 'Effacer')) + '</span></button>' +
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
      '<div id="compare-modal-body" class="compare-modal-body"></div>';
    document.body.appendChild(dlg);

    armClear(document.getElementById('compare-clear'));
    document.getElementById('compare-view').addEventListener('click', open);
    document.getElementById('compare-share').addEventListener('click', shareLink);
    dlg.querySelectorAll('.compare-modal-close').forEach((btn) => {
      btn.addEventListener('click', closeModal);
    });
    // Échap : le <dialog> fermerait d'un coup ; on passe par la sortie animée.
    dlg.addEventListener('cancel', (e) => {
      e.preventDefault();
      closeModal();
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

  /* La barre entre en glissant (vh-enter) ; elle sortait d'un coup.
   * .is-leaving joue la sortie, puis .hidden la retire du rendu. */
  let cancelBarLeave = null;

  function showBar(bar) {
    if (cancelBarLeave) { cancelBarLeave(); cancelBarLeave = null; }
    bar.classList.remove('is-leaving', 'hidden');
  }

  function hideBar(bar) {
    if (bar.classList.contains('hidden') || bar.classList.contains('is-leaving')) return;
    let finished = false;
    const cancel = VH.motion.exit(bar, () => {
      finished = true;
      cancelBarLeave = null;
      bar.classList.add('hidden');
    }, { className: 'is-leaving' });
    if (!finished) cancelBarLeave = cancel;
  }

  /* La modale se fermait d'un coup (dialog.close()). .is-closing joue le
   * fondu de la boîte et du voile (compare.css), puis on la ferme. */
  let cancelModalClose = null;
  // Morphing barre ↔ modale en cours (jusqu'à la mise à jour du DOM).
  let panelPending = null;

  function barShown(bar) {
    return !!bar && !bar.classList.contains('hidden') && !bar.classList.contains('is-leaving');
  }

  /* Ouvre la modale ; avec l'API View Transitions, la barre s'y agrandit. */
  function showPanel(dlg) {
    const cm = morphApi();
    const bar = document.getElementById('compare-bar');
    const morph = !!(cm && cm.canMorph() && barShown(bar));
    // L'entrée CSS de la modale (modalSlideIn) se tait sous le morphing.
    dlg.classList.toggle('is-morph', morph);
    if (!morph) { dlg.showModal(); return; }
    const done = () => { panelPending = null; };
    panelPending = cm.panel({ from: bar, to: dlg, update: () => dlg.showModal() }).then(done, done);
  }

  function closeModal() {
    const dlg = document.getElementById('compare-modal');
    if (!dlg || !dlg.open || cancelModalClose || panelPending) return;
    // La modale se replie dans la barre si celle-ci reste affichée (sinon,
    // sélection vidée : simple fondu de sortie).
    const cm = morphApi();
    const bar = document.getElementById('compare-bar');
    if (cm && cm.canMorph() && barShown(bar)) {
      const done = () => { panelPending = null; };
      panelPending = cm.panel({ from: dlg, to: bar, update: () => dlg.close() }).then(done, done);
      return;
    }
    let finished = false;
    const cancel = VH.motion.exit(dlg, () => {
      finished = true;
      cancelModalClose = null;
      dlg.close();
    }, { className: 'is-closing' });
    if (!finished) cancelModalClose = cancel;
  }

  /* « Effacer » vide jusqu'à trois appareils d'un clic : même confirmation
   * que la suppression d'un utilisateur (Paramètres) — le couvercle de la
   * poubelle se soulève et « ✓ Effacer · ✗ Garder » sort à droite du bouton ;
   * à la confirmation, la coche se trace puis la sélection est vidée. Une
   * fois vidée, la confirmation revient au repos : la barre est réutilisée à
   * la prochaine sélection. */
  let clearControl = null;

  function armClear(btn) {
    if (!btn) return;
    btn.prepend(VH.confirmAction.binIcon());
    const control = VH.confirmAction.arm(btn, {
      showText: true,
      side: 'right',
      className: 'cmp-clear',
      measure: '.cfm-bin-check',
      // Évalués à l'ouverture : la langue peut ne pas être chargée à l'armement.
      labels: {
        group: () => t('hangar.compare_clear_group', 'Effacer la sélection ?'),
        confirm: () => t('hangar.compare_clear_confirm', 'Effacer'),
        cancel: () => t('hangar.compare_clear_keep', 'Garder'),
      },
      onConfirm: () => {
        clear();
        control.reset();
      },
    });
    if (control) clearControl = control;
  }

  /* Compteur « N sélectionnés » : seul le nombre défile (odomètre), le libellé
   * autour reste du texte ordinaire. Le nombre est repéré dans le texte
   * traduit ; sans lui (traduction de repli), tout le texte passe par
   * l'odomètre. */
  function paintCount(cnt, n, text) {
    if (!cnt.firstElementChild) {
      cnt.innerHTML = '<span class="cmp-count-pre"></span><span class="cmp-count-num"></span>' +
        '<span class="cmp-count-post"></span>';
    }
    const at = text.indexOf(String(n));
    const [pre, mid, post] = at < 0
      ? ['', text, '']
      : [text.slice(0, at), String(n), text.slice(at + String(n).length)];
    cnt.querySelector('.cmp-count-pre').textContent = pre;
    cnt.querySelector('.cmp-count-post').textContent = post;
    VH.rollingNumber.setText(cnt.querySelector('.cmp-count-num'), mid);
  }

  function renderBar() {
    const bar = document.getElementById('compare-bar');
    if (!bar) return;
    clearOfConsentBanner(bar);
    const n = ids.length;
    if (n === 0) hideBar(bar); else showBar(bar);
    renderThumbs(bar);
    const cnt = document.getElementById('compare-count');
    if (cnt) {
      const key = n > 1 ? 'hangar.compare_selected_many' : 'hangar.compare_selected_one';
      paintCount(cnt, n, t(key, String(n) + ' ✓', { n }));
    }
    if (n === 0) {
      closeModal();
      // Sélection vidée ailleurs (case décochée, colonne retirée) pendant que
      // « Effacer ? » était ouvert : le panneau ne doit pas réapparaître
      // ouvert avec la prochaine sélection.
      if (clearControl) clearControl.reset();
    }
  }

  /* Confirmation sur le bouton lui-même, en plus du toast : le maillon se
   * replie et la coche se trace (compare.css, .is-copied), le libellé devient
   * « Lien copié » un instant, puis tout revient au repos. */
  const COPIED_MS = 1800;
  let copiedTimer = null;

  // Fondu du libellé (vh-text-swap) : rejoué dès le premier changement.
  function setShareLabel(label, text) {
    label.textContent = text;
    VH.motion.replay(label, 'is-swapping');
  }

  function flashCopied() {
    const btn = document.getElementById('compare-share');
    if (!btn) return;
    const label = btn.querySelector('.cmp-share-label');
    clearTimeout(copiedTimer);
    btn.classList.add('is-copied');
    setShareLabel(label, t('hangar.compare_link_copied', 'Lien copié'));
    copiedTimer = setTimeout(() => {
      copiedTimer = null;
      btn.classList.remove('is-copied');
      setShareLabel(label, t('hangar.compare_share', 'Copier le lien'));
    }, COPIED_MS);
  }

  /* Le lien pointe toujours vers le hangar : c'est la page qui sait ouvrir une
   * sélection reçue par URL. */
  function shareLink() {
    if (ids.length === 0) return;
    const url = `${location.origin}/hangar?${URL_PARAM}=${ids.join(',')}`;
    const done = () => {
      flashCopied();
      if (typeof showToast === 'function') showToast(t('hangar.compare_link_copied', 'Lien copié'), 'success');
    };
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
    renderBar, ensureUi, shareLink, renderModal,
    /* init({ urlSync, autoOpen }) — appelé une fois par page.
     * Les ids de l'URL priment sur ceux du stockage : un lien partagé doit
     * afficher la comparaison qu'il transporte, pas celle du visiteur. */
    init(options = {}) {
      urlSync = options.urlSync === true;
      const fromUrl = urlSync ? readUrl() : [];
      const hadUrlIds = fromUrl.length > 0;
      ids = hadUrlIds ? fromUrl : readStorage();
      thumbs = readThumbs();
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

  // Valeur numérique d'une colonne, ou NaN si elle est absente : Number(null)
  // et Number('') valent 0, et une donnée inconnue serait alors comptée comme
  // la meilleure (poids à vide le plus bas) ou dessinée en barre à 0 %.
  function numeric(raw) {
    if (raw == null || (typeof raw === 'string' && raw.trim() === '')) return NaN;
    return Number(raw);
  }

  function extreme(items, key, highest) {
    let best = null;
    items.forEach((item) => {
      const v = numeric(item[key]);
      if (isNaN(v)) return;
      if (best === null || (highest ? v > best : v < best)) best = v;
    });
    return best;
  }

  function bestClass(items, item, key, higherIsBetter) {
    const v = numeric(item[key]);
    if (isNaN(v)) return '';
    const target = extreme(items, key, higherIsBetter);
    return (target !== null && v === target) ? ' cmp-best' : '';
  }

  // Les dimensions dynamiques passent par data-* puis par l'API DOM :
  // un attribut style="..." serait bloqué par la CSP.
  function barHtml(value, max, color) {
    if (value == null || isNaN(value) || max == null || max === 0) return '';
    const pct = Math.min(Math.round((value / max) * 100), 100);
    return '<div class="cmp-bar-track"><div class="cmp-bar-fill" data-pct="' + pct + '" data-bg="' + escapeHtml(color || 'var(--gold)') + '"></div></div>';
  }

  function applyCssVars(root) {
    root.querySelectorAll('.cmp-bar-fill[data-pct]').forEach((el) => {
      el.style.width = el.dataset.pct + '%';
      el.style.background = el.dataset.bg || 'var(--gold)';
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
    if (panelPending) return; // la barre s'agrandit déjà en modale
    body.innerHTML = '<div class="cmp-loading"><i class="fas fa-circle-notch fa-spin"></i> ' + escapeHtml(t('common.loading', 'Chargement')) + '</div>';
    // Réouverture pendant la sortie : on l'interrompt, la modale reste ouverte.
    if (cancelModalClose) { cancelModalClose(); cancelModalClose = null; }
    if (!dlg.open) showPanel(dlg);

    try {
      const loaded = await Promise.all(ids.map(fetchOne));
      // Modale encore en train de s'ouvrir : la refermer maintenant serait sans effet.
      if (panelPending) await panelPending;
      // Un id qui ne répond plus est purgé ici — c'est le seul endroit où l'on
      // sait vraiment qu'il n'existe pas (l'ancienne purge comparait à la page
      // courante du hangar et supprimait des ids parfaitement valides).
      const items = loaded.filter(Boolean);
      rememberLoaded(items);
      if (items.length !== ids.length) {
        ids = sanitize(items.map((a) => a.id));
        commit();
      }
      if (items.length === 0) { closeModal(); return; }

      renderModal(body, items);
    } catch {
      body.innerHTML = '<div class="cmp-loading cmp-error"><i class="fas fa-triangle-exclamation"></i> ' + escapeHtml(t('common.loading_error', 'Erreur de chargement')) + '</div>';
    }
  }

  /* Les fiches chargées donnent la photo de chaque appareil : la barre
   * remplace ses icônes d'attente (sélection relue d'un lien ou du stockage). */
  function rememberLoaded(items) {
    let changed = false;
    items.forEach((a) => {
      const path = safePath(a.image_url);
      if (path && ids.includes(a.id) && thumbs[a.id] !== path) {
        thumbs[a.id] = path;
        changed = true;
      }
    });
    if (!changed) return;
    writeStorage();
    const bar = document.getElementById('compare-bar');
    if (bar) renderThumbs(bar);
  }

  function renderModal(body, items) {
    const n = items.length;
    const maxSpeed = extreme(items, 'max_speed', true) || 1;
    const maxRange = extreme(items, 'max_range', true) || 1;
    const maxWeight = extreme(items, 'empty_weight', true) || 1;

    const headers = items.map((a) =>
      '<div class="cmp-col-head" data-cmp-id="' + a.id + '">' +
        '<button type="button" class="cmp-remove" data-remove="' + a.id + '" aria-label="' + escapeHtml(t('hangar.compare_remove_named', 'Retirer {name} du comparateur', { name: a.name || '' })) + '"><i class="fas fa-times"></i></button>' +
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

    /* Lecteurs d'écran (A11Y-003) : les colonnes sont des div sans sémantique
     * de tableau ; chaque valeur est donc précédée du nom de son appareil, et
     * la meilleure valeur, signalée à l'œil par la couleur et l'étoile, est
     * aussi annoncée en texte. Invisible à l'écran (.sr-only). */
    const who = (a) => '<span class="sr-only">' + escapeHtml(a.name || '') + ' : </span>';
    const bestText = '<span class="sr-only"> (' + escapeHtml(t('hangar.compare_best', 'meilleure valeur')) + ')</span>';

    function perfRow(label, key, unit, max, higherIsBetter) {
      const cells = items.map((a) => {
        const v = numeric(a[key]);
        const cls = bestClass(items, a, key, higherIsBetter);
        const valStr = isNaN(v) ? '<span class="cmp-dash">—</span>' : fmt(a[key], unit);
        const barStr = isNaN(v) ? '' : barHtml(v, max, cls ? 'var(--gold)' : 'rgba(255,255,255,0.12)');
        return '<div class="cmp-cell cmp-cell-perf' + cls + '" data-cmp-id="' + a.id + '">' + who(a) + valStr + (cls ? bestText : '') + barStr + '</div>';
      }).join('');
      return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
    }

    function textRow(label, fn) {
      const cells = items.map((a) => '<div class="cmp-cell" data-cmp-id="' + a.id + '">' + who(a) + fn(a) + '</div>').join('');
      return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
    }

    function tagRow(label, key) {
      const cells = items.map((a) => {
        const list = a[key] || [];
        if (list.length === 0) return '<div class="cmp-cell" data-cmp-id="' + a.id + '">' + who(a) + '<span class="cmp-dash">—</span></div>';
        const tags = list.map((x) => '<span class="cmp-tag">' + escapeHtml(x.name || '') + '</span>').join('');
        return '<div class="cmp-cell cmp-cell-tags" data-cmp-id="' + a.id + '">' + who(a) + tags + '</div>';
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
      btn.addEventListener('click', () => removeColumn(body, items, Number(btn.dataset.remove)));
    });
  }

  /* Retirer une colonne ne recharge rien : les fiches restantes sont déjà en
   * mémoire. Avant, open() remettait le spinner et refaisait 3 × 3 requêtes.
   * La colonne s'efface (en-tête + cellules, .is-removing), puis la grille se
   * recompose sur n − 1 à partir des données chargées. */
  function removeColumn(body, items, id) {
    if (body.dataset.removing === 'true') return; // un retrait à la fois
    body.dataset.removing = 'true';
    body.querySelectorAll('.cmp-remove').forEach((b) => { b.disabled = true; });
    const parts = Array.from(body.querySelectorAll('[data-cmp-id="' + id + '"]'));
    const cm = morphApi();
    const morph = !!(cm && cm.canMorph());

    const finish = () => {
      delete body.dataset.removing;
      remove(id);
      // Une sélection vidée ailleurs pendant l'animation (barre « Effacer »)
      // a déjà refermé la modale : on ne garde que ce qui est encore retenu.
      const rest = items.filter((a) => a.id !== id && ids.includes(a.id));
      if (rest.length === 0) return;
      renderModal(body, rest);
      if (morph) return; // les colonnes glissent déjà (morphing)
      body.classList.remove('cmp-enter');
      void body.offsetWidth; // relance le fondu de recomposition
      body.classList.add('cmp-enter');
    };
    // Morphing : la colonne retirée s'efface, les autres glissent à leur
    // nouvelle place (compare-morph.js).
    if (morph) {
      cm.columns({ body, update: finish });
      return;
    }
    // Le premier élément porte la minuterie (durée mesurée) ; les autres
    // reçoivent la même classe et s'effacent en même temps.
    parts.slice(1).forEach((el) => el.classList.add('is-removing'));
    VH.motion.exit(parts[0], finish, { className: 'is-removing' });
  }

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.compare;
  }
})();
