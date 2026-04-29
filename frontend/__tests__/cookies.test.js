/**
 * Tests unitaires — frontend/js/cookies.js (CookieConsent class)
 *
 * cookies.js depend de safeSetHTML (window globale via utils.js). On l'expose
 * avant require pour eviter ReferenceError au chargement.
 *
 * Le constructeur appelle init() qui est async + DOM-dependent. On instancie
 * mais on teste uniquement les methodes synchrones state-only (saveConsent,
 * getConsent, acceptAll, rejectAll, preferences).
 */

// Stubs globals attendus par cookies.js
global.safeSetHTML = (el, html) => { el.innerHTML = html; };

const { CookieConsent } = require('../js/cookies');

describe('CookieConsent — constructeur', () => {
  beforeEach(() => {
    localStorage.clear();
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
  });

  test('initialise les preferences par defaut (essential=true, autres=false)', () => {
    const cc = new CookieConsent();
    expect(cc.preferences.essential).toBe(true);
    expect(cc.preferences.analytics).toBe(false);
    expect(cc.preferences.preference).toBe(false);
    expect(cc.preferences.marketing).toBe(false);
  });

  test('definit le nom du cookie "voldhistoire_cookie_consent"', () => {
    const cc = new CookieConsent();
    expect(cc.cookieName).toBe('voldhistoire_cookie_consent');
  });

  test('definit l\'expiration a 365 jours', () => {
    const cc = new CookieConsent();
    expect(cc.cookieExpiry).toBe(365);
  });
});

describe('CookieConsent — saveConsent / getConsent', () => {
  let cc;
  beforeEach(() => {
    localStorage.clear();
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    cc = new CookieConsent();
  });

  test('getConsent() retourne null quand rien n\'est stocke', () => {
    localStorage.clear();
    expect(cc.getConsent()).toBeNull();
  });

  test('saveConsent() persiste les preferences dans localStorage', () => {
    cc.preferences = { essential: true, analytics: true, preference: false, marketing: false };
    cc.saveConsent();
    const raw = localStorage.getItem('voldhistoire_cookie_consent');
    expect(raw).not.toBeNull();
    const parsed = JSON.parse(raw);
    expect(parsed.preferences.analytics).toBe(true);
    expect(parsed.preferences.preference).toBe(false);
    expect(parsed.timestamp).toBeDefined();
    expect(parsed.version).toBe('1.0');
  });

  test('getConsent() recupere les preferences sauvegardees', () => {
    cc.preferences = { essential: true, analytics: true, preference: true, marketing: false };
    cc.saveConsent();
    const consent = cc.getConsent();
    expect(consent).not.toBeNull();
    expect(consent.analytics).toBe(true);
    expect(consent.preference).toBe(true);
  });

  test('getConsent() retourne null sur JSON corrompu', () => {
    localStorage.setItem('voldhistoire_cookie_consent', '{not-valid-json');
    expect(cc.getConsent()).toBeNull();
  });
});

describe('CookieConsent — acceptAll / rejectAll', () => {
  let cc;
  beforeEach(() => {
    localStorage.clear();
    // DOM minimal pour eviter les nullref dans hideBanner / showToast
    document.body.innerHTML = `
      <div id="cookie-banner" class="hidden"></div>
      <div id="toast-container"></div>
    `;
    cc = new CookieConsent();
  });

  test('acceptAll() active analytics + preference, garde marketing false', () => {
    cc.acceptAll();
    expect(cc.preferences.essential).toBe(true);
    expect(cc.preferences.analytics).toBe(true);
    expect(cc.preferences.preference).toBe(true);
    expect(cc.preferences.marketing).toBe(false);
  });

  test('acceptAll() persiste le consent', () => {
    cc.acceptAll();
    const consent = cc.getConsent();
    expect(consent.analytics).toBe(true);
    expect(consent.preference).toBe(true);
  });

  test('rejectAll() force tout a false sauf essential', () => {
    cc.rejectAll();
    expect(cc.preferences.essential).toBe(true);
    expect(cc.preferences.analytics).toBe(false);
    expect(cc.preferences.preference).toBe(false);
    expect(cc.preferences.marketing).toBe(false);
  });

  test('rejectAll() persiste le consent (essentials only)', () => {
    rejectAll: cc.rejectAll();
    const consent = cc.getConsent();
    expect(consent.essential).toBe(true);
    expect(consent.analytics).toBe(false);
  });
});
