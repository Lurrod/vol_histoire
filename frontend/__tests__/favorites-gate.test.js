/**
 * Tests — frontend/js/favorites/gate.js : page Favoris sans session.
 *
 * Le panneau de gauche montre un aperçu de collection : trois vraies fiches
 * du catalogue, tirées au hasard parmi celles qui ont une photo. En cas
 * d'échec du réseau, les trois cadres restent (cœur seul), sans erreur.
 */
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
window.VH = {};
require('../js/shared/picture');
const gate = require('../js/favorites/gate');

const PLANES = [
  { id: 1, name: 'Rafale', country_name: 'France', image_url: '/assets/airplanes/rafale.jpg' },
  { id: 2, name: 'F-22 Raptor', country_name: 'États-Unis', image_url: '/assets/airplanes/f22.jpg' },
  { id: 3, name: 'Sans photo', country_name: 'X', image_url: null },
  { id: 4, name: 'MiG-29 <b>', country_name: 'URSS', image_url: '/assets/airplanes/mig29.jpg' },
];

function mount() {
  document.body.innerHTML = '<div class="gate-showcase" aria-hidden="true">'
    + '<div class="gate-card"></div><div class="gate-card"></div><div class="gate-card"></div></div>';
  return document.querySelector('.gate-showcase');
}

describe('pick', () => {
  test('ne garde que les fiches avec photo, au plus n, sans doublon', () => {
    const out = gate.pick(PLANES, 3, () => 0.5);
    expect(out).toHaveLength(3);
    expect(out.every(a => a.image_url)).toBe(true);
    expect(new Set(out.map(a => a.id)).size).toBe(3);
  });

  test('moins de fiches que demandé : toutes celles qui ont une photo', () => {
    expect(gate.pick(PLANES.slice(0, 3), 3, Math.random)).toHaveLength(2);
    expect(gate.pick(null, 3, Math.random)).toEqual([]);
  });
});

describe('render', () => {
  test('remplit les cadres : photo, nom échappé, pays, lien vers la fiche', () => {
    const root = mount();
    gate.render(root, [PLANES[0], PLANES[3]]);
    const cards = root.querySelectorAll('.gate-card');
    expect(cards[0].querySelector('img')).not.toBeNull();
    expect(cards[0].querySelector('.gate-card-name').textContent).toBe('Rafale');
    expect(cards[0].querySelector('.gate-card-meta').textContent).toBe('France');
    expect(cards[1].innerHTML).toContain('MiG-29 &lt;b&gt;');
    expect(cards[0].classList.contains('is-filled')).toBe(true);
    // Le troisième cadre reste vide (cœur seul).
    expect(cards[2].classList.contains('is-filled')).toBe(false);
  });

  test('sans conteneur : ne lève pas', () => {
    expect(() => gate.render(null, PLANES)).not.toThrow();
  });
});

describe('load', () => {
  test('interroge le catalogue public puis remplit les cadres', async () => {
    const root = mount();
    const fetchImpl = jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ data: PLANES }) }));
    await gate.load(root, fetchImpl, () => 0.3);
    expect(fetchImpl.mock.calls[0][0]).toMatch(/^\/api\/airplanes\?limit=\d+/);
    expect(root.querySelectorAll('.gate-card.is-filled')).toHaveLength(3);
    expect(root.classList.contains('is-ready')).toBe(true);
  });

  test('réseau en échec ou réponse en erreur : cadres vides, aucune exception', async () => {
    const root = mount();
    await expect(gate.load(root, () => Promise.reject(new Error('offline')))).resolves.toBeUndefined();
    await expect(gate.load(root, () => Promise.resolve({ ok: false }))).resolves.toBeUndefined();
    expect(root.querySelectorAll('.gate-card.is-filled')).toHaveLength(0);
    expect(root.classList.contains('is-ready')).toBe(true);
  });
});

describe('load — tirage dans tout le catalogue', () => {
  test('page tirée au hasard ; vide ou trop pauvre : repli sur la première page', async () => {
    const root = mount();
    const fetchImpl = jest.fn((url) => Promise.resolve({
      ok: true,
      json: () => Promise.resolve({ data: /page=1(&|$)/.test(url) ? PLANES : [] }),
    }));
    await gate.load(root, fetchImpl, () => 0.99);
    expect(fetchImpl).toHaveBeenCalledTimes(2);
    expect(fetchImpl.mock.calls[0][0]).toMatch(/page=6/);
    expect(fetchImpl.mock.calls[1][0]).toMatch(/page=1(&|$)/);
    expect(root.querySelectorAll('.gate-card.is-filled')).toHaveLength(3);
  });
});

test('sans fetch fourni : passe par auth.fetchWithTimeout (qui ajoute ?lang=)', async () => {
  const root = mount();
  global.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ data: PLANES }) })) };
  try {
    await gate.load(root, undefined, () => 0);
    expect(global.auth.fetchWithTimeout).toHaveBeenCalledWith(expect.stringMatching(/^\/api\/airplanes\?limit=100&page=1$/));
  } finally {
    delete global.auth;
  }
});
