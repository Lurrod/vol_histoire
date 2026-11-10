/**
 * Tests unitaires — frontend/js/nations-map.js
 *
 * On teste l'échelle de teintes : c'est elle qui décide de la lisibilité de la
 * carte. Le rendu SVG lui-même dépend d'un fetch et de getScreenCTM, absents de
 * jsdom, et est couvert côté navigateur.
 */

global.escapeHtml = (s) => String(s);
global.i18n = { t: (key) => key };
global.auth = { fetchWithTimeout: jest.fn() };

const map = require('../js/nations-map');

describe('nations-map — paliers de teinte', () => {
  test('une nation sans fiche n\'est pas colorée', () => {
    expect(map.tierOf(0, 120)).toBe(0);
    expect(map.tierOf(null, 120)).toBe(0);
  });

  test('la nation la plus fournie occupe le palier le plus élevé', () => {
    expect(map.tierOf(120, 120)).toBe(4);
  });

  test('une seule fiche reste visible au palier le plus bas', () => {
    expect(map.tierOf(1, 120)).toBe(1);
  });

  test('les paliers ne décroissent jamais quand le nombre de fiches monte', () => {
    const max = 120;
    let previous = 0;
    for (let n = 1; n <= max; n++) {
      const tier = map.tierOf(n, max);
      expect(tier).toBeGreaterThanOrEqual(previous);
      expect(tier).toBeLessThanOrEqual(4);
      previous = tier;
    }
  });

  test('l\'échelle en racine évite que deux nations écrasent les autres', () => {
    // Avec une échelle linéaire, 30 fiches sur 120 tomberaient au palier 1 ;
    // la racine les remonte, ce qui est tout l'objet du choix.
    expect(map.tierOf(30, 120)).toBeGreaterThan(1);
  });

  test('un maximum nul ne casse pas le calcul', () => {
    expect(map.tierOf(5, 0)).toBe(0);
  });
});

describe('nations-map — montage accessible (A11Y-010)', () => {
  const SVG = '<svg xmlns="http://www.w3.org/2000/svg" class="world-map" role="img" aria-hidden="true">'
    + '<g class="wm-nations"><path class="wm-nation" data-code="FRA" d="M0 0"/>'
    + '<path class="wm-nation" data-code="LBY" d="M1 1"/></g></svg>';

  beforeEach(() => {
    jest.resetModules();
    global.auth = {
      fetchWithTimeout: jest.fn(() => Promise.resolve({
        ok: true,
        json: () => Promise.resolve([{ code: 'FRA', name: 'France', name_fr: 'France', count: 40 }]),
      })),
    };
    global.fetch = jest.fn(() => Promise.resolve({ ok: true, text: () => Promise.resolve(SVG) }));
    document.body.innerHTML = '<section id="m"><div class="nations-map-canvas"></div>'
      + '<div class="nations-map-tooltip"></div></section>';
  });

  afterEach(() => { delete global.fetch; });

  test('le SVG monté est un groupe nommé, plus une image aux pays masqués', async () => {
    const fresh = require('../js/nations-map');
    await fresh.mount(document.getElementById('m'));
    const svg = document.querySelector('#m svg');
    expect(svg.getAttribute('role')).toBe('group');
    expect(svg.hasAttribute('aria-hidden')).toBe(false);
    expect(svg.getAttribute('aria-label')).toBe('home.nations_map_aria');
    const france = svg.querySelector('[data-code="FRA"]');
    expect(france.getAttribute('tabindex')).toBe('0');
    expect(france.getAttribute('role')).toBe('link');
    // Pays sans fiche : décor, non focalisable
    expect(svg.querySelector('[data-code="LBY"]').hasAttribute('tabindex')).toBe(false);
  });
});
