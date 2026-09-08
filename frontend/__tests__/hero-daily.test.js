/**
 * Tests unitaires — frontend/js/home/hero-daily.js
 *
 * Ce module porte la promesse des deux widgets du hero : « le même contenu pour
 * tout le monde aujourd'hui, un autre demain ». C'est une propriété qui ne se
 * voit pas à l'œil nu sur une page — d'où ces tests, qui vérifient la stabilité
 * du tirage, sa dispersion sur l'année, et le choix des anniversaires.
 */

const daily = require('../js/home/hero-daily');

describe('hero-daily — tirage du jour', () => {
  test('le même jour donne toujours le même index', () => {
    const a = daily.dailyIndex('2026-09-08', 383);
    const b = daily.dailyIndex('2026-09-08', 383);
    expect(a).toBe(b);
  });

  test('deux jours voisins ne donnent pas le même index', () => {
    expect(daily.dailyIndex('2026-09-08', 383))
      .not.toBe(daily.dailyIndex('2026-09-09', 383));
  });

  test("l'index reste dans les bornes de la liste", () => {
    for (let i = 1; i <= 30; i++) {
      const key = `2026-01-${String(i).padStart(2, '0')}`;
      const index = daily.dailyIndex(key, 7);
      expect(index).toBeGreaterThanOrEqual(0);
      expect(index).toBeLessThan(7);
    }
  });

  test('une liste vide ne produit pas de tirage', () => {
    expect(daily.dailyIndex('2026-09-08', 0)).toBe(-1);
    expect(daily.pickDaily([], '2026-09-08')).toBeNull();
    expect(daily.pickDaily(null, '2026-09-08')).toBeNull();
  });

  test('le tirage balaie le catalogue sur une année', () => {
    // Un hash qui retomberait sans cesse sur les mêmes fiches viderait la
    // mécanique de son intérêt : on exige une vraie dispersion. 365 tirages
    // dans 383 cases en remplissent environ 235 (paradoxe des anniversaires),
    // jamais 365 — le seuil est calé sous cette valeur théorique.
    const vus = new Set();
    const debut = Date.UTC(2026, 0, 1);
    for (let j = 0; j < 365; j++) {
      const d = new Date(debut + j * 86400000);
      vus.add(daily.dailyIndex(d.toISOString().slice(0, 10), 383));
    }
    expect(vus.size).toBeGreaterThan(220);
  });

  test('le tirage porte sur l\'identifiant, pas sur la position', () => {
    // Un index modulo la longueur décale toute la liste dès qu'une fiche est
    // ajoutée : l'appareil du jour changeait alors en pleine journée. Le tirage
    // par identifiant ne bouge que si la nouvelle fiche gagne elle-même.
    const catalogue = (n) => Array.from({ length: n }, (_, i) => ({ id: i + 1, name: 'A' + (i + 1) }));
    const avant = daily.pickDaily(catalogue(383), '2026-09-08');
    const apres = daily.pickDaily(catalogue(387), '2026-09-08');
    expect(apres.id).toBe(avant.id);
  });

  test('ajouter des fiches ne rebat pas les tirages des jours suivants', () => {
    const catalogue = (n) => Array.from({ length: n }, (_, i) => ({ id: i + 1 }));
    let changements = 0;
    for (let j = 1; j <= 28; j++) {
      const jour = `2026-10-${String(j).padStart(2, '0')}`;
      if (daily.pickDaily(catalogue(383), jour).id !== daily.pickDaily(catalogue(387), jour).id) {
        changements++;
      }
    }
    // Tolérance : l'ajout de 4 fiches sur 383 peut légitimement en faire gagner
    // une, mais pas rebattre la moitié du calendrier comme le faisait l'index.
    expect(changements).toBeLessThanOrEqual(2);
  });

  test('une liste sans identifiant reste tirable (repli hors ligne)', () => {
    const liste = ['a', 'b', 'c', 'd', 'e'];
    const choix = daily.pickDaily(liste, '2026-09-08');
    expect(liste).toContain(choix);
    expect(daily.pickDaily(liste, '2026-09-08')).toBe(choix);
  });
});

describe('hero-daily — générateur amorcé', () => {
  test('deux générateurs de même graine produisent la même suite', () => {
    const a = daily.seededRandom(daily.hashSeed('2026-09-08:quiz'));
    const b = daily.seededRandom(daily.hashSeed('2026-09-08:quiz'));
    const suiteA = [a(), a(), a()];
    const suiteB = [b(), b(), b()];
    expect(suiteA).toEqual(suiteB);
  });

  test('des graines différentes produisent des suites différentes', () => {
    const a = daily.seededRandom(daily.hashSeed('2026-09-08:quiz'));
    const b = daily.seededRandom(daily.hashSeed('2026-09-09:quiz'));
    expect(a()).not.toBe(b());
  });

  test('les tirages restent dans [0, 1[', () => {
    const rng = daily.seededRandom(daily.hashSeed('graine'));
    for (let i = 0; i < 200; i++) {
      const v = rng();
      expect(v).toBeGreaterThanOrEqual(0);
      expect(v).toBeLessThan(1);
    }
  });

  test('le mélange conserve tous les éléments et se reproduit', () => {
    const source = ['F-15', 'MiG-29', 'Rafale', 'F-22', 'Su-57'];
    const melange = (seed) => daily.shuffleWith(source, daily.seededRandom(seed));
    const a = melange(42);
    const b = melange(42);
    expect(a).toEqual(b);
    expect([...a].sort()).toEqual([...source].sort());
    expect(source).toEqual(['F-15', 'MiG-29', 'Rafale', 'F-22', 'Su-57']); // pas de mutation
  });
});

describe('hero-daily — sélection des anniversaires', () => {
  const entree = (gap, nom) => ({ day_gap: gap, airplane_name: nom });

  test('seuls les anniversaires du jour sont retenus quand il y en a', () => {
    const { list, exact } = daily.selectEphemeris([
      entree(0, 'Jaguar'), entree(0, 'Rafale'), entree(1, 'F-22'), entree(3, 'Mirage'),
    ]);
    expect(exact).toBe(true);
    expect(list.map(e => e.airplane_name)).toEqual(['Jaguar', 'Rafale']);
  });

  test('sans anniversaire du jour, on retient les plus proches', () => {
    const { list, exact } = daily.selectEphemeris([entree(2, 'F-22'), entree(3, 'Mirage')]);
    expect(exact).toBe(false);
    expect(list.map(e => e.airplane_name)).toEqual(['F-22']);
  });

  test('une réponse vide ne casse pas la sélection', () => {
    expect(daily.selectEphemeris([])).toEqual({ list: [], exact: false });
    expect(daily.selectEphemeris(undefined)).toEqual({ list: [], exact: false });
  });
});

describe('hero-daily — mise en forme des dates', () => {
  test('une date ISO devient une date lisible en français', () => {
    expect(daily.formatEventDate('1968-09-08', 'fr')).toMatch(/8.*1968/);
  });

  test('la même date en anglais', () => {
    expect(daily.formatEventDate('1968-09-08', 'en')).toMatch(/8.*1968/);
  });

  test('le jour ne glisse pas selon le fuseau du visiteur', () => {
    // Une date lue en heure locale ferait afficher le 31 décembre à l'ouest de
    // Greenwich. On la lit en UTC : le 1er janvier reste le 1er janvier.
    expect(daily.formatEventDate('1970-01-01', 'fr')).toMatch(/1970/);
    expect(daily.formatEventDate('1970-01-01', 'fr')).toMatch(/^1\b/);
  });

  test('une entrée invalide ne produit pas de texte parasite', () => {
    expect(daily.formatEventDate('', 'fr')).toBe('');
    expect(daily.formatEventDate(null, 'fr')).toBe('');
    expect(daily.formatEventDate('1968', 'fr')).toBe('');
  });
});

describe('hero-daily — date locale de repli', () => {
  test('format YYYY-MM-DD avec zéros de tête', () => {
    expect(daily.localDayKey(new Date(2026, 0, 5))).toBe('2026-01-05');
    expect(daily.localDayKey(new Date(2026, 11, 31))).toBe('2026-12-31');
  });
});
