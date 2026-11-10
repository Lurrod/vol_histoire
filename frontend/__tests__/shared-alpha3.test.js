/**
 * Tests — frontend/js/shared/alpha3.js
 *
 * Un code pays absent de la table ne casse rien : le drapeau disparaît de la
 * carte, en silence (vingt nations l'ont été jusqu'à la v4.8.0). On confronte
 * donc la table au référentiel canonique (backend/db_backup/db.sql) et aux
 * fichiers réellement livrés dans frontend/assets/flags.
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..');

function countryCodesFromDbSql() {
  const sql = fs.readFileSync(path.join(ROOT, 'backend', 'db_backup', 'db.sql'), 'utf8');
  const start = sql.indexOf('INSERT INTO countries');
  const block = sql.slice(start, sql.indexOf(';', start));
  return Array.from(block.matchAll(/'([A-Z]{3})'\)/g), m => m[1]);
}

let table;

beforeAll(() => {
  window.VH = {};
  require('../js/shared/alpha3');
  table = window.VH.shared.ALPHA3_TO_ALPHA2;
});

describe('shared/alpha3 — codes pays → drapeaux', () => {
  test('le référentiel est bien lu (garde-fou du test lui-même)', () => {
    const codes = countryCodesFromDbSql();
    expect(codes.length).toBeGreaterThanOrEqual(42);
    expect(codes).toEqual(expect.arrayContaining(['FRA', 'USA', 'ROK', 'CSK', 'YUG']));
  });

  test('chaque pays de db.sql a une entrée dans la table', () => {
    const missing = countryCodesFromDbSql().filter(code => !table[code]);
    expect(missing).toEqual([]);
  });

  test('chaque entrée pointe vers un drapeau livré', () => {
    const flagsDir = path.join(ROOT, 'frontend', 'assets', 'flags');
    const absent = Object.entries(table)
      .filter(([, a2]) => !fs.existsSync(path.join(flagsDir, `${a2}.png`)))
      .map(([a3, a2]) => `${a3}→${a2}`);
    expect(absent).toEqual([]);
  });

  test('entités disparues et doubles codes coréens', () => {
    expect(table.CSK).toBe('cz');
    expect(table.YUG).toBe('rs');
    // KOR localise la guerre de 1950, ROK les appareils sud-coréens : même drapeau
    expect(table.KOR).toBe('kr');
    expect(table.ROK).toBe('kr');
  });

  test('ne recrée pas l\'espace de noms VH s\'il existe déjà', () => {
    jest.resetModules();
    const keep = { other: 1 };
    window.VH = { shared: keep };
    require('../js/shared/alpha3');
    expect(window.VH.shared).toBe(keep);
    expect(keep.other).toBe(1);
    expect(keep.ALPHA3_TO_ALPHA2.FRA).toBe('fr');
  });
});
