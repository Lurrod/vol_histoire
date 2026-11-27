/**
 * Tests — frontend/js/shared/calendar-date.js : dates de calendrier.
 *
 * L'API envoie « AAAA-MM-JJ » (backend/db.js, useCalendarDates) ; l'ancien
 * format, minuit heure de Paris converti en UTC, reste lisible.
 */
const cd = require('../js/shared/calendar-date');

describe('iso', () => {
  test('« AAAA-MM-JJ » rendu tel quel', () => {
    expect(cd.iso('1974-12-23')).toBe('1974-12-23');
  });

  test('ancien format UTC : le jour à Paris, été comme hiver', () => {
    expect(cd.iso('1986-07-03T22:00:00.000Z')).toBe('1986-07-04'); // heure d'été (UTC+2)
    expect(cd.iso('1986-09-30T23:00:00.000Z')).toBe('1986-10-01'); // 1986 : heure d'hiver dès fin septembre
    expect(cd.iso('1977-12-31T23:00:00.000Z')).toBe('1978-01-01'); // heure d'hiver (UTC+1)
    expect(cd.iso(new Date('1974-12-22T23:00:00.000Z'))).toBe('1974-12-23');
  });

  test('vide ou invalide : null', () => {
    [null, undefined, '', 'pas une date'].forEach((v) => expect(cd.iso(v)).toBeNull());
  });

  test('Intl indisponible : repli sur le jour UTC, sans lever', () => {
    const orig = Intl.DateTimeFormat;
    jest.resetModules();
    Intl.DateTimeFormat = function () { throw new Error('Intl'); };
    try {
      const fresh = require('../js/shared/calendar-date');
      expect(fresh.iso('1986-10-01T12:00:00.000Z')).toBe('1986-10-01');
    } finally {
      Intl.DateTimeFormat = orig;
    }
  });
});

describe('parts, year, toUTCDate', () => {
  test('trois nombres, mois de 1 à 12', () => {
    expect(cd.parts('1978-01-01')).toEqual({ year: 1978, month: 1, day: 1 });
    expect(cd.year('1978-01-01')).toBe(1978);
    expect(cd.parts(null)).toBeNull();
    expect(cd.year('')).toBeNull();
  });

  test('toUTCDate : minuit UTC, à formater en UTC (le jour ne bouge pas, quel que soit le fuseau)', () => {
    const d = cd.toUTCDate('1974-12-23');
    expect(d.toISOString()).toBe('1974-12-23T00:00:00.000Z');
    expect(d.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' })).toBe('23 décembre 1974');
    expect(cd.toUTCDate(undefined)).toBeNull();
  });
});
