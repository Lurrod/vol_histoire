/**
 * Tests — bibliothèques de frontend/js/vendor/ (JS-009).
 *
 * vendor/ est produit par scripts/build-js.js depuis frontend/node_modules
 * (dompurify et @sentry/browser en devDependencies). On charge les fichiers
 * RÉELLEMENT servis, comme le ferait un <script>, et on vérifie qu'ils
 * fonctionnent avec le code qui les consomme : safeSetHTML (utils.js) et
 * sentry-init.js (window.Sentry.init / captureException).
 */

const fs = require('fs');
const path = require('path');

const VENDOR = path.join(__dirname, '..', 'js', 'vendor');

/** Exécute un script classique dans la portée globale de jsdom. */
function loadScript(file) {
  const code = fs.readFileSync(path.join(VENDOR, file), 'utf8');
  // eval indirect = portée globale, comme un <script> classique : un `var` de
  // premier niveau (var Sentry = …) devient une propriété de window, et
  // module / exports (propres au wrapper de Jest) n'y sont pas visibles.
  (0, eval)(code);
}

function packageVersion(name) {
  return JSON.parse(fs.readFileSync(
    path.join(__dirname, '..', 'node_modules', ...name.split('/'), 'package.json'), 'utf8')).version;
}

describe('vendor/purify.min.js', () => {
  beforeAll(() => {
    delete window.DOMPurify;
    loadScript('purify.min.js');
  });

  test('est la version déclarée dans frontend/package.json', () => {
    const banner = fs.readFileSync(path.join(VENDOR, 'purify.min.js'), 'utf8').slice(0, 200);
    expect(banner).toContain(`DOMPurify ${packageVersion('dompurify')}`);
    expect(window.DOMPurify.version).toBe(packageVersion('dompurify'));
  });

  test('safeSetHTML délègue au vrai DOMPurify et désarme le XSS', () => {
    global.DOMPurify = window.DOMPurify;
    const { safeSetHTML } = require('../js/utils');
    const el = document.createElement('div');
    safeSetHTML(el, '<p class="ok" data-i18n="k">Texte</p><img src="x" onerror="alert(1)">'
      + '<script>alert(2)</script><a href="javascript:alert(3)">lien</a>');
    expect(el.querySelector('p.ok').getAttribute('data-i18n')).toBe('k');
    expect(el.querySelector('img').hasAttribute('onerror')).toBe(false);
    expect(el.querySelector('script')).toBeNull();
    expect(el.querySelector('a').getAttribute('href')).toBeNull();
    delete global.DOMPurify;
  });
});

describe('vendor/sentry.min.js', () => {
  beforeAll(() => {
    delete window.Sentry;
    loadScript('sentry.min.js');
  });

  test('expose window.Sentry.init et captureException, à la version déclarée dans frontend/package.json', () => {
    expect(typeof window.Sentry.init).toBe('function');
    expect(typeof window.Sentry.captureException).toBe('function');
    const banner = fs.readFileSync(path.join(VENDOR, 'sentry.min.js'), 'utf8').slice(0, 200);
    const version = packageVersion('@sentry/browser');
    expect(banner).toContain(`@sentry/browser ${version}`);
  });

  test('une exception capturée part avec la release passée par sentry-init', async () => {
    const sent = [];
    window.Sentry.init({
      dsn: 'https://cle@exemple.invalid/1',
      release: '4.13.1',
      environment: 'test',
      transport: () => ({
        send: (envelope) => { sent.push(envelope); return Promise.resolve({}); },
        flush: () => Promise.resolve(true),
      }),
    });
    window.Sentry.captureException(new Error('boum'));
    await new Promise((r) => setTimeout(r, 50));
    // Enveloppes : session (au démarrage) puis événement — on cherche ce dernier.
    const eventItem = sent.flatMap(([, items]) => items).find(([header]) => header.type === 'event');
    expect(eventItem).toBeDefined();
    const event = eventItem[1];
    expect(event.release).toBe('4.13.1');
    expect(event.exception.values[0].value).toBe('boum');
  });
});

describe('app-version.js', () => {
  test('porte la version du package.json racine (générée par build-js.js)', () => {
    const rootPkg = JSON.parse(fs.readFileSync(path.join(__dirname, '..', '..', 'package.json'), 'utf8'));
    const src = fs.readFileSync(path.join(__dirname, '..', 'js', 'app-version.js'), 'utf8');
    expect(src).toContain(`window.APP_VERSION = ${JSON.stringify(rootPkg.version)};`);
  });
});
