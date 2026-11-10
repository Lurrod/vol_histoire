/**
 * Tests — frontend/js/hangar/compare.js, branché sur le vrai magasin
 * js/shared/compare.js.
 *
 * Les cases « Comparer » des cartes reflètent la sélection (au rendu, après
 * un nouveau rendu de page, après un changement venu d'ailleurs), cocher
 * ajoute à ?compare=, la 4e case est refusée avec un avertissement.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

let store;
let state;

function card(id, withCheck = true) {
  const check = withCheck
    ? `<label class="compare-check"><input type="checkbox" data-compare-id="${id}" aria-label="Comparer A${id}"><span>Comparer</span></label>`
    : '';
  return `<article class="aircraft-card" data-id="${id}"><h3><a href="/details/a-${id}">A${id}</a></h3>${check}</article>`;
}

function boot(search = '', cardsHtml = card(1) + card(2)) {
  jest.resetModules();
  window.history.replaceState(null, '', `/hangar${search}`);
  document.body.innerHTML = `<div id="airplanes-container">${cardsHtml}</div>`;
  global.i18n = { t: (k) => ({ 'hangar.compare_label': 'Comparer', 'hangar.compare_max': 'Trois au plus' }[k] || k) };
  global.showToast = jest.fn();
  window.VH = { shared: {}, hangar: {} };
  store = require('../js/shared/compare');
  require('../js/hangar/compare');
  state = { compareIds: [] };
  window.VH.hangar.compare.init(state);
}

const box = (id) => document.querySelector(`[data-compare-id="${id}"]`);
function check(id) {
  const cb = box(id);
  cb.checked = !cb.checked;
  cb.dispatchEvent(new Event('change', { bubbles: true }));
  return cb;
}
const flush = () => new Promise(r => setTimeout(r, 0));

// jsdom n'implémente pas showModal()/close() : un lien ?compare= ouvre la
// modale dès l'init, on simule donc le comportement du navigateur.
const proto = window.HTMLDialogElement.prototype;
const native = { showModal: proto.showModal, close: proto.close };

beforeEach(() => {
  localStorage.clear();
  proto.showModal = function () { this.setAttribute('open', ''); };
  proto.close = function () { this.removeAttribute('open'); };
  global.fetch = jest.fn((url) => {
    const id = Number(url.split('/')[3]);
    return Promise.resolve({ ok: true, json: () => Promise.resolve(url.endsWith(String(id)) ? { id, name: 'A' + id } : []) });
  });
});

afterEach(() => {
  proto.showModal = native.showModal;
  proto.close = native.close;
  delete global.fetch;
});

describe('cases du comparateur sur les cartes du hangar', () => {
  test('init synchronise l\'URL et relit une sélection reçue par lien', () => {
    boot('?compare=2&country=France');
    expect(state.compareIds).toEqual([2]);
    // Un lien partagé ouvre directement la comparaison
    expect(document.getElementById('compare-modal').open).toBe(true);
    expect(box(2).checked).toBe(true);
    expect(box(1).checked).toBe(false);
  });

  test('cocher ajoute à la sélection et à ?compare= sans effacer les filtres', () => {
    boot('?country=France');
    const cb = check(1);
    expect(cb.checked).toBe(true);
    expect(store.getIds()).toEqual([1]);
    expect(state.compareIds).toEqual([1]);
    const p = new window.URLSearchParams(window.location.search);
    expect(p.get('compare')).toBe('1');
    expect(p.get('country')).toBe('France');
  });

  test('décocher retire de la sélection et de l\'URL', () => {
    boot('?compare=1');
    const cb = check(1);
    expect(cb.checked).toBe(false);
    expect(store.getIds()).toEqual([]);
    expect(window.location.search).not.toContain('compare');
  });

  test('4e appareil : case décochée et avertissement', () => {
    boot('?compare=7,8,9', card(1));
    const cb = check(1);
    expect(cb.checked).toBe(false);
    expect(store.getIds()).toEqual([7, 8, 9]);
    expect(showToast).toHaveBeenCalledWith('Trois au plus', 'warning');
  });

  test('4e appareil sans showToast disponible : refus silencieux, pas d\'erreur', () => {
    boot('?compare=7,8,9', card(1));
    delete global.showToast;
    expect(() => check(1)).not.toThrow();
    expect(box(1).checked).toBe(false);
  });

  test('un changement hors des cases (barre « Effacer ») décoche les cases visibles', () => {
    boot('?compare=1,2');
    store.clear();
    expect(box(1).checked).toBe(false);
    expect(box(2).checked).toBe(false);
    expect(state.compareIds).toEqual([]);
  });

  test('un changement sans rapport avec une case est ignoré', () => {
    boot();
    const input = document.createElement('input');
    document.getElementById('airplanes-container').appendChild(input);
    input.dispatchEvent(new Event('change', { bubbles: true }));
    expect(store.getIds()).toEqual([]);
  });

  test('carte rendue sans case (ancien gabarit) : la case est ajoutée, échappée et cochée selon la sélection', () => {
    global.i18n = { t: () => '<b>x</b>' };
    boot('?compare=3', card(3, false));
    const label = document.querySelector('.aircraft-card[data-id="3"] .compare-check');
    expect(label).not.toBeNull();
    expect(label.querySelector('b')).toBeNull();
    expect(box(3).checked).toBe(true);
    // Le clic sur la case ne remonte pas jusqu'à la carte
    const onCard = jest.fn();
    document.querySelector('.aircraft-card').addEventListener('click', onCard);
    label.click();
    expect(onCard).not.toHaveBeenCalled();
  });

  test('nouvelle page de résultats : les cases rendues sont recochées d\'après la sélection', async () => {
    boot('?compare=5');
    document.getElementById('airplanes-container').innerHTML = card(5) + card(6, false);
    await flush();
    expect(box(5).checked).toBe(true);
    expect(box(6)).not.toBeNull();
    expect(box(6).checked).toBe(false);
  });

  test('page sans conteneur de cartes : rien n\'est initialisé', () => {
    jest.resetModules();
    document.body.innerHTML = '';
    const init = jest.fn();
    window.VH = { shared: { compare: { init } }, hangar: {} };
    require('../js/hangar/compare');
    window.VH.hangar.compare.init({});
    expect(init).not.toHaveBeenCalled();
  });
});
