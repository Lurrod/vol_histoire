/**
 * @jest-environment jsdom
 * @jest-environment-options {"url": "https://vol-histoire.titouan-borde.com/hangar"}
 */
/**
 * Tests — durée de vie et retrait du consentement (js/cookies.js, js/gtm.js).
 *
 * LEGAL-004 : le choix est daté et ne vaut que 6 mois (180 jours) ; au-delà,
 *   il est effacé et le bandeau revient.
 * LEGAL-005 : refuser ou retirer la mesure d'audience coupe Google Analytics
 *   (drapeau ga-disable-<ID>), efface les cookies _ga sur l'hôte ET sur le
 *   domaine parent (.titouan-borde.com), et recharge la page si GTM y tournait.
 * CSP strict-dynamic : le <script> GTM porte le nonce de gtm.js.
 *
 * L'URL de test est celle de la production : jsdom applique alors les vraies
 * règles de domaine des cookies (un cookie posé sur .titouan-borde.com n'est
 * effaçable qu'avec ce même attribut domain).
 */
global.safeSetHTML = (el, html) => { el.innerHTML = html; };

const {
  CookieConsent, isConsentExpired, readConsentRecord, cookieDomainCandidates,
  analyticsMeasurementIds, CONSENT_MAX_AGE_DAYS,
} = require('../js/cookies');

const KEY = 'voldhistoire_cookie_consent';
const DAY = 24 * 60 * 60 * 1000;
const daysAgo = (n) => new Date(Date.now() - n * DAY).toISOString();
const store = (preferences, timestamp) => localStorage.setItem(KEY, JSON.stringify({ preferences, timestamp, version: '2' }));
const cookieNames = () => document.cookie.split(';').map((c) => c.split('=')[0].trim()).filter(Boolean);

function clearAllCookies() {
  cookieNames().forEach((name) => {
    ['', '; domain=.titouan-borde.com', '; domain=.vol-histoire.titouan-borde.com'].forEach((d) => {
      document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/${d}`;
    });
  });
}

beforeEach(() => {
  localStorage.clear();
  clearAllCookies();
  document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div><div id="toast-container"></div>';
  delete window.__isGTMLoaded;
  delete window.__VH_GA_IDS;
  Object.keys(window).filter((k) => k.startsWith('ga-disable-')).forEach((k) => { delete window[k]; });
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
});

describe('LEGAL-004 — conservation du choix limitée à 6 mois', () => {
  test('durée : 180 jours', () => {
    expect(CONSENT_MAX_AGE_DAYS).toBe(180);
  });

  test('isConsentExpired : 179 j valide, 181 j expiré, date illisible expirée', () => {
    expect(isConsentExpired(daysAgo(179))).toBe(false);
    expect(isConsentExpired(daysAgo(181))).toBe(true);
    expect(isConsentExpired('x')).toBe(true);
    expect(isConsentExpired(undefined)).toBe(true);
  });

  test('choix expiré : effacé du stockage, absent pour VH.consent, bandeau réaffiché', () => {
    jest.useFakeTimers();
    store({ essential: true, analytics: false, marketing: false }, daysAgo(200));
    document.cookie = `${KEY}=true; path=/`;
    expect(window.VH.consent.get()).toBeNull();
    expect(localStorage.getItem(KEY)).toBeNull();
    expect(cookieNames()).not.toContain(KEY);

    store({ essential: true, analytics: false, marketing: false }, daysAgo(200));
    const cc = new CookieConsent();
    expect(cc.getConsent()).toBeNull();
    jest.advanceTimersByTime(250);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(true);
  });

  test('choix récent : conservé, bandeau non réaffiché', () => {
    jest.useFakeTimers();
    store({ essential: true, analytics: false, marketing: false }, daysAgo(10));
    const cc = new CookieConsent();
    expect(cc.getConsent()).toEqual({ essential: true, analytics: false, marketing: false });
    jest.advanceTimersByTime(250);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(false);
  });

  test('ancien format (catégorie « préférence ») : relu sans la catégorie retirée', () => {
    store({ essential: true, analytics: true, preference: true, marketing: false }, daysAgo(1));
    expect(readConsentRecord().preferences).toEqual({ essential: true, analytics: true, marketing: false });
    expect(window.VH.consent.allows('preference')).toBe(false);
  });

  test('VH.consent.save : enregistrement daté, relu par record()', () => {
    const written = window.VH.consent.save({ analytics: true });
    expect(written.preferences).toEqual({ essential: true, analytics: true, marketing: false });
    const record = window.VH.consent.record();
    expect(record.timestamp).toBe(written.timestamp);
    expect(window.VH.consent.allows('analytics')).toBe(true);
    expect(window.VH.consent.MAX_AGE_DAYS).toBe(180);
  });
});

describe('LEGAL-005 — retrait effectif de la mesure d\'audience', () => {
  test('domaines candidats : hôte, puis chaque parent (jamais le TLD seul)', () => {
    expect(cookieDomainCandidates('vol-histoire.titouan-borde.com'))
      .toEqual(['', '.vol-histoire.titouan-borde.com', '.titouan-borde.com']);
    expect(cookieDomainCandidates('localhost')).toEqual(['']);
    expect(cookieDomainCandidates('127.0.0.1')).toEqual(['']);
  });

  test('identifiants de mesure : ceux de gtm.js + ceux révélés par les cookies _ga_<ID>', () => {
    window.__VH_GA_IDS = ['G-AAA'];
    document.cookie = '_ga_BBB=GS1; path=/';
    expect(analyticsMeasurementIds().sort()).toEqual(['G-AAA', 'G-BBB']);
  });

  test('refus : cookies GA effacés sur l\'hôte et le domaine parent, GA désactivé, autres cookies intacts', () => {
    document.cookie = '_ga=GA1.1.123; path=/; domain=.titouan-borde.com';
    document.cookie = '_ga_V9QY0YW5E0=GS1.1; path=/; domain=.titouan-borde.com';
    document.cookie = '_gid=GA1.1.9; path=/';
    document.cookie = 'vh_session=1; path=/';
    expect(cookieNames()).toEqual(expect.arrayContaining(['_ga', '_ga_V9QY0YW5E0', '_gid']));

    const cc = new CookieConsent();
    cc.reloadPage = jest.fn();
    cc.rejectAll();

    const left = cookieNames();
    expect(left).not.toContain('_ga');
    expect(left).not.toContain('_ga_V9QY0YW5E0');
    expect(left).not.toContain('_gid');
    expect(left).toContain('vh_session');
    expect(window['ga-disable-G-V9QY0YW5E0']).toBe(true);
    // GTM jamais chargé dans cette page : pas de rechargement
    expect(cc.reloadPage).not.toHaveBeenCalled();
  });

  test('retrait alors que GTM tourne dans la page : rechargement (coupe les envois en file)', () => {
    window.__isGTMLoaded = () => true;
    window.__VH_GA_IDS = ['G-V9QY0YW5E0'];
    const cc = new CookieConsent();
    cc.reloadPage = jest.fn();
    cc.preferences = { essential: true, analytics: false, marketing: false };
    cc.applyConsent();
    expect(cc.reloadPage).toHaveBeenCalledTimes(1);
    expect(window['ga-disable-G-V9QY0YW5E0']).toBe(true);
  });

  test('acceptation après un refus : drapeau ga-disable levé', () => {
    window.__VH_GA_IDS = ['G-V9QY0YW5E0'];
    window['ga-disable-G-V9QY0YW5E0'] = true;
    const cc = new CookieConsent();
    cc.acceptAll();
    expect(window['ga-disable-G-V9QY0YW5E0']).toBe(false);
  });

  test('le consentement Google transmis ne demande jamais fonctionnalité ni personnalisation', () => {
    window.dataLayer = [];
    const cc = new CookieConsent();
    cc.acceptAll();
    const update = window.dataLayer.map((e) => Array.from(e)).find((a) => a[1] === 'update');
    expect(update[2]).toMatchObject({
      analytics_storage: 'granted', functionality_storage: 'denied', personalization_storage: 'denied', ad_storage: 'denied',
    });
  });
});

describe('gtm.js — nonce CSP, réglages des cookies GA, état de chargement', () => {
  function loadGtmWithScript(nonce) {
    document.head.innerHTML = '<script src="/js/dist/app.min.js"></script>';
    const current = document.createElement('script');
    if (nonce) current.nonce = nonce;
    jest.spyOn(document, 'currentScript', 'get').mockReturnValue(current);
    window.dataLayer = [];
    delete window.__loadGTM;
    jest.isolateModules(() => { require('../js/gtm'); });
    jest.restoreAllMocks();
  }
  const gtmScript = () => Array.from(document.querySelectorAll('script')).find((s) => (s.src || '').includes('googletagmanager.com'));

  test('le script GTM créé reprend le nonce capturé au chargement de gtm.js', () => {
    loadGtmWithScript('abc123');
    expect(window.__isGTMLoaded()).toBe(false);
    window.__loadGTM();
    expect(gtmScript().nonce).toBe('abc123');
    expect(window.__isGTMLoaded()).toBe(true);
  });

  test('sans nonce : script créé quand même, sans attribut nonce', () => {
    loadGtmWithScript('');
    window.__loadGTM();
    expect(gtmScript()).toBeDefined();
    expect(gtmScript().getAttribute('nonce')).toBeNull();
  });

  test('cookies GA bornés à l\'hôte et à 13 mois ; identifiant de mesure exposé', () => {
    loadGtmWithScript('n');
    const set = window.dataLayer.map((e) => Array.from(e)).find((a) => a[0] === 'set');
    expect(set[1]).toEqual({ cookie_domain: 'vol-histoire.titouan-borde.com', cookie_expires: 33696000 });
    expect(window.__VH_GA_IDS).toEqual(['G-V9QY0YW5E0']);
  });
});
