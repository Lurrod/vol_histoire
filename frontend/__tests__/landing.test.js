/**
 * Tests unitaires — accueil v4.10.0
 *   - js/home/search-suggest.js : correspondance des suggestions de recherche
 *   - js/home/landing.js        : rangement des types de mission en familles
 *   - js/home/text.js           : traduction avec repli français, accord au nombre
 *
 * Les suggestions remplacent une recherche plein texte qui ne fait pas de
 * préfixe (« mira » ne trouve rien côté API) : ce qu'on vérifie ici, c'est
 * qu'un visiteur trouve ce qu'il tape, dans l'ordre où il l'attend.
 */

const suggest = require('../js/home/search-suggest');
const landing = require('../js/home/landing');
const text = require('../js/home/text');

const CATALOG = [
  { id: 1, name: 'Mirage 2000', complete_name: 'Dassault Mirage 2000' },
  { id: 2, name: 'Mirage III', complete_name: 'Dassault Mirage III' },
  { id: 3, name: 'F-16 Fighting Falcon', complete_name: 'General Dynamics F-16 Fighting Falcon' },
  { id: 4, name: 'F-16XL', complete_name: 'General Dynamics F-16XL' },
  { id: 5, name: 'Su-27', complete_name: 'Soukhoï Su-27' },
  { id: 6, name: 'MiG-21', complete_name: 'Mikoyan-Gourevitch MiG-21' },
  { id: 7, name: 'MiG-21 Bison', complete_name: 'Mikoyan-Gourevitch MiG-21 Bison' },
  { id: 8, name: 'Rafale', complete_name: 'Dassault Rafale' },
].map(suggest.toEntry);

const names = (list) => list.map((a) => a.name);

describe('search-suggest — compact', () => {
  test('ignore casse, accents, tirets et espaces', () => {
    expect(suggest.compact('F-16 Fighting Falcon')).toBe('f16fightingfalcon');
    expect(suggest.compact('Soukhoï Su-27')).toBe('soukhoisu27');
    expect(suggest.compact('  Électronique  ')).toBe('electronique');
  });

  test('tolère null et undefined', () => {
    expect(suggest.compact(null)).toBe('');
    expect(suggest.compact(undefined)).toBe('');
  });
});

describe('search-suggest — match', () => {
  test('un début de mot suffit (ce que la recherche plein texte ne sait pas faire)', () => {
    expect(names(suggest.match(CATALOG, 'mira'))).toEqual(['Mirage III', 'Mirage 2000']);
  });

  test('« f16 », « F 16 » et « f-16 » donnent le même résultat', () => {
    const expected = ['F-16XL', 'F-16 Fighting Falcon'];
    expect(names(suggest.match(CATALOG, 'f16'))).toEqual(expected);
    expect(names(suggest.match(CATALOG, 'F 16'))).toEqual(expected);
    expect(names(suggest.match(CATALOG, 'f-16'))).toEqual(expected);
  });

  test('à rang égal, le nom le plus court passe devant', () => {
    expect(names(suggest.match(CATALOG, 'mig21'))).toEqual(['MiG-21', 'MiG-21 Bison']);
  });

  test('un mot du nom passe avant le nom complet (constructeur)', () => {
    expect(names(suggest.match(CATALOG, 'falcon'))).toEqual(['F-16 Fighting Falcon']);
    expect(names(suggest.match(CATALOG, 'dassault'))).toEqual(['Rafale', 'Mirage III', 'Mirage 2000']);
  });

  test('sans correspondance ou saisie vide : liste vide', () => {
    expect(suggest.match(CATALOG, 'zzzz')).toEqual([]);
    expect(suggest.match(CATALOG, '   ')).toEqual([]);
    expect(suggest.match(CATALOG, '-')).toEqual([]);
  });

  test('score : rangs attendus', () => {
    const [mirage] = CATALOG;
    expect(suggest.score(mirage, 'mirage')).toBe(0);
    expect(suggest.score(mirage, '2000')).toBe(1);
    expect(suggest.score(mirage, 'age2')).toBe(2);
    expect(suggest.score(mirage, 'dassault')).toBe(3);
    expect(suggest.score(mirage, 'rafale')).toBe(-1);
    expect(suggest.score(mirage, '')).toBe(-1);
  });
});

describe('landing — groupTypes', () => {
  const COUNTS = {
    Chasseur: 63, Multirôle: 60, 'Appui aérien': 39, Bombardier: 37, Intercepteur: 31,
    Transport: 37, Reconnaissance: 37, Ravitailleur: 9, 'Guerre électronique': 3,
    Entraîneur: 47, Recherche: 11, 'Drone de combat': 9,
  };

  test('trois familles, effectifs additionnés, types triés par effectif', () => {
    const groups = landing.groupTypes(COUNTS);
    expect(groups.map((g) => [g.key, g.total])).toEqual([
      ['family_combat', 230], ['family_support', 86], ['family_training', 67],
    ]);
    expect(groups[0].items[0]).toEqual(['Chasseur', 63]);
    expect(groups[0].items.at(-1)).toEqual(['Intercepteur', 31]);
  });

  test('un type inconnu tombe dans « Autres » au lieu de disparaître', () => {
    const groups = landing.groupTypes({ Chasseur: 5, Hélicoptère: 2 });
    expect(groups.map((g) => g.key)).toEqual(['family_combat', 'family_other']);
    expect(groups[1].items).toEqual([['Hélicoptère', 2]]);
  });

  test('les familles vides et les effectifs nuls sont retirés', () => {
    const groups = landing.groupTypes({ Transport: 4, Chasseur: 0, Inconnu: 0 });
    expect(groups.map((g) => g.key)).toEqual(['family_support']);
  });

  test('chaque type du référentiel appartient à une seule famille', () => {
    const all = landing.FAMILIES.flatMap((f) => f.types);
    expect(new Set(all).size).toBe(all.length);
  });
});

describe('text — tr / trn', () => {
  afterEach(() => { delete window.i18n; });

  test('repli français quand i18n est absent', () => {
    expect(text.tr('search_all', { q: 'mig' })).toBe('Rechercher « mig » dans le hangar');
  });

  test('repli français quand la clé manque (i18n.t renvoie la clé)', () => {
    window.i18n = { t: (key) => key, isLoaded: true };
    expect(text.tr('end_welcome', { name: 'Ada' })).toBe('Bon retour, Ada');
  });

  test('traduction i18n quand elle existe', () => {
    window.i18n = { t: (key, p) => (key === 'home.landing.end_welcome' ? `Welcome back, ${p.name}` : key), isLoaded: true };
    expect(text.tr('end_welcome', { name: 'Ada' })).toBe('Welcome back, Ada');
  });

  test('accord au nombre : _one pour 1, _other sinon', () => {
    expect(text.trn('count', 1)).toBe('1 fiche');
    expect(text.trn('count', 89)).toBe('89 fiches');
    expect(text.trn('end_favs', 7)).toBe('Voir mes 7 favoris');
  });

  test('chaque repli français existe dans locales/fr.json', () => {
    const fr = require('../locales/fr.json').home.landing;
    Object.keys(text.FALLBACK_FR).forEach((k) => expect(fr[k]).toBe(text.FALLBACK_FR[k]));
  });

  test('fr.json et en.json déclarent les mêmes clés home.landing', () => {
    const fr = Object.keys(require('../locales/fr.json').home.landing).sort();
    const en = Object.keys(require('../locales/en.json').home.landing).sort();
    expect(en).toEqual(fr);
  });

  test('whenReady résout dès que la langue est chargée', async () => {
    window.i18n = { t: (k) => k, isLoaded: false };
    setTimeout(() => { window.i18n.isLoaded = true; }, 30);
    await expect(text.whenReady(1000)).resolves.toBeUndefined();
  });

  test('whenReady ne bloque pas au-delà du délai', async () => {
    window.i18n = { t: (k) => k, isLoaded: false };
    const start = Date.now();
    await text.whenReady(60);
    expect(Date.now() - start).toBeLessThan(1000);
  });
});
