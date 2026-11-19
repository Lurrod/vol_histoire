/**
 * Tests unitaires — frontend/js/nav.js
 * Navigation partagée : closeMenu, updateAuthUI
 */

// Mock auth global
// VH.motion : durées de sortie lues sur le CSS (inexistantes sous jsdom : rappel immédiat).
require('../js/shared/motion');

global.auth = {
  getToken: jest.fn().mockReturnValue(null),
  getPayload: jest.fn().mockReturnValue(null),
  logout: jest.fn().mockResolvedValue(undefined),
};

// Mock i18n global
global.i18n = {
  t: jest.fn((key) => key),
};

// Mock showToast global
global.showToast = jest.fn();

beforeEach(() => {
  jest.clearAllMocks();
  document.body.innerHTML = `
    <header>
      <nav class="container">
        <div class="logo"></div>
        <button class="hamburger" aria-expanded="false" aria-controls="nav-links"><span></span><span></span><span></span></button>
        <ul class="nav-links" id="nav-links">
          <li><a href="/">Accueil</a></li>
          <li><a href="/hangar">Hangar</a></li>
        </ul>
        <div class="nav-actions">
          <div class="lang-switch">
            <button type="button" id="lang-toggle" class="lang-btn"></button>
            <ul class="lang-dropdown" id="lang-dropdown"></ul>
          </div>
        </div>
      </nav>
    </header>
  `;
});

// nav.js s'auto-initialise au DOMContentLoaded, mais en test on le charge après le DOM
// On doit simuler le DOMContentLoaded
function loadNav() {
  // Reset module cache
  jest.resetModules();
  // Le module s'enregistre sur DOMContentLoaded. On retire l'écouteur après
  // usage : sinon les initialisations des tests précédents se rejouent au
  // dispatch suivant, et plusieurs instances réagissent au même clic.
  const inits = [];
  const add = document.addEventListener;
  document.addEventListener = function (type, fn, opts) {
    if (type === 'DOMContentLoaded') inits.push(fn);
    return add.call(this, type, fn, opts);
  };
  try {
    require('../js/nav');
  } finally {
    document.addEventListener = add;
  }
  // Déclencher DOMContentLoaded
  document.dispatchEvent(new Event('DOMContentLoaded'));
  inits.forEach((fn) => document.removeEventListener('DOMContentLoaded', fn));
  return window.nav;
}

// =============================================================================
// Initialisation
// =============================================================================
describe('nav.js initialisation', () => {
  test('expose window.nav avec closeMenu et updateAuthUI', () => {
    const nav = loadNav();
    expect(nav).toBeDefined();
    expect(typeof nav.closeMenu).toBe('function');
    expect(nav.closeDropdown).toBeUndefined();
    expect(typeof nav.updateAuthUI).toBe('function');
  });
});

// =============================================================================
// closeMenu
// =============================================================================
describe('closeMenu', () => {
  test('retire la classe show de nav-links', () => {
    const nav = loadNav();
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.add('show');

    nav.closeMenu();

    expect(navLinks.classList.contains('show')).toBe(false);
  });

  test('retire la classe active du hamburger', () => {
    const nav = loadNav();
    const hamburger = document.querySelector('.hamburger');
    hamburger.classList.add('active');

    nav.closeMenu();

    expect(hamburger.classList.contains('active')).toBe(false);
  });

  test('débloque le défilement (classe nav-open retirée)', () => {
    const nav = loadNav();
    document.querySelector('.hamburger').click();
    expect(document.body.classList.contains('nav-open')).toBe(true);

    nav.closeMenu();

    expect(document.body.classList.contains('nav-open')).toBe(false);
    expect(document.body.getAttribute('style')).toBeNull();
  });
});

// =============================================================================
// updateAuthUI
// =============================================================================
describe('updateAuthUI', () => {
  test('ne crash pas si payload est null', () => {
    auth.getPayload.mockReturnValue(null);
    const nav = loadNav();

    expect(() => nav.updateAuthUI()).not.toThrow();
  });

  test('menu flottant : .is-auth sur l’en-tête suit la session (Connexion ou Paramètres/Déconnexion)', () => {
    auth.getPayload.mockReturnValue(null);
    const nav = loadNav();
    const header = document.querySelector('body > header');
    nav.updateAuthUI();
    expect(header.classList.contains('is-auth')).toBe(false);
    auth.getPayload.mockReturnValue({ name: 'Jean', role: 3 });
    nav.updateAuthUI();
    expect(header.classList.contains('is-auth')).toBe(true);
    auth.getPayload.mockReturnValue(null);
    nav.updateAuthUI();
    expect(header.classList.contains('is-auth')).toBe(false);
  });
});

// =============================================================================
// Hamburger toggle
// =============================================================================
describe('hamburger click', () => {
  test('toggle la classe show sur nav-links', () => {
    loadNav();
    const hamburger = document.querySelector('.hamburger');
    const navLinks = document.querySelector('.nav-links');

    hamburger.click();
    expect(navLinks.classList.contains('show')).toBe(true);

    hamburger.click();
    expect(navLinks.classList.contains('show')).toBe(false);
  });

  test('pilote le menu flottant : .menu-open sur l’en-tête, retirée à la fermeture', () => {
    const nav = loadNav();
    const header = document.querySelector('body > header');
    document.querySelector('.hamburger').click();
    expect(header.classList.contains('menu-open')).toBe(true);
    document.querySelector('.hamburger').click();
    expect(header.classList.contains('menu-open')).toBe(false);
    document.querySelector('.hamburger').click();
    nav.closeMenu();
    expect(header.classList.contains('menu-open')).toBe(false);
  });

  test('bureau : le menu underlay prend la main, le menu flottant ne bouge pas', () => {
    const underlay = { init: jest.fn(), enabled: jest.fn(() => true), toggle: jest.fn(), close: jest.fn() };
    window.VH = { ...window.VH, underlayNav: underlay };
    try {
      const nav = loadNav();
      expect(underlay.init).toHaveBeenCalledWith(expect.objectContaining({
        trigger: document.querySelector('.hamburger'),
      }));
      document.querySelector('.hamburger').click();
      expect(underlay.toggle).toHaveBeenCalledTimes(1);
      expect(document.querySelector('body > header').classList.contains('menu-open')).toBe(false);
      nav.closeMenu();
      expect(underlay.close).toHaveBeenCalled();
    } finally {
      delete window.VH.underlayNav;
    }
  });
});

// =============================================================================
// ESC ferme tout
// =============================================================================
describe('ESC key', () => {
  test('ferme le menu', () => {
    loadNav();
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.add('show');

    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));

    expect(navLinks.classList.contains('show')).toBe(false);
  });

  test('ferme la liste des langues et rend le focus au bouton', () => {
    loadNav();
    const langSwitch = document.querySelector('.lang-switch');
    const toggle = document.getElementById('lang-toggle');
    const dropdown = document.getElementById('lang-dropdown');
    dropdown.innerHTML = '<li><button type="button" class="lang-option">FR</button></li>';
    langSwitch.classList.add('open');
    toggle.classList.add('open');
    toggle.setAttribute('aria-expanded', 'true');
    dropdown.querySelector('button').focus();

    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));

    expect(langSwitch.classList.contains('open')).toBe(false);
    expect(toggle.classList.contains('open')).toBe(false);
    expect(toggle.getAttribute('aria-expanded')).toBe('false');
    expect(document.activeElement).toBe(toggle);
  });
});

// =============================================================================
// Menu mobile : voile et un seul élément ouvert à la fois
// =============================================================================
describe('menu mobile', () => {
  test('le voile suit l’ouverture du menu', () => {
    const nav = loadNav();
    const scrim = document.querySelector('.nav-scrim');
    expect(scrim).not.toBeNull();

    document.querySelector('.hamburger').click();
    expect(scrim.classList.contains('show')).toBe(true);

    nav.closeMenu();
    expect(scrim.classList.contains('show')).toBe(false);
  });

  test('un toucher sur le voile referme le menu', () => {
    loadNav();
    document.querySelector('.hamburger').click();

    document.querySelector('.nav-scrim').click();

    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
    expect(document.querySelector('.hamburger').getAttribute('aria-expanded')).toBe('false');
  });

  test('ouvrir le menu referme la liste des langues', () => {
    loadNav();
    const langSwitch = document.querySelector('.lang-switch');
    const toggle = document.getElementById('lang-toggle');
    langSwitch.classList.add('open');
    toggle.setAttribute('aria-expanded', 'true');

    document.querySelector('.hamburger').click();

    expect(langSwitch.classList.contains('open')).toBe(false);
    expect(toggle.getAttribute('aria-expanded')).toBe('false');
  });

  test('ouvrir la liste des langues referme le menu', () => {
    loadNav();
    document.querySelector('.hamburger').click();

    document.getElementById('lang-toggle').click();

    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
  });
});
