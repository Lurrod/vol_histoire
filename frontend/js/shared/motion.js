/* VH.motion — orchestration des sorties animées (v4.16.0).
 *
 * Avant ce module, chaque composant fermait à sa façon (modales, feuille
 * mobile, suggestions, menus, toasts) avec une durée recopiée en JS
 * (150, 300, 320 ms…) qui devait rester synchrone avec le CSS — et ne
 * l'était plus dès qu'on retouchait un token. Désormais :
 *
 *   VH.motion.exit(el, done)   pose .is-closing, attend la durée réelle
 *                              calculée par le navigateur (transitions et
 *                              animations, délais compris), retire la
 *                              classe, puis appelle done().
 *
 * La durée vient donc des tokens de tokens.css, jamais d'une constante.
 * Mouvements réduits : done() est appelé aussitôt, sans classe de sortie.
 * exit() renvoie une fonction d'annulation, pour une réouverture pendant
 * la sortie.
 *
 * Préférence du site « Réduire les animations » (réglages, 2026-11-20) :
 * clé vh-reduce-motion en stockage local, appliquée ici dès le chargement
 * d'app.min.js par la classe html.vh-reduce-motion (garde-fou CSS de
 * shared-utilities.css) ; prefersReducedMotion() la compte comme la
 * préférence du système. */
(function () {
  window.VH = window.VH || {};

  // Marge au-delà de la durée calculée : une image (≈16 ms) et un peu
  // de jeu, pour que la dernière image de l'animation soit peinte.
  var SETTLE_MS = 34;

  var REDUCE_KEY = 'vh-reduce-motion';
  var REDUCE_CLASS = 'vh-reduce-motion';

  function readReducePref() {
    try {
      return window.localStorage.getItem(REDUCE_KEY) === '1';
    } catch {
      return false; // stockage refusé : préférence du système seule
    }
  }

  /** Préférence du site (réglages), indépendante de celle du système. */
  function siteReducesMotion() {
    return document.documentElement.classList.contains(REDUCE_CLASS);
  }

  /** Active ou retire la préférence du site, mémorisée si possible.
   * @param {boolean} on */
  function setReducedMotion(on) {
    try {
      if (on) window.localStorage.setItem(REDUCE_KEY, '1');
      else window.localStorage.removeItem(REDUCE_KEY);
    } catch {
      // stockage refusé : la préférence vaut pour cette page seulement
    }
    document.documentElement.classList.toggle(REDUCE_CLASS, Boolean(on));
  }

  // Au plus tôt : app.min.js est le premier script de la page.
  if (readReducePref()) document.documentElement.classList.add(REDUCE_CLASS);

  /** @param {string|null|undefined} value « 160ms », « 0.24s »
   *  @returns {number} millisecondes (0 si illisible) */
  function parseTime(value) {
    if (value == null) return 0;
    var str = String(value).trim();
    var n = parseFloat(str);
    if (!Number.isFinite(n)) return 0;
    if (/ms$/.test(str)) return n;
    if (/s$/.test(str)) return n * 1000;
    return 0;
  }

  function splitTimes(list) {
    return String(list || '').split(',').map(parseTime);
  }

  // Durée + délai les plus longs d'une liste de propriétés CSS appariées
  // (le navigateur répète la liste la plus courte, d'où le modulo).
  function longest(durations, delays) {
    var max = 0;
    for (var i = 0; i < durations.length; i++) {
      var total = durations[i] + (delays[i % delays.length] || 0);
      if (total > max) max = total;
    }
    return max;
  }

  /** @param {Element} el @returns {number} ms avant la fin de la sortie */
  function exitDuration(el) {
    if (!el || typeof window.getComputedStyle !== 'function') return 0;
    var cs = window.getComputedStyle(el);
    var t = longest(splitTimes(cs.transitionDuration), splitTimes(cs.transitionDelay));
    var a = longest(splitTimes(cs.animationDuration), splitTimes(cs.animationDelay));
    return Math.max(t, a);
  }

  /** @returns {boolean} */
  function prefersReducedMotion() {
    if (siteReducesMotion()) return true;
    return systemPrefersReducedMotion();
  }

  /** @returns {boolean} préférence du système seule */
  function systemPrefersReducedMotion() {
    if (typeof window.matchMedia !== 'function') return false;
    try {
      return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    } catch {
      // Navigateur ou bac à sable qui lève : on anime, comme sans préférence.
      return false;
    }
  }

  /**
   * @param {Element|null} el
   * @param {() => void} done
   * @param {{ className?: string, measure?: Element|Element[] }} [opts]
   *   className : classe de sortie (défaut .is-closing), posée sur el ;
   *   measure   : élément(s) qui portent réellement l'animation, quand ce
   *               n'est pas el lui-même (ex. `.modal.is-closing .modal-content`).
   * @returns {() => void} annulation (la classe est retirée, done n'est pas appelé)
   */
  function exit(el, done, opts) {
    var className = (opts && opts.className) || 'is-closing';
    var measured = [el].concat((opts && opts.measure) || []).filter(Boolean);
    var callback = typeof done === 'function' ? done : function () {};
    if (!el || prefersReducedMotion()) {
      callback();
      return function () {};
    }

    el.classList.add(className);
    // La classe vient d'être posée : getComputedStyle renvoie déjà les
    // durées de l'état de sortie.
    var ms = Math.max.apply(null, measured.map(exitDuration));
    if (ms <= 0) {
      el.classList.remove(className);
      callback();
      return function () {};
    }

    var timer = setTimeout(function () {
      el.classList.remove(className);
      callback();
    }, ms + SETTLE_MS);

    return function cancel() {
      clearTimeout(timer);
      el.classList.remove(className);
    };
  }

  /** Rejoue une animation portée par une classe (pop, secousse…).
   * @param {Element|null} el @param {string} className */
  function replay(el, className) {
    if (!el) return;
    el.classList.remove(className);
    void el.offsetWidth; // reflow : sans lui, l'animation ne repart pas
    el.classList.add(className);
  }

  // Éléments déjà remplis une fois par swapText : seuls ceux-là s'animent.
  var swapped = new WeakSet();

  /** Remplace un texte sur place et rejoue .is-swapping (keyframe
   * vh-text-swap) — seulement s'il change, et jamais au premier
   * remplissage, même par-dessus un texte provisoire du HTML
   * (« 0 avions trouvés ») : un rendu qui réécrit le même compteur ne
   * doit pas clignoter.
   * @param {Element|null} el @param {string} text */
  function swapText(el, text) {
    if (!el) return;
    var first = !swapped.has(el);
    swapped.add(el);
    if (el.textContent === text) return;
    el.textContent = text;
    if (!first) replay(el, 'is-swapping');
  }

  window.VH.motion = {
    parseTime: parseTime,
    exitDuration: exitDuration,
    prefersReducedMotion: prefersReducedMotion,
    systemPrefersReducedMotion: systemPrefersReducedMotion,
    siteReducesMotion: siteReducesMotion,
    setReducedMotion: setReducedMotion,
    REDUCE_KEY: REDUCE_KEY,
    exit: exit,
    replay: replay,
    swapText: swapText
  };
})();
