/**
 * Tests — js/login/flow.js : étapes par code sur la page de connexion.
 * Mot de passe oublié → code → nouveau mot de passe ; inscription → code →
 * mot de passe ; renvoi du code, changement d'adresse, ancres d'historique.
 */
const utils = require('../js/utils');
const { LOGIN_DOM } = require('./helpers/login-dom');

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}

let auth;
let toasts;
let flow;
let ctx;

function installGlobals() {
  Object.assign(global, {
    escapeHtml: utils.escapeHtml,
    setFieldError: utils.setFieldError,
    clearFieldError: utils.clearFieldError,
    isValidEmail: utils.isValidEmail,
    calculatePasswordStrength: utils.calculatePasswordStrength,
    isValidPassword: utils.isValidPassword,
  });
  toasts = [];
  global.showToast = jest.fn((msg, t) => toasts.push([t, msg]));
  global.i18n = { t: jest.fn((k) => `t:${k}`) };
  auth = { fetchWithTimeout: jest.fn(() => Promise.resolve(jsonResponse(200, {}))) };
  global.auth = auth;
}

function load() {
  jest.resetModules();
  window.VH = {};
  require('./helpers/motion-env').loadMotion();
  require('../js/login/state');
  require('../js/login/strength');
  require('../js/login/tabs');
  require('../js/shared/busy-button');
  require('../js/login/ui');
  require('../js/shared/otp-input');
  require('../js/login/flow');
  flow = window.VH.login.flow;
  ctx = window.VH.login.state.createContext(document);
  flow.setup(ctx);
}

const $ = (id) => document.getElementById(id);
const active = () => document.querySelector('.form-slide.active')?.id;
const lastBody = () => JSON.parse(auth.fetchWithTimeout.mock.calls.at(-1)[1].body);
const lastUrl = () => auth.fetchWithTimeout.mock.calls.at(-1)[0];
const ev = { preventDefault() {} };

beforeEach(() => {
  window.history.replaceState(null, '', '/login');
  document.body.innerHTML = LOGIN_DOM;
  installGlobals();
  // Mouvements réduits : bascules immédiates, pas d'attente du tracé vert.
  window.matchMedia = jest.fn(() => ({ matches: true }));
  delete window.getHcaptchaToken;
  load();
});

afterEach(() => {
  jest.useRealTimers();
});

describe('mise en place', () => {
  test('champ de code monté, étiqueté (repli tant que la langue manque)', () => {
    expect(ctx.state.otp).toBeTruthy();
    expect($('code-otp').querySelectorAll('.otp-slot')).toHaveLength(6);
    expect($('code-otp').querySelector('input').getAttribute('aria-label')).toBe('t:login.code_label');
    global.i18n.t = jest.fn((k) => k);
    document.body.innerHTML = LOGIN_DOM;
    load();
    expect($('code-otp').querySelector('input').getAttribute('aria-label')).toBe('Code à 6 chiffres');
  });

  test('arrivée par /login#mot-de-passe-oublie : étape « oubli » ; autre ancre retirée', () => {
    window.history.replaceState(null, '', '/login#mot-de-passe-oublie');
    document.body.innerHTML = LOGIN_DOM;
    load();
    expect(active()).toBe('forgot-slide');
    expect(document.querySelector('.form-container').classList.contains('is-flow')).toBe(true);
    window.history.replaceState(null, '', '/login#autre');
    document.body.innerHTML = LOGIN_DOM;
    load();
    expect(window.location.hash).toBe('');
    expect(active()).toBe('login-slide');
  });

  test('« Mot de passe oublié ? » reprend l’adresse de connexion', () => {
    const link = document.createElement('a');
    link.id = 'open-forgot';
    link.href = '#mot-de-passe-oublie';
    $('login-form').appendChild(link);
    document.body.innerHTML = document.body.innerHTML; // nouveau DOM, écouteurs neufs
    load();
    $('login-email').value = 'pilote@x.fr';
    $('open-forgot').click();
    expect(active()).toBe('forgot-slide');
    expect($('forgot-email').value).toBe('pilote@x.fr');
    expect(window.location.hash).toBe('#mot-de-passe-oublie');
  });
});

describe('mot de passe oublié', () => {
  test('adresse invalide : erreur de champ, aucun appel', async () => {
    $('forgot-email').value = 'x';
    await flow.onForgotSubmit(ctx, ev);
    expect($('forgot-email-error').textContent).toBe('t:login.invalid_email');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('succès : captcha joint, étape « code » en mode réinitialisation', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('cap'));
    $('forgot-email').value = 'pilote@x.fr';
    await flow.onForgotSubmit(ctx, ev);
    expect(window.getHcaptchaToken).toHaveBeenCalledWith('forgot');
    expect(lastUrl()).toBe('/api/auth/forgot-password');
    expect(lastBody()).toEqual({ email: 'pilote@x.fr', 'h-captcha-response': 'cap' });
    expect(active()).toBe('code-slide');
    expect($('code-title').getAttribute('data-i18n')).toBe('login.code_title_reset');
    expect($('code-title').textContent).toBe('t:login.code_title_reset');
    expect($('code-hint').textContent).toBe('t:login.code_hint_reset');
    expect($('code-email').textContent).toBe('pilote@x.fr');
  });

  test('refus (429) et erreur réseau : message, on reste sur l’étape', async () => {
    $('forgot-email').value = 'pilote@x.fr';
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(429, { message: 'Trop' }));
    await flow.onForgotSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 'Trop']);
    auth.fetchWithTimeout.mockResolvedValueOnce({ ok: false, status: 500, json: () => Promise.reject(new Error('html')) });
    await flow.onForgotSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await flow.onForgotSubmit(ctx, ev);
    expect(toasts.filter(([, m]) => m === 't:login.server_error')).toHaveLength(2);
  });
});

describe('étape « code »', () => {
  beforeEach(() => flow.startCode(ctx, 'verify', 'pilote@x.fr'));

  test('code juste : succès, puis étape « mot de passe » (textes d’activation)', async () => {
    await flow.onCodeComplete(ctx, '123456');
    expect(lastUrl()).toBe('/api/auth/check-code');
    expect(lastBody()).toEqual({ email: 'pilote@x.fr', type: 'verify', code: '123456' });
    expect($('code-otp').classList.contains('is-success')).toBe(true);
    expect($('code-status').dataset.tone).toBe('success');
    expect(ctx.state.flow.code).toBe('123456');
    expect(active()).toBe('password-slide');
    expect(window.location.hash).toBe('#mot-de-passe');
    expect($('password-title').textContent).toBe('t:login.password_title_verify');
    expect($('password-submit-label').getAttribute('data-i18n')).toBe('login.password_submit_verify');
  });

  test('sans mouvements réduits : on attend la fin du tracé vert (ou le délai de repli)', async () => {
    jest.useFakeTimers();
    window.matchMedia = jest.fn(() => ({ matches: false }));
    await flow.onCodeComplete(ctx, '123456');
    expect(active()).toBe('code-slide');
    const rings = $('code-otp').querySelectorAll('.otp-ring rect');
    rings[rings.length - 1].dispatchEvent(new window.Event('transitionend'));
    jest.advanceTimersByTime(2000); // sortie animée du panneau (motion-env)
    expect(active()).toBe('password-slide');
  });

  test('code faux : erreur, champ réactivé, statut annoncé ; la frappe l’efface', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(400, { code: 'CODE_INVALID' }));
    await flow.onCodeComplete(ctx, '000000');
    expect($('code-otp').classList.contains('is-error')).toBe(true);
    expect($('code-status').textContent).toBe('t:login.code_invalid');
    expect($('code-status').dataset.tone).toBe('error');
    expect(ctx.state.flow.code).toBeNull();
    const input = $('code-otp').querySelector('input');
    expect(input.disabled).toBe(false);
    input.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Backspace', bubbles: true }));
    expect($('code-status').textContent).toBe('');
  });

  test('trop d’essais (429) et erreur réseau', async () => {
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(429, { message: 'Trop d’essais' }));
    await flow.onCodeComplete(ctx, '000000');
    expect($('code-status').textContent).toBe('Trop d’essais');
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(429, {}));
    await flow.onCodeComplete(ctx, '000000');
    expect($('code-status').textContent).toBe('t:login.too_many_attempts');
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await flow.onCodeComplete(ctx, '000000');
    expect($('code-status').textContent).toBe('t:login.server_error');
  });

  test('une vérification en cours ignore une seconde saisie ; sans parcours, rien', async () => {
    ctx.state.checking = true;
    await flow.onCodeComplete(ctx, '123456');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    ctx.state.checking = false;
    ctx.state.flow = null;
    await flow.onCodeComplete(ctx, '123456');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('renvoi (activation) : code vidé, bouton en pause avec compte à rebours', async () => {
    jest.useFakeTimers();
    await flow.onResend(ctx);
    expect(lastUrl()).toBe('/api/auth/resend-verification');
    expect(lastBody()).toEqual({ email: 'pilote@x.fr' });
    expect(toasts).toContainEqual(['success', 't:login.code_resent']);
    const button = $('code-resend');
    expect(button.disabled).toBe(true);
    expect(button.querySelector('span').textContent).toBe('t:login.code_resend (30)');
    await flow.onResend(ctx); // bouton indisponible : rien
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
    jest.advanceTimersByTime(31000);
    expect(button.disabled).toBe(false);
    expect(button.querySelector('span').textContent).toBe('t:login.code_resend');
  });

  test('renvoi (réinitialisation) : captcha joint ; échec réseau : bouton rendu', async () => {
    flow.startCode(ctx, 'reset', 'pilote@x.fr');
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('cap'));
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await flow.onResend(ctx);
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
    expect($('code-resend').disabled).toBe(false);
    jest.useFakeTimers();
    await flow.onResend(ctx);
    expect(lastUrl()).toBe('/api/auth/forgot-password');
    expect(lastBody()).toEqual({ email: 'pilote@x.fr', 'h-captcha-response': 'cap' });
  });

  test('changer d’adresse : retour à l’inscription, adresse reprise', () => {
    flow.onChangeEmail(ctx);
    expect(active()).toBe('register-slide');
    expect($('register-email').value).toBe('pilote@x.fr');
    expect(document.activeElement).toBe($('register-email'));
    expect(document.querySelector('.form-container').classList.contains('is-flow')).toBe(false);
  });

  test('changer d’adresse (réinitialisation) : retour à l’étape « oubli »', () => {
    flow.startCode(ctx, 'reset', 'a@x.fr');
    flow.onChangeEmail(ctx);
    expect(active()).toBe('forgot-slide');
    expect($('forgot-email').value).toBe('a@x.fr');
    ctx.state.flow = null;
    flow.onChangeEmail(ctx); // sans parcours : rien
    expect(active()).toBe('forgot-slide');
  });

  test('bouton « retour » des étapes : connexion, ancre retirée', () => {
    document.querySelector('#code-slide .flow-back, #forgot-slide .flow-back').click();
    expect(active()).toBe('login-slide');
    expect(window.location.hash).toBe('');
  });
});

describe('étape « mot de passe »', () => {
  async function reachPassword(type = 'verify') {
    flow.startCode(ctx, type, 'pilote@x.fr');
    await flow.onCodeComplete(ctx, '123456');
    auth.fetchWithTimeout.mockClear();
  }
  const fillPw = (pw, confirm = pw) => { $('new-password').value = pw; $('confirm-password').value = confirm; };

  test('règle du mot de passe puis confirmation différente : erreurs, aucun appel', async () => {
    await reachPassword();
    fillPw('abc');
    await flow.onPasswordSubmit(ctx, ev);
    expect($('new-password-error').textContent).toBe('t:login.password_requirements');
    expect($('new-password').getAttribute('aria-describedby')).toBe('new-password-error new-password-hint');
    fillPw('Abcdefg1', 'Abcdefg2');
    await flow.onPasswordSubmit(ctx, ev);
    expect($('confirm-password-error').textContent).toBe('t:login.password_mismatch');
    expect($('new-password').getAttribute('aria-describedby')).toBe('new-password-hint');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('activation réussie : code + mot de passe envoyés, connexion préremplie', async () => {
    await reachPassword('verify');
    fillPw('Abcdefg1');
    await flow.onPasswordSubmit(ctx, ev);
    expect(lastUrl()).toBe('/api/auth/verify-email');
    expect(lastBody()).toEqual({ email: 'pilote@x.fr', code: '123456', password: 'Abcdefg1' });
    expect(toasts).toContainEqual(['success', 't:login.account_activated']);
    expect(active()).toBe('login-slide');
    expect($('login-email').value).toBe('pilote@x.fr');
    expect(document.activeElement).toBe($('login-password'));
    expect(ctx.state.flow).toBeNull();
  });

  test('réinitialisation réussie : bonne route, bon message', async () => {
    await reachPassword('reset');
    expect($('password-title').textContent).toBe('t:login.password_title_reset');
    fillPw('Abcdefg1');
    await flow.onPasswordSubmit(ctx, ev);
    expect(lastUrl()).toBe('/api/auth/reset-password');
    expect(toasts).toContainEqual(['success', 't:login.password_reset_done']);
  });

  test('code expiré entre-temps : retour à l’étape « code », champ vidé', async () => {
    await reachPassword();
    fillPw('Abcdefg1');
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(400, { code: 'CODE_INVALID' }));
    await flow.onPasswordSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.code_expired']);
    expect(active()).toBe('code-slide');
    expect(ctx.state.flow.code).toBeNull();
  });

  test('autre erreur, réponse non JSON et réseau : message, on reste', async () => {
    await reachPassword();
    fillPw('Abcdefg1');
    auth.fetchWithTimeout.mockResolvedValueOnce(jsonResponse(500, { message: 'Panne' }));
    await flow.onPasswordSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 'Panne']);
    auth.fetchWithTimeout.mockResolvedValueOnce({ ok: false, status: 502, json: () => Promise.reject(new Error('html')) });
    await flow.onPasswordSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await flow.onPasswordSubmit(ctx, ev);
    expect(active()).toBe('password-slide');
  });

  test('sans code validé : envoi impossible', async () => {
    flow.startCode(ctx, 'verify', 'pilote@x.fr');
    fillPw('Abcdefg1');
    await flow.onPasswordSubmit(ctx, ev);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });
});

describe('historique', () => {
  test('retour arrière : #code → étape « code », #mot-de-passe sans code → connexion', () => {
    flow.startCode(ctx, 'verify', 'pilote@x.fr');
    flow.go(ctx, 'login');
    window.history.replaceState(null, '', '/login#code');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(active()).toBe('code-slide');
    window.history.replaceState(null, '', '/login#mot-de-passe');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(active()).toBe('login-slide');
    window.history.replaceState(null, '', '/login#mot-de-passe-oublie');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(active()).toBe('forgot-slide');
  });

  test('#mot-de-passe avec un code validé : étape « mot de passe »', async () => {
    flow.startCode(ctx, 'verify', 'pilote@x.fr');
    await flow.onCodeComplete(ctx, '123456');
    flow.go(ctx, 'login');
    window.history.replaceState(null, '', '/login#mot-de-passe');
    window.dispatchEvent(new window.PopStateEvent('popstate'));
    expect(active()).toBe('password-slide');
  });
});
