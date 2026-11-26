/* Dates clés d'un conflit — carrousel (2026-11-26).
 *
 * Comportement inspiré du composant « Timeline » de beUI : tête de lecture
 * fixe au centre, cartes opaques en profondeur, règle graduée entre les
 * cartes, câbles tendus vers les cartes proches et passés dessous, glissement
 * avec élan. Comportement reproduit, aucun code repris. Différence voulue :
 * en haut, câbles et tête de lecture partent de l'année de la carte centrée
 * (une seule, au centre, tenue par dates.js via onCenter) au lieu du bord de
 * la scène.
 *
 * Géométrie : `pos` est un indice flottant (0 = première date au centre). La
 * carte i se trouve à l'écart d = i - pos : échelle 1 au centre, 0,72 pour les
 * voisines, puis décroissante ; un voile l'assombrit. L'espacement intègre
 * l'échelle (trapèzes exacts, l'échelle étant affine entre deux entiers) : à
 * l'arrêt, l'espace visible entre deux cartes est constant.
 *
 * Écriture : uniquement des propriétés personnalisées (--tl-x, --tl-s,
 * --tl-veil, --tl-z, --tl-w) par le CSSOM ; la feuille en tire translate,
 * scale, voile et z-index.
 *
 * Mouvement : durée et courbe lues sur le CSS calculé de la piste
 * (transition-duration / transition-timing-function), jamais en dur. Avec
 * moins d'animations, la piste saute directement à la date.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.conflicts = root.VH.conflicts || {};

  const NEIGHBOUR_SCALE = 0.72;
  const SCALE_STEP = 0.11;       // l'échelle atteint son plancher à l'écart 3, un entier
  const MIN_SCALE = 0.5;
  const NEIGHBOUR_VEIL = 0.45;
  const VEIL_STEP = 0.15;
  const MAX_VEIL = 0.75;
  const DRAG_THRESHOLD = 4;      // px : en deçà, c'est un clic
  const EDGE_RESIST = 0.3;       // au-delà des extrémités, la piste suit à 30 %
  const MAX_COAST = 4;           // l'élan franchit au plus quatre dates
  const COAST_TIME = 0.25;       // s d'élan projetés au lâcher
  const VELOCITY_SMOOTHING = 0.6;
  const STALE_MOVE_MS = 80;      // immobile plus longtemps avant le lâcher : pas d'élan
  const WHEEL_SETTLE_MS = 140;
  const WHEEL_LINE_PX = 16;      // molette comptée en lignes (Firefox)
  const TICKS_PER_GAP = 5;
  const TICK_SPAN = 0.7;         // la règle occupe 70 % de l'espace entre deux cartes
  const TICK_HEIGHT = 0.2;       // graduation centrale : 20 % de la largeur d'une carte
  const CABLE_HOLD = 1;          // câbles pleins jusqu'aux voisines…
  const CABLE_FADE = 1.6;        // …effacés à l'écart 1,6
  const CABLE_SPREAD = 0.8;      // visée à 80 % de la demi-largeur, au centre vertical
  const CABLE_POOL = 4;
  const SVG_NS = 'http://www.w3.org/2000/svg';

  function scaleAt(d) {
    const a = Math.abs(d);
    if (a <= 1) return 1 - (1 - NEIGHBOUR_SCALE) * a;
    return Math.max(MIN_SCALE, NEIGHBOUR_SCALE - SCALE_STEP * (a - 1));
  }

  function veilAt(d) {
    const a = Math.abs(d);
    if (a <= 1) return NEIGHBOUR_VEIL * a;
    return Math.min(MAX_VEIL, NEIGHBOUR_VEIL + VEIL_STEP * (a - 1));
  }

  /** Distance (px) du centre de la scène au centre d'une carte d'écart d. */
  function offsetAt(d, width, gap) {
    const a = Math.abs(d);
    let x = 0;
    let t = 0;
    while (t < a) {
      const step = Math.min(1, a - t);
      x += (width * (scaleAt(t) + scaleAt(t + step)) / 2 + gap) * step;
      t += step;
    }
    return d < 0 ? -x : x;
  }

  /**
   * Position de chaque carte, graduations entre deux cartes voisines et
   * câbles, pour une position donnée. Fonction pure : testable sans mise en page.
   */
  function layout(pos, count, dims) {
    const { width, stageWidth, stageHeight, gap } = dims;
    const cy = Number.isFinite(dims.centerY) ? dims.centerY : stageHeight / 2;
    const top = Number.isFinite(dims.anchorY) ? dims.anchorY : 0;
    const cards = [];
    for (let i = 0; i < count; i++) {
      const d = i - pos;
      cards.push({ d, x: offsetAt(d, width, gap), scale: scaleAt(d), veil: veilAt(d) });
    }
    const ticks = [];
    for (let i = 0; i < count - 1; i++) {
      const right = cards[i].x + (width * cards[i].scale) / 2;
      const left = cards[i + 1].x - (width * cards[i + 1].scale) / 2;
      ticks.push({ x: (right + left) / 2, width: Math.max(0, left - right) * TICK_SPAN });
    }
    const cx = stageWidth / 2;
    // Câbles : de l'année (en haut) et du bas de la scène, au centre, vers le
    // centre vertical de la carte à 80 % de sa demi-largeur. Dessinés sous les
    // cartes opaques, ils semblent s'arrêter sur leur bord.
    const fmt = (n) => Math.round(n * 100) / 100;
    const cables = cards
      .filter((c) => Math.abs(c.d) < CABLE_FADE)
      .map((c) => {
        const reach = ((width * c.scale) / 2) * CABLE_SPREAD;
        const path = [cx + c.x - reach, cx + c.x + reach]
          .flatMap((tx) => [top, stageHeight].map((y0) => `M${fmt(cx)} ${fmt(y0)}L${fmt(tx)} ${fmt(cy)}`))
          .join('');
        return {
          opacity: Math.min(1, Math.max(0, (CABLE_FADE - Math.abs(c.d)) / (CABLE_FADE - CABLE_HOLD))),
          path,
        };
      });
    return { cards, ticks, cables, tickHeight: width * TICK_HEIGHT };
  }

  /** Courbe CSS « cubic-bezier(a, b, c, d) » → fonction y(x) (Newton, puis dichotomie). */
  function cubicBezier(x1, y1, x2, y2) {
    const cx = 3 * x1;
    const bx = 3 * (x2 - x1) - cx;
    const ax = 1 - cx - bx;
    const cy = 3 * y1;
    const by = 3 * (y2 - y1) - cy;
    const ay = 1 - cy - by;
    const sx = (t) => ((ax * t + bx) * t + cx) * t;
    const sy = (t) => ((ay * t + by) * t + cy) * t;
    const dx = (t) => (3 * ax * t + 2 * bx) * t + cx;
    return (x) => {
      if (x <= 0) return 0;
      if (x >= 1) return 1;
      let t = x;
      for (let i = 0; i < 8; i++) {
        const err = sx(t) - x;
        if (Math.abs(err) < 1e-6) return sy(t);
        const slope = dx(t);
        if (Math.abs(slope) < 1e-6) break;
        t -= err / slope;
      }
      let lo = 0;
      let hi = 1;
      t = x;
      for (let i = 0; i < 30; i++) {
        if (sx(t) < x) lo = t; else hi = t;
        t = (lo + hi) / 2;
      }
      return sy(t);
    };
  }

  // Mots-clés CSS et leur courbe, telle que la définit la spécification.
  const KEYWORD_EASINGS = {
    ease: 'cubic-bezier(0.25, 0.1, 0.25, 1)',
    'ease-in': 'cubic-bezier(0.42, 0, 1, 1)',
    'ease-out': 'cubic-bezier(0, 0, 0.58, 1)',
    'ease-in-out': 'cubic-bezier(0.42, 0, 0.58, 1)',
  };

  /** transition-timing-function calculée → fonction ; « linear » ou illisible : linéaire. */
  function parseEasing(value) {
    // Première courbe de la liste : virgules hors parenthèses seulement.
    const text = String(value || '').split(/,(?![^(]*\))/)[0].trim();
    const m = /cubic-bezier\(([^)]+)\)/.exec(KEYWORD_EASINGS[text] || text);
    const nums = m ? m[1].split(',').map(Number) : [];
    if (nums.length === 4 && nums.every(Number.isFinite)) return cubicBezier(nums[0], nums[1], nums[2], nums[3]);
    return (x) => Math.min(1, Math.max(0, x));
  }

  function parseTime(value) {
    const motion = root.VH.motion;
    const first = String(value || '').split(',')[0].trim();
    if (motion && motion.parseTime) return motion.parseTime(first);
    const n = parseFloat(first);
    if (!Number.isFinite(n)) return 0;
    return /ms$/.test(first) ? n : n * 1000;
  }

  function reducesMotion(win) {
    const motion = root.VH.motion;
    if (motion && motion.prefersReducedMotion) return motion.prefersReducedMotion();
    return Boolean(win.matchMedia && win.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  /** Graduations entre les cartes et réserve de câbles. */
  function buildDecor(doc, o) {
    const ticks = [];
    for (let i = 0; o.ruler && i < o.count - 1; i++) {
      const el = doc.createElement('span');
      el.className = 'conflict-tl-ticks';
      for (let k = 0; k < TICKS_PER_GAP; k++) el.appendChild(doc.createElement('i'));
      o.ruler.appendChild(el);
      ticks.push(el);
    }
    const cables = [];
    for (let i = 0; o.cables && i < CABLE_POOL; i++) {
      const path = doc.createElementNS(SVG_NS, 'path');
      o.cables.appendChild(path);
      cables.push(path);
    }
    return { ticks, cables };
  }

  function measure(o, win) {
    const first = o.track.firstElementChild;
    const gap = parseFloat(win.getComputedStyle(o.track).columnGap);
    return {
      width: first ? first.offsetWidth : 0,
      // Centre vertical des cartes (top de la feuille ; translate n'y compte pas).
      centerY: first && first.offsetTop ? first.offsetTop : o.stage.clientHeight / 2,
      // Point d'attache en haut : sous l'année (o.anchor), sinon le bord de la scène.
      anchorY: o.anchor ? o.anchor.offsetTop + o.anchor.offsetHeight : 0,
      stageWidth: o.stage.clientWidth,
      stageHeight: o.stage.clientHeight,
      gap: Number.isFinite(gap) ? gap : 0,
    };
  }

  function paintCards(cards, geo) {
    cards.forEach((card, i) => {
      const c = geo.cards[i];
      card.style.setProperty('--tl-x', c.x.toFixed(2));
      card.style.setProperty('--tl-s', c.scale.toFixed(4));
      card.style.setProperty('--tl-veil', c.veil.toFixed(3));
      card.style.setProperty('--tl-z', String(100 - Math.round(Math.abs(c.d) * 10)));
      card.classList.toggle('is-centered', Math.abs(c.d) < 0.5);
    });
  }

  function paintDecor(decor, geo, dims, o) {
    const svg = o.cables;
    if (o.ruler) o.ruler.style.setProperty('--tl-tick-h', geo.tickHeight.toFixed(2));
    o.stage.style.setProperty('--tl-anchor-y', (dims.anchorY || 0).toFixed(2));
    decor.ticks.forEach((el, i) => {
      el.style.setProperty('--tl-x', geo.ticks[i].x.toFixed(2));
      el.style.setProperty('--tl-w', geo.ticks[i].width.toFixed(2));
    });
    if (svg) svg.setAttribute('viewBox', `0 0 ${dims.stageWidth} ${dims.stageHeight}`);
    decor.cables.forEach((path, i) => {
      const cable = geo.cables[i];
      path.setAttribute('d', cable ? cable.path : '');
      path.style.setProperty('--tl-cable', cable ? cable.opacity.toFixed(3) : '0');
    });
  }

  /**
   * Branche le carrousel. o : { stage, track (cartes enfants directes),
   * ruler, cables (svg), anchor (attache du haut), count, start,
   * onSelect(i), onCenter(i) }.
   * onCenter : la carte la plus proche de la tête de lecture a changé
   * (y compris pendant un glissement).
   * Renvoie { goTo(i, { animate }), refresh(), destroy(), position }.
   */
  function create(o) {
    const doc = o.stage.ownerDocument;
    const win = doc.defaultView || root;
    const raf = win.requestAnimationFrame ? win.requestAnimationFrame.bind(win) : (fn) => setTimeout(() => fn(Date.now()), 16);
    const caf = win.cancelAnimationFrame ? win.cancelAnimationFrame.bind(win) : clearTimeout;
    const ctl = new AbortController();
    const on = (el, type, fn, opts) => el.addEventListener(type, fn, { ...opts, signal: ctl.signal });
    const decor = buildDecor(doc, o);
    const st = { pos: o.start || 0, raf: 0, drag: null, wheel: 0, eatClick: false, dims: null, center: null };
    const last = Math.max(0, o.count - 1);

    const cards = () => Array.from(o.track.children);
    const unit = () => offsetAt(1, st.dims.width, st.dims.gap) || 1;
    const clampIndex = (i) => Math.max(0, Math.min(last, i));
    const resist = (p) => {
      if (p < 0) return p * EDGE_RESIST;
      if (p > last) return last + (p - last) * EDGE_RESIST;
      return p;
    };

    function paint() {
      if (!st.dims) st.dims = measure(o, win);
      const geo = layout(st.pos, o.count, st.dims);
      paintCards(cards(), geo);
      paintDecor(decor, geo, st.dims, o);
      const center = clampIndex(Math.round(st.pos));
      if (center !== st.center) {
        st.center = center;
        if (o.onCenter) o.onCenter(center);
      }
    }

    function stop() {
      if (st.raf) caf(st.raf);
      st.raf = 0;
    }

    function goTo(index, { animate = true } = {}) {
      const to = clampIndex(index);
      stop();
      clearTimeout(st.wheel);
      const from = st.pos;
      const cs = win.getComputedStyle(o.track);
      const duration = parseTime(cs.transitionDuration);
      if (!animate || from === to || duration <= 0 || reducesMotion(win)) {
        st.pos = to;
        paint();
        return;
      }
      const ease = parseEasing(cs.transitionTimingFunction);
      let t0 = null;
      const step = (now) => {
        if (t0 === null) t0 = now;
        const k = Math.min(1, (now - t0) / duration);
        st.pos = from + (to - from) * ease(k);
        paint();
        st.raf = k < 1 ? raf(step) : 0;
      };
      st.raf = raf(step);
    }

    function release(ev, coast) {
      const g = st.drag;
      if (!g || ev.pointerId !== g.id) return;
      st.drag = null;
      if (!g.moved) return;
      o.stage.classList.remove('is-dragging');
      // Le clic qui suit le lâcher est avalé ; s'il ne vient pas, on désarme.
      st.eatClick = true;
      setTimeout(() => { st.eatClick = false; }, 0);
      const fresh = ev.timeStamp - g.lastT <= STALE_MOVE_MS;
      const near = clampIndex(Math.round(st.pos));
      const projected = Math.round(st.pos + (coast && fresh ? g.v * COAST_TIME : 0));
      o.onSelect(clampIndex(Math.max(near - MAX_COAST, Math.min(near + MAX_COAST, projected))));
    }

    on(o.stage, 'pointerdown', (ev) => {
      st.eatClick = false;
      if (ev.button !== 0 || o.count < 2) return;
      st.drag = { id: ev.pointerId, x0: ev.clientX, pos0: st.pos, lastX: ev.clientX, lastT: ev.timeStamp, v: 0, moved: false };
    });
    on(o.stage, 'pointermove', (ev) => {
      const g = st.drag;
      if (!g || ev.pointerId !== g.id) return;
      // Bouton relâché hors de la scène avant le seuil : aucun pointerup reçu.
      if (ev.pointerType === 'mouse' && ev.buttons === 0) {
        st.drag = null;
        return;
      }
      if (!g.moved) {
        if (Math.abs(ev.clientX - g.x0) < DRAG_THRESHOLD) return;
        g.moved = true;
        stop();
        // Une glissade en cours a pu avancer depuis l'appui : on part d'ici.
        g.pos0 = st.pos;
        g.x0 = ev.clientX;
        g.lastX = ev.clientX;
        if (o.stage.setPointerCapture) o.stage.setPointerCapture(ev.pointerId);
        o.stage.classList.add('is-dragging');
      }
      const dt = ev.timeStamp - g.lastT;
      if (dt > 0) {
        const instant = (-(ev.clientX - g.lastX) / unit() / dt) * 1000;
        g.v = g.v * VELOCITY_SMOOTHING + instant * (1 - VELOCITY_SMOOTHING);
      }
      g.lastX = ev.clientX;
      g.lastT = ev.timeStamp;
      st.pos = resist(g.pos0 - (ev.clientX - g.x0) / unit());
      paint();
    });
    on(o.stage, 'pointerup', (ev) => release(ev, true));
    on(o.stage, 'pointercancel', (ev) => release(ev, false));
    on(o.stage, 'dragstart', (ev) => ev.preventDefault());
    on(o.stage, 'click', (ev) => {
      // detail 0 : clic au clavier (Entrée, Espace), jamais issu d'un glissement.
      if (!st.eatClick || ev.detail === 0) return;
      st.eatClick = false;
      ev.preventDefault();
      ev.stopPropagation();
    }, { capture: true });
    on(o.stage, 'wheel', (ev) => {
      if (Math.abs(ev.deltaX) <= Math.abs(ev.deltaY) || o.count < 2) return;
      // Déjà au bout et poussée vers l'extérieur : le geste revient au navigateur.
      if ((st.pos <= 0 && ev.deltaX < 0) || (st.pos >= last && ev.deltaX > 0)) return;
      ev.preventDefault();
      stop();
      if (!st.dims) st.dims = measure(o, win);
      const perLine = ev.deltaMode === 1 ? WHEEL_LINE_PX : 1;
      const px = ev.deltaMode === 2 ? ev.deltaX * st.dims.stageWidth : ev.deltaX * perLine;
      st.pos = Math.max(-0.5, Math.min(last + 0.5, st.pos + px / unit()));
      paint();
      clearTimeout(st.wheel);
      st.wheel = setTimeout(() => o.onSelect(clampIndex(Math.round(st.pos))), WHEEL_SETTLE_MS);
    }, { passive: false });

    let observer = null;
    if (typeof win.ResizeObserver === 'function') {
      observer = new win.ResizeObserver(() => { st.dims = null; paint(); });
      observer.observe(o.stage);
      if (o.anchor) observer.observe(o.anchor);
      if (o.track.firstElementChild) observer.observe(o.track.firstElementChild);
    }

    paint();

    return {
      goTo,
      refresh() { st.dims = null; paint(); },
      destroy() {
        stop();
        clearTimeout(st.wheel);
        ctl.abort();
        o.stage.classList.remove('is-dragging');
        if (observer) observer.disconnect();
        [o.ruler, o.cables].forEach((el) => { if (el) el.replaceChildren(); });
      },
      get position() { return st.pos; },
    };
  }

  root.VH.conflicts.carousel = { scaleAt, veilAt, offsetAt, layout, cubicBezier, parseEasing, create };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = root.VH.conflicts.carousel;
  }
})();
