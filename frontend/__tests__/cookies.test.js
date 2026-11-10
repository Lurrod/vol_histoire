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
    expect(cc.preferences.marketing).toBe(false);
    // Catégorie « préférence » retirée (LEGAL-006) : elle ne pilotait rien.
    expect(cc.preferences).not.toHaveProperty('preference');
  });

  test('definit le nom du cookie "voldhistoire_cookie_consent"', () => {
    const cc = new CookieConsent();
    expect(cc.cookieName).toBe('voldhistoire_cookie_consent');
  });

  test('conserve le choix 180 jours (6 mois, LEGAL-004)', () => {
    const cc = new CookieConsent();
    expect(cc.cookieExpiry).toBe(180);
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
    cc.preferences = { essential: true, analytics: true, marketing: false };
    cc.saveConsent();
    const raw = localStorage.getItem('voldhistoire_cookie_consent');
    expect(raw).not.toBeNull();
    const parsed = JSON.parse(raw);
    expect(parsed.preferences).toEqual({ essential: true, analytics: true, marketing: false });
    expect(Number.isNaN(Date.parse(parsed.timestamp))).toBe(false);
    expect(parsed.version).toBe('2');
    // Cookie miroir posé en même temps
    expect(document.cookie).toContain('voldhistoire_cookie_consent=true');
  });

  test('getConsent() recupere les preferences sauvegardees', () => {
    cc.preferences = { essential: true, analytics: true, marketing: false };
    cc.saveConsent();
    const consent = cc.getConsent();
    expect(consent).not.toBeNull();
    expect(consent.analytics).toBe(true);
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

  test('acceptAll() active analytics, garde marketing false', () => {
    cc.acceptAll();
    expect(cc.preferences).toEqual({ essential: true, analytics: true, marketing: false });
  });

  test('acceptAll() persiste le consent', () => {
    cc.acceptAll();
    const consent = cc.getConsent();
    expect(consent.analytics).toBe(true);
  });

  test('rejectAll() force tout a false sauf essential', () => {
    cc.rejectAll();
    expect(cc.preferences).toEqual({ essential: true, analytics: false, marketing: false });
  });

  test('rejectAll() persiste le consent (essentials only)', () => {
    rejectAll: cc.rejectAll();
    const consent = cc.getConsent();
    expect(consent.essential).toBe(true);
    expect(consent.analytics).toBe(false);
  });
});

describe('CookieConsent — en-têtes de catégorie', () => {
  let cc;
  beforeEach(() => {
    localStorage.clear();
    document.body.innerHTML = `
      <div id="cookie-banner" class="hidden"></div>
      <div class="cookie-category-header" id="h-essential">
        <h3>Essentiels</h3>
        <div class="cookie-toggle"><input type="checkbox" id="cookie-essential" checked disabled><label for="cookie-essential"></label></div>
      </div>
      <div class="cookie-category-header" id="h-analytics">
        <h3>Analytiques</h3>
        <div class="cookie-toggle"><input type="checkbox" id="cookie-analytics"><label for="cookie-analytics"></label></div>
      </div>
    `;
    cc = new CookieConsent();
    cc.bindCategoryHeaders();
  });

  test('un clic sur l’en-tête bascule l’interrupteur de la catégorie', () => {
    const input = document.getElementById('cookie-analytics');
    document.querySelector('#h-analytics h3').click();
    expect(input.checked).toBe(true);
    document.querySelector('#h-analytics h3').click();
    expect(input.checked).toBe(false);
  });

  test('un clic sur la case elle-même ne la bascule qu’une fois', () => {
    const input = document.getElementById('cookie-analytics');
    input.click();
    expect(input.checked).toBe(true);
  });

  test('une catégorie verrouillée ne reçoit pas l’affordance de clic', () => {
    expect(document.getElementById('h-essential').classList.contains('is-toggleable')).toBe(false);
    expect(document.getElementById('h-analytics').classList.contains('is-toggleable')).toBe(true);
    document.querySelector('#h-essential h3').click();
    expect(document.getElementById('cookie-essential').checked).toBe(true);
  });
});

describe('CookieConsent — toast', () => {
  afterEach(() => { delete global.showToast; });

  test('délègue au showToast partagé quand il existe', () => {
    localStorage.clear();
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    global.showToast = jest.fn();
    const cc = new CookieConsent();
    cc.acceptAll();
    expect(global.showToast).toHaveBeenCalledWith(expect.any(String), 'success');
  });

  test('le repli n’écrit aucun style en ligne', () => {
    jest.useFakeTimers();
    localStorage.clear();
    document.body.innerHTML = '<div id="cookie-banner" class="hidden"></div>';
    const cc = new CookieConsent();
    cc.showToast('Message', 'info');
    const toast = document.querySelector('#toast-container .toast');
    expect(toast).not.toBeNull();
    expect(document.getElementById('toast-container').getAttribute('style')).toBeNull();
    jest.advanceTimersByTime(3000);
    expect(toast.classList.contains('fade-out')).toBe(true);
    expect(toast.getAttribute('style')).toBeNull();
    jest.useRealTimers();
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// WCAG 2.2 — 2.4.11 : le focus ne doit pas rester caché sous le bandeau.
// jsdom ne calcule aucune mise en page : les rectangles sont simulés.
// ─────────────────────────────────────────────────────────────────────────────
describe('bannerOverlap — focus caché par le bandeau', () => {
  const { bannerOverlap } = require('../js/cookies');
  const rect = (top, bottom, left = 0, right = 200) => ({
    top, bottom, left, right, width: right - left, height: bottom - top,
  });
  let banner;
  let target;

  beforeEach(() => {
    document.body.innerHTML = `
      <header id="hdr"></header>
      <button id="cible">Filtre</button>
      <aside id="cookie-banner" class="cookie-banner show"><button id="dedans">OK</button></aside>`;
    banner = document.getElementById('cookie-banner');
    target = document.getElementById('cible');
    banner.getBoundingClientRect = () => rect(586, 812, 0, 375);
    delete document.elementFromPoint;
  });

  test('0 quand le bandeau n’est pas affiché', () => {
    banner.classList.remove('show');
    target.getBoundingClientRect = () => rect(633, 678);
    expect(bannerOverlap(target, banner)).toBe(0);
  });

  test('0 pour un élément du bandeau lui-même', () => {
    const dedans = document.getElementById('dedans');
    dedans.getBoundingClientRect = () => rect(700, 740);
    expect(bannerOverlap(dedans, banner)).toBe(0);
  });

  test('0 pour un élément entièrement au-dessus du bandeau', () => {
    target.getBoundingClientRect = () => rect(300, 344);
    expect(bannerOverlap(target, banner)).toBe(0);
  });

  test('0 pour un élément sans boîte (lien d’évitement replié)', () => {
    target.getBoundingClientRect = () => rect(0, 0, 0, 0);
    expect(bannerOverlap(target, banner)).toBe(0);
  });

  test('distance à défiler pour remonter l’élément au-dessus du bandeau, marge comprise', () => {
    target.getBoundingClientRect = () => rect(633, 678);
    // 678 - 586 + 16 de marge
    expect(bannerOverlap(target, banner)).toBe(108);
  });

  test('0 si un autre élément est posé au-dessus du bandeau (toast, modale)', () => {
    target.getBoundingClientRect = () => rect(700, 740);
    document.elementFromPoint = () => target;
    expect(bannerOverlap(target, banner)).toBe(0);
  });

  test('défile quand le point testé tombe sur le bandeau', () => {
    target.getBoundingClientRect = () => rect(700, 740);
    document.elementFromPoint = () => banner;
    expect(bannerOverlap(target, banner)).toBe(170);
  });

  test('ne fait pas passer le haut d’un élément haut sous l’en-tête', () => {
    document.getElementById('hdr').getBoundingClientRect = () => rect(0, 70);
    target.getBoundingClientRect = () => rect(120, 760);
    // Il faudrait 190 px ; le haut (120) ne peut monter qu'à 70 + 16 : 34 px.
    expect(bannerOverlap(target, banner, document.getElementById('hdr'))).toBe(34);
  });
});

describe('CookieConsent — garde du focus tant que le bandeau est affiché', () => {
  let cc;
  let scrollBy;

  beforeEach(() => {
    jest.useFakeTimers();
    localStorage.clear();
    document.body.innerHTML = `
      <button id="cible">Filtre</button>
      <aside id="cookie-banner" class="cookie-banner hidden"></aside>`;
    cc = new CookieConsent();
    jest.advanceTimersByTime(250); // le bandeau s'affiche après 200 ms
    document.getElementById('cookie-banner').getBoundingClientRect = () => ({
      top: 586, bottom: 812, left: 0, right: 375, width: 375, height: 226,
    });
    document.getElementById('cible').getBoundingClientRect = () => ({
      top: 633, bottom: 678, left: 0, right: 200, width: 200, height: 45,
    });
    scrollBy = jest.fn();
    window.scrollBy = scrollBy;
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('un élément focalisé sous le bandeau est remonté sans animation', () => {
    document.getElementById('cible').focus();
    expect(scrollBy).toHaveBeenCalledWith({ top: 108, behavior: 'instant' });
  });

  test('plus aucune correction une fois le bandeau fermé', () => {
    cc.hideBanner();
    jest.advanceTimersByTime(500);
    document.getElementById('cible').focus();
    expect(scrollBy).not.toHaveBeenCalled();
  });
});
