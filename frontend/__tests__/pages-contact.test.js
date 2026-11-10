/**
 * Tests — frontend/js/contact.js sur le vrai <main> de contact.html :
 * validation, envoi (avec ou sans hCaptcha), états du bouton, message de
 * succès effacé à la reprise de saisie, erreurs 429 / serveur / réseau.
 *
 * Les aides de formulaire (isValidEmail, setFieldError, clearFieldError) sont
 * celles de utils.js, comme dans le bundle app.min.js.
 */
const fs = require('fs');
const path = require('path');
const utils = require('../js/utils');

const MAIN = /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(__dirname, '..', 'contact.html'), 'utf8'))[0];
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };

let domReady = [];
let addSpy;

function loadContact() {
  document.body.innerHTML = MAIN;
  domReady = [];
  addSpy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    if (type === 'DOMContentLoaded') { domReady.push(fn); return undefined; }
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
  jest.isolateModules(() => { require('../js/contact'); });
  addSpy.mockRestore();
  domReady.forEach((fn) => fn());
}

const $ = (id) => document.getElementById(id);
function fill({ email = 'ada@test.local', message = 'Bonjour', firstname = ' Ada ', lastname = 'Lovelace', subject = 'bug' } = {}) {
  $('contact-firstname').value = firstname;
  $('contact-lastname').value = lastname;
  $('contact-email').value = email;
  $('contact-subject').value = subject;
  $('contact-message').value = message;
}
const submit = async () => {
  $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
  await flush();
};

beforeEach(() => {
  global.isValidEmail = utils.isValidEmail;
  global.setFieldError = utils.setFieldError;
  global.clearFieldError = utils.clearFieldError;
  global.showToast = jest.fn();
  global.i18n = { t: jest.fn((k) => k) };
  global.fetch = jest.fn(() => Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve({}) }));
  delete window.getHcaptchaToken;
});

describe('contact.js — validation', () => {
  test('email invalide : erreur sur le champ, focus, aucun envoi', async () => {
    loadContact();
    fill({ email: 'pas-un-email' });
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect($('contact-email').getAttribute('aria-invalid')).toBe('true');
    expect($('contact-email-error').textContent).toBe('contact.form_error_email');
    expect(document.activeElement).toBe($('contact-email'));
  });

  test('message vide (espaces) : erreur sur le message, aucun envoi', async () => {
    loadContact();
    fill({ message: '   ' });
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect($('contact-message-error').textContent).toBe('contact.form_error_message');
    expect(document.activeElement).toBe($('contact-message'));
  });

  test('la saisie efface l’erreur du champ', async () => {
    loadContact();
    fill({ email: '' });
    await submit();
    expect($('contact-email').getAttribute('aria-invalid')).toBe('true');
    $('contact-email').dispatchEvent(new Event('input'));
    expect($('contact-email').hasAttribute('aria-invalid')).toBe(false);
    $('contact-message').dispatchEvent(new Event('input'));
  });

  test('page sans formulaire : rien n’est branché', () => {
    document.body.innerHTML = '<main></main>';
    jest.isolateModules(() => { require('../js/contact'); });
    expect(() => document.dispatchEvent(new Event('DOMContentLoaded'))).not.toThrow();
  });
});

describe('contact.js — envoi', () => {
  test('payload nettoyé envoyé en JSON à /api/contact, formulaire vidé, succès affiché', async () => {
    loadContact();
    fill();
    await submit();

    expect(global.fetch).toHaveBeenCalledWith('/api/contact', expect.objectContaining({
      method: 'POST', headers: { 'Content-Type': 'application/json' },
    }));
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)).toEqual({
      firstname: 'Ada', lastname: 'Lovelace', email: 'ada@test.local', subject: 'bug', message: 'Bonjour',
    });
    expect($('contact-email').value).toBe('');
    expect($('contact-success').classList.contains('visible')).toBe(true);
    expect(document.querySelector('.t-success-check').getAttribute('data-state')).toBe('in');
    expect(showToast).toHaveBeenCalledWith('contact.form_success', 'success');
  });

  test('jeton hCaptcha ajouté quand il existe', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('jeton-h'));
    loadContact();
    fill();
    await submit();
    expect(window.getHcaptchaToken).toHaveBeenCalledWith('contact');
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)['h-captcha-response']).toBe('jeton-h');
  });

  test('hCaptcha non configuré (null) : pas de champ h-captcha-response', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve(null));
    loadContact();
    fill();
    await submit();
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)).not.toHaveProperty('h-captcha-response');
  });

  test('bouton bloqué pendant l’envoi (aria-busy), restauré à l’identique ensuite', async () => {
    let release;
    global.fetch = jest.fn(() => new Promise((r) => { release = r; }));
    loadContact();
    const btn = document.querySelector('.btn-send');
    const original = btn.innerHTML;
    fill();
    await submit();
    expect(btn.disabled).toBe(true);
    expect(btn.getAttribute('aria-busy')).toBe('true');
    expect(btn.textContent).toContain('contact.form_sending');
    release({ ok: true, status: 200 });
    await flush();
    expect(btn.disabled).toBe(false);
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(btn.innerHTML).toBe(original);
  });

  test('429 : message du serveur affiché', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 429, json: () => Promise.resolve({ message: 'Trop de messages' }) }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('Trop de messages', 'error');
    expect($('contact-email').value).toBe('ada@test.local'); // rien n'est perdu
  });

  test('429 au corps illisible : message générique de limitation', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 429, json: () => Promise.reject(new Error('html')) }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('login.too_many_attempts', 'error');
  });

  test('erreur serveur : message d’échec d’envoi', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 500 }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('contact.form_error_send', 'error');
    expect($('contact-success').classList.contains('visible')).toBe(false);
  });

  test('réseau coupé ou hCaptcha bloqué : message d’échec, bouton rendu', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.reject(new Error('hCaptcha script load error')));
    loadContact();
    fill();
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect(showToast).toHaveBeenCalledWith('contact.form_error_send', 'error');
    expect(document.querySelector('.btn-send').disabled).toBe(false);
  });
});

describe('contact.js — message de succès', () => {
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  async function sendOk() {
    loadContact();
    fill();
    $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
    jest.useRealTimers();
    await flush();
    jest.useFakeTimers();
  }

  test('reprendre la saisie efface le message en fondu (200 ms)', async () => {
    await sendOk();
    const msg = $('contact-success');
    $('contact-form').dispatchEvent(new Event('input'));
    expect(msg.classList.contains('is-hiding')).toBe(true);
    // Un second événement pendant le fondu ne relance rien.
    $('contact-form').dispatchEvent(new Event('change'));
    jest.advanceTimersByTime(200);
    expect(msg.classList.contains('visible')).toBe(false);
    expect(msg.classList.contains('is-hiding')).toBe(false);
    expect(msg.querySelector('.t-success-check').getAttribute('data-state')).toBe('out');
  });

  test('saisie sans message affiché : rien à masquer', () => {
    loadContact();
    $('contact-form').dispatchEvent(new Event('input'));
    expect($('contact-success').classList.contains('is-hiding')).toBe(false);
  });

  test('un nouvel envoi pendant le fondu annule le masquage différé', async () => {
    await sendOk();
    const msg = $('contact-success');
    $('contact-form').dispatchEvent(new Event('input'));
    fill();
    $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
    jest.useRealTimers();
    await flush();
    jest.useFakeTimers();
    jest.advanceTimersByTime(500);
    expect(msg.classList.contains('visible')).toBe(true);
    expect(msg.classList.contains('is-hiding')).toBe(false);
  });
});
