/**
 * Tests unitaires — frontend/js/shared/legal-doc.js
 *
 * En-tête des documents légaux : temps de lecture calculé sur le texte
 * affiché (recalculé au changement de langue) et bouton d'impression.
 */
const words = (n) => Array.from({ length: n }, (_, i) => 'mot' + i).join(' ');

function page(n) {
  document.body.innerHTML = `
    <header class="doc-head">
      <p class="doc-meta"><strong data-reading-time>? min</strong></p>
      <button type="button" data-print>Imprimer</button>
    </header>
    <div class="legal-container"><p>${words(n)}</p></div>`;
}

let legalDoc;

beforeEach(() => {
  jest.resetModules();
  page(1150);
  window.print = jest.fn();
  legalDoc = require('../js/shared/legal-doc');
});

test('temps de lecture : 230 mots par minute, arrondi', () => {
  expect(document.querySelector('[data-reading-time]').textContent).toBe('5 min');
  expect(legalDoc.readingMinutes(words(100))).toBe(1);   // jamais 0
  expect(legalDoc.readingMinutes('')).toBe(1);
  expect(legalDoc.readingMinutes(words(460))).toBe(2);
});

test('recalculé quand la langue change (texte traduit)', () => {
  document.querySelector('.legal-container').innerHTML = `<p>${words(2300)}</p>`;
  window.dispatchEvent(new Event('langChanged'));
  expect(document.querySelector('[data-reading-time]').textContent).toBe('10 min');
});

test('le bouton ouvre l’impression du navigateur', () => {
  document.querySelector('[data-print]').click();
  expect(window.print).toHaveBeenCalledTimes(1);
});

test('page sans en-tête de document : rien', () => {
  document.body.innerHTML = '<main></main>';
  expect(legalDoc.init(document)).toBe(false);
  expect(legalDoc.updateReadingTime(document)).toBeNull();
});

test('recalculé quand la langue finit de se charger (i18nReady)', () => {
  document.querySelector('.legal-container').innerHTML = `<p>${words(690)}</p>`;
  window.dispatchEvent(new Event('i18nReady'));
  expect(document.querySelector('[data-reading-time]').textContent).toBe('3 min');
});
