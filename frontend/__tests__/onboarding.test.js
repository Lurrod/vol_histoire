/**
 * Tests — frontend/js/onboarding.js : visite guidée sur l'accueil.
 * Conditions d'affichage, déclenchement différé, parcours bureau / mobile,
 * étapes sans cible retirées, navigation (boutons, flèches, Échap),
 * placement du projecteur et de la bulle, focus et mémorisation.
 */
require('../js/shared/motion');

const { trapFocus } = require('../js/utils');

const STORAGE_KEY = 'vh-onboarding-done';
let domReady = [];

function load() {
  domReady = [];
  const spy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    if (type === 'DOMContentLoaded') { domReady.push(fn); return undefined; }
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
  let mod;
  jest.isolateModules(() => { mod = require('../js/onboarding'); });
  spy.mockRestore();
  return mod;
}

function setMobile(mobile) {
  window.matchMedia = jest.fn((q) => ({
    matches: q.includes('63.99em') ? mobile : false,
    addEventListener() {}, removeEventListener() {},
  }));
}

const PAGE = `
  <header>
    <button class="hamburger" type="button">Menu</button>
    <ul class="nav-links">
      <li><a href="/hangar">Hangar</a></li>
      <li><a href="/timeline">Chronologie</a></li>
      <li><a href="/favorites">Favoris</a></li>
    </ul>
    <button id="lang-toggle" type="button">FR</button>
  </header>
  <form id="hero-search"><input type="search"></form>
  <strong id="hero-split-stat-airplanes">733</strong>
  <button id="avant" type="button">Avant</button>`;

const root = () => document.querySelector('.ob');
const title = () => document.querySelector('.ob-title').textContent;
const next = () => document.querySelector('.ob-next');

beforeEach(() => {
  jest.useFakeTimers();
  localStorage.clear();
  document.body.innerHTML = PAGE;
  window.history.replaceState(null, '', '/');
  global.trapFocus = jest.fn(trapFocus);
  global.auth = { getToken: jest.fn(() => 'jeton'), getPayload: jest.fn(() => ({ name: 'Jean Dupont' })) };
  global.i18n = { t: jest.fn((k) => k) };
  setMobile(false);
  window.requestAnimationFrame = (fn) => setTimeout(fn, 0);
  window.cancelAnimationFrame = (id) => clearTimeout(id);
  window.Element.prototype.scrollIntoView = jest.fn();
});

afterEach(() => {
  root()?.remove();
  jest.useRealTimers();
});

describe('affichage', () => {
  test('connecté, sur l’accueil, jamais vue : la visite s’ouvre après le délai', () => {
    load();
    domReady.forEach((fn) => fn());
    expect(root()).toBeNull();
    jest.advanceTimersByTime(1500);
    expect(root()).not.toBeNull();
    expect(root().getAttribute('role')).toBe('dialog');
    expect(root().getAttribute('aria-modal')).toBe('true');
  });

  test('déjà vue, hors accueil ou sans session : rien', () => {
    const { shouldShow } = load();
    localStorage.setItem(STORAGE_KEY, '1');
    expect(shouldShow()).toBe(false);
    localStorage.clear();
    window.history.replaceState(null, '', '/hangar');
    expect(shouldShow()).toBe(false);
    window.history.replaceState(null, '', '/');
    auth.getToken.mockReturnValue(null);
    expect(shouldShow()).toBe(false);
    auth.getToken.mockReturnValue('jeton');
    expect(shouldShow()).toBe(true);
  });
});

describe('parcours', () => {
  test('bureau : bienvenue, recherche, Hangar, Chronologie, Favoris ; prénom et compteur réel', () => {
    const { buildSteps } = load();
    const steps = buildSteps('Jean');
    expect(steps.map((s) => s.id)).toEqual(['welcome', 'search', 'hangar', 'timeline', 'favorites']);
    expect(steps[0].title).toBe('Bienvenue à bord, Jean.');
    expect(steps[2].text).toMatch(/^733 appareils/);
  });

  test('compteur en odomètre : la valeur vient du .sr-only, pas des bandes de chiffres', () => {
    document.getElementById('hero-split-stat-airplanes').innerHTML =
      '<span class="sr-only">733</span><span aria-hidden="true">0123456789 0123456789 0123456789</span>';
    const { buildSteps } = load();
    expect(buildSteps('').find((x) => x.id === 'hangar').text).toMatch(/^733 appareils/);
  });

  test('mobile : le menu burger et la langue remplacent les liens', () => {
    setMobile(true);
    const { buildSteps } = load();
    expect(buildSteps('').map((s) => s.id)).toEqual(['welcome', 'search', 'menu', 'lang']);
    expect(buildSteps('')[0].title).toBe('Bienvenue à bord.');
  });

  test('une cible absente retire son étape ; sans compteur, texte générique', () => {
    document.getElementById('hero-search').remove();
    document.getElementById('hero-split-stat-airplanes').remove();
    const { buildSteps } = load();
    const steps = buildSteps('');
    expect(steps.map((s) => s.id)).not.toContain('search');
    expect(steps.find((s) => s.id === 'hangar').text).toMatch(/^Tout le catalogue/);
  });

  test('traduction présente : elle remplace le texte de repli, variables comprises', () => {
    i18n.t.mockImplementation((k, v) => (k === 'onboarding.welcome_title_name' ? `Welcome, ${v.name}.` : k));
    const { buildSteps } = load();
    expect(buildSteps('Jean')[0].title).toBe('Welcome, Jean.');
  });
});

describe('variables (syntaxe du module i18n : {nom})', () => {
  test('prénom, nombre et compteur d’étapes sont remplacés, sans accolade restante', () => {
    const dict = {
      'onboarding.welcome_title_name': 'Bienvenue à bord, {name}.',
      'onboarding.hangar_text_count': '{count} appareils.',
      'onboarding.count': 'Étape {n} sur {total}',
    };
    i18n.t.mockImplementation((k, p = {}) => {
      if (!(k in dict)) return k;
      return Object.entries(p).reduce((s, [a, b]) => s.replace(new RegExp(`\{${a}\}`, 'g'), b), dict[k]);
    });
    const { createTour } = load();
    const tour = createTour();
    expect(title()).toBe('Bienvenue à bord, Jean.');
    expect(document.querySelector('.ob-count').textContent).toBe('Étape 1 sur 5');
    expect(tour.steps.find((s) => s.id === 'hangar').text).toBe('733 appareils.');
    expect(document.querySelector('.ob').textContent).not.toMatch(/[{}]/);
  });
});

describe('navigation', () => {
  test('Suivant, Précédent et flèches parcourent les étapes ; boutons adaptés', () => {
    const { createTour } = load();
    createTour();
    jest.advanceTimersByTime(20);
    expect(title()).toBe('Bienvenue à bord, Jean.');
    expect(document.querySelector('.ob-prev').hidden).toBe(true);
    expect(next().textContent).toBe('Commencer la visite');
    next().click();
    expect(title()).toBe('Cherchez un appareil');
    expect(document.querySelector('.ob-prev').hidden).toBe(false);
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowRight' }));
    expect(title()).toBe('Le Hangar');
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowLeft' }));
    expect(title()).toBe('Cherchez un appareil');
    document.querySelector('.ob-prev').click();
    document.querySelector('.ob-prev').click(); // déjà au début : sans effet
    expect(title()).toBe('Bienvenue à bord, Jean.');
    expect(document.querySelector('.ob-count').textContent).toBe('Étape 1 sur 5');
  });

  test('dernière étape : « C’est parti » ferme et mémorise ; « Passer » masqué', () => {
    const { createTour } = load();
    const tour = createTour();
    for (let i = 0; i < tour.steps.length - 1; i++) next().click();
    expect(next().textContent).toBe('C’est parti'.replace('’', "'"));
    expect(document.querySelector('.ob-skip').hidden).toBe(true);
    next().click();
    jest.advanceTimersByTime(50);
    expect(root()).toBeNull();
    expect(localStorage.getItem(STORAGE_KEY)).toBe('1');
  });

  test('« Passer » et Échap ferment ; le focus revient à l’élément d’avant', () => {
    const { createTour } = load();
    document.getElementById('avant').focus();
    createTour();
    jest.advanceTimersByTime(20);
    expect(document.activeElement).toBe(next());
    document.querySelector('.ob-skip').click();
    jest.advanceTimersByTime(50);
    expect(root()).toBeNull();
    expect(document.activeElement.id).toBe('avant');

    localStorage.clear();
    createTour();
    jest.advanceTimersByTime(20);
    document.activeElement.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
    jest.advanceTimersByTime(50);
    expect(root()).toBeNull();
  });
});

describe('placement', () => {
  test('étape sans cible : bulle centrée ; avec cible : projecteur sur la cible et bulle dessous', () => {
    const search = document.getElementById('hero-search');
    search.getBoundingClientRect = () => ({ top: 200, bottom: 248, left: 100, right: 500, width: 400, height: 48 });
    const { createTour } = load();
    createTour();
    jest.advanceTimersByTime(20);
    expect(root().classList.contains('ob-centered')).toBe(true);
    next().click();
    jest.advanceTimersByTime(20);
    expect(root().classList.contains('ob-centered')).toBe(false);
    const spot = document.querySelector('.ob-spot').style;
    expect(spot.getPropertyValue('--ob-x')).toBe('92px');
    expect(spot.getPropertyValue('--ob-y')).toBe('192px');
    expect(spot.getPropertyValue('--ob-w')).toBe('416px');
    expect(document.querySelector('.ob-card').style.getPropertyValue('--ob-y')).toBe('270px');
  });

  test('cible hors de l’écran : ramenée au centre ; pas de place dessous : bulle au-dessus', () => {
    const search = document.getElementById('hero-search');
    search.getBoundingClientRect = () => ({ top: window.innerHeight - 40, bottom: window.innerHeight + 10, left: 0, right: 100, width: 100, height: 50 });
    const { createTour } = load();
    const card = () => document.querySelector('.ob-card');
    createTour();
    Object.defineProperty(card(), 'offsetHeight', { configurable: true, value: 200 });
    next().click();
    jest.advanceTimersByTime(20);
    expect(search.scrollIntoView).toHaveBeenCalled();
    const top = parseInt(card().style.getPropertyValue('--ob-y'), 10);
    expect(top).toBeLessThan(window.innerHeight - 40);
  });

  test('redimensionnement : la position est recalculée', () => {
    const { createTour } = load();
    createTour();
    jest.advanceTimersByTime(20);
    const card = document.querySelector('.ob-card');
    card.style.removeProperty('--ob-y');
    window.dispatchEvent(new Event('resize'));
    jest.advanceTimersByTime(20);
    expect(card.style.getPropertyValue('--ob-y')).not.toBe('');
  });
});
