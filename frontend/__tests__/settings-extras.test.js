/**
 * Tests — barre d'enregistrement flottante (settings/save-bar.js),
 * « Se déconnecter de tous les appareils » (settings/sessions.js),
 * préférences (settings/preferences.js), préférence « Réduire les
 * animations » de VH.motion et toast différé de utils.js.
 */
global.DOMPurify = require('dompurify');
const utils = require('../js/utils');
const { jsonResponse, flush, tick, env, loadModules, resetEnv } = require('./helpers/settings-env');

let auth;
let toasts;

beforeEach(() => {
  resetEnv();
  ({ auth, toasts } = env);
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
});

describe('VH.settings.saveBar', () => {
  function owner(initial = false) {
    const o = { dirty: initial };
    o.isDirty = jest.fn(() => o.dirty);
    o.save = jest.fn(() => { o.dirty = false; return Promise.resolve(true); });
    o.reset = jest.fn(() => { o.dirty = false; });
    return o;
  }
  const bar = () => document.getElementById('save-bar');
  const live = () => document.getElementById('save-bar-live').textContent;

  test('apparaît quand un formulaire est modifié, annoncée ; disparaît au retour à l’état enregistré', () => {
    jest.useFakeTimers();
    const { saveBar } = loadModules();
    saveBar.setup();
    const o = saveBar.register(owner());
    saveBar.update();
    expect(bar().hidden).toBe(true);
    o.dirty = true;
    saveBar.update();
    expect(bar().hidden).toBe(false);
    expect(saveBar.isShown()).toBe(true);
    expect(document.body.classList.contains('has-save-bar')).toBe(true);
    expect(live()).toBe('t:settings.savebar_text');
    saveBar.update(); // déjà affichée : rien
    o.dirty = false;
    saveBar.update();
    expect(bar().classList.contains('is-leaving')).toBe(true);
    expect(saveBar.isShown()).toBe(false);
    saveBar.update(); // déjà en sortie : rien
    jest.advanceTimersByTime(300);
    expect(bar().hidden).toBe(true);
    expect(document.body.classList.contains('has-save-bar')).toBe(false);
  });

  test('réapparition pendant la sortie : la sortie est annulée', () => {
    jest.useFakeTimers();
    const { saveBar } = loadModules();
    saveBar.setup();
    const o = saveBar.register(owner(true));
    saveBar.update();
    o.dirty = false;
    saveBar.update();
    o.dirty = true;
    saveBar.update();
    jest.advanceTimersByTime(300);
    expect(bar().hidden).toBe(false);
    expect(bar().classList.contains('is-leaving')).toBe(false);
  });

  test('Enregistrer : formulaires modifiés seulement, coche, puis barre masquée et annonce', async () => {
    jest.useFakeTimers();
    const { saveBar } = loadModules();
    saveBar.setup();
    const a = saveBar.register(owner(true));
    const b = saveBar.register(owner(false));
    saveBar.update();
    document.getElementById('save-bar-save').click();
    await flush();
    expect(a.save).toHaveBeenCalled();
    expect(b.save).not.toHaveBeenCalled();
    expect(document.getElementById('save-bar-save').dataset.bb).toBe('done');
    jest.advanceTimersByTime(window.VH.busyButton.HOLD_MS);
    await flush();
    expect(live()).toBe('t:settings.savebar_saved');
    jest.advanceTimersByTime(300);
    expect(bar().hidden).toBe(true);
  });

  test('échec ou exception : bouton rendu, barre gardée ; enregistrements simultanés ignorés', async () => {
    const { saveBar } = loadModules();
    saveBar.setup();
    const o = saveBar.register(owner(true));
    o.save.mockResolvedValueOnce(false);
    saveBar.update();
    expect(await saveBar.save()).toBe(false);
    expect(document.getElementById('save-bar-save').disabled).toBe(false);
    expect(bar().hidden).toBe(false);
    let release;
    o.save.mockImplementationOnce(() => new Promise((r) => { release = r; }));
    const first = saveBar.save();
    expect(await saveBar.save()).toBe(false); // déjà en cours
    saveBar.update(); // pendant l'enregistrement : rien
    document.getElementById('save-bar-cancel').click(); // pendant l'enregistrement : rien
    expect(o.reset).not.toHaveBeenCalled();
    release(false);
    await first;
    o.save.mockRejectedValueOnce(new Error('boum'));
    expect(await saveBar.save()).toBe(false);
  });

  test('isDirty qui lève : formulaire ignoré ; rien à enregistrer : false', async () => {
    const { saveBar } = loadModules();
    saveBar.setup();
    saveBar.register({ isDirty: () => { throw new Error('x'); }, save: jest.fn(), reset: jest.fn() });
    saveBar.register(null);
    saveBar.update();
    expect(bar().hidden).toBe(true);
    expect(await saveBar.save()).toBe(false);
  });

  test('Annuler : formulaires remis, annonce', () => {
    const { saveBar } = loadModules();
    saveBar.setup();
    const o = saveBar.register(owner(true));
    saveBar.update();
    saveBar.cancel();
    expect(o.reset).toHaveBeenCalled();
    expect(live()).toBe('t:settings.savebar_cancelled');
  });

  test('bandeau de consentement : la barre se place au-dessus, suit son apparition', async () => {
    document.body.insertAdjacentHTML('beforeend', '<div class="cookie-banner"></div>');
    const banner = document.querySelector('.cookie-banner');
    banner.getBoundingClientRect = () => ({ height: 134 });
    const { saveBar } = loadModules();
    saveBar.setup();
    saveBar.clearOfConsentBanner();
    expect(bar().style.getPropertyValue('--savebar-offset')).toBe('0px');
    banner.classList.add('show');
    await tick();
    expect(bar().style.getPropertyValue('--savebar-offset')).toBe('150px');
  });

  test('sans barre dans la page : aucune action', async () => {
    document.getElementById('save-bar').remove();
    const { saveBar } = loadModules();
    saveBar.setup();
    saveBar.register(owner(true));
    saveBar.update();
    saveBar.clearOfConsentBanner();
    expect(saveBar.isShown()).toBe(false);
    expect(await saveBar.save()).toBe(false);
    expect(() => saveBar.cancel()).not.toThrow();
    saveBar.reset();
  });

  test('sans MutationObserver ni bandeau : installation sans erreur', () => {
    const MO = global.MutationObserver;
    delete global.MutationObserver;
    document.body.insertAdjacentHTML('beforeend', '<div class="cookie-banner"></div>');
    const { saveBar } = loadModules();
    expect(() => saveBar.setup()).not.toThrow();
    global.MutationObserver = MO;
  });
});

describe('VH.settings.sessions', () => {
  function setup() {
    const S = loadModules();
    const control = S.sessions.setup();
    S.sessions.navigate = jest.fn();
    return { S, control };
  }
  const wrap = () => document.querySelector('.ses-out');

  test('confirmation sur place, puis POST, déconnexion locale, toast différé, retour à /login', async () => {
    const { S } = setup();
    const btn = document.getElementById('logout-all-btn');
    btn.click();
    expect(wrap().dataset.state).toBe('confirm');
    expect(wrap().querySelector('.cfm-panel').getAttribute('aria-label')).toBe('t:settings.sessions_confirm_group');
    expect(wrap().querySelector('.cfm-yes .cfm-text').textContent).toBe('t:settings.sessions_confirm');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    wrap().querySelector('.cfm-yes').click();
    await flush(6);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/auth/logout-all', { method: 'POST' });
    expect(auth.logout).toHaveBeenCalled();
    expect(global.queueToast).toHaveBeenCalledWith('t:settings.sessions_done', 'success');
    expect(S.sessions.navigate).toHaveBeenCalledWith('/login');
  });

  test('déconnexion locale qui échoue : session effacée quand même ; sans toast différé : toast immédiat', async () => {
    const { S } = setup();
    auth.logout.mockRejectedValueOnce(new Error('401'));
    global.queueToast = jest.fn(() => false);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    expect(await S.sessions.logoutAll(null)).toBe(true);
    expect(auth.clearSession).toHaveBeenCalled();
    expect(toasts).toContainEqual(['success', 't:settings.sessions_done']);
    delete global.queueToast;
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    await S.sessions.logoutAll(null);
    expect(S.sessions.navigate).toHaveBeenCalledTimes(2);
  });

  test('refus du serveur ou réseau : confirmation remise au repos, toast, aucune redirection', async () => {
    const { S, control } = setup();
    const reset = jest.spyOn(control, 'reset');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(429, {}));
    expect(await S.sessions.logoutAll(control)).toBe(false);
    expect(toasts).toContainEqual(['error', 't:settings.sessions_error']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    expect(await S.sessions.logoutAll(control)).toBe(false);
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(reset).toHaveBeenCalledTimes(2);
    expect(S.sessions.navigate).not.toHaveBeenCalled();
    await S.sessions.logoutAll(undefined); // sans contrôle : aucune erreur
  });

  test('sans bouton ou sans confirmation partagée : rien n’est armé', () => {
    const S = loadModules();
    delete window.VH.confirmAction;
    expect(S.sessions.setup()).toBeNull();
    document.getElementById('logout-all-btn').remove();
    expect(S.sessions.setup()).toBeNull();
  });
});

describe('VH.settings.preferences', () => {
  test('langue : bouton coché d’après la langue courante ; choix → i18n.setLang ; même langue : rien', () => {
    const { preferences } = loadModules();
    i18n.currentLang = 'en';
    preferences.setup();
    const [fr, en] = document.querySelectorAll('input[name="pref-lang"]');
    expect(en.checked).toBe(true);
    fr.checked = true;
    fr.dispatchEvent(new window.Event('change', { bubbles: true }));
    expect(i18n.setLang).toHaveBeenCalledWith('fr');
    i18n.setLang.mockClear();
    en.dispatchEvent(new window.Event('change', { bubbles: true }));
    expect(i18n.setLang).not.toHaveBeenCalled();
    i18n.currentLang = 'fr';
    window.dispatchEvent(new window.Event('langChanged'));
    expect(fr.checked).toBe(true);
  });

  test('langue sans i18n.setLang : aucune erreur', () => {
    const { preferences } = loadModules();
    preferences.setup();
    delete i18n.setLang;
    const en = document.querySelector('input[name="pref-lang"][value="en"]');
    expect(() => en.dispatchEvent(new window.Event('change'))).not.toThrow();
    delete global.i18n;
    expect(() => preferences.syncLang()).not.toThrow();
    expect(() => en.dispatchEvent(new window.Event('change'))).not.toThrow();
  });

  test('réduire les animations : classe, stockage, interrupteur ; mention si le système réduit déjà', () => {
    const { preferences } = loadModules();
    window.matchMedia = jest.fn(() => ({ matches: true }));
    preferences.setup();
    const toggle = document.getElementById('pref-reduce-motion');
    expect(toggle.checked).toBe(false);
    expect(document.getElementById('pref-motion-system').hidden).toBe(false);
    toggle.checked = true;
    toggle.dispatchEvent(new window.Event('change'));
    expect(document.documentElement.classList.contains('vh-reduce-motion')).toBe(true);
    expect(localStorage.getItem('vh-reduce-motion')).toBe('1');
    toggle.checked = false;
    toggle.dispatchEvent(new window.Event('change'));
    expect(document.documentElement.classList.contains('vh-reduce-motion')).toBe(false);
    expect(localStorage.getItem('vh-reduce-motion')).toBeNull();
  });

  test('sans VH.motion : interrupteur sans effet, aucune erreur', () => {
    const { preferences } = loadModules();
    delete window.VH.motion;
    preferences.setup();
    expect(() => document.getElementById('pref-reduce-motion').dispatchEvent(new window.Event('change'))).not.toThrow();
  });

  test('revoir la visite : marque effacée puis accueil ; stockage refusé : toast', () => {
    const { preferences } = loadModules();
    preferences.navigate = jest.fn();
    preferences.setup();
    localStorage.setItem('vh-onboarding-done', '1');
    document.getElementById('pref-tour-btn').click();
    expect(localStorage.getItem('vh-onboarding-done')).toBeNull();
    expect(preferences.navigate).toHaveBeenCalledWith('/');
    jest.spyOn(window.Storage.prototype, 'removeItem').mockImplementation(() => { throw new Error('refusé'); });
    expect(preferences.replayTour()).toBe(false);
    expect(toasts).toContainEqual(['error', 't:settings.pref_tour_error']);
  });

  test('éléments absents : setup sans erreur', () => {
    document.body.innerHTML = '';
    const { preferences } = loadModules();
    expect(() => preferences.setup()).not.toThrow();
  });
});

describe('VH.motion — préférence « Réduire les animations »', () => {
  function loadMotionFresh() {
    jest.resetModules();
    window.VH = {};
    require('../js/shared/motion');
    return window.VH.motion;
  }

  test('lue au chargement : classe posée, prefersReducedMotion vrai même sans préférence système', () => {
    localStorage.setItem('vh-reduce-motion', '1');
    const motion = loadMotionFresh();
    expect(document.documentElement.classList.contains('vh-reduce-motion')).toBe(true);
    expect(motion.siteReducesMotion()).toBe(true);
    expect(motion.prefersReducedMotion()).toBe(true);
    expect(motion.systemPrefersReducedMotion()).toBe(false);
    // Sortie immédiate, comme pour la préférence du système.
    const done = jest.fn();
    const el = document.createElement('div');
    motion.exit(el, done);
    expect(done).toHaveBeenCalled();
  });

  test('setReducedMotion : stockage refusé, la classe suit quand même', () => {
    const motion = loadMotionFresh();
    jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('quota'); });
    motion.setReducedMotion(true);
    expect(document.documentElement.classList.contains('vh-reduce-motion')).toBe(true);
    expect(motion.REDUCE_KEY).toBe('vh-reduce-motion');
  });

  test('stockage illisible au chargement : préférence du système seule', () => {
    jest.spyOn(window.Storage.prototype, 'getItem').mockImplementation(() => { throw new Error('bloqué'); });
    const motion = loadMotionFresh();
    expect(motion.siteReducesMotion()).toBe(false);
  });
});

describe('utils.js — toast différé', () => {
  beforeEach(() => {
    document.body.innerHTML = '<div id="toast-container"></div>';
    window.VH = window.VH || {};
    require('../js/shared/motion');
  });

  test('queueToast puis showQueuedToast : montré une seule fois, type validé', () => {
    expect(utils.queueToast('Sessions fermées', 'success')).toBe(true);
    expect(utils.showQueuedToast()).toBe(true);
    expect(document.querySelector('.toast-success .toast-message').textContent).toBe('Sessions fermées');
    expect(utils.showQueuedToast()).toBe(false);
    utils.queueToast('Bizarre', 'pirate');
    utils.showQueuedToast();
    expect(document.querySelectorAll('.toast-info')).toHaveLength(1);
    utils.queueToast('Par défaut');
    utils.showQueuedToast();
    expect(document.querySelectorAll('.toast-info')).toHaveLength(2);
  });

  test('entrée vide ou illisible, stockage refusé : rien', () => {
    sessionStorage.setItem('vh-toast', '{');
    expect(utils.showQueuedToast()).toBe(false);
    sessionStorage.setItem('vh-toast', JSON.stringify({ message: '' }));
    expect(utils.showQueuedToast()).toBe(false);
    jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('quota'); });
    expect(utils.queueToast('x')).toBe(false);
  });
});

describe('VH.settings.account — rôle absent de la réponse de l’API', () => {
  test('le rôle déjà connu est gardé', async () => {
    const { account } = loadModules();
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 });
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, { id: 1, created_at: '2025-01-01' }));
    const state = { currentUser: null };
    await account.checkAuth(state);
    expect(state.currentUser.role).toBe(1);
    expect(state.currentUser.created_at).toBe('2025-01-01');
  });
});
