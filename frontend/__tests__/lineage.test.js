/**
 * Tests unitaires — frontend/js/details/lineage.js
 * Rendu de la chaîne de filiation sur la fiche.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { t: (key) => key };
window.VH = { details: { data: { slugify: (name) => String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-') } } };

const lineage = require('../js/details/lineage');

const CHAIN = [
  { id: 9, name: 'Mirage III', depth: -2, year: 1961 },
  { id: 68, name: 'Mirage 2000', depth: -1, year: 1984 },
  { id: 20, name: 'Rafale', depth: 0, year: 2001 },
];

beforeEach(() => {
  document.body.innerHTML = `
    <section class="content-section hidden" id="lineage-section">
      <ol class="lineage-chain" id="lineage-chain"></ol>
    </section>`;
});

describe('lineage.render', () => {
  test('rend un maillon par appareil, dans l\'ordre reçu', () => {
    lineage.render(CHAIN, 20);
    const nodes = document.querySelectorAll('#lineage-chain .lineage-node');
    expect(nodes).toHaveLength(3);
    expect(nodes[0].textContent).toContain('Mirage III');
    expect(nodes[2].textContent).toContain('Rafale');
  });

  test('affiche la section et marque l\'appareil courant', () => {
    lineage.render(CHAIN, 20);
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(false);
    const current = document.querySelectorAll('.lineage-node.is-current');
    expect(current).toHaveLength(1);
    expect(current[0].textContent).toContain('Rafale');
    // L'appareil courant n'est pas un lien vers lui-même
    expect(current[0].querySelector('a')).toBeNull();
    expect(current[0].querySelector('[aria-current="true"]')).not.toBeNull();
  });

  test('compare les ids en nombre (aircraftId arrive en chaîne depuis l\'URL)', () => {
    lineage.render(CHAIN, '68');
    expect(document.querySelector('.lineage-node.is-current').textContent).toContain('Mirage 2000');
  });

  test('les autres maillons pointent vers /details/<slug>-<id>', () => {
    lineage.render(CHAIN, 20);
    const links = [...document.querySelectorAll('.lineage-node a')].map(a => a.getAttribute('href'));
    expect(links).toEqual(['/details/mirage-iii-9', '/details/mirage-2000-68']);
  });

  test('une chaîne d\'un seul maillon laisse la section masquée', () => {
    lineage.render([{ id: 20, name: 'Rafale', depth: 0, year: 2001 }], 20);
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(true);
  });

  test('une réponse vide ou invalide laisse la section masquée', () => {
    lineage.render([], 20);
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(true);
    lineage.render(null, 20);
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(true);
  });

  test('une année absente n\'efface pas le maillon', () => {
    lineage.render([
      { id: 1, name: 'Sans date', depth: -1, year: null },
      { id: 2, name: 'Courant', depth: 0, year: 1980 },
    ], 2);
    const nodes = document.querySelectorAll('.lineage-node');
    expect(nodes).toHaveLength(2);
    expect(nodes[0].querySelector('.lineage-year').textContent).toBe('—');
  });

  test('échappe les noms', () => {
    lineage.render([
      { id: 1, name: '<img src=x onerror=alert(1)>', depth: -1, year: 1950 },
      { id: 2, name: 'Courant', depth: 0, year: 1980 },
    ], 2);
    expect(document.querySelector('#lineage-chain').innerHTML).not.toContain('<img');
  });

  // jsdom ne calcule aucune mise en page : dimensions et scrollLeft simulés.
  function fakeLayout(list, { scrollWidth, clientWidth }) {
    let scrollLeft = 0;
    Object.defineProperty(list, 'scrollWidth', { configurable: true, value: scrollWidth });
    Object.defineProperty(list, 'clientWidth', { configurable: true, value: clientWidth });
    Object.defineProperty(list, 'scrollLeft', {
      configurable: true, get: () => scrollLeft, set: (v) => { scrollLeft = v; },
    });
    const pos = (prop, value) => jest.spyOn(HTMLElement.prototype, prop, 'get')
      .mockImplementation(function () { return this.classList.contains('is-current') ? value : 0; });
    pos('offsetLeft', 700);
    pos('offsetWidth', 100);
  }
  afterEach(() => jest.restoreAllMocks());

  test('bande qui déborde : l\'appareil courant est centré (scrollLeft)', () => {
    const list = document.getElementById('lineage-chain');
    fakeLayout(list, { scrollWidth: 1000, clientWidth: 300 });
    lineage.render(CHAIN, 20);
    // 700 - (300 - 100) / 2
    expect(list.scrollLeft).toBe(600);
  });

  test('bande sans débordement : pas de défilement', () => {
    const list = document.getElementById('lineage-chain');
    fakeLayout(list, { scrollWidth: 300, clientWidth: 300 });
    lineage.render(CHAIN, 20);
    expect(list.scrollLeft).toBe(0);
  });
});

describe('lineage.load', () => {
  const flush = () => new Promise((r) => setTimeout(r, 0));
  const res = (body, ok = true) => Promise.resolve({ ok, status: ok ? 200 : 500, json: () => Promise.resolve(body) });

  test('interroge /api/airplanes/:id/lineage et rend la chaîne', async () => {
    global.auth = { fetchWithTimeout: jest.fn(() => res({ chain: CHAIN })) };
    await lineage.load({ aircraftId: '20' });
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/airplanes/20/lineage');
    expect(document.querySelectorAll('.lineage-node')).toHaveLength(3);
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(false);
  });

  test('réponse en erreur : section masquée, sans exception', async () => {
    document.getElementById('lineage-section').classList.remove('hidden');
    global.auth = { fetchWithTimeout: jest.fn(() => res({}, false)) };
    await expect(lineage.load({ aircraftId: '20' })).resolves.toBeUndefined();
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(true);
  });

  test('erreur réseau : section masquée', async () => {
    document.getElementById('lineage-section').classList.remove('hidden');
    global.auth = { fetchWithTimeout: jest.fn(() => Promise.reject(new Error('timeout'))) };
    await lineage.load({ aircraftId: '20' });
    await flush();
    expect(document.getElementById('lineage-section').classList.contains('hidden')).toBe(true);
  });

  test('page sans section de filiation : aucun appel réseau', async () => {
    document.body.innerHTML = '';
    global.auth = { fetchWithTimeout: jest.fn() };
    await lineage.load({ aircraftId: '20' });
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('render sans conteneur : ne lève pas', () => {
    document.body.innerHTML = '';
    expect(() => lineage.render(CHAIN, 20)).not.toThrow();
  });
});
