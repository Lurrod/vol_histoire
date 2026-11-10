/**
 * Tests — page Paramètres (js/settings/*.js + js/settings.js).
 * Découpage ARCH-004 : chaque module VH.settings.* est testé sur un DOM
 * réduit à ses éléments, l'API étant simulée.
 */

const utils = require('../js/utils');
// DOMPurify réel (devDependency) : safeSetHTML l'utilise comme en production.
global.DOMPurify = require('dompurify');

const SETTINGS_DOM = `
  <header><span id="user-name">Utilisateur</span><span class="user-role">Membre</span></header>
  <section class="settings-section">
    <nav>
      <a href="#dashboard" class="sidebar-link active" data-section="dashboard" id="tab-dashboard" aria-selected="true" tabindex="0">Dashboard</a>
      <a href="#profile" class="sidebar-link" data-section="profile" id="tab-profile" aria-selected="false" tabindex="-1">Profil</a>
      <a href="#admin" class="sidebar-link hidden" data-section="admin" id="admin-nav-link" aria-selected="false" tabindex="-1">Admin</a>
      <a href="#danger" class="sidebar-link" data-section="danger" id="tab-danger" aria-selected="false" tabindex="-1">Danger</a>
    </nav>
    <div id="dashboard" class="content-section active">
      <div id="db-avatar">U</div><h2 id="db-name"></h2><span id="db-role-badge" class="db-role-badge role-member"></span><p id="db-email"></p>
      <div id="db-kpis"><div id="db-total-fav">0</div><div id="db-total-countries">0</div><div id="db-total-gen">0</div><div id="db-total-types">0</div></div>
      <div id="db-charts"><div id="db-country-bars"></div><div id="db-gen-bars"></div></div>
      <div id="db-type-block"><div id="db-type-bars"></div></div>
      <div id="db-empty" class="hidden"></div>
    </div>
    <div id="profile" class="content-section" hidden>
      <form id="profile-form">
        <div><input id="name"></div>
        <div><input id="email"></div>
        <div id="profile-current-password-group" hidden><input type="password" id="profile-current-password"></div>
        <button type="submit">Enregistrer</button>
        <button type="button" id="reset-profile-btn">Annuler</button>
      </form>
    </div>
    <div id="security" class="content-section" hidden>
      <form id="security-form">
        <div><input type="password" id="current-password"></div>
        <div><input type="password" id="password"><button type="button" id="toggle-password"></button></div>
        <div class="strength-bar"></div><div class="strength-bar"></div><div class="strength-bar"></div><div class="strength-bar"></div>
        <span id="strength-text"></span>
        <ul><li id="req-length"></li><li id="req-upper"></li><li id="req-lower"></li><li id="req-number"></li></ul>
        <button type="submit">Changer</button>
      </form>
    </div>
    <div id="privacy" class="content-section" hidden>
      <input type="checkbox" id="pref-analytics"><span id="analytics-status"></span>
      <strong id="consent-date" data-i18n="settings.never">Jamais</strong>
      <button id="save-cookie-preferences">Enregistrer</button>
      <button id="open-cookie-modal">Ouvrir</button>
      <button type="button" id="export-data-btn"><span>Télécharger mes données</span></button>
    </div>
    <div id="admin" class="content-section hidden" hidden>
      <input id="user-filter"><span id="total-users">0</span>
      <div id="user-list"></div><div id="user-pagination"></div>
    </div>
    <div id="danger" class="content-section" hidden><button type="button" id="delete-account-btn"><span>Supprimer</span></button></div>
  </section>
  <div id="edit-user-modal" class="hidden">
    <div class="logout-modal-backdrop"></div>
    <h2 id="edit-user-modal-title"></h2>
    <div><input id="edit-user-name"></div><div><input id="edit-user-email"></div>
    <select id="edit-user-role"><option value="1">Admin</option><option value="2">Éditeur</option><option value="3">Membre</option></select>
    <button id="edit-user-cancel">Annuler</button><button id="edit-user-save">Enregistrer</button>
  </div>`;

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}
const flush = async (n = 4) => { for (let i = 0; i < n; i++) await Promise.resolve(); };
const tick = () => new Promise((r) => setTimeout(r, 0));

let auth;
let toasts;

function installGlobals() {
  Object.assign(global, {
    escapeHtml: utils.escapeHtml,
    safeSetHTML: utils.safeSetHTML,
    setFieldError: utils.setFieldError,
    clearFieldError: utils.clearFieldError,
    isValidEmail: utils.isValidEmail,
    calculatePasswordStrength: utils.calculatePasswordStrength,
    setupPasswordToggle: jest.fn(),
  });
  toasts = [];
  global.showToast = jest.fn((msg, type) => toasts.push([type, msg]));
  global.i18n = { currentLang: 'fr', t: jest.fn((k, p) => (p ? `t:${k}:${JSON.stringify(p)}` : `t:${k}`)) };
  auth = {
    init: jest.fn(() => Promise.resolve(null)),
    getPayload: jest.fn(() => ({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 })),
    getUserInfo: jest.fn(() => null),
    setUserInfo: jest.fn(),
    setToken: jest.fn(),
    clearSession: jest.fn(),
    logout: jest.fn(() => Promise.resolve()),
    authFetch: jest.fn(() => Promise.resolve(jsonResponse(200, {}))),
  };
  global.auth = auth;
}

function loadModules() {
  jest.resetModules();
  window.VH = {};
  // window.VH.consent (cookies.js, chargé avant settings.min.js dans app.min.js)
  global.safeSetHTML = utils.safeSetHTML;
  require('../js/cookies');
  ['ui', 'tabs', 'account', 'profile', 'security', 'danger-zone', 'admin', 'dashboard', 'cookies', 'data-export']
    .forEach((m) => require(`../js/settings/${m}`));
  return window.VH.settings;
}

beforeEach(() => {
  document.body.innerHTML = SETTINGS_DOM;
  installGlobals();
  window.matchMedia = jest.fn(() => ({ matches: false }));
  window.Element.prototype.scrollIntoView = jest.fn();
  window.scrollTo = jest.fn();
  localStorage.clear();
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
});

describe('VH.settings.ui', () => {
  test('tr : traduction ou repli', () => {
    const { ui } = loadModules();
    expect(ui.tr('a.b', 'repli')).toBe('t:a.b');
    i18n.t.mockImplementation((k) => k);
    expect(ui.tr('a.b', 'repli')).toBe('repli');
  });

  test('setButtonLoading : spinner + libellé lu, puis restauration ; bouton absent toléré', () => {
    const { ui } = loadModules();
    const btn = document.getElementById('delete-account-btn');
    const html = btn.innerHTML;
    ui.setButtonLoading(btn, true);
    expect(btn.querySelector('.spinner')).not.toBeNull();
    expect(btn.querySelector('.sr-only').textContent).toBe('Supprimer');
    ui.setButtonLoading(btn, false);
    expect(btn.innerHTML).toBe(html);
    expect(() => ui.setButtonLoading(null, true)).not.toThrow();
  });

  test('scrollBehavior respecte prefers-reduced-motion', () => {
    const { ui } = loadModules();
    expect(ui.scrollBehavior()).toBe('smooth');
    window.matchMedia = jest.fn(() => ({ matches: true }));
    expect(ui.scrollBehavior()).toBe('auto');
  });
});

describe('VH.settings.tabs', () => {
  test('clic : onglet et section actifs, défilement vers la section', () => {
    const { tabs } = loadModules();
    tabs.setup();
    document.getElementById('tab-profile').click();
    expect(document.getElementById('tab-profile').getAttribute('aria-selected')).toBe('true');
    expect(document.getElementById('tab-dashboard').tabIndex).toBe(-1);
    expect(document.getElementById('profile').hidden).toBe(false);
    expect(document.getElementById('dashboard').hidden).toBe(true);
    expect(window.Element.prototype.scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth', block: 'start' });
  });

  test('clavier : onglet masqué sauté, bouclage, Début / Fin, focus sans défilement', () => {
    const { tabs } = loadModules();
    tabs.setup();
    const key = (id, k) => document.getElementById(id).dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true }));
    key('tab-dashboard', 'ArrowDown');
    expect(document.activeElement.id).toBe('tab-profile');
    key('tab-profile', 'ArrowRight');
    expect(document.activeElement.id).toBe('tab-danger'); // admin masqué
    key('tab-danger', 'ArrowDown');
    expect(document.activeElement.id).toBe('tab-dashboard');
    key('tab-dashboard', 'ArrowUp');
    expect(document.activeElement.id).toBe('tab-danger');
    key('tab-danger', 'Home');
    expect(document.activeElement.id).toBe('tab-dashboard');
    key('tab-dashboard', 'End');
    expect(document.activeElement.id).toBe('tab-danger');
    key('tab-danger', 'ArrowLeft');
    expect(document.activeElement.id).toBe('tab-profile');
    key('tab-profile', 'a');
    expect(document.activeElement.id).toBe('tab-profile');
    key('admin-nav-link', 'ArrowDown'); // onglet masqué : ignoré
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
  });

  test('activateTab : onglet masqué ignoré, repli sur scrollTo', () => {
    const { tabs } = loadModules();
    tabs.activateTab(document.getElementById('admin-nav-link'));
    expect(document.getElementById('admin').hidden).toBe(true);
    document.querySelector('.settings-section').classList.remove('settings-section');
    tabs.activateTab(document.getElementById('tab-danger'));
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });
});

describe('VH.settings.account', () => {
  test('userFromPayload', () => {
    const { account } = loadModules();
    expect(account.userFromPayload({ id: 2, role: '3' })).toEqual({ id: 2, name: 'Utilisateur', email: '', role: 3 });
    expect(account.userFromPayload(null)).toEqual({ name: 'Utilisateur', email: '' });
  });

  test('utilisateur en mémoire : formulaire rempli, administration révélée', async () => {
    const { account } = loadModules();
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 });
    const state = { currentUser: null };
    expect(await account.checkAuth(state)).toBe(true);
    expect(state.currentUser.name).toBe('Chef');
    expect(document.getElementById('name').value).toBe('Chef');
    expect(document.getElementById('user-name').textContent).toBe('Chef');
    expect(document.querySelector('.user-role').textContent).toBe('t:common.role_admin');
    expect(document.getElementById('admin-nav-link').classList.contains('hidden')).toBe(false);
  });

  test('sinon l\'API ; éditeur : pas d\'administration', async () => {
    const { account } = loadModules();
    auth.authFetch.mockResolvedValue(jsonResponse(200, { id: 1, name: 'Ed', email: 'ed@x.fr', role: 2 }));
    const state = { currentUser: null };
    await account.checkAuth(state);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/1');
    expect(auth.setUserInfo).toHaveBeenCalledWith(state.currentUser);
    expect(document.getElementById('email').value).toBe('ed@x.fr');
    expect(document.querySelector('.user-role').textContent).toBe('t:common.role_editor');
    expect(document.getElementById('admin-nav-link').classList.contains('hidden')).toBe(true);
  });

  test('API en erreur puis réseau coupé : utilisateur du jeton', async () => {
    const { account } = loadModules();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    const state = { currentUser: null };
    await account.checkAuth(state);
    expect(state.currentUser).toEqual({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 });
    expect(document.getElementById('admin').classList.contains('hidden')).toBe(false);

    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    auth.getPayload.mockReturnValue({ id: 3, role: 3 });
    const state2 = { currentUser: null };
    await account.checkAuth(state2);
    expect(state2.currentUser.name).toBe('Utilisateur');
    expect(document.querySelector('.user-role').textContent).toBe('t:nav.user_role');
  });

  test('sans session : un rafraîchissement tenté puis redirection vers /login', async () => {
    const { account } = loadModules();
    auth.getPayload.mockReturnValue(null);
    auth.authFetch.mockRejectedValue(new Error('401'));
    const state = { currentUser: null };
    const spy = jest.spyOn(console, 'error').mockImplementation(() => {}); // navigation jsdom
    expect(await account.checkAuth(state)).toBe(false);
    spy.mockRestore();
    expect(auth.authFetch).toHaveBeenCalledWith('/api/stats');
  });

  test('session revenue après rafraîchissement', async () => {
    const { account } = loadModules();
    auth.getPayload.mockReturnValueOnce(null).mockReturnValue({ id: 1, role: 3 });
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'R', email: 'r@x.fr', role: 3 });
    const state = { currentUser: null };
    expect(await account.checkAuth(state)).toBe(true);
    expect(state.currentUser.name).toBe('R');
  });

  test('updateUserDisplay sans utilisateur : libellé par défaut', () => {
    const { account } = loadModules();
    account.updateUserDisplay({ currentUser: null });
    expect(document.getElementById('user-name').textContent).toBe('t:nav.user_default');
  });
});

describe('VH.settings.profile', () => {
  function setup(user = { id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 }) {
    const S = loadModules();
    const state = { currentUser: user };
    S.profile.setup(state);
    document.getElementById('name').value = user.name;
    document.getElementById('email').value = user.email;
    return { S, state };
  }
  const submit = () => document.getElementById('profile-form').dispatchEvent(new window.Event('submit', { cancelable: true }));

  test('le mot de passe actuel n\'est demandé que si l\'adresse change', () => {
    setup();
    const email = document.getElementById('email');
    email.value = ' CHEF@x.fr ';
    email.dispatchEvent(new window.Event('input'));
    expect(document.getElementById('profile-current-password-group').hidden).toBe(true);
    email.value = 'autre@x.fr';
    email.dispatchEvent(new window.Event('input'));
    expect(document.getElementById('profile-current-password-group').hidden).toBe(false);
  });

  test('validation : nom, email, mot de passe actuel', () => {
    setup();
    document.getElementById('name').value = 'A';
    submit();
    expect(document.getElementById('name-error').textContent).toBe('t:settings.toast_name_min');
    document.getElementById('name').value = 'Chef';
    document.getElementById('email').value = 'x';
    submit();
    expect(document.getElementById('email-error').textContent).toBe('t:settings.toast_email_invalid');
    document.getElementById('email').value = 'autre@x.fr';
    submit();
    expect(document.getElementById('profile-current-password-error').textContent).toBe('t:settings.toast_current_password_required');
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('nom seul : PUT {name}, toast de succès', async () => {
    const { state } = setup();
    document.getElementById('name').value = 'Nouveau';
    auth.authFetch.mockResolvedValue(jsonResponse(200, {}));
    submit();
    await tick();
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body)).toEqual({ name: 'Nouveau' });
    expect(state.currentUser.name).toBe('Nouveau');
    expect(toasts).toContainEqual(['success', 't:settings.toast_profile_updated']);
  });

  test('changement d\'adresse en attente : adresse actuelle conservée', async () => {
    const { state } = setup();
    document.getElementById('email').value = 'autre@x.fr';
    document.getElementById('profile-current-password').value = 'Secret1';
    auth.authFetch.mockResolvedValue(jsonResponse(200, { emailChangePending: true }));
    submit();
    await tick();
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body)).toEqual({ name: 'Chef', email: 'autre@x.fr', currentPassword: 'Secret1' });
    expect(document.getElementById('email').value).toBe('chef@x.fr');
    expect(document.getElementById('profile-current-password').value).toBe('');
    expect(state.currentUser.email).toBe('chef@x.fr');
    expect(toasts).toContainEqual(['info', 't:settings.toast_email_change_pending']);
  });

  test('mot de passe actuel refusé, autre erreur, réseau', async () => {
    setup();
    document.getElementById('name').value = 'Nouveau';
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { code: 'CURRENT_PASSWORD_INVALID' }));
    submit(); await tick();
    expect(document.getElementById('profile-current-password-error').textContent).toBe('t:settings.toast_current_password_invalid');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(400, { message: 'Non' }));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 'Non']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(document.querySelector('#profile-form [type="submit"]').disabled).toBe(false);
  });

  test('bouton de réinitialisation', () => {
    setup();
    document.getElementById('name').value = 'X';
    document.getElementById('reset-profile-btn').click();
    expect(document.getElementById('name').value).toBe('Chef');
    expect(toasts).toContainEqual(['info', 't:settings.toast_form_reset']);
  });
});

describe('VH.settings.security', () => {
  function setup() {
    const S = loadModules();
    const state = { currentUser: { id: 1 } };
    S.security.setup(state);
    return S;
  }
  const submit = () => document.getElementById('security-form').dispatchEvent(new window.Event('submit', { cancelable: true }));

  test('exigences et jauge suivent la saisie', () => {
    setup();
    const pw = document.getElementById('password');
    pw.value = 'abc';
    pw.dispatchEvent(new window.Event('input'));
    expect(document.getElementById('req-lower').classList.contains('valid')).toBe(true);
    expect(document.getElementById('req-length').classList.contains('valid')).toBe(false);
    expect(document.querySelectorAll('.strength-bar.active.weak')).toHaveLength(1);
    expect(document.getElementById('strength-text').textContent).toBe('t:settings.strength_weak');
    pw.value = 'Abcdefgh1';
    pw.dispatchEvent(new window.Event('input'));
    expect(document.getElementById('strength-text').textContent).toBe('t:settings.strength_strong');
    pw.value = 'abcdefgh';
    pw.dispatchEvent(new window.Event('input'));
    expect(document.querySelectorAll('.strength-bar.medium')).toHaveLength(2);
  });

  test('strengthLabel et meetsRequirements', () => {
    const { security } = setup();
    expect(security.strengthLabel('', 0).key).toBe('settings.password_strength');
    expect(security.strengthLabel('x', 50).key).toBe('settings.strength_medium');
    expect(security.meetsRequirements('Abcdefg1')).toBe(true);
    expect(security.meetsRequirements('Abcdefgh')).toBe(false);
  });

  test('validation : mot de passe actuel, nouveau absent, nouveau trop faible', () => {
    setup();
    submit();
    expect(document.getElementById('current-password-error').textContent).toBe('t:settings.toast_current_password_required');
    document.getElementById('current-password').value = 'Ancien1';
    submit();
    expect(document.getElementById('password-error').textContent).toBe('Veuillez entrer un nouveau mot de passe');
    document.getElementById('password').value = 'faible';
    submit();
    expect(document.getElementById('password-error').textContent).toBe('t:settings.toast_password_min');
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('succès : nouveau jeton, formulaire remis à zéro', async () => {
    setup();
    document.getElementById('current-password').value = 'Ancien1';
    document.getElementById('password').value = 'Nouveau12';
    auth.authFetch.mockResolvedValue(jsonResponse(200, { token: 'neuf' }));
    submit(); await tick();
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body)).toEqual({ password: 'Nouveau12', currentPassword: 'Ancien1' });
    expect(auth.setToken).toHaveBeenCalledWith('neuf');
    expect(document.getElementById('password').value).toBe('');
    expect(document.getElementById('strength-text').textContent).toBe('t:settings.password_strength');
  });

  test('erreurs serveur et réseau', async () => {
    setup();
    document.getElementById('current-password').value = 'Ancien1';
    document.getElementById('password').value = 'Nouveau12';
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { code: 'CURRENT_PASSWORD_REQUIRED' }));
    submit(); await tick();
    expect(document.getElementById('current-password-error').textContent).toBe('t:settings.toast_current_password_invalid');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(400, {}));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 't:settings.toast_profile_error']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    submit(); await tick();
    expect(toasts.pop()[1]).toMatch(/^API non disponible/);
  });
});

describe('VH.settings.dangerZone', () => {
  function setup() {
    const S = loadModules();
    S.dangerZone.setup({ currentUser: { id: 5 } });
    return S;
  }

  test('annulation : rien ; mauvais mot : toast d\'erreur', async () => {
    const S = setup();
    window.prompt = jest.fn(() => null);
    await S.dangerZone.onDeleteClick({ currentUser: { id: 5 } }, document.getElementById('delete-account-btn'));
    expect(toasts).toEqual([]);
    window.prompt = jest.fn(() => 'oui');
    await S.dangerZone.onDeleteClick({ currentUser: { id: 5 } }, document.getElementById('delete-account-btn'));
    expect(toasts).toContainEqual(['error', 't:settings.toast_delete_confirm_mismatch']);
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('mot correct : DELETE, déconnexion, redirection différée', async () => {
    jest.useFakeTimers();
    setup();
    i18n.t.mockImplementation((k) => (k === 'settings.delete_confirm_word' ? 'DELETE' : `t:${k}`));
    window.prompt = jest.fn(() => ' DELETE ');
    document.getElementById('delete-account-btn').click();
    await flush(6);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/5', { method: 'DELETE' });
    expect(auth.logout).toHaveBeenCalled();
    expect(toasts).toContainEqual(['success', 't:settings.toast_account_deleted']);
  });

  test('refus du serveur puis réseau : bouton rendu', async () => {
    const S = setup();
    window.prompt = jest.fn(() => 'SUPPRIMER');
    i18n.t.mockImplementation((k) => k); // repli français
    const btn = document.getElementById('delete-account-btn');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(400, {}));
    await S.dangerZone.onDeleteClick({ currentUser: { id: 5 } }, btn);
    expect(toasts).toContainEqual(['error', 'Erreur lors de la suppression']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.dangerZone.onDeleteClick({ currentUser: { id: 5 } }, btn);
    expect(toasts).toContainEqual(['error', 'settings.toast_network_error']);
    expect(btn.disabled).toBe(false);
  });
});

describe('VH.settings.admin', () => {
  const USERS = [
    { id: 1, name: 'Chef', email: 'chef@x.fr', role_id: 1 },
    { id: 2, name: '<img src=x onerror=alert(1)>', email: 'b@x.fr', role_id: 2 },
    { id: 3, name: '', email: 'c@x.fr', role_id: 3 },
  ];
  function setup(meta = { total: 19, totalPages: 3 }) {
    const S = loadModules();
    const state = { currentUser: { id: 1 } };
    S.admin.init(state);
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: USERS, meta }));
    return S;
  }

  test('roleView et carte utilisateur échappée, sans bouton de suppression pour soi', () => {
    const S = setup();
    expect(S.admin.roleView(2)).toEqual({ label: 'Éditeur', badge: 'badge-editor' });
    const own = S.admin.userCardHtml(USERS[0], 1);
    expect(own).not.toContain('btn-delete');
    const other = S.admin.userCardHtml(USERS[1], 1);
    expect(other).toContain('&lt;img');
    expect(other).toContain('btn-delete');
    expect(S.admin.userCardHtml(USERS[2], 1)).toContain('>?<');
  });

  test('chargement : liste, pagination, total ; navigation entre pages', async () => {
    const S = setup();
    await S.admin.loadUsers();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
    expect(document.querySelectorAll('.user-card')).toHaveLength(3);
    expect(document.getElementById('total-users').textContent).toBe('19');
    expect(document.querySelector('.prev-page-btn').disabled).toBe(true);
    document.querySelector('.next-page-btn').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=2&limit=8');
    document.querySelector('.prev-page-btn').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
  });

  test('page au-delà du total : recul et nouveau chargement', async () => {
    const S = setup({ total: 3, totalPages: 1 });
    await S.admin.loadUsers();
    document.querySelector('.next-page-btn').click(); // désactivé : sans effet
    const ctx = S.admin.init({ currentUser: { id: 1 } });
    ctx.page = 4;
    await S.admin.loadUsers();
    expect(ctx.page).toBe(1);
  });

  test('total nul : pagination vide ; meta absente : déduite de la liste', async () => {
    const S = setup({ total: 0, totalPages: 1 });
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: [] , meta: { total: 0 } }));
    await S.admin.loadUsers();
    expect(document.getElementById('user-pagination').innerHTML).toBe('');
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: 'pas un tableau' }));
    await S.admin.loadUsers();
    expect(document.getElementById('total-users').textContent).toBe('0');
  });

  test('401 : session effacée ; 500 et réseau : message dans la liste', async () => {
    jest.useFakeTimers();
    const S = setup();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(401, {}));
    await S.admin.loadUsers();
    expect(auth.clearSession).toHaveBeenCalled();
    expect(toasts).toContainEqual(['error', 't:settings.toast_session_expired']);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    await S.admin.loadUsers();
    expect(document.getElementById('user-list').textContent).toBe('t:settings.admin_api_unavailable');
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.loadUsers();
    expect(document.getElementById('user-list').textContent).toBe('t:settings.toast_users_error');
  });

  test('recherche temporisée côté serveur', async () => {
    jest.useFakeTimers();
    setup();
    const input = document.getElementById('user-filter');
    input.value = ' pil ';
    input.dispatchEvent(new window.Event('input'));
    input.value = ' pilo ';
    input.dispatchEvent(new window.Event('input'));
    jest.advanceTimersByTime(300);
    expect(auth.authFetch).toHaveBeenCalledTimes(1);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users?page=1&limit=8&search=pilo');
  });

  test('édition : modale pré-remplie, validation, enregistrement, fermeture', async () => {
    const S = setup();
    await S.admin.loadUsers();
    document.querySelectorAll('.btn-edit')[2].click();
    const modal = document.getElementById('edit-user-modal');
    expect(modal.classList.contains('hidden')).toBe(false);
    expect(document.getElementById('edit-user-email').value).toBe('c@x.fr');
    expect(document.getElementById('edit-user-role').value).toBe('3');

    document.getElementById('edit-user-name').value = 'Z';
    document.getElementById('edit-user-save').click();
    expect(document.getElementById('edit-user-name-error').textContent).toBe('t:settings.toast_name_min');
    document.getElementById('edit-user-name').dispatchEvent(new window.Event('input'));
    expect(document.getElementById('edit-user-name').hasAttribute('aria-invalid')).toBe(false);

    document.getElementById('edit-user-name').value = 'Zoé';
    document.getElementById('edit-user-email').value = 'pas-email';
    document.getElementById('edit-user-save').click();
    expect(document.getElementById('edit-user-email-error').textContent).toBe('t:settings.toast_email_invalid');
    document.getElementById('edit-user-email').dispatchEvent(new window.Event('input'));

    document.getElementById('edit-user-email').value = 'zoe@x.fr';
    document.getElementById('edit-user-role').value = '2';
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    await S.admin.saveEditedUser();
    const call = auth.authFetch.mock.calls.find(([url]) => url === '/api/admin/users/3');
    expect(JSON.parse(call[1].body)).toEqual({ name: 'Zoé', email: 'zoe@x.fr', role_id: 2 });
    expect(toasts).toContainEqual(['success', 'Utilisateur modifié avec succès']);
    expect(modal.classList.contains('show')).toBe(false);
  });

  test('édition : refus du serveur, réseau, annulation et voile', async () => {
    const S = setup();
    S.admin.openEditUserModal(USERS[1]);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(409, {}));
    document.getElementById('edit-user-email').value = 'b@x.fr';
    document.getElementById('edit-user-name').value = 'Bob';
    await S.admin.saveEditedUser();
    expect(toasts).toContainEqual(['error', 'Erreur lors de la modification']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.saveEditedUser();
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    jest.useFakeTimers();
    document.getElementById('edit-user-cancel').click();
    jest.advanceTimersByTime(300);
    expect(document.getElementById('edit-user-modal').classList.contains('hidden')).toBe(true);
    document.querySelector('.logout-modal-backdrop').click();
  });

  test('suppression : confirmation refusée, acceptée, refus serveur, réseau', async () => {
    const S = setup();
    window.confirm = jest.fn(() => false);
    await S.admin.deleteUser(2);
    expect(auth.authFetch).not.toHaveBeenCalled();
    window.confirm = jest.fn(() => true);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    await S.admin.deleteUser(2);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/2', { method: 'DELETE' });
    expect(toasts).toContainEqual(['success', 't:settings.toast_user_deleted']);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { message: 'Interdit' }));
    await S.admin.deleteUser(2);
    expect(toasts).toContainEqual(['error', 'Interdit']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.deleteUser(2);
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
  });

  test('loadUsers avant init : sans effet', async () => {
    const S = loadModules();
    await S.admin.loadUsers();
    expect(auth.authFetch).not.toHaveBeenCalled();
  });
});

describe('VH.settings.dashboard', () => {
  const FAVS = [
    { generation: 4, country_name: 'France', country_name_en: 'France', type_name: 'Multirôle', type_name_en: 'Multirole' },
    { generation: 4, country_name: 'États-Unis', country_name_en: 'United States', type_name: 'Chasseur', type_name_en: 'Fighter' },
    { generation: 5, country_name: 'États-Unis', type_name: 'Chasseur' },
    { generation: 1, country_name: 'URSS', type_name: 'Intercepteur' },
  ];

  test('computeStats : comptes et répartitions, libellés de génération', () => {
    const { dashboard } = loadModules();
    const fr = dashboard.computeStats(FAVS, 'fr');
    expect(fr).toMatchObject({ total: 4, countries: 3, generations: 3, types: 3 });
    expect(fr.byCountry).toEqual({ France: 1, 'États-Unis': 2, URSS: 1 });
    expect(Object.keys(fr.byGeneration)).toEqual(['Gen 1', 'Gen 4', 'Gen 5']);
    const en = dashboard.computeStats(FAVS, 'en');
    expect(en.byCountry).toEqual({ France: 1, 'United States': 1, 'États-Unis': 1, URSS: 1 });
    expect(Object.keys(en.byGeneration)).toEqual(['1st Gen', '4th Gen', '5th Gen']);
    expect(dashboard.generationLabel('2', 'en')).toBe('2nd Gen');
    expect(dashboard.generationLabel('3', 'en')).toBe('3rd Gen');
  });

  test('loadDashboard : carte de profil, compteurs, barres', async () => {
    jest.useFakeTimers();
    window.requestAnimationFrame = (cb) => setTimeout(cb, 0);
    const { dashboard } = loadModules();
    auth.authFetch.mockResolvedValue(jsonResponse(200, FAVS));
    await dashboard.loadDashboard({ currentUser: { name: 'chef', email: 'c@x.fr', role: 2 } });
    expect(document.getElementById('db-avatar').textContent).toBe('C');
    expect(document.getElementById('db-role-badge').className).toBe('db-role-badge role-editor');
    jest.advanceTimersByTime(1000);
    expect(document.getElementById('db-total-fav').textContent).toBe('4');
    const rows = document.querySelectorAll('#db-country-bars .db-bar-row');
    expect(rows[0].querySelector('.db-bar-label').textContent).toBe('États-Unis');
    expect(rows[0].querySelector('.db-bar-fill').style.width).toBe('100%');
    expect(document.querySelectorAll('#db-gen-bars .db-bar-label')[0].textContent).toBe('Gen 1');
  });

  test('aucun favori : bloc vide ; erreurs API silencieuses', async () => {
    const { dashboard } = loadModules();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, []));
    await dashboard.loadDashboard({ currentUser: null });
    expect(document.getElementById('db-empty').classList.contains('hidden')).toBe(false);
    expect(document.getElementById('db-kpis').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('db-name').textContent).toBe('Utilisateur');
    expect(document.getElementById('db-role-badge').className).toBe('db-role-badge role-member');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    await expect(dashboard.loadDashboard({ currentUser: { role: 1 } })).resolves.toBeUndefined();
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await expect(dashboard.loadDashboard({ currentUser: { role: 1 } })).resolves.toBeUndefined();
    expect(document.getElementById('db-role-badge').className).toBe('db-role-badge role-admin');
  });

  test('changement de langue : re-rendu seulement une fois l\'utilisateur connu', () => {
    const { dashboard } = loadModules();
    const state = { currentUser: null };
    dashboard.init(state);
    window.dispatchEvent(new window.Event('langChanged'));
    expect(auth.authFetch).not.toHaveBeenCalled();
    state.currentUser = { name: 'X' };
    window.dispatchEvent(new window.Event('langChanged'));
    expect(auth.authFetch).toHaveBeenCalledWith('/api/favorites');
  });
});

describe('VH.settings.cookies', () => {
  test('état initial lu depuis le consentement enregistré', () => {
    const recent = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify({ preferences: { analytics: true }, timestamp: recent.toISOString() }));
    const { cookies } = loadModules();
    cookies.init();
    expect(document.getElementById('pref-analytics').checked).toBe(true);
    expect(document.getElementById('analytics-status').textContent).toBe('t:settings.enabled');
    // Couleur par classe, pas par element.style (CSP)
    expect(document.getElementById('analytics-status').classList.contains('is-enabled')).toBe(true);
    expect(document.getElementById('consent-date').textContent).toMatch(String(recent.getFullYear()));
    // Date rendue en JS : plus retraduite en « Jamais » au changement de langue
    expect(document.getElementById('consent-date').hasAttribute('data-i18n')).toBe(false);
  });

  test('sans consentement ou JSON invalide : rien ne change', () => {
    const { cookies } = loadModules();
    cookies.loadCookiePreferences();
    localStorage.setItem('voldhistoire_cookie_consent', '{');
    cookies.loadCookiePreferences();
    expect(document.getElementById('analytics-status').textContent).toBe('');
  });

  test('enregistrement : localStorage, cookie miroir, cookieConsent appliqué, événement', () => {
    const { cookies } = loadModules();
    cookies.init();
    window.cookieConsent = { applyConsent: jest.fn(), openModal: jest.fn() };
    const events = [];
    document.addEventListener('cookieConsent', (e) => events.push(e.detail.event));
    const toggle = document.getElementById('pref-analytics');
    toggle.checked = true;
    toggle.dispatchEvent(new window.Event('change'));
    expect(document.getElementById('analytics-status').textContent).toBe('t:settings.enabled');
    document.getElementById('save-cookie-preferences').click();
    const saved = JSON.parse(localStorage.getItem('voldhistoire_cookie_consent'));
    expect(saved.preferences).toEqual({ essential: true, analytics: true, marketing: false });
    expect(Number.isNaN(Date.parse(saved.timestamp))).toBe(false);
    expect(document.cookie).toContain('voldhistoire_cookie_consent=true');
    expect(window.cookieConsent.applyConsent).toHaveBeenCalled();
    expect(events).toContain('preferences_saved');
    document.getElementById('open-cookie-modal').click();
    expect(window.cookieConsent.openModal).toHaveBeenCalled();
    delete window.cookieConsent;
  });

  test('modale indisponible : toast ; événement de consentement : rechargement', () => {
    const { cookies } = loadModules();
    cookies.init();
    document.getElementById('open-cookie-modal').click();
    expect(toasts).toContainEqual(['error', 't:settings.toast_cookies_unavailable']);
    document.getElementById('pref-analytics').checked = true;
    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify({ preferences: { analytics: false }, timestamp: new Date().toISOString() }));
    document.dispatchEvent(new window.CustomEvent('cookieConsent', { detail: { event: 'analytics_disabled' } }));
    expect(document.getElementById('pref-analytics').checked).toBe(false);
    document.dispatchEvent(new window.CustomEvent('cookieConsent', { detail: { event: 'autre' } }));
  });
});

describe('VH.settings.cookies — conservation du choix (LEGAL-004)', () => {
  test('choix de plus de 6 mois : ignoré (interrupteur et date non remplis)', () => {
    const old = new Date(Date.now() - 200 * 24 * 60 * 60 * 1000).toISOString();
    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify({ preferences: { analytics: true }, timestamp: old }));
    const { cookies } = loadModules();
    cookies.init();
    expect(document.getElementById('pref-analytics').checked).toBe(false);
    expect(document.getElementById('consent-date').textContent).toBe('Jamais');
  });

  test('VH.consent absent : enregistrement refusé avec un toast, sans exception', () => {
    const { cookies } = loadModules();
    delete window.VH.consent;
    expect(() => cookies.saveCookiePreferences()).not.toThrow();
    expect(toasts).toContainEqual(['error', 't:settings.toast_cookies_unavailable']);
    expect(() => cookies.loadCookiePreferences()).not.toThrow();
  });
});

describe('VH.settings.dataExport (LEGAL-011)', () => {
  function exportResponse({ ok = true, status = 200, disposition = 'attachment; filename="vol-histoire-donnees-42.json"', body = '{"user":{}}', json } = {}) {
    return {
      ok,
      status,
      headers: { get: (h) => (h.toLowerCase() === 'content-disposition' ? disposition : null) },
      blob: () => Promise.resolve(new window.Blob([body], { type: 'application/json' })),
      json: json || (() => Promise.resolve(JSON.parse(body))),
    };
  }

  beforeEach(() => {
    window.URL.createObjectURL = jest.fn(() => 'blob:vh/1');
    window.URL.revokeObjectURL = jest.fn();
  });

  test('nom de fichier tiré de Content-Disposition, nettoyé', () => {
    const { dataExport } = loadModules();
    expect(dataExport.filenameFromDisposition('attachment; filename="vol-histoire-donnees-42.json"')).toBe('vol-histoire-donnees-42.json');
    expect(dataExport.filenameFromDisposition("attachment; filename*=UTF-8''don%C3%A9es.json")).toBe('don_es.json');
    expect(dataExport.filenameFromDisposition('attachment; filename="../../etc/passwd"')).toBe('_.._etc_passwd');
    expect(dataExport.filenameFromDisposition('inline')).toBeNull();
    expect(dataExport.filenameFromDisposition(null)).toBeNull();
  });

  test('clic : GET /api/users/me/export authentifié, téléchargement via lien temporaire, aria-busy pendant la requête', async () => {
    jest.useFakeTimers();
    const { dataExport } = loadModules();
    let resolve;
    auth.authFetch.mockImplementation(() => new Promise((r) => { resolve = r; }));
    const clicks = [];
    const clickSpy = jest.spyOn(window.HTMLAnchorElement.prototype, 'click').mockImplementation(function () {
      clicks.push({ href: this.href, download: this.download, attached: document.body.contains(this) });
    });
    dataExport.setup();
    const btn = document.getElementById('export-data-btn');
    btn.click();
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/me/export');
    expect(btn.getAttribute('aria-busy')).toBe('true');
    expect(btn.disabled).toBe(true);
    // Un second clic pendant la requête ne relance rien
    btn.click();
    expect(auth.authFetch).toHaveBeenCalledTimes(1);

    resolve(exportResponse());
    await flush(8);
    expect(clicks).toEqual([{ href: 'blob:vh/1', download: 'vol-histoire-donnees-42.json', attached: true }]);
    expect(document.querySelector('a[download]')).toBeNull(); // lien retiré
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(btn.disabled).toBe(false);
    expect(toasts).toContainEqual(['success', 't:settings.export_success']);
    jest.advanceTimersByTime(1000);
    expect(window.URL.revokeObjectURL).toHaveBeenCalledWith('blob:vh/1');
    clickSpy.mockRestore();
  });

  test('sans Content-Disposition : nom de fichier par défaut', async () => {
    const { dataExport } = loadModules();
    auth.authFetch.mockResolvedValue(exportResponse({ disposition: null }));
    const names = [];
    jest.spyOn(window.HTMLAnchorElement.prototype, 'click').mockImplementation(function () { names.push(this.download); });
    await dataExport.exportData(document.getElementById('export-data-btn'));
    expect(names).toEqual(['vol-histoire-donnees.json']);
  });

  test('réponse en erreur : toast avec le message du serveur, ou repli', async () => {
    const { dataExport } = loadModules();
    const btn = document.getElementById('export-data-btn');
    auth.authFetch.mockResolvedValueOnce(exportResponse({ ok: false, status: 429, body: '{"message":"Trop de demandes"}' }));
    await dataExport.exportData(btn);
    expect(toasts).toContainEqual(['error', 'Trop de demandes']);
    auth.authFetch.mockResolvedValueOnce(exportResponse({ ok: false, status: 500, json: () => Promise.reject(new Error('pas du JSON')) }));
    await dataExport.exportData(btn);
    expect(toasts).toContainEqual(['error', 't:settings.export_error']);
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(window.URL.createObjectURL).not.toHaveBeenCalled();
  });

  test('réseau coupé : toast d\'erreur réseau, bouton rendu', async () => {
    const { dataExport } = loadModules();
    const btn = document.getElementById('export-data-btn');
    auth.authFetch.mockRejectedValueOnce(new TypeError('Failed to fetch'));
    await dataExport.exportData(btn);
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(btn.disabled).toBe(false);
  });
});

describe('settings.js — point d\'entrée', () => {
  async function boot() {
    loadModules();
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/settings');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
    await tick();
  }

  test('administrateur : liste des utilisateurs et tableau de bord chargés', async () => {
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 });
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: [], meta: { total: 0 } }));
    await boot();
    const urls = auth.authFetch.mock.calls.map(([u]) => u);
    expect(urls).toContain('/api/users?page=1&limit=8');
    expect(urls).toContain('/api/favorites');
    document.getElementById('tab-profile').click();
    expect(document.getElementById('profile').hidden).toBe(false);
  });

  test('membre : pas de liste des utilisateurs', async () => {
    auth.getUserInfo.mockReturnValue({ id: 3, name: 'M', email: 'm@x.fr', role: 3 });
    auth.authFetch.mockResolvedValue(jsonResponse(200, []));
    await boot();
    const urls = auth.authFetch.mock.calls.map(([u]) => u);
    expect(urls).not.toContain('/api/users?page=1&limit=8');
    expect(urls).toContain('/api/favorites');
  });
});
