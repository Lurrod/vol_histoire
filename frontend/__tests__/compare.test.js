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

const compare = require('../js/shared/compare');

function resetPage(search = '') {
  document.body.innerHTML = '';
  localStorage.clear();
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
  beforeEach(() => resetPage());

  test('la barre apparaît à la première sélection et disparaît une fois vide', () => {
    compare.init({ urlSync: false });
    const bar = document.getElementById('compare-bar');
    expect(bar).not.toBeNull();
    expect(bar.classList.contains('hidden')).toBe(true);

    compare.toggle(5);
    expect(bar.classList.contains('hidden')).toBe(false);

    compare.clear();
    expect(bar.classList.contains('hidden')).toBe(true);
  });
});
