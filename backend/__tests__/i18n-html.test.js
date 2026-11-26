/**
 * Traduction côté serveur des textes d'interface (SEO-002).
 */
const { localizeBody } = require('../utils/i18n-html');

const DICT = {
  nav: { home: 'Home', menu: 'Menu' },
  details: { description: 'Description', loading_desc: 'Loading description...' },
  home: { hero_title: 'Military aviation, <span class="hero-muted">one record at a time</span>' },
  search: { placeholder: 'Search an aircraft', label: 'Search' },
  x: { amp: 'Fish & <chips>' },
  footer: { copyright: "© {year} Vol d'Histoire" },
  favorites: { results: '{count} favorites' },
};

describe('localizeBody', () => {
  test('data-i18n : texte remplacé, échappé', () => {
    expect(localizeBody('<a href="/" data-i18n="nav.home">Accueil</a>', DICT)).toBe('<a href="/" data-i18n="nav.home">Home</a>');
    expect(localizeBody('<span data-i18n="x.amp">a</span>', DICT)).toBe('<span data-i18n="x.amp">Fish &amp; &lt;chips&gt;</span>');
  });

  test('icône <i> en tête conservée, comme applyToDOM', () => {
    expect(localizeBody('<h2 data-i18n="details.description"><i class="fas fa-file"></i> Description FR</h2>', DICT))
      .toBe('<h2 data-i18n="details.description"><i class="fas fa-file"></i> Description</h2>');
  });

  test('clé absente ou contenu riche : laissé au navigateur', () => {
    const missing = '<p data-i18n="nope.key">Texte</p>';
    expect(localizeBody(missing, DICT)).toBe(missing);
    const rich = '<p data-i18n="nav.home">Texte <strong>gras</strong></p>';
    expect(localizeBody(rich, DICT)).toBe(rich);
  });

  test('{year} remplacé comme dans i18n.js ; autre variable → laissé au script', () => {
    expect(localizeBody('<p data-i18n="footer.copyright">© 2026</p>', DICT))
      .toBe(`<p data-i18n="footer.copyright">© ${new Date().getFullYear()} Vol d'Histoire</p>`);
    const count = '<span data-i18n="favorites.results">0 favoris</span>';
    expect(localizeBody(count, DICT)).toBe(count);
  });

  test('<title> laissé à localizeHead', () => {
    const t = '<title data-i18n="nav.home">Accueil</title>';
    expect(localizeBody(t, DICT)).toBe(t);
  });

  test('data-i18n-html : contenu remplacé ; même balise imbriquée → laissé', () => {
    expect(localizeBody('<h1 data-i18n-html="home.hero_title">FR <span>x</span></h1>', DICT))
      .toBe('<h1 data-i18n-html="home.hero_title">Military aviation, <span class="hero-muted">one record at a time</span></h1>');
    const nested = '<span data-i18n-html="home.hero_title"><span>a</span></span>';
    expect(localizeBody(nested, DICT)).toBe(nested);
  });

  test('placeholder et aria-label : remplacés ou ajoutés', () => {
    expect(localizeBody('<input type="search" placeholder="Rechercher" data-i18n-placeholder="search.placeholder">', DICT))
      .toBe('<input type="search" placeholder="Search an aircraft" data-i18n-placeholder="search.placeholder">');
    expect(localizeBody('<button data-i18n-aria="search.label">', DICT))
      .toBe('<button data-i18n-aria="search.label" aria-label="Search">');
  });
});
