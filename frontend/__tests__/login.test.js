/**
 * Tests — page de connexion / inscription (js/login/*.js + js/login.js).
 * Découpage ARCH-004 : les modules VH.login.* sont testés un à un, puis le
 * point d'entrée sur le DOM réel du formulaire.
 */

const utils = require('../js/utils');

const { LOGIN_DOM } = require('./helpers/login-dom');

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}

let auth;
let toasts;
let navigations;

function installGlobals() {
  Object.assign(global, {
    escapeHtml: utils.escapeHtml,
    setFieldError: utils.setFieldError,
    clearFieldError: utils.clearFieldError,
    isValidEmail: utils.isValidEmail,
    calculatePasswordStrength: utils.calculatePasswordStrength,
    isValidPassword: utils.isValidPassword,
    setupPasswordToggle: jest.fn(),
  });
  toasts = [];
  global.showToast = jest.fn((msg, type) => toasts.push([type, msg]));
  global.i18n = { t: jest.fn((k) => `t:${k}`) };
  auth = {
    init: jest.fn(() => Promise.resolve(null)),
    fetchWithTimeout: jest.fn(() => Promise.resolve(jsonResponse(200, {}))),
    setToken: jest.fn(),
    getPayload: jest.fn(() => null),
    setUserInfo: jest.fn(),
  };
  global.auth = auth;
}

// jsdom ne calcule aucune durée : exit() rappelle aussitôt. Pour exercer la
// sortie animée, on la remplace par une version qui attend 250 ms.
const SLIDE_OUT_MS = 250;
function simulateAnimatedExit() {
  window.VH.motion.exit = (el, done, opts) => {
    const cls = (opts && opts.className) || 'is-closing';
    el.classList.add(cls);
    const timer = setTimeout(() => { el.classList.remove(cls); done(); }, SLIDE_OUT_MS);
    return () => { clearTimeout(timer); el.classList.remove(cls); };
  };
}

function loadModules() {
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
  require('../js/login/visual');
  require('../js/login/forms');
  // jsdom ne navigue pas : on relève les redirections demandées.
  window.VH.login.forms.navigate = jest.fn((url) => navigations.push(url));
  return window.VH.login;
}

beforeEach(() => {
  document.body.innerHTML = LOGIN_DOM;
  installGlobals();
  window.matchMedia = jest.fn(() => ({ matches: true })); // mouvements réduits : bascule immédiate
  delete window.getHcaptchaToken;
  navigations = [];
});

afterEach(() => {
  jest.useRealTimers();
});

const flush = () => new Promise((r) => setTimeout(r, 0));
const submit = (form) => form.dispatchEvent(new window.Event('submit', { cancelable: true }));

describe('VH.login.state', () => {
  test('rassemble les éléments de la page', () => {
    const { state } = loadModules();
    const ctx = state.createContext(document);
    expect(ctx.els.loginForm.id).toBe('login-form');
    expect(ctx.els.tabRegister.id).toBe('tab-register');
    expect(ctx.state.pendingSwap).toBeNull();
  });

  test('null si un formulaire manque', () => {
    const { state } = loadModules();
    document.getElementById('register-form').remove();
    expect(state.createContext(document)).toBeNull();
  });
});

describe('VH.login.strength', () => {
  test('validatePassword applique la règle du serveur', () => {
    const { strength } = loadModules();
    expect(strength.validatePassword('Abcdefg1')).toBe(true);
    expect(strength.validatePassword('abcdefg1')).toBe(false);
    expect(strength.validatePassword('ABCDEFG1')).toBe(false);
    expect(strength.validatePassword('Abcdefgh')).toBe(false);
    expect(strength.validatePassword('Abc1')).toBe(false);
    // Borne haute du serveur (128), oubliée par l'ancienne copie de la règle
    expect(strength.validatePassword('Aa1' + 'x'.repeat(125))).toBe(true);
    expect(strength.validatePassword('Aa1' + 'x'.repeat(126))).toBe(false);
  });

  test.each([
    [0, 'login.password_strength', 'var(--text-secondary)', 'transparent'],
    [20, 'login.strength_weak', 'var(--accent)', 'var(--accent)'],
    [60, 'login.strength_medium', 'var(--warning)', 'var(--warning)'],
    [90, 'login.strength_strong', 'var(--success)', 'var(--success)'],
  ])('strengthLevel(%i)', (score, key, text, fill) => {
    const { strength } = loadModules();
    expect(strength.strengthLevel(score)).toEqual({ key, text, fill });
  });

  test('la jauge suit la saisie du nouveau mot de passe', () => {
    const { state, strength } = loadModules();
    const ctx = state.createContext(document);
    strength.setupPasswordStrength(ctx);
    const input = ctx.els.newPassword;
    input.value = 'Abcdefgh1!xyz';
    input.dispatchEvent(new window.Event('input'));
    const fill = document.querySelector('.strength-fill');
    expect(fill.style.width).toBe('100%');
    expect(document.querySelector('.strength-text').textContent).toBe('t:login.strength_strong');
  });

  test('updatePasswordStrength sans jauge : rien ne casse', () => {
    const { strength } = loadModules();
    document.querySelector('.password-strength').remove();
    expect(() => strength.updatePasswordStrength(50)).not.toThrow();
  });
});

describe('VH.login.tabs', () => {
  function setup() {
    const login = loadModules();
    const ctx = login.state.createContext(document);
    login.tabs.setupFormSwitching(ctx);
    return { login, ctx };
  }

  test('le bouton « Créer un compte » montre l\'inscription et y place le focus', () => {
    const { ctx } = setup();
    ctx.els.loginForm.querySelector('#login-email').value = 'x@y.fr';
    ctx.els.switchToRegister.click();
    expect(ctx.els.tabRegister.getAttribute('aria-selected')).toBe('true');
    expect(ctx.els.tabLogin.getAttribute('tabindex')).toBe('-1');
    expect(ctx.els.registerSlide.classList.contains('active')).toBe(true);
    expect(ctx.els.registerSlide.inert).toBe(false);
    expect(ctx.els.loginSlide.inert).toBe(true);
    expect(document.activeElement.id).toBe('register-name');
    // Les formulaires sont remis à zéro à chaque bascule
    expect(document.getElementById('login-email').value).toBe('');
  });

  test('flèches, Début et Fin dans la tablist', () => {
    const { ctx } = setup();
    const key = (el, k) => el.dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true }));
    key(ctx.els.tabLogin, 'ArrowRight');
    expect(ctx.els.tabRegister.getAttribute('aria-selected')).toBe('true');
    expect(document.activeElement).toBe(ctx.els.tabRegister);
    key(ctx.els.tabRegister, 'ArrowLeft');
    expect(ctx.els.tabLogin.getAttribute('aria-selected')).toBe('true');
    key(ctx.els.tabLogin, 'End');
    expect(ctx.els.tabRegister.getAttribute('aria-selected')).toBe('true');
    key(ctx.els.tabRegister, 'Home');
    expect(ctx.els.tabLogin.getAttribute('aria-selected')).toBe('true');
    key(ctx.els.tabLogin, 'Enter'); // touche sans effet
    expect(ctx.els.tabLogin.getAttribute('aria-selected')).toBe('true');
  });

  test('clic sur les onglets et retour à la connexion', () => {
    const { ctx } = setup();
    ctx.els.tabRegister.click();
    expect(ctx.els.registerSlide.classList.contains('active')).toBe(true);
    ctx.els.switchToLogin.click();
    expect(ctx.els.loginSlide.classList.contains('active')).toBe(true);
    ctx.els.tabLogin.click();
    expect(ctx.els.loginSlide.classList.contains('active')).toBe(true);
  });

  test('sortie animée : le panneau sortant glisse puis la bascule se fait', () => {
    jest.useFakeTimers();
    const { login, ctx } = setup();
    simulateAnimatedExit();
    login.tabs.activateTab(ctx, ctx.els.tabRegister, { focusInput: false });
    expect(ctx.els.loginSlide.classList.contains('is-leaving')).toBe(true);
    expect(ctx.els.loginSlide.inert).toBe(true);
    expect(ctx.els.registerSlide.classList.contains('active')).toBe(false);
    jest.advanceTimersByTime(SLIDE_OUT_MS);
    expect(ctx.els.registerSlide.classList.contains('active')).toBe(true);
    expect(ctx.els.loginSlide.classList.contains('is-leaving')).toBe(false);
    expect(ctx.state.pendingSwap).toBeNull();
  });

  test('une bascule en cours se termine dès la suivante', () => {
    jest.useFakeTimers();
    const { login, ctx } = setup();
    simulateAnimatedExit();
    login.tabs.activateTab(ctx, ctx.els.tabRegister);
    expect(typeof ctx.state.pendingSwap).toBe('function');
    login.tabs.activateTab(ctx, ctx.els.tabLogin);
    // la première bascule a été achevée : inscription affichée puis sortie animée
    expect(ctx.els.registerSlide.classList.contains('is-leaving')).toBe(true);
    jest.advanceTimersByTime(SLIDE_OUT_MS);
    expect(ctx.els.loginSlide.classList.contains('active')).toBe(true);
  });

  test('onglet absent ou panneau introuvable : sans effet', () => {
    const { login, ctx } = setup();
    expect(() => login.tabs.activateTab(ctx, null)).not.toThrow();
    ctx.els.tabRegister.setAttribute('aria-controls', 'nope');
    login.tabs.activateTab(ctx, ctx.els.tabRegister);
    expect(ctx.els.tabRegister.getAttribute('aria-selected')).toBe('false');
  });
});

describe('VH.login.ui', () => {
  test('fetchStats : compteurs animés depuis /api/stats', async () => {
    const { ui } = loadModules();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(200, { airplanes: 434, countries: 33, earliest_year: 1945, latest_year: 2026 }));
    await ui.fetchStats();
    expect(document.getElementById('stat-airplanes').querySelector('.sr-only').textContent).toBe('434');
    expect(document.getElementById('stat-years').querySelector('.sr-only').textContent).toBe('81');
    expect(document.getElementById('stat-years-label').textContent).toBe('t:login.years_label');
  });

  test('fetchStats : repli statique si l\'API échoue', async () => {
    const { ui } = loadModules();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(500, {}));
    await ui.fetchStats();
    expect(document.getElementById('stat-airplanes').textContent).toBe('45+');
    expect(document.getElementById('stat-years').textContent).toBe('1950');
    expect(document.getElementById('stat-countries').textContent).toBe('12');
  });

  test('fetchStats sans compteurs dans la page : aucun appel', async () => {
    const { ui } = loadModules();
    document.getElementById('stat-airplanes').remove();
    await ui.fetchStats();
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('setButtonLoading garde le libellé pour les lecteurs d\'écran puis le restaure', () => {
    const { ui } = loadModules();
    const btn = document.querySelector('#login-form .btn-submit');
    const html = btn.innerHTML;
    ui.setButtonLoading(btn, true);
    expect(btn.disabled).toBe(true);
    expect(btn.getAttribute('aria-busy')).toBe('true');
    expect(btn.classList.contains('is-loading')).toBe(true);
    // Libellé gardé dans le bouton (VH.busyButton) : toujours lu.
    expect(btn.querySelector('.bb-label').textContent.trim()).toBe('Se connecter');
    ui.setButtonLoading(btn, false);
    expect(btn.disabled).toBe(false);
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(btn.classList.contains('is-loading')).toBe(false);
    expect(btn.querySelector('.bb-label').innerHTML).toBe(html);
  });

  test('avis « email non vérifié » unique, renvoi du lien réussi puis échoué', async () => {
    const login = loadModules();
    const ctx = login.state.createContext(document);
    login.ui.showEmailNotVerifiedNotice(ctx, 'a<b>@x.fr');
    login.ui.showEmailNotVerifiedNotice(ctx, 'a@x.fr');
    expect(document.querySelectorAll('#email-not-verified-notice')).toHaveLength(1);

    const btn = document.getElementById('resend-verify-btn');
    btn.click();
    await flush();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/auth/resend-verification', expect.objectContaining({ method: 'POST' }));
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ email: 'a@x.fr' });
    expect(btn.classList.contains('ev-resend-success')).toBe(true);
    expect(btn.disabled).toBe(true);
    // Message conditionnel : l'avis s'affiche sans savoir si le compte existe
    expect(toasts).toContainEqual(['success', 't:login.resent_notice']);

    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await login.ui.resendVerification(btn, 'a@x.fr');
    expect(btn.disabled).toBe(false);
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
  });

  test('renvoi du lien : l\'adresse part telle quelle, pas échappée pour le HTML', async () => {
    const login = loadModules();
    const ctx = login.state.createContext(document);
    login.ui.showEmailNotVerifiedNotice(ctx, "o'brien&co@x.fr");
    document.getElementById('resend-verify-btn').click();
    await flush();
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ email: "o'brien&co@x.fr" });
  });
});

describe('VH.login.forms — connexion', () => {
  function setup() {
    const login = loadModules();
    const ctx = login.state.createContext(document);
    login.forms.bindForms(ctx);
    return { login, ctx };
  }

  test('email invalide puis mot de passe manquant : erreurs de champ, aucun appel', () => {
    const { ctx } = setup();
    document.getElementById('login-email').value = 'pas-un-email';
    submit(ctx.els.loginForm);
    expect(document.getElementById('login-email-error').textContent).toBe('t:login.invalid_email');

    document.getElementById('login-email').value = 'a@b.fr';
    submit(ctx.els.loginForm);
    expect(document.getElementById('login-email').hasAttribute('aria-invalid')).toBe(false);
    expect(document.getElementById('login-password-error').textContent).toBe('t:login.missing_password');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('jeton hCaptcha (portée « login ») joint aux identifiants', async () => {
    const { login, ctx } = setup();
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('cap'));
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(400, { message: 'Email ou mot de passe incorrect' }));
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(window.getHcaptchaToken).toHaveBeenCalledWith('login');
    const body = JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body);
    expect(body).toEqual({ email: 'pilote@x.fr', password: 'secret', remember: false, 'h-captcha-response': 'cap' });
  });

  test('CONT-002 : case « Se souvenir de moi » cochée → remember: true', async () => {
    const { login, ctx } = setup();
    window.getHcaptchaToken = jest.fn(() => Promise.resolve(null));
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(400, {}));
    const box = document.createElement('input');
    box.type = 'checkbox'; box.id = 'remember-me'; box.checked = true;
    document.body.appendChild(box);
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body).remember).toBe(true);
    box.remove();
  });

  test('sans clé de site (jeton null) : identifiants seuls', async () => {
    const { login, ctx } = setup();
    window.getHcaptchaToken = jest.fn(() => Promise.resolve(null));
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(400, {}));
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ email: 'pilote@x.fr', password: 'secret', remember: false });
  });

  test('succès : jeton et infos utilisateur enregistrés, redirection', async () => {
    jest.useFakeTimers();
    const { ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(200, { token: 'jwt' }));
    auth.getPayload.mockReturnValue({ id: 7, role: '3' });
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    submit(ctx.els.loginForm);
    await Promise.resolve(); await Promise.resolve(); await Promise.resolve();
    expect(auth.setToken).toHaveBeenCalledWith('jwt');
    expect(auth.setUserInfo).toHaveBeenCalledWith({ id: 7, email: 'pilote@x.fr', name: 'pilote', role: 3 });
    expect(toasts).toContainEqual(['success', 't:login.login_success']);
    jest.advanceTimersByTime(1500);
    expect(navigations).toEqual(['/']);
  });

  test.each([
    [429, {}, ['error', 't:login.too_many_attempts']],
    [401, { message: 'Identifiants invalides' }, ['error', 'Identifiants invalides']],
    [401, {}, ['error', 't:login.invalid_credentials']],
  ])('échec %i : toast et bouton rendu', async (status, body, toast) => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(status, body));
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(toasts).toContainEqual(toast);
    expect(ctx.els.loginForm.querySelector('button[type="submit"]').disabled).toBe(false);
  });

  // Le serveur ne dit plus si le compte attend son activation (oracle
  // d'énumération) : l'aide « renvoyer le lien » suit tout échec générique.
  test('échec générique (400) : message d\'erreur ET aide « compte pas encore activé ? »', async () => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(400, { message: 'Email ou mot de passe incorrect' }));
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(toasts).toContainEqual(['error', 'Email ou mot de passe incorrect']);
    expect(document.getElementById('email-not-verified-notice')).not.toBeNull();
  });

  test('429 ou erreur serveur : pas d\'aide à l\'activation', async () => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(429, { message: 'Trop de tentatives' }));
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(document.getElementById('email-not-verified-notice')).toBeNull();
  });

  test('réponse non JSON et erreur réseau', async () => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValueOnce({ ok: false, status: 500, json: () => Promise.reject(new Error('html')) });
    document.getElementById('login-email').value = 'pilote@x.fr';
    ctx.els.loginPassword.value = 'secret';
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(toasts).toContainEqual(['error', 't:login.invalid_credentials']);
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    await login.forms.onLoginSubmit(ctx, { preventDefault() {} });
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
  });
});

describe('VH.login.forms — inscription', () => {
  function setup() {
    const login = loadModules();
    const ctx = login.state.createContext(document);
    return { login, ctx };
  }
  function fill({ name = 'Pilote', email = 'pilote@x.fr', terms = true } = {}) {
    document.getElementById('register-name').value = name;
    document.getElementById('register-email').value = email;
    document.getElementById('accept-terms').checked = terms;
  }
  const ev = { preventDefault() {} };

  test('conditions non acceptées : message, aucun appel', async () => {
    const { login, ctx } = setup();
    fill({ terms: false });
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.accept_terms_error']);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('nom trop court, email invalide', async () => {
    const { login, ctx } = setup();
    fill({ name: 'A' });
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(document.getElementById('register-name-error').textContent).toBe('t:login.name_too_short');
    fill({ email: 'x' });
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(document.getElementById('register-email-error').textContent).toBe('t:login.invalid_email');
  });

  test('succès : sans mot de passe, jeton hCaptcha transmis, étape « code » sur la page', async () => {
    const { login, ctx } = setup();
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('cap'));
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(201, {}));
    fill({ email: 'p+1@x.fr' });
    await login.forms.onRegisterSubmit(ctx, ev);
    const body = JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body);
    expect(body).toEqual({ name: 'Pilote', email: 'p+1@x.fr', 'h-captcha-response': 'cap' });
    expect(navigations).toEqual([]);
    expect(ctx.state.flow).toEqual({ type: 'verify', email: 'p+1@x.fr', code: null });
    expect(document.getElementById('code-slide').classList.contains('active')).toBe(true);
    expect(document.getElementById('code-email').textContent).toBe('p+1@x.fr');
    expect(window.location.hash).toBe('#code');
  });

  test.each([
    [429, { message: 'Trop' }, ['error', 'Trop']],
    [429, {}, ['error', 't:login.too_many_attempts']],
    [400, {}, ['error', 't:login.account_creation_failed']],
  ])('échec %i', async (status, body, toast) => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(status, body));
    fill();
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(toasts).toContainEqual(toast);
    expect(ctx.els.registerForm.querySelector('button[type="submit"]').disabled).toBe(false);
  });

  test('erreur réseau et réponse non JSON', async () => {
    const { login, ctx } = setup();
    auth.fetchWithTimeout.mockRejectedValueOnce(new Error('réseau'));
    fill();
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.server_error']);
    auth.fetchWithTimeout.mockResolvedValueOnce({ ok: false, status: 502, json: () => Promise.reject(new Error('html')) });
    await login.forms.onRegisterSubmit(ctx, ev);
    expect(toasts).toContainEqual(['error', 't:login.account_creation_failed']);
  });
});

describe('login.js — point d\'entrée', () => {
  async function boot() {
    loadModules();
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/login');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
  }

  test('branche bascules, jauge, compteurs et formulaires après auth.init()', async () => {
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(500, {}));
    await boot();
    expect(auth.init).toHaveBeenCalledTimes(1);
    expect(global.setupPasswordToggle).toHaveBeenCalledTimes(2);
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/stats');
    // Panneau gauche : la photo est cherchée dans le catalogue public.
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith(expect.stringMatching(/^\/api\/airplanes\?search=/));
    document.getElementById('switch-to-register').click();
    expect(document.getElementById('register-slide').classList.contains('active')).toBe(true);
    submit(document.getElementById('register-form'));
    expect(document.getElementById('register-name-error').textContent).toBe('t:login.name_too_short');
  });

  test('formulaires absents : rien n\'est branché, pas d\'auth.init()', async () => {
    document.body.innerHTML = '<p>vide</p>';
    await boot();
    expect(auth.init).not.toHaveBeenCalled();
  });
});

describe('VH.login.forms.navigate', () => {
  test('affecte window.location.href', () => {
    jest.resetModules();
    window.VH = {};
    const forms = require('../js/login/forms');
    const before = window.location.href;
    // jsdom journalise « navigation non implémentée » sans changer d'URL
    const spy = jest.spyOn(console, 'error').mockImplementation(() => {});
    forms.navigate('#ancre');
    spy.mockRestore();
    expect(window.location.href).toBe(before.split('#')[0] + '#ancre');
  });
});
