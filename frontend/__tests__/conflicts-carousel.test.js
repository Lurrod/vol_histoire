/**
 * Tests — frontend/js/conflicts/date-carousel.js : géométrie du carrousel des
 * dates clés (fonctions pures) et contrôleur (glissement, élan, molette,
 * animation lue sur le CSS calculé, moins d'animations, nettoyage).
 *
 * jsdom n'a pas de mise en page : largeurs, hauteurs et styles calculés sont
 * posés à la main ; requestAnimationFrame est une file rejouée par le test.
 */

const C = require('../js/conflicts/date-carousel.js');

const DIMS = { width: 300, height: 200, stageWidth: 1000, stageHeight: 400, gap: 40 };

describe('géométrie', () => {
  test('échelle : 1 au centre, 0,72 aux voisines, plancher 0,5 dès l\'écart 3', () => {
    expect(C.scaleAt(0)).toBe(1);
    expect(C.scaleAt(1)).toBeCloseTo(0.72);
    expect(C.scaleAt(-1)).toBeCloseTo(0.72);
    expect(C.scaleAt(0.5)).toBeCloseTo(0.86);
    expect(C.scaleAt(2)).toBeCloseTo(0.61);
    expect(C.scaleAt(3)).toBeCloseTo(0.5);
    expect(C.scaleAt(8)).toBe(0.5);
  });

  test('voile : nul au centre, 0,45 aux voisines, plafonné à 0,75', () => {
    expect(C.veilAt(0)).toBe(0);
    expect(C.veilAt(-1)).toBeCloseTo(0.45);
    expect(C.veilAt(2)).toBeCloseTo(0.6);
    expect(C.veilAt(9)).toBe(0.75);
  });

  test('décalage : demi-largeurs à l\'échelle + espace, symétrique, continu', () => {
    // centre → voisine : 300 × (1 + 0,72) / 2 + 40
    expect(C.offsetAt(1, 300, 40)).toBeCloseTo(298);
    expect(C.offsetAt(-1, 300, 40)).toBeCloseTo(-298);
    expect(C.offsetAt(0, 300, 40)).toBe(0);
    // écart constant à l'arrêt entre les cartes 1 et 2 : bords séparés de 40 px
    const x1 = C.offsetAt(1, 300, 40);
    const x2 = C.offsetAt(2, 300, 40);
    expect((x2 - (300 * C.scaleAt(2)) / 2) - (x1 + (300 * C.scaleAt(1)) / 2)).toBeCloseTo(40);
    expect(C.offsetAt(0.5, 300, 40)).toBeGreaterThan(0);
    expect(C.offsetAt(0.5, 300, 40)).toBeLessThan(C.offsetAt(1, 300, 40));
  });

  test('layout : cartes, règle sur 70 % de l\'espace, graduation à 20 % de la largeur', () => {
    const geo = C.layout(0, 4, DIMS);
    expect(geo.cards).toHaveLength(4);
    expect(geo.cards[0]).toMatchObject({ d: 0, x: 0, scale: 1, veil: 0 });
    expect(geo.ticks).toHaveLength(3);
    expect(geo.ticks[0].width).toBeCloseTo(28);
    expect(geo.ticks[0].x).toBeCloseTo(150 + 20);
    expect(geo.tickHeight).toBe(60);
  });

  test('câbles : de l\'attache haute et du bas de la scène vers le centre des cartes, à 80 % de la demi-largeur', () => {
    const geo = C.layout(0, 4, DIMS);
    // carte centrée et voisine pleines ; écart 2 : au-delà de 1,6, aucun câble
    expect(geo.cables).toHaveLength(2);
    expect(geo.cables[0].opacity).toBe(1);
    expect(geo.cables[1].opacity).toBe(1);
    // carte centrée 300 px de large, centre (500, 200) : visées x = 380 et 620
    expect(geo.cables[0].path).toBe('M500 0L380 200M500 400L380 200M500 0L620 200M500 400L620 200');
    // à mi-chemin entre deux dates, les deux cartes s'estompent ensemble
    const mid = C.layout(0.5, 4, DIMS);
    expect(mid.cables.map((c) => c.opacity)).toEqual([1, 1, expect.closeTo(0.1667, 3)]);
    // attache sous l'année et centre vertical lus sur la mise en page
    const anchored = C.layout(0, 1, { ...DIMS, centerY: 250, anchorY: 92 });
    expect(anchored.cables[0].path).toBe('M500 92L380 250M500 400L380 250M500 92L620 250M500 400L620 250');
  });

  test('courbes : cubic-bezier lue, extrémités exactes, repli linéaire', () => {
    const ease = C.parseEasing('cubic-bezier(0.22, 1, 0.36, 1)');
    expect(ease(0)).toBe(0);
    expect(ease(1)).toBe(1);
    expect(ease(0.5)).toBeGreaterThan(0.85); // sortie : très avancée à mi-course
    const linear = C.parseEasing('cubic-bezier(0, 0, 1, 1)');
    expect(linear(0.3)).toBeCloseTo(0.3, 4);
    // pente nulle au départ : Newton s'arrête, la dichotomie conclut
    const flat = C.cubicBezier(0.5, 0, 0.5, 1);
    expect(flat(0.25)).toBeGreaterThan(0);
    expect(flat(0.25)).toBeLessThan(0.25);
    // pente nulle au point de départ de Newton : la dichotomie prend le relais
    const steep = C.cubicBezier(1, 0, 1, 1);
    expect(steep(0.9999)).toBeGreaterThan(0.9);
    expect(steep(0.9999)).toBeLessThanOrEqual(1);
    // mots-clés CSS : leur courbe de la spécification ; liste : la première
    expect(C.parseEasing('ease-out')(0.5)).toBeGreaterThan(0.5);
    expect(C.parseEasing('ease-in')(0.5)).toBeLessThan(0.5);
    expect(C.parseEasing('cubic-bezier(0.22, 1, 0.36, 1), linear')(0.5)).toBeGreaterThan(0.85);
    const fallback = C.parseEasing('linear');
    expect(fallback(0.4)).toBe(0.4);
    expect(fallback(2)).toBe(1);
    expect(C.parseEasing(null)(-1)).toBe(0);
  });
});

describe('contrôleur', () => {
  let frames;
  let stage;
  let track;
  let selected;
  let centers;
  let style;

  function flushFrames(times) {
    for (const t of times) {
      const queue = frames;
      frames = [];
      queue.forEach((fn) => fn(t));
    }
  }

  function setup({ count = 5, start = 0 } = {}) {
    document.body.innerHTML = `
      <div id="stage"><div id="anchor"></div><div id="ruler"></div>
        <svg id="cables"></svg><div id="track"></div></div>`;
    stage = document.getElementById('stage');
    track = document.getElementById('track');
    for (let i = 0; i < count; i++) {
      const card = document.createElement('button');
      card.dataset.index = String(i);
      Object.defineProperties(card, {
        offsetWidth: { value: 300 }, offsetHeight: { value: 200 }, offsetTop: { value: 0 },
      });
      track.appendChild(card);
    }
    Object.defineProperties(stage, { clientWidth: { value: 1000 }, clientHeight: { value: 400 } });
    selected = [];
    centers = [];
    const anchor = document.getElementById('anchor');
    Object.defineProperties(anchor, { offsetTop: { value: 4 }, offsetHeight: { value: 88 } });
    const ctl = C.create({
      stage,
      track,
      anchor,
      ruler: document.getElementById('ruler'),
      cables: document.getElementById('cables'),
      count,
      start,
      onSelect: (i) => { selected.push(i); ctl.goTo(i); },
      onCenter: (i) => centers.push(i),
    });
    return ctl;
  }

  function pointer(type, x, t, id = 1, extra = {}) {
    const ev = new window.Event(type, { bubbles: true, cancelable: true });
    Object.defineProperties(ev, {
      clientX: { value: x }, pointerId: { value: id }, button: { value: 0 }, timeStamp: { value: t },
      pointerType: { value: extra.pointerType || 'touch' }, buttons: { value: extra.buttons ?? 1 },
    });
    stage.dispatchEvent(ev);
    return ev;
  }

  const xOf = (i) => Number(track.children[i].style.getPropertyValue('--tl-x'));

  beforeEach(() => {
    frames = [];
    style = { transitionDuration: '0.52s', transitionTimingFunction: 'cubic-bezier(0.22, 1, 0.36, 1)', columnGap: '40px' };
    window.requestAnimationFrame = (fn) => { frames.push(fn); return frames.length; };
    window.cancelAnimationFrame = jest.fn();
    jest.spyOn(window, 'getComputedStyle').mockImplementation(() => style);
    window.VH = {};
  });
  afterEach(() => {
    jest.restoreAllMocks();
    jest.useRealTimers();
    delete window.ResizeObserver;
  });

  test('premier rendu : propriétés posées, décor construit, carte centrée annoncée', () => {
    const ctl = setup({ start: 1 });
    expect(ctl.position).toBe(1);
    expect(xOf(1)).toBe(0);
    expect(xOf(2)).toBeCloseTo(298);
    expect(track.children[1].classList.contains('is-centered')).toBe(true);
    expect(track.children[0].style.getPropertyValue('--tl-veil')).toBe('0.450');
    expect(track.children[1].style.getPropertyValue('--tl-z')).toBe('100');
    expect(centers).toEqual([1]);
    expect(stage.style.getPropertyValue('--tl-anchor-y')).toBe('92.00');
    expect(document.querySelector('#cables path').getAttribute('d')).toMatch(/^M500 92L/);
    expect(document.getElementById('ruler').style.getPropertyValue('--tl-tick-h')).toBe('60.00');
    expect(document.querySelectorAll('#ruler .conflict-tl-ticks')).toHaveLength(4);
    expect(document.querySelectorAll('#ruler .conflict-tl-ticks i')).toHaveLength(20);
    expect(document.querySelectorAll('#cables path')).toHaveLength(4);
    expect(document.getElementById('cables').getAttribute('viewBox')).toBe('0 0 1000 400');
  });

  test('goTo anime avec la durée et la courbe du CSS, puis s\'arrête sur la date', () => {
    const ctl = setup();
    ctl.goTo(2);
    expect(frames).toHaveLength(1);
    flushFrames([1000, 1260]);
    expect(ctl.position).toBeGreaterThan(1);
    expect(ctl.position).toBeLessThan(2);
    flushFrames([1600]);
    expect(ctl.position).toBe(2);
    expect(frames).toHaveLength(0);
    ctl.goTo(99, { animate: false }); // borné, sans animation
    expect(ctl.position).toBe(4);
  });

  test('saut direct : moins d\'animations (site ou système), durée nulle', () => {
    let ctl = setup();
    window.VH.motion = { prefersReducedMotion: () => true, parseTime: (v) => parseFloat(v) * 1000 };
    ctl.goTo(3);
    expect(ctl.position).toBe(3);
    expect(frames).toHaveLength(0);
    window.VH = {};
    window.matchMedia = jest.fn(() => ({ matches: true }));
    ctl = setup();
    ctl.goTo(2);
    expect(ctl.position).toBe(2);
    delete window.matchMedia;
    style.transitionDuration = '0s';
    ctl = setup();
    ctl.goTo(1);
    expect(ctl.position).toBe(1);
    style.transitionDuration = '240ms, 0s';
    ctl = setup();
    ctl.goTo(1);
    expect(frames).toHaveLength(1);
    style.transitionDuration = 'n/a';
    ctl = setup();
    ctl.goTo(1);
    expect(ctl.position).toBe(1);
  });

  test('glisser : la piste suit le pointeur, résiste aux extrémités, l\'élan choisit la date', () => {
    const ctl = setup({ start: 0 });
    stage.setPointerCapture = jest.fn();
    pointer('pointerdown', 500, 0);
    pointer('pointermove', 498, 10); // sous le seuil : rien
    expect(stage.classList.contains('is-dragging')).toBe(false);
    pointer('pointermove', 400, 20);
    expect(stage.classList.contains('is-dragging')).toBe(true);
    expect(stage.setPointerCapture).toHaveBeenCalledWith(1);
    // le seuil franchi fixe le point de départ : la piste suit ensuite le pointeur
    expect(ctl.position).toBe(0);
    pointer('pointermove', 300, 25);
    expect(ctl.position).toBeCloseTo(100 / 298, 3);
    pointer('pointermove', 100, 27); // la carte suivante passe sous la tête de lecture
    expect(centers).toEqual([0, 1]);
    pointer('pointermove', 2, 30, 2); // autre pointeur : ignoré
    pointer('pointerup', 2, 31, 2); // lâcher d'un autre pointeur : ignoré
    expect(stage.classList.contains('is-dragging')).toBe(true);
    pointer('pointermove', 0, 40);
    pointer('pointerup', 0, 41);
    expect(stage.classList.contains('is-dragging')).toBe(false);
    // position ≈ 1,34 et vitesse forte vers la droite : l'élan va plus loin, sans dépasser la fin
    expect(selected).toHaveLength(1);
    expect(selected[0]).toBeGreaterThanOrEqual(2);
    expect(selected[0]).toBeLessThanOrEqual(4);

    // au-delà de la première date, la piste ne suit qu'à 30 %
    ctl.goTo(0, { animate: false });
    pointer('pointerdown', 500, 100);
    pointer('pointermove', 600, 150); // seuil franchi : départ fixé ici
    pointer('pointermove', 898, 200);
    expect(ctl.position).toBeCloseTo(-0.3, 2);
    pointer('pointercancel', 798, 201); // annulé : pas d'élan, retour à la plus proche
    expect(selected[selected.length - 1]).toBe(0);

    // immobile avant le lâcher : l'élan est oublié, on se pose sur la plus proche
    ctl.goTo(0, { animate: false });
    pointer('pointerdown', 500, 300);
    pointer('pointermove', 400, 310);
    pointer('pointermove', 202, 320);
    pointer('pointerup', 202, 600);
    expect(selected[selected.length - 1]).toBe(1);
  });

  test('souris relâchée hors de la scène avant le seuil : le glissement est abandonné', () => {
    const ctl = setup();
    pointer('pointerdown', 500, 0, 1, { pointerType: 'mouse' });
    pointer('pointermove', 300, 10, 1, { pointerType: 'mouse', buttons: 0 });
    pointer('pointermove', 200, 20, 1, { pointerType: 'mouse' });
    expect(stage.classList.contains('is-dragging')).toBe(false);
    expect(ctl.position).toBe(0);
  });

  test('appui pendant une glissade : la piste repart de sa position du moment', () => {
    const ctl = setup();
    ctl.goTo(2);
    flushFrames([0, 100]);
    const mid = ctl.position;
    expect(mid).toBeGreaterThan(0);
    pointer('pointerdown', 500, 0);
    flushFrames([300]); // la glissade avance encore avant le seuil
    const moving = ctl.position;
    pointer('pointermove', 490, 10);
    expect(ctl.position).toBe(moving);
    expect(window.cancelAnimationFrame).toHaveBeenCalled();
  });

  test('un clic après un glissement est avalé ; un clic au clavier ou un simple clic passe', () => {
    jest.useFakeTimers();
    setup();
    const clicks = jest.fn();
    track.addEventListener('click', clicks);
    const mouseClick = () => track.children[1].dispatchEvent(new window.MouseEvent('click', { bubbles: true, detail: 1 }));
    pointer('pointerdown', 500, 0);
    pointer('pointermove', 450, 10);
    pointer('pointerup', 450, 20);
    track.children[1].click(); // detail 0 : Entrée ou Espace, jamais avalé
    expect(clicks).toHaveBeenCalledTimes(1);
    mouseClick();
    expect(clicks).toHaveBeenCalledTimes(1);
    pointer('pointerdown', 500, 30);
    pointer('pointerup', 500, 31); // pas de mouvement : pas de choix imposé
    mouseClick();
    expect(clicks).toHaveBeenCalledTimes(2);
    expect(selected).toHaveLength(1);
    // aucun clic après le lâcher : désarmé à la tâche suivante
    pointer('pointerdown', 500, 40);
    pointer('pointermove', 450, 50);
    pointer('pointerup', 450, 60);
    jest.advanceTimersByTime(0);
    mouseClick();
    expect(clicks).toHaveBeenCalledTimes(3);
  });

  test('bouton secondaire, une seule date, glisser-déposer natif : ignorés', () => {
    setup({ count: 1 });
    pointer('pointerdown', 500, 0);
    pointer('pointermove', 300, 10);
    expect(stage.classList.contains('is-dragging')).toBe(false);
    const drag = new window.Event('dragstart', { cancelable: true });
    stage.dispatchEvent(drag);
    expect(drag.defaultPrevented).toBe(true);
    setup();
    const ev = new window.Event('pointerdown');
    Object.defineProperties(ev, { button: { value: 2 }, clientX: { value: 0 }, pointerId: { value: 1 }, timeStamp: { value: 0 } });
    stage.dispatchEvent(ev);
    pointer('pointermove', 300, 10);
    expect(stage.classList.contains('is-dragging')).toBe(false);
  });

  test('molette horizontale : la piste suit, puis se pose après une pause ; verticale : la page défile', () => {
    jest.useFakeTimers();
    const ctl = setup();
    const wheel = (dx, dy, mode = 0) => {
      const ev = new window.Event('wheel', { cancelable: true });
      Object.defineProperties(ev, { deltaX: { value: dx }, deltaY: { value: dy }, deltaMode: { value: mode } });
      stage.dispatchEvent(ev);
      return ev;
    };
    expect(wheel(0, 120).defaultPrevented).toBe(false);
    expect(wheel(149, 0).defaultPrevented).toBe(true);
    expect(ctl.position).toBeCloseTo(0.5, 2);
    wheel(149, 0);
    jest.advanceTimersByTime(139);
    expect(selected).toHaveLength(0);
    jest.advanceTimersByTime(1);
    expect(selected).toEqual([1]);
    wheel(-300, 0);
    expect(ctl.position).toBeLessThanOrEqual(0);
    // au bout, vers l'extérieur : le geste revient au navigateur (retour arrière du pavé)
    const pos = ctl.position;
    expect(wheel(-300, 0).defaultPrevented).toBe(false);
    expect(ctl.position).toBe(pos);
    // lignes (Firefox) : 16 px par ligne ; pages : une largeur de scène
    ctl.goTo(1, { animate: false });
    wheel(-6, 0, 1);
    expect(ctl.position).toBeCloseTo(1 - 96 / 298, 3);
    wheel(2, 0, 2);
    expect(ctl.position).toBe(4.5);
    // au bout à droite, vers l'extérieur : rien
    expect(wheel(50, 0).defaultPrevented).toBe(false);
  });

  test('redimensionnement : mesure refaite ; destroy : écouteurs, décor et observateur retirés', () => {
    const observe = jest.fn();
    const disconnect = jest.fn();
    let onResize;
    window.ResizeObserver = function (cb) { onResize = cb; this.observe = observe; this.disconnect = disconnect; };
    const ctl = setup();
    expect(observe).toHaveBeenCalledTimes(3);
    style.columnGap = '0px';
    onResize();
    expect(xOf(1)).toBeCloseTo(258);
    ctl.refresh();
    ctl.goTo(2);
    ctl.destroy();
    expect(disconnect).toHaveBeenCalled();
    expect(window.cancelAnimationFrame).toHaveBeenCalled();
    expect(document.getElementById('ruler').children).toHaveLength(0);
    pointer('pointerdown', 500, 0);
    pointer('pointermove', 300, 10);
    expect(stage.classList.contains('is-dragging')).toBe(false);
  });

  test('sans requestAnimationFrame ni décor : minuterie de repli, rien ne casse', () => {
    jest.useFakeTimers();
    delete window.requestAnimationFrame;
    delete window.cancelAnimationFrame;
    style.columnGap = 'normal';
    document.body.innerHTML = '<div id="stage"><div id="track"><button></button><button></button></div></div>';
    stage = document.getElementById('stage');
    track = document.getElementById('track');
    const ctl = C.create({ stage, track, count: 2, onSelect: () => {} });
    ctl.goTo(1);
    jest.advanceTimersByTime(1000);
    expect(ctl.position).toBe(1);
    ctl.destroy();
    document.body.innerHTML = '<div id="stage"><div id="track"></div></div>';
    const empty = C.create({ stage: document.getElementById('stage'), track: document.getElementById('track'), count: 0, onSelect: () => {} });
    expect(empty.position).toBe(0);
  });
});
