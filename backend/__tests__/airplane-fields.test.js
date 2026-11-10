'use strict';

const {
  AIRPLANE_FIELDS, AIRPLANE_COLUMNS, STEALTH_LEVELS, toDbValue, toDbValues, presentFields,
} = require('../utils/airplane-fields');

describe('utils/airplane-fields', () => {
  test('52 colonnes éditables, uniques, name en tête', () => {
    expect(AIRPLANE_COLUMNS).toHaveLength(52);
    expect(new Set(AIRPLANE_COLUMNS).size).toBe(52);
    expect(AIRPLANE_COLUMNS[0]).toBe('name');
    expect(AIRPLANE_COLUMNS).toEqual(expect.arrayContaining(['engine_type_en', 'variants_en', 'image_licence']));
  });

  test('chaque entrée a un kind et un groupe connus ; ref et enum renseignés', () => {
    const kinds = ['text', 'longtext', 'url', 'date', 'int', 'number', 'enum', 'ref'];
    for (const f of AIRPLANE_FIELDS) {
      expect(kinds).toContain(f.kind);
      expect(typeof f.group).toBe('string');
      if (f.kind === 'ref') expect(['countries', 'manufacturer', 'generation', 'type', 'airplanes']).toContain(f.ref);
      if (f.kind === 'enum') expect(f.values).toBe(STEALTH_LEVELS);
    }
    expect(AIRPLANE_FIELDS.filter((f) => f.required).map((f) => f.column)).toEqual(['name']);
  });

  test('table gelée', () => {
    expect(Object.isFrozen(AIRPLANE_FIELDS)).toBe(true);
    expect(Object.isFrozen(AIRPLANE_FIELDS[0])).toBe(true);
  });

  test('toDbValue : vide et absent → NULL, name rogné, le reste intact', () => {
    const name = AIRPLANE_FIELDS[0];
    const speed = AIRPLANE_FIELDS.find((f) => f.column === 'max_speed');
    expect(toDbValue(name, '  Rafale  ')).toBe('Rafale');
    expect(toDbValue(speed, '')).toBeNull();
    expect(toDbValue(speed, undefined)).toBeNull();
    expect(toDbValue(speed, null)).toBeNull();
    expect(toDbValue(speed, 0)).toBe(0);
    expect(toDbValue(speed, '1800')).toBe('1800');
  });

  test('toDbValues : 52 paramètres dans l\'ordre des colonnes', () => {
    const values = toDbValues({ name: ' X ', variants_en: 'A' });
    expect(values).toHaveLength(52);
    expect(values[0]).toBe('X');
    expect(values[AIRPLANE_COLUMNS.indexOf('variants_en')]).toBe('A');
    expect(values.filter((v) => v !== null)).toHaveLength(2);
    expect(toDbValues(undefined)).toHaveLength(52);
  });

  test('presentFields : clés propres seulement, null compris, ordre de la table', () => {
    const body = { variants_en: null, name: 'X', inconnu: 1 };
    expect(presentFields(body).map((f) => f.column)).toEqual(['name', 'variants_en']);
    expect(presentFields(Object.create({ name: 'hérité' }))).toEqual([]);
    expect(presentFields(null)).toEqual([]);
  });
});
