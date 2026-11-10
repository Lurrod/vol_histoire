/**
 * Tests — frontend/js/onboarding.js : conditions d'affichage du briefing,
 * déclenchement différé, textes de repli et navigation entre étapes.
 * (Icône et focus sont couverts par onboarding.test.js.)
 */
const { escapeHtml } = require('../js/utils');

const STORAGE_KEY = 'vh-onboarding-done';
let domReady = [];

function loadOnboarding() {
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

const overlay = () => document.querySelector('.ob');
const title = () => document.querySelector('.ob-title').textContent;
const counter = () => document.querySelector('.ob-counter').textContent;
const click = (sel) => { document.querySelector(sel).click(); jest.advanceTimersByTime(700); };
const key = (k) => { document.dispatchEvent(new KeyboardEvent('keydown', { key: k })); jest.advanceTimersByTime(700); };

let keyListeners = [];
let docSpy;

beforeEach(() => {
  jest.useFakeTimers();
  localStorage.clear();
  document.body.innerHTML = '';
  window.history.replaceState(null, '', '/');
  global.escapeHtml = escapeHtml;
  delete global.trapFocus;
  delete global.i18n;
  delete window.matchMedia;
  global.auth = { getToken: jest.fn(() => 'jeton'), getPayload: jest.fn(() => ({ name: 'Ada' })) };
  keyListeners = [];
  docSpy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    if (type === 'keydown') keyListeners.push(fn);
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
});

afterEach(() => {
  docSpy.mockRestore();
  keyListeners.forEach((fn) => document.removeEventListener('keydown', fn));
  jest.useRealTimers();
  delete global.auth;
});

describe('shouldShow — à qui montrer le briefing', () => {
  test('utilisateur connecté, sur l’accueil, jamais briefé : oui', () => {
    expect(loadOnboarding().shouldShow()).toBe(true);
  });

  test('déjà vu : non', () => {
    localStorage.setItem(STORAGE_KEY, '1');
    expect(loadOnboarding().shouldShow()).toBe(false);
  });

  test('hors de l’accueil : non', () => {
    window.history.replaceState(null, '', '/hangar');
    expect(loadOnboarding().shouldShow()).toBe(false);
  });

  test('visiteur anonyme : non', () => {
    auth.getToken.mockReturnValue(null);
    expect(loadOnboarding().shouldShow()).toBe(false);
  });

  test('auth absent ou incomplet : non', () => {
    const { shouldShow } = loadOnboarding();
    global.auth = {};
    expect(shouldShow()).toBe(false);
    delete global.auth;
    expect(shouldShow()).toBe(false);
  });
});

describe('déclenchement au chargement', () => {
  test('ouvert 2 s après DOMContentLoaded si les conditions sont réunies', () => {
    loadOnboarding();
    domReady.forEach((fn) => fn());
    jest.advanceTimersByTime(1999);
    expect(overlay()).toBeNull();
    jest.advanceTimersByTime(1);
    expect(overlay()).not.toBeNull();
    expect(overlay().getAttribute('role')).toBe('dialog');
    expect(overlay().getAttribute('aria-modal')).toBe('true');
  });

  test('pas ouvert pour un briefing déjà vu', () => {
    localStorage.setItem(STORAGE_KEY, '1');
    loadOnboarding();
    domReady.forEach((fn) => fn());
    jest.advanceTimersByTime(3000);
    expect(overlay()).toBeNull();
  });
});

describe('textes et navigation', () => {
  test('sans i18n : textes français de repli, prénom dans le titre', () => {
    loadOnboarding().createTour();
    jest.advanceTimersByTime(20);
    expect(title()).toBe('Bienvenue à bord, Ada.');
    expect(overlay().getAttribute('aria-label')).toBe('Briefing de bienvenue');
    expect(document.querySelector('.ob-skip').textContent).toBe('Passer le briefing');
  });

  test('payload illisible : titre sans prénom, pas d’exception', () => {
    auth.getPayload.mockImplementation(() => { throw new Error('jeton corrompu'); });
    loadOnboarding().createTour();
    jest.advanceTimersByTime(20);
    expect(title()).toBe('Bienvenue à bord.');
  });

  test('Suivant / Précédent / flèches : compteur et barre de progression suivent', () => {
    loadOnboarding().createTour();
    jest.advanceTimersByTime(20);
    expect(counter()).toBe('1 / 4');
    key('ArrowLeft'); // déjà à la première étape
    expect(counter()).toBe('1 / 4');
    click('.ob-next');
    expect(counter()).toBe('2 / 4');
    expect(document.querySelectorAll('.ob-bar.done')).toHaveLength(1);
    expect(document.querySelector('.ob-skip')).toBeNull();
    click('.ob-prev');
    expect(counter()).toBe('1 / 4');
    key('ArrowRight');
    key('ArrowRight');
    key('ArrowRight');
    expect(counter()).toBe('4 / 4');
    expect(document.querySelector('.ob-next')).toBeNull();
    key('ArrowRight'); // déjà à la dernière
    expect(counter()).toBe('4 / 4');
    key('a'); // touche sans effet
    expect(counter()).toBe('4 / 4');
  });

  test('« Commencer » à la dernière étape ferme et mémorise', () => {
    loadOnboarding().createTour();
    jest.advanceTimersByTime(500); // fin de l'animation d'entrée
    for (let i = 0; i < 3; i++) click('.ob-next');
    click('.ob-finish');
    expect(localStorage.getItem(STORAGE_KEY)).toBe('1');
    expect(overlay()).toBeNull();
  });

  test('« Passer » ferme dès la première étape', () => {
    loadOnboarding().createTour();
    jest.advanceTimersByTime(20);
    document.querySelector('.ob-skip').click();
    expect(overlay().classList.contains('ob-exit')).toBe(true);
    jest.advanceTimersByTime(600);
    expect(overlay()).toBeNull();
    expect(localStorage.getItem(STORAGE_KEY)).toBe('1');
  });

  test('mouvements réduits : étapes et fermeture sans délai d’animation', () => {
    window.matchMedia = jest.fn(() => ({ matches: true }));
    loadOnboarding().createTour();
    jest.advanceTimersByTime(1);
    document.querySelector('.ob-next').click();
    jest.advanceTimersByTime(1);
    expect(counter()).toBe('2 / 4');
    document.querySelector('.ob-prev').click();
    jest.advanceTimersByTime(1);
    document.querySelector('.ob-skip').click();
    jest.advanceTimersByTime(1);
    expect(overlay()).toBeNull();
  });

  test('l’élément d’origine retiré entre-temps : la fermeture ne tente pas de le focaliser', () => {
    document.body.innerHTML = '<button id="avant">x</button>';
    const avant = document.getElementById('avant');
    avant.focus();
    const tour = loadOnboarding().createTour();
    jest.advanceTimersByTime(20);
    avant.remove();
    const focus = jest.spyOn(avant, 'focus');
    tour.close();
    expect(focus).not.toHaveBeenCalled();
  });
});
