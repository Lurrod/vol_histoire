/**
 * Tests — page Paramètres (js/settings/*.js + js/settings.js).
 * Découpage ARCH-004 : chaque module VH.settings.* est testé sur un DOM
 * réduit à ses éléments, l'API étant simulée (helpers/settings-env.js).
 * Collection et identité : settings-collection.test.js ; barre
 * d'enregistrement, sessions et préférences : settings-extras.test.js.
 */

// DOMPurify réel (devDependency) : safeSetHTML l'utilise comme en production.
global.DOMPurify = require('dompurify');
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

describe('VH.settings.ui', () => {
  test('tr : traduction ou repli ; trf : paramètres remplacés dans le repli', () => {
    const { ui } = loadModules();
    expect(ui.tr('a.b', 'repli')).toBe('t:a.b');
    expect(ui.trf('a.b', 'x {n}', { n: 2 })).toBe('t:a.b:{"n":2}');
    i18n.t.mockImplementation((k) => k);
    expect(ui.tr('a.b', 'repli')).toBe('repli');
    expect(ui.trf('a.b', '{n} sur {n}, {m}', { n: 2, m: 'x' })).toBe('2 sur 2, x');
    expect(ui.trf('a.b', 'fixe')).toBe('fixe');
    delete global.i18n;
    expect(ui.tr('a.b', 'repli')).toBe('repli');
    expect(ui.trf('a.b', 'v{n}', { n: 1 })).toBe('v1');
  });

  test('plural : _one pour 1, _many sinon', () => {
    const { ui } = loadModules();
    expect(ui.plural('k', 1)).toBe('k_one');
    expect(ui.plural('k', 0)).toBe('k_many');
    expect(ui.plural('k', '3')).toBe('k_many');
  });

  test('setButtonLoading : anneau, libellé toujours lu, puis repos ; bouton absent toléré', () => {
    const { ui } = loadModules();
    const btn = document.getElementById('delete-account-btn');
    ui.setButtonLoading(btn, true);
    expect(btn.dataset.bb).toBe('busy');
    expect(btn.disabled).toBe(true);
    expect(btn.getAttribute('aria-busy')).toBe('true');
    expect(btn.querySelector('.bb-label').textContent.trim()).toBe('Supprimer');
    ui.setButtonLoading(btn, false);
    expect(btn.dataset.bb).toBeUndefined();
    expect(btn.disabled).toBe(false);
    expect(() => ui.setButtonLoading(null, true)).not.toThrow();
  });

  test('setButtonLoading(…, false, { done }) : coche et libellé de succès, puis repos', () => {
    jest.useFakeTimers();
    const { ui } = loadModules();
    const btn = document.getElementById('delete-account-btn');
    ui.setButtonLoading(btn, true);
    ui.setButtonLoading(btn, false, { done: true, label: 'Enregistré' });
    expect(btn.dataset.bb).toBe('done');
    expect(btn.querySelector('.bb-done-text').textContent).toBe('Enregistré');
    jest.advanceTimersByTime(window.VH.busyButton.HOLD_MS);
    expect(btn.dataset.bb).toBeUndefined();
  });

  test('scrollBehavior : système, réglage du site, ou matchMedia seul sans VH.motion', () => {
    const { ui } = loadModules();
    expect(ui.scrollBehavior()).toBe('smooth');
    window.VH.motion.setReducedMotion(true);
    expect(ui.scrollBehavior()).toBe('auto');
    window.VH.motion.setReducedMotion(false);
    window.matchMedia = jest.fn(() => ({ matches: true }));
    expect(ui.scrollBehavior()).toBe('auto');
    delete window.VH.motion;
    expect(ui.scrollBehavior()).toBe('auto');
    window.matchMedia = jest.fn(() => ({ matches: false }));
    expect(ui.scrollBehavior()).toBe('smooth');
  });
});

describe('VH.settings.tabs', () => {
  const key = (id, k) => document.getElementById(id).dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true }));
  afterEach(() => window.history.replaceState(null, '', '/'));

  test('ancre de l’URL : ouvre l’onglet nommé, sans défiler ; ancre inconnue ou onglet masqué : rien', () => {
    const { tabs } = loadModules();
    window.history.replaceState(null, '', '/settings#account');
    tabs.setup();
    expect(document.getElementById('tab-account').getAttribute('aria-selected')).toBe('true');
    expect(document.getElementById('account').hidden).toBe(false);
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();

    const links = Array.from(document.querySelectorAll('.sidebar-link'));
    window.history.replaceState(null, '', '/settings#inconnu');
    expect(tabs.openFromHash(links)).toBe(false);
    window.history.replaceState(null, '', '/settings#admin'); // onglet masqué (non-admin)
    expect(tabs.openFromHash(links)).toBe(false);
    window.history.replaceState(null, '', '/settings#%E0%A4%A'); // ancre mal encodée
    expect(tabs.openFromHash()).toBe(false);
    window.history.replaceState(null, '', '/settings');
    expect(tabs.openFromHash(links)).toBe(false);
    expect(document.getElementById('tab-account').getAttribute('aria-selected')).toBe('true');
  });

  test.each([
    ['dashboard', 'collection', null],
    ['profile', 'account', null],
    ['security', 'account', 'password-block'],
    ['danger', 'privacy', 'delete-block'],
    ['privacy', 'privacy', null],
  ])('ancienne ancre #%s → onglet %s, bloc %s', (hash, section, block) => {
    const { tabs } = loadModules();
    expect(tabs.resolveHash(hash)).toEqual({ section, block });
    window.history.replaceState(null, '', `/settings#${hash}`);
    tabs.setup();
    expect(document.getElementById(`tab-${section}`).getAttribute('aria-selected')).toBe('true');
    expect(document.getElementById(section).hidden).toBe(false);
    if (block) {
      expect(document.activeElement.id).toBe(block);
      expect(window.Element.prototype.scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth', block: 'start' });
    } else {
      expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
    }
  });

  test('focusBlock : bloc absent ignoré', () => {
    const { tabs } = loadModules();
    expect(() => tabs.focusBlock(null)).not.toThrow();
    expect(() => tabs.focusBlock('absent')).not.toThrow();
  });

  test('clic : onglet et section actifs ; contenu remonté seulement s’il est passé sous l’en-tête', () => {
    const { tabs } = loadModules();
    tabs.setup();
    const content = document.querySelector('.settings-content');
    content.getBoundingClientRect = () => ({ top: 120 });
    document.getElementById('tab-account').click();
    expect(document.getElementById('tab-account').getAttribute('aria-selected')).toBe('true');
    expect(document.getElementById('tab-collection').tabIndex).toBe(-1);
    expect(document.getElementById('account').hidden).toBe(false);
    expect(document.getElementById('collection').hidden).toBe(true);
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
    content.getBoundingClientRect = () => ({ top: -400 });
    document.getElementById('tab-privacy').click();
    expect(window.Element.prototype.scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth', block: 'start' });
  });

  test('clavier : onglet masqué sauté, bouclage, Début / Fin, focus sans défilement', () => {
    const { tabs } = loadModules();
    tabs.setup();
    key('tab-collection', 'ArrowDown');
    expect(document.activeElement.id).toBe('tab-account');
    key('tab-account', 'ArrowRight');
    expect(document.activeElement.id).toBe('tab-preferences');
    key('tab-preferences', 'ArrowDown');
    expect(document.activeElement.id).toBe('tab-privacy');
    key('tab-privacy', 'ArrowDown'); // admin masqué : bouclage
    expect(document.activeElement.id).toBe('tab-collection');
    key('tab-collection', 'ArrowUp');
    expect(document.activeElement.id).toBe('tab-privacy');
    key('tab-privacy', 'Home');
    expect(document.activeElement.id).toBe('tab-collection');
    key('tab-collection', 'End');
    expect(document.activeElement.id).toBe('tab-privacy');
    key('tab-privacy', 'ArrowLeft');
    expect(document.activeElement.id).toBe('tab-preferences');
    key('tab-preferences', 'a');
    expect(document.activeElement.id).toBe('tab-preferences');
    key('admin-nav-link', 'ArrowDown'); // onglet masqué : ignoré
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
  });

  test('activateTab : onglet masqué ignoré ; sans .settings-content : scrollTo', () => {
    const { tabs } = loadModules();
    tabs.activateTab(document.getElementById('admin-nav-link'));
    expect(document.getElementById('admin').hidden).toBe(true);
    document.querySelector('.settings-content').classList.remove('settings-content');
    tabs.activateTab(document.getElementById('tab-privacy'));
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });

  test('aria-orientation suit la largeur (rangée sous 64em) ; matchMedia indisponible : inchangé', () => {
    let listener = null;
    const mq = { matches: true, addEventListener: jest.fn((t, cb) => { listener = cb; }) };
    window.matchMedia = jest.fn(() => mq);
    const { tabs } = loadModules();
    tabs.setup();
    const nav = document.querySelector('.sidebar-nav');
    expect(window.matchMedia).toHaveBeenCalledWith('(max-width: 64em)');
    expect(nav.getAttribute('aria-orientation')).toBe('horizontal');
    mq.matches = false;
    listener();
    expect(nav.getAttribute('aria-orientation')).toBe('vertical');
    // matchMedia qui ne renvoie rien : aucune erreur.
    window.matchMedia = jest.fn(() => null);
    expect(() => loadModules().tabs.setup()).not.toThrow();
  });

  test('rangée horizontale : l’onglet actif est ramené au centre de la rangée', () => {
    const { tabs } = loadModules();
    const row = document.querySelector('.settings-sidebar');
    Object.defineProperty(row, 'scrollWidth', { configurable: true, get: () => 600 });
    Object.defineProperty(row, 'clientWidth', { configurable: true, get: () => 300 });
    const link = document.getElementById('tab-privacy');
    Object.defineProperty(link, 'offsetLeft', { configurable: true, get: () => 420 });
    Object.defineProperty(link, 'offsetWidth', { configurable: true, get: () => 100 });
    row.scrollTo = jest.fn();
    tabs.revealInRow(link);
    expect(row.scrollTo).toHaveBeenCalledWith({ left: 300, behavior: 'smooth' });
    // Sans scrollTo : scrollLeft directement.
    delete row.scrollTo;
    row.scrollTo = undefined;
    tabs.revealInRow(document.getElementById('tab-collection'));
    expect(row.scrollLeft).toBe(0);
    // Rangée qui tient en entier : rien.
    Object.defineProperty(row, 'scrollWidth', { configurable: true, get: () => 300 });
    expect(() => tabs.revealInRow(link)).not.toThrow();
  });

  test('onglet hors colonne : pas de rangée à faire défiler', () => {
    const { tabs } = loadModules();
    document.querySelector('.settings-sidebar').replaceWith(document.querySelector('.sidebar-nav'));
    expect(() => tabs.revealInRow(document.getElementById('tab-account'))).not.toThrow();
  });
});

/* Pastille glissante et morphing du contenu (settings/tabs.js). jsdom ne
 * calcule aucune mise en page : les mesures des onglets sont simulées, et
 * l'API View Transitions l'est aussi (rappel synchrone de la mise à jour). */
const TABS_DOM = `
  <section class="settings-section">
    <aside class="settings-sidebar">
      <nav class="sidebar-nav" role="tablist">
        <a href="#collection" class="sidebar-link active" data-section="collection" id="tab-collection" role="tab" aria-selected="true" tabindex="0">Collection</a>
        <a href="#account" class="sidebar-link" data-section="account" id="tab-account" role="tab" aria-selected="false" tabindex="-1">Compte</a>
        <a href="#admin" class="sidebar-link hidden" data-section="admin" id="admin-nav-link" role="tab" aria-selected="false" tabindex="-1">Admin</a>
        <a href="#privacy" class="sidebar-link" data-section="privacy" id="tab-privacy" role="tab" aria-selected="false" tabindex="-1">Confidentialité</a>
      </nav>
    </aside>
    <div class="settings-content">
      <div id="collection" class="content-section active" role="tabpanel">
        <div class="section-card"><div class="section-header"><div class="header-text"><h2 id="collection-title">Collection</h2></div></div><div class="col-content"></div></div>
      </div>
      <div id="account" class="content-section" role="tabpanel" hidden>
        <div class="section-card"><div class="section-header"><div class="header-text"><h2 id="account-title">Compte</h2></div></div><form id="profile-form"></form></div>
      </div>
      <div id="admin" class="content-section hidden" role="tabpanel" hidden><div class="section-card"></div></div>
      <div id="privacy" class="content-section" role="tabpanel" hidden>
        <div class="section-card"><div class="section-header"><div class="header-text"><h2 id="privacy-title">Confidentialité</h2></div></div><section class="danger-block" id="delete-block" tabindex="-1"></section></div>
      </div>
      <div id="orphan" class="content-section" hidden></div>
    </div>
  </section>`;

/** Mesures simulées d'un onglet dans la colonne (offsetParent). */
function fakeLayout(el, box, parent) {
  const def = (k, v) => Object.defineProperty(el, k, { configurable: true, get: () => v });
  def('offsetParent', parent);
  def('offsetLeft', box.x);
  def('offsetTop', box.y);
  def('offsetWidth', box.w);
  def('offsetHeight', box.h);
}

function layoutTabs(boxes) {
  const sidebar = document.querySelector('.settings-sidebar');
  Object.entries(boxes).forEach(([id, box]) => fakeLayout(document.getElementById(id), box, sidebar));
}

const DEFAULT_BOXES = {
  'tab-collection': { x: 8, y: 8, w: 220, h: 44 },
  'tab-account': { x: 8, y: 56, w: 220, h: 44 },
  'admin-nav-link': { x: 0, y: 0, w: 0, h: 0 },
  'tab-privacy': { x: 8, y: 104, w: 220, h: 44 },
};

const hl = () => {
  const ind = document.querySelector('.sidebar-indicator');
  const v = (k) => ind.style.getPropertyValue(`--tab-hl-${k}`);
  return { x: v('x'), y: v('y'), w: v('w'), h: v('h'), o: v('o') };
};

/** View Transitions simulée : noms relevés avant et après la mise à jour.
 * Comme le navigateur, on ne compte que les éléments rendus : une section
 * masquée garde ses anciens noms jusqu'à la fin, sans être capturée. */
function mockViewTransition() {
  const seen = { before: null, after: null, rootClasses: null };
  const names = () => Object.fromEntries(
    [...document.querySelectorAll('*')]
      .filter((el) => el.style.viewTransitionName && !el.closest('[hidden]'))
      .map((el) => [el.style.viewTransitionName, el.id || el.className]),
  );
  let resolveFinished;
  document.startViewTransition = jest.fn((cb) => {
    seen.before = names();
    seen.rootClasses = [...document.documentElement.classList];
    cb();
    seen.after = names();
    return {
      finished: new Promise((r) => { resolveFinished = r; }),
      updateCallbackDone: Promise.resolve(),
    };
  });
  return { seen, finish: () => resolveFinished(), names };
}

function loadTabs() {
  const S = loadModules();
  require('../js/shared/view-morph');
  return S.tabs;
}

describe('VH.settings.tabs — pastille et morphing', () => {
  let roCallback;
  let observed;

  beforeEach(() => {
    document.body.innerHTML = TABS_DOM;
    layoutTabs(DEFAULT_BOXES);
    observed = [];
    roCallback = null;
    global.ResizeObserver = jest.fn((cb) => {
      roCallback = cb;
      return { observe: (el) => observed.push(el) };
    });
  });

  afterEach(() => {
    delete document.startViewTransition;
    delete global.ResizeObserver;
    document.documentElement.className = '';
    window.history.replaceState(null, '', '/');
  });

  test('setup : pastille décorative posée sous l’onglet actif, sans animation d’entrée', () => {
    const tabs = loadTabs();
    tabs.setup();
    const ind = document.querySelector('.settings-sidebar > .sidebar-indicator');
    expect(ind).not.toBeNull();
    expect(ind.getAttribute('aria-hidden')).toBe('true');
    expect(document.querySelector('.sidebar-nav .sidebar-indicator')).toBeNull(); // hors du tablist
    expect(hl()).toEqual({ x: '8px', y: '8px', w: '220px', h: '44px', o: '1' });
    expect(ind.classList.contains('is-ready')).toBe(true);
    expect(document.querySelector('.settings-sidebar').classList.contains('has-indicator')).toBe(true);
    expect(observed).toContain(document.querySelector('.sidebar-nav'));
    expect(observed).toContain(document.getElementById('tab-privacy'));
    tabs.setup();
    expect(document.querySelectorAll('.sidebar-indicator')).toHaveLength(1);
  });

  test('ancre d’alias (#danger) : pastille directement sur Confidentialité, sans morphing', () => {
    const vt = mockViewTransition();
    window.history.replaceState(null, '', '/settings#danger');
    const tabs = loadTabs();
    tabs.setup();
    expect(document.startViewTransition).not.toHaveBeenCalled();
    expect(vt.seen.before).toBeNull();
    expect(hl().y).toBe('104px');
    expect(document.getElementById('privacy').hidden).toBe(false);
    expect(document.activeElement.id).toBe('delete-block');
  });

  test('clic : la pastille glisse (transition gardée)', () => {
    const tabs = loadTabs();
    tabs.setup();
    const ind = document.querySelector('.sidebar-indicator');
    document.getElementById('tab-account').click();
    expect(hl()).toEqual({ x: '8px', y: '56px', w: '220px', h: '44px', o: '1' });
    expect(ind.classList.contains('is-ready')).toBe(true);
    document.getElementById('tab-privacy').click();
    expect(hl().y).toBe('104px');
  });

  test('mise en page changée : recalage sans animation ; mesure inchangée : rien', async () => {
    const tabs = loadTabs();
    tabs.setup();
    const ind = document.querySelector('.sidebar-indicator');
    const removed = jest.spyOn(ind.classList, 'remove');
    roCallback(); // même mesure
    expect(removed).not.toHaveBeenCalledWith('is-ready');
    // Passage en rangée (< 64em) : l'onglet change de place et de largeur.
    layoutTabs({ 'tab-collection': { x: 6, y: 6, w: 150, h: 44 } });
    roCallback();
    expect(removed).toHaveBeenCalledWith('is-ready');
    expect(hl()).toEqual({ x: '6px', y: '6px', w: '150px', h: '44px', o: '1' });
    expect(ind.classList.contains('is-ready')).toBe(true);
    // Onglet Administration révélé : vu par le MutationObserver.
    layoutTabs({ 'tab-collection': { x: 6, y: 12, w: 150, h: 44 } });
    document.getElementById('admin-nav-link').classList.remove('hidden');
    await new Promise((r) => setTimeout(r, 0));
    expect(hl().y).toBe('12px');
  });

  test('onglet non rendu : pastille masquée, l’onglet garde son propre fond', () => {
    const tabs = loadTabs();
    tabs.setup();
    layoutTabs({ 'tab-account': { x: 0, y: 0, w: 0, h: 0 } });
    tabs.placeIndicator(document.getElementById('tab-account'));
    expect(hl().o).toBe('0');
    expect(document.querySelector('.settings-sidebar').classList.contains('has-indicator')).toBe(false);
    fakeLayout(document.getElementById('tab-privacy'), { x: 1, y: 1, w: 10, h: 10 }, null);
    tabs.placeIndicator(document.getElementById('tab-privacy'));
    expect(hl().o).toBe('0');
    tabs.placeIndicator(null);
    expect(hl().o).toBe('0');
    document.querySelector('.sidebar-indicator').remove();
    expect(() => tabs.placeIndicator(document.getElementById('tab-collection'))).not.toThrow();
  });

  test('sans colonne .settings-sidebar ni ResizeObserver : onglets fonctionnels, pas de pastille', () => {
    delete global.ResizeObserver;
    document.querySelector('.settings-sidebar').replaceWith(document.querySelector('.sidebar-nav'));
    const tabs = loadTabs();
    tabs.setup();
    expect(document.querySelector('.sidebar-indicator')).toBeNull();
    document.getElementById('tab-account').click();
    expect(document.getElementById('account').hidden).toBe(false);
    expect(tabs.morphNames().map(([, n]) => n)).toEqual(['vh-set-frame', 'vh-set-title', 'vh-set-account-0', 'vh-set-account-1']);
  });

  test('sans ResizeObserver mais avec la colonne : pastille posée quand même', () => {
    delete global.ResizeObserver;
    const tabs = loadTabs();
    tabs.setup();
    expect(hl().o).toBe('1');
  });

  test('sans View Transitions (Firefox) : changement direct, entrée CSS conservée, aucun nom', () => {
    const tabs = loadTabs();
    tabs.setup();
    document.getElementById('tab-account').click();
    const account = document.getElementById('account');
    expect(account.hidden).toBe(false);
    expect(account.classList.contains('is-morphed')).toBe(false);
    expect(document.documentElement.classList.contains('vh-set')).toBe(false);
    expect([...document.querySelectorAll('*')].some((el) => el.style.viewTransitionName)).toBe(false);
  });

  test('mouvement réduit (réglage du site) : pas de transition même si l’API existe', () => {
    mockViewTransition();
    const tabs = loadTabs();
    window.VH.motion.setReducedMotion(true);
    tabs.setup();
    document.getElementById('tab-account').click();
    expect(document.startViewTransition).not.toHaveBeenCalled();
    expect(document.getElementById('account').hidden).toBe(false);
  });

  test('vers un onglet placé après : cadre et titre appariés, blocs nommés par section, sens « suivant »', async () => {
    const vt = mockViewTransition();
    const tabs = loadTabs();
    tabs.setup();
    document.getElementById('tab-account').click();

    expect(document.startViewTransition).toHaveBeenCalledTimes(1);
    expect(vt.seen.rootClasses).toEqual(expect.arrayContaining(['vh-set', 'vh-set-next']));
    expect(vt.seen.rootClasses).not.toContain('vh-set-prev');
    expect(vt.seen.before).toEqual({
      'vh-set-nav': 'settings-sidebar has-indicator',
      'vh-set-frame': 'section-card',
      'vh-set-title': 'collection-title',
      'vh-set-collection-0': 'section-header',
      'vh-set-collection-1': 'col-content',
    });
    expect(vt.seen.after).toEqual({
      'vh-set-nav': 'settings-sidebar has-indicator',
      'vh-set-frame': 'section-card',
      'vh-set-title': 'account-title',
      'vh-set-account-0': 'section-header',
      'vh-set-account-1': 'profile-form',
    });
    const account = document.getElementById('account');
    expect(account.hidden).toBe(false);
    expect(account.classList.contains('is-morphed')).toBe(true);
    expect(document.getElementById('collection').hidden).toBe(true);
    expect(document.getElementById('tab-account').getAttribute('aria-selected')).toBe('true');

    vt.finish();
    await flush();
    expect([...document.querySelectorAll('*')].some((el) => el.style.viewTransitionName)).toBe(false);
    expect(document.documentElement.classList.contains('vh-set')).toBe(false);
    expect(document.documentElement.classList.contains('vh-set-next')).toBe(false);

    // Onglet actif recliqué : la marque reste (la retirer relancerait l'entrée CSS).
    document.getElementById('tab-account').click();
    expect(document.startViewTransition).toHaveBeenCalledTimes(1);
    expect(account.classList.contains('is-morphed')).toBe(true);
  });

  test('vers un onglet placé avant : sens « précédent » ; même onglet : aucun morphing', async () => {
    const vt = mockViewTransition();
    window.history.replaceState(null, '', '/settings#privacy');
    const tabs = loadTabs();
    tabs.setup();
    document.getElementById('tab-privacy').click(); // déjà actif
    expect(document.startViewTransition).not.toHaveBeenCalled();
    const home = new window.KeyboardEvent('keydown', { key: 'Home', bubbles: true, cancelable: true });
    document.getElementById('tab-privacy').dispatchEvent(home);
    expect(vt.seen.rootClasses).toEqual(expect.arrayContaining(['vh-set', 'vh-set-prev']));
    expect(vt.seen.before['vh-set-title']).toBe('privacy-title');
    expect(vt.seen.after['vh-set-title']).toBe('collection-title');
    expect(document.activeElement.id).toBe('tab-collection');
    vt.finish();
    await flush();
    tabs.activateTab(document.getElementById('tab-account'), { scroll: false, morph: false });
    expect(document.getElementById('collection').classList.contains('is-morphed')).toBe(false);
  });

  test('direction et noms : cas limites', () => {
    const tabs = loadTabs();
    const d = (a, b) => tabs.direction(document.getElementById(a), document.getElementById(b));
    expect(d('tab-account', 'tab-privacy')).toBe(1);
    expect(d('tab-privacy', 'tab-collection')).toBe(-1);
    document.getElementById('collection').classList.remove('active');
    document.getElementById('orphan').classList.add('active');
    expect(tabs.morphNames()).toEqual([[document.querySelector('.settings-sidebar'), 'vh-set-nav']]);
    document.getElementById('orphan').classList.remove('active');
    expect(tabs.morphNames()).toHaveLength(1);
  });
});

describe('VH.settings.account', () => {
  test('userFromPayload et normalizeUser', () => {
    const { account } = loadModules();
    expect(account.userFromPayload({ id: 2, role: '3' })).toEqual({ id: 2, name: 'Utilisateur', email: '', role: 3 });
    expect(account.userFromPayload(null)).toEqual({ name: 'Utilisateur', email: '' });
    expect(account.normalizeUser({ id: 1, role_id: 2 }).role).toBe(2);
    expect(account.normalizeUser({ id: 1, role: '1', role_id: 3 }).role).toBe(1);
  });

  test('utilisateur en mémoire avec date : formulaire rempli, administration révélée, pas d’appel', async () => {
    const { account } = loadModules();
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1, created_at: '2025-03-04' });
    const state = { currentUser: null };
    expect(await account.checkAuth(state)).toBe(true);
    expect(state.currentUser.name).toBe('Chef');
    expect(document.getElementById('name').value).toBe('Chef');
    expect(document.getElementById('admin-nav-link').classList.contains('hidden')).toBe(false);
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('sans date d’inscription : complété par l’API (role_id normalisé), champ déjà modifié respecté', async () => {
    const { account } = loadModules();
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Ed', email: 'ed@x.fr', role: 3 });
    let release;
    auth.authFetch.mockReturnValue(new Promise((r) => { release = r; }));
    const state = { currentUser: null };
    const done = account.checkAuth(state);
    await flush();
    document.getElementById('name').value = 'Édité'; // saisi pendant la requête
    release(jsonResponse(200, { id: 1, name: 'Edouard', email: 'edouard@x.fr', role_id: 2, created_at: '2025-03-04T10:00:00Z' }));
    await done;
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/1');
    expect(state.currentUser).toMatchObject({ role: 2, created_at: '2025-03-04T10:00:00Z', name: 'Edouard' });
    expect(auth.setUserInfo).toHaveBeenCalledWith(state.currentUser);
    expect(document.getElementById('name').value).toBe('Édité');
    expect(document.getElementById('email').value).toBe('edouard@x.fr');
    expect(document.getElementById('admin-nav-link').classList.contains('hidden')).toBe(true);
  });

  test('API en erreur puis réseau coupé : utilisateur du jeton, sans date', async () => {
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
  });

  test('utilisateur sans identifiant : pas d’appel ; champs absents tolérés', async () => {
    const { account } = loadModules();
    auth.getUserInfo.mockReturnValue({ name: 'Anonyme', role: 3 });
    auth.getPayload.mockReturnValueOnce({ id: 1 }).mockReturnValue({});
    document.getElementById('name').remove();
    await account.checkAuth({ currentUser: null });
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('sans session : un rafraîchissement tenté puis redirection vers /login', async () => {
    const { account } = loadModules();
    auth.getPayload.mockReturnValue(null);
    auth.authFetch.mockRejectedValue(new Error('401'));
    const spy = jest.spyOn(console, 'error').mockImplementation(() => {}); // navigation jsdom
    expect(await account.checkAuth({ currentUser: null })).toBe(false);
    spy.mockRestore();
    expect(auth.authFetch).toHaveBeenCalledWith('/api/stats');
  });

  test('session revenue après rafraîchissement', async () => {
    const { account } = loadModules();
    auth.getPayload.mockReturnValueOnce(null).mockReturnValue({ id: 1, role: 3 });
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'R', email: 'r@x.fr', role: 3, created_at: '2025-01-01' });
    const state = { currentUser: null };
    expect(await account.checkAuth(state)).toBe(true);
    expect(state.currentUser.name).toBe('R');
  });
});

describe('VH.settings.profile', () => {
  function setup(user = { id: 1, name: 'Chef', email: 'chef@x.fr', role: 1 }) {
    const S = loadModules();
    const state = { currentUser: user };
    S.saveBar.setup();
    S.profile.setup(state);
    document.getElementById('name').value = user.name;
    document.getElementById('email').value = user.email;
    return { S, state };
  }
  const submit = () => document.getElementById('profile-form').dispatchEvent(new window.Event('submit', { cancelable: true }));
  const type = (id, value) => {
    const el = document.getElementById(id);
    el.value = value;
    el.dispatchEvent(new window.Event('input'));
  };

  test('le mot de passe actuel n\'est demandé que si l\'adresse change', () => {
    setup();
    type('email', ' CHEF@x.fr ');
    expect(document.getElementById('profile-current-password-group').hidden).toBe(true);
    type('email', 'autre@x.fr');
    expect(document.getElementById('profile-current-password-group').hidden).toBe(false);
  });

  test('isDirty : nom ou adresse différents de l’enregistré ; utilisateur absent : non', () => {
    const { S, state } = setup();
    expect(S.profile.isDirty(state)).toBe(false);
    type('name', 'Chef ');
    expect(S.profile.isDirty(state)).toBe(false);
    type('name', 'Chef2');
    expect(S.profile.isDirty(state)).toBe(true);
    expect(S.profile.isDirty({ currentUser: null })).toBe(false);
  });

  test('saisie : la barre apparaît ; Annuler : valeurs enregistrées, barre masquée', () => {
    const { S } = setup();
    expect(document.getElementById('save-bar').hidden).toBe(true);
    type('email', 'autre@x.fr');
    document.getElementById('profile-current-password').value = 'x';
    expect(document.getElementById('save-bar').hidden).toBe(false);
    document.getElementById('save-bar-cancel').click();
    expect(document.getElementById('email').value).toBe('chef@x.fr');
    expect(document.getElementById('profile-current-password').value).toBe('');
    expect(document.getElementById('profile-current-password-group').hidden).toBe(true);
    expect(S.saveBar.isShown()).toBe(false);
  });

  test('validation : nom, email, mot de passe actuel (aucune requête)', async () => {
    setup();
    type('name', 'A');
    submit();
    await flush();
    expect(document.getElementById('name-error').textContent).toBe('t:settings.toast_name_min');
    type('name', 'Chef2');
    type('email', 'x');
    submit();
    await flush();
    expect(document.getElementById('email-error').textContent).toBe('t:settings.toast_email_invalid');
    type('email', 'autre@x.fr');
    submit();
    await flush();
    expect(document.getElementById('profile-current-password-error').textContent).toBe('t:settings.toast_current_password_required');
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('Entrée sans modification : rien n’est envoyé', async () => {
    setup();
    submit();
    await flush();
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('nom seul (Entrée) : PUT {name}, toast, coche sur la barre, en-tête mis à jour', async () => {
    jest.useFakeTimers();
    const { S, state } = setup();
    const render = jest.spyOn(S.identity, 'render');
    type('name', 'Nouveau');
    auth.authFetch.mockResolvedValue(jsonResponse(200, {}));
    submit();
    await flush(8);
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body)).toEqual({ name: 'Nouveau' });
    expect(state.currentUser.name).toBe('Nouveau');
    expect(toasts).toContainEqual(['success', 't:settings.toast_profile_updated']);
    expect(render).toHaveBeenCalledWith(state.currentUser);
    expect(document.getElementById('save-bar-save').dataset.bb).toBe('done');
    jest.advanceTimersByTime(window.VH.busyButton.HOLD_MS);
    await flush(8);
    jest.advanceTimersByTime(400);
    expect(document.getElementById('save-bar').hidden).toBe(true);
    expect(document.getElementById('save-bar-live').textContent).toBe('t:settings.savebar_saved');
  });

  test('sans barre d’enregistrement : envoi direct', async () => {
    const { S, state } = setup();
    delete window.VH.settings.saveBar;
    type('name', 'Direct');
    auth.authFetch.mockResolvedValue(jsonResponse(200, {}));
    submit();
    await flush(8);
    expect(state.currentUser.name).toBe('Direct');
    expect(S.profile.submitProfile).toBeDefined();
  });

  test('changement d\'adresse en attente : adresse actuelle conservée, barre masquée sans coche', async () => {
    const { state } = setup();
    type('email', 'autre@x.fr');
    document.getElementById('profile-current-password').value = 'Secret1';
    auth.authFetch.mockResolvedValue(jsonResponse(200, { emailChangePending: true }));
    document.getElementById('save-bar-save').click();
    await tick();
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body)).toEqual({ name: 'Chef', email: 'autre@x.fr', currentPassword: 'Secret1' });
    expect(document.getElementById('email').value).toBe('chef@x.fr');
    expect(document.getElementById('profile-current-password').value).toBe('');
    expect(state.currentUser.email).toBe('chef@x.fr');
    expect(toasts).toContainEqual(['info', 't:settings.toast_email_change_pending']);
    expect(document.getElementById('save-bar-save').dataset.bb).toBeUndefined();
    expect(document.getElementById('email-code-box').hidden).toBe(false);
    expect(document.getElementById('email-code-target').textContent).toBe('autre@x.fr');
    expect(document.querySelectorAll('#email-code-otp .otp-slot')).toHaveLength(6);
  });

  describe('code du changement d\'adresse', () => {
    async function pending(S) {
      type('email', 'autre@x.fr');
      document.getElementById('profile-current-password').value = 'Secret1';
      auth.authFetch.mockResolvedValueOnce(jsonResponse(200, { emailChangePending: true }));
      submit();
      await tick();
      S.profile.navigate = jest.fn();
      return document.querySelector('#email-code-otp input');
    }
    const typeCode = (input, code) => [...code].forEach((k) => input.dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true })));

    test('code juste : confirmation, puis déconnexion et retour à la connexion', async () => {
      const { S } = setup();
      const input = await pending(S);
      auth.logout = jest.fn(() => Promise.resolve());
      jest.useFakeTimers();
      auth.authFetch.mockResolvedValueOnce(jsonResponse(200, { email: 'autre@x.fr' }));
      typeCode(input, '123456');
      await flush(3);
      expect(auth.authFetch).toHaveBeenLastCalledWith('/api/auth/confirm-email-change', expect.objectContaining({ method: 'POST' }));
      expect(JSON.parse(auth.authFetch.mock.calls.at(-1)[1].body)).toEqual({ code: '123456' });
      expect(document.getElementById('email-code-otp').classList.contains('is-success')).toBe(true);
      expect(document.getElementById('email-code-status').textContent).toBe('t:settings.email_code_done');
      jest.advanceTimersByTime(1500);
      await flush(2);
      expect(auth.logout).toHaveBeenCalled();
      expect(S.profile.navigate).toHaveBeenCalledWith('/login');
    });

    test('déconnexion qui échoue (session déjà révoquée) : retour à la connexion quand même', async () => {
      const { S } = setup();
      const input = await pending(S);
      auth.logout = jest.fn(() => Promise.reject(new Error('401')));
      jest.useFakeTimers();
      auth.authFetch.mockResolvedValueOnce({ ok: true, status: 200, json: () => Promise.reject(new Error('vide')) });
      typeCode(input, '123456');
      await flush(4);
      jest.advanceTimersByTime(1500);
      await flush(3);
      expect(S.profile.navigate).toHaveBeenCalledWith('/login');
    });

    test('code faux, adresse prise, réseau : erreur, champ réactivé', async () => {
      const { S } = setup();
      const input = await pending(S);
      const status = () => document.getElementById('email-code-status').textContent;
      auth.authFetch.mockResolvedValueOnce(jsonResponse(400, { code: 'CODE_INVALID' }));
      typeCode(input, '000000');
      await tick();
      expect(status()).toBe('t:settings.email_code_invalid');
      expect(document.getElementById('email-code-otp').classList.contains('is-error')).toBe(true);
      expect(input.disabled).toBe(false);
      auth.authFetch.mockResolvedValueOnce(jsonResponse(409, { code: 'EMAIL_TAKEN' }));
      input.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Backspace', bubbles: true }));
      expect(status()).toBe('');
      typeCode(input, '1');
      await tick();
      expect(status()).toBe('t:settings.email_code_taken');
      auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
      input.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Backspace', bubbles: true }));
      typeCode(input, '2');
      await tick();
      expect(status()).toBe('t:settings.toast_network_error');
    });

    test('annuler masque le champ ; une nouvelle demande le rouvre, vidé', async () => {
      const { S } = setup();
      const input = await pending(S);
      typeCode(input, '12');
      document.getElementById('email-code-cancel').click();
      expect(document.getElementById('email-code-box').hidden).toBe(true);
      await pending(S);
      expect(document.getElementById('email-code-box').hidden).toBe(false);
      expect(input.value).toBe('');
    });

    test('sans le bloc du code dans la page : rien ne casse', async () => {
      document.getElementById('email-code-box').remove();
      const { S } = setup();
      await pending(S);
      expect(toasts).toContainEqual(['info', 't:settings.toast_email_change_pending']);
    });
  });

  test('mot de passe actuel refusé, autre erreur, réseau : la barre reste, bouton rendu', async () => {
    setup();
    type('name', 'Nouveau');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { code: 'CURRENT_PASSWORD_INVALID' }));
    submit(); await tick();
    expect(document.getElementById('profile-current-password-error').textContent).toBe('t:settings.toast_current_password_invalid');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(400, { message: 'Non' }));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 'Non']);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(400, {}));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 't:settings.toast_profile_error']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    submit(); await tick();
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(document.getElementById('save-bar-save').disabled).toBe(false);
    expect(document.getElementById('save-bar').hidden).toBe(false);
  });

  test('resetForm sans champs : aucune erreur', () => {
    const { S } = setup();
    ['name', 'email', 'profile-current-password'].forEach((id) => document.getElementById(id).remove());
    expect(() => S.profile.resetForm({ currentUser: null })).not.toThrow();
    expect(S.profile.isDirty({ currentUser: { name: 'x' } })).toBe(false);
  });
});

describe('VH.settings.security', () => {
  function setup() {
    const S = loadModules();
    S.security.setup({ currentUser: { id: 1 } });
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
    expect(security.meetsRequirements('Aa1' + 'x'.repeat(126))).toBe(false);
    expect(security.passwordRequirements('Aa1' + 'x'.repeat(126))['req-length']).toBe(false);
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

describe('VH.settings.cookies', () => {
  test('état initial lu depuis le consentement enregistré', () => {
    const recent = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify({ preferences: { analytics: true }, timestamp: recent.toISOString() }));
    const { cookies } = loadModules();
    cookies.init();
    expect(document.getElementById('pref-analytics').checked).toBe(true);
    expect(document.getElementById('analytics-status').textContent).toBe('t:settings.enabled');
    expect(document.getElementById('analytics-status').classList.contains('is-enabled')).toBe(true);
    expect(document.getElementById('consent-date').textContent).toMatch(String(recent.getFullYear()));
    expect(document.getElementById('consent-date').hasAttribute('data-i18n')).toBe(false);
    expect(cookies.isDirty()).toBe(false);
  });

  test('sans consentement ou JSON invalide : rien ne change', () => {
    const { cookies } = loadModules();
    cookies.loadCookiePreferences();
    localStorage.setItem('voldhistoire_cookie_consent', '{');
    cookies.loadCookiePreferences();
    expect(document.getElementById('analytics-status').textContent).toBe('');
  });

  test('interrupteur changé : barre affichée ; Enregistrer : localStorage, cookieConsent appliqué, événement', async () => {
    const S = loadModules();
    S.saveBar.setup();
    S.cookies.init();
    window.cookieConsent = { applyConsent: jest.fn(), openModal: jest.fn() };
    const events = [];
    document.addEventListener('cookieConsent', (e) => events.push(e.detail.event));
    const toggle = document.getElementById('pref-analytics');
    toggle.checked = true;
    toggle.dispatchEvent(new window.Event('change'));
    expect(document.getElementById('analytics-status').textContent).toBe('t:settings.enabled');
    expect(document.getElementById('save-bar').hidden).toBe(false);
    await S.saveBar.save();
    const saved = JSON.parse(localStorage.getItem('voldhistoire_cookie_consent'));
    expect(saved.preferences).toEqual({ essential: true, analytics: true, marketing: false });
    expect(document.cookie).toContain('voldhistoire_cookie_consent=true');
    expect(window.cookieConsent.applyConsent).toHaveBeenCalled();
    expect(events).toContain('preferences_saved');
    expect(S.cookies.isDirty()).toBe(false);
    document.getElementById('open-cookie-modal').click();
    expect(window.cookieConsent.openModal).toHaveBeenCalled();
    delete window.cookieConsent;
  });

  test('Annuler : interrupteur remis sur le choix enregistré', () => {
    const S = loadModules();
    S.saveBar.setup();
    S.cookies.init();
    const toggle = document.getElementById('pref-analytics');
    toggle.checked = true;
    toggle.dispatchEvent(new window.Event('change'));
    document.getElementById('save-bar-cancel').click();
    expect(toggle.checked).toBe(false);
    expect(document.getElementById('analytics-status').textContent).toBe('t:settings.disabled');
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

  test('sans interrupteur : jamais modifié, remise à zéro sans effet', () => {
    const { cookies } = loadModules();
    document.getElementById('pref-analytics').remove();
    expect(cookies.isDirty()).toBe(false);
    expect(() => cookies.resetToggle()).not.toThrow();
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
    expect(cookies.saveCookiePreferences()).toBe(false);
    expect(toasts).toContainEqual(['error', 't:settings.toast_cookies_unavailable']);
    expect(() => cookies.loadCookiePreferences()).not.toThrow();
    expect(cookies.isDirty()).toBe(false);
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
    btn.click();
    expect(auth.authFetch).toHaveBeenCalledTimes(1);

    resolve(exportResponse());
    await flush(8);
    expect(clicks).toEqual([{ href: 'blob:vh/1', download: 'vol-histoire-donnees-42.json', attached: true }]);
    expect(document.querySelector('a[download]')).toBeNull();
    expect(btn.dataset.bb).toBe('done');
    expect(btn.querySelector('.bb-done-text').textContent).toBe('t:settings.btn_downloaded');
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
  afterEach(() => window.history.replaceState(null, '', '/'));

  test('administrateur : en-tête, collection et liste des utilisateurs chargées ; #admin ouvert après révélation', async () => {
    window.history.replaceState(null, '', '/settings#admin');
    auth.getUserInfo.mockReturnValue({ id: 1, name: 'Chef', email: 'chef@x.fr', role: 1, created_at: '2025-03-04' });
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: [], meta: { total: 0 } }));
    await boot();
    const urls = auth.authFetch.mock.calls.map(([u]) => u);
    expect(urls).toContain('/api/users?page=1&limit=8');
    expect(urls).toContain('/api/favorites');
    expect(document.getElementById('id-name').textContent).toBe('Chef');
    expect(document.getElementById('admin-nav-link').getAttribute('aria-selected')).toBe('true');
    document.getElementById('tab-account').click();
    expect(document.getElementById('account').hidden).toBe(false);
  });

  test('membre : pas de liste des utilisateurs', async () => {
    auth.getUserInfo.mockReturnValue({ id: 3, name: 'M', email: 'm@x.fr', role: 3, created_at: '2025-03-04' });
    auth.authFetch.mockResolvedValue(jsonResponse(200, []));
    await boot();
    const urls = auth.authFetch.mock.calls.map(([u]) => u);
    expect(urls).not.toContain('/api/users?page=1&limit=8');
    expect(urls).toContain('/api/favorites');
  });

  test('sans session : rien n’est chargé', async () => {
    auth.getPayload.mockReturnValue(null);
    auth.authFetch.mockRejectedValue(new Error('401'));
    const spy = jest.spyOn(console, 'error').mockImplementation(() => {});
    await boot();
    spy.mockRestore();
    expect(auth.authFetch.mock.calls.map(([u]) => u)).not.toContain('/api/favorites');
  });
});
