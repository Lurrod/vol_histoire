/**
 * Couleurs écrites en dur dans les feuilles (CSS-001). Les couleurs passent
 * par les jetons de tokens.css (voiles --white-aNN, --gold-aNN…, teintes
 * nommées) : une retouche de teinte se fait à un seul endroit, et le contraste
 * garanti par les jetons --text-* ne peut pas être contourné en silence.
 *
 * Les couleurs restantes (valeurs uniques : couleurs d'ère de la frise,
 * palette d'impression, dégradés du héros…) sont figées par feuille dans
 * BASELINE : le compte peut baisser (mettre alors la ligne à jour), jamais
 * monter. Une nouvelle couleur s'ajoute comme jeton dans tokens.css.
 */
const fs = require('fs');
const path = require('path');

const CSS_DIR = path.join(__dirname, '..', 'css');

const BASELINE = {
  'cookies.css': 1,
  'details-print.css': 7,
  'details.css': 2,
  'favorites.css': 1,
  'legal.css': 8,
  'login-steps.css': 9,
  'otp-input.css': 3,
  'settings-sections.css': 1,
  'shared-base.css': 1,
  'shared-feedback.css': 1,
  'shared-layout.css': 1,
  'shared-onboarding.css': 5,
  'style-hero-split.css': 14,
  'style-hero.css': 2,
  'timeline-responsive.css': 8,
  'timeline.css': 1,
};

const COLOR_RE = /#[0-9a-fA-F]{3,8}\b|rgba?\([^)]*\)/g;

function stripComments(css) {
  return css.replace(/\/\*[\s\S]*?\*\//g, (m) => ' '.repeat(m.length));
}

/** Vrai si la couleur est dans une valeur de déclaration, hors url(). */
function inDeclarationValue(text, start, end) {
  const before = Math.max(text.lastIndexOf('{', start), text.lastIndexOf('}', start), text.lastIndexOf(';', start));
  const segment = text.slice(before + 1, start);
  if (!segment.includes(':')) return false;
  const next = ['{', ';', '}'].map((c) => text.indexOf(c, end)).filter((i) => i !== -1);
  if (!next.length || text[Math.min(...next)] === '{') return false;
  const lastUrl = segment.lastIndexOf('url(');
  return lastUrl === -1 || segment.slice(lastUrl).includes(')');
}

function hardcodedColors(file) {
  const text = stripComments(fs.readFileSync(path.join(CSS_DIR, file), 'utf8'));
  return [...text.matchAll(COLOR_RE)].filter((m) => inDeclarationValue(text, m.index, m.index + m[0].length));
}

const sheets = fs.readdirSync(CSS_DIR)
  .filter((f) => f.endsWith('.css') && !f.endsWith('.min.css') && f !== 'tokens.css');

describe('couleurs en dur hors tokens.css', () => {
  test.each(sheets)('%s : pas de nouvelle couleur en dur', (file) => {
    const found = hardcodedColors(file).map((m) => m[0]);
    const allowed = BASELINE[file] || 0;
    if (found.length > allowed) {
      throw new Error(`${file} : ${found.length} couleurs en dur (plafond ${allowed}) — `
        + `utiliser un jeton de tokens.css : ${found.join(', ')}`);
    }
    expect(found.length).toBeLessThanOrEqual(allowed);
  });

  test('le détecteur ignore les sélecteurs d\'identifiant (#add-airplane-btn)', () => {
    const css = '.x #add-airplane-btn span { color: var(--white); }';
    const text = stripComments(css);
    const hits = [...text.matchAll(COLOR_RE)].filter((m) => inDeclarationValue(text, m.index, m.index + m[0].length));
    expect(hits).toEqual([]);
  });
});
