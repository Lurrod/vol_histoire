/**
 * Tests — morphing des étapes de connexion (js/login/tabs.js + VH.viewMorph).
 * jsdom n'a pas l'API View Transitions : sans elle, la bascule garde la sortie
 * animée d'avant ; avec une API simulée (rappel synchrone), on vérifie les
 * noms posés avant et après la bascule, leur retrait, le sens et le focus.
 */
const { LOGIN_DOM } = require('./helpers/login-dom');

let ctx;
let flow;

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}

function installGlobals() {
  const utils = require('../js/utils');
  Object.assign(global, {
    escapeHtml: utils.escapeHtml,
    setFieldError: utils.setFieldError,
    clearFieldError: utils.clearFieldError,
    isValidEmail: utils.isValidEmail,
    calculatePasswordStrength: utils.calculatePasswordStrength,
    isValidPassword: utils.isValidPassword,
  });
  global.showToast = jest.fn();
  global.i18n = { t: jest.fn((k) => `t:${k}`) };
  global.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve(jsonResponse(200, {}))) };
}

/** En-têtes et pieds de panneau, absents du gabarit commun. */
function decorate() {
  document.querySelectorAll('.form-slide').forEach((slide) => {
    const header = document.createElement('div');
    header.className = 'form-header';
    const tag = slide.id === 'login-slide' ? 'h1' : 'h2';
    header.innerHTML = `<div class="form-icon"></div><${tag} class="t-${slide.id}">${slide.id}</${tag}>`;
    // L'étape « code » porte déjà son titre (#code-title) : on l'y range.
    const own = slide.querySelector('h2');
    if (own) header.replaceChild(own, header.querySelector('h2'));
    slide.prepend(header);
    const footer = document.createElement('div');
    footer.className = 'form-footer';
    slide.appendChild(footer);
  });
}

function load({ reduced = false } = {}) {
  jest.resetModules();
  window.VH = {};
  window.matchMedia = jest.fn(() => ({ matches: reduced }));
  require('./helpers/motion-env').loadMotion();
  require('../js/shared/view-morph');
  require('../js/login/state');
  require('../js/login/strength');
  require('../js/login/tabs');
  require('../js/shared/busy-button');
  require('../js/login/ui');
  require('../js/shared/otp-input');
  require('../js/login/flow');
  ctx = window.VH.login.state.createContext(document);
  window.VH.login.tabs.setupFormSwitching(ctx);
  flow = window.VH.login.flow;
  flow.setup(ctx);
  return window.VH.login.tabs;
}

/** Transition simulée : rappel synchrone, fin contrôlée par le test. */
function mockVt({ deferUpdate = false } = {}) {
  const calls = [];
  let end;
  const finished = new Promise((r) => { end = r; });
  document.startViewTransition = jest.fn((cb) => {
    const call = { before: snapshot(), html: [...document.documentElement.classList], cb };
    calls.push(call);
    if (!deferUpdate) {
      cb();
      call.after = snapshot();
    }
    return { finished, updateCallbackDone: Promise.resolve() };
  });
  return { calls, end: () => end() };
}

/** Noms de transition posés dans le document : { nom: id ou classe }. */
function snapshot() {
  const out = {};
  document.querySelectorAll('*').forEach((el) => {
    const n = el.style.viewTransitionName;
    if (n) out[n] = el.id || el.className;
  });
  return out;
}

const flush = () => new Promise((r) => setTimeout(r, 0));
const $ = (id) => document.getElementById(id);
const active = () => document.querySelector('.form-slide.active')?.id;
const htmlCls = () => document.documentElement.className;

beforeEach(() => {
  window.history.replaceState(null, '', '/login');
  document.body.innerHTML = LOGIN_DOM;
  document.documentElement.className = '';
  decorate();
  installGlobals();
  delete window.getHcaptchaToken;
  delete document.startViewTransition;
});

afterEach(() => {
  delete document.startViewTransition;
  document.documentElement.className = '';
});

describe('sans l\'API View Transitions (repli)', () => {
  test('bascule comme avant : aucun nom, pas de .no-enter, focus sur le premier champ', () => {
    const tabs = load();
    expect(tabs.canMorph()).toBe(false);
    $('switch-to-register').click();
    expect(active()).toBe('register-slide');
    expect($('register-slide').classList.contains('no-enter')).toBe(false);
    expect(document.activeElement.id).toBe('register-name');
    expect(snapshot()).toEqual({});
    expect(htmlCls()).toBe('');
  });

  test('mouvement réduit : l\'API présente n\'est pas utilisée', () => {
    const tabs = load({ reduced: true });
    const vt = mockVt();
    expect(tabs.canMorph()).toBe(false);
    $('tab-register').click();
    expect(document.startViewTransition).not.toHaveBeenCalled();
    expect(vt.calls).toHaveLength(0);
    expect(active()).toBe('register-slide');
  });

  test('page masquée : pas de morphing', () => {
    const tabs = load();
    mockVt();
    const spy = jest.spyOn(document, 'hidden', 'get').mockReturnValue(true);
    expect(tabs.canMorph()).toBe(false);
    spy.mockRestore();
  });
});

describe('avec l\'API View Transitions (simulée)', () => {
  test('connexion → inscription : cadre, onglets, icône, titre, bouton et pied nommés des deux côtés', async () => {
    load();
    const vt = mockVt();
    $('switch-to-register').click();
    expect(vt.calls).toHaveLength(1);
    const { before, after, html } = vt.calls[0];
    expect(html).toContain('vh-login-fwd');
    expect(before).toEqual({
      'vh-login-frame': 'form-container',
      'vh-login-tabs': '',
      'vh-login-icon': 'form-icon',
      'vh-login-title': 't-login-slide',
      'vh-login-submit': 'btn-submit',
      'vh-login-footer': 'form-footer',
    });
    // Après la bascule, les éléments du nouveau panneau portent les mêmes
    // noms (l'ancien panneau, masqué, n'est plus capturé).
    const reg = $('register-slide');
    expect(reg.querySelector('h2').style.viewTransitionName).toBe('vh-login-title');
    expect(reg.querySelector('.btn-submit').style.viewTransitionName).toBe('vh-login-submit');
    expect(after['vh-login-frame']).toBe('form-container');
    // Bascule faite dans la transition, sans sortie slideOut ni slideIn.
    expect(active()).toBe('register-slide');
    expect($('login-slide').classList.contains('is-leaving')).toBe(false);
    expect(reg.classList.contains('no-enter')).toBe(true);
    expect(document.activeElement.id).toBe('register-name');
    expect(ctx.state.pendingSwap).toBeNull();
    // Fin de la transition : noms et classe de sens retirés.
    vt.end();
    await flush();
    expect(snapshot()).toEqual({});
    expect(htmlCls()).toBe('');
  });

  test('retour à la connexion : sens inversé ; .no-enter retiré du panneau quitté', async () => {
    load();
    let vt = mockVt();
    $('tab-register').click();
    vt.end();
    await flush();
    vt = mockVt();
    $('switch-to-login').click();
    expect(vt.calls[0].html).toContain('vh-login-back');
    expect(active()).toBe('login-slide');
    expect($('register-slide').classList.contains('no-enter')).toBe(false);
    expect(document.activeElement.id).toBe('login-email');
    vt.end();
    await flush();
  });

  test('étapes par code : onglets nommés seulement à la sortie, bouton absent de « code »', async () => {
    load();
    let vt = mockVt();
    flow.go(ctx, 'forgot');
    expect(vt.calls[0].before['vh-login-tabs']).toBe('');
    expect($('tab-login').parentElement.style.viewTransitionName).toBe('vh-login-tabs');
    expect(vt.calls[0].html).toContain('vh-login-fwd');
    expect(document.activeElement.id).toBe('forgot-email');
    vt.end();
    await flush();

    vt = mockVt();
    flow.startCode(ctx, 'reset', 'pilote@x.fr');
    const { before, after } = vt.calls[0];
    expect(before['vh-login-tabs']).toBeUndefined();
    expect(before['vh-login-submit']).toBe('btn-submit');
    expect(after['vh-login-title']).toBe('code-title');
    // Focus dans le champ de code, comme sans morphing.
    expect($('code-otp').contains(document.activeElement)).toBe(true);
    expect(window.location.hash).toBe('#code');
    vt.end();
    await flush();

    // Retour par l'historique (#mot-de-passe-oublie) : transition à l'envers.
    vt = mockVt();
    window.history.replaceState(null, '', '/login#mot-de-passe-oublie');
    flow.fromHash(ctx);
    expect(vt.calls[0].html).toContain('vh-login-back');
    expect(active()).toBe('forgot-slide');
    expect(document.activeElement.id).toBe('forgot-email');
    vt.end();
    await flush();
    expect(snapshot()).toEqual({});
  });

  test('préremplissage (after) appliqué une fois le panneau affiché', async () => {
    load();
    const vt = mockVt();
    flow.go(ctx, 'register', {
      after: () => { $('register-email').value = 'pilote@x.fr'; },
    });
    expect($('register-email').value).toBe('pilote@x.fr');
    vt.end();
    await flush();
  });

  test('seconde bascule pendant un morphing : la première se termine, la seconde est immédiate', async () => {
    load();
    const vt = mockVt({ deferUpdate: true });
    $('tab-register').click();
    // Mise à jour pas encore jouée : bascule en attente, panneau sortant inerte.
    expect(active()).toBe('login-slide');
    expect($('login-slide').inert).toBe(true);
    expect(typeof ctx.state.pendingSwap).toBe('function');
    $('tab-login').click();
    expect(document.startViewTransition).toHaveBeenCalledTimes(1);
    expect(active()).toBe('login-slide');
    expect($('login-slide').inert).toBe(false);
    // Le rappel de la transition arrive ensuite : sans effet.
    vt.calls[0].cb();
    expect(active()).toBe('login-slide');
    vt.end();
    await flush();
    expect(htmlCls()).toBe('');
  });

  test('panneau déjà affiché : rien à animer, classes conservées', () => {
    load();
    mockVt();
    $('register-slide').classList.add('no-enter');
    flow.go(ctx, 'login');
    expect(document.startViewTransition).not.toHaveBeenCalled();
    expect(active()).toBe('login-slide');
  });

  test('morphNames : sans conteneur ni panneau actif, rien n\'est nommé', () => {
    const tabs = load();
    document.querySelectorAll('.form-slide').forEach((s) => s.classList.remove('active'));
    expect(tabs.morphNames({ els: { ...ctx.els, container: null } })).toEqual([]);
  });
});
