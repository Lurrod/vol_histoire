/**
 * Tests — petites pages et scripts communs :
 *   - js/check-email.js (renvoi du lien de vérification) ;
 *   - js/404.js (route demandée affichée) ;
 *   - js/sw-register.js (enregistrement du service worker) ;
 *   - js/shared/alpha3.js (drapeaux : tous les pays de db.sql couverts) ;
 *   - js/app-version.js (version injectée par le build).
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const mainOf = (file) => /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(ROOT, file), 'utf8'))[0];
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };
const $ = (id) => document.getElementById(id);

afterEach(() => {
  window.history.replaceState(null, '', '/');
  jest.restoreAllMocks();
});

// =============================================================================
// check-email.js
// =============================================================================
describe('check-email.js', () => {
  function load(search) {
    window.history.replaceState(null, '', `/check-email${search}`);
    document.body.innerHTML = mainOf('check-email.html');
    global.i18n = { t: (k) => k };
    global.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: true })) };
    jest.isolateModules(() => { require('../js/check-email'); });
  }

  test('affiche l’adresse de l’URL comme texte, jamais comme HTML', () => {
    load(`?email=${encodeURIComponent('<img src=x onerror=alert(1)>@x.fr')}`);
    expect($('ce-email').textContent).toBe('<img src=x onerror=alert(1)>@x.fr');
    expect($('ce-email').querySelector('img')).toBeNull();
  });

  test('sans adresse : badge par défaut, le bouton ne fait rien', async () => {
    load('');
    const before = $('ce-email').textContent;
    $('ce-resend-btn').click();
    await flush();
    expect($('ce-email').textContent).toBe(before);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    expect($('ce-resend-btn').disabled).toBe(false);
  });

  test('renvoi réussi : appel POST, bouton désactivé et marqué « envoyé »', async () => {
    load('?email=ada%40test.local');
    $('ce-resend-btn').click();
    expect($('ce-resend-btn').disabled).toBe(true);
    await flush();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/auth/resend-verification', expect.objectContaining({ method: 'POST' }));
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ email: 'ada@test.local' });
    expect($('ce-resend-btn').classList.contains('sent')).toBe(true);
    expect($('ce-resend-btn').textContent.trim()).toBe('check_email.resent');
    expect($('ce-resend-btn').disabled).toBe(true); // un seul renvoi par visite
  });

  test('échec réseau : bouton réactivé pour réessayer', async () => {
    load('?email=ada%40test.local');
    auth.fetchWithTimeout.mockRejectedValue(new TypeError('Failed to fetch'));
    $('ce-resend-btn').click();
    await flush();
    expect($('ce-resend-btn').disabled).toBe(false);
    expect($('ce-resend-btn').classList.contains('sent')).toBe(false);
    expect($('ce-resend-btn').textContent.trim()).toBe('check_email.resend');
  });
});

// =============================================================================
// 404.js
// =============================================================================
describe('404.js', () => {
  function run(html) {
    document.body.innerHTML = html;
    const ready = [];
    jest.spyOn(document, 'addEventListener').mockImplementation((type, fn) => { if (type === 'DOMContentLoaded') ready.push(fn); });
    jest.isolateModules(() => { require('../js/404'); });
    document.addEventListener.mockRestore();
    ready.forEach((fn) => fn());
  }

  test('affiche la route demandée dans le panneau télémétrie (texte brut)', () => {
    window.history.replaceState(null, '', '/hangar/%3Cb%3Ex%3C/b%3E');
    run(mainOf('404.html'));
    expect($('requested-path').textContent).toBe('/hangar/%3Cb%3Ex%3C/b%3E');
    expect($('requested-path').querySelector('b')).toBeNull();
  });

  test('page sans panneau : rien ne casse', () => {
    expect(() => run('<main></main>')).not.toThrow();
  });
});

// =============================================================================
// sw-register.js
// =============================================================================
describe('sw-register.js', () => {
  const desc = {
    sw: Object.getOwnPropertyDescriptor(window.navigator, 'serviceWorker'),
    connection: Object.getOwnPropertyDescriptor(window.navigator, 'connection'),
  };
  let register;

  function setNavigator({ sw = true, saveData = false } = {}) {
    register = jest.fn(() => Promise.resolve({ waiting: null, addEventListener: jest.fn() }));
    if (sw) {
      Object.defineProperty(window.navigator, 'serviceWorker', {
        configurable: true,
        value: { register, controller: null, addEventListener: jest.fn() },
      });
    } else {
      delete window.navigator.serviceWorker;
    }
    Object.defineProperty(window.navigator, 'connection', { configurable: true, value: saveData ? { saveData: true } : undefined });
  }

  function run({ readyState = 'complete' } = {}) {
    Object.defineProperty(document, 'readyState', { configurable: true, get: () => readyState });
    try {
      // Sous Jest le module s'exporte au lieu de démarrer : boot() est ce que
      // le navigateur exécute (voir aussi __tests__/sw-register.test.js).
      jest.isolateModules(() => { require('../js/sw-register').boot(window, document); });
    } finally {
      delete document.readyState;
    }
  }

  afterEach(() => {
    delete window.navigator.serviceWorker;
    delete window.navigator.connection;
    if (desc.sw) Object.defineProperty(window.navigator, 'serviceWorker', desc.sw);
    if (desc.connection) Object.defineProperty(window.navigator, 'connection', desc.connection);
  });

  test('page chargée, sur localhost : enregistre /sw.js à la racine', () => {
    setNavigator();
    run();
    expect(register).toHaveBeenCalledWith('/sw.js', { scope: '/' });
  });

  test('page en cours de chargement : attend l’événement load (une fois)', () => {
    setNavigator();
    const add = jest.spyOn(window, 'addEventListener');
    run({ readyState: 'interactive' });
    expect(register).not.toHaveBeenCalled();
    const [type, fn, opts] = add.mock.calls.find(([t]) => t === 'load');
    expect([type, opts]).toEqual(['load', { once: true }]);
    fn();
    expect(register).toHaveBeenCalledTimes(1);
  });

  test('mode économie de données : pas de service worker', () => {
    setNavigator({ saveData: true });
    run();
    expect(register).not.toHaveBeenCalled();
  });

  test('navigateur sans service worker : rien', () => {
    setNavigator({ sw: false });
    expect(() => run()).not.toThrow();
  });

  test('échec de l’enregistrement : silencieux', async () => {
    setNavigator();
    register.mockReturnValue(Promise.reject(new Error('SecurityError')));
    run();
    await flush();
    expect(register).toHaveBeenCalled();
  });
});

// =============================================================================
// shared/alpha3.js
// =============================================================================
describe('shared/alpha3.js — drapeaux', () => {
  require('../js/shared/alpha3');
  const map = window.VH.shared.ALPHA3_TO_ALPHA2;
  const dbSql = fs.readFileSync(path.join(ROOT, '..', 'backend', 'db_backup', 'db.sql'), 'utf8');
  const block = /INSERT INTO countries \(name, name_en, code\) VALUES([\s\S]*?);/.exec(dbSql)[1];
  const codes = Array.from(block.matchAll(/'([A-Z]{3})'\)/g), (m) => m[1]);

  test('db.sql déclare bien des pays (le motif de lecture tient)', () => {
    expect(codes.length).toBeGreaterThanOrEqual(42);
  });

  test('chaque code pays de db.sql a son code alpha-2 (sinon drapeau absent en silence)', () => {
    expect(codes.filter((c) => !map[c])).toEqual([]);
  });

  test('chaque code alpha-2 a son fichier dans assets/flags', () => {
    const missing = Object.values(map).filter((a2) => !fs.existsSync(path.join(ROOT, 'assets', 'flags', `${a2}.png`)));
    expect(missing).toEqual([]);
  });

  test('les deux codes coréens mènent au même drapeau, les entités disparues à leur successeur', () => {
    expect(map.KOR).toBe('kr');
    expect(map.ROK).toBe('kr');
    expect(map.CSK).toBe('cz');
    expect(map.YUG).toBe('rs');
  });
});

// =============================================================================
// app-version.js
// =============================================================================
describe('app-version.js', () => {
  test('expose une version semver sur window.APP_VERSION', () => {
    delete window.APP_VERSION;
    jest.isolateModules(() => { require('../js/app-version'); });
    expect(window.APP_VERSION).toMatch(/^\d+\.\d+\.\d+$/);
  });
});
