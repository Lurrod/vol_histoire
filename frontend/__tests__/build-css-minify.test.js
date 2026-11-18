/**
 * Tests — scripts/build-css.js : minifieur maison.
 *
 * Il a déjà tué des règles en silence (« + » de calc(), espace avant
 * « :pseudo »). Ici : le contenu des chaînes ne doit jamais être touché —
 * le compactage des espaces retirait l'espace finale de content: ' : ' et
 * changeait l'espace insécable (que \s de JavaScript attrape) en espace.
 */
const { minify } = require('../../scripts/build-css');

describe('minify — chaînes intactes', () => {
  test('espaces et espace insécable gardés dans content', () => {
    const out = minify(".a::after { content: ' : '; }\n.b::after { content: ' : '; }");
    expect(out).toContain("content:' : '");
    expect(out).toContain("content:' : '");
  });

  test('guillemets doubles, échappements et caractères de compactage dans une chaîne', () => {
    const out = minify('.a::before { content: "a > b ; c { d }"; }\n.b::before { content: \'\\00a0→ \'; }');
    expect(out).toContain('content:"a > b ; c { d }"');
    expect(out).toContain("content:'\\00a0→ '");
  });

  test('URI de données SVG inchangée', () => {
    const svg = "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 16 16'%3E%3Cpath d='M3.6 8.4l2.9 2.9'/%3E%3C/svg%3E\")";
    expect(minify(`.a { background-image: ${svg}; }`)).toContain(svg);
  });

  test('le compactage hors chaînes est conservé', () => {
    expect(minify('.a  >  .b {\n  color: red ;\n}')).toBe('.a>.b{color:red}');
    expect(minify('.a { width: calc(100% + 1rem); }')).toBe('.a{width:calc(100% + 1rem)}');
  });
});
