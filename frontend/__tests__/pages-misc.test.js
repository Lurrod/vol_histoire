/**
 * Tests — petites pages et scripts communs :
 *   - js/404.js (mots de l'adresse manquante, recherche préremplie) ;
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

  test('préremplit la recherche avec les mots de l’adresse', () => {
    window.history.replaceState(null, '', '/hangar/rafal');
    run(mainOf('404.html'));
    expect($('e4-q').value).toBe('rafal');
  });

  test('fiche : retire l’identifiant et les mots vides', () => {
    window.history.replaceState(null, '', '/details/mirage-2000-c-14');
    run(mainOf('404.html'));
    expect($('e4-q').value).toBe('mirage 2000 c');
  });

  test('/404 lui-même : recherche laissée vide', () => {
    window.history.replaceState(null, '', '/404');
    run(mainOf('404.html'));
    expect($('e4-q').value).toBe('');
  });

  test('queryFromPath : adresse mal encodée lue telle quelle, extension retirée', () => {
    run('<main></main>');
    const { queryFromPath } = window.VH.e404;
    expect(queryFromPath('/hangar/%E0%A4%A')).toBe('%E0%A4%A');
    expect(queryFromPath('/conflits/guerre-du-golfe.html')).toBe('guerre golfe');
    expect(queryFromPath('/')).toBe('');
  });

  test('page sans champ de recherche : rien ne casse', () => {
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

  // jsdom tourne sur http://localhost, où le service worker n'est plus
  // enregistré (développement) : la page est simulée sur le site en HTTPS.
  const SITE = { protocol: 'https:', hostname: 'vol-histoire.titouan-borde.com', href: 'https://vol-histoire.titouan-borde.com/' };

  function run({ readyState = 'complete', location = SITE } = {}) {
    Object.defineProperty(document, 'readyState', { configurable: true, get: () => readyState });
    const win = {
      navigator: window.navigator,
      location,
      addEventListener: (...args) => window.addEventListener(...args),
    };
    try {
      // Sous Jest le module s'exporte au lieu de démarrer : boot() est ce que
      // le navigateur exécute (voir aussi __tests__/sw-register.test.js).
      jest.isolateModules(() => { require('../js/sw-register').boot(win, document); });
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

  test('page chargée, en HTTPS : enregistre /sw.js à la racine', () => {
    setNavigator();
    run();
    expect(register).toHaveBeenCalledWith('/sw.js', { scope: '/' });
  });

  test('sur localhost (développement) : aucun service worker', () => {
    setNavigator();
    run({ location: { protocol: 'http:', hostname: 'localhost', href: 'http://localhost:3000/' } });
    expect(register).not.toHaveBeenCalled();
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
