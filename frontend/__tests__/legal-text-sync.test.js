/**
 * Pages légales (CONT-006) : chaque section existe deux fois en français, dans
 * le HTML (servi tel quel, lu sans JavaScript et par les robots) et dans
 * fr.json (data-i18n-html, réécrit au chargement). Les deux doivent dire la
 * même chose, sinon une correction faite d'un seul côté se perd.
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const fr = require('../locales/fr.json');
const lookup = (key) => key.split('.').reduce((o, k) => (o ? o[k] : undefined), fr);
const text = (html) => {
  const div = document.createElement('div');
  div.innerHTML = html;
  // Blancs ignorés : fr.json enchaîne les blocs sans retour à la ligne.
  return div.textContent.replace(/\s+/g, '');
};

const PAGES = ['cgu.html', 'mentions-legales.html', 'politique-confidentialite.html'];

describe.each(PAGES)('%s', (page) => {
  document.documentElement.innerHTML = fs.readFileSync(path.join(ROOT, page), 'utf8');
  const blocks = [...document.querySelectorAll('[data-i18n-html], [data-i18n]')]
    .filter((el) => el.tagName !== 'TITLE')
    .map((el) => {
      const key = el.getAttribute('data-i18n-html') || el.getAttribute('data-i18n');
      return [key, text(el.innerHTML)];
    });

  test.each(blocks)('%s : HTML identique à fr.json', (key, htmlText) => {
    const value = lookup(key);
    expect(value).toBeDefined();
    expect(htmlText).toBe(text(value));
  });
});
