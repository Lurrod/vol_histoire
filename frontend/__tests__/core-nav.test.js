/**
 * Tests — frontend/js/nav.js : comportements non couverts par nav.test.js
 * (défilement, redimensionnement, redirection anonyme, déconnexion, clavier
 * dans les menus, attente de la session).
 *
 * nav.js s'initialise au DOMContentLoaded et pose des écouteurs sur document
 * et window : ils sont tous retirés après chaque test pour qu'aucune instance
 * précédente ne réagisse aux événements suivants.
 */

const HEADER = `
  <header>
    <nav>
      <button class="hamburger"></button>
      <ul class="nav-links"><li><a href="#accueil">Accueil</a></li><li><a href="#hangar">Hangar</a></li></ul>
      <div class="nav-actions">
        <div class="lang-switch">
          <button type="button" id="lang-toggle"></button>
          <ul id="lang-dropdown">
            <li><a href="#" class="lang-option" data-lang="fr">FR</a></li>
            <li><a href="#" class="lang-option" data-lang="en">EN</a></li>
          </ul>
        </div>
        <div class="user-menu">
          <div class="user-toggle">
            <a href="/login" id="login-icon">compte</a>
          </div>
          <div class="user-dropdown hidden">
            <span id="user-name"></span><span class="user-role"></span>
            <a href="/settings" id="settings-icon" role="menuitem">Paramètres</a>
            <a href="#" id="logout-icon" role="menuitem">Déconnexion</a>
          </div>
        </div>
      </div>
    </nav>
  </header>`;

const registered = [];
let docSpy;
let winSpy;

function track(target) {
  return jest.spyOn(target, 'addEventListener').mockImplementation(function (type, fn, opts) {
    registered.push([target, type, fn, opts]);
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
}

function loadNav(html = HEADER) {
  document.body.innerHTML = html;
  jest.isolateModules(() => { require('../js/nav'); });
  document.dispatchEvent(new Event('DOMContentLoaded'));
  return window.nav;
}

/** Compte les navigations tentées (jsdom ne les implémente pas et le signale). */
function watchNavigation() {
  const spy = jest.spyOn(console, 'error').mockImplementation(() => {});
  return {
    count: () => spy.mock.calls.filter(([e]) => /navigation/.test(String(e && e.message))).length,
    restore: () => spy.mockRestore(),
  };
}

const keydown = (el, key) => {
  const ev = new KeyboardEvent('keydown', { key, bubbles: true, cancelable: true });
  el.dispatchEvent(ev);
  return ev;
};

beforeEach(() => {
  jest.useFakeTimers();
  global.auth = {
    getToken: jest.fn(() => null),
    getPayload: jest.fn(() => null),
    logout: jest.fn(() => Promise.resolve()),
  };
  global.i18n = { t: jest.fn((k) => k) };
  global.showToast = jest.fn();
  docSpy = track(document);
  winSpy = track(window);
});

afterEach(() => {
  docSpy.mockRestore();
  winSpy.mockRestore();
  registered.splice(0).forEach(([target, type, fn, opts]) => target.removeEventListener(type, fn, opts));
  jest.useRealTimers();
  delete window.nav;
  window.history.replaceState(null, '', '/');
});

describe('en-tête au défilement', () => {
  test('classe scrolled au-delà de 100 px, retirée en remontant', () => {
    loadNav();
    const header = document.querySelector('header');
    window.pageYOffset = 150;
    window.dispatchEvent(new Event('scroll'));
    expect(header.classList.contains('scrolled')).toBe(true);
    window.pageYOffset = 20;
    window.dispatchEvent(new Event('scroll'));
    expect(header.classList.contains('scrolled')).toBe(false);
  });
});

describe('menu mobile', () => {
  test('un clic sur un lien referme le panneau', () => {
    loadNav();
    document.querySelector('.hamburger').click();
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
    document.querySelector('.nav-links a').click();
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
    expect(document.body.classList.contains('nav-open')).toBe(false);
  });

  test('passage au-delà de 1024 px : menu et compte refermés (anti-rebond 250 ms)', () => {
    window.matchMedia = jest.fn(() => ({ matches: true }));
    loadNav();
    document.querySelector('.hamburger').click();
    window.dispatchEvent(new Event('resize'));
    window.dispatchEvent(new Event('resize'));
    jest.advanceTimersByTime(249);
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
    jest.advanceTimersByTime(1);
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
    expect(window.matchMedia).toHaveBeenCalledTimes(1);
    expect(window.matchMedia).toHaveBeenCalledWith('(min-width: 64em)');
  });

  test('redimensionnement sous 1024 px : le menu reste ouvert', () => {
    window.matchMedia = jest.fn(() => ({ matches: false }));
    loadNav();
    document.querySelector('.hamburger').click();
    window.dispatchEvent(new Event('resize'));
    jest.advanceTimersByTime(300);
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
  });
});

describe('icône compte', () => {
  test('visiteur anonyme : le clic mène à /login, aucun menu ouvert', () => {
    loadNav();
    const nav = watchNavigation();
    try {
      const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true });
      document.getElementById('login-icon').dispatchEvent(ev);
      expect(ev.defaultPrevented).toBe(true);
      expect(nav.count()).toBe(1);
    } finally {
      nav.restore();
    }
    expect(document.querySelector('.user-dropdown').classList.contains('show')).toBe(false);
  });

  test('connecté : nom et rôle administrateur affichés', () => {
    auth.getPayload.mockReturnValue({ id: 1, name: 'Ada', role: '1' });
    loadNav();
    expect(document.getElementById('user-name').textContent).toBe('Ada');
    expect(document.querySelector('.user-role').textContent).toBe('common.role_admin');
    expect(document.getElementById('login-icon').getAttribute('aria-haspopup')).toBe('true');
  });

  test('connecté sans nom : libellé par défaut', () => {
    auth.getPayload.mockReturnValue({ id: 1, role: 3 });
    loadNav();
    expect(document.getElementById('user-name').textContent).toBe('nav.user_default');
  });

  test('sans menu ni conteneur : ouvrir/fermer ne lève pas', () => {
    auth.getToken.mockReturnValue('jeton');
    const nav = loadNav('<header><a href="/login" id="login-icon">compte</a></header>');
    expect(() => {
      document.getElementById('login-icon').click();
      nav.closeDropdown();
      nav.closeMenu();
    }).not.toThrow();
  });

  test('« Paramètres » mène à /settings', () => {
    loadNav();
    const nav = watchNavigation();
    try {
      document.getElementById('settings-icon').click();
      expect(nav.count()).toBe(1);
    } finally {
      nav.restore();
    }
  });
});

describe('déconnexion', () => {
  test('appelle auth.logout, confirme, puis renvoie à l’accueil après 1 s', async () => {
    window.history.replaceState(null, '', '/hangar'); // sinon « / » → « / » n'est pas une navigation
    loadNav();
    const nav = watchNavigation();
    try {
      document.getElementById('logout-icon').click();
      await Promise.resolve();
      await Promise.resolve();
      expect(auth.logout).toHaveBeenCalledTimes(1);
      expect(showToast).toHaveBeenCalledWith('common.logout_success', 'success');
      expect(nav.count()).toBe(0);
      jest.advanceTimersByTime(1000);
      expect(nav.count()).toBe(1);
    } finally {
      nav.restore();
    }
  });
});

describe('clavier dans les menus déroulants', () => {
  let offsetParent;
  beforeAll(() => {
    // jsdom ne calcule pas offsetParent (toujours null) : nav.js s'en sert
    // pour ignorer les options masquées. On le simule : visible = pas [hidden].
    offsetParent = Object.getOwnPropertyDescriptor(HTMLElement.prototype, 'offsetParent');
    Object.defineProperty(HTMLElement.prototype, 'offsetParent', {
      configurable: true,
      get() { return this.closest('[hidden]') ? null : this.parentNode; },
    });
  });
  afterAll(() => {
    Object.defineProperty(HTMLElement.prototype, 'offsetParent', offsetParent);
  });

  test('↓ ↑ Début Fin parcourent la liste des langues, en boucle', () => {
    loadNav();
    const [fr, en] = document.querySelectorAll('.lang-option');
    const list = document.getElementById('lang-dropdown');
    fr.focus();
    expect(keydown(fr, 'ArrowDown').defaultPrevented).toBe(true);
    expect(document.activeElement).toBe(en);
    keydown(en, 'ArrowDown');
    expect(document.activeElement).toBe(fr);
    keydown(fr, 'ArrowUp');
    expect(document.activeElement).toBe(en);
    keydown(en, 'Home');
    expect(document.activeElement).toBe(fr);
    keydown(fr, 'End');
    expect(document.activeElement).toBe(en);
    expect(keydown(list, 'a').defaultPrevented).toBe(false);
  });

  test('menu compte : les entrées role=menuitem, options masquées ignorées', () => {
    loadNav();
    const settings = document.getElementById('settings-icon');
    const logout = document.getElementById('logout-icon');
    settings.focus();
    keydown(settings, 'ArrowDown');
    expect(document.activeElement).toBe(logout);
    logout.hidden = true;
    keydown(settings, 'ArrowDown');
    expect(document.activeElement).toBe(settings);
  });

  test('aucune entrée visible : touches laissées au navigateur', () => {
    loadNav();
    document.getElementById('lang-dropdown').hidden = true;
    const ev = keydown(document.querySelector('.lang-option'), 'ArrowDown');
    expect(ev.defaultPrevented).toBe(false);
  });
});

describe('Échap', () => {
  test('menu compte ouvert, focus dedans : focus rendu à l’icône compte', () => {
    auth.getToken.mockReturnValue('jeton');
    auth.getPayload.mockReturnValue({ id: 1, name: 'Ada', role: 3 });
    loadNav();
    document.getElementById('login-icon').click();
    jest.advanceTimersByTime(20);
    const settings = document.getElementById('settings-icon');
    settings.focus();
    keydown(settings, 'Escape');
    expect(document.activeElement).toBe(document.getElementById('login-icon'));
    expect(document.querySelector('.user-dropdown').classList.contains('show')).toBe(false);
    expect(document.getElementById('login-icon').getAttribute('aria-expanded')).toBe('false');
  });

  test('autre touche : rien ne se ferme', () => {
    loadNav();
    document.querySelector('.hamburger').click();
    keydown(document.body, 'Enter');
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
  });
});

describe('attente de la session', () => {
  test('met à jour l’en-tête dès que auth.init() a fourni un payload', () => {
    loadNav();
    expect(document.getElementById('user-name').textContent).toBe('');
    auth.getPayload.mockReturnValue({ id: 2, name: 'Grace', role: 2 });
    jest.advanceTimersByTime(100);
    expect(document.getElementById('user-name').textContent).toBe('Grace');
    expect(document.querySelector('.user-role').textContent).toBe('common.role_editor');
    // Intervalle arrêté une fois la session vue.
    auth.getPayload.mockClear();
    jest.advanceTimersByTime(500);
    expect(auth.getPayload).not.toHaveBeenCalled();
  });

  test('abandon après 5 s sans session', () => {
    loadNav();
    jest.advanceTimersByTime(5000);
    auth.getPayload.mockClear();
    jest.advanceTimersByTime(1000);
    expect(auth.getPayload).not.toHaveBeenCalled();
  });
});
