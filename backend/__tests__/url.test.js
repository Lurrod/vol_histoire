/**
 * Tests unitaires — utils/url.js
 * slugify, buildDetailsPath, idFromSlug doivent rester synchrones
 * avec frontend/js/utils.js (slugify, buildDetailsUrl).
 */

const { slugify, buildDetailsPath, idFromSlug } = require('../utils/url');

describe('slugify', () => {
  test('nom simple → slug', () => {
    expect(slugify('F-22 Raptor')).toBe('f-22-raptor');
  });

  test('supprime les diacritiques', () => {
    expect(slugify('Sukhoï Élysée')).toBe('sukhoi-elysee');
  });

  test('remplace caractères spéciaux par "-"', () => {
    expect(slugify('Mirage 2000 «D»')).toBe('mirage-2000-d');
  });

  test('trim les tirets de début/fin', () => {
    expect(slugify('--test--')).toBe('test');
  });

  test('gère séparateurs multiples', () => {
    expect(slugify('F-16   Fighting_Falcon')).toBe('f-16-fighting-falcon');
  });

  test('null, undefined, empty → ""', () => {
    expect(slugify(null)).toBe('');
    expect(slugify(undefined)).toBe('');
    expect(slugify('')).toBe('');
  });
});

describe('buildDetailsPath', () => {
  test('id + nom → /details/<slug>-<id>', () => {
    expect(buildDetailsPath(30, 'F-22 Raptor')).toBe('/details/f-22-raptor-30');
  });

  test('diacritiques gérés', () => {
    expect(buildDetailsPath(5, 'Sukhoï Su-27')).toBe('/details/sukhoi-su-27-5');
  });

  test('fallback /details/<id> si nom absent', () => {
    expect(buildDetailsPath(42, '')).toBe('/details/42');
    expect(buildDetailsPath(42, null)).toBe('/details/42');
  });

  test('id en string accepté', () => {
    expect(buildDetailsPath('17', 'Rafale')).toBe('/details/rafale-17');
  });
});

describe('idFromSlug', () => {
  test('extrait l\'id depuis slug-id', () => {
    expect(idFromSlug('f-22-raptor-30')).toBe(30);
  });

  test('gère un slug sans nom (juste id)', () => {
    expect(idFromSlug('42')).toBe(42);
    expect(idFromSlug('-42')).toBe(42);
  });

  test('gère les gros ids', () => {
    expect(idFromSlug('rafale-12345')).toBe(12345);
  });

  test('retourne null si pas de nombre trailing', () => {
    expect(idFromSlug('f-22-raptor')).toBe(null);
    expect(idFromSlug('')).toBe(null);
    expect(idFromSlug(null)).toBe(null);
  });

  test('prend uniquement les chiffres finaux', () => {
    // "f-22-raptor-30" → 30 (pas 22 et pas 2230)
    expect(idFromSlug('f-22-raptor-30')).toBe(30);
  });
});

// Vérifie la symétrie buildDetailsPath ↔ idFromSlug
describe('symétrie buildDetailsPath ↔ idFromSlug', () => {
  test('roundtrip : id → path → id', () => {
    const ids = [1, 42, 999, 12345];
    const names = ['F-22 Raptor', 'Mirage 2000 D', 'Sukhoï Su-27', 'Rafale'];
    for (const id of ids) {
      for (const name of names) {
        const path = buildDetailsPath(id, name);
        const slug = path.replace('/details/', '');
        expect(idFromSlug(slug)).toBe(id);
      }
    }
  });
});
