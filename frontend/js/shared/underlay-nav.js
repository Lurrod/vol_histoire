/* ======================================================================
   VOL D'HISTOIRE — MENU « UNDERLAY » (bureau, ≥ 64em)
   D'après l'underlay navigation de Motion Core : la page entière glisse à
   gauche de la largeur du panneau, se resserre et s'arrondit, et découvre
   dessous le panneau des liens.

   Trois contraintes dictent la mécanique :
   - Le panneau doit échapper à la transformation de la page : c'est un
     popover (top layer), que ni transform ni clip-path d'un ancêtre ne
     touchent. Il porte aussi le bouton « Fermer », copie du bouton « Menu »
     posée exactement par-dessus (le vrai bouton part avec la page).
   - Transformer <body> en fait le bloc conteneur de tous ses descendants
     `position: fixed` (en-tête, barres, toasts) : ils remonteraient en haut
     du document. Chacun est donc recalé (top + hauteur) à sa place à l'écran
     le temps de l'ouverture, puis rendu à son état d'origine.
   - Le défilement est bloqué (overflow sur <html>) sans changer la position :
     la page se resserre autour du centre de l'écran visible.

   Les styles sont dans shared-underlay.css ; la durée de fermeture est lue
   sur le CSS calculé (VH.motion), jamais recopiée ici.
   ====================================================================== */
(function () {
  'use strict';

  window.VH = window.VH || {};

  var DESKTOP = '(min-width: 64em)';
  var LOCK = 'ul-on';       // structure posée (page figée, panneau affiché)
  var OPEN = 'ul-open';     // état cible : page repoussée, liens visibles
  var GUTTER = 'ul-gutter'; // la page avait une barre de défilement
  var VARS = ['--ul-y', '--ul-b', '--ul-oy', '--ul-pw', '--ul-sx', '--ul-sy', '--ul-btn-top', '--ul-btn-left'];
  var PINNED = ['top', 'bottom', 'height'];

  var els = { panel: null, trigger: null, closeBtn: null };
  var isOpenState = false;
  var cancelClose = null;
  var pinned = [];
  var inerted = [];

  function matches(query) {
    return !!(window.matchMedia && window.matchMedia(query).matches);
  }

  /** Menu underlay utilisable : bureau et API Popover présente. */
  function enabled() {
    return !!(els.panel && typeof els.panel.showPopover === 'function' && matches(DESKTOP));
  }

  function isOpen() { return isOpenState; }

  // ── Éléments fixes : recalage pendant l'ouverture ──────────────────────

  /** L'élément fournit-il un bloc conteneur à ses descendants fixes ? */
  function containsFixed(cs) {
    return (cs.transform && cs.transform !== 'none') ||
      (cs.filter && cs.filter !== 'none') ||
      (cs.backdropFilter && cs.backdropFilter !== 'none') ||
      (cs.perspective && cs.perspective !== 'none') ||
      /paint|layout|strict|content/.test(cs.contain || '') ||
      /transform|filter|perspective/.test(cs.willChange || '');
  }

  /** Éléments fixes rendus, positionnés par rapport à l'écran (hors panneau). */
  function findFixed() {
    var out = [];
    var all = document.body.querySelectorAll('*');
    for (var i = 0; i < all.length; i++) {
      var el = all[i];
      if (els.panel && els.panel.contains(el)) continue;
      if (window.getComputedStyle(el).position !== 'fixed') continue;
      if (!el.getClientRects().length) continue;
      var anchoredToScreen = true;
      for (var p = el.parentElement; p && p !== document.body; p = p.parentElement) {
        if (containsFixed(window.getComputedStyle(p))) { anchoredToScreen = false; break; }
      }
      if (anchoredToScreen) out.push(el);
    }
    return out;
  }

  /** Fige chaque élément fixe à sa place à l'écran, en coordonnées de body
   *  (offset : défilement moins le haut de body dans le document). */
  function pinFixed(offset) {
    pinned = findFixed().map(function (el) {
      var saved = PINNED.map(function (prop) {
        return [prop, el.style.getPropertyValue(prop), el.style.getPropertyPriority(prop)];
      });
      // offsetTop d'un élément fixe : position à l'écran, hors transformation.
      var top = el.offsetTop;
      var height = el.offsetHeight;
      el.style.setProperty('top', (offset + top) + 'px', 'important');
      el.style.setProperty('bottom', 'auto', 'important');
      el.style.setProperty('height', height + 'px', 'important');
      return { el: el, saved: saved };
    });
  }

  function unpinFixed() {
    pinned.forEach(function (entry) {
      entry.saved.forEach(function (s) {
        if (s[1]) entry.el.style.setProperty(s[0], s[1], s[2]);
        else entry.el.style.removeProperty(s[0]);
      });
    });
    pinned = [];
  }

  // ── Inertie : seule la carte des liens reste atteignable ───────────────

  function setInert(on) {
    if (!on) {
      inerted.forEach(function (el) { el.inert = false; });
      inerted = [];
      return;
    }
    var keep = els.panel;
    var mark = function (el) {
      if (el === keep || el.contains(keep) || el.inert || el.tagName === 'SCRIPT') return;
      el.inert = true;
      inerted.push(el);
    };
    // Frères de chaque ancêtre du panneau, jusqu'à <body>.
    for (var node = keep; node && node !== document.body; node = node.parentElement) {
      var parent = node.parentElement;
      if (!parent) break;
      Array.prototype.forEach.call(parent.children, function (child) {
        if (child !== node) mark(child);
      });
    }
  }

  // ── Mesures ─────────────────────────────────────────────────────────────

  function setVars(values) {
    var style = document.documentElement.style;
    Object.keys(values).forEach(function (k) { style.setProperty(k, values[k]); });
  }

  function clearVars() {
    var style = document.documentElement.style;
    VARS.forEach(function (k) { style.removeProperty(k); });
  }

  /** Défilement exprimé dans le repère de body. Son haut n'est pas toujours
   *  celui du document : la marge haute du premier bloc peut fusionner avec
   *  la sienne (70 px sur le hangar). */
  function bodyOffset() {
    return -document.body.getBoundingClientRect().top;
  }

  function measure(y) {
    var de = document.documentElement;
    var w = de.clientWidth;
    var h = de.clientHeight;
    var bodyH = document.body.offsetHeight;
    var list = els.panel.querySelector('.nav-links');
    var pw = list ? list.getBoundingClientRect().width : 0;
    var btn = els.trigger.getBoundingClientRect();
    var gap = 2 * (parseFloat(window.getComputedStyle(de).getPropertyValue('--underlay-gap')) || 16);
    return {
      '--ul-y': y + 'px',
      '--ul-b': Math.max(0, bodyH - y - h) + 'px',
      '--ul-oy': (y + h / 2) + 'px',
      '--ul-pw': pw + 'px',
      '--ul-sx': String(w > gap ? (w - gap) / w : 1),
      '--ul-sy': String(h > gap ? (h - gap) / h : 1),
      '--ul-btn-top': btn.top + 'px',
      '--ul-btn-left': btn.left + 'px',
    };
  }

  function setExpanded(open) {
    [els.trigger, els.closeBtn].forEach(function (b) {
      if (b) b.setAttribute('aria-expanded', String(open));
    });
  }

  // ── Ouverture / fermeture ───────────────────────────────────────────────

  function open() {
    if (!enabled()) return false;
    var de = document.documentElement;
    if (cancelClose) {
      // Réouverture pendant la fermeture : la structure est encore en place.
      cancelClose();
      cancelClose = null;
    } else if (!isOpenState) {
      var y = bodyOffset();
      var hadScrollbar = window.innerWidth > de.clientWidth;
      els.panel.showPopover();
      var vars = measure(y);
      pinFixed(y);
      setVars(vars);
      de.classList.toggle(GUTTER, hadScrollbar);
      de.classList.add(LOCK);
      setInert(true);
      void document.body.offsetWidth; // départ des transitions depuis l'état figé
    }
    isOpenState = true;
    de.classList.add(OPEN);
    setExpanded(true);
    if (els.closeBtn) els.closeBtn.focus({ preventScroll: true });
    return true;
  }

  function finish() {
    var de = document.documentElement;
    cancelClose = null;
    var focusInside = els.panel && els.panel.contains(document.activeElement);
    de.classList.remove(OPEN, LOCK, GUTTER);
    setInert(false);
    unpinFixed();
    clearVars();
    if (els.panel && typeof els.panel.hidePopover === 'function') {
      try { els.panel.hidePopover(); } catch { /* déjà masqué */ }
    }
    if (focusInside && els.trigger) els.trigger.focus({ preventScroll: true });
  }

  /** @param {{ immediate?: boolean }} [opts] immediate : sans animation (redimensionnement, retour d'historique). */
  function close(opts) {
    if (!isOpenState) return;
    isOpenState = false;
    setExpanded(false);
    var de = document.documentElement;
    de.classList.remove(OPEN);
    if (opts && opts.immediate) {
      if (cancelClose) cancelClose();
      finish();
      return;
    }
    // Le body porte la transition la plus longue (délai de miroir compris).
    cancelClose = window.VH.motion.exit(de, finish, { className: 'ul-closing', measure: [document.body] });
  }

  function toggle() {
    if (isOpenState) close();
    else open();
  }

  /** @param {{ panel?: Element|null, trigger?: Element|null, closeBtn?: Element|null }} opts */
  function init(opts) {
    els.panel = opts.panel || null;
    els.trigger = opts.trigger || null;
    els.closeBtn = opts.closeBtn || null;
    // Sans déclencheur, rien à ouvrir : le menu reste inactif.
    if (!els.panel || !els.trigger) {
      els.panel = null;
      return;
    }

    els.closeBtn?.addEventListener('click', function () { close(); });
    // Clic dans la zone vide du popover (au-dessus de la page) : fermeture.
    els.panel.addEventListener('click', function (e) {
      if (e.target === els.panel) close();
    });

    var resizeTimer;
    window.addEventListener('resize', function () {
      if (!isOpenState) return;
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function () { close({ immediate: true }); }, 100);
    });
    // Page restaurée depuis le cache d'historique : jamais de menu ouvert.
    window.addEventListener('pageshow', function (e) {
      if (e.persisted) close({ immediate: true });
    });
  }

  var api = { init: init, open: open, close: close, toggle: toggle, isOpen: isOpen, enabled: enabled };
  window.VH.underlayNav = api;
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
})();
