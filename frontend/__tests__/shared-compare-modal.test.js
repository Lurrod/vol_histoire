/**
 * Tests DOM — frontend/js/shared/compare.js : modale, barre et cas limites
 * (suite de compare.test.js, qui couvre le magasin et l'URL).
 *
 * Chargement des fiches à l'ouverture (purge des ids disparus), rendu de la
 * grille (meilleure valeur, barres, années, étiquettes échappées), erreurs,
 * partage sans presse-papiers, bandeau de consentement, mouvements réduits.
 *
 * jsdom n'implémente pas showModal()/close() : on les simule par l'attribut
 * `open`, comme le navigateur.
 */

const proto = window.HTMLDialogElement.prototype;
const native = { showModal: proto.showModal, close: proto.close };

let compare;
let reduced;

const AIRCRAFT = {
  1: {
    id: 1, name: 'Rafale', complete_name: 'Dassault Rafale', country_name: 'France', generation: 4,
    type_name: 'Chasseur', manufacturer_name: 'Dassault', status: 'En service',
    date_concept: '1983-01-01', date_first_fly: '1986-07-04', date_operationel: '2001-12-04',
    max_speed: 1912, max_range: 3700, empty_weight: 10300, image_url: '/assets/airplanes/rafale.jpg',
  },
  2: {
    id: 2, name: '<img src=x onerror=alert(1)>', country_name: null, generation: null,
    max_speed: 2400, max_range: null, empty_weight: 12000, date_operational: '1976-01-09',
  },
};
const ARM = { 1: [{ name: 'MICA <IR>' }, { name: 'Meteor' }], 2: [] };
const TECH = { 1: [{ name: 'RBE2' }], 2: null };

function api({ missing = [], fail = false, subFail = false } = {}) {
  return jest.fn((url) => {
    if (fail) return Promise.reject(new Error('offline'));
    const [, , , rawId, sub] = url.split('/');
    const id = Number(rawId);
    if (sub) {
      if (subFail) return Promise.reject(new Error('x'));
      const body = (sub === 'armament' ? ARM : TECH)[id];
      return Promise.resolve({ ok: true, json: () => Promise.resolve(body || []) });
    }
    if (missing.includes(id) || !AIRCRAFT[id]) return Promise.resolve({ ok: false, status: 404 });
    return Promise.resolve({ ok: true, json: () => Promise.resolve(AIRCRAFT[id]) });
  });
}

function load({ withI18n = true, search = '' } = {}) {
  jest.resetModules();
  window.history.replaceState(null, '', `/hangar${search}`);
  document.body.innerHTML = '';
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  if (withI18n) global.i18n = { t: (k, p) => (k === 'hangar.compare_selected_many' ? `${p.n} sélectionnés` : k) };
  else delete global.i18n;
  global.showToast = jest.fn();
  window.VH = { shared: { picture: { pictureHtml: (src, o) => `<img class="pic" src="${src}" alt="${o.alt}">` } } };
  compare = require('../js/shared/compare');
}

const flush = async () => { for (let i = 0; i < 6; i++) await Promise.resolve(); };
const dlg = () => document.getElementById('compare-modal');
const body = () => document.getElementById('compare-modal-body');

beforeEach(() => {
  localStorage.clear();
  reduced = false;
  window.matchMedia = jest.fn((q) => ({ matches: q.includes('reduced-motion') ? reduced : false }));
  proto.showModal = function () { this.setAttribute('open', ''); };
  proto.close = function () { this.removeAttribute('open'); };
});

afterEach(() => {
  jest.useRealTimers();
  proto.showModal = native.showModal;
  proto.close = native.close;
  delete global.fetch;
});

describe('ouverture de la modale', () => {
  test('charge chaque fiche avec armement et technologies, puis rend la grille', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.toggle(1);
    compare.toggle(2);
    const opening = compare.open();
    // Indicateur de chargement immédiat, modale ouverte
    expect(dlg().open).toBe(true);
    expect(body().querySelector('.cmp-loading')).not.toBeNull();
    await opening;

    expect(fetch).toHaveBeenCalledWith('/api/airplanes/1');
    expect(fetch).toHaveBeenCalledWith('/api/airplanes/1/armament');
    expect(fetch).toHaveBeenCalledWith('/api/airplanes/2/tech');
    const heads = body().querySelectorAll('.cmp-col-head');
    expect(Array.from(heads).map(h => h.dataset.cmpId)).toEqual(['1', '2']);
    expect(document.querySelector('#compare-modal-title span').textContent).toBe('Comparaison — 2');
    // i18n renvoie la clé : le module affiche alors son libellé de repli
    expect(body().querySelector('.cmp-summary-count').textContent).toBe('2 appareils');
  });

  test('les données de l\'API sont échappées (nom, étiquettes)', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    await compare.open();
    expect(body().querySelector('img:not(.pic)')).toBeNull();
    const titles = Array.from(body().querySelectorAll('.cmp-col-title h3')).map(h => h.textContent);
    expect(titles).toEqual(['Rafale', '<img src=x onerror=alert(1)>']);
    const tags = Array.from(body().querySelectorAll('.cmp-tag')).map(t => t.textContent);
    expect(tags).toEqual(['MICA <IR>', 'Meteor', 'RBE2']);
  });

  test('meilleure valeur surlignée : vitesse la plus haute, poids le plus bas ; barres dimensionnées sans attribut style', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    await compare.open();

    const rows = body().querySelectorAll('.cmp-cell-perf');
    // Ordre : vitesse (1, 2), portée (1, 2), poids (1, 2)
    const best = Array.from(rows).map(c => c.classList.contains('cmp-best'));
    expect(best).toEqual([false, true, true, false, true, false]);
    const fill = rows[1].querySelector('.cmp-bar-fill');
    expect(fill.dataset.pct).toBe('100');
    expect(fill.style.width).toBe('100%');
    expect(rows[0].querySelector('.cmp-bar-fill').style.width).toBe('80%');
    // Valeur absente : tiret
    expect(rows[3].querySelector('.cmp-dash')).not.toBeNull();
    expect(body().querySelector('.cmp-row').style.getPropertyValue('--cmp-cols')).toBe('2');
    expect(rows[0].textContent).toContain('km/h');
  });

  // Régression (shared/compare.js) : Number(null) vaut 0, pas NaN. Une valeur
  // ABSENTE était comptée comme 0 : surlignée « meilleure » sur le poids à
  // vide (le plus bas gagne), barre à 0 % ailleurs.
  test('une valeur absente n’est jamais désignée meilleure ni dessinée', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.renderModal(body(), [AIRCRAFT[1], { ...AIRCRAFT[2], empty_weight: null, max_speed: '' }]);
    const cells = Array.from(body().querySelectorAll('.cmp-cell-perf'));
    const weight = cells.slice(4);
    expect(weight[1].classList.contains('cmp-best')).toBe(false);
    expect(weight[0].classList.contains('cmp-best')).toBe(true);
    expect(weight[1].querySelector('.cmp-bar-fill')).toBeNull();
    expect(weight[1].querySelector('.cmp-dash').textContent).toBe('—');
    // Chaîne vide : même traitement qu'une valeur nulle
    expect(cells[1].querySelector('.cmp-bar-fill')).toBeNull();
    expect(cells[1].querySelector('.cmp-dash')).not.toBeNull();
    expect(cells[0].classList.contains('cmp-best')).toBe(true);
  });

  test('années, puces et repli sur date_operational ; valeurs manquantes en tiret', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    await compare.open();
    const text = body().textContent;
    expect(text).toContain('1983');
    expect(text).toContain('1986');
    expect(text).toContain('2001');
    expect(text).toContain('1976');
    const head1 = body().querySelector('.cmp-col-head[data-cmp-id="1"]');
    expect(head1.querySelector('.cmp-img-wrap .pic').getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
    expect(head1.textContent).toContain('Gen 4');
    expect(head1.textContent).toContain('Dassault Rafale');
    const head2 = body().querySelector('.cmp-col-head[data-cmp-id="2"]');
    expect(head2.querySelector('.cmp-img-placeholder')).not.toBeNull();
    expect(head2.querySelectorAll('.cmp-chip')).toHaveLength(0);
    // Armement vide et technologies nulles : tiret
    const tagCells = body().querySelectorAll('.cmp-row-tags .cmp-cell[data-cmp-id="2"]');
    tagCells.forEach(c => expect(c.querySelector('.cmp-dash')).not.toBeNull());
  });

  test('une fiche supprimée depuis le partage du lien est purgée de la sélection et de l\'URL', async () => {
    load({ search: '?compare=1,99' });
    global.fetch = api();
    compare.init({ urlSync: true, autoOpen: false });
    await compare.open();
    expect(compare.getIds()).toEqual([1]);
    expect(new window.URLSearchParams(window.location.search).get('compare')).toBe('1');
    expect(body().querySelectorAll('.cmp-col-head')).toHaveLength(1);
    expect(body().querySelector('.cmp-summary-count').textContent).toBe('1 appareil');
  });

  test('toutes les fiches ont disparu : la modale se referme', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.toggle(98);
    await compare.open();
    expect(compare.getIds()).toEqual([]);
    expect(dlg().open).toBe(false);
  });

  test('armement ou technologies indisponibles : la comparaison s\'affiche quand même', async () => {
    load();
    global.fetch = api({ subFail: true });
    compare.init({ urlSync: false });
    compare.toggle(1);
    await compare.open();
    expect(body().querySelectorAll('.cmp-col-head')).toHaveLength(1);
    expect(body().querySelectorAll('.cmp-tag')).toHaveLength(0);
  });

  test('réseau coupé : message d\'erreur traduit dans la modale', async () => {
    load();
    global.fetch = api({ fail: true });
    compare.init({ urlSync: false });
    compare.toggle(1);
    await compare.open();
    expect(body().querySelector('.cmp-error').textContent.trim()).toBe('Erreur de chargement');
    expect(compare.getIds()).toEqual([1]);
  });

  test('sélection vide : rien ne s\'ouvre', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    await compare.open();
    expect(dlg().open).toBe(false);
    expect(fetch).not.toHaveBeenCalled();
  });

  test('un lien ?compare= ouvre la modale dès l\'init (sauf autoOpen: false)', async () => {
    load({ search: '?compare=1' });
    global.fetch = api();
    const res = compare.init({ urlSync: true });
    expect(res.fromUrl).toBe(true);
    expect(dlg().open).toBe(true);
    await flush();
  });

  test('boutons de la barre et de la modale : « Comparer », « Effacer », fermeture', async () => {
    load();
    global.fetch = api();
    compare.init({ urlSync: false });
    compare.toggle(1);
    document.getElementById('compare-view').click();
    expect(dlg().open).toBe(true);
    await flush();
    dlg().querySelector('.compare-modal-close').click();
    expect(dlg().open).toBe(false);
    expect(dlg().querySelector('.compare-modal-close').getAttribute('aria-label')).toBe('Fermer');

    document.getElementById('compare-view').click();
    await flush();
    document.getElementById('compare-clear').click();
    expect(compare.getIds()).toEqual([]);
    // Sélection vidée : la modale ouverte se referme
    expect(dlg().open).toBe(false);
  });

  test('ensureUi est idempotent', () => {
    load();
    compare.ensureUi();
    compare.ensureUi();
    expect(document.querySelectorAll('#compare-bar')).toHaveLength(1);
    expect(document.querySelectorAll('#compare-modal')).toHaveLength(1);
    expect(dlg().getAttribute('aria-labelledby')).toBe('compare-modal-title');
  });
});

describe('retrait d\'une colonne — cas limites', () => {
  test('mouvements réduits : retrait immédiat, sans attente', () => {
    load();
    reduced = true;
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    compare.renderModal(body(), [AIRCRAFT[1], AIRCRAFT[2]]);
    body().querySelector('.cmp-remove[data-remove="1"]').click();
    expect(compare.getIds()).toEqual([2]);
    expect(body().querySelectorAll('.cmp-col-head')).toHaveLength(1);
    expect(body().classList.contains('cmp-enter')).toBe(true);
    expect(body().dataset.removing).toBeUndefined();
  });

  test('sélection vidée pendant l\'animation : pas de nouvelle grille', () => {
    jest.useFakeTimers();
    load();
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    compare.renderModal(body(), [AIRCRAFT[1], AIRCRAFT[2]]);
    body().querySelector('.cmp-remove[data-remove="1"]').click();
    expect(body().querySelectorAll('.cmp-remove:disabled')).toHaveLength(2);
    compare.clear();
    jest.advanceTimersByTime(300);
    expect(compare.getIds()).toEqual([]);
    expect(body().classList.contains('cmp-enter')).toBe(false);
  });
});

describe('barre flottante — cas limites', () => {
  test('mouvements réduits : la barre disparaît sans animation', () => {
    load();
    reduced = true;
    compare.init({ urlSync: false });
    compare.toggle(1);
    compare.clear();
    const bar = document.getElementById('compare-bar');
    expect(bar.classList.contains('hidden')).toBe(true);
    expect(bar.classList.contains('is-leaving')).toBe(false);
  });

  test('matchMedia en erreur : on retombe sur l\'animation', () => {
    jest.useFakeTimers();
    load();
    window.matchMedia = () => { throw new Error('x'); };
    compare.init({ urlSync: false });
    compare.toggle(1);
    compare.clear();
    expect(document.getElementById('compare-bar').classList.contains('is-leaving')).toBe(true);
  });

  test('compteur au pluriel traduit', () => {
    load();
    compare.init({ urlSync: false });
    [1, 2].forEach(id => compare.toggle(id));
    expect(document.getElementById('compare-count').textContent).toBe('2 sélectionnés');
  });

  test('sans i18n : libellés de repli lisibles, jamais de clé brute', () => {
    load({ withI18n: false });
    compare.init({ urlSync: false });
    compare.toggle(1);
    expect(document.getElementById('compare-view').textContent).toBe('Comparer');
    expect(document.getElementById('compare-share').textContent).toBe('Copier le lien');
    expect(document.getElementById('compare-count').textContent).toBe('1 ✓');
  });

  test('traduction manquante (clé renvoyée) : repli lisible', () => {
    load();
    global.i18n = { t: (k) => k };
    compare.ensureUi();
    expect(document.getElementById('compare-clear').textContent).toBe('Effacer');
  });

  test('bandeau de consentement affiché : la barre remonte au-dessus de lui, puis redescend', async () => {
    load();
    document.body.innerHTML = '<div class="cookie-banner show"></div>';
    const banner = document.querySelector('.cookie-banner');
    banner.getBoundingClientRect = () => ({ height: 134 });
    compare.init({ urlSync: false });
    compare.toggle(1);
    const bar = document.getElementById('compare-bar');
    expect(bar.style.bottom).toBe('158px');

    banner.classList.remove('show');
    await flush();
    expect(bar.style.bottom).toBe('');
  });
});

describe('magasin — entrées hostiles', () => {
  test('stockage corrompu : sélection vide', () => {
    load();
    localStorage.setItem('vh_compare_ids', '{oops');
    compare.init({ urlSync: false });
    expect(compare.getIds()).toEqual([]);
  });

  test('stockage indisponible (mode privé) : la sélection marche en mémoire', () => {
    load();
    const spy = jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('quota'); });
    compare.init({ urlSync: false });
    expect(compare.toggle(3)).toBe('added');
    expect(compare.getIds()).toEqual([3]);
    spy.mockRestore();
  });

  test('replaceState en erreur : la sélection change quand même', () => {
    load();
    compare.init({ urlSync: true, autoOpen: false });
    const spy = jest.spyOn(window.history, 'replaceState').mockImplementation(() => { throw new Error('x'); });
    expect(compare.toggle(4)).toBe('added');
    spy.mockRestore();
  });

  test('id non entier refusé ; retirer un id absent ne notifie personne', () => {
    load();
    compare.init({ urlSync: false });
    const fn = jest.fn();
    compare.onChange(fn);
    compare.onChange('pas une fonction');
    expect(compare.toggle('abc')).toBe('full');
    compare.remove(42);
    expect(fn).not.toHaveBeenCalled();
  });

  test('un abonné qui lève une erreur n\'empêche pas les autres d\'être notifiés', () => {
    load();
    compare.init({ urlSync: false });
    const after = jest.fn();
    compare.onChange(() => { throw new Error('boom'); });
    compare.onChange(after);
    compare.toggle(5);
    expect(after).toHaveBeenCalledWith([5]);
  });
});

describe('partage du lien', () => {
  afterEach(() => { delete navigator.clipboard; });

  test('sélection vide : rien n\'est copié', () => {
    load();
    const writeText = jest.fn(() => Promise.resolve());
    Object.defineProperty(navigator, 'clipboard', { value: { writeText }, configurable: true });
    compare.init({ urlSync: false });
    compare.shareLink();
    expect(writeText).not.toHaveBeenCalled();
  });

  test('presse-papiers refusé : l\'URL est montrée dans un toast', async () => {
    load();
    Object.defineProperty(navigator, 'clipboard', { value: { writeText: () => Promise.reject(new Error('denied')) }, configurable: true });
    compare.init({ urlSync: false });
    compare.toggle(9);
    compare.toggle(4);
    compare.shareLink();
    await flush();
    expect(showToast).toHaveBeenCalledWith(expect.stringMatching(/\/hangar\?compare=9,4$/), 'info');
  });

  test('pas d\'API presse-papiers : l\'URL est montrée dans un toast', () => {
    load();
    Object.defineProperty(navigator, 'clipboard', { value: undefined, configurable: true });
    compare.init({ urlSync: false });
    compare.toggle(9);
    document.getElementById('compare-share').click();
    expect(showToast).toHaveBeenCalledWith(expect.stringContaining('/hangar?compare=9'), 'info');
  });

  test('copie réussie : toast de succès', async () => {
    load();
    Object.defineProperty(navigator, 'clipboard', { value: { writeText: () => Promise.resolve() }, configurable: true });
    compare.init({ urlSync: false });
    compare.toggle(9);
    compare.shareLink();
    await flush();
    expect(showToast).toHaveBeenCalledWith('Lien copié', 'success');
  });
});
