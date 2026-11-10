/**
 * Tests unitaires — frontend/js/details/markdown.js
 *
 * Parseur Markdown minimal des descriptions enrichies (strate 5). Sa sortie
 * passe ensuite par safeSetHTML (DOMPurify) ; on vérifie ici que le parseur
 * échappe lui-même tout ce qui n'est pas une syntaxe reconnue, sans compter
 * sur cette seconde barrière.
 */

window.VH = {};
require('../js/details/markdown');
const { parse } = window.VH.details.markdown;

/** Rend le HTML produit dans un conteneur pour l'inspecter en DOM. */
function dom(markdown) {
  const div = document.createElement('div');
  div.innerHTML = parse(markdown);
  return div;
}

describe('markdown.parse — entrées vides ou invalides', () => {
  test.each([[''], [null], [undefined], [42], [{}]])('%p → chaîne vide', (input) => {
    expect(parse(input)).toBe('');
  });

  test('uniquement des lignes vides → aucune balise', () => {
    expect(parse('\n\n   \n')).toBe('');
  });
});

describe('markdown.parse — blocs', () => {
  test('## → <h3 class="md-section">, ### → <h4 class="md-subsection">', () => {
    const root = dom('## Origines\n### Prototype');
    expect(root.querySelector('h3.md-section').textContent).toBe('Origines');
    expect(root.querySelector('h4.md-subsection').textContent).toBe('Prototype');
  });

  test('un « # » seul ou « ##» sans espace reste du texte', () => {
    const root = dom('# Pas un titre\n##collé');
    expect(root.querySelector('h3, h4')).toBeNull();
    expect(root.querySelector('p').textContent).toBe('# Pas un titre ##collé');
  });

  test('lignes consécutives → un seul paragraphe joint par des espaces', () => {
    const root = dom('Première ligne\nseconde ligne');
    const ps = root.querySelectorAll('p');
    expect(ps).toHaveLength(1);
    expect(ps[0].textContent).toBe('Première ligne seconde ligne');
  });

  test('ligne vide → deux paragraphes distincts', () => {
    expect(dom('A\n\nB').querySelectorAll('p')).toHaveLength(2);
  });

  test('fins de ligne Windows (CRLF) traitées comme LF', () => {
    const root = dom('## Titre\r\n\r\nTexte\r\n- item');
    expect(root.querySelector('h3').textContent).toBe('Titre');
    expect(root.querySelector('p').textContent).toBe('Texte');
    expect(root.querySelector('li').textContent).toBe('item');
  });

  test('liste « - item » → <ul><li>, indentation tolérée', () => {
    const root = dom('- Mach 2\n  - Radar RBE2\n- Canon 30 mm');
    const items = [...root.querySelectorAll('ul > li')].map((li) => li.textContent);
    expect(items).toEqual(['Mach 2', 'Radar RBE2', 'Canon 30 mm']);
    expect(root.querySelectorAll('ul')).toHaveLength(1);
  });

  test('un paragraphe interrompu par une liste, puis repris', () => {
    const html = parse('Intro\n- a\n- b\nSuite');
    expect(html).toBe('<p>Intro</p>\n<ul><li>a</li><li>b</li></ul>\n<p>Suite</p>');
  });

  test('un titre ferme la liste et le paragraphe en cours', () => {
    const html = parse('Texte\n- a\n## Titre');
    expect(html).toBe('<p>Texte</p>\n<ul><li>a</li></ul>\n<h3 class="md-section">Titre</h3>');
    expect(parse('Para\n### Sous')).toBe('<p>Para</p>\n<h4 class="md-subsection">Sous</h4>');
  });
});

describe('markdown.parse — en ligne', () => {
  test('**gras** → <strong>, *italique* → <em>', () => {
    const root = dom('Le **Rafale** est *omnirôle*.');
    expect(root.querySelector('strong').textContent).toBe('Rafale');
    expect(root.querySelector('em').textContent).toBe('omnirôle');
  });

  test('un astérisque isolé (multiplication) ne crée pas d\'italique', () => {
    const root = dom('Poussée 2*75 kN');
    expect(root.querySelector('em')).toBeNull();
    expect(root.textContent).toBe('Poussée 2*75 kN');
  });

  test('italique en début de ligne et entre parenthèses', () => {
    expect(dom('*Mirage* III').querySelector('em').textContent).toBe('Mirage');
    expect(dom('(*Rafale*)').querySelector('em').textContent).toBe('Rafale');
  });

  test('lien http(s) → <a target="_blank" rel="noopener noreferrer">', () => {
    const a = dom('Voir [Wikipédia](https://fr.wikipedia.org/wiki/Rafale).').querySelector('a');
    expect(a.getAttribute('href')).toBe('https://fr.wikipedia.org/wiki/Rafale');
    expect(a.getAttribute('target')).toBe('_blank');
    expect(a.getAttribute('rel')).toBe('noopener noreferrer');
    expect(a.textContent).toBe('Wikipédia');
  });

  test('lien dans un élément de liste et dans un titre', () => {
    expect(dom('- [Doc](http://ex.com)').querySelector('li a').getAttribute('href')).toBe('http://ex.com');
    expect(dom('## **Gras** de titre').querySelector('h3 strong').textContent).toBe('Gras');
  });

  // Régression (markdown.js, parseInline) : le texte entier est échappé AVANT
  // la détection des liens ; l'URL capturée était échappée une seconde fois
  // (« & » → « &amp;amp; »). Elle ne l'est plus.
  test('un « & » dans l\'URL d\'un lien n\'est échappé qu\'une fois', () => {
    const a = dom('[Doc](https://ex.com/?a=1&b=2)').querySelector('a');
    expect(a.getAttribute('href')).toBe('https://ex.com/?a=1&b=2');
  });

  test('un guillemet dans l\'URL d\'un lien ne sort pas de l\'attribut', () => {
    const a = dom('[Doc](https://ex.com/"onmouseover="alert(1))').querySelector('a');
    expect(a.getAttribute('onmouseover')).toBeNull();
    expect(a.getAttribute('href')).toBe('https://ex.com/"onmouseover="alert(1');
  });

  test('un lien javascript: n\'est pas transformé en <a>', () => {
    const root = dom('[x](javascript:alert(1))');
    expect(root.querySelector('a')).toBeNull();
  });
});

describe('markdown.parse — sécurité', () => {
  test('les balises HTML brutes sont échappées, jamais interprétées', () => {
    const root = dom('<img src=x onerror=alert(1)> <script>alert(1)</script>');
    expect(root.querySelector('img, script')).toBeNull();
    expect(root.textContent).toContain('<img src=x onerror=alert(1)>');
  });

  test('guillemets et apostrophes échappés (pas d\'évasion d\'attribut)', () => {
    const html = parse('Il a dit "oui" et l\'a fait');
    expect(html).toContain('&quot;oui&quot;');
    expect(html).toContain('l&#39;a');
  });

  test('lien javascript: refusé, laissé en texte', () => {
    const root = dom('[clic](javascript:alert(1))');
    expect(root.querySelector('a')).toBeNull();
    expect(root.textContent).toContain('[clic](javascript:alert(1))');
  });

  test('lien data: refusé', () => {
    expect(dom('[x](data:text/html,<b>)').querySelector('a')).toBeNull();
  });

  test('libellé de lien contenant du HTML : échappé', () => {
    const a = dom('[<b>gras</b>](https://ex.com)').querySelector('a');
    expect(a.querySelector('b')).toBeNull();
    expect(a.textContent).toBe('<b>gras</b>');
  });

  test('une URL ne peut pas sortir de l\'attribut href par un guillemet', () => {
    const a = dom('[x](https://ex.com/"onmouseover="alert(1))').querySelector('a');
    expect(a.getAttribute('onmouseover')).toBeNull();
  });
});
