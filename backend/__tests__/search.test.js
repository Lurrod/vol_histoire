/**
 * Tests unitaires — utils/search.js (variante préfixe de la recherche)
 */

const { prefixTsquery } = require('../utils/search');

describe('prefixTsquery', () => {
  test('mot incomplet → préfixe', () => {
    expect(prefixTsquery('mira')).toBe('mira:*');
  });

  test('seul le dernier mot devient un préfixe', () => {
    expect(prefixTsquery('mirage 20')).toBe('mirage & 20:*');
  });

  test('suit le découpage du parseur : « F-16 » → f & 16', () => {
    expect(prefixTsquery('F-16')).toBe('f & 16:*');
  });

  test('met en minuscules et garde les lettres accentuées', () => {
    expect(prefixTsquery('Kızıl')).toBe('kızıl:*');
    expect(prefixTsquery('Étend')).toBe('étend:*');
  });

  test("n'injecte aucun opérateur de tsquery venu de la saisie", () => {
    const q = prefixTsquery("rafale & !mirage | (f:*) 'x'");
    expect(q).toBe('rafale & mirage & f & x:*');
    expect(q).not.toMatch(/[|!()']/);
  });

  test('désactivé quand la saisie utilise la syntaxe websearch', () => {
    expect(prefixTsquery('"mirage 2000"')).toBeNull();
    expect(prefixTsquery('rafale -mirage')).toBeNull();
    expect(prefixTsquery('rafale or mirage')).toBeNull();
  });

  test('un tiret interne n’est pas une exclusion', () => {
    expect(prefixTsquery('su-2')).toBe('su & 2:*');
  });

  test('saisie sans caractère alphanumérique → null', () => {
    expect(prefixTsquery('   ')).toBeNull();
    expect(prefixTsquery('--- !!')).toBeNull();
    expect(prefixTsquery(undefined)).toBeNull();
  });
});
