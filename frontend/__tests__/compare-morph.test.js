/**
 * Tests — frontend/js/shared/compare-morph.js et son branchement dans
 * frontend/js/shared/compare.js (vignettes de la barre, morphings carte ↔
 * barre, barre ↔ modale, retrait d'une colonne).
 *
 * jsdom n'a ni l'API View Transitions ni mise en page : startViewTransition
 * est simulée (on relève les noms posés avant et après la mise à jour), et
 * les rectangles des éléments sont fournis par le test (`el.__rect`).
 */

const { loadMotion } = require('./helpers/motion-env');

const proto = window.HTMLDialogElement.prototype;
const native = { showModal: proto.showModal, close: proto.close };

let reduced;
let cm;
let compare;

const OFF = { top: 2000, bottom: 2100, left: 0, right: 100, width: 100, height: 100 };

const flush = async () => { for (let i = 0; i < 12; i++) await Promise.resolve(); };

/** Noms de transition posés dans le document : [[élément, nom], …]. */
function names() {
  return Array.from(document.querySelectorAll('*'))
    .filter((el) => el.style && el.style.viewTransitionName)
    .map((el) => [el, el.style.viewTransitionName]);
}
const nameOf = (el) => (el.style.viewTransitionName || '');

/** startViewTransition simulée : relève les noms avant / après update. */
function installVt() {
  const calls = [];
  document.startViewTransition = jest.fn((cb) => {
    const rec = { before: names(), rootClasses: document.documentElement.className };
    let end;
    const finished = new Promise((r) => { end = r; });
    rec.end = async () => { end(); await flush(); };
    rec.updateCallbackDone = Promise.resolve().then(() => {
      cb();
      rec.after = names();
    });
    calls.push(rec);
    return { finished, updateCallbackDone: rec.updateCallbackDone, skipTransition: jest.fn() };
  });
  return calls;
}

function stubLayout() {
  jest.spyOn(window.Element.prototype, 'getClientRects').mockReturnValue([{}]);
  jest.spyOn(window.Element.prototype, 'getBoundingClientRect').mockImplementation(function () {
    return this.__rect || { top: 10, bottom: 100, left: 10, right: 100, width: 90, height: 90 };
  });
}

function baseVH() {
  window.VH = {
    shared: {
      picture: {
        pictureHtml: (src, o) => `<img class="pic" src="${src}" alt="${o.alt}">`,
        thumbHtml: (src) => `<img class="thumb" src="${src}" alt="">`,
      },
    },
  };
  loadMotion(['.compare-bar.is-leaving', '.cmp-col-head.is-removing', '.compare-modal.is-closing']);
}

/** Charge view-morph + compare-morph (+ compare si `withStore`). */
function load({ withStore = false, viewMorph = true } = {}) {
  jest.resetModules();
  document.body.innerHTML = '';
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.i18n = { t: (k) => k };
  global.showToast = jest.fn();
  baseVH();
  if (viewMorph) require('../js/shared/view-morph');
  cm = require('../js/shared/compare-morph');
  if (withStore) compare = require('../js/shared/compare');
}

beforeEach(() => {
  localStorage.clear();
  sessionStorage.clear();
  window.history.replaceState(null, '', '/hangar');
  reduced = false;
  window.matchMedia = jest.fn((q) => ({ matches: q.includes('reduced-motion') ? reduced : false }));
  proto.showModal = function () { this.setAttribute('open', ''); };
  proto.close = function () { this.removeAttribute('open'); };
  delete document.startViewTransition;
  stubLayout();
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
  delete document.startViewTransition;
  delete global.fetch;
  proto.showModal = native.showModal;
  proto.close = native.close;
  document.documentElement.className = '';
});

const CARD = (id, src = `/assets/airplanes/a${id}.jpg?v=4`) =>
  `<article class="aircraft-card" data-id="${id}" data-morph-id="${id}">` +
  `<div class="aircraft-image" data-morph="photo"><picture><img src="${src}" alt=""></picture></div></article>`;

function barWith(ids) {
  const bar = document.createElement('div');
  bar.innerHTML = '<span class="cmp-thumbs">' +
    ids.map((id) => `<span class="cmp-thumb" data-cmp-thumb="${id}"></span>`).join('') + '</span>';
  document.body.appendChild(bar);
  return bar;
}

// ── compare-morph.js seul ──────────────────────────────────────────────

describe('compareMorph — sans transition', () => {
  test('sans l\'API : chaque morphing fait la mise à jour d\'un coup', async () => {
    load();
    expect(cm.canMorph()).toBe(false);
    const update = jest.fn();
    const bar = barWith([1]);
    await cm.bar({ bar, id: 1, dir: 'add', update });
    await cm.panel({ from: bar, to: bar, update });
    await cm.columns({ body: bar, update });
    expect(update).toHaveBeenCalledTimes(3);
    expect(names()).toEqual([]);
  });

  test('mouvement réduit, onglet caché ou VH.viewMorph absent : pas de morphing', async () => {
    load();
    installVt();
    expect(cm.canMorph()).toBe(true);
    reduced = true;
    expect(cm.canMorph()).toBe(false);
    reduced = false;
    const hidden = jest.spyOn(document, 'hidden', 'get').mockReturnValue(true);
    expect(cm.canMorph()).toBe(false);
    hidden.mockRestore();

    load({ viewMorph: false });
    delete window.VH.viewMorph;
    installVt();
    expect(cm.canMorph()).toBe(false);
    const update = jest.fn();
    await cm.panel({ from: document.body, to: document.body, update });
    expect(update).toHaveBeenCalledTimes(1);
    expect(document.startViewTransition).not.toHaveBeenCalled();
    expect(cm.photoOnScreen(1)).toBeNull();
  });
});

describe('compareMorph.bar — carte ↔ barre', () => {
  test('ajout : la photo de la carte porte le nom de la vignette avant, « none » après', async () => {
    load();
    const calls = installVt();
    document.body.innerHTML = CARD(12) + CARD(30);
    const bar = barWith([30]);
    const photo = document.querySelector('[data-morph-id="12"] img');
    const update = jest.fn(() => {
      bar.querySelector('.cmp-thumbs').insertAdjacentHTML('beforeend', '<span class="cmp-thumb" data-cmp-thumb="12"></span>');
    });
    const done = cm.bar({ bar, id: 12, dir: 'add', update });
    expect(document.documentElement.classList.contains('vh-cmp-adding')).toBe(true);
    await done;

    const [vt] = calls;
    expect(vt.before.map(([el, n]) => [el === photo ? 'photo' : el.dataset.cmpThumb, n]))
      .toEqual([['photo', 'vh-cmp-12'], ['30', 'vh-cmp-30']]);
    const after = new Map(vt.after);
    expect(after.get(photo)).toBe('none');
    expect(after.get(bar.querySelector('[data-cmp-thumb="12"]'))).toBe('vh-cmp-12');
    expect(after.get(bar.querySelector('[data-cmp-thumb="30"]'))).toBe('vh-cmp-30');

    await vt.end();
    expect(names()).toEqual([]);
    expect(document.documentElement.classList.contains('vh-cmp-adding')).toBe(false);
  });

  test('retrait : la vignette porte son nom avant, la photo le reprend après', async () => {
    load();
    const calls = installVt();
    document.body.innerHTML = CARD(12);
    const bar = barWith([12]);
    const thumb = bar.querySelector('[data-cmp-thumb="12"]');
    const photo = document.querySelector('[data-morph-id="12"] img');
    await cm.bar({ bar, id: 12, dir: 'remove', update: () => thumb.remove() });
    const [vt] = calls;
    expect(vt.rootClasses).toContain('vh-cmp-removing');
    expect(new Map(vt.before)).toEqual(new Map([[thumb, 'vh-cmp-12'], [photo, 'none']]));
    expect(vt.after).toEqual([[photo, 'vh-cmp-12']]);
  });

  test('retrait : photo hors de l\'écran — la vignette s\'efface seule', async () => {
    load();
    const calls = installVt();
    document.body.innerHTML = CARD(12);
    document.querySelector('[data-morph-id="12"] img').__rect = OFF;
    const bar = barWith([12]);
    const thumb = bar.querySelector('[data-cmp-thumb="12"]');
    await cm.bar({ bar, id: 12, dir: 'remove', update: () => thumb.remove() });
    expect(calls[0].after).toEqual([]);
  });

  test('ajout avec préchargement : la transition attend le décodage de la vignette', async () => {
    load();
    const calls = installVt();
    let decoded;
    const decode = jest.fn(() => new Promise((r) => { decoded = r; }));
    const RealImage = window.Image;
    window.Image = function () { return { decode }; };
    try {
      const bar = barWith([]);
      const update = jest.fn();
      const done = cm.bar({ bar, id: 5, dir: 'add', update, preload: '/assets/airplanes/a5.avif' });
      await flush();
      expect(decode).toHaveBeenCalled();
      expect(calls).toHaveLength(0);
      decoded();
      await done;
      expect(calls).toHaveLength(1);
      expect(update).toHaveBeenCalled();
    } finally {
      window.Image = RealImage;
    }
  });

  test('préchargement : décodage trop long ou indisponible, on n\'attend pas', async () => {
    load();
    const calls = installVt();
    const RealImage = window.Image;
    jest.useFakeTimers();
    window.Image = function () { return { decode: () => new Promise(() => {}) }; };
    try {
      const done = cm.bar({ bar: barWith([]), id: 5, dir: 'add', update: jest.fn(), preload: '/x.avif' });
      jest.advanceTimersByTime(200);
      await done;
      expect(calls).toHaveLength(1);
      // Image sans decode() : transition immédiate.
      window.Image = function () { return {}; };
      await cm.bar({ bar: barWith([]), id: 6, dir: 'add', update: jest.fn(), preload: '/y.avif' });
      expect(calls).toHaveLength(2);
    } finally {
      window.Image = RealImage;
    }
  });
});

describe('compareMorph.panel — barre ↔ modale', () => {
  test('la source porte le nom avant, la cible après (la source passe à « none »)', async () => {
    load();
    const calls = installVt();
    const from = document.createElement('div');
    const to = document.createElement('dialog');
    document.body.append(from, to);
    await cm.panel({ from, to, update: () => to.setAttribute('open', '') });
    expect(calls[0].before).toEqual([[from, 'vh-cmp-panel']]);
    expect(new Map(calls[0].after)).toEqual(new Map([[from, 'none'], [to, 'vh-cmp-panel']]));
    await calls[0].end();
    expect(nameOf(from)).toBe('');
    expect(nameOf(to)).toBe('');
  });
});

describe('compareMorph.columns — retrait d\'une colonne', () => {
  test('seuls les éléments entièrement visibles sont nommés, avec un rang stable', () => {
    load();
    const body = document.createElement('div');
    body.__rect = { top: 0, bottom: 500, left: 0, right: 1000, width: 1000, height: 500 };
    body.innerHTML =
      '<div data-cmp-id="1"></div><div data-cmp-id="2"></div>' +
      '<div data-cmp-id="1" class="low"></div><div data-cmp-id="2"></div>';
    document.body.appendChild(body);
    body.querySelector('.low').__rect = { top: 450, bottom: 560, left: 0, right: 100, width: 100, height: 110 };
    const list = cm.columnNames(body).map(([, n]) => n);
    expect(list).toEqual(['vh-cmp-col-1-1', 'vh-cmp-col-2-1', 'vh-cmp-col-2-2']);
  });

  test('la mise à jour passe par une transition de classe vh-cmp-col', async () => {
    load();
    const calls = installVt();
    const body = document.createElement('div');
    body.__rect = { top: 0, bottom: 500, left: 0, right: 1000, width: 1000, height: 500 };
    body.innerHTML = '<div data-cmp-id="1"></div><div data-cmp-id="2"></div>';
    document.body.appendChild(body);
    const setProp = jest.spyOn(window.CSSStyleDeclaration.prototype, 'setProperty');
    await cm.columns({ body, update: () => body.firstChild.remove() });
    expect(calls[0].before.map(([, n]) => n)).toEqual(['vh-cmp-col-1-1', 'vh-cmp-col-2-1']);
    expect(calls[0].after.map(([, n]) => n)).toContain('vh-cmp-col-2-1');
    expect(setProp).toHaveBeenCalledWith('view-transition-class', 'vh-cmp-col');
  });
});

// ── Branchement dans compare.js ────────────────────────────────────────

const AIRCRAFT = {
  1: { id: 1, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg', max_speed: 1900 },
  2: { id: 2, name: 'F-22', image_url: '/assets/airplanes/f22.jpg', max_speed: 2400 },
  3: { id: 3, name: 'Sans photo', image_url: null },
};

function api() {
  return jest.fn((url) => {
    const [, , , rawId, sub] = url.split('/');
    if (sub) return Promise.resolve({ ok: true, json: () => Promise.resolve([]) });
    const a = AIRCRAFT[Number(rawId)];
    return Promise.resolve(a ? { ok: true, json: () => Promise.resolve(a) } : { ok: false });
  });
}

const bar = () => document.getElementById('compare-bar');
const dlg = () => document.getElementById('compare-modal');
const mbody = () => document.getElementById('compare-modal-body');
const thumbIds = () => Array.from(bar().querySelectorAll('[data-cmp-thumb]')).map((el) => el.dataset.cmpThumb);

describe('compare.js — vignettes de la barre', () => {
  test('une vignette par appareil retenu, prise sur la carte ; décochée, elle part', () => {
    load({ withStore: true });
    document.body.insertAdjacentHTML('afterbegin', CARD(12) + CARD(30, '/assets/logo/placeholder-airplane-fr.svg'));
    compare.init({ urlSync: false });
    compare.toggle(12);
    compare.toggle(30);
    expect(thumbIds()).toEqual(['12', '30']);
    const img12 = bar().querySelector('[data-cmp-thumb="12"] img');
    // URL déjà chargée par la carte (même origine), pour une vignette instantanée.
    expect(img12.getAttribute('src')).toBe('http://localhost/assets/airplanes/a12.jpg?v=4');
    // Image d'attente : icône, rien de mémorisé.
    expect(bar().querySelector('[data-cmp-thumb="30"] .fa-plane')).not.toBeNull();
    expect(JSON.parse(localStorage.getItem('vh_compare_thumbs'))).toEqual({ 12: '/assets/airplanes/a12.jpg' });
    expect(bar().querySelector('.cmp-thumbs').getAttribute('aria-hidden')).toBe('true');

    const kept = bar().querySelector('[data-cmp-thumb="30"]');
    compare.toggle(12);
    expect(thumbIds()).toEqual(['30']);
    // Vignette gardée : même élément, pas recréé.
    expect(bar().querySelector('[data-cmp-thumb="30"]')).toBe(kept);
    expect(JSON.parse(localStorage.getItem('vh_compare_thumbs'))).toEqual({});
  });

  test('stockage relu au chargement : chemins locaux seulement, vignettes réduites', () => {
    load({ withStore: true });
    localStorage.setItem('vh_compare_ids', '[1,2,3]');
    localStorage.setItem('vh_compare_thumbs', JSON.stringify({
      1: '/assets/airplanes/rafale.jpg?v=9', 2: 'https://evil.example/x.jpg', 3: '//evil.example/y.jpg', x: '/a.jpg',
    }));
    compare.init({ urlSync: false });
    expect(bar().querySelector('[data-cmp-thumb="1"] .thumb').getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
    expect(bar().querySelector('[data-cmp-thumb="2"] .fa-plane')).not.toBeNull();
    expect(bar().querySelector('[data-cmp-thumb="3"] .fa-plane')).not.toBeNull();
  });

  test('stockage des vignettes corrompu : icônes d\'attente', () => {
    load({ withStore: true });
    localStorage.setItem('vh_compare_ids', '[1]');
    localStorage.setItem('vh_compare_thumbs', '{oops');
    compare.init({ urlSync: false });
    expect(bar().querySelector('[data-cmp-thumb="1"] .fa-plane')).not.toBeNull();
  });

  test('sans module d\'image : icône d\'attente', () => {
    load({ withStore: true });
    delete window.VH.shared.picture;
    localStorage.setItem('vh_compare_ids', '[1]');
    localStorage.setItem('vh_compare_thumbs', JSON.stringify({ 1: '/assets/airplanes/rafale.jpg' }));
    compare.init({ urlSync: false });
    expect(bar().querySelector('[data-cmp-thumb="1"] .fa-plane')).not.toBeNull();
  });

  test('photo d\'une autre origine : chemin gardé, URL directe ignorée', () => {
    load({ withStore: true });
    document.body.insertAdjacentHTML('afterbegin', CARD(12));
    const img = document.querySelector('[data-morph-id="12"] img');
    Object.defineProperty(img, 'currentSrc', { value: 'https://cdn.example/a12.avif' });
    compare.init({ urlSync: false });
    compare.toggle(12);
    expect(bar().querySelector('[data-cmp-thumb="12"] .thumb').getAttribute('src')).toBe('/assets/airplanes/a12.jpg');
  });

  test('sur une fiche : la vignette vient du hero', () => {
    load({ withStore: true });
    window.history.replaceState(null, '', '/details/rafale-30');
    document.body.insertAdjacentHTML('afterbegin',
      '<section data-morph-self><div data-morph="photo"><img id="hero-image" src="/assets/airplanes/rafale.jpg?v=2"></div></section>');
    compare.init({ urlSync: false });
    compare.toggle(30);
    expect(bar().querySelector('[data-cmp-thumb="30"] img').getAttribute('src')).toBe('http://localhost/assets/airplanes/rafale.jpg?v=2');
    // Un autre appareil n'a pas de photo dans cette page.
    compare.toggle(31);
    expect(bar().querySelector('[data-cmp-thumb="31"] .fa-plane')).not.toBeNull();
  });

  test('l\'ouverture de la modale remplace les icônes par la photo des fiches chargées', async () => {
    load({ withStore: true });
    global.fetch = api();
    localStorage.setItem('vh_compare_ids', '[1,3]');
    compare.init({ urlSync: false });
    expect(bar().querySelectorAll('.fa-plane')).toHaveLength(2);
    await compare.open();
    expect(bar().querySelector('[data-cmp-thumb="1"] .thumb').getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
    expect(bar().querySelector('[data-cmp-thumb="3"] .fa-plane')).not.toBeNull();
    expect(JSON.parse(localStorage.getItem('vh_compare_thumbs'))).toEqual({ 1: '/assets/airplanes/rafale.jpg' });
    // Seconde ouverture : rien de neuf, rien de réécrit.
    const setItem = jest.spyOn(window.Storage.prototype, 'setItem');
    await compare.open();
    expect(setItem).not.toHaveBeenCalled();
  });
});

describe('compare.js — morphing carte → barre', () => {
  test('cocher une carte : sa photo vole jusqu\'à la vignette, puis les noms sont retirés', async () => {
    load({ withStore: true });
    document.body.insertAdjacentHTML('afterbegin', CARD(12));
    compare.init({ urlSync: false });
    const calls = installVt();
    const RealImage = window.Image;
    window.Image = function () { return { decode: () => Promise.resolve() }; };
    try {
      expect(compare.toggle(12)).toBe('added');
      await flush();
    } finally {
      window.Image = RealImage;
    }
    const photo = document.querySelector('[data-morph-id="12"] img');
    expect(calls).toHaveLength(1);
    expect(calls[0].before).toEqual([[photo, 'vh-cmp-12']]);
    const slot = bar().querySelector('[data-cmp-thumb="12"]');
    expect(new Map(calls[0].after)).toEqual(new Map([[slot, 'vh-cmp-12'], [photo, 'none']]));
    await calls[0].end();
    expect(names()).toEqual([]);

    // Décocher : la vignette revient à la carte.
    compare.toggle(12);
    await flush();
    expect(new Map(calls[1].before)).toEqual(new Map([[slot, 'vh-cmp-12'], [photo, 'none']]));
    expect(calls[1].after).toEqual([[photo, 'vh-cmp-12']]);
  });

  test('sans compare-morph chargé : la barre se redessine d\'un coup', () => {
    load({ withStore: true });
    delete window.VH.shared.compareMorph;
    installVt();
    compare.init({ urlSync: false });
    compare.toggle(4);
    expect(thumbIds()).toEqual(['4']);
    expect(document.startViewTransition).not.toHaveBeenCalled();
  });
});

describe('compare.js — morphing barre ↔ modale', () => {
  function openMorphed() {
    load({ withStore: true });
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.toggle(1);
    compare.toggle(2);
    const calls = installVt();
    const opening = compare.open();
    return { calls, opening };
  }

  test('ouverture : la barre devient la modale ; fermeture : la modale se replie dans la barre', async () => {
    const { calls, opening } = openMorphed();
    expect(dlg().classList.contains('is-morph')).toBe(true);
    // La mise à jour n'a pas encore eu lieu : modale fermée, nouvelle ouverture ignorée.
    expect(dlg().open).toBe(false);
    await compare.open();
    expect(calls).toHaveLength(1);
    await opening;
    expect(dlg().open).toBe(true);
    expect(calls[0].before).toEqual([[bar(), 'vh-cmp-panel']]);
    expect(new Map(calls[0].after)).toEqual(new Map([[bar(), 'none'], [dlg(), 'vh-cmp-panel']]));
    expect(mbody().querySelectorAll('.cmp-col-head')).toHaveLength(2);
    await calls[0].end();

    dlg().querySelector('.compare-modal-close').click();
    // Fermeture en cours : un second clic ne relance rien.
    dlg().querySelector('.compare-modal-close').click();
    await flush();
    expect(calls).toHaveLength(2);
    expect(dlg().open).toBe(false);
    expect(calls[1].before).toEqual([[dlg(), 'vh-cmp-panel']]);
    expect(new Map(calls[1].after)).toEqual(new Map([[dlg(), 'none'], [bar(), 'vh-cmp-panel']]));
  });

  test('toutes les fiches ont disparu pendant l\'ouverture : la modale se referme après', async () => {
    load({ withStore: true });
    global.fetch = jest.fn(() => Promise.resolve({ ok: false }));
    compare.init({ urlSync: false });
    compare.toggle(98);
    const calls = installVt();
    await compare.open();
    expect(calls).toHaveLength(1);
    expect(compare.getIds()).toEqual([]);
    // La barre s'en va : la modale se referme en fondu, pas en morphing.
    expect(dlg().open).toBe(true);
    expect(dlg().classList.contains('is-closing')).toBe(true);
  });

  test('barre absente de l\'écran (sélection vidée) : fermeture en fondu, sans morphing', async () => {
    const { calls, opening } = openMorphed();
    await opening;
    await calls[0].end();
    jest.useFakeTimers();
    compare.clear();
    expect(dlg().classList.contains('is-closing')).toBe(true);
    expect(calls).toHaveLength(1);
  });

  test('sans l\'API : ouverture classique, sans .is-morph', async () => {
    load({ withStore: true });
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.toggle(1);
    const opening = compare.open();
    expect(dlg().open).toBe(true);
    expect(dlg().classList.contains('is-morph')).toBe(false);
    await opening;
  });
});

describe('compare.js — retrait d\'une colonne en morphing', () => {
  test('les colonnes restantes glissent ; pas de fondu de recomposition', async () => {
    load({ withStore: true });
    compare.init({ urlSync: false });
    [1, 2].forEach((id) => compare.toggle(id));
    compare.renderModal(mbody(), [AIRCRAFT[1], AIRCRAFT[2]]);
    mbody().__rect = { top: 0, bottom: 5000, left: 0, right: 5000, width: 5000, height: 5000 };
    const calls = installVt();
    mbody().querySelector('.cmp-remove[data-remove="1"]').click();
    // Un second retrait pendant la transition est ignoré.
    mbody().querySelector('.cmp-remove[data-remove="2"]').click();
    expect(mbody().dataset.removing).toBe('true');
    await flush();
    expect(calls).toHaveLength(1);
    expect(compare.getIds()).toEqual([2]);
    expect(mbody().querySelectorAll('.cmp-col-head')).toHaveLength(1);
    expect(mbody().classList.contains('cmp-enter')).toBe(false);
    const before = calls[0].before.map(([, n]) => n);
    expect(before).toContain('vh-cmp-col-1-1');
    expect(before).toContain('vh-cmp-col-2-1');
    const after = calls[0].after.map(([, n]) => n);
    expect(after).toContain('vh-cmp-col-2-1');
    expect(after).not.toContain('vh-cmp-col-1-1');
    await calls[0].end();
    expect(names()).toEqual([]);
  });
});
