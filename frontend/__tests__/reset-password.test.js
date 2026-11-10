/**
 * Tests — js/reset-password.js : messages de force du mot de passe traduits
 * (ils étaient écrits en dur en français), repli français tant que les
 * locales ne sont pas chargées.
 */

const DOM = `
  <div id="rp-invalid" class="hidden"></div>
  <div id="rp-form-section">
    <div id="rp-error" role="alert"></div>
    <form id="rp-form">
      <input type="password" id="rp-password"><button type="button" id="toggle-rp-pw"></button>
      <div class="strength-bar"><div class="strength-fill" id="strength-fill"></div></div>
      <div class="strength-hint" id="strength-hint"></div>
      <input type="password" id="rp-password-confirm"><button type="button" id="toggle-rp-pw-confirm"></button>
      <button type="submit" id="rp-submit-btn">Enregistrer</button>
    </form>
  </div>`;

function load(search) {
  jest.resetModules();
  document.body.innerHTML = DOM;
  window.history.replaceState(null, '', `/reset-password${search}`);
  global.setupPasswordToggle = jest.fn();
  global.auth = { fetchWithTimeout: jest.fn() };
  require('../js/reset-password');
}

function type(value) {
  const input = document.getElementById('rp-password');
  input.value = value;
  input.dispatchEvent(new window.Event('input'));
  return document.getElementById('strength-hint').textContent;
}

afterEach(() => { delete global.i18n; });

describe('reset-password.js — indicateur de force', () => {
  test('messages traduits par i18n', () => {
    global.i18n = { t: (k) => ({
      'reset_password.strength_weak': 'Password too weak',
      'reset_password.strength_medium': 'Medium password',
      'reset_password.strength_strong': 'Strong password',
    })[k] || k };
    load('?token=abc');
    expect(type('abc')).toBe('Password too weak');
    expect(type('abcdefgh')).toBe('Medium password');
    expect(type('Abcdefgh1')).toBe('Strong password');
    expect(document.getElementById('strength-fill').style.width).toBe('90%');
  });

  test('locales pas encore chargées (i18n.t renvoie la clé) : repli français', () => {
    global.i18n = { t: (k) => k };
    load('?token=abc');
    expect(type('abc')).toBe('Mot de passe trop faible');
    expect(type('abcdefgh')).toBe('Mot de passe moyen');
    expect(type('Abcdefgh1')).toBe('Mot de passe fort');
  });

  test('sans i18n : repli français', () => {
    load('?token=abc');
    expect(type('abc')).toBe('Mot de passe trop faible');
  });

  test('sans jeton : formulaire masqué, lien invalide affiché', () => {
    load('');
    expect(document.getElementById('rp-form-section').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('rp-invalid').classList.contains('hidden')).toBe(false);
  });

  test('les deux langues déclarent les trois clés', () => {
    const fr = require('../locales/fr.json').reset_password;
    const en = require('../locales/en.json').reset_password;
    ['strength_weak', 'strength_medium', 'strength_strong'].forEach((k) => {
      expect(typeof fr[k]).toBe('string');
      expect(typeof en[k]).toBe('string');
    });
  });
});
