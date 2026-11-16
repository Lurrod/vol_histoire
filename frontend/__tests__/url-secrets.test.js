/**
 * Tests — paramètres sensibles retirés de l'URL (audit 2026-11-16) :
 * un jeton de réinitialisation ou d'activation, une adresse email ne doivent
 * rester ni dans la barre d'adresse, ni dans l'historique, ni dans ce que
 * GTM ou Sentry pourraient lire de window.location.
 */
const fs = require('fs');
const path = require('path');
const { takeUrlParams, isValidPassword, calculatePasswordStrength } = require('../js/utils');

const ROOT = path.join(__dirname, '..');
const mainOf = (file) => /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(ROOT, file), 'utf8'))[0];
const here = () => window.location.pathname + window.location.search + window.location.hash;

beforeEach(() => {
  global.takeUrlParams = takeUrlParams;
  global.isValidPassword = isValidPassword;
  global.calculatePasswordStrength = calculatePasswordStrength;
  global.setupPasswordToggle = jest.fn();
  global.i18n = { t: (k) => k };
  global.auth = { fetchWithTimeout: jest.fn(), clearSession: jest.fn() };
});
afterEach(() => {
  jest.restoreAllMocks();
  window.history.replaceState(null, '', '/');
  delete global.takeUrlParams;
  try { sessionStorage.clear(); } catch { /* indisponible */ }
});

describe('takeUrlParams', () => {
  test('renvoie les valeurs puis les retire de l’URL, en gardant le reste', () => {
    window.history.replaceState({ k: 1 }, '', '/reset-password?lang=en&token=abc#x');
    expect(takeUrlParams(['token'])).toEqual({ token: 'abc' });
    expect(here()).toBe('/reset-password?lang=en#x');
    expect(window.history.state).toEqual({ k: 1 });
  });

  test('paramètre absent : null, URL et historique inchangés', () => {
    window.history.replaceState(null, '', '/reset-password?lang=en');
    const spy = jest.spyOn(window.history, 'replaceState');
    expect(takeUrlParams(['token'])).toEqual({ token: null });
    expect(spy).not.toHaveBeenCalled();
    expect(here()).toBe('/reset-password?lang=en');
  });

  test('plusieurs noms, dernier « ? » retiré quand il ne reste rien', () => {
    window.history.replaceState(null, '', '/verify-email?token=t1&email=a%40b.fr');
    expect(takeUrlParams(['token', 'email'])).toEqual({ token: 't1', email: 'a@b.fr' });
    expect(here()).toBe('/verify-email');
  });

  test('replaceState qui lève : la valeur est quand même rendue', () => {
    window.history.replaceState(null, '', '/reset-password?token=abc');
    jest.spyOn(window.history, 'replaceState').mockImplementation(() => { throw new Error('SecurityError'); });
    expect(takeUrlParams(['token'])).toEqual({ token: 'abc' });
  });
});

describe('pages qui reçoivent un jeton ou une adresse', () => {
  test('reset-password : jeton retiré de l’URL, mais toujours envoyé à l’API', async () => {
    window.history.replaceState(null, '', '/reset-password?token=secret-tok');
    document.body.innerHTML = mainOf('reset-password.html');
    jest.isolateModules(() => { require('../js/reset-password'); });
    expect(here()).toBe('/reset-password');

    auth.fetchWithTimeout.mockResolvedValue({ ok: true, json: () => Promise.resolve({}) });
    document.getElementById('rp-password').value = 'Abcdefgh1';
    document.getElementById('rp-password-confirm').value = 'Abcdefgh1';
    document.getElementById('rp-form').dispatchEvent(new Event('submit', { cancelable: true }));
    await Promise.resolve();
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body).token).toBe('secret-tok');
  });

  test('verify-email : jeton retiré, type=email conservé (non sensible)', async () => {
    window.history.replaceState(null, '', '/verify-email?type=email&token=secret-tok');
    document.body.innerHTML = mainOf('verify-email.html');
    auth.fetchWithTimeout.mockResolvedValue({ ok: true, json: () => Promise.resolve({}) });
    jest.isolateModules(() => { require('../js/verify-email'); });
    document.dispatchEvent(new Event('DOMContentLoaded'));
    await Promise.resolve();
    expect(here()).toBe('/verify-email?type=email');
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ token: 'secret-tok' });
  });

  test('check-email : adresse lue en sessionStorage, jamais dans l’URL', () => {
    sessionStorage.setItem('vh_pending_email', 'ada@test.local');
    window.history.replaceState(null, '', '/check-email');
    document.body.innerHTML = mainOf('check-email.html');
    jest.isolateModules(() => { require('../js/check-email'); });
    expect(document.getElementById('ce-email').textContent).toBe('ada@test.local');
  });

  test('check-email : ancien lien ?email= encore lu, puis retiré et mémorisé', () => {
    window.history.replaceState(null, '', '/check-email?email=ada%40test.local');
    document.body.innerHTML = mainOf('check-email.html');
    jest.isolateModules(() => { require('../js/check-email'); });
    expect(document.getElementById('ce-email').textContent).toBe('ada@test.local');
    expect(here()).toBe('/check-email');
    expect(sessionStorage.getItem('vh_pending_email')).toBe('ada@test.local');
  });
});

describe('les pages à jeton ne chargent pas GTM', () => {
  test.each(['reset-password.html', 'verify-email.html', 'check-email.html'])('%s', (file) => {
    const html = fs.readFileSync(path.join(ROOT, file), 'utf8');
    expect(html).not.toMatch(/js\/gtm\.js/);
  });
});
