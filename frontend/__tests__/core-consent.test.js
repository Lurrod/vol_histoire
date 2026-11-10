/**
 * Tests — consentement aux cookies (js/cookies.js) et chargement conditionnel
 * de Google Tag Manager (js/gtm.js).
 *
 * Exigence RGPD / CNIL vérifiée ici : AUCUNE requête vers googletagmanager.com
 * tant que l'utilisateur n'a pas accordé la finalité « analytics ». Le bandeau
 * est le vrai fragment cookie-consent.html, servi par un fetch simulé.
 */
const fs = require('fs');
const path = require('path');
const DOMPurify = require('../js/vendor/purify.min.js');
const utils = require('../js/utils');

const FRAGMENT = fs.readFileSync(path.join(__dirname, '..', 'cookie-consent.html'), 'utf8');
const KEY = 'voldhistoire_cookie_consent';

global.DOMPurify = DOMPurify;
window.DOMPurify = DOMPurify;
global.safeSetHTML = utils.safeSetHTML;
global.trapFocus = utils.trapFocus;

// cookies.js enregistre un écouteur DOMContentLoaded au chargement : on le
// garde pour le déclencher une seule fois, puis le retirer.
const domReadyListeners = [];
const originalAdd = document.addEventListener;
document.addEventListener = function (type, fn, opts) {
  if (type === 'DOMContentLoaded') domReadyListeners.push(fn);
  return originalAdd.call(this, type, fn, opts);
};
const { CookieConsent } = require('../js/cookies');
document.addEventListener = originalAdd;

const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };
const gtmScripts = () => Array.from(document.querySelectorAll('script'))
  .filter((s) => (s.src || '').includes('googletagmanager.com'));
const storeConsent = (preferences) => localStorage.setItem(KEY, JSON.stringify({ preferences, timestamp: new Date().toISOString(), version: '2' }));

function loadGtm() {
  delete window.__loadGTM;
  jest.isolateModules(() => { require('../js/gtm'); });
}

/** Page minimale : un <script> (gtm.js s'insère avant le premier), un en-tête,
 *  et le fragment du bandeau servi par fetch quand cookies.js le demande. */
function setupPage({ inlineBanner = false } = {}) {
  document.head.innerHTML = '<script src="/js/dist/app.min.js"></script>';
  document.body.innerHTML = '<header></header><main><a href="#" class="cookie-settings-link">Cookies</a><button id="ailleurs">x</button></main>'
    + (inlineBanner ? FRAGMENT : '');
  global.fetch = jest.fn().mockResolvedValue({ ok: true, text: () => Promise.resolve(FRAGMENT) });
}

/** Nouvelle instance + attente de l'injection du fragment. */
async function createConsent() {
  const cc = new CookieConsent();
  await flush();
  return cc;
}

const listeners = [];
let addSpy;

beforeEach(() => {
  jest.useFakeTimers();
  localStorage.clear();
  window.dataLayer = [];
  global.showToast = jest.fn();
  delete global.i18n;
  // Chaque instance attache un keydown sur document : on les retire après le test.
  addSpy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    listeners.push([type, fn, opts]);
    return originalAdd.call(this, type, fn, opts);
  });
});

afterEach(() => {
  addSpy.mockRestore();
  listeners.splice(0).forEach(([type, fn, opts]) => document.removeEventListener(type, fn, opts));
  jest.useRealTimers();
  delete global.showToast;
});

// =============================================================================
// gtm.js seul
// =============================================================================
describe('gtm.js — Consent Mode v2 et chargement différé', () => {
  test('au chargement : défauts « denied » posés, aucun script Google inséré', () => {
    setupPage();
    loadGtm();
    expect(gtmScripts()).toHaveLength(0);
    const [cmd, action, defaults] = Array.from(window.dataLayer[0]);
    expect([cmd, action]).toEqual(['consent', 'default']);
    expect(defaults).toMatchObject({
      ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied',
      analytics_storage: 'denied', functionality_storage: 'denied', personalization_storage: 'denied',
      security_storage: 'granted',
    });
    expect(typeof window.__loadGTM).toBe('function');
  });

  test('__loadGTM insère le conteneur une seule fois (idempotent)', () => {
    setupPage();
    loadGtm();
    window.__loadGTM();
    window.__loadGTM();
    const scripts = gtmScripts();
    expect(scripts).toHaveLength(1);
    expect(scripts[0].src).toBe('https://www.googletagmanager.com/gtm.js?id=GTM-KB3P52VK');
    expect(scripts[0].async).toBe(true);
    expect(window.dataLayer.filter((e) => e.event === 'gtm.js')).toHaveLength(1);
  });

  test('ne remplace pas un dataLayer existant', () => {
    setupPage();
    window.dataLayer = [{ event: 'déjà là' }];
    loadGtm();
    expect(window.dataLayer[0]).toEqual({ event: 'déjà là' });
  });
});

// =============================================================================
// RGPD : GTM chargé SEULEMENT après consentement analytics
// =============================================================================
describe('RGPD — Google Tag Manager attend le consentement', () => {
  beforeEach(() => {
    setupPage();
    loadGtm();
  });

  test('première visite : bandeau affiché, GTM non chargé', async () => {
    await createConsent();
    jest.advanceTimersByTime(250);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(true);
    expect(gtmScripts()).toHaveLength(0);
  });

  test('« Refuser » : GTM jamais chargé, consentement refusé transmis', async () => {
    await createConsent();
    jest.advanceTimersByTime(250);
    document.getElementById('cookie-reject-btn').click();
    expect(gtmScripts()).toHaveLength(0);
    expect(window.VH.consent.denies('analytics')).toBe(true);
    const update = window.dataLayer.map((e) => Array.from(e)).find((a) => a[1] === 'update');
    expect(update[2]).toMatchObject({ analytics_storage: 'denied', functionality_storage: 'denied', ad_storage: 'denied' });
  });

  test('« Accepter » : GTM chargé, consentement accordé transmis', async () => {
    await createConsent();
    jest.advanceTimersByTime(250);
    document.getElementById('cookie-accept-btn').click();
    expect(gtmScripts()).toHaveLength(1);
    expect(window.VH.consent.allows('analytics')).toBe(true);
    const update = window.dataLayer.map((e) => Array.from(e)).find((a) => a[1] === 'update');
    // Le marketing n'est jamais accordé : le site n'en utilise pas.
    expect(update[2]).toMatchObject({ analytics_storage: 'granted', functionality_storage: 'denied', ad_storage: 'denied' });
    expect(window.dataLayer).toContainEqual({
      event: 'cookie_consent_update', cookie_consent_analytics: true,
      cookie_consent_marketing: false,
    });
  });

  test('visite suivante, analytics accordé : GTM chargé sans afficher le bandeau', async () => {
    storeConsent({ essential: true, analytics: true, marketing: false });
    await createConsent();
    jest.advanceTimersByTime(250);
    expect(gtmScripts()).toHaveLength(1);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(false);
  });

  test('visite suivante, analytics refusé : GTM non chargé, bandeau non réaffiché', async () => {
    storeConsent({ essential: true, analytics: false, marketing: false });
    await createConsent();
    jest.advanceTimersByTime(250);
    expect(gtmScripts()).toHaveLength(0);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(false);
  });

  test('préférences personnalisées sans analytics : GTM non chargé', async () => {
    await createConsent();
    document.getElementById('cookie-settings-btn').click();
    document.getElementById('cookie-save-preferences-btn').click();
    expect(gtmScripts()).toHaveLength(0);
    expect(window.VH.consent.get()).toEqual({ essential: true, analytics: false, marketing: false });
  });

  test('préférences personnalisées avec analytics : GTM chargé', async () => {
    await createConsent();
    document.getElementById('cookie-settings-btn').click();
    document.getElementById('cookie-analytics').click();
    document.getElementById('cookie-save-preferences-btn').click();
    expect(gtmScripts()).toHaveLength(1);
  });

  test('consentement stocké corrompu : traité comme une absence de choix (bandeau, pas de GTM)', async () => {
    localStorage.setItem(KEY, '{pas du json');
    await createConsent();
    jest.advanceTimersByTime(250);
    expect(gtmScripts()).toHaveLength(0);
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(true);
  });
});

// =============================================================================
// window.VH.consent — accesseur unique
// =============================================================================
describe('window.VH.consent', () => {
  test('aucun choix : get null, ni allows ni denies', () => {
    expect(window.VH.consent.get()).toBeNull();
    expect(window.VH.consent.allows('analytics')).toBe(false);
    expect(window.VH.consent.denies('analytics')).toBe(false);
  });

  test('lit la clé et la forme écrites par CookieConsent.saveConsent', () => {
    setupPage({ inlineBanner: true });
    const cc = new CookieConsent();
    cc.preferences = { essential: true, analytics: false, marketing: false };
    cc.saveConsent();
    expect(window.VH.consent.STORAGE_KEY).toBe(cc.cookieName);
    expect(window.VH.consent.denies('analytics')).toBe(true);
    // Catégorie « préférence » retirée (LEGAL-006) : ni accordée ni refusée
    expect(window.VH.consent.allows('preference')).toBe(false);
  });

  test('valeur absente ≠ refus : une finalité non renseignée n’est ni accordée ni refusée', () => {
    storeConsent({ essential: true });
    expect(window.VH.consent.allows('analytics')).toBe(false);
    expect(window.VH.consent.denies('analytics')).toBe(false);
  });

  test('données corrompues ou sans préférences : null', () => {
    localStorage.setItem(KEY, '{x');
    expect(window.VH.consent.get()).toBeNull();
    localStorage.setItem(KEY, JSON.stringify({ timestamp: 'x' }));
    expect(window.VH.consent.get()).toBeNull();
    localStorage.setItem(KEY, 'null');
    expect(window.VH.consent.get()).toBeNull();
  });

  test('stockage inaccessible : null (pas d’exception)', () => {
    const spy = jest.spyOn(window.Storage.prototype, 'getItem').mockImplementation(() => { throw new Error('bloqué'); });
    try {
      expect(window.VH.consent.get()).toBeNull();
      expect(window.VH.consent.denies('analytics')).toBe(false);
    } finally {
      spy.mockRestore();
    }
  });
});

// =============================================================================
// Chargement du fragment
// =============================================================================
describe('CookieConsent — chargement du fragment cookie-consent.html', () => {
  test('injecte le fragment en tête de body et le traduit', async () => {
    setupPage();
    global.i18n = { applyToDOM: jest.fn(), t: (k) => k };
    await createConsent();
    const container = document.body.firstElementChild;
    expect(container.querySelector('#cookie-banner')).not.toBeNull();
    expect(global.i18n.applyToDOM).toHaveBeenCalledWith(container);
  });

  /*
   * Régression (utils.js safeSetHTML, appelé par cookies.js:100) — la liste
   * blanche DOMPurify ne contenait ni <label> ni les attributs checked /
   * disabled / for : la modale montrait les cookies ESSENTIELS décochés et
   * modifiables, le MARKETING activable, et perdait les quatre <label> qui
   * portent les interrupteurs (.cookie-toggle label, cookies.css:374).
   */
  test('le fragment injecté garde interrupteurs, cases verrouillées et libellés', async () => {
    setupPage();
    await createConsent();
    const essential = document.getElementById('cookie-essential');
    expect(essential.checked).toBe(true);
    expect(essential.disabled).toBe(true);
    expect(document.getElementById('cookie-marketing').disabled).toBe(true);
    // essentiels, mesure d'audience, marketing : plus de catégorie « préférence »
    expect(document.querySelectorAll('.cookie-toggle label')).toHaveLength(3);
    expect(document.getElementById('cookie-preference')).toBeNull();
    document.querySelectorAll('.cookie-toggle label').forEach((label) => {
      expect(document.getElementById(label.getAttribute('for'))).not.toBeNull();
    });
  });

  test('safeSetHTML ne retire aucun élément ni attribut du vrai fragment', () => {
    const source = document.createElement('div');
    source.innerHTML = FRAGMENT;
    const injected = document.createElement('div');
    utils.safeSetHTML(injected, FRAGMENT);
    const describe = (root) => Array.from(root.querySelectorAll('*')).map((el) =>
      `${el.tagName} ${Array.from(el.attributes).map((a) => `${a.name}=${a.value}`).sort().join(' ')}`);
    expect(describe(injected)).toEqual(describe(source));
  });

  test('chemin du fragment déduit de la balise <script> de cookies.js', async () => {
    setupPage();
    document.head.innerHTML += '<script src="http://localhost/sous/js/cookies.js?v=1"></script>';
    await createConsent();
    expect(global.fetch).toHaveBeenCalledWith('http://localhost/sous/cookie-consent.html');
  });

  test('bandeau déjà présent dans la page : aucun fetch', async () => {
    setupPage({ inlineBanner: true });
    await createConsent();
    expect(global.fetch).not.toHaveBeenCalled();
  });

  test('réponse HTTP en erreur : rien n’est inséré', async () => {
    setupPage();
    global.fetch.mockResolvedValueOnce({ ok: false, text: () => Promise.resolve('') });
    await createConsent();
    expect(document.getElementById('cookie-banner')).toBeNull();
  });

  test('repli SPA (index.html servi à la place du fragment) : rien n’est inséré', async () => {
    setupPage();
    global.fetch.mockResolvedValueOnce({ ok: true, text: () => Promise.resolve('<main id="main-content">accueil</main>') });
    await createConsent();
    expect(document.getElementById('cookie-banner')).toBeNull();
    expect(document.getElementById('main-content')).toBeNull();
  });

  test('réseau coupé : échec silencieux', async () => {
    setupPage();
    global.fetch.mockRejectedValueOnce(new TypeError('Failed to fetch'));
    await expect(createConsent()).resolves.toBeInstanceOf(CookieConsent);
    expect(document.getElementById('cookie-banner')).toBeNull();
  });
});

// =============================================================================
// Modale de paramétrage
// =============================================================================
describe('CookieConsent — modale de paramétrage', () => {
  let cc;
  beforeEach(async () => {
    setupPage({ inlineBanner: true });
    cc = await createConsent();
    jest.advanceTimersByTime(250);
  });

  const modal = () => document.getElementById('cookie-modal');

  test('ouverture : rôle dialogue, titre relié, interrupteurs reflétant le choix enregistré', () => {
    storeConsent({ essential: true, analytics: true, marketing: false });
    const opener = document.getElementById('cookie-settings-btn');
    opener.focus();
    opener.click();

    expect(modal().getAttribute('role')).toBe('dialog');
    expect(modal().getAttribute('aria-modal')).toBe('true');
    const labelId = modal().getAttribute('aria-labelledby');
    expect(labelId).toBeTruthy();
    expect(document.getElementById(labelId)).not.toBeNull();
    expect(modal().classList.contains('show')).toBe(true);
    expect(modal().classList.contains('hidden')).toBe(false);
    expect(document.body.classList.contains('cookie-modal-open')).toBe(true);
    expect(document.getElementById('cookie-analytics').checked).toBe(true);
  });

  test('fermeture par la croix : focus rendu au déclencheur, masquée après l’animation', () => {
    const opener = document.getElementById('cookie-settings-btn');
    opener.focus();
    opener.click();
    document.querySelector('.cookie-modal-close').click();
    expect(document.activeElement).toBe(opener);
    expect(modal().classList.contains('show')).toBe(false);
    expect(document.body.classList.contains('cookie-modal-open')).toBe(false);
    jest.advanceTimersByTime(300);
    expect(modal().classList.contains('hidden')).toBe(true);
  });

  test('Échap ferme la modale ouverte', () => {
    cc.openModal();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
    expect(modal().classList.contains('show')).toBe(false);
  });

  test('Échap sans modale ouverte : ne fait rien, autres touches ignorées', () => {
    const close = jest.spyOn(cc, 'closeModal');
    modal().classList.add('hidden');
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    cc.openModal();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter' }));
    expect(close).not.toHaveBeenCalled();
  });

  test('le fond assombri ferme la modale', () => {
    cc.openModal();
    document.querySelector('.cookie-modal-backdrop').click();
    expect(modal().classList.contains('show')).toBe(false);
  });

  test('« Tout accepter » et « Tout refuser » de la modale enregistrent et ferment', () => {
    cc.openModal();
    document.getElementById('cookie-accept-all-btn').click();
    expect(window.VH.consent.allows('analytics')).toBe(true);
    expect(modal().classList.contains('show')).toBe(false);

    cc.openModal();
    document.getElementById('cookie-reject-all-btn').click();
    expect(window.VH.consent.denies('analytics')).toBe(true);
    expect(modal().classList.contains('show')).toBe(false);
  });

  test('lien « Cookies » du pied de page : ouvre la modale sans suivre le lien', () => {
    const link = document.querySelector('.cookie-settings-link');
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true });
    link.dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(true);
    expect(modal().classList.contains('show')).toBe(true);
  });

  test('enregistrer ferme la modale ET le bandeau, puis confirme', () => {
    cc.openModal();
    document.getElementById('cookie-save-preferences-btn').click();
    expect(document.getElementById('cookie-banner').classList.contains('show')).toBe(false);
    expect(global.showToast).toHaveBeenCalledWith(expect.any(String), 'success');
  });

  test('LEGAL-013 : « Tout refuser » au même niveau visuel que « Tout accepter »', () => {
    const reject = document.getElementById('cookie-reject-all-btn');
    const accept = document.getElementById('cookie-accept-all-btn');
    expect(reject.className).toBe(accept.className);
    expect(reject.classList.contains('btn-primary')).toBe(true);
    // Bandeau : même traitement pour Refuser et Tout accepter
    expect(document.getElementById('cookie-reject-btn').className).toBe(document.getElementById('cookie-accept-btn').className);
  });

  test('le focus est piégé dans la modale (trapFocus)', () => {
    cc.openModal();
    expect(cc._focusTrap).toBeTruthy();
    cc.closeModal();
    expect(cc._focusTrap).toBeNull();
  });
});

describe('CookieConsent — éléments absents et replis', () => {
  test('page sans modale : ouvrir / fermer / enregistrer ne lèvent pas', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    expect(() => { cc.openModal(); cc.closeModal(); cc.savePreferences(); }).not.toThrow();
    expect(cc.preferences).toEqual({ essential: true, analytics: false, marketing: false });
  });

  test('libellés : traduction i18n si disponible, sinon repli français', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    expect(cc.t('cookie.toast_accepted', 'Repli')).toBe('Repli');
    global.i18n = { t: (k) => (k === 'cookie.toast_accepted' ? 'All cookies accepted' : k) };
    expect(cc.t('cookie.toast_accepted', 'Repli')).toBe('All cookies accepted');
    expect(cc.t('cookie.autre', 'Repli')).toBe('Repli');
  });

  test('saveConsent pose aussi un cookie témoin de 6 mois', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    cc.saveConsent();
    expect(document.cookie).toContain(`${KEY}=true`);
  });

  test('chaque application du choix émet l’événement cookieConsent', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    const events = [];
    const onConsent = (e) => events.push(e.detail.event);
    document.addEventListener('cookieConsent', onConsent);
    cc.acceptAll();
    cc.rejectAll();
    document.removeEventListener('cookieConsent', onConsent);
    expect(events).toEqual(['analytics_enabled', 'analytics_disabled']);
  });

  test('toast de repli : icône selon le type, retiré après sa sortie', () => {
    delete global.showToast;
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div><div id="toast-container"></div>';
    const cc = new CookieConsent();
    cc.showToast('ok', 'success');
    cc.showToast('ko', 'error');
    cc.showToast('info');
    const icons = Array.from(document.querySelectorAll('#toast-container .toast i')).map((i) => i.className);
    expect(icons).toEqual(['fas fa-check-circle', 'fas fa-exclamation-circle', 'fas fa-info-circle']);
    jest.advanceTimersByTime(3300);
    expect(document.querySelectorAll('#toast-container .toast')).toHaveLength(0);
  });

  test('garde du focus : libérée si le bandeau est retiré du DOM', () => {
    document.body.innerHTML = '<button id="b">x</button><aside id="cookie-banner" class="hidden"></aside>';
    const cc = new CookieConsent();
    jest.advanceTimersByTime(250);
    expect(cc._focusGuard).toBeTruthy();
    document.getElementById('cookie-banner').remove();
    window.scrollBy = jest.fn();
    document.getElementById('b').focus();
    expect(cc._focusGuard).toBeNull();
    expect(window.scrollBy).not.toHaveBeenCalled();
    // Un second showBanner n'empile pas deux gardes.
    document.body.insertAdjacentHTML('beforeend', '<aside id="cookie-banner"></aside>');
    cc.showBanner();
    const guard = cc._focusGuard;
    cc.showBanner();
    expect(cc._focusGuard).toBe(guard);
  });
});

// =============================================================================
// Initialisation au DOMContentLoaded
// =============================================================================
describe('initialisation de la page', () => {
  test('DOMContentLoaded crée window.cookieConsent et expose resetCookieConsent', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    domReadyListeners.forEach((fn) => fn());
    expect(window.cookieConsent).toBeInstanceOf(CookieConsent);
    expect(typeof window.resetCookieConsent).toBe('function');
  });

  test('resetConsent efface le choix et recharge la page', () => {
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    cc.acceptAll();
    // jsdom n'implémente pas la navigation : il le signale en console.error.
    const errors = jest.spyOn(console, 'error').mockImplementation(() => {});
    try {
      window.cookieConsent = cc;
      window.resetCookieConsent();
      expect(localStorage.getItem(KEY)).toBeNull();
      expect(errors.mock.calls.some(([e]) => /navigation/.test(String(e && e.message)))).toBe(true);
    } finally {
      errors.mockRestore();
    }
  });
});
