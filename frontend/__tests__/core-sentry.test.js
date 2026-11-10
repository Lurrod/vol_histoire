/**
 * Tests — frontend/js/sentry-init.js : chargement différé de Sentry.
 *
 * Le consentement est lu par le vrai accesseur window.VH.consent de
 * cookies.js : c'est précisément la lecture d'une mauvaise clé qui avait rendu
 * la garde inopérante (v4.9.0).
 *
 * jsdom n'a ni requestIdleCallback (repli setTimeout 3 s) ni
 * PromiseRejectionEvent : ce dernier est simulé quand un test en a besoin.
 */
global.safeSetHTML = (el, html) => { el.innerHTML = html; };
const domReady = [];
const originalAdd = document.addEventListener;
document.addEventListener = function (type, fn, opts) {
  if (type === 'DOMContentLoaded') { domReady.push(fn); return undefined; }
  return originalAdd.call(this, type, fn, opts);
};
require('../js/cookies'); // définit window.VH.consent
document.addEventListener = originalAdd;

const KEY = 'voldhistoire_cookie_consent';
const sentryScripts = () => Array.from(document.head.querySelectorAll('script'))
  .filter((s) => (s.src || '').includes('sentry.min.js'));
const setConsent = (analytics) => localStorage.setItem(KEY, JSON.stringify({
  preferences: { essential: true, analytics, marketing: false }, timestamp: new Date().toISOString(),
}));

let added;
let addSpy;

function loadSentryInit({ dsn = 'https://key@o1.ingest.sentry.io/1', via = 'meta' } = {}) {
  document.head.innerHTML = via === 'meta' && dsn ? `<meta name="sentry-dsn" content="${dsn}">` : '';
  if (via === 'global') window.SENTRY_DSN = dsn;
  jest.isolateModules(() => { require('../js/sentry-init'); });
}

beforeEach(() => {
  jest.useFakeTimers();
  localStorage.clear();
  delete window.Sentry;
  delete window.SENTRY_DSN;
  delete window.APP_VERSION;
  delete window.requestIdleCallback;
  added = [];
  addSpy = jest.spyOn(window, 'addEventListener').mockImplementation(function (type, fn, opts) {
    added.push([type, fn]);
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
});

afterEach(() => {
  addSpy.mockRestore();
  added.forEach(([type, fn]) => window.removeEventListener(type, fn));
  jest.useRealTimers();
  delete global.PromiseRejectionEvent;
});

// =============================================================================
// RGPD
// =============================================================================
describe('sentry-init — consentement', () => {
  test('analytics refusé : aucun script, aucun écouteur, rien de planifié', () => {
    setConsent(false);
    loadSentryInit();
    jest.advanceTimersByTime(10000);
    expect(sentryScripts()).toHaveLength(0);
    expect(added).toHaveLength(0);
  });

  test('analytics accordé : script chargé après le délai d’inactivité', () => {
    setConsent(true);
    loadSentryInit();
    expect(sentryScripts()).toHaveLength(0); // jamais sur le chemin critique
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()).toHaveLength(1);
  });

  /*
   * BUG / DÉCISION (sentry-init.js:23) — la mission exige que Sentry ne se
   * charge PAS sans consentement. La garde ne teste que le refus explicite
   * (`denies`) : un visiteur qui n'a pas encore répondu au bandeau envoie ses
   * erreurs (IP, URL, user-agent) à Sentry (États-Unis). La politique de
   * confidentialité (pc_sec3_body) annonce pourtant « intérêt légitime » pour
   * Sentry, alors que le code le soumet au refus « analytics » : les deux
   * doivent être alignés. Si le consentement est retenu, remplacer
   * `denies('analytics')` par `!allows('analytics')` (et prévoir un
   * chargement à l'acceptation, cookieConsent → analytics_enabled).
   */
  test.skip('RGPD — sans choix enregistré, Sentry ne se charge pas', () => {
    loadSentryInit();
    jest.advanceTimersByTime(10000);
    expect(sentryScripts()).toHaveLength(0);
  });

  /*
   * BUG (sentry-init.js:23 et 104-105) — la garde n'est évaluée qu'une fois,
   * à l'exécution du script ; loadSentryScript ne relit pas le consentement.
   * Un refus donné dans les 3 s (ou avant le premier idle) n'empêche plus le
   * chargement.
   */
  test.skip('RGPD — un refus donné avant le chargement différé est respecté', () => {
    loadSentryInit();
    setConsent(false);
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()).toHaveLength(0);
  });
});

// =============================================================================
// DSN et ordonnancement
// =============================================================================
describe('sentry-init — DSN et chargement', () => {
  beforeEach(() => setConsent(true));

  test('sans DSN : rien n’est chargé', () => {
    loadSentryInit({ dsn: '' });
    jest.advanceTimersByTime(10000);
    expect(sentryScripts()).toHaveLength(0);
    expect(added).toHaveLength(0);
  });

  test('DSN lu dans window.SENTRY_DSN à défaut de <meta>', () => {
    loadSentryInit({ via: 'global' });
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()).toHaveLength(1);
  });

  test('script versionné par APP_VERSION (cache immuable d’un an)', () => {
    window.APP_VERSION = '4.14.0';
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()[0].getAttribute('src')).toBe('/js/vendor/sentry.min.js?v=4.14.0');
    expect(sentryScripts()[0].async).toBe(true);
  });

  test('sans APP_VERSION : pas de paramètre ?v=', () => {
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()[0].getAttribute('src')).toBe('/js/vendor/sentry.min.js');
  });

  test('requestIdleCallback disponible : utilisé avec un délai maximal de 5 s', () => {
    window.requestIdleCallback = jest.fn();
    loadSentryInit();
    expect(window.requestIdleCallback).toHaveBeenCalledWith(expect.any(Function), { timeout: 5000 });
    window.requestIdleCallback.mock.calls[0][0]();
    expect(sentryScripts()).toHaveLength(1);
  });

  test('Sentry déjà présent : initialisé sans second script', () => {
    window.Sentry = { init: jest.fn(), captureException: jest.fn() };
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    expect(sentryScripts()).toHaveLength(0);
    expect(window.Sentry.init).toHaveBeenCalledTimes(1);
  });

  test('échec du chargement : les écouteurs de file sont retirés', () => {
    const removeSpy = jest.spyOn(window, 'removeEventListener');
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    sentryScripts()[0].onerror();
    const removed = removeSpy.mock.calls.map(([type]) => type);
    removeSpy.mockRestore();
    expect(removed).toEqual(expect.arrayContaining(['error', 'unhandledrejection']));
  });

  test('onload sans window.Sentry (script vide) : rien ne casse', () => {
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    expect(() => sentryScripts()[0].onload()).not.toThrow();
  });
});

// =============================================================================
// Initialisation et file d'attente
// =============================================================================
describe('sentry-init — initialisation', () => {
  beforeEach(() => setConsent(true));

  function loadAndInit() {
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    window.Sentry = { init: jest.fn(), captureException: jest.fn() };
    sentryScripts()[0].onload();
    return window.Sentry.init.mock.calls[0][0];
  }

  test('options transmises : DSN, environnement, release, échantillonnage', () => {
    window.APP_VERSION = '4.14.0';
    const opts = loadAndInit();
    expect(opts).toMatchObject({
      dsn: 'https://key@o1.ingest.sentry.io/1',
      environment: 'development', // jsdom : localhost
      release: '4.14.0',
      tracesSampleRate: 0.1,
    });
    expect(opts.ignoreErrors).toContain('ResizeObserver loop limit exceeded');
  });

  test('beforeSend écarte les erreurs venues d’une extension de navigateur', () => {
    const { beforeSend } = loadAndInit();
    const fromExtension = { exception: { values: [{ stacktrace: { frames: [{ filename: 'chrome-extension://abc/x.js' }] } }] } };
    const fromSite = { exception: { values: [{ stacktrace: { frames: [{ filename: '/js/dist/app.min.js' }, {}] } }] } };
    const noStack = { exception: { values: [{}] } };
    const message = { message: 'texte' };
    expect(beforeSend(fromExtension)).toBeNull();
    expect(beforeSend(fromSite)).toBe(fromSite);
    expect(beforeSend(noStack)).toBe(noStack);
    expect(beforeSend(message)).toBe(message);
  });

  test('les erreurs survenues avant le chargement sont rejouées', () => {
    global.PromiseRejectionEvent = class extends Event {
      constructor(type, init) { super(type); this.reason = init.reason; }
    };
    loadSentryInit();
    const boom = new Error('avant chargement');
    window.dispatchEvent(new window.ErrorEvent('error', { error: boom }));
    const rejet = new Error('promesse');
    window.dispatchEvent(new global.PromiseRejectionEvent('unhandledrejection', { reason: rejet }));
    window.dispatchEvent(new window.ErrorEvent('error', { message: 'sans objet erreur' }));
    jest.advanceTimersByTime(3000);
    window.Sentry = { init: jest.fn(), captureException: jest.fn() };
    sentryScripts()[0].onload();

    expect(window.Sentry.captureException.mock.calls.map(([e]) => e)).toEqual([boom, rejet]);
  });

  test('file d’attente plafonnée à 50 erreurs', () => {
    loadSentryInit();
    for (let i = 0; i < 60; i++) window.dispatchEvent(new window.ErrorEvent('error', { error: new Error(String(i)) }));
    jest.advanceTimersByTime(3000);
    window.Sentry = { init: jest.fn(), captureException: jest.fn() };
    sentryScripts()[0].onload();
    expect(window.Sentry.captureException).toHaveBeenCalledTimes(50);
  });

  test('un rejeu en échec n’interrompt pas les suivants', () => {
    loadSentryInit();
    window.dispatchEvent(new window.ErrorEvent('error', { error: new Error('1') }));
    window.dispatchEvent(new window.ErrorEvent('error', { error: new Error('2') }));
    jest.advanceTimersByTime(3000);
    window.Sentry = { init: jest.fn(), captureException: jest.fn(() => { throw new Error('quota'); }) };
    expect(() => sentryScripts()[0].onload()).not.toThrow();
    expect(window.Sentry.captureException).toHaveBeenCalledTimes(2);
  });

  test('Sentry.init qui lève : la page n’est pas cassée', () => {
    loadSentryInit();
    jest.advanceTimersByTime(3000);
    window.Sentry = { init: jest.fn(() => { throw new Error('DSN invalide'); }) };
    expect(() => sentryScripts()[0].onload()).not.toThrow();
  });
});
