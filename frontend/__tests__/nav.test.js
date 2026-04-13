/**
 * Tests unitaires — frontend/js/nav.js
 * Navigation partagée : closeMenu, closeDropdown, updateAuthUI
 */

// Mock auth global
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
          <li class="user-menu">
            <div class="user-toggle">
              <a href="/login" id="login-icon"><i class="fas fa-user-circle"></i></a>
              <div class="user-dropdown hidden">
                <div class="user-header">
                  <div class="user-details">
                    <span id="user-name">Utilisateur</span>
                    <span class="user-role">Membre</span>
                  </div>
                </div>
                <a href="/settings" id="settings-icon">Paramètres</a>
                <a href="#" id="logout-icon">Déconnexion</a>
              </div>
            </div>
          </li>
        </ul>
      </nav>
    </header>
  `;
});

// nav.js s'auto-initialise au DOMContentLoaded, mais en test on le charge après le DOM
// On doit simuler le DOMContentLoaded
function loadNav() {
  // Reset module cache
  jest.resetModules();
  // Le module s'enregistre sur DOMContentLoaded
  require('../js/nav');
  // Déclencher DOMContentLoaded
  document.dispatchEvent(new Event('DOMContentLoaded'));
  return window.nav;
}

// =============================================================================
// Initialisation
// =============================================================================
describe('nav.js initialisation', () => {
  test('expose window.nav avec closeMenu, closeDropdown, updateAuthUI', () => {
    const nav = loadNav();
    expect(nav).toBeDefined();
    expect(typeof nav.closeMenu).toBe('function');
    expect(typeof nav.closeDropdown).toBe('function');
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

  test('remet body overflow à vide', () => {
    const nav = loadNav();
    document.body.style.overflow = 'hidden';

    nav.closeMenu();

    expect(document.body.style.overflow).toBe('');
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

  test('met à jour le nom et le rôle si payload existe', () => {
    auth.getPayload.mockReturnValue({ name: 'Jean', role: 1 });
    i18n.t.mockImplementation((key) => {
      if (key === 'common.role_admin') return 'Administrateur';
      return key;
    });

    const nav = loadNav();
    nav.updateAuthUI();

    expect(document.getElementById('user-name').textContent).toBe('Jean');
    expect(document.querySelector('.user-role').textContent).toBe('Administrateur');
  });

  test('affiche éditeur pour role 2', () => {
    auth.getPayload.mockReturnValue({ name: 'Marie', role: 2 });
    i18n.t.mockImplementation((key) => {
      if (key === 'common.role_editor') return 'Éditeur';
      return key;
    });

    const nav = loadNav();
    nav.updateAuthUI();

    expect(document.querySelector('.user-role').textContent).toBe('Éditeur');
  });

  test('affiche membre par défaut pour role 3', () => {
    auth.getPayload.mockReturnValue({ name: 'Paul', role: 3 });
    i18n.t.mockImplementation((key) => {
      if (key === 'nav.user_role') return 'Membre';
      return key;
    });

    const nav = loadNav();
    nav.updateAuthUI();

    expect(document.querySelector('.user-role').textContent).toBe('Membre');
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
});

// =============================================================================
// ESC ferme tout
// =============================================================================
describe('ESC key', () => {
  test('ferme le menu et le dropdown', () => {
    const nav = loadNav();
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.add('show');

    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));

    expect(navLinks.classList.contains('show')).toBe(false);
  });
});
