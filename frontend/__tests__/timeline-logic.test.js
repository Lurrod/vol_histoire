/**
 * Tests unitaires — frontend/js/timeline/{util,era,data,keyboard,effects}.js
 * Logique de la frise : langue, dates, échappement, couleur d'ère lue dans
 * timeline.css, filtrage des décennies, navigation clavier, effets.
 */
const fs = require('fs');
const path = require('path');

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { currentLang: 'fr', t: (key) => key };
window.i18n = global.i18n;

const util = require('../js/timeline/util');
const era = require('../js/timeline/era');
const data = require('../js/timeline/data');
const keyboard = require('../js/timeline/keyboard');
const effects = require('../js/timeline/effects');

function setReducedMotion(on) {
  window.matchMedia = jest.fn(() => ({ matches: on }));
}

afterEach(() => {
  window.i18n.currentLang = 'fr';
  delete window.matchMedia;
  jest.restoreAllMocks();
});

describe('util', () => {
  test('localized : langue courante, puis fr, puis champ nu, puis vide', () => {
    const ev = { title_fr: 'Titre', title_en: 'Title', body: 'Corps' };
    expect(util.localized(ev, 'title')).toBe('Titre');
    window.i18n.currentLang = 'en';
    expect(util.localized(ev, 'title')).toBe('Title');
    expect(util.localized({ title_fr: 'Seul' }, 'title')).toBe('Seul');
    expect(util.localized(ev, 'body')).toBe('Corps');
    expect(util.localized(ev, 'quote_author')).toBe('');
  });

  test('currentLang retombe sur fr sans i18n', () => {
    const saved = window.i18n;
    delete window.i18n;
    expect(util.currentLang()).toBe('fr');
    window.i18n = saved;
  });

  test('fmtDate : vide, invalide, français et anglais', () => {
    expect(util.fmtDate('')).toBe('');
    expect(util.fmtDate('pas une date')).toBe('');
    expect(util.fmtDate('1969-07-20')).toMatch(/20 juillet 1969/);
    window.i18n.currentLang = 'en';
    expect(util.fmtDate('1969-07-20')).toMatch(/July 20, 1969/);
  });

  test('fmtDate retombe sur l\'ISO si toLocaleDateString lève', () => {
    jest.spyOn(Date.prototype, 'toLocaleDateString').mockImplementation(() => { throw new RangeError('x'); });
    expect(util.fmtDate('1969-07-20T00:00:00Z')).toBe('1969-07-20');
  });

  test('escapeAttr neutralise guillemets et chevrons', () => {
    expect(util.escapeAttr(`a"b'<c>&`)).toBe('a&quot;b&#39;&lt;c&gt;&amp;');
    expect(util.escapeAttr(null)).toBe('');
  });

  test('scrollBehavior suit prefers-reduced-motion', () => {
    expect(util.scrollBehavior()).toBe('smooth'); // pas de matchMedia
    setReducedMotion(true);
    expect(util.scrollBehavior()).toBe('auto');
    setReducedMotion(false);
    expect(util.scrollBehavior()).toBe('smooth');
  });

  test('scrollToElement vise le haut de l\'élément moins l\'en-tête', () => {
    window.scrollTo = jest.fn();
    const el = { getBoundingClientRect: () => ({ top: 500 }) };
    util.scrollToElement(el);
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 500 + window.pageYOffset - 80, behavior: 'smooth' });
  });

  test('onScrollFrame : un seul appel par image', () => {
    const frames = [];
    window.requestAnimationFrame = global.requestAnimationFrame = jest.fn(cb => frames.push(cb));
    const fn = jest.fn();
    util.onScrollFrame(fn);
    window.dispatchEvent(new Event('scroll'));
    window.dispatchEvent(new Event('scroll'));
    expect(frames).toHaveLength(1);
    frames[0]();
    expect(fn).toHaveBeenCalledTimes(1);
    window.dispatchEvent(new Event('scroll'));
    expect(frames).toHaveLength(2);
  });
});

describe('era', () => {
  const css = fs.readFileSync(path.join(__dirname, '..', 'css', 'timeline.css'), 'utf8');

  beforeEach(() => {
    document.head.innerHTML = `<style>${css}</style>`;
    document.body.className = 'page-timeline';
    document.body.removeAttribute('style');
  });

  test('getEra lit libellé, titre et récit dans i18n, sans couleur', () => {
    expect(era.getEra(1950)).toEqual({
      label: 'timeline.era_1950_label2',
      title: 'timeline.era_1950_title2',
      narrative: 'timeline.era_1950_narrative',
    });
  });

  test.each([
    [1940, '#d4a017'], [1950, '#3aff6e'], [1960, '#ff8c00'], [1970, '#ff4500'],
    [1980, '#C8A96E'], [1990, '#8f75f5'], [2000, '#2979ff'], [2010, '#e040fb'], [2020, '#ff3d6e'],
  ])('timeline.css couvre la décennie %i (data-decade)', (decade, color) => {
    document.body.innerHTML = `<section class="tl-chapter" data-decade="${decade}"></section>`;
    expect(era.eraColor(document.querySelector('.tl-chapter')).toLowerCase()).toBe(color.toLowerCase());
  });

  test('décennie hors feuille de style ou élément absent : repli cyan', () => {
    document.body.innerHTML = '<section class="tl-chapter" data-decade="1930"></section>';
    expect(era.eraColor(document.querySelector('.tl-chapter'))).toBe('var(--hud-cyan)');
    expect(era.eraColor(null)).toBe('var(--hud-cyan)');
  });

  test('showActiveEra met à jour le HUD et la teinte du body', () => {
    document.body.innerHTML = `
      <span id="tl-year-hud-num"></span><span id="tl-year-hud-label"></span>
      <section class="tl-chapter" data-decade="1990"></section>`;
    const decade = era.showActiveEra(document.querySelector('.tl-chapter'));
    expect(decade).toBe(1990);
    expect(document.getElementById('tl-year-hud-num').textContent).toBe('1990s');
    expect(document.getElementById('tl-year-hud-label').textContent).toBe('timeline.era_1990_label2');
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('#8f75f5');
    era.clearActiveEra();
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('');
  });

  test('showActiveEra tolère un HUD absent', () => {
    document.body.innerHTML = '<section class="tl-chapter" data-decade="2000"></section>';
    expect(era.showActiveEra(document.querySelector('.tl-chapter'))).toBe(2000);
  });
});

describe('data', () => {
  const DECADES = [
    { decade: 1940, events: [], aircraft: [] },
    { decade: 1950, events: [{ id: 1 }], aircraft: [] },
    { decade: 1960, aircraft: [{ id: 2 }, { id: 3 }] },
  ];

  test('keepNonEmpty retire les décennies sans événement ni appareil', () => {
    expect(data.keepNonEmpty(DECADES).map(d => d.decade)).toEqual([1950, 1960]);
  });

  test('countTotals additionne événements et appareils', () => {
    expect(data.countTotals(data.keepNonEmpty(DECADES))).toEqual({ events: 1, aircraft: 2, decades: 2 });
  });

  test('loadTimeline interroge /api/timeline et filtre', async () => {
    global.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: DECADES }) })) };
    const out = await data.loadTimeline();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/timeline');
    expect(out).toHaveLength(2);
  });

  test('loadTimeline : charge utile sans tableau → liste vide', async () => {
    global.auth = { fetchWithTimeout: () => Promise.resolve({ ok: true, json: () => Promise.resolve({}) }) };
    expect(await data.loadTimeline()).toEqual([]);
  });

  test('loadTimeline lève sur une réponse en erreur', async () => {
    global.auth = { fetchWithTimeout: () => Promise.resolve({ ok: false, status: 503 }) };
    await expect(data.loadTimeline()).rejects.toThrow('503');
  });
});

describe('keyboard', () => {
  beforeEach(() => {
    document.body.innerHTML = [1950, 1960, 1970].map(d => `<section id="ch-${d}"></section>`).join('');
    [1950, 1960, 1970].forEach((d, i) => {
      const el = document.getElementById(`ch-${d}`);
      Object.defineProperty(el, 'offsetTop', { value: i * 1000 });
      el.getBoundingClientRect = () => ({ top: i * 1000 });
    });
    window.scrollTo = jest.fn();
  });

  test('keyAction associe chaque touche à une action', () => {
    expect(keyboard.keyAction('ArrowDown')).toBe('next');
    expect(keyboard.keyAction(' ')).toBe('next');
    expect(keyboard.keyAction('PageUp')).toBe('prev');
    expect(keyboard.keyAction('Home')).toBe('home');
    expect(keyboard.keyAction('End')).toBe('end');
    expect(keyboard.keyAction('a')).toBeNull();
    expect(keyboard.keyAction('constructor')).toBeNull();
  });

  test('chapterIndexAt : dernier chapitre passé, 0 avant le premier', () => {
    const ids = [1950, 1960, 1970];
    expect(keyboard.chapterIndexAt(ids, 1500)).toBe(1);
    expect(keyboard.chapterIndexAt(ids, 5000)).toBe(2);
    expect(keyboard.chapterIndexAt(ids, -1)).toBe(0);
  });

  test('jumpTo borne l\'index et ignore un chapitre absent', () => {
    keyboard.jumpTo([1950, 1960, 1970], 99);
    expect(window.scrollTo).toHaveBeenLastCalledWith({ top: 2000 + window.pageYOffset - 80, behavior: 'smooth' });
    keyboard.jumpTo([1930], 0);
    expect(window.scrollTo).toHaveBeenCalledTimes(1);
  });

  test('initKeyboard : flèches, Début, Fin ; ignore les champs de saisie', () => {
    keyboard.initKeyboard([{ decade: 1950 }, { decade: 1960 }, { decade: 1970 }]);
    const press = (key, target = document.body) => {
      const e = new KeyboardEvent('keydown', { key, bubbles: true, cancelable: true });
      target.dispatchEvent(e);
      return e;
    };
    expect(press('ArrowDown').defaultPrevented).toBe(true);
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: 1000 + window.pageYOffset - 80 }));
    press('ArrowUp');
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: 0 + window.pageYOffset - 80 }));
    press('End');
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: 2000 + window.pageYOffset - 80 }));
    press('Home');
    expect(window.scrollTo).toHaveBeenLastCalledWith({ top: 0, behavior: 'smooth' });
    expect(press('x').defaultPrevented).toBe(false);

    const input = document.createElement('input');
    document.body.appendChild(input);
    const calls = window.scrollTo.mock.calls.length;
    expect(press('ArrowDown', input).defaultPrevented).toBe(false);
    expect(window.scrollTo).toHaveBeenCalledTimes(calls);
  });
});

describe('effects — logique', () => {
  test('particleCount : une particule pour 22 000 px², 80 au plus', () => {
    expect(effects.particleCount(1100, 200)).toBe(10);
    expect(effects.particleCount(4000, 4000)).toBe(80);
  });

  test('makeParticles construit des particules dans le cadre', () => {
    const ps = effects.makeParticles(3, 100, 50, () => 0.5);
    expect(ps).toHaveLength(3);
    expect(ps[0]).toMatchObject({ x: 50, y: 25, vx: 0, vy: 0 });
    expect(ps[0].r).toBeCloseTo(0.95);
    expect(ps[0].a).toBeCloseTo(0.325);
  });

  test('stepParticle avance et fait réapparaître de l\'autre côté', () => {
    const p = { x: -5, y: 10, vx: -1, vy: 0 };
    effects.stepParticle(p, 100, 50);
    expect(p.x).toBe(105);
    const q = { x: 105, y: 55, vx: 1, vy: 1 };
    effects.stepParticle(q, 100, 50);
    expect(q).toMatchObject({ x: -5, y: -5 });
    const r = { x: 10, y: -5, vx: 0, vy: -1 };
    effects.stepParticle(r, 100, 50);
    expect(r.y).toBe(55);
  });

  test('scrollPercent et easeOutCubic', () => {
    expect(effects.scrollPercent(250, 1500, 500)).toBe(25);
    expect(effects.scrollPercent(0, 500, 500)).toBe(0);
    expect(effects.easeOutCubic(0)).toBe(0);
    expect(effects.easeOutCubic(1)).toBe(1);
    expect(effects.easeOutCubic(0.5)).toBeCloseTo(0.875);
  });

  test('animateCounter : valeur finale directe en mouvement réduit', () => {
    setReducedMotion(true);
    const el = document.createElement('span');
    effects.animateCounter(el, 42);
    expect(el.textContent).toBe('42');
    expect(() => effects.animateCounter(null, 1)).not.toThrow();
  });

  test('animateCounter : interpolation jusqu\'à la cible', () => {
    const frames = [];
    global.requestAnimationFrame = jest.fn(cb => frames.push(cb));
    jest.spyOn(window.performance, 'now').mockReturnValue(0);
    const el = document.createElement('span');
    effects.animateCounter(el, 100, 1000);
    frames.shift()(500);
    expect(el.textContent).toBe('88');
    frames.shift()(1000);
    expect(el.textContent).toBe('100');
    expect(frames).toHaveLength(0);
  });
});
