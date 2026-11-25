/**
 * shared/meta-description.js — copie générée de backend/utils/meta-description.js
 * (ARCH-003). Le serveur (rendu SSR des fiches) et le navigateur doivent
 * produire exactement la même meta description.
 */
const fs = require('fs');
const path = require('path');

const backend = require('../../backend/utils/meta-description.js');
require('../js/shared/meta-description');
const front = window.VH.shared.metaDescription;

const NARRATIVE = [
  '## Genèse',
  '',
  'Le **Mirage III** est un *intercepteur* conçu par [Dassault](https://www.dassault-aviation.com) : il vole à Mach 2 ?',
  '',
  '---',
  '',
  'Second paragraphe ignoré.',
].join('\n');

describe('shared/meta-description.js', () => {
  test('copie à jour de la source backend (sinon : node scripts/build-js.js)', () => {
    const source = fs.readFileSync(path.join(__dirname, '../../backend/utils/meta-description.js'), 'utf8').replace(/\r\n/g, '\n');
    const copy = fs.readFileSync(path.join(__dirname, '../js/shared/meta-description.js'), 'utf8').replace(/\r\n/g, '\n');
    const body = source.split('// >>> partagé avec le navigateur\n')[1].split('// <<< partagé avec le navigateur')[0];
    const indented = body.replace(/\n+$/, '').split('\n').map(l => (l ? `  ${l}` : l)).join('\n');
    expect(copy).toContain(indented);
  });

  test.each([
    ['Intercepteur français', NARRATIVE, '', 158, 'fr'],
    ['Intercepteur français', NARRATIVE, '', 158, 'en'],
    ['', '---\n\nTexte après un filet.', '', 158, 'fr'],
    ['Sans point final', '', 'Phrase de repli.', 40, 'fr'],
    ['', '', '', 158, 'fr'],
  ])('même résultat que le serveur : %s', (lead, narrative, filler, max, lang) => {
    expect(front.buildDescription(lead, narrative, filler, max, lang))
      .toBe(backend.buildDescription(lead, narrative, filler, max, lang));
  });

  test('les filets Markdown sont sautés, comme sur le serveur', () => {
    expect(front.markdownToText('---\n\nTexte')).toBe('Texte');
  });

  test('coupe à 158 caractères au plus, sur un mot', () => {
    const out = front.buildDescription('', 'mot '.repeat(80), '', 158, 'en');
    expect(out.length).toBeLessThanOrEqual(158);
    expect(out.endsWith('…')).toBe(true);
  });
});
