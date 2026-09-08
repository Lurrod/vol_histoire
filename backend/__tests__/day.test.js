/**
 * Tests unitaires — backend/utils/day.js
 *
 * L'éphéméride et l'appareil du jour basculent sur cette horloge. Un serveur en
 * UTC ferait changer le contenu à 2 h du matin heure française en été ; ces
 * tests fixent le fuseau de référence.
 */
const { todayInParis, REFERENCE_TZ } = require('../utils/day');

describe('todayInParis', () => {
  test('rend une date au format YYYY-MM-DD', () => {
    expect(todayInParis()).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  test('bascule à minuit heure de Paris, pas à minuit UTC', () => {
    // 8 septembre 2026, 22 h 30 UTC = 9 septembre, 0 h 30 à Paris (UTC+2).
    expect(todayInParis(new Date('2026-09-08T22:30:00Z'))).toBe('2026-09-09');
    // 8 septembre 2026, 21 h 30 UTC = encore le 8 à Paris.
    expect(todayInParis(new Date('2026-09-08T21:30:00Z'))).toBe('2026-09-08');
  });

  test('tient compte de l\'heure d\'hiver (UTC+1)', () => {
    // 15 janvier 2026, 23 h 30 UTC = 16 janvier, 0 h 30 à Paris.
    expect(todayInParis(new Date('2026-01-15T23:30:00Z'))).toBe('2026-01-16');
    expect(todayInParis(new Date('2026-01-15T22:30:00Z'))).toBe('2026-01-15');
  });

  test('le fuseau de référence est explicite', () => {
    expect(REFERENCE_TZ).toBe('Europe/Paris');
  });
});
