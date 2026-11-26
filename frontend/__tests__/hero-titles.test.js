/**
 * Titres de héros en deux parties (HTML-002) : la seconde partie
 * (<span class="hero-muted">) passe à la ligne par le CSS seulement. Sans
 * espace dans le balisage, le texte brut du <h1> collait les deux mots
 * (« Hangardes Avions », « LesConflits ») pour les robots et les lecteurs.
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const pages = fs.readdirSync(ROOT).filter((f) => f.endsWith('.html'));
const locales = ['fr.json', 'en.json'].map((f) => [f, fs.readFileSync(path.join(ROOT, 'locales', f), 'utf8')]);

// Un caractère non blanc juste avant l'ouverture du span = deux mots collés.
const GLUED = /[^\s>]<span class="hero-muted"|[^\s>]<span class=\\"hero-muted\\"/;

describe('titres de héros : une espace avant la partie atténuée', () => {
  test.each(pages)('%s', (file) => {
    const html = fs.readFileSync(path.join(ROOT, file), 'utf8');
    expect(html).not.toMatch(GLUED);
  });

  test.each(locales)('locales/%s', (_name, json) => {
    expect(json).not.toMatch(GLUED);
  });
});
