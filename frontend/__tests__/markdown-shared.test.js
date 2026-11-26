/**
 * details/markdown.js — copie générée de backend/utils/markdown.js (SEO-001).
 * Le serveur (récit écrit dans la fiche) et le navigateur doivent produire
 * exactement le même HTML : sinon la fiche bouge quand le client la réécrit.
 */
const fs = require('fs');
const path = require('path');

const backend = require('../../backend/utils/markdown.js');
require('../js/details/markdown');
const front = window.VH.details.markdown;

const NARRATIVE = [
  '## Genèse',
  '',
  'Le **Mirage III** est l\'*intercepteur* conçu par [Dassault](https://www.dassault-aviation.com) : Mach 2 ?',
  '',
  '### Armement',
  '- canon DEFA',
  '- missile « Matra R530 »',
  '',
  'Fin <script>alert(1)</script> & co.',
].join('\n');

describe('details/markdown.js', () => {
  test('copie à jour de la source backend (sinon : node scripts/build-js.js)', () => {
    const source = fs.readFileSync(path.join(__dirname, '../../backend/utils/markdown.js'), 'utf8').replace(/\r\n/g, '\n');
    const copy = fs.readFileSync(path.join(__dirname, '../js/details/markdown.js'), 'utf8').replace(/\r\n/g, '\n');
    const body = source.split('// >>> partagé avec le navigateur\n')[1].split('// <<< partagé avec le navigateur')[0];
    const indented = body.replace(/\n+$/, '').split('\n').map(l => (l ? `  ${l}` : l)).join('\n');
    expect(copy).toContain(indented);
  });

  test.each([['fr'], ['en']])('même HTML que le serveur (%s)', (lang) => {
    expect(front.parse(NARRATIVE, { lang })).toBe(backend.parse(NARRATIVE, { lang }));
  });

  test('CONT-005 : guillemets droits → « » en français, intacts en anglais et dans les URL', () => {
    const md = 'Le Viggen ("Foudre") vole, voir [lien](https://x.fr/a"b).';
    const fr = front.parse(md, { lang: 'fr' });
    expect(fr).toContain('« Foudre »');
    expect(fr).toBe(backend.parse(md, { lang: 'fr' }));
    expect(front.parse(md, { lang: 'en' })).toContain('&quot;Foudre&quot;');
  });

  test('isMarkdown : titres et listes oui, texte simple non', () => {
    expect(front.isMarkdown('## Titre')).toBe(true);
    expect(front.isMarkdown('Texte\n- puce')).toBe(true);
    expect(front.isMarkdown('Un chasseur.')).toBe(false);
    expect(front.isMarkdown(null)).toBe(false);
  });
});
