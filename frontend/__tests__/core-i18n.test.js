/**
 * Tests — frontend/js/i18n.js : détection de la langue, chargement des
 * locales, application au DOM, balises SEO (canonical / hreflang), menu de
 * langue et rechargement des pages à données.
 *
 * i18n.js s'initialise dès son chargement : chaque test le recharge isolé
 * (jest.isolateModules), avec un fetch simulé qui sert les vraies locales.
 */
const fs = require('fs');
const path = require('path');

const LOCALES = {
  fr: JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'locales', 'fr.json'), 'utf8')),
  en: JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'locales', 'en.json'), 'utf8')),
};
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };

function serveLocales() {
  global.fetch = jest.fn((url) => {
    const m = /locales\/(\w+)\.json$/.exec(url);
    return Promise.resolve(m && LOCALES[m[1]]
      ? { ok: true, json: () => Promise.resolve(LOCALES[m[1]]) }
      : { ok: false, status: 404, json: () => Promise.resolve({}) });
  });
}

const docListeners = [];
let addSpy;

/** Charge i18n.js isolé et attend la fin de son init(). */
async function loadI18n({ url = '/', navLang = 'fr-FR' } = {}) {
  window.history.replaceState(null, '', url);
  Object.defineProperty(window.navigator, 'language', { configurable: true, get: () => navLang });
  let mod;
  jest.isolateModules(() => { mod = require('../js/i18n'); });
  await flush();
  return mod;
}

beforeEach(() => {
  localStorage.clear();
  document.head.innerHTML = '';
  document.body.innerHTML = '';
  serveLocales();
  delete global.DOMPurify;
  addSpy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    docListeners.push([type, fn, opts]);
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
});

afterEach(() => {
  addSpy.mockRestore();
  docListeners.splice(0).forEach(([type, fn, opts]) => document.removeEventListener(type, fn, opts));
  jest.useRealTimers();
  window.history.replaceState(null, '', '/');
});

// =============================================================================
// Détection de la langue
// =============================================================================
describe('détection de la langue', () => {
  test('?lang=en prime sur tout et se mémorise', async () => {
    localStorage.setItem('vol-histoire-lang', 'fr');
    const i18n = await loadI18n({ url: '/hangar?lang=en' });
    expect(i18n.currentLang).toBe('en');
    expect(localStorage.getItem('vol-histoire-lang')).toBe('en');
  });

  test('?lang= non supportée : ignorée, choix mémorisé utilisé', async () => {
    localStorage.setItem('vol-histoire-lang', 'en');
    const i18n = await loadI18n({ url: '/?lang=de' });
    expect(i18n.currentLang).toBe('en');
  });

  test('valeur mémorisée invalide : langue du navigateur', async () => {
    localStorage.setItem('vol-histoire-lang', 'xx');
    const i18n = await loadI18n({ navLang: 'en-GB' });
    expect(i18n.currentLang).toBe('en');
  });

  test('navigateur dans une langue non gérée : français par défaut, rien de mémorisé', async () => {
    const i18n = await loadI18n({ navLang: 'de-DE' });
    expect(i18n.currentLang).toBe('fr');
    expect(localStorage.getItem('vol-histoire-lang')).toBeNull();
  });

  test('navigator.language absent : français', async () => {
    const i18n = await loadI18n({ navLang: undefined });
    expect(i18n.currentLang).toBe('fr');
  });

  test('exposé sur window.i18n (les modules testent window.i18n)', async () => {
    const i18n = await loadI18n();
    expect(window.i18n).toBe(i18n);
    expect(i18n.isLoaded).toBe(true);
  });
});

// =============================================================================
// Chargement des locales
// =============================================================================
describe('chargement des locales', () => {
  test('chemin déduit de la balise <script> d’i18n.js', async () => {
    document.head.innerHTML = '<script src="http://localhost/base/js/i18n.js?v=1"></script>';
    await loadI18n();
    expect(global.fetch).toHaveBeenCalledWith('http://localhost/base/locales/fr.json');
  });

  test('locale introuvable (404) : les clés sont rendues telles quelles', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 404 }));
    const i18n = await loadI18n();
    expect(i18n.t('nav.home')).toBe('nav.home');
    expect(i18n.isLoaded).toBe(true);
  });

  test('t() : interpolation des paramètres et de {year}', async () => {
    const i18n = await loadI18n();
    expect(i18n.t('nav.home')).toBe(LOCALES.fr.nav.home);
    // Clé dont la valeur n'est pas une chaîne : renvoyée telle quelle.
    expect(typeof i18n.t('nav')).toBe('object');
    expect(i18n.t('footer.copyright')).toBe(`© ${new Date().getFullYear()} Vol d'Histoire. Tous droits réservés.`);
    expect(i18n.t('hangar.results', { count: 5 })).toBe('5 avions trouvés');
    // {year} passé explicitement : la valeur fournie l'emporte.
    expect(i18n.t('conflicts.since', { year: 1947 })).toBe('depuis 1947');
  });
});

// =============================================================================
// applyToDOM
// =============================================================================
describe('applyToDOM', () => {
  test('texte, icône conservée, placeholder, aria-label, <title>, html lang', async () => {
    document.head.innerHTML = '<title data-i18n="nav.home">Accueil</title>';
    document.body.innerHTML = `
      <span id="t" data-i18n="nav.home">x</span>
      <a id="i" data-i18n="nav.hangar"><i class="fas fa-plane"></i> x</a>
      <input id="p" data-i18n-placeholder="nav.home" placeholder="x">
      <button id="a" data-i18n-aria="nav.home" aria-label="x"></button>`;
    const i18n = await loadI18n({ url: '/?lang=en' });
    const en = LOCALES.en.nav;

    expect(document.getElementById('t').textContent).toBe(en.home);
    const link = document.getElementById('i');
    expect(link.querySelector('i.fa-plane')).not.toBeNull();
    expect(link.textContent.trim()).toBe(en.hangar);
    expect(document.getElementById('p').placeholder).toBe(en.home);
    expect(document.getElementById('a').getAttribute('aria-label')).toBe(en.home);
    expect(document.title).toBe(en.home);
    expect(document.documentElement.lang).toBe('en');
    expect(i18n.currentLang).toBe('en');
  });

  test('<title> : traduction absente (locales non chargées) → titre du serveur conservé', async () => {
    document.head.innerHTML = '<title data-i18n="details.title">Titre serveur | Vol d\'Histoire</title>';
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 503, json: () => Promise.resolve({}) }));
    await loadI18n({ url: '/?lang=en' });
    expect(document.title).toBe('Titre serveur | Vol d\'Histoire');
  });

  test('[data-i18n-html] sans DOMPurify : tout le balisage est échappé (repli sûr)', async () => {
    const i18n = await loadI18n();
    i18n.applyToDOM(); // sans effet sur un DOM vide
    global.fetch = jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ k: { html: '<b>gras</b><img src=x onerror=alert(1)>' } }) }));
    await i18n.setLang('fr');
    document.body.innerHTML = '<p data-i18n-html="k.html">x</p><p data-i18n-html="k.absente">garde</p>';
    i18n.applyToDOM();
    const [p, kept] = document.querySelectorAll('p');
    expect(p.querySelector('b, img')).toBeNull();
    expect(p.textContent).toBe('<b>gras</b><img src=x onerror=alert(1)>');
    expect(kept.textContent).toBe('garde');
  });

  test('bouton de langue et option active du menu', async () => {
    document.body.innerHTML = `
      <button id="lang-toggle"></button>
      <button class="lang-option" data-lang="fr"></button>
      <button class="lang-option" data-lang="en"></button>`;
    await loadI18n();
    expect(document.getElementById('lang-toggle').getAttribute('aria-label')).toBe('Switch to English');
    const [fr, en] = document.querySelectorAll('.lang-option');
    expect(fr.classList.contains('active')).toBe(true);
    expect(en.classList.contains('active')).toBe(false);
  });

  test('applyToDOM(root) limite la traduction à la racine donnée', async () => {
    const i18n = await loadI18n();
    document.body.innerHTML = '<div id="in"><span data-i18n="nav.home">x</span></div><span id="out" data-i18n="nav.home">x</span>';
    i18n.applyToDOM(document.getElementById('in'));
    expect(document.querySelector('#in span').textContent).toBe(LOCALES.fr.nav.home);
    expect(document.getElementById('out').textContent).toBe('x');
  });

  /*
   * Régression (settings.html) — le <strong id="consent-date"> vivait DANS le
   * <span data-i18n="settings.last_modified"> : applyToDOM remplaçait le
   * textContent du span et la date disparaissait du DOM. Il en est sorti.
   */
  test('settings.html : la date de consentement survit à la traduction', async () => {
    const html = fs.readFileSync(path.join(__dirname, '..', 'settings.html'), 'utf8');
    const fragment = /<div class="consent-date">[\s\S]*?<\/div>/.exec(html)[0];
    document.body.innerHTML = fragment;
    await loadI18n();
    const date = document.getElementById('consent-date');
    expect(date).not.toBeNull();
    expect(date.textContent).toBe(LOCALES.fr.settings.never);
    expect(document.querySelector('[data-i18n="settings.last_modified"]').textContent)
      .toBe(LOCALES.fr.settings.last_modified);
  });
});

// =============================================================================
// Balises SEO
// =============================================================================
describe('URL, canonical et hreflang (SEO-002)', () => {
  const HEAD = `
      <link rel="canonical" href="https://vol-histoire.example/hangar">
      <link rel="alternate" hreflang="fr" href="https://vol-histoire.example/hangar">
      <link rel="alternate" hreflang="en" href="https://vol-histoire.example/hangar?lang=en">
      <link rel="alternate" hreflang="x-default" href="https://vol-histoire.example/hangar">`;
  const snapshot = () => Array.from(document.querySelectorAll('link[rel="canonical"], link[hreflang]'))
    .map((l) => l.outerHTML).join('');

  test('langue détectée (navigateur) : ni l’URL, ni la canonical, ni les hreflang ne bougent', async () => {
    document.head.innerHTML = HEAD;
    const before = snapshot();
    const i18n = await loadI18n({ url: '/hangar?country=France', navLang: 'en-US' });
    expect(i18n.currentLang).toBe('en');
    expect(window.location.search).toBe('?country=France');
    expect(snapshot()).toBe(before);
  });

  test('?lang= présent : conservé tel quel, balises du serveur intactes', async () => {
    document.head.innerHTML = HEAD;
    const before = snapshot();
    await loadI18n({ url: '/hangar?lang=en' });
    expect(window.location.search).toBe('?lang=en');
    expect(snapshot()).toBe(before);
  });

  test('choix explicite (setLang) : ?lang= dans l’URL, canonical et hreflang intacts', async () => {
    document.head.innerHTML = HEAD;
    const before = snapshot();
    jest.useFakeTimers();
    const i18n = await loadI18n({ url: '/contact?x=1' });
    await i18n.setLang('en');
    expect(window.location.search).toBe('?x=1&lang=en');
    expect(snapshot()).toBe(before);
  });
});

// =============================================================================
// setLang
// =============================================================================
describe('setLang', () => {
  test('change la langue, la mémorise, retraduit et émet langChanged', async () => {
    document.body.innerHTML = '<span data-i18n="nav.home">x</span>';
    const i18n = await loadI18n({ url: '/login' });
    const onChange = jest.fn();
    window.addEventListener('langChanged', onChange);
    await i18n.setLang('en');
    window.removeEventListener('langChanged', onChange);

    expect(i18n.currentLang).toBe('en');
    expect(localStorage.getItem('vol-histoire-lang')).toBe('en');
    expect(document.querySelector('span').textContent).toBe(LOCALES.en.nav.home);
    expect(onChange.mock.calls[0][0].detail).toEqual({ lang: 'en' });
  });

  test.each([
    ['/', true], ['/hangar', true], ['/details/rafale-30', true], ['/favorites', true],
    ['/timeline', true], ['/conflits/guerre-du-golfe', true],
    ['/login', false], ['/settings', false], ['/cgu', false],
  ])('page %s : rechargement programmé = %s', async (url, reload) => {
    const i18n = await loadI18n({ url });
    jest.useFakeTimers();
    await i18n.setLang('en');
    expect(jest.getTimerCount()).toBe(reload ? 1 : 0);
  });

  test('même langue qu’avant : pas de rechargement', async () => {
    const i18n = await loadI18n({ url: '/hangar' });
    jest.useFakeTimers();
    await i18n.setLang('fr');
    expect(jest.getTimerCount()).toBe(0);
  });

  test('langue non gérée : ignorée', async () => {
    const i18n = await loadI18n();
    global.fetch.mockClear();
    await i18n.setLang('de');
    expect(i18n.currentLang).toBe('fr');
    expect(global.fetch).not.toHaveBeenCalled();
  });
});

// =============================================================================
// Menu de langue
// =============================================================================
describe('menu de langue', () => {
  const MENU = `
    <div class="lang-switch">
      <button id="lang-toggle" aria-expanded="false"></button>
      <ul id="lang-dropdown">
        <li><a href="#" class="lang-option" data-lang="fr">FR</a></li>
        <li><a href="#" class="lang-option" data-lang="en">EN</a></li>
        <li><a href="#" class="lang-option">?</a></li>
      </ul>
    </div>
    <p id="dehors">ailleurs</p>`;

  const click = (el) => {
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true });
    el.dispatchEvent(ev);
    return ev;
  };

  test('le bouton ouvre puis referme la liste (aria-expanded suivi)', async () => {
    document.body.innerHTML = MENU;
    await loadI18n({ url: '/login' });
    const toggle = document.getElementById('lang-toggle');
    const sw = document.querySelector('.lang-switch');

    expect(click(toggle).defaultPrevented).toBe(true);
    expect(sw.classList.contains('open')).toBe(true);
    expect(toggle.getAttribute('aria-expanded')).toBe('true');
    click(toggle);
    expect(sw.classList.contains('open')).toBe(false);
    expect(toggle.getAttribute('aria-expanded')).toBe('false');
  });

  test('choisir une option change la langue et referme la liste', async () => {
    document.body.innerHTML = MENU;
    const i18n = await loadI18n({ url: '/login' });
    click(document.getElementById('lang-toggle'));
    click(document.querySelector('.lang-option[data-lang="en"]'));
    await flush();
    expect(i18n.currentLang).toBe('en');
    expect(document.querySelector('.lang-switch').classList.contains('open')).toBe(false);
    expect(document.getElementById('lang-toggle').getAttribute('aria-expanded')).toBe('false');
  });

  test('option sans data-lang : liste refermée, langue inchangée', async () => {
    document.body.innerHTML = MENU;
    const i18n = await loadI18n({ url: '/login' });
    click(document.getElementById('lang-toggle'));
    click(document.querySelector('.lang-option:not([data-lang])'));
    expect(i18n.currentLang).toBe('fr');
    expect(document.querySelector('.lang-switch').classList.contains('open')).toBe(false);
  });

  test('clic à l’extérieur : la liste ouverte se referme', async () => {
    document.body.innerHTML = MENU;
    await loadI18n({ url: '/login' });
    click(document.getElementById('lang-toggle'));
    click(document.getElementById('dehors'));
    expect(document.querySelector('.lang-switch').classList.contains('open')).toBe(false);
    expect(document.getElementById('lang-toggle').getAttribute('aria-expanded')).toBe('false');
  });

  test('page sans sélecteur de langue : les clics ne lèvent pas', async () => {
    document.body.innerHTML = '<button id="lang-toggle"></button><a class="lang-option" data-lang="fr">FR</a><p id="x"></p>';
    await loadI18n({ url: '/login' });
    expect(() => {
      click(document.getElementById('lang-toggle'));
      click(document.querySelector('.lang-option'));
      click(document.getElementById('x'));
    }).not.toThrow();
    expect(document.getElementById('lang-toggle').getAttribute('aria-expanded')).toBe('false');
  });
});

// =============================================================================
// Démarrage
// =============================================================================
describe('démarrage', () => {
  test('document encore en chargement : init attend DOMContentLoaded', async () => {
    Object.defineProperty(document, 'readyState', { configurable: true, get: () => 'loading' });
    let i18n;
    try {
      i18n = await loadI18n();
    } finally {
      delete document.readyState;
    }
    expect(global.fetch).not.toHaveBeenCalled();
    expect(i18n.isLoaded).toBe(false);
    document.dispatchEvent(new Event('DOMContentLoaded'));
    await flush();
    expect(i18n.isLoaded).toBe(true);
  });
});
