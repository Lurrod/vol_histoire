/**
 * Tests DOM — frontend/js/i18n.js : contenu [data-i18n-html] assaini par
 * DOMPurify (A11Y-009). L'inventaire des cookies de la politique de
 * confidentialité est un tableau dans une zone défilante focalisable : la
 * liste blanche doit garder les tableaux et role / tabindex / aria-label,
 * et continuer à retirer scripts et gestionnaires en ligne.
 */
const DOMPurify = require('../js/vendor/purify.min.js');

const TABLE_HTML = '<section class="cookies-inventory-wrap" tabindex="0" aria-label="Inventaire des cookies">'
  + '<table class="cookies-inventory"><caption class="sr-only">Inventaire</caption>'
  + '<thead><tr><th scope="col">Nom</th></tr></thead>'
  + '<tbody><tr><td><code>refreshToken</code></td></tr></tbody></table></section>'
  + '<img src="x" onerror="alert(1)"><script>alert(2)</script>';

let i18n;

beforeAll(async () => {
  global.DOMPurify = DOMPurify;
  window.DOMPurify = DOMPurify;
  localStorage.clear();
  global.fetch = jest.fn().mockResolvedValue({
    ok: true,
    json: async () => ({ legal: { body: TABLE_HTML } }),
  });
  i18n = require('../js/i18n');
  await i18n.setLang('fr');
});

afterAll(() => {
  delete global.fetch;
});

test('garde le tableau et les attributs d\'accessibilité de la zone défilante', () => {
  document.body.innerHTML = '<div data-i18n-html="legal.body"></div>';
  i18n.applyToDOM();
  const wrap = document.querySelector('.cookies-inventory-wrap');
  expect(wrap).not.toBeNull();
  expect(wrap.getAttribute('tabindex')).toBe('0');
  expect(wrap.tagName).toBe('SECTION');
  expect(wrap.getAttribute('aria-label')).toBe('Inventaire des cookies');
  expect(document.querySelector('table caption')).not.toBeNull();
  expect(document.querySelector('th').getAttribute('scope')).toBe('col');
  expect(document.querySelector('td code').textContent).toBe('refreshToken');
});

test('retire toujours scripts, images et gestionnaires en ligne', () => {
  document.body.innerHTML = '<div data-i18n-html="legal.body"></div>';
  i18n.applyToDOM();
  const html = document.body.innerHTML;
  expect(html).not.toMatch(/<script|onerror|<img/i);
});
