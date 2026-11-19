/**
 * Tests — frontend/js/shared/view-morph.js
 * jsdom n'a pas l'API View Transitions : elle est simulée (startViewTransition,
 * événements pageswap / pagereveal), ainsi que la mise en page (rectangles).
 */
let vm;
let listeners;

function fakeVt() {
  let resolveFinished;
  const vt = {
    skipTransition: jest.fn(),
    finished: new Promise((r) => { resolveFinished = r; }),
    updateCallbackDone: Promise.resolve(),
  };
  vt.end = () => resolveFinished();
  return vt;
}

const flush = () => new Promise((r) => setTimeout(r, 0));

function load({ reduced = false } = {}) {
  jest.resetModules();
  listeners = { window: {}, document: {} };
  window.VH = { motion: { prefersReducedMotion: () => reduced } };
  const wAdd = jest.spyOn(window, 'addEventListener').mockImplementation((t, fn) => { listeners.window[t] = fn; });
  const dAdd = jest.spyOn(document, 'addEventListener').mockImplementation((t, fn) => { listeners.document[t] = fn; });
  vm = require('../js/shared/view-morph');
  wAdd.mockRestore();
  dAdd.mockRestore();
  return vm;
}

function setPath(path) {
  window.history.replaceState(null, '', path);
}

beforeEach(() => {
  sessionStorage.clear();
  setPath('/');
  document.body.innerHTML = '';
  // Éléments « rendus » : jsdom n'a ni rectangles ni boîtes.
  jest.spyOn(window.Element.prototype, 'getClientRects').mockReturnValue([{}]);
  jest.spyOn(window.Element.prototype, 'getBoundingClientRect').mockReturnValue({ top: 10, bottom: 100, width: 100, height: 90 });
  delete document.startViewTransition;
});

afterEach(() => {
  jest.restoreAllMocks();
  delete document.startViewTransition;
});

const CARDS = `
  <article class="aircraft-card" data-morph-id="30"><div class="aircraft-image" data-morph="photo"></div><a href="/details/rafale-30">Rafale</a></article>
  <article class="aircraft-card" data-morph-id="12"><div class="aircraft-image" data-morph="photo"></div><a href="/details/f-22-12">F-22</a></article>`;
const HERO = '<section class="aircraft-hero" data-morph-self><div class="aircraft-image-container" data-morph="photo"></div></section>';

describe('selfId', () => {
  test('lit l\'id de la fiche dans le chemin ou ?id=, rien ailleurs', () => {
    load();
    expect(vm.selfId({ pathname: '/details/rafale-30', search: '' })).toBe('30');
    expect(vm.selfId({ pathname: '/details/30', search: '' })).toBe('30');
    expect(vm.selfId({ pathname: '/details', search: '?id=14' })).toBe('14');
    expect(vm.selfId({ pathname: '/hangar', search: '?id=14' })).toBeNull();
    expect(vm.selfId({ pathname: '/hangar', search: '' })).toBeNull();
  });
});

describe('photoFor', () => {
  test('carte de l\'appareil, sinon hero de la fiche courante, sinon rien', () => {
    load();
    document.body.innerHTML = CARDS + HERO;
    expect(vm.photoFor('12')).toBe(document.querySelector('[data-morph-id="12"] [data-morph="photo"]'));
    expect(vm.photoFor('99')).toBeNull();
    setPath('/details/mirage-99');
    expect(vm.photoFor('99')).toBe(document.querySelector('[data-morph-self] [data-morph="photo"]'));
    expect(vm.photoFor(null)).toBeNull();
  });

  test('carte avec image : seule l’image vole (pas les pastilles) ; le hero reste entier', () => {
    load();
    document.body.innerHTML = '<article data-morph-id="5"><div data-morph="photo"><img alt=""><span class="badge"></span></div></article>' +
      '<section data-morph-self><div data-morph="photo"><img alt=""></div></section>';
    expect(vm.photoFor('5').tagName).toBe('IMG');
    setPath('/details/x-6');
    expect(vm.photoFor('6').tagName).toBe('DIV');
  });

  test('photo non rendue (aucune boîte) : ignorée', () => {
    load();
    document.body.innerHTML = CARDS;
    window.Element.prototype.getClientRects.mockReturnValue([]);
    expect(vm.photoFor('30')).toBeNull();
  });
});

describe('navigation : carte → fiche', () => {
  test('un clic dans une carte mémorise l\'appareil ; clic modifié ou hors carte : rien', () => {
    load();
    document.body.innerHTML = CARDS + '<a id="out" href="/hangar">x</a>';
    const click = (el, extra = {}) => listeners.document.click({ target: el, button: 0, defaultPrevented: false, ...extra });
    click(document.querySelector('[data-morph-id="12"] a'), { ctrlKey: true });
    expect(sessionStorage.getItem('vh-morph')).toBeNull();
    click(document.getElementById('out'));
    expect(sessionStorage.getItem('vh-morph')).toBeNull();
    click(document.querySelector('[data-morph-id="12"] a'));
    expect(sessionStorage.getItem('vh-morph')).toBe('12');
  });

  test('pageswap vers la fiche de la carte cliquée : photo nommée, nom retiré à la fin', async () => {
    load();
    document.body.innerHTML = CARDS;
    sessionStorage.setItem('vh-morph', '12');
    const vt = fakeVt();
    listeners.window.pageswap({ viewTransition: vt, activation: { entry: { url: 'http://localhost/details/f-22-12' }, navigationType: 'push' } });
    const photo = document.querySelector('[data-morph-id="12"] [data-morph="photo"]');
    expect(vt.skipTransition).not.toHaveBeenCalled();
    expect(photo.style.viewTransitionName).toBe('vh-photo');
    vt.end();
    await flush();
    expect(photo.style.viewTransitionName).toBe('');
  });

  test('pageswap vers une autre fiche, vers une autre page, ou sans carte mémorisée : sautée', () => {
    load();
    document.body.innerHTML = CARDS;
    const swap = (url, type = 'push') => {
      const vt = fakeVt();
      listeners.window.pageswap({ viewTransition: vt, activation: { entry: { url }, navigationType: type } });
      return vt;
    };
    expect(swap('http://localhost/details/x-30').skipTransition).toHaveBeenCalled(); // aucune carte mémorisée
    sessionStorage.setItem('vh-morph', '12');
    expect(swap('http://localhost/details/x-30').skipTransition).toHaveBeenCalled();
    expect(swap('http://localhost/timeline').skipTransition).toHaveBeenCalled();
    // Sans transition (navigateur, mouvement réduit) : rien à faire.
    expect(() => listeners.window.pageswap({ viewTransition: null })).not.toThrow();
  });

  test('retour arrière depuis la fiche : hero nommé', () => {
    load();
    setPath('/details/f-22-12');
    document.body.innerHTML = HERO;
    sessionStorage.setItem('vh-morph', '12');
    const vt = fakeVt();
    listeners.window.pageswap({ viewTransition: vt, activation: { entry: { url: 'http://localhost/hangar' }, navigationType: 'traverse' } });
    expect(vt.skipTransition).not.toHaveBeenCalled();
    expect(document.querySelector('[data-morph-self] [data-morph="photo"]').style.viewTransitionName).toBe('vh-photo');
  });

  test('fiche → fiche par la filiation : le hero est retiré de la transition', async () => {
    load();
    setPath('/details/rafale-30');
    document.body.innerHTML = HERO + '<a class="related-card" data-morph-id="12" href="/details/f-22-12"><div data-morph="photo"></div></a>';
    sessionStorage.setItem('vh-morph', '12');
    const vt = fakeVt();
    listeners.window.pageswap({ viewTransition: vt, activation: { entry: { url: 'http://localhost/details/f-22-12' }, navigationType: 'push' } });
    const hero = document.querySelector('[data-morph-self] [data-morph="photo"]');
    expect(document.querySelector('.related-card [data-morph="photo"]').style.viewTransitionName).toBe('vh-photo');
    expect(hero.style.viewTransitionName).toBe('none');
    vt.end();
    await flush();
    expect(hero.style.viewTransitionName).toBe('');
  });

  test('pagereveal : carte retrouvée nommée, sinon transition sautée ; mouvement réduit : sautée', () => {
    load();
    document.body.innerHTML = CARDS;
    sessionStorage.setItem('vh-morph', '30');
    const ok = fakeVt();
    listeners.window.pagereveal({ viewTransition: ok });
    expect(ok.skipTransition).not.toHaveBeenCalled();
    sessionStorage.setItem('vh-morph', '77');
    const missing = fakeVt();
    listeners.window.pagereveal({ viewTransition: missing });
    expect(missing.skipTransition).toHaveBeenCalled();
    expect(() => listeners.window.pagereveal({})).not.toThrow();

    load({ reduced: true });
    sessionStorage.setItem('vh-morph', '30');
    const reduced = fakeVt();
    listeners.window.pagereveal({ viewTransition: reduced });
    expect(reduced.skipTransition).toHaveBeenCalled();
  });

  test('stockage indisponible : aucune erreur, pas de morphing', () => {
    load();
    document.body.innerHTML = CARDS;
    jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('bloqué'); });
    jest.spyOn(window.Storage.prototype, 'getItem').mockImplementation(() => { throw new Error('bloqué'); });
    expect(() => listeners.document.click({ target: document.querySelector('[data-morph-id="12"] a'), button: 0 })).not.toThrow();
    const vt = fakeVt();
    listeners.window.pageswap({ viewTransition: vt, activation: { entry: { url: 'http://localhost/details/f-22-12' } } });
    expect(vt.skipTransition).toHaveBeenCalled();
  });
});

describe('swap : morphing dans la page', () => {
  test('sans l\'API : mise à jour immédiate', async () => {
    load();
    const update = jest.fn();
    await vm.swap({ root: document.body, update });
    expect(update).toHaveBeenCalledTimes(1);
    await expect(vm.swap({ root: document.body })).resolves.toBeUndefined();
  });

  test('avec l\'API : éléments visibles nommés avant et après, doublons ignorés, noms retirés à la fin', async () => {
    load();
    document.body.innerHTML = CARDS + '<div data-morph-id="30"></div>';
    const vt = fakeVt();
    let namesDuringUpdate = null;
    document.startViewTransition = jest.fn((cb) => {
      cb();
      return vt;
    });
    const update = jest.fn(() => {
      namesDuringUpdate = [...document.querySelectorAll('[data-morph-id]')].map((el) => el.style.viewTransitionName);
      document.body.insertAdjacentHTML('beforeend', '<div data-morph-id="55"></div>');
    });
    await vm.swap({ root: document.body, update });
    expect(update).toHaveBeenCalled();
    // Le second élément d'id 30 n'est pas nommé : un nom doit être unique.
    expect(namesDuringUpdate).toEqual(['vh-m-30', 'vh-m-12', '']);
    expect(document.querySelector('[data-morph-id="55"]').style.viewTransitionName).toBe('vh-m-55');
    vt.end();
    await flush();
    expect([...document.querySelectorAll('[data-morph-id]')].every((el) => el.style.viewTransitionName === '')).toBe(true);
  });

  test('hors écran : non nommé ; mouvement réduit ou sans racine : mise à jour directe', async () => {
    load();
    document.body.innerHTML = CARDS;
    window.Element.prototype.getBoundingClientRect.mockReturnValue({ top: 5000, bottom: 5100, width: 100 });
    const vt = fakeVt();
    document.startViewTransition = jest.fn((cb) => { cb(); return vt; });
    await vm.swap({ root: document.body, update: () => {} });
    expect(document.querySelector('[data-morph-id="30"]').style.viewTransitionName).toBe('');

    document.startViewTransition.mockClear();
    const update = jest.fn();
    await vm.swap({ root: null, update });
    expect(update).toHaveBeenCalled();
    expect(document.startViewTransition).not.toHaveBeenCalled();

    load({ reduced: true });
    document.startViewTransition = jest.fn();
    const u2 = jest.fn();
    await vm.swap({ root: document.body, update: u2 });
    expect(u2).toHaveBeenCalled();
    expect(document.startViewTransition).not.toHaveBeenCalled();
  });
});
