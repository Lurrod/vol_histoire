/**
 * Dates de calendrier : texte « AAAA-MM-JJ » rendu par le pilote PostgreSQL
 * (db.useCalendarDates) et aides de lecture (utils/calendar-date).
 */
const { isoDay, yearOf } = require('../utils/calendar-date');
const { useCalendarDates } = require('../db');

describe('utils/calendar-date', () => {
  test('texte AAAA-MM-JJ : rendu tel quel, sans fuseau', () => {
    expect(isoDay('1974-12-23')).toBe('1974-12-23');
    expect(yearOf('1978-01-01')).toBe(1978); // un 1er janvier ne recule pas d'un an
  });

  test('objet Date (ancien pilote : minuit local) : jour local, jamais le jour UTC', () => {
    const local = new Date(1986, 9, 1); // 1er octobre 1986, minuit local
    expect(isoDay(local)).toBe('1986-10-01');
    expect(yearOf(new Date(1978, 0, 1))).toBe(1978);
  });

  test('valeurs vides ou invalides : null', () => {
    [null, undefined, '', 'pas une date', new Date('x')].forEach((v) => {
      expect(isoDay(v)).toBeNull();
      expect(yearOf(v)).toBeNull();
    });
  });
});

describe('db.useCalendarDates', () => {
  test('le type DATE (OID 1082) est rendu en texte brut', () => {
    const setTypeParser = jest.fn();
    const pg = { types: { setTypeParser } };
    expect(useCalendarDates(pg)).toBe(pg);
    expect(setTypeParser).toHaveBeenCalledWith(1082, expect.any(Function));
    const parse = setTypeParser.mock.calls[0][1];
    expect(parse('1986-10-01')).toBe('1986-10-01');
  });

  test('avec le vrai module pg : la date reste une chaîne', () => {
    const pg = require('pg');
    useCalendarDates(pg);
    expect(pg.types.getTypeParser(1082)('1986-10-01')).toBe('1986-10-01');
  });
});
