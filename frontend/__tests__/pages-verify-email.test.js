/**
 * Tests — frontend/js/verify-email.js sur le vrai <main> de verify-email.html.
 *
 *   /verify-email?token=…            activation : le titulaire de la boîte
 *                                    choisit ici son mot de passe ;
 *   /verify-email?type=email&token=… confirmation d'un changement d'adresse.
 */
const fs = require('fs');
const path = require('path');

const MAIN = /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(__dirname, '..', 'verify-email.html'), 'utf8'))[0];
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };
const $ = (id) => document.getElementById(id);
const visible = () => ['state-loading', 'state-form', 'state-success', 'state-error']
  .filter((id) => !$(id).classList.contains('hidden'));

const jsonRes = (status, body) => Promise.resolve({ ok: status < 300, status, json: () => Promise.resolve(body) });

async function load(search) {
  window.history.replaceState(null, '', `/verify-email${search}`);
  document.body.innerHTML = MAIN;
  const ready = [];
  const spy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    if (type === 'DOMContentLoaded') { ready.push(fn); return undefined; }
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
  jest.isolateModules(() => { require('../js/verify-email'); });
  spy.mockRestore();
  await Promise.all(ready.map((fn) => fn()));
  await flush();
}

async function submitPassword(password, confirm = password) {
  $('verify-password').value = password;
  $('verify-password-confirm').value = confirm;
  $('verify-form').dispatchEvent(new Event('submit', { cancelable: true }));
  await flush();
}

beforeEach(() => {
  global.i18n = { t: jest.fn((k) => k) };
  global.setupPasswordToggle = jest.fn();
  global.auth = { fetchWithTimeout: jest.fn(), clearSession: jest.fn() };
});

afterEach(() => window.history.replaceState(null, '', '/'));

describe('verify-email.js — lien sans jeton', () => {
  test('message « jeton manquant », aucun appel', async () => {
    await load('');
    expect(visible()).toEqual(['state-error']);
    expect($('error-message').textContent).toBe('verify_email.error_missing_token');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });
});

describe('verify-email.js — confirmation de changement d’adresse', () => {
  test('succès : session locale purgée, message dédié sans data-i18n-html', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(200, {}));
    await load('?type=email&token=tok%2B1');

    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/auth/confirm-email-change', expect.objectContaining({ method: 'POST' }));
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ token: 'tok+1' });
    expect(auth.clearSession).toHaveBeenCalled();
    expect(visible()).toEqual(['state-success']);
    const msg = $('success-message');
    expect(msg.hasAttribute('data-i18n-html')).toBe(false); // sinon applyToDOM le réécrirait
    expect(msg.textContent).toBe('verify_email.email_changed_desc');
  });

  test.each([
    [{ code: 'EMAIL_TAKEN' }, 'verify_email.error_email_taken'],
    [{ code: 'TOKEN_INVALID' }, 'verify_email.error_expired'],
    [{ message: 'Message serveur' }, 'Message serveur'],
    [{}, 'common.error'],
  ])('refus %j : %s', async (body, expected) => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(400, body));
    await load('?type=email&token=t');
    expect(visible()).toEqual(['state-error']);
    expect($('error-message').textContent).toBe(expected);
    expect(auth.clearSession).not.toHaveBeenCalled();
  });

  test('réseau coupé : message réseau', async () => {
    auth.fetchWithTimeout.mockRejectedValue(new TypeError('Failed to fetch'));
    await load('?type=email&token=t');
    expect($('error-message').textContent).toBe('verify_email.error_network');
  });
});

describe('verify-email.js — activation du compte', () => {
  test('affiche le formulaire, branche l’œil sur les deux champs', async () => {
    await load('?token=abc');
    expect(visible()).toEqual(['state-form']);
    expect(global.setupPasswordToggle).toHaveBeenCalledWith($('toggle-verify-pw'), $('verify-password'), $('verify-password-confirm'));
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test.each(['court1A', 'sansmajuscule1', 'SANSMINUSCULE1', 'SansChiffre', `${'Aa1'.repeat(43)}`])(
    'mot de passe refusé avant envoi : %s', async (pw) => {
      await load('?token=abc');
      await submitPassword(pw);
      expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
      expect($('verify-error').textContent).toBe('verify_email.error_password_weak');
      expect($('verify-error').classList.contains('is-visible')).toBe(true);
      expect($('verify-password').hasAttribute('aria-invalid')).toBe(true);
    },
  );

  test('confirmation différente : refusée avant envoi', async () => {
    await load('?token=abc');
    await submitPassword('Motdepasse1', 'Motdepasse2');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    expect($('verify-error').textContent).toBe('verify_email.error_password_mismatch');
  });

  test('succès : jeton et mot de passe envoyés, état succès, erreur effacée', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(200, {}));
    await load('?token=abc');
    await submitPassword('court');
    await submitPassword('Motdepasse1');

    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ token: 'abc', password: 'Motdepasse1' });
    expect(auth.fetchWithTimeout.mock.calls[0][0]).toBe('/api/auth/verify-email');
    expect(visible()).toEqual(['state-success']);
    expect($('verify-error').textContent).toBe('');
    expect($('verify-password').hasAttribute('aria-invalid')).toBe(false);
    expect($('verify-submit-btn').disabled).toBe(false);
  });

  test('bouton désactivé pendant l’envoi', async () => {
    let release;
    auth.fetchWithTimeout.mockReturnValue(new Promise((r) => { release = r; }));
    await load('?token=abc');
    await submitPassword('Motdepasse1');
    expect($('verify-submit-btn').disabled).toBe(true);
    release({ ok: true, json: () => Promise.resolve({}) });
    await flush();
    expect($('verify-submit-btn').disabled).toBe(false);
  });

  test('lien expiré (TOKEN_INVALID) : bascule sur l’état d’erreur', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(400, { code: 'TOKEN_INVALID' }));
    await load('?token=abc');
    await submitPassword('Motdepasse1');
    expect(visible()).toEqual(['state-error']);
    expect($('error-message').textContent).toBe('verify_email.error_expired');
  });

  test('autre refus : message affiché dans le formulaire, qui reste ouvert', async () => {
    auth.fetchWithTimeout.mockReturnValueOnce(jsonRes(400, { message: 'Trop faible côté serveur' }))
      .mockReturnValueOnce(jsonRes(500, {}));
    await load('?token=abc');
    await submitPassword('Motdepasse1');
    expect(visible()).toEqual(['state-form']);
    expect($('verify-error').textContent).toBe('Trop faible côté serveur');
    await submitPassword('Motdepasse1');
    expect($('verify-error').textContent).toBe('common.error');
  });

  test('réseau coupé : message réseau dans le formulaire', async () => {
    auth.fetchWithTimeout.mockRejectedValue(new TypeError('Failed to fetch'));
    await load('?token=abc');
    await submitPassword('Motdepasse1');
    expect($('verify-error').textContent).toBe('verify_email.error_network');
    expect($('verify-submit-btn').disabled).toBe(false);
  });
});
