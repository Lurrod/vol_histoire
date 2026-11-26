/**
 * Tests — frontend/js/nav.js : comportements non couverts par nav.test.js
 * (défilement, redimensionnement, déconnexion, clavier dans la liste des
 * langues, attente de la session).
 *
 * nav.js s'initialise au DOMContentLoaded et pose des écouteurs sur document
 * et window : ils sont tous retirés après chaque test pour qu'aucune instance
 * précédente ne réagisse aux événements suivants.
 */

// VH.motion : durées de sortie lues sur le CSS (inexistantes sous jsdom : rappel immédiat).
require('../js/shared/motion');

const HEADER = `
  <header>
    <nav>
      <button class="hamburger"></button>
      <ul class="nav-links"><li><a href="#accueil">Accueil</a></li><li><a href="#hangar">Hangar</a></li><li><button type="button" class="nav-logout">Déconnexion</button></li></ul>
      <div class="nav-actions">
        <div class="lang-switch">
          <button type="button" id="lang-toggle"></button>
          <ul id="lang-dropdown">
            <li><a href="#" class="lang-option" data-lang="fr">FR</a></li>
            <li><a href="#" class="lang-option" data-lang="en">EN</a></li>
          </ul>
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

  test('passage au-delà de 1024 px : menu refermé (anti-rebond 250 ms)', () => {
    window.matchMedia = jest.fn(() => ({ matches: true }));
    loadNav();
    document.querySelector('.hamburger').click();
    window.dispatchEvent(new Event('resize'));
    window.dispatchEvent(new Event('resize'));
    jest.advanceTimersByTime(249);
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
    jest.advanceTimersByTime(1);
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
    // VH.motion.exit interroge aussi matchMedia (mouvements réduits) : on ne
    // compte que la requête du palier burger.
    const burger = window.matchMedia.mock.calls.filter(([q]) => q === '(min-width: 64em)');
    expect(burger).toHaveLength(1);
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

describe('déconnexion', () => {
  test('appelle auth.logout, confirme, puis renvoie à l’accueil après 1 s', async () => {
    window.history.replaceState(null, '', '/hangar'); // sinon « / » → « / » n'est pas une navigation
    loadNav();
    const nav = watchNavigation();
    try {
      document.querySelector('.nav-logout').click();
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

describe('clavier dans la liste des langues', () => {
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

  test('aucune entrée visible : touches laissées au navigateur', () => {
    loadNav();
    document.getElementById('lang-dropdown').hidden = true;
    const ev = keydown(document.querySelector('.lang-option'), 'ArrowDown');
    expect(ev.defaultPrevented).toBe(false);
  });
});

describe('Échap', () => {
  test('menu mobile ouvert, focus sur un lien : le focus revient au bouton Menu (A11Y-009)', () => {
    loadNav();
    const burger = document.querySelector('.hamburger');
    burger.click();
    const link = document.querySelector('.nav-links a');
    link.focus();
    keydown(document.body, 'Escape');
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(false);
    expect(document.activeElement).toBe(burger);
  });

  test('autre touche : rien ne se ferme', () => {
    loadNav();
    document.querySelector('.hamburger').click();
    keydown(document.body, 'Enter');
    expect(document.querySelector('.nav-links').classList.contains('show')).toBe(true);
  });
});

describe('attente de la session', () => {
  test('met à jour l’en-tête quand auth émet « vh:auth-ready » (JS-008)', () => {
    loadNav();
    const header = document.querySelector('header');
    expect(header.classList.contains('is-auth')).toBe(false);
    auth.getPayload.mockReturnValue({ id: 2, name: 'Grace', role: 2 });
    // Plus de sondage : rien ne change tant que l'événement n'est pas émis.
    jest.advanceTimersByTime(500);
    expect(header.classList.contains('is-auth')).toBe(false);
    document.dispatchEvent(new window.CustomEvent('vh:auth-ready'));
    expect(header.classList.contains('is-auth')).toBe(true);
  });

  test('session déjà initialisée au chargement de nav.js : en-tête mis à jour tout de suite', () => {
    auth.isReady = jest.fn(() => true);
    auth.getPayload.mockReturnValue({ id: 2, name: 'Grace', role: 2 });
    loadNav();
    expect(document.querySelector('header').classList.contains('is-auth')).toBe(true);
    delete auth.isReady;
  });

  test('abandon après 5 s sans session', () => {
    loadNav();
    jest.advanceTimersByTime(5000);
    auth.getPayload.mockClear();
    jest.advanceTimersByTime(1000);
    expect(auth.getPayload).not.toHaveBeenCalled();
  });
});

describe('lien d’évitement (A11Y-004)', () => {
  test('pose le focus sur le contenu principal sans suivre l’ancre', () => {
    loadNav('<header><a href="#main-content" class="skip-link">Aller au contenu</a></header><main id="main-content"><p>x</p></main>');
    const main = document.getElementById('main-content');
    main.scrollIntoView = jest.fn();
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true });
    document.querySelector('.skip-link').dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(true);
    expect(main.getAttribute('tabindex')).toBe('-1');
    expect(document.activeElement).toBe(main);
    expect(main.scrollIntoView).toHaveBeenCalled();
  });

  test('sans contenu principal, le lien garde son comportement natif', () => {
    loadNav('<header><a href="#main-content" class="skip-link">Aller au contenu</a></header>');
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true });
    document.querySelector('.skip-link').dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(false);
  });
});
