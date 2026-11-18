/**
 * Tests unitaires — frontend/js/timeline/{util,era,data,keyboard}.js
 * Logique de la frise : langue, traduction avec repli, dates, couleur d'ère
 * lue dans timeline.css, sélection des appareils marquants, filtres
 * « par nation » / « par type », navigation clavier.
 */
const fs = require('fs');
const path = require('path');

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
const fakeT = (key) => key;
// window === global sous jsdom : on garde la référence pour la remettre.
const I18N = { currentLang: 'fr', t: fakeT };
window.i18n = I18N;
const realAdd = window.EventTarget.prototype.addEventListener;

require('./helpers/motion-env').loadMotion();
const util = require('../js/timeline/util');
const era = require('../js/timeline/era');
const data = require('../js/timeline/data');
const keyboard = require('../js/timeline/keyboard');

function setReducedMotion(on) {
  window.matchMedia = jest.fn(() => ({ matches: on }));
}

afterEach(() => {
  window.i18n = I18N;
  window.i18n.currentLang = 'fr';
  window.i18n.t = fakeT;
  delete window.i18n.isLoaded;
  delete window.matchMedia;
  jest.useRealTimers();
  jest.restoreAllMocks();
});

/* ====================================================================== */
/* util                                                                   */
/* ====================================================================== */

describe('util', () => {
  test('t : traduction reçue, transmise avec ses paramètres', () => {
    window.i18n.t = jest.fn((key, params) => `[${key}:${params && params.n}]`);
    expect(util.t('a.b', 'repli', { n: '3' })).toBe('[a.b:3]');
    expect(window.i18n.t).toHaveBeenCalledWith('a.b', { n: '3' });
  });

  test('t : i18n renvoie la clé (langue pas chargée) → repli fourni', () => {
    expect(util.t('timeline.chapter_label', 'Chapitre')).toBe('Chapitre');
    expect(util.t('timeline.era_1950_label2', '')).toBe('');
  });

  test('t : sans repli, la clé ; valeur vide → repli', () => {
    expect(util.t('cle.seule')).toBe('cle.seule');
    window.i18n.t = () => '';
    expect(util.t('x', 'repli')).toBe('repli');
  });

  test('t : sans i18n ou sans fonction t → repli', () => {
    window.i18n = { currentLang: 'fr' };
    expect(util.t('x', 'repli')).toBe('repli');
    delete window.i18n;
    expect(util.t('x', 'repli')).toBe('repli');
  });

  test('whenI18nReady : résout aussitôt sans i18n ou langue chargée', async () => {
    window.i18n.isLoaded = true;
    await expect(util.whenI18nReady()).resolves.toBeUndefined();
    delete window.i18n;
    await expect(util.whenI18nReady()).resolves.toBeUndefined();
  });

  test('whenI18nReady : attend le chargement de la langue', async () => {
    jest.useFakeTimers();
    window.i18n.isLoaded = false;
    const done = jest.fn();
    util.whenI18nReady(1000).then(done);
    await Promise.resolve();
    jest.advanceTimersByTime(50);
    await Promise.resolve();
    expect(done).not.toHaveBeenCalled();
    window.i18n.isLoaded = true;
    jest.advanceTimersByTime(25);
    await Promise.resolve();
    await Promise.resolve();
    expect(done).toHaveBeenCalledTimes(1);
  });

  test('whenI18nReady : abandonne au bout du délai (3 s par défaut)', async () => {
    jest.useFakeTimers();
    window.i18n.isLoaded = false;
    const done = jest.fn();
    util.whenI18nReady().then(done);
    jest.advanceTimersByTime(2900);
    await Promise.resolve();
    expect(done).not.toHaveBeenCalled();
    jest.advanceTimersByTime(150);
    await Promise.resolve();
    await Promise.resolve();
    expect(done).toHaveBeenCalledTimes(1);
  });

  test('localized : langue courante, puis fr, puis champ nu, puis vide', () => {
    const ev = { title_fr: 'Titre', title_en: 'Title', body: 'Corps' };
    expect(util.localized(ev, 'title')).toBe('Titre');
    window.i18n.currentLang = 'en';
    expect(util.localized(ev, 'title')).toBe('Title');
    expect(util.localized({ title_fr: 'Seul' }, 'title')).toBe('Seul');
    expect(util.localized(ev, 'body')).toBe('Corps');
    expect(util.localized(ev, 'quote_author')).toBe('');
  });

  test('localName : variante anglaise en anglais seulement, sinon le nom', () => {
    const a = { name: 'Mirage', name_en: 'Mirage (EN)', country_name: 'France', country_name_en: 'France (EN)' };
    expect(util.localName(a)).toBe('Mirage');
    expect(util.localName(a, 'country_name')).toBe('France');
    window.i18n.currentLang = 'en';
    expect(util.localName(a)).toBe('Mirage (EN)');
    expect(util.localName(a, 'country_name')).toBe('France (EN)');
    expect(util.localName({ name: 'Seul' })).toBe('Seul');
    expect(util.localName({})).toBe('');
  });

  test('currentLang retombe sur fr sans i18n', () => {
    delete window.i18n;
    expect(util.currentLang()).toBe('fr');
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

  test('yearOf : quatre premiers chiffres, null si absent ou illisible', () => {
    expect(util.yearOf('1950-06-25')).toBe(1950);
    expect(util.yearOf(1999)).toBe(1999);
    expect(util.yearOf('')).toBeNull();
    expect(util.yearOf(null)).toBeNull();
    expect(util.yearOf('abcd-01-01')).toBeNull();
  });

  test('currentYear : année de l\'horloge', () => {
    expect(util.currentYear()).toBe(new Date().getFullYear());
  });

  test('escapeAttr neutralise guillemets et chevrons', () => {
    expect(util.escapeAttr(`a"b'<c>&`)).toBe('a&quot;b&#39;&lt;c&gt;&amp;');
    expect(util.escapeAttr(null)).toBe('');
  });

  test('prefersReducedMotion et scrollBehavior suivent la préférence', () => {
    expect(util.prefersReducedMotion()).toBe(false); // pas de matchMedia
    expect(util.scrollBehavior()).toBe('smooth');
    setReducedMotion(true);
    expect(util.prefersReducedMotion()).toBe(true);
    expect(util.scrollBehavior()).toBe('auto');
    setReducedMotion(false);
    expect(util.scrollBehavior()).toBe('smooth');
  });

  test('scrollToElement vise le haut de l\'élément moins l\'en-tête et la règle', () => {
    window.scrollTo = jest.fn();
    const el = { getBoundingClientRect: () => ({ top: 500 }) };
    util.scrollToElement(el);
    expect(util.SCROLL_OFFSET).toBe(140);
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 500 + window.pageYOffset - 140, behavior: 'smooth' });
  });

  test('scrollOffset : bas réel de la règle collée, repli sans règle', () => {
    document.body.innerHTML = '<div id="tl-bar"></div>';
    const bar = document.getElementById('tl-bar');
    bar.getBoundingClientRect = () => ({ height: 120 });
    const spy = jest.spyOn(window, 'getComputedStyle').mockReturnValue({ top: '70px' });
    expect(util.scrollOffset()).toBe(70 + 120 + 12);
    spy.mockReturnValue({ top: 'auto' });
    expect(util.scrollOffset()).toBe(util.SCROLL_OFFSET);
    spy.mockRestore();
    document.body.innerHTML = '';
    expect(util.scrollOffset()).toBe(util.SCROLL_OFFSET);
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

/* ====================================================================== */
/* era                                                                    */
/* ====================================================================== */

describe('era', () => {
  const css = fs.readFileSync(path.join(__dirname, '..', 'css', 'timeline.css'), 'utf8');

  beforeEach(() => {
    document.head.innerHTML = `<style>${css}</style>`;
    document.body.className = 'page-timeline';
    document.body.removeAttribute('style');
  });

  test('getEra : libellé, titre et récit traduits', () => {
    window.i18n.t = (key) => `T:${key}`;
    expect(era.getEra(1950)).toEqual({
      label: 'T:timeline.era_1950_label2',
      title: 'T:timeline.era_1950_title2',
      narrative: 'T:timeline.era_1950_narrative',
    });
  });

  test('getEra : langue pas chargée → textes vides, jamais la clé', () => {
    expect(era.getEra(1950)).toEqual({ label: '', title: '', narrative: '' });
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
    expect(era.eraColor(document.querySelector('.tl-chapter'))).toBe(era.FALLBACK_COLOR);
    expect(era.eraColor(null)).toBe('var(--hud-cyan)');
  });

  test('showActiveEra : libellé de la règle, teinte du body et de la barre ; clearActiveEra efface', () => {
    window.i18n.t = (key) => `T:${key}`;
    document.body.innerHTML = `
      <div id="tl-bar"><span id="tl-bar-era"></span></div>
      <section class="tl-chapter" data-decade="1990"></section>`;
    const decade = era.showActiveEra(document.querySelector('.tl-chapter'));
    expect(decade).toBe(1990);
    expect(document.getElementById('tl-bar-era').textContent).toBe('T:timeline.era_1990_label2');
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('#8f75f5');
    expect(document.getElementById('tl-bar').style.getPropertyValue('--era-color')).toBe('#8f75f5');

    era.clearActiveEra();
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('');
    expect(document.getElementById('tl-bar-era').textContent).toBe('');
    expect(document.getElementById('tl-bar').style.getPropertyValue('--era-color')).toBe('');
  });

  test('showActiveEra / clearActiveEra tolèrent une barre absente', () => {
    document.body.innerHTML = '<section class="tl-chapter" data-decade="2000"></section>';
    expect(era.showActiveEra(document.querySelector('.tl-chapter'))).toBe(2000);
    expect(() => era.clearActiveEra()).not.toThrow();
  });
});

/* ====================================================================== */
/* data                                                                   */
/* ====================================================================== */

describe('data — chargement et totaux', () => {
  const DECADES = [
    { decade: 1940, events: [], aircraft: [] },
    { decade: 1950, events: [{ id: 1 }], aircraft: [] },
    { decade: 1960, aircraft: [{ id: 2 }, { id: 3 }] },
  ];
  const WARS = [{ id: 1 }, { id: 2 }];

  test('keepNonEmpty retire les décennies sans événement ni appareil', () => {
    expect(data.keepNonEmpty(DECADES).map(d => d.decade)).toEqual([1950, 1960]);
  });

  test('countTotals additionne événements, appareils, conflits et décennies', () => {
    expect(data.countTotals(data.keepNonEmpty(DECADES), WARS)).toEqual({ events: 1, aircraft: 2, wars: 2, decades: 2 });
    expect(data.countTotals(DECADES)).toEqual({ events: 1, aircraft: 2, wars: 0, decades: 3 });
  });

  test('loadTimeline interroge /api/timeline, filtre les décennies et garde les conflits', async () => {
    global.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: DECADES, wars: WARS }) })) };
    const out = await data.loadTimeline();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/timeline');
    expect(out.decades.map(d => d.decade)).toEqual([1950, 1960]);
    expect(out.wars).toBe(WARS);
  });

  test('loadTimeline : charge utile sans tableaux → listes vides', async () => {
    global.auth = { fetchWithTimeout: () => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: 'x', wars: null }) }) };
    expect(await data.loadTimeline()).toEqual({ decades: [], wars: [] });
  });

  test('loadTimeline lève sur une réponse en erreur', async () => {
    global.auth = { fetchWithTimeout: () => Promise.resolve({ ok: false, status: 503 }) };
    await expect(data.loadTimeline()).rejects.toThrow('503');
  });
});

describe('data — appareils marquants', () => {
  const plane = (id, year, units, extra = {}) => ({ id, name: `A${id}`, year, units_built: units, ...extra });

  test('d\'abord les appareils racontés par un événement, puis les plus produits ; ordre d\'origine conservé', () => {
    const aircraft = [
      plane(1, 1950, 10), plane(2, 1951, 5000), plane(3, 1952, null),
      plane(4, 1953, 300), plane(5, 1954, 0), plane(6, 1955, 300),
    ];
    const bucket = {
      aircraft,
      events: [
        { airplane: { id: 3 } }, // pas de production : retenu par l'événement
        { airplane: { id: 3 } }, // doublon ignoré
        { airplane: { id: 99 } }, // absent de la décennie
        { title: 'sans appareil' },
      ],
    };
    const { featured, others } = data.splitAircraft(bucket, 3);
    // Choisis : 3 (événement), 2 (5000), puis 4 (300, plus ancien que 6).
    expect(featured.map(a => a.id)).toEqual([2, 3, 4]);
    expect(others.map(a => a.id)).toEqual([1, 5, 6]);
    expect(bucket.aircraft).toBe(aircraft);
    expect(aircraft.map(a => a.id)).toEqual([1, 2, 3, 4, 5, 6]);
  });

  test('plafond FEATURED_MAX par défaut ; production nulle ou absente jamais retenue', () => {
    const aircraft = Array.from({ length: 10 }, (_, i) => plane(i + 1, 1960 + i, 100 - i));
    aircraft.push(plane(11, 1969, undefined), plane(12, 1969, 0));
    const { featured, others } = data.splitAircraft({ aircraft });
    expect(data.FEATURED_MAX).toBe(8);
    expect(featured.map(a => a.id)).toEqual([1, 2, 3, 4, 5, 6, 7, 8]);
    expect(others.map(a => a.id)).toEqual([9, 10, 11, 12]);
  });

  test('les événements ne dépassent pas le plafond', () => {
    const aircraft = [plane(1, 1950, 1), plane(2, 1951, 1), plane(3, 1952, 1)];
    const events = aircraft.map(a => ({ airplane: { id: a.id } }));
    const { featured } = data.splitAircraft({ aircraft, events }, 2);
    expect(featured.map(a => a.id)).toEqual([1, 2]);
  });

  test('décennie sans appareils ni événements', () => {
    expect(data.splitAircraft({})).toEqual({ featured: [], others: [] });
  });

  test('groupByYear : groupes par année croissante, ordre interne conservé', () => {
    const list = [plane(1, 1962), plane(2, 1960), plane(3, 1962), plane(4, 1961)];
    expect(data.groupByYear(list).map(g => [g.year, g.aircraft.map(a => a.id)]))
      .toEqual([[1960, [2]], [1961, [4]], [1962, [1, 3]]]);
    expect(data.groupByYear([])).toEqual([]);
  });

  test('warsOfDecade : conflits ouverts dans la décennie, par début puis par nom', () => {
    const wars = [
      { name: 'Zeta', start_year: 1965, era_decade: 1960 },
      { name: 'Alpha', start_year: 1965, era_decade: 1960 },
      { name: 'Beta', start_year: 1962, era_decade: 1960 },
      { name: 'Corée', start_year: 1950, era_decade: 1950 },
    ];
    expect(data.warsOfDecade(wars, 1960).map(w => w.name)).toEqual(['Beta', 'Alpha', 'Zeta']);
    expect(data.warsOfDecade(wars, 1970)).toEqual([]);
    expect(wars[0].name).toBe('Zeta'); // pas de tri sur place
  });
});

describe('data — filtres par nation et par type', () => {
  const DECADES = [
    {
      decade: 1950, events: [{ id: 'e1' }],
      aircraft: [
        { id: 1, country_name: 'France', country_name_en: 'France', type_name: 'Chasseur', type_name_en: 'Fighter' },
        { id: 2, country_name: 'États-Unis', country_name_en: 'United States', type_name: 'Bombardier', type_name_en: 'Bomber' },
      ],
    },
    {
      decade: 1960, events: [],
      aircraft: [
        { id: 3, country_name: 'France', country_name_en: 'France', type_name: 'Bombardier', type_name_en: 'Bomber' },
        { id: 4, country_name: 'Allemagne', type_name: 'Chasseur' },
        { id: 5, country_name: null, type_name: null },
      ],
    },
    { decade: 1970 },
  ];
  const WARS = [
    { id: 10, aircraft_ids: [1, 2] },
    { id: 11, aircraft_ids: [2] },
    { id: 12 },
  ];

  test('isLensActive et matchesLens', () => {
    expect(data.isLensActive(null)).toBe(false);
    expect(data.isLensActive(data.EMPTY_LENS)).toBe(false);
    expect(data.isLensActive({ nation: 'France' })).toBe(true);
    expect(data.isLensActive({ type: 'Chasseur' })).toBe(true);
    const a = DECADES[0].aircraft[0];
    expect(data.matchesLens(a, null)).toBe(true);
    expect(data.matchesLens(a, { nation: 'France', type: 'Chasseur' })).toBe(true);
    expect(data.matchesLens(a, { nation: 'Allemagne' })).toBe(false);
    expect(data.matchesLens(a, { type: 'Bombardier' })).toBe(false);
  });

  test('applyLens sans filtre : données renvoyées telles quelles', () => {
    const out = data.applyLens(DECADES, WARS, data.EMPTY_LENS);
    expect(out.decades).toBe(DECADES);
    expect(out.wars).toBe(WARS);
  });

  test('applyLens : appareils filtrés, événements gardés, conflits restreints, rien de modifié', () => {
    const snapshot = JSON.stringify({ DECADES, WARS });
    const out = data.applyLens(DECADES, WARS, { nation: 'France', type: null });
    expect(out.decades.map(d => (d.aircraft || []).map(a => a.id))).toEqual([[1], [3], []]);
    expect(out.decades[0].events).toBe(DECADES[0].events);
    expect(out.decades[0]).not.toBe(DECADES[0]);
    expect(out.wars.map(w => w.id)).toEqual([10]);
    // Nombre d'appareils du conflit dans la vue filtrée.
    expect(out.wars[0].lens_count).toBeGreaterThan(0);
    expect(out.wars[0].lens_count).toBeLessThanOrEqual(WARS.find(w => w.id === 10).aircraft_ids.length);
    expect(JSON.stringify({ DECADES, WARS })).toBe(snapshot);

    const both = data.applyLens(DECADES, WARS, { nation: 'France', type: 'Bombardier' });
    expect(both.decades.map(d => d.aircraft.map(a => a.id))).toEqual([[], [3], []]);
    expect(both.wars).toEqual([]);
  });

  test('lensOptions : clés françaises, libellés de la langue, nombres, tri alphabétique', () => {
    const fr = data.lensOptions(DECADES);
    expect(fr.nations).toEqual([
      { value: 'Allemagne', label: 'Allemagne', count: 1 },
      { value: 'États-Unis', label: 'États-Unis', count: 1 },
      { value: 'France', label: 'France', count: 2 },
    ]);
    expect(fr.types).toEqual([
      { value: 'Bombardier', label: 'Bombardier', count: 2 },
      { value: 'Chasseur', label: 'Chasseur', count: 2 },
    ]);

    const en = data.lensOptions(DECADES, 'en');
    // Allemagne n'a pas de libellé anglais : repli sur la clé.
    expect(en.nations.map(o => [o.value, o.label])).toEqual([
      ['Allemagne', 'Allemagne'], ['France', 'France'], ['États-Unis', 'United States'],
    ]);
    expect(en.types.map(o => [o.value, o.label, o.count])).toEqual([
      ['Bombardier', 'Bomber', 2], ['Chasseur', 'Chasseur', 2],
    ]);
  });

  test('readLens : valeurs connues retenues, inconnues ou absentes ignorées', () => {
    const options = data.lensOptions(DECADES);
    expect(data.readLens('?nation=France&type=Chasseur', options)).toEqual({ nation: 'France', type: 'Chasseur' });
    expect(data.readLens('?nation=Atlantide&type=Chasseur', options)).toEqual({ nation: null, type: 'Chasseur' });
    expect(data.readLens('?type=Sous-marin', options)).toEqual({ nation: null, type: null });
    expect(data.readLens('', options)).toEqual({ nation: null, type: null });
    expect(data.readLens(undefined, options)).toEqual({ nation: null, type: null });
  });

  test('lensQuery : chaîne de requête sans « ? »', () => {
    expect(data.lensQuery({ nation: 'États-Unis', type: 'Chasseur' })).toBe('nation=%C3%89tats-Unis&type=Chasseur');
    expect(data.lensQuery({ nation: null, type: 'Chasseur' })).toBe('type=Chasseur');
    expect(data.lensQuery(data.EMPTY_LENS)).toBe('');
    expect(data.lensQuery(null)).toBe('');
  });

  test('hangarUrl : décennie, pays et type du filtre courant', () => {
    expect(data.hangarUrl(1960)).toBe('/hangar?decade=1960');
    expect(data.hangarUrl(1960, { nation: 'France', type: null })).toBe('/hangar?decade=1960&country=France');
    expect(data.hangarUrl(1950, { nation: 'France', type: 'Chasseur' })).toBe('/hangar?decade=1950&country=France&type=Chasseur');
    expect(data.hangarUrl(1950, { type: 'Chasseur' })).toBe('/hangar?decade=1950&type=Chasseur');
  });
});

/* ====================================================================== */
/* keyboard                                                               */
/* ====================================================================== */

describe('keyboard', () => {
  const listeners = [];

  beforeEach(() => {
    document.body.innerHTML = [1950, 1960, 1970].map(d => `<section id="ch-${d}"></section>`).join('');
    [1950, 1960, 1970].forEach((d, i) => {
      const el = document.getElementById(`ch-${d}`);
      Object.defineProperty(el, 'offsetTop', { value: i * 1000 });
      el.getBoundingClientRect = () => ({ top: i * 1000 });
    });
    window.scrollTo = jest.fn();
    jest.spyOn(window, 'addEventListener').mockImplementation((type, fn, opts) => {
      listeners.push([type, fn]);
      realAdd.call(window, type, fn, opts);
    });
  });

  afterEach(() => {
    listeners.splice(0).forEach(([type, fn]) => window.removeEventListener(type, fn));
  });

  const top = (y) => y + window.pageYOffset - util.SCROLL_OFFSET;

  function press(key, target = document.body, init = {}) {
    const e = new KeyboardEvent('keydown', { key, bubbles: true, cancelable: true, ...init });
    target.dispatchEvent(e);
    return e;
  }

  test('keyAction associe chaque touche à une action', () => {
    expect(keyboard.keyAction('ArrowDown')).toBe('next');
    expect(keyboard.keyAction(' ')).toBe('next');
    expect(keyboard.keyAction('PageDown')).toBe('next');
    expect(keyboard.keyAction('PageUp')).toBe('prev');
    expect(keyboard.keyAction('Home')).toBe('home');
    expect(keyboard.keyAction('End')).toBe('end');
    expect(keyboard.keyAction('a')).toBeNull();
    expect(keyboard.keyAction('constructor')).toBeNull();
  });

  test('isInteractive : contrôles, listes déroulantes et leurs descendants', () => {
    document.body.insertAdjacentHTML('beforeend', `
      <button id="b"><span id="in-b">x</span></button>
      <a id="l" href="#">lien</a>
      <select id="s"><option>1</option></select>
      <input id="i"><textarea id="ta"></textarea>
      <div id="ce" contenteditable="true"></div>
      <div role="combobox" id="cb"></div>
      <ul role="listbox"><li role="option" id="opt">o</li></ul>
      <p id="p">texte</p>`);
    ['b', 'in-b', 'l', 's', 'i', 'ta', 'ce', 'cb', 'opt'].forEach(id => {
      expect(keyboard.isInteractive(document.getElementById(id))).toBe(true);
    });
    expect(keyboard.isInteractive(document.getElementById('p'))).toBe(false);
    expect(keyboard.isInteractive(document.body)).toBe(false);
    expect(keyboard.isInteractive(null)).toBe(false);
    expect(keyboard.isInteractive(window)).toBe(false);
  });

  test('chapterIndexAt : dernier chapitre passé, 0 avant le premier', () => {
    const ids = [1950, 1960, 1970];
    expect(keyboard.chapterIndexAt(ids, 1500)).toBe(1);
    expect(keyboard.chapterIndexAt(ids, 5000)).toBe(2);
    expect(keyboard.chapterIndexAt(ids, -1)).toBe(0);
    expect(keyboard.chapterIndexAt([1930], 5000)).toBe(0);
  });

  test('jumpTo borne l\'index et ignore un chapitre absent', () => {
    keyboard.jumpTo([1950, 1960, 1970], 99);
    expect(window.scrollTo).toHaveBeenLastCalledWith({ top: top(2000), behavior: 'smooth' });
    keyboard.jumpTo([1950, 1960, 1970], -5);
    expect(window.scrollTo).toHaveBeenLastCalledWith({ top: top(0), behavior: 'smooth' });
    keyboard.jumpTo([1930], 0);
    expect(window.scrollTo).toHaveBeenCalledTimes(2);
  });

  test('initKeyboard : flèches, Page, Espace, Début, Fin', () => {
    keyboard.initKeyboard([{ decade: 1950 }, { decade: 1960 }, { decade: 1970 }]);
    expect(press('ArrowDown').defaultPrevented).toBe(true);
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: top(1000) }));
    press('PageUp');
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: top(0) }));
    press('End');
    expect(window.scrollTo).toHaveBeenLastCalledWith(expect.objectContaining({ top: top(2000) }));
    setReducedMotion(true);
    press('Home');
    expect(window.scrollTo).toHaveBeenLastCalledWith({ top: 0, behavior: 'auto' });
    expect(press('x').defaultPrevented).toBe(false);
  });

  test('initKeyboard : touches laissées aux contrôles (bouton, lien, liste, combobox, champ)', () => {
    keyboard.initKeyboard([{ decade: 1950 }, { decade: 1960 }]);
    document.body.insertAdjacentHTML('beforeend', `
      <button id="b">ok</button><a id="l" href="#">lien</a>
      <select id="s"><option>1</option></select>
      <div role="combobox" id="cb" tabindex="0"></div><input id="i">`);
    ['b', 'l', 's', 'cb', 'i'].forEach(id => {
      const key = id === 'b' || id === 'l' ? ' ' : 'ArrowDown';
      expect(press(key, document.getElementById(id)).defaultPrevented).toBe(false);
    });
    expect(window.scrollTo).not.toHaveBeenCalled();
  });

  test('initKeyboard : touches modifiées et événements déjà traités ignorés', () => {
    keyboard.initKeyboard([{ decade: 1950 }, { decade: 1960 }]);
    expect(press('ArrowDown', document.body, { altKey: true }).defaultPrevented).toBe(false);
    expect(press('ArrowDown', document.body, { ctrlKey: true }).defaultPrevented).toBe(false);
    expect(press('ArrowDown', document.body, { metaKey: true }).defaultPrevented).toBe(false);
    const e = new KeyboardEvent('keydown', { key: 'ArrowDown', bubbles: true, cancelable: true });
    e.preventDefault();
    document.body.dispatchEvent(e);
    expect(window.scrollTo).not.toHaveBeenCalled();
  });
});
