/**
 * Tests — frontend/js/i18n.js : la langue déduite du navigateur est mémorisée
 * (HTML-001). auth.js lit localStorage pour ajouter ?lang= aux appels /api :
 * sans cette mémorisation, un premier visiteur anglophone recevait les
 * données en français et le h1 rendu en anglais par le serveur était réécrit.
 */
test('langue du navigateur (en-US) mémorisée sous vol-histoire-lang', () => {
  localStorage.clear();
  Object.defineProperty(window.navigator, 'language', { configurable: true, get: () => 'en-US' });
  global.fetch = jest.fn().mockResolvedValue({ ok: true, json: async () => ({}) });
  const i18n = require('../js/i18n');
  expect(i18n.currentLang).toBe('en');
  expect(localStorage.getItem('vol-histoire-lang')).toBe('en');
  delete global.fetch;
});
