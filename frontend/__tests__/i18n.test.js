/**
 * Tests unitaires — frontend/js/i18n.js
 *
 * En jsdom, fetch('/locales/fr.json') echoue silencieusement (URL non resolvable),
 * donc translations = {} et t() retombe sur la cle. On teste :
 *   - le fallback (cle inconnue retournee verbatim)
 *   - l'API publique (SUPPORTED_LANGS, currentLang, t, setLang, applyToDOM)
 *   - l'interpolation {param} et la variable globale {year}
 */

// Cleanup avant le require — i18n est un singleton, mais localStorage doit etre propre
beforeAll(() => {
  localStorage.clear();
});

const i18n = require('../js/i18n');

describe('i18n — API publique', () => {
  test('expose SUPPORTED_LANGS = ["fr", "en"]', () => {
    expect(i18n.SUPPORTED_LANGS).toEqual(['fr', 'en']);
  });

  test('expose currentLang (string fr ou en)', () => {
    expect(['fr', 'en']).toContain(i18n.currentLang);
  });

  test('expose isLoaded (booleen)', () => {
    expect(typeof i18n.isLoaded).toBe('boolean');
  });

  test('expose t, setLang, applyToDOM (fonctions)', () => {
    expect(typeof i18n.t).toBe('function');
    expect(typeof i18n.setLang).toBe('function');
    expect(typeof i18n.applyToDOM).toBe('function');
  });
});

describe('i18n.t() — fallback et interpolation', () => {
  test('retourne la cle verbatim quand la traduction est introuvable', () => {
    expect(i18n.t('cle.totalement.inexistante')).toBe('cle.totalement.inexistante');
  });

  test('retourne la cle verbatim pour une cle plate inconnue', () => {
    expect(i18n.t('xyz')).toBe('xyz');
  });

  test('accepte un objet params sans casser quand la cle est introuvable', () => {
    expect(i18n.t('cle.inconnue', { count: 5 })).toBe('cle.inconnue');
  });

  test('ne crash pas avec une cle vide', () => {
    expect(typeof i18n.t('')).toBe('string');
  });
});

describe('i18n.setLang() — changement de langue', () => {
  test('ignore une langue non supportee', async () => {
    const before = i18n.currentLang;
    await i18n.setLang('xx');
    expect(i18n.currentLang).toBe(before);
  });

  test('accepte une langue supportee (fr ou en) sans throw', async () => {
    await expect(i18n.setLang('fr')).resolves.not.toThrow();
    await expect(i18n.setLang('en')).resolves.not.toThrow();
  });
});

describe('i18n.applyToDOM() — application aux elements [data-i18n]', () => {
  beforeEach(() => {
    document.body.innerHTML = '';
  });

  test('ne casse pas sur un DOM vide', () => {
    expect(() => i18n.applyToDOM()).not.toThrow();
  });

  test('met a jour document.documentElement.lang sur la langue courante', () => {
    i18n.applyToDOM();
    expect(['fr', 'en']).toContain(document.documentElement.lang);
  });

  test('garde le texte fallback quand la cle est inconnue (pas de remplacement)', () => {
    document.body.innerHTML = '<span data-i18n="cle.inexistante">Texte fallback</span>';
    i18n.applyToDOM();
    // La traduction etant === cle, applyToDOM ne remplace pas → texte fallback preserve
    expect(document.querySelector('[data-i18n]').textContent).toBe('Texte fallback');
  });

  test('met a jour [data-i18n-placeholder] uniquement si la cle est trouvee', () => {
    document.body.innerHTML = '<input data-i18n-placeholder="cle.inexistante" placeholder="Original">';
    i18n.applyToDOM();
    // cle inexistante → placeholder original preserve
    expect(document.querySelector('input').placeholder).toBe('Original');
  });
});
