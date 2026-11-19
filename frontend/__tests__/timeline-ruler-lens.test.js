/**
 * Tests — frontend/js/timeline/{ruler,lens}.js
 * Règle des années (axe, pistes de conflits, odomètre, curseur, décennie
 * active, ancrage sous l'en-tête, liens directs #1962) et filtres « par
 * nation » / « par type » (listes, URL partageable, réinitialisation,
 * bascule mobile, annonce aux lecteurs d'écran).
 */
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
const fakeT = (key) => key;
const I18N = { currentLang: 'fr', t: fakeT };
window.i18n = I18N;

require('./helpers/motion-env').loadMotion();
const util = require('../js/timeline/util');
require('../js/timeline/era');
require('../js/timeline/data');
const ruler = require('../js/timeline/ruler');
const lens = require('../js/timeline/lens');

const ROLLING = window.VH.rollingNumber;

beforeEach(() => {
  ruler._reset();
  window.scrollTo = jest.fn();
  window.i18n = I18N;
  I18N.t = fakeT;
  window.VH.rollingNumber = ROLLING;
  window.history.replaceState(null, '', '/timeline');
});

afterEach(() => {
  jest.restoreAllMocks();
  delete window.ResizeObserver;
  delete global.ResizeObserver;
});

const num = (v) => parseFloat(v);

/* ====================================================================== */
/* ruler — calculs                                                        */
/* ====================================================================== */

describe('ruler — calculs', () => {
  test('percent : position bornée à [0, 100], 0 si l\'axe est vide', () => {
    expect(ruler.percent(1990, 1940, 2040)).toBe(50);
    expect(ruler.percent(1900, 1940, 2040)).toBe(0);
    expect(ruler.percent(2100, 1940, 2040)).toBe(100);
    expect(ruler.percent(1990, 2000, 2000)).toBe(0);
    expect(ruler.percent(1990, 2000, 1990)).toBe(0);
  });

  test('tickYear : 1945 pour le chapitre 1940, la décennie sinon', () => {
    expect(ruler.tickYear(1940)).toBe(1945);
    expect(ruler.tickYear(1960)).toBe(1960);
  });

  test('yearInChapter : année atteinte selon la part parcourue', () => {
    expect(ruler.yearInChapter(1940, 0, 2026)).toBe(1945);
    expect(ruler.yearInChapter(1940, 0.5, 2026)).toBe(1947);
    expect(ruler.yearInChapter(1960, 0.78, 2026)).toBe(1967);
    expect(ruler.yearInChapter(1960, undefined, 2026)).toBe(1960);
    expect(ruler.yearInChapter(1960, -3, 2026)).toBe(1960);
    expect(ruler.yearInChapter(1960, 0.999, 2026)).toBe(1969);
    // Décennie en cours : jamais au-delà de l'année courante.
    expect(ruler.yearInChapter(2020, 1, 2026)).toBe(2026);
    expect(ruler.yearInChapter(2020, 5, 2026)).toBe(2026);
  });

  test('packLanes : pistes sans chevauchement, réutilisées dès qu\'elles se libèrent', () => {
    const wars = [
      { id: 'b', start_year: 1955, end_year: 1975 },
      { id: 'a', start_year: 1950, end_year: 1953 },
      { id: 'c', start_year: 1953, end_year: 1956 }, // 1953 n'est pas libre (borne incluse)
      { id: 'd', start_year: 1960, end_year: 1962 }, // reprend la piste de « c »
      { id: 'x', start_year: null, end_year: 1960 }, // sans début : ignoré
    ];
    const placed = ruler.packLanes(wars, 2026);
    expect(placed.map(p => [p.war.id, p.lane, p.from, p.to])).toEqual([
      ['a', 0, 1950, 1953],
      ['c', 1, 1953, 1956],
      ['b', 0, 1955, 1975], // la piste de « a » est libre depuis 1954
      ['d', 1, 1960, 1962],
    ]);
    expect(wars[0].id).toBe('b'); // tableau d'entrée non trié sur place
  });

  test('packLanes : conflit en cours jusqu\'à `end`, bandes en trop omises', () => {
    const wars = [
      { id: 1, start_year: 2014, end_year: null },
      { id: 2, start_year: 2015, end_year: 2020 },
      { id: 3, start_year: 2016, end_year: 2018 },
      { id: 4, start_year: 2017, end_year: 2019 }, // quatrième piste : omise
      { id: 5, start_year: 2022, end_year: 2022 }, // la piste de 3 est libre
    ];
    const placed = ruler.packLanes(wars, 2026);
    expect(ruler.MAX_LANES).toBe(3);
    expect(placed.map(p => [p.war.id, p.lane, p.to])).toEqual([
      [1, 0, 2026], [2, 1, 2020], [3, 2, 2018], [5, 1, 2022],
    ]);
    expect(ruler.packLanes(wars, 2026, 1).map(p => p.war.id)).toEqual([1]);
    expect(ruler.packLanes([], 2026)).toEqual([]);
  });

  test('decadeFromHash : #1962, #ch-1960 ; le reste ignoré', () => {
    expect(ruler.decadeFromHash('#1962')).toBe(1960);
    expect(ruler.decadeFromHash('#ch-1970')).toBe(1970);
    expect(ruler.decadeFromHash('#ch-197')).toBeNull();
    expect(ruler.decadeFromHash('#chapitre')).toBeNull();
    expect(ruler.decadeFromHash('1962')).toBeNull();
    expect(ruler.decadeFromHash('')).toBeNull();
    expect(ruler.decadeFromHash(undefined)).toBeNull();
  });
});

/* ====================================================================== */
/* ruler — DOM                                                            */
/* ====================================================================== */

describe('ruler — DOM', () => {
  const DECADES = [{ decade: 1940 }, { decade: 1950 }, { decade: 1960 }];
  const WARS = [
    { id: 1, start_year: 1950, end_year: 1953 },
    { id: 2, start_year: 1991, end_year: null },
  ];

  function page() {
    document.body.innerHTML = `
      <header></header>
      <div id="tl-bar">
        <span id="tl-bar-year">1945</span><span id="tl-bar-era"></span>
        <nav id="tl-ruler"></nav>
      </div>
      <section id="ch-1940"></section><section id="ch-1950"></section><section id="ch-1960"></section>`;
  }

  beforeEach(() => {
    page();
    // Axe de 1940 à 2040 : 1 an = 1 %.
    jest.spyOn(util, 'currentYear').mockReturnValue(2040);
  });

  test('render : un bouton par décennie, positions posées par le CSSOM', () => {
    ruler.render(DECADES, WARS);
    const items = document.querySelectorAll('.tl-tick-item');
    expect([...items].map(li => li.dataset.year)).toEqual(['1940', '1950', '1960']);
    expect([...items].map(li => num(li.style.getPropertyValue('--x')))).toEqual([0, 10, 20]);
    expect(items[0].getAttribute('style')).toContain('--x');

    const btn = items[1].querySelector('.tl-tick');
    expect(btn.dataset.target).toBe('ch-1950');
    expect(btn.getAttribute('aria-label')).toBe('Aller aux années 1950');
    expect(btn.querySelector('.tl-tick-full').textContent).toBe('1950');
    expect(btn.querySelector('.tl-tick-short').textContent).toBe('’50');
    expect(document.querySelector('.tl-ruler-track').getAttribute('aria-hidden')).toBe('true');
  });

  test('render : bandes de conflits (largeur minimale, conflit en cours jusqu\'à l\'année courante)', () => {
    ruler.render(DECADES, [...WARS, { id: 3, start_year: 1956, end_year: 1956 }]);
    const bands = document.querySelectorAll('.tl-ruler-war');
    expect(bands).toHaveLength(3);
    const [korea, suez, open] = bands;
    expect(korea.dataset).toMatchObject({ lane: '0', from: '1950', to: '1953' });
    expect(num(korea.style.getPropertyValue('--x'))).toBeCloseTo(10);
    expect(num(korea.style.getPropertyValue('--w'))).toBeCloseTo(4);
    expect(num(suez.style.getPropertyValue('--w'))).toBeCloseTo(1);
    expect(open.dataset.to).toBe('2040');
    // Bande bornée à 100 % : 1991 → 2041 (hors axe) = 49 %.
    expect(num(open.style.getPropertyValue('--w'))).toBeCloseTo(49);
  });

  test('render : bande d\'au moins 0,6 % quand l\'axe est très long', () => {
    util.currentYear.mockReturnValue(2240); // 1 an = 0,333 %
    ruler.render(DECADES, [{ id: 1, start_year: 1956, end_year: 1956 }]);
    expect(num(document.querySelector('.tl-ruler-war').style.getPropertyValue('--w'))).toBe(0.6);
  });

  test('render : libellé traduit, conflits absents tolérés', () => {
    I18N.t = (key, params) => `Go ${params.decade}`;
    ruler.render(DECADES);
    expect(document.querySelectorAll('.tl-ruler-war')).toHaveLength(0);
    expect(document.querySelector('.tl-tick').getAttribute('aria-label')).toBe('Go 1940');
  });

  test('render : sans conteneur, rien', () => {
    document.body.innerHTML = '';
    expect(() => ruler.render(DECADES, WARS)).not.toThrow();
  });

  test('clic sur une décennie : défilement vers son chapitre ; cible absente ignorée', () => {
    document.getElementById('ch-1960').getBoundingClientRect = () => ({ top: 900 });
    ruler.render(DECADES, WARS);
    document.querySelector('[data-target="ch-1960"]').click();
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 900 + window.pageYOffset - util.SCROLL_OFFSET, behavior: 'smooth' });
    document.getElementById('ch-1940').remove();
    document.querySelector('[data-target="ch-1940"]').click();
    expect(window.scrollTo).toHaveBeenCalledTimes(1);
  });

  test('setYear : odomètre, curseur et décennie active (aria-current)', () => {
    ruler.render(DECADES, WARS);
    ruler.setYear(1962, 1960);
    const year = document.getElementById('tl-bar-year');
    expect(year.classList.contains('t-roll')).toBe(true);
    expect(year.querySelector('.sr-only').textContent).toBe('1962');
    expect(num(document.getElementById('tl-ruler-cursor').style.getPropertyValue('--x'))).toBeCloseTo(22);
    const active = document.querySelector('[data-decade="1960"]');
    expect(active.classList.contains('active')).toBe(true);
    expect(active.getAttribute('aria-current')).toBe('true');
    expect(document.querySelectorAll('.tl-tick[aria-current]')).toHaveLength(1);

    ruler.setYear(1953, 1950);
    expect(active.classList.contains('active')).toBe(false);
    expect(active.hasAttribute('aria-current')).toBe(false);
    expect(document.querySelector('[data-decade="1950"]').getAttribute('aria-current')).toBe('true');
    expect(year.querySelector('.sr-only').textContent).toBe('1953');
  });

  test('setYear : idempotent pour la même année et la même décennie', () => {
    ruler.render(DECADES, WARS);
    const spy = jest.spyOn(ROLLING, 'setText');
    ruler.setYear(1945, null);
    ruler.setYear(1945, null);
    expect(spy).toHaveBeenCalledTimes(1);
    ruler.setYear(1945, 1940);
    expect(spy).toHaveBeenCalledTimes(2);
    expect(document.querySelectorAll('.tl-tick[aria-current]')).toHaveLength(1);
  });

  test('setYear : sans odomètre, texte brut ; sans barre ni règle, aucune erreur', () => {
    delete window.VH.rollingNumber;
    ruler.setYear(1970, 1970);
    expect(document.getElementById('tl-bar-year').textContent).toBe('1970');
    document.body.innerHTML = '';
    expect(() => ruler.setYear(1980, 1980)).not.toThrow();
  });

  test('render après setYear : curseur et décennie active reposés (nouveau rendu du filtre)', () => {
    ruler.render(DECADES, WARS);
    ruler.setYear(1955, 1950);
    ruler.render(DECADES, []);
    expect(num(document.getElementById('tl-ruler-cursor').style.getPropertyValue('--x'))).toBeCloseTo(15);
    expect(document.querySelector('[data-decade="1950"]').getAttribute('aria-current')).toBe('true');
  });

  test('syncBarTop : hauteur réelle de l\'en-tête, suivie par un ResizeObserver en border-box', () => {
    const header = document.querySelector('header');
    let height = 72;
    header.getBoundingClientRect = () => ({ bottom: height });
    const observed = [];
    window.ResizeObserver = global.ResizeObserver = class {
      constructor(cb) { this.cb = cb; }
      observe(el, opts) { observed.push({ el, opts, cb: this.cb }); }
    };
    ruler.syncBarTop();
    const bar = document.getElementById('tl-bar');
    expect(bar.style.getPropertyValue('--tl-bar-top')).toBe('72px');
    expect(observed).toHaveLength(1);
    expect(observed[0].el).toBe(header);
    expect(observed[0].opts).toEqual({ box: 'border-box' });
    height = 56;
    observed[0].cb();
    expect(bar.style.getPropertyValue('--tl-bar-top')).toBe('56px');
    // Menu flottant ouvert : l'en-tête grandit sous le voile, la règle ne bouge pas.
    header.classList.add('menu-open');
    height = 400;
    observed[0].cb();
    expect(bar.style.getPropertyValue('--tl-bar-top')).toBe('56px');
    header.classList.remove('menu-open');
    observed[0].cb();
    expect(bar.style.getPropertyValue('--tl-bar-top')).toBe('400px');
  });

  test('syncBarTop : sans ResizeObserver, valeur posée une fois ; sans en-tête ou barre, rien', () => {
    document.querySelector('header').getBoundingClientRect = () => ({ bottom: 80 });
    ruler.syncBarTop();
    expect(document.getElementById('tl-bar').style.getPropertyValue('--tl-bar-top')).toBe('80px');
    document.querySelector('header').remove();
    expect(() => ruler.syncBarTop()).not.toThrow();
    document.body.innerHTML = '<header></header>';
    expect(() => ruler.syncBarTop()).not.toThrow();
  });

  test('syncBarTop : seul l\'en-tête enfant direct du body compte', () => {
    document.body.innerHTML = '<div id="tl-bar"><header class="tl-title-card"></header></div>';
    ruler.syncBarTop();
    expect(document.getElementById('tl-bar').style.getPropertyValue('--tl-bar-top')).toBe('');
  });

  test('jumpToHash : défilement immédiat vers le chapitre ; ancre inconnue ou chapitre absent → false', () => {
    document.getElementById('ch-1960').getBoundingClientRect = () => ({ top: 1200 });
    expect(ruler.jumpToHash('#1962')).toBe(true);
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 1200 + window.pageYOffset - util.SCROLL_OFFSET, behavior: 'auto' });
    expect(ruler.jumpToHash('#ch-1960')).toBe(true);
    expect(ruler.jumpToHash('#2010')).toBe(false);
    expect(ruler.jumpToHash('#tl-bar')).toBe(false);
    expect(ruler.jumpToHash('')).toBe(false);
    expect(window.scrollTo).toHaveBeenCalledTimes(2);
  });
});

/* ====================================================================== */
/* lens                                                                   */
/* ====================================================================== */

describe('lens', () => {
  const OPTIONS = {
    nations: [
      { value: 'États-Unis', label: 'États-Unis', count: 1 },
      { value: 'France', label: 'France', count: 2 },
    ],
    types: [{ value: 'Chasseur', label: 'Chasseur', count: 3 }],
  };

  function page({ cselect = false } = {}) {
    const nation = '<select id="tl-lens-nation"><option value="">Toutes les nations</option><option value="old">Ancienne</option></select>';
    document.body.innerHTML = `
      <div id="tl-bar">
        <button type="button" id="tl-lens-toggle" aria-expanded="false"></button>
        <div id="tl-lens">
          ${cselect ? `<div class="cselect"><div role="combobox" tabindex="0" id="combo"></div>${nation}</div>` : nation}
          <select id="tl-lens-type"><option value="">Tous les types</option></select>
          <button type="button" id="tl-lens-reset" hidden></button>
        </div>
        <p id="tl-lens-status"></p>
      </div>`;
  }

  const $ = (id) => document.getElementById(id);
  function choose(id, value) {
    $(id).value = value;
    $(id).dispatchEvent(new Event('change'));
  }

  beforeEach(() => page());

  test('fillSelect : première option gardée, « libellé (nombre) », valeur posée', () => {
    lens.fillSelect($('tl-lens-nation'), OPTIONS.nations, 'France');
    const opts = [...$('tl-lens-nation').options];
    expect(opts.map(o => [o.value, o.textContent])).toEqual([
      ['', 'Toutes les nations'], ['États-Unis', 'États-Unis (1)'], ['France', 'France (2)'],
    ]);
    expect($('tl-lens-nation').value).toBe('France');
    lens.fillSelect($('tl-lens-nation'), OPTIONS.nations, null);
    expect($('tl-lens-nation').value).toBe('');
  });

  test('fillSelect : liste sans option initiale ou absente', () => {
    const select = document.createElement('select');
    lens.fillSelect(select, OPTIONS.types, 'Chasseur');
    expect([...select.options].map(o => o.value)).toEqual(['Chasseur']);
    expect(() => lens.fillSelect(null, OPTIONS.types, null)).not.toThrow();
  });

  test('withLabels : libellés affichés, null si valeur inconnue ou absente', () => {
    expect(lens.withLabels({ nation: 'France', type: 'Chasseur' }, OPTIONS)).toEqual({
      nation: 'France', type: 'Chasseur', nationLabel: 'France', typeLabel: 'Chasseur',
    });
    expect(lens.withLabels({ nation: 'Atlantide', type: '' }, OPTIONS)).toEqual({
      nation: 'Atlantide', type: null, nationLabel: null, typeLabel: null,
    });
  });

  test('urlFor : filtre reflété, ?lang= et ancre conservés, anciens paramètres remplacés', () => {
    const loc = { pathname: '/timeline', search: '?lang=en&nation=Inde&type=X', hash: '#1962' };
    expect(lens.urlFor({ nation: 'France', type: null }, loc)).toBe('/timeline?lang=en&nation=France#1962');
    expect(lens.urlFor({ nation: null, type: null }, { pathname: '/timeline', search: '?nation=Inde', hash: '' }))
      .toBe('/timeline');
    window.history.replaceState(null, '', '/timeline?lang=en');
    expect(lens.urlFor({ nation: null, type: 'Chasseur' })).toBe('/timeline?lang=en&type=Chasseur');
  });

  test('syncUrl : window.history.replaceState, erreur ignorée', () => {
    const spy = jest.spyOn(window.history, 'replaceState');
    lens.syncUrl({ nation: 'France', type: null });
    expect(spy).toHaveBeenLastCalledWith(null, '', '/timeline?nation=France');
    spy.mockImplementation(() => { throw new Error('SecurityError'); });
    expect(() => lens.syncUrl({ nation: null, type: null })).not.toThrow();
  });

  test('init : listes remplies avec les nombres, filtre initial appliqué et renvoyé enrichi', () => {
    const onChange = jest.fn();
    const out = lens.init(OPTIONS, { nation: 'France', type: null }, onChange);
    expect(out).toEqual({ nation: 'France', type: null, nationLabel: 'France', typeLabel: null });
    expect([...$('tl-lens-nation').options].map(o => o.textContent))
      .toEqual(['Toutes les nations', 'États-Unis (1)', 'France (2)']);
    expect([...$('tl-lens-type').options].map(o => o.textContent)).toEqual(['Tous les types', 'Chasseur (3)']);
    expect($('tl-lens-nation').value).toBe('France');
    expect($('tl-lens-reset').hidden).toBe(false);
    expect($('tl-bar').classList.contains('is-filtered')).toBe(true);
    expect(onChange).not.toHaveBeenCalled();
  });

  test('init sans filtre : bouton « Tout afficher » masqué', () => {
    lens.init(OPTIONS, { nation: null, type: null }, jest.fn());
    expect($('tl-lens-reset').hidden).toBe(true);
    expect($('tl-bar').classList.contains('is-filtered')).toBe(false);
  });

  test('changement : onChange avec libellés, URL mise à jour (?lang= et ancre gardés)', () => {
    window.history.replaceState(null, '', '/timeline?lang=en#ch-1960');
    const onChange = jest.fn();
    lens.init(OPTIONS, { nation: null, type: null }, onChange);
    choose('tl-lens-nation', 'États-Unis');
    expect(onChange).toHaveBeenLastCalledWith({
      nation: 'États-Unis', type: null, nationLabel: 'États-Unis', typeLabel: null,
    });
    expect(window.location.pathname + window.location.search + window.location.hash)
      .toBe('/timeline?lang=en&nation=%C3%89tats-Unis#ch-1960');
    expect($('tl-lens-reset').hidden).toBe(false);

    choose('tl-lens-type', 'Chasseur');
    expect(onChange).toHaveBeenLastCalledWith(expect.objectContaining({ nation: 'États-Unis', type: 'Chasseur', typeLabel: 'Chasseur' }));
    expect(new window.URLSearchParams(window.location.search).get('type')).toBe('Chasseur');
    expect(onChange).toHaveBeenCalledTimes(2);
  });

  test('« Tout afficher » : listes vidées, filtre retiré de l\'URL, focus sur la liste des nations', () => {
    window.history.replaceState(null, '', '/timeline?nation=France&type=Chasseur');
    const onChange = jest.fn();
    lens.init(OPTIONS, { nation: 'France', type: 'Chasseur' }, onChange);
    $('tl-lens-reset').click();
    expect($('tl-lens-nation').value).toBe('');
    expect($('tl-lens-type').value).toBe('');
    expect(onChange).toHaveBeenCalledWith({ nation: null, type: null, nationLabel: null, typeLabel: null });
    expect(window.location.search).toBe('');
    expect($('tl-lens-reset').hidden).toBe(true);
    expect($('tl-bar').classList.contains('is-filtered')).toBe(false);
    expect(document.activeElement).toBe($('tl-lens-nation'));
  });

  test('« Tout afficher » : focus sur le déclencheur de la liste personnalisée', () => {
    page({ cselect: true });
    lens.init(OPTIONS, { nation: 'France', type: null }, jest.fn());
    $('tl-lens-reset').click();
    expect(document.activeElement).toBe($('combo'));
  });

  test('bascule mobile : aria-expanded et .lens-open, liée une seule fois', () => {
    lens.init(OPTIONS, { nation: null, type: null }, jest.fn());
    lens.init(OPTIONS, { nation: null, type: null }, jest.fn()); // nouveau rendu : pas de second écouteur
    const toggle = $('tl-lens-toggle');
    toggle.click();
    expect(toggle.getAttribute('aria-expanded')).toBe('true');
    expect($('tl-bar').classList.contains('lens-open')).toBe(true);
    toggle.click();
    expect(toggle.getAttribute('aria-expanded')).toBe('false');
    expect($('tl-bar').classList.contains('lens-open')).toBe(false);
  });

  test('init sans aucun contrôle : aucune erreur', () => {
    document.body.innerHTML = '';
    const out = lens.init(OPTIONS, { nation: 'France', type: null }, jest.fn());
    expect(out.nationLabel).toBe('France');
  });

  test('reset sans liste des types : seule la nation est vidée', () => {
    $('tl-lens-type').remove();
    const onChange = jest.fn();
    lens.init(OPTIONS, { nation: 'France', type: null }, onChange);
    $('tl-lens-reset').click();
    expect(onChange).toHaveBeenCalledWith({ nation: null, type: null, nationLabel: null, typeLabel: null });
  });

  test('reset sans liste des nations : type vidé, pas de focus', () => {
    $('tl-lens-nation').remove();
    const onChange = jest.fn();
    lens.init(OPTIONS, { nation: null, type: 'Chasseur' }, onChange);
    $('tl-lens-reset').click();
    expect($('tl-lens-type').value).toBe('');
    expect(onChange).toHaveBeenCalledWith({ nation: null, type: null, nationLabel: null, typeLabel: null });
  });

  test('announce : résumé du filtre (repli), vide sans filtre, région absente tolérée', () => {
    const live = $('tl-lens-status');
    lens.announce({ nation: 'France', type: 'Chasseur', nationLabel: 'France', typeLabel: 'Chasseur' }, 3);
    expect(live.textContent).toBe('France · Chasseur : 3 appareils');
    lens.announce({ nation: 'France', nationLabel: 'France' }, 2);
    expect(live.textContent).toBe('France : 2 appareils');
    lens.announce({ nation: null, type: null }, 9);
    expect(live.textContent).toBe('');
    live.remove();
    expect(() => lens.announce({ nation: 'France' }, 1)).not.toThrow();
  });

  test('announce : texte traduit avec ses paramètres', () => {
    I18N.t = (key, p) => `${p.lens} — ${p.n} aircraft`;
    lens.announce({ type: 'Chasseur', typeLabel: 'Fighter' }, 4);
    expect($('tl-lens-status').textContent).toBe('Fighter — 4 aircraft');
  });
});
