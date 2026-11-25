/* Environnement commun des tests de la page Paramètres (js/settings/*.js) :
 * DOM réduit aux éléments utilisés, globaux de utils.js, i18n et auth
 * simulés, chargement des modules dans l'ordre du bundle. */
const utils = require('../../js/utils');
const { loadMotion } = require('./motion-env');

const SETTINGS_DOM = `
  <section class="settings-section">
    <div class="settings-id">
      <div id="id-avatar">U</div>
      <h1><span id="id-name">…</span></h1>
      <span id="id-role" class="role-pill role-member"></span><span id="id-since" hidden></span>
      <a href="/favorites"><span id="id-fav-count">0</span><span id="id-fav-label">favoris</span></a>
    </div>
    <aside class="settings-sidebar">
      <nav class="sidebar-nav" role="tablist" aria-orientation="vertical">
        <a href="#collection" class="sidebar-link active" data-section="collection" id="tab-collection" aria-selected="true" tabindex="0">Ma collection</a>
        <a href="#account" class="sidebar-link" data-section="account" id="tab-account" aria-selected="false" tabindex="-1">Compte</a>
        <a href="#preferences" class="sidebar-link" data-section="preferences" id="tab-preferences" aria-selected="false" tabindex="-1">Préférences</a>
        <a href="#privacy" class="sidebar-link" data-section="privacy" id="tab-privacy" aria-selected="false" tabindex="-1">Confidentialité</a>
        <a href="#admin" class="sidebar-link hidden" data-section="admin" id="admin-nav-link" aria-selected="false" tabindex="-1">Admin</a>
      </nav>
    </aside>
    <div class="settings-content">
      <div id="collection" class="content-section active">
        <p id="col-status"></p>
        <div id="col-content" hidden>
          <ul id="col-strip"></ul><ol id="col-decades"></ol><p id="col-undated" hidden></p><ul id="col-countries"></ul>
        </div>
        <div id="col-empty" hidden></div>
        <section id="col-last" hidden><div id="col-last-body"></div></section>
      </div>
      <div id="account" class="content-section" hidden>
        <form id="profile-form">
          <div><input id="name"></div>
          <div><input id="email"></div>
          <div id="profile-current-password-group" hidden><input type="password" id="profile-current-password"></div>
          <button type="submit" class="sr-only">Enregistrer le profil</button>
        </form>
        <section id="email-code-box" hidden>
          <h4 id="email-code-title">Confirmez</h4>
          <p><strong id="email-code-target"></strong></p>
          <div id="email-code-otp"></div>
          <p id="email-code-status" role="status"></p>
          <button type="button" id="email-code-cancel">Annuler</button>
        </section>
        <section id="password-block" tabindex="-1">
          <form id="security-form">
            <div><input type="password" id="current-password"></div>
            <div><input type="password" id="password"><button type="button" id="toggle-password"></button></div>
            <div class="strength-bar"></div><div class="strength-bar"></div><div class="strength-bar"></div><div class="strength-bar"></div>
            <span id="strength-text"></span>
            <ul><li id="req-length"></li><li id="req-upper"></li><li id="req-lower"></li><li id="req-number"></li></ul>
            <button type="submit">Changer</button>
          </form>
        </section>
        <section id="sessions-block"><div><button type="button" id="logout-all-btn"><span>Tout fermer</span></button></div></section>
      </div>
      <div id="preferences" class="content-section" hidden>
        <input type="radio" name="pref-lang" value="fr" checked><input type="radio" name="pref-lang" value="en">
        <input type="checkbox" id="pref-reduce-motion"><p id="pref-motion-system" hidden></p>
        <button type="button" id="pref-tour-btn">Revoir</button>
      </div>
      <div id="privacy" class="content-section" hidden>
        <input type="checkbox" id="pref-analytics"><span id="analytics-status"></span>
        <strong id="consent-date" data-i18n="settings.never">Jamais</strong>
        <button id="open-cookie-modal">Ouvrir</button>
        <button type="button" id="export-data-btn"><span>Télécharger mes données</span></button>
        <section id="delete-block" tabindex="-1"><form id="delete-account-form"><input type="password" id="delete-current-password"></form><button type="button" id="delete-account-btn"><span>Supprimer</span></button></section>
      </div>
      <div id="admin" class="content-section hidden" hidden>
        <input id="user-filter">
        <div id="role-chips">
          <button type="button" class="role-chip" data-role="" aria-pressed="true">Tous<span class="role-chip-count" data-count-role="all"></span></button>
          <button type="button" class="role-chip" data-role="1" aria-pressed="false">Admins<span class="role-chip-count" data-count-role="1"></span></button>
          <button type="button" class="role-chip" data-role="2" aria-pressed="false">Éditeurs<span class="role-chip-count" data-count-role="2"></span></button>
          <button type="button" class="role-chip" data-role="3" aria-pressed="false">Membres<span class="role-chip-count" data-count-role="3"></span></button>
        </div>
        <span id="total-users">0</span> <span id="total-users-label"></span>
        <div id="user-list"></div><div id="user-pagination"></div>
      </div>
    </div>
  </section>
  <section class="save-bar" id="save-bar" hidden>
    <button type="button" id="save-bar-cancel">Annuler</button>
    <button type="button" id="save-bar-save"><span>Enregistrer</span></button>
  </section>
  <p id="save-bar-live"></p>
  <div id="edit-user-modal" class="hidden">
    <div class="logout-modal-backdrop"></div>
    <div class="logout-modal-container">
      <h2 id="edit-user-modal-title"></h2>
      <div><input id="edit-user-name"></div><div><input id="edit-user-email"></div>
      <button id="edit-user-cancel">Annuler</button><button id="edit-user-save">Enregistrer</button>
    </div>
  </div>`;

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}
const flush = async (n = 4) => { for (let i = 0; i < n; i++) await Promise.resolve(); };
const tick = () => new Promise((r) => setTimeout(r, 0));

const env = { auth: null, toasts: [] };

function installGlobals() {
  Object.assign(global, {
    escapeHtml: utils.escapeHtml,
    safeSetHTML: utils.safeSetHTML,
    setFieldError: utils.setFieldError,
    clearFieldError: utils.clearFieldError,
    isValidEmail: utils.isValidEmail,
    calculatePasswordStrength: utils.calculatePasswordStrength,
    isValidPassword: utils.isValidPassword,
    PASSWORD_MIN_LENGTH: utils.PASSWORD_MIN_LENGTH,
    PASSWORD_MAX_LENGTH: utils.PASSWORD_MAX_LENGTH,
    setupPasswordToggle: jest.fn(),
  });
  env.toasts = [];
  global.showToast = jest.fn((msg, type) => env.toasts.push([type, msg]));
  global.queueToast = jest.fn(() => true);
  global.i18n = { currentLang: 'fr', t: jest.fn((k, p) => (p ? `t:${k}:${JSON.stringify(p)}` : `t:${k}`)), setLang: jest.fn() };
  env.auth = {
    init: jest.fn(() => Promise.resolve(null)),
    getPayload: jest.fn(() => ({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 })),
    getUserInfo: jest.fn(() => null),
    setUserInfo: jest.fn(),
    setToken: jest.fn(),
    clearSession: jest.fn(),
    logout: jest.fn(() => Promise.resolve()),
    authFetch: jest.fn(() => Promise.resolve(jsonResponse(200, {}))),
  };
  global.auth = env.auth;
  return env;
}

/** Valeur lisible d'un compteur « odomètre » (le .sr-only porte le nombre). */
const rolled = (id) => document.getElementById(id).querySelector('.sr-only').textContent;

const MODULES = ['ui', 'tabs', 'save-bar', 'account', 'identity', 'collection', 'profile', 'security',
  'sessions', 'preferences', 'danger-zone', 'admin', 'cookies', 'data-export'];

function loadModules() {
  jest.resetModules();
  window.VH = {};
  // window.VH.consent (cookies.js, chargé avant settings.min.js dans app.min.js)
  global.safeSetHTML = utils.safeSetHTML;
  require('../../js/cookies');
  require('../../js/shared/motion');
  // Odomètre et confirmation sur place (modules partagés d'app.min.js).
  loadMotion(['.t-roll-col.is-leaving', '.cfm-bin-check', '.save-bar.is-leaving']);
  require('../../js/shared/busy-button');
  require('../../js/shared/otp-input');
  require('../../js/shared/alpha3');
  require('../../js/shared/picture');
  require('../../js/shared/card');
  require('../../js/shared/last-viewed');
  MODULES.forEach((m) => require(`../../js/settings/${m}`));
  return window.VH.settings;
}

/** À appeler dans beforeEach. */
function resetEnv() {
  document.body.innerHTML = SETTINGS_DOM;
  installGlobals();
  window.matchMedia = jest.fn(() => ({ matches: false }));
  window.Element.prototype.scrollIntoView = jest.fn();
  window.scrollTo = jest.fn();
  localStorage.clear();
  sessionStorage.clear();
  document.documentElement.className = '';
}

module.exports = { SETTINGS_DOM, jsonResponse, flush, tick, env, installGlobals, rolled, loadModules, resetEnv };
