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
