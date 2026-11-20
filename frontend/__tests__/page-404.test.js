/**
 * Tests — page 404 :
 *   - js/404-sky.js (l'avion écrit « 404 », rejouable au clic) ;
 *   - js/404-board.js (tableau des départs : vol annulé + quatre vols réels).
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const mainOf = (file) => /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(ROOT, file), 'utf8'))[0];
const $ = (id) => document.getElementById(id);

/** Charge un script de page et déclenche son DOMContentLoaded. */
function load(file) {
  const ready = [];
  jest.spyOn(document, 'addEventListener').mockImplementation((type, fn) => { if (type === 'DOMContentLoaded') ready.push(fn); });
  let mod;
  jest.isolateModules(() => { mod = require(`../js/${file}`); });
  document.addEventListener.mockRestore();
  return { mod, ready: () => Promise.all(ready.map((fn) => fn())) };
}

function setMotion(reduced) {
  window.VH = window.VH || {};
  window.VH.motion = { prefersReducedMotion: () => reduced };
}

beforeEach(() => {
  document.body.innerHTML = mainOf('404.html');
  window.history.replaceState(null, '', '/hangar/rafal');
  window.VH = {};
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
  delete window.i18n;
  delete window.Sentry;
  delete global.fetch;
});

// =============================================================================
// 404-sky.js
// =============================================================================
describe('404-sky.js', () => {
  const proto = window.SVGElement.prototype;

  beforeAll(() => {
    // jsdom ne mesure pas les tracés SVG : une longueur fixe suffit.
    proto.getTotalLength = function () { return 100; };
    proto.getPointAtLength = function (d) { return { x: d, y: d / 2 }; };
  });
  afterAll(() => {
    delete proto.getTotalLength;
    delete proto.getPointAtLength;
  });

  test('vol complet : l’avion décolle, trace, puis l’inscription reste', async () => {
    jest.useFakeTimers();
    setMotion(false);
    const { ready } = load('404-sky');
    await ready();
    const sky = $('e4-sky');
    jest.advanceTimersByTime(400);
    expect(sky.classList.contains('is-flying')).toBe(true);
    expect($('e4-plane').getAttribute('transform')).toMatch(/^translate\(/);
    jest.advanceTimersByTime(5000);
    expect(sky.classList.contains('is-flying')).toBe(false);
    expect(sky.classList.contains('is-done')).toBe(true);
    const trails = sky.querySelectorAll('.e4-trail');
    trails.forEach((p) => expect(p.style.strokeDashoffset).toBe('0'));
  });

  test('un clic rejoue le vol', async () => {
    jest.useFakeTimers();
    setMotion(false);
    const { ready } = load('404-sky');
    await ready();
    jest.advanceTimersByTime(6000);
    $('e4-sky').click();
    expect($('e4-sky').classList.contains('is-done')).toBe(false);
    expect($('e4-sky').classList.contains('is-flying')).toBe(true);
  });

  test('mouvements réduits : inscription posée sans avion', async () => {
    jest.useFakeTimers();
    setMotion(true);
    const { ready } = load('404-sky');
    await ready();
    jest.advanceTimersByTime(400);
    expect($('e4-sky').classList.contains('is-done')).toBe(true);
    expect($('e4-sky').classList.contains('is-flying')).toBe(false);
  });

  test('page sans ciel : rien ne casse', async () => {
    document.body.innerHTML = '<main></main>';
    const { ready } = load('404-sky');
    await expect(ready()).resolves.toBeDefined();
  });
});

// =============================================================================
// 404-board.js
// =============================================================================
describe('404-board.js', () => {
  const PLANES = [
    { id: 30, name: 'Rafale', country_code: 'FRA' },
    { id: 3, name: 'Tu-160', country_code: 'RUS' },
    { id: 12, name: 'F-22 Raptor', country_code: 'USA' },
    { id: 7, name: 'Gripen', country_code: null },
    { id: 8, name: 'Nom bien trop long pour le tableau' },
  ];

  function mockApi({ fail = false, data = PLANES } = {}) {
    global.fetch = jest.fn(async (url) => {
      if (fail) return { ok: false, status: 500, json: async () => ({}) };
      const limit = /limit=(\d+)/.exec(url)[1];
      return { ok: true, json: async () => (limit === '1' ? { total: 733, data: [data[0]] } : { total: 733, data }) };
    });
  }

  function setup404() {
    window.VH.shared = { buildDetailsPath: (id, name) => `/details/${name.toLowerCase().replace(/\W+/g, '-')}-${id}` };
    load('404'); // VH.e404 (adresse manquante)
  }

  const rows = () => [...document.querySelectorAll('.e4-fids-row')];
  const text = (row, cls) => [...row.querySelectorAll(`.${cls} .e4-flap`)].map((c) => c.textContent).join('').replace(/\u00a0/g, ' ').trimEnd();

  test('helpers : heures de 5 en 5, champs à largeur fixe', () => {
    const { mod } = load('404-board');
    expect(mod.departureTimes(new Date(2026, 10, 20, 10, 42, 31), [5, 15, 25, 40])).toEqual(['10:50', '11:00', '11:10', '11:25']);
    expect(mod.departureTimes(new Date(2026, 10, 20, 23, 55), [5])).toEqual(['00:00']);
    expect(mod.fit('rafale', 8)).toBe('RAFALE  ');
    expect(mod.fit('abcdefghijklmno', 5)).toBe('ABCDE');
    expect(mod.fit(null, 2)).toBe('  ');
  });

  test('t() : traduction si présente, sinon repli français avec paramètres', () => {
    const { mod } = load('404-board');
    expect(mod.t('x', 'Vol {flight} {inconnu}', { flight: 'VH1' })).toBe('Vol VH1 {inconnu}');
    window.i18n = { t: (k, p) => (k === 'error404.board_title' ? `Departures ${p.n || ''}`.trim() : k) };
    expect(mod.t('board_title', 'Départs')).toBe('Departures');
    expect(mod.t('absent', 'Repli')).toBe('Repli');
  });

  test('lostName : mots de l’adresse en capitales, « PAGE 404 » sinon', () => {
    setup404();
    const { mod } = load('404-board');
    expect(mod.lostName('/hangar/rafal')).toBe('RAFAL');
    expect(mod.lostName('/404')).toBe('PAGE 404');
    delete window.VH.e404;
    expect(mod.lostName('/hangar/rafal')).toBe('PAGE 404');
  });

  test('tableau complet (mouvements réduits) : vol annulé puis quatre vols vers des fiches', async () => {
    setMotion(true);
    mockApi();
    setup404();
    const { mod } = load('404-board');
    await mod.setup();

    const r = rows();
    expect(r).toHaveLength(5);
    expect(r[0].hasAttribute('href')).toBe(false);
    expect(r[0].classList.contains('is-cancelled')).toBe(true);
    expect(text(r[0], 'is-dest')).toBe('RAFAL');
    expect(text(r[0], 'is-flight')).toBe('VH404');
    expect(text(r[0], 'is-status')).toBe('ANNULÉ');
    expect(r[0].querySelector('.sr-only').textContent).toBe('Vol VH404 à destination de rafal : annulé, cette page n’existe pas.');

    const flights = r.slice(1);
    flights.forEach((row) => expect(row.getAttribute('href')).toMatch(/^\/details\//));
    // Le nom trop long pour 12 palettes n'est jamais tiré.
    expect(flights.map((row) => text(row, 'is-dest'))).not.toContain('NOM BIEN TROP LONG');
    expect(text(flights[0], 'is-status')).toBe('EMBARQUEMENT');
    expect(flights[0].classList.contains('is-boarding')).toBe(true);
    expect(text(flights[3], 'is-status')).toBe('RETARDÉ');
    const rafale = flights.find((row) => text(row, 'is-dest') === 'RAFALE');
    expect(rafale.querySelector('.sr-only').textContent).toMatch(/^Vol VH030 à destination de Rafale, départ \d\d:\d\d, porte FRA, /);
    const gripen = flights.find((row) => text(row, 'is-dest') === 'GRIPEN');
    expect(gripen.querySelector('.sr-only').textContent).not.toMatch(/porte/);
    r.forEach((row) => expect(row.classList.contains('is-settled')).toBe(true));
    expect($('e4-fids-clock').textContent).toMatch(/^\d\d:\d\d$/);
  });

  test('palettes animées : elles tournent puis s’arrêtent sur le bon texte', async () => {
    jest.useFakeTimers();
    setMotion(false);
    mockApi();
    setup404();
    const animate = jest.fn();
    window.HTMLElement.prototype.animate = animate;
    const { mod } = load('404-board');
    const done = mod.setup();
    await jest.advanceTimersByTimeAsync(800);
    expect(animate).toHaveBeenCalled();
    await jest.advanceTimersByTimeAsync(6000);
    await done;
    expect(text(rows()[0], 'is-status')).toBe('ANNULÉ');
    expect(rows()[1].classList.contains('is-settled')).toBe(true);
    delete window.HTMLElement.prototype.animate;
  });

  test('horloge : seules les palettes qui changent tournent', async () => {
    jest.useFakeTimers();
    jest.setSystemTime(new Date(2026, 10, 20, 10, 59, 58));
    setMotion(true);
    mockApi();
    setup404();
    const { mod } = load('404-board');
    const done = mod.setup();
    await jest.advanceTimersByTimeAsync(10);
    await done;
    expect($('e4-fids-clock').textContent).toBe('10:59');
    await jest.advanceTimersByTimeAsync(3000);
    expect($('e4-fids-clock').textContent).toBe('11:00');
  });

  test('catalogue indisponible : vols de repli vers les rubriques, erreur signalée', async () => {
    setMotion(true);
    mockApi({ fail: true });
    window.Sentry = { captureException: jest.fn() };
    setup404();
    const { mod } = load('404-board');
    await mod.setup();
    const flights = rows().slice(1);
    expect(flights.map((row) => row.getAttribute('href'))).toEqual(['/hangar', '/timeline', '/conflits', '/']);
    expect(text(flights[1], 'is-dest')).toBe('CHRONOLOGIE');
    expect(window.Sentry.captureException).toHaveBeenCalled();
  });

  test('trop peu d’appareils qui tiennent : repli aussi', async () => {
    setMotion(true);
    mockApi({ data: PLANES.slice(0, 2) });
    setup404();
    const { mod } = load('404-board');
    await mod.setup();
    expect(rows()[1].getAttribute('href')).toBe('/hangar');
  });

  test('langue en cours de chargement : le tableau attend i18nReady puis s’écrit traduit', async () => {
    jest.useFakeTimers();
    setMotion(true);
    mockApi();
    setup404();
    const EN = { 'error404.status_cancelled': 'CANCELLED', 'error404.status_boarding': 'BOARDING' };
    window.i18n = { isLoaded: false, t: (k) => EN[k] || k };
    const { mod } = load('404-board');
    const done = mod.setup();
    await jest.advanceTimersByTimeAsync(100);
    expect(text(rows()[0], 'is-status')).toBe('');
    window.dispatchEvent(new window.CustomEvent('i18nReady'));
    await jest.advanceTimersByTimeAsync(10);
    await done;
    expect(text(rows()[0], 'is-status')).toBe('CANCELLED');
    expect(text(rows()[1], 'is-status')).toBe('BOARDING');
  });

  test('page sans tableau : rien ne se passe', async () => {
    document.body.innerHTML = '<main></main>';
    global.fetch = jest.fn();
    const { mod } = load('404-board');
    await mod.setup();
    expect(global.fetch).not.toHaveBeenCalled();
  });
});
