/* ======================================================================
   VOL D'HISTOIRE — VISITE GUIDÉE (première connexion, page d'accueil)
   Un projecteur se pose tour à tour sur les vrais éléments de l'accueil
   (recherche, liens du menu…) ; une bulle l'accompagne et explique. Le
   projecteur est une découpe dans un voile sombre : il glisse et se
   redimensionne d'une cible à l'autre (top/left/width/height en
   transition), la bulle se place dessous ou dessus selon la place.
   Parcours différent sous 64em : les liens sont dans le menu burger.
   ====================================================================== */
(function () {
  'use strict';

  var STORAGE_KEY = 'vh-onboarding-done';
  var GAP = 14;        // espace entre la cible et la bulle
  var PAD = 8;         // marge du projecteur autour de la cible
  var EDGE = 16;       // marge minimale avec les bords de l'écran
  var MOBILE = '(max-width: 63.99em)';

  function shouldShow() {
    try { if (localStorage.getItem(STORAGE_KEY)) return false; } catch { return false; }
    if (window.location.pathname !== '/') return false;
    if (typeof auth === 'undefined' || !auth.getToken || !auth.getToken()) return false;
    return true;
  }

  /** Traduction avec repli : i18n.t renvoie la clé quand elle manque. */
  function t(key, fallback, vars) {
    var out = fallback;
    if (typeof i18n !== 'undefined' && i18n.t) {
      var v = i18n.t(key, vars);
      if (v && v !== key) out = v;
    }
    if (vars) Object.keys(vars).forEach(function (k) { out = out.split('{' + k + '}').join(vars[k]); });
    return out;
  }

  function isMobile() {
    return !!(window.matchMedia && window.matchMedia(MOBILE).matches);
  }

  function reducedMotion() {
    return !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  /** Nombre d'appareils affiché par l'accueil, sinon null. Le compteur est un
   *  odomètre (VH.rollingNumber) : son texte brut contient toutes les bandes de
   *  chiffres ; la valeur lisible est dans son .sr-only. */
  function catalogueCount() {
    var el = document.getElementById('hero-split-stat-airplanes');
    var src = el ? (el.querySelector('.sr-only') || el) : null;
    var n = src ? parseInt(String(src.textContent).replace(/\D/g, ''), 10) : NaN;
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  /** Étapes du parcours ; une étape sans cible présente est retirée. */
  function buildSteps(userName) {
    var count = catalogueCount();
    var welcome = {
      id: 'welcome',
      target: null,
      title: userName
        ? t('onboarding.welcome_title_name', 'Bienvenue à bord, {name}.', { name: userName })
        : t('onboarding.welcome_title', 'Bienvenue à bord.'),
      text: t('onboarding.welcome_text', 'Une visite de trente secondes pour prendre vos repères. Vous pouvez la passer à tout moment.'),
    };
    var search = {
      id: 'search',
      target: '#hero-search',
      title: t('onboarding.search_title', 'Cherchez un appareil'),
      text: t('onboarding.search_text', 'Un nom, un pays, un constructeur : les suggestions arrivent dès les premières lettres.'),
    };
    var steps = isMobile()
      ? [welcome, search, {
        id: 'menu',
        target: '.hamburger',
        title: t('onboarding.menu_title', 'Le menu'),
        text: t('onboarding.menu_text', 'Le Hangar, la Chronologie, les Conflits et votre espace personnel : tout part d\'ici.'),
      }, {
        id: 'lang',
        target: '#lang-toggle',
        title: t('onboarding.lang_title', 'Français ou anglais'),
        text: t('onboarding.lang_text', 'Tout le site, fiches comprises, existe dans les deux langues.'),
      }]
      : [welcome, search, {
        id: 'hangar',
        target: '.nav-links a[href="/hangar"]',
        title: t('onboarding.hangar_title', 'Le Hangar'),
        text: count
          ? t('onboarding.hangar_text_count', '{count} appareils, de 1945 à aujourd\'hui, à filtrer par pays, génération, type, conflit ou mission.', { count: count.toLocaleString(document.documentElement.lang || 'fr') })
          : t('onboarding.hangar_text', 'Tout le catalogue, de 1945 à aujourd\'hui, à filtrer par pays, génération, type, conflit ou mission.'),
      }, {
        id: 'timeline',
        target: '.nav-links a[href="/timeline"]',
        title: t('onboarding.timeline_title', 'La Chronologie'),
        text: t('onboarding.timeline_text', 'Huit décennies d\'aviation militaire sur une même frise, avec les conflits et les appareils qui ont compté.'),
      }, {
        id: 'favorites',
        target: '.nav-links a[href="/favorites"]',
        title: t('onboarding.favorites_title', 'Vos favoris'),
        text: t('onboarding.favorites_text', 'Le cœur d\'une fiche range l\'appareil dans votre collection. Elle vous attend ici.'),
      }];
    return steps.filter(function (s) { return !s.target || document.querySelector(s.target); });
  }

  // Signe Livre-delta (frontend/assets/logo) : deux pages qui s'ouvrent.
  var SIGN = '<svg class="ob-sign" viewBox="0 0 128 128" aria-hidden="true" focusable="false">' +
    '<path class="ob-sign-page ob-sign-left" d="M61.5 16 L6 100 Q36 91 61.5 104 Z"/>' +
    '<path class="ob-sign-page ob-sign-right" d="M66.5 16 L122 100 Q92 91 66.5 104 Z"/></svg>';

  function createTour() {
    var userName = '';
    try {
      var payload = auth.getPayload();
      if (payload && payload.name) userName = String(payload.name).split(/\s+/)[0];
    } catch { /* jeton illisible : bienvenue sans prénom */ }

    var steps = buildSteps(userName);
    var current = 0;
    var trap = null;
    var raf = 0;
    var previousFocus = document.activeElement;

    // ── DOM ─────────────────────────────────────────────────────────────
    var root = document.createElement('div');
    root.className = 'ob';
    root.setAttribute('role', 'dialog');
    root.setAttribute('aria-modal', 'true');
    root.setAttribute('aria-labelledby', 'ob-title');
    root.setAttribute('aria-describedby', 'ob-text');
    root.innerHTML =
      '<div class="ob-spot" aria-hidden="true"></div>' +
      '<div class="ob-card">' +
        '<div class="ob-head">' + SIGN +
          '<p class="ob-count" aria-live="polite"></p>' +
          '<button type="button" class="ob-btn ob-skip"></button>' +
        '</div>' +
        '<div class="ob-body">' +
          '<h2 class="ob-title" id="ob-title"></h2>' +
          '<p class="ob-text" id="ob-text"></p>' +
        '</div>' +
        '<div class="ob-foot">' +
          '<ol class="ob-dots" aria-hidden="true"></ol>' +
          '<div class="ob-actions">' +
            '<button type="button" class="ob-btn ob-prev"></button>' +
            '<button type="button" class="ob-btn ob-primary ob-next"></button>' +
          '</div>' +
        '</div>' +
      '</div>';

    var spot = root.querySelector('.ob-spot');
    var card = root.querySelector('.ob-card');
    var body = root.querySelector('.ob-body');
    var countEl = root.querySelector('.ob-count');
    var titleEl = root.querySelector('.ob-title');
    var textEl = root.querySelector('.ob-text');
    var dots = root.querySelector('.ob-dots');
    var skipBtn = root.querySelector('.ob-skip');
    var prevBtn = root.querySelector('.ob-prev');
    var nextBtn = root.querySelector('.ob-next');

    dots.innerHTML = steps.map(function () { return '<li class="ob-dot"></li>'; }).join('');
    skipBtn.textContent = t('onboarding.skip', 'Passer');
    prevBtn.textContent = t('onboarding.prev', 'Précédent');

    // ── Placement ───────────────────────────────────────────────────────
    function targetOf(step) {
      return step && step.target ? document.querySelector(step.target) : null;
    }

    /** Pose le projecteur sur la cible (ou le réduit au centre) et la bulle
     *  dessous, dessus ou au centre. Positions en px, posées en CSSOM. */
    function place() {
      raf = 0;
      var el = targetOf(steps[current]);
      var vw = window.innerWidth;
      var vh = window.innerHeight;
      var cw = card.offsetWidth;
      var ch = card.offsetHeight;
      if (!el) {
        root.classList.add('ob-centered');
        setBox(spot, vw / 2, vh / 2, 0, 0);
        setPos(card, Math.max(EDGE, (vw - cw) / 2), Math.max(EDGE, (vh - ch) / 2));
        return;
      }
      root.classList.remove('ob-centered');
      var r = el.getBoundingClientRect();
      var radius = parseFloat(window.getComputedStyle(el).borderRadius) || 0;
      spot.style.setProperty('--ob-radius', (radius + PAD / 2) + 'px');
      setBox(spot, r.left - PAD, r.top - PAD, r.width + PAD * 2, r.height + PAD * 2);
      var below = r.bottom + PAD + GAP;
      var top = below + ch <= vh - EDGE ? below : Math.max(EDGE, r.top - PAD - GAP - ch);
      var left = Math.min(Math.max(EDGE, r.left + r.width / 2 - cw / 2), vw - cw - EDGE);
      setPos(card, left, top);
    }

    function setBox(elt, x, y, w, h) {
      elt.style.setProperty('--ob-x', x + 'px');
      elt.style.setProperty('--ob-y', y + 'px');
      elt.style.setProperty('--ob-w', w + 'px');
      elt.style.setProperty('--ob-h', h + 'px');
    }

    function setPos(elt, x, y) {
      elt.style.setProperty('--ob-x', Math.round(x) + 'px');
      elt.style.setProperty('--ob-y', Math.round(y) + 'px');
    }

    function schedulePlace() {
      if (!raf) raf = requestAnimationFrame(place);
    }

    /** Cible hors de l'écran : on la ramène au centre avant de placer. */
    function reveal(el) {
      if (!el) return;
      var r = el.getBoundingClientRect();
      if (r.top >= 0 && r.bottom <= window.innerHeight) return;
      el.scrollIntoView({ block: 'center', behavior: reducedMotion() ? 'auto' : 'smooth' });
    }

    // ── Rendu d'une étape ───────────────────────────────────────────────
    function render(animate) {
      var step = steps[current];
      var last = current === steps.length - 1;
      countEl.textContent = t('onboarding.count', 'Étape {n} sur {total}', { n: current + 1, total: steps.length });
      titleEl.textContent = step.title;
      textEl.textContent = step.text;
      prevBtn.hidden = current === 0;
      skipBtn.hidden = last;
      nextBtn.textContent = current === 0
        ? t('onboarding.start', 'Commencer la visite')
        : last ? t('onboarding.finish', 'C\'est parti') : t('onboarding.next', 'Suivant');
      Array.prototype.forEach.call(dots.children, function (d, i) {
        d.classList.toggle('is-active', i === current);
        d.classList.toggle('is-done', i < current);
      });
      if (animate) {
        body.classList.remove('is-swapping');
        void body.offsetWidth; // l'animation repart de zéro
        body.classList.add('is-swapping');
      }
      reveal(targetOf(step));
      schedulePlace();
    }

    function go(delta) {
      var target = current + delta;
      if (target < 0) return;
      if (target >= steps.length) { close(); return; }
      current = target;
      render(true);
      focusNext();
    }

    /** Focus sur le bouton principal, sans anneau imposé : le navigateur ne
     *  l'affiche que pour une navigation au clavier (option focusVisible). */
    function focusNext() {
      try { nextBtn.focus({ focusVisible: false }); } catch { nextBtn.focus(); }
    }

    // ── Ouverture et fermeture ──────────────────────────────────────────
    function onKey(e) {
      if (e.key === 'ArrowRight') { e.preventDefault(); go(1); }
      if (e.key === 'ArrowLeft') { e.preventDefault(); go(-1); }
    }

    function close() {
      try { localStorage.setItem(STORAGE_KEY, '1'); } catch { /* stockage refusé : la visite reviendra */ }
      document.removeEventListener('keydown', onKey);
      window.removeEventListener('resize', schedulePlace);
      window.removeEventListener('scroll', schedulePlace, true);
      if (trap) { trap.destroy(); trap = null; }
      if (raf) cancelAnimationFrame(raf);
      root.classList.remove('ob-active');
      if (previousFocus && typeof previousFocus.focus === 'function' && document.contains(previousFocus)) {
        previousFocus.focus();
      }
      var done = function () { root.remove(); };
      if (window.VH && window.VH.motion) window.VH.motion.exit(root, done, { className: 'ob-exit' });
      else done();
    }

    skipBtn.addEventListener('click', close);
    prevBtn.addEventListener('click', function () { go(-1); });
    nextBtn.addEventListener('click', function () { go(1); });
    document.addEventListener('keydown', onKey);
    window.addEventListener('resize', schedulePlace);
    window.addEventListener('scroll', schedulePlace, true);

    document.body.appendChild(root);
    render(false);
    place();
    if (typeof trapFocus === 'function') trap = trapFocus(root, { onEscape: close });
    requestAnimationFrame(function () {
      root.classList.add('ob-active');
      focusNext();
    });

    return { root: root, close: close, go: go, steps: steps };
  }

  // Lancée une fois la page posée (session, traductions, compteurs).
  document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
      if (shouldShow()) createTour();
    }, 1500);
  });

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = { createTour: createTour, shouldShow: shouldShow, buildSteps: buildSteps };
  }
})();
