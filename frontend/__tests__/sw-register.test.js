/**
 * @jest-environment jsdom
 *
 * js/sw-register.js : enregistrement du service worker versionné et toast
 * « Nouvelle version disponible — Recharger » (MOB-004, MOB-005).
 */
/* global EventTarget */
const sw = require('../js/sw-register.js');

function fakeServiceWorker({ controller = {}, register } = {}) {
  const target = new EventTarget();
  target.controller = controller;
  target.register = register || jest.fn(() => Promise.resolve(fakeRegistration()));
  return target;
}

function fakeRegistration({ waiting = null } = {}) {
  const reg = new EventTarget();
  reg.waiting = waiting;
  reg.installing = null;
  return reg;
}

function fakeWorker(state = 'installing') {
  const w = new EventTarget();
  w.state = state;
  w.postMessage = jest.fn();
  return w;
}

function makeCtx(overrides = {}) {
  return {
    window: { i18n: null },
    document,
    navigator: { serviceWorker: fakeServiceWorker() },
    location: { protocol: 'https:', hostname: 'vol-histoire.titouan-borde.com', href: 'https://vol-histoire.titouan-borde.com/hangar', reload: jest.fn() },
    scriptSrc: 'https://vol-histoire.titouan-borde.com/js/sw-register.js?v=4.13.1',
    state: { reloadRequested: false },
    ...overrides,
  };
}

beforeEach(() => {
  document.body.innerHTML = '';
  document.documentElement.lang = 'fr';
});

describe('scriptVersion / swUrl', () => {
  test('lit le ?v= posé par serveHtml', () => {
    expect(sw.scriptVersion('/js/sw-register.js?v=4.13.1', 'https://x.test/')).toBe('4.13.1');
  });
  test('null sans paramètre, sans src ou avec une valeur suspecte', () => {
    expect(sw.scriptVersion('/js/sw-register.js', 'https://x.test/')).toBeNull();
    expect(sw.scriptVersion(null, 'https://x.test/')).toBeNull();
    expect(sw.scriptVersion('/js/a.js?v=<script>', 'https://x.test/')).toBeNull();
    expect(sw.scriptVersion('http://[', undefined)).toBeNull();
  });
  test('URL du SW versionnée, ou nue en repli', () => {
    expect(sw.swUrl('4.13.1')).toBe('/sw.js?v=4.13.1');
    expect(sw.swUrl(null)).toBe('/sw.js');
  });
});

describe('canRegister', () => {
  const nav = { serviceWorker: {} };
  test('HTTPS ou boucle locale uniquement', () => {
    expect(sw.canRegister(nav, { protocol: 'https:', hostname: 'a.fr' })).toBe(true);
    expect(sw.canRegister(nav, { protocol: 'http:', hostname: 'localhost' })).toBe(true);
    expect(sw.canRegister(nav, { protocol: 'http:', hostname: '127.0.0.1' })).toBe(true);
    expect(sw.canRegister(nav, { protocol: 'http:', hostname: 'a.fr' })).toBe(false);
  });
  test('sans API service worker ou en économie de données : non', () => {
    expect(sw.canRegister({}, { protocol: 'https:', hostname: 'a.fr' })).toBe(false);
    expect(sw.canRegister(null, { protocol: 'https:', hostname: 'a.fr' })).toBe(false);
    expect(sw.canRegister({ serviceWorker: {}, connection: { saveData: true } }, { protocol: 'https:', hostname: 'a.fr' })).toBe(false);
  });
});

describe('label', () => {
  test('traduction i18n quand elle existe', () => {
    const win = { i18n: { t: (k) => (k === 'pwa.update_reload' ? 'Reload now' : k) } };
    expect(sw.label('reload', win, document)).toBe('Reload now');
  });
  test('repli selon <html lang> si la clé est absente ou i18n non chargé', () => {
    const win = { i18n: { t: (k) => k } };
    expect(sw.label('message', win, document)).toBe('Nouvelle version disponible');
    document.documentElement.lang = 'en';
    expect(sw.label('reload', {}, document)).toBe('Reload');
    document.documentElement.lang = 'de';
    expect(sw.label('close', null, document)).toBe('Fermer');
  });
});

describe('showUpdateNotice', () => {
  test('toast accessible dans #toast-container, un seul à la fois', () => {
    document.body.innerHTML = '<div id="toast-container"></div>';
    const ctx = makeCtx();
    const worker = fakeWorker('installed');
    const toast = sw.showUpdateNotice(worker, ctx);
    expect(toast.parentElement.id).toBe('toast-container');
    expect(toast.getAttribute('role')).toBe('status');
    expect(toast.querySelector('.toast-message').textContent).toBe('Nouvelle version disponible');
    expect(toast.querySelector('.sw-update-reload').textContent).toBe('Recharger');
    expect(toast.querySelector('.toast-close').getAttribute('aria-label')).toBe('Fermer');
    expect(sw.showUpdateNotice(worker, ctx)).toBeNull();
    expect(document.querySelectorAll('.sw-update')).toHaveLength(1);
  });

  test('crée le conteneur de toasts s\'il manque', () => {
    sw.showUpdateNotice(fakeWorker(), makeCtx());
    const container = document.getElementById('toast-container');
    expect(container).not.toBeNull();
    expect(container.getAttribute('aria-live')).toBe('polite');
  });

  test('Recharger envoie SKIP_WAITING et bloque le bouton', () => {
    const ctx = makeCtx();
    const worker = fakeWorker('installed');
    const toast = sw.showUpdateNotice(worker, ctx);
    const btn = toast.querySelector('.sw-update-reload');
    btn.click();
    expect(worker.postMessage).toHaveBeenCalledWith({ type: 'SKIP_WAITING' });
    expect(ctx.state.reloadRequested).toBe(true);
    expect(btn.disabled).toBe(true);
    expect(btn.getAttribute('aria-busy')).toBe('true');
  });

  test('la croix ferme le toast', () => {
    const toast = sw.showUpdateNotice(fakeWorker(), makeCtx());
    toast.querySelector('.toast-close').click();
    expect(document.querySelector('.sw-update')).toBeNull();
  });
});

describe('watchRegistration', () => {
  test('SW déjà en attente et page contrôlée : annonce', () => {
    const ctx = makeCtx();
    sw.watchRegistration(fakeRegistration({ waiting: fakeWorker('installed') }), ctx);
    expect(document.querySelector('.sw-update')).not.toBeNull();
  });

  test('premier enregistrement (aucun contrôleur) : pas d\'annonce', () => {
    const ctx = makeCtx({ navigator: { serviceWorker: fakeServiceWorker({ controller: null }) } });
    sw.watchRegistration(fakeRegistration({ waiting: fakeWorker('installed') }), ctx);
    expect(document.querySelector('.sw-update')).toBeNull();
  });

  test('nouvelle version installée plus tard : annonce à l\'état installed', () => {
    const ctx = makeCtx();
    const reg = fakeRegistration();
    sw.watchRegistration(reg, ctx);
    const installing = fakeWorker('installing');
    reg.installing = installing;
    reg.dispatchEvent(new Event('updatefound'));
    installing.dispatchEvent(new Event('statechange'));
    expect(document.querySelector('.sw-update')).toBeNull();
    installing.state = 'installed';
    installing.dispatchEvent(new Event('statechange'));
    expect(document.querySelector('.sw-update')).not.toBeNull();
  });

  test('updatefound sans worker en installation : ignoré', () => {
    const reg = fakeRegistration();
    sw.watchRegistration(reg, makeCtx());
    expect(() => reg.dispatchEvent(new Event('updatefound'))).not.toThrow();
  });
});

describe('init', () => {
  test('contexte non éligible : rien n\'est enregistré', () => {
    const ctx = makeCtx({ location: { protocol: 'http:', hostname: 'a.fr', href: 'http://a.fr/' } });
    expect(sw.init(ctx)).toBeNull();
    expect(ctx.navigator.serviceWorker.register).not.toHaveBeenCalled();
  });

  test('enregistre /sw.js?v=<version du script> sur la portée /', async () => {
    const ctx = makeCtx();
    const reg = await sw.init(ctx);
    expect(ctx.navigator.serviceWorker.register).toHaveBeenCalledWith('/sw.js?v=4.13.1', { scope: '/' });
    expect(reg).toBeInstanceOf(EventTarget);
  });

  test('état créé s\'il manque', async () => {
    const ctx = makeCtx({ state: undefined });
    await sw.init(ctx);
    expect(ctx.state).toEqual({ reloadRequested: false });
  });

  test('controllerchange ne recharge que sur demande, et une seule fois', async () => {
    const ctx = makeCtx();
    await sw.init(ctx);
    const target = ctx.navigator.serviceWorker;
    target.dispatchEvent(new Event('controllerchange'));
    expect(ctx.location.reload).not.toHaveBeenCalled();
    ctx.state.reloadRequested = true;
    target.dispatchEvent(new Event('controllerchange'));
    target.dispatchEvent(new Event('controllerchange'));
    expect(ctx.location.reload).toHaveBeenCalledTimes(1);
  });

  test('échec d\'enregistrement silencieux', async () => {
    const ctx = makeCtx({
      navigator: { serviceWorker: fakeServiceWorker({ register: jest.fn(() => Promise.reject(new Error('x'))) }) },
    });
    await expect(sw.init(ctx)).resolves.toBeNull();
  });
});

describe('boot', () => {
  function fakeWin() {
    const win = new EventTarget();
    win.navigator = { serviceWorker: fakeServiceWorker() };
    win.location = { protocol: 'http:', hostname: 'localhost', href: 'http://localhost/', reload: jest.fn() };
    return win;
  }

  test('page déjà chargée : enregistre tout de suite, avec la version du script', () => {
    const win = fakeWin();
    const doc = { readyState: 'complete', currentScript: { src: 'http://localhost/js/sw-register.js?v=9.9.9' } };
    const ctx = sw.boot(win, doc);
    expect(ctx.scriptSrc).toContain('v=9.9.9');
    expect(win.navigator.serviceWorker.register).toHaveBeenCalledWith('/sw.js?v=9.9.9', { scope: '/' });
  });

  test('page en cours de chargement : attend load', () => {
    const win = fakeWin();
    sw.boot(win, { readyState: 'interactive', currentScript: null });
    expect(win.navigator.serviceWorker.register).not.toHaveBeenCalled();
    win.dispatchEvent(new Event('load'));
    expect(win.navigator.serviceWorker.register).toHaveBeenCalledWith('/sw.js', { scope: '/' });
  });
});
