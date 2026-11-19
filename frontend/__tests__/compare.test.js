/**
 * Tests unitaires — frontend/js/shared/compare.js
 *
 * Le module tient le magasin d'ids du comparateur (localStorage + paramètre
 * d'URL `compare`) et construit la barre flottante. On teste ici le magasin et
 * l'assainissement des entrées, qui sont la partie sensible : ce sont eux qui
 * décident du contenu d'un lien partagé.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

global.i18n = { t: (key) => key };
global.showToast = jest.fn();

const { loadMotion } = require('./helpers/motion-env');
require('../js/shared/motion');
const compare = require('../js/shared/compare');

// jsdom ne charge aucune feuille : on déclare les durées de sortie du CSS.
const declareExits = () => loadMotion(['.compare-bar.is-leaving', '.cmp-col-head.is-removing']);

function resetPage(search = '') {
  document.body.innerHTML = '';
  localStorage.clear();
  declareExits();
  window.history.replaceState(null, '', '/hangar' + search);
  compare.clear();
}

describe('compare — magasin', () => {
  beforeEach(() => resetPage());

  test('toggle ajoute puis retire', () => {
    expect(compare.toggle(12)).toBe('added');
    expect(compare.getIds()).toEqual([12]);
    expect(compare.has(12)).toBe(true);

    expect(compare.toggle(12)).toBe('removed');
    expect(compare.getIds()).toEqual([]);
    expect(compare.has(12)).toBe(false);
  });

  test('refuse le 4e appareil sans toucher à la sélection', () => {
    [1, 2, 3].forEach(id => compare.toggle(id));
    expect(compare.isFull()).toBe(true);
    expect(compare.toggle(4)).toBe('full');
    expect(compare.getIds()).toEqual([1, 2, 3]);
  });

  test('persiste dans localStorage', () => {
    compare.toggle(7);
    expect(JSON.parse(localStorage.getItem('vh_compare_ids'))).toEqual([7]);
  });

  test('remove et clear', () => {
    [1, 2].forEach(id => compare.toggle(id));
    compare.remove(1);
    expect(compare.getIds()).toEqual([2]);
    compare.clear();
    expect(compare.getIds()).toEqual([]);
  });

  test('notifie les abonnés à chaque changement', () => {
    const seen = [];
    compare.onChange(ids => seen.push(ids.slice()));
    compare.toggle(3);
    compare.toggle(3);
    expect(seen).toContainEqual([3]);
    expect(seen[seen.length - 1]).toEqual([]);
  });
});

describe('compare — init et URL', () => {
  beforeEach(() => resetPage());

  test('les ids de l\'URL priment sur le stockage', () => {
    localStorage.setItem('vh_compare_ids', '[99]');
    window.history.replaceState(null, '', '/hangar?compare=4,5');
    const res = compare.init({ urlSync: true, autoOpen: false });
    expect(res.fromUrl).toBe(true);
    expect(compare.getIds()).toEqual([4, 5]);
  });

  test('sans ids dans l\'URL, on repart du stockage', () => {
    localStorage.setItem('vh_compare_ids', '[8]');
    window.history.replaceState(null, '', '/hangar');
    const res = compare.init({ urlSync: true, autoOpen: false });
    expect(res.fromUrl).toBe(false);
    expect(compare.getIds()).toEqual([8]);
  });

  test('écrit la sélection dans l\'URL sans effacer les filtres', () => {
    window.history.replaceState(null, '', '/hangar?country=France&gen=4');
    compare.init({ urlSync: true, autoOpen: false });
    compare.toggle(21);
    expect(window.location.search).toContain('country=France');
    expect(window.location.search).toContain('gen=4');
    expect(window.location.search).toContain('compare=21');
    // Virgules laissées lisibles pour un lien destiné au copier-coller
    compare.toggle(22);
    expect(window.location.search).toContain('compare=21,22');
  });

  test('retire le paramètre quand la sélection se vide', () => {
    window.history.replaceState(null, '', '/hangar?compare=1');
    compare.init({ urlSync: true, autoOpen: false });
    compare.clear();
    expect(window.location.search).not.toContain('compare');
  });

  test('sans urlSync, l\'URL n\'est pas touchée (cas de la fiche)', () => {
    window.history.replaceState(null, '', '/details/rafale-20');
    compare.init({ urlSync: false });
    compare.toggle(20);
    expect(window.location.search).toBe('');
  });

  test('ignore les ids illisibles et tronque au maximum', () => {
    window.history.replaceState(null, '', '/hangar?compare=3,abc,-1,0,3,4,5,6');
    compare.init({ urlSync: true, autoOpen: false });
    expect(compare.getIds()).toEqual([3, 4, 5]);
  });
});

describe('compare — barre flottante', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    resetPage();
  });
  afterEach(() => jest.useRealTimers());

  test('la barre apparaît à la première sélection et sort en animation une fois vide', () => {
    compare.init({ urlSync: false });
    const bar = document.getElementById('compare-bar');
    expect(bar).not.toBeNull();
    expect(bar.classList.contains('hidden')).toBe(true);
    // Plus de style en ligne : la CSP interdit les attributs style.
    expect(bar.getAttribute('style') || '').not.toContain('display');

    compare.toggle(5);
    expect(bar.classList.contains('hidden')).toBe(false);

    compare.clear();
    // Animation de sortie d'abord, retrait du rendu ensuite.
    expect(bar.classList.contains('is-leaving')).toBe(true);
    expect(bar.classList.contains('hidden')).toBe(false);
    jest.advanceTimersByTime(250);
    expect(bar.classList.contains('is-leaving')).toBe(false);
    expect(bar.classList.contains('hidden')).toBe(true);
  });

  test('une nouvelle sélection pendant la sortie annule le masquage', () => {
    compare.init({ urlSync: false });
    const bar = document.getElementById('compare-bar');
    compare.toggle(5);
    compare.clear();
    compare.toggle(6);
    jest.advanceTimersByTime(250);
    expect(bar.classList.contains('hidden')).toBe(false);
    expect(bar.classList.contains('is-leaving')).toBe(false);
  });

  test('le compteur fait défiler le nombre sans toucher au libellé', () => {
    compare.init({ urlSync: false });
    const cnt = document.getElementById('compare-count');
    compare.toggle(1);
    const num = cnt.querySelector('.cmp-count-num');
    expect(num.querySelector('.sr-only').textContent).toBe('1');
    const post = cnt.querySelector('.cmp-count-post');
    const col = num.querySelector('.t-roll-col');
    compare.toggle(2);
    // Même colonne, même libellé : la bande glisse au lieu d'être recréée.
    expect(num.querySelector('.t-roll-col')).toBe(col);
    expect(col.dataset.d).toBe('2');
    expect(cnt.querySelector('.cmp-count-post')).toBe(post);
    expect(cnt.classList.contains('is-bumped')).toBe(false);
  });

  test('« Effacer » demande confirmation sur place avant de vider', () => {
    compare.init({ urlSync: false });
    [1, 2, 3].forEach(id => compare.toggle(id));
    const trigger = document.getElementById('compare-clear');
    const wrap = trigger.closest('.cfm');
    expect(wrap.classList.contains('cmp-clear')).toBe(true);
    trigger.click();
    expect(wrap.dataset.state).toBe('confirm');
    expect(compare.getIds()).toEqual([1, 2, 3]);
    wrap.querySelector('.cfm-no').click();
    expect(wrap.dataset.state).toBe('idle');
    expect(compare.getIds()).toEqual([1, 2, 3]);

    trigger.click();
    wrap.querySelector('.cfm-yes').click();
    expect(compare.getIds()).toEqual([]);
    // Remis au repos : la barre réutilisée peut redemander confirmation.
    expect(wrap.dataset.state).toBe('idle');
  });

  test('« Effacer » porte la poubelle partagée, panneau à droite', () => {
    compare.init({ urlSync: false });
    compare.toggle(4);
    const trigger = document.getElementById('compare-clear');
    expect(trigger.querySelector('svg.cfm-bin .cfm-bin-lid')).not.toBeNull();
    expect(trigger.textContent).toBe('Effacer');
    const wrap = trigger.closest('.cfm');
    expect(wrap.dataset.side).toBe('right');
    expect(wrap.classList.contains('cfm-morph')).toBe(false);
  });

  test('« Effacer ? » ouvert puis sélection vidée ailleurs : le panneau revient au repos', () => {
    compare.init({ urlSync: false });
    compare.toggle(4);
    const trigger = document.getElementById('compare-clear');
    const wrap = trigger.closest('.cfm');
    trigger.click();
    expect(wrap.dataset.state).toBe('confirm');
    compare.toggle(4); // dernière case décochée depuis une carte
    expect(compare.getIds()).toEqual([]);
    expect(wrap.dataset.state).toBe('idle');
    compare.toggle(5);
    expect(wrap.dataset.state).toBe('idle'); // la barre revient fermée
  });

  test('« Copier le lien » affiche une confirmation puis revient à son libellé', async () => {
    const writeText = jest.fn(() => Promise.resolve());
    Object.defineProperty(navigator, 'clipboard', { value: { writeText }, configurable: true });
    compare.init({ urlSync: false });
    compare.toggle(9);
    const btn = document.getElementById('compare-share');

    compare.shareLink();
    await Promise.resolve();
    await Promise.resolve();
    expect(writeText).toHaveBeenCalledWith(expect.stringContaining('/hangar?compare=9'));
    expect(btn.classList.contains('is-copied')).toBe(true);
    // Maillon et coche sont deux tracés du même SVG, permutés par .is-copied.
    expect(btn.querySelector('svg.cmp-share-ico .cmp-link')).not.toBeNull();
    expect(btn.querySelector('svg.cmp-share-ico .cmp-check')).not.toBeNull();
    expect(btn.querySelector('.cmp-share-label').textContent).toBe('Lien copié');

    jest.advanceTimersByTime(2000);
    expect(btn.classList.contains('is-copied')).toBe(false);
    expect(btn.querySelector('.cmp-share-label').textContent).toBe('Copier le lien');
  });
});

describe('compare — retrait d\'une colonne', () => {
  const items = [
    { id: 1, name: 'Rafale', max_speed: 1900 },
    { id: 2, name: 'Typhoon', max_speed: 2100 },
    { id: 3, name: 'Gripen', max_speed: 2200 },
  ];

  beforeEach(() => {
    jest.useFakeTimers();
    resetPage();
    global.fetch = jest.fn();
  });
  afterEach(() => {
    jest.useRealTimers();
    delete global.fetch;
  });

  test('recompose la grille sur les données chargées, sans nouvelle requête', () => {
    compare.init({ urlSync: false });
    [1, 2, 3].forEach(id => compare.toggle(id));
    const body = document.getElementById('compare-modal-body');
    compare.renderModal(body, items);
    expect(body.querySelectorAll('.cmp-col-head')).toHaveLength(3);

    body.querySelector('.cmp-remove[data-remove="2"]').click();
    // La colonne s'efface d'abord : en-tête et toutes ses cellules.
    const leaving = body.querySelectorAll('[data-cmp-id="2"]');
    expect(leaving.length).toBeGreaterThan(1);
    leaving.forEach(el => expect(el.classList.contains('is-removing')).toBe(true));
    // Un second clic pendant l'animation est ignoré.
    body.querySelector('.cmp-remove[data-remove="1"]').click();

    jest.advanceTimersByTime(300);
    expect(compare.getIds()).toEqual([1, 3]);
    const heads = body.querySelectorAll('.cmp-col-head');
    expect(Array.from(heads).map(h => h.dataset.cmpId)).toEqual(['1', '3']);
    expect(body.querySelector('.cmp-row').dataset.cmpCols).toBe('2');
    expect(body.querySelector('.cmp-loading')).toBeNull();
    expect(global.fetch).not.toHaveBeenCalled();
  });
});
