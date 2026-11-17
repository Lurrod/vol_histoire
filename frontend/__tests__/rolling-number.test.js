/**
 * Tests unitaires — frontend/js/shared/rolling-number.js
 *
 * Compteur « odomètre » : chaque chiffre est une colonne qui glisse de
 * l'ancienne valeur à la nouvelle (data-d, transition CSS), au lieu de
 * recompter depuis zéro. Sous jsdom aucune durée n'existe : les colonnes
 * qui sortent sont retirées aussitôt (VH.motion.exit).
 */
require('../js/shared/motion');
require('../js/shared/rolling-number');

const { set } = window.VH.rollingNumber;

const cols = (el) => [...el.querySelectorAll('.t-roll-col:not(.is-leaving)')];
const digits = (el) => cols(el).map(c => c.dataset.d).join('');

let el;
beforeEach(() => {
  document.body.innerHTML = '<span class="data-number" id="n">0</span>';
  el = document.getElementById('n');
});

describe('premier rendu', () => {
  test('une colonne par chiffre, texte accessible séparé, colonnes masquées aux lecteurs d\'écran', () => {
    set(el, 123, 'fr');
    expect(digits(el)).toBe('123');
    expect(el.querySelector('.sr-only').textContent).toBe('123');
    expect(el.querySelector('.t-roll-cols').getAttribute('aria-hidden')).toBe('true');
    // Chaque colonne porte la bande complète : vide + 0 à 9.
    expect(cols(el)[0].querySelectorAll('.t-roll-strip > span')).toHaveLength(11);
  });

  test('le texte provisoire du HTML (« 0 ») est remplacé', () => {
    set(el, 7, 'fr');
    expect(el.textContent.replace(/\s/g, '')).not.toMatch(/^0/);
    expect(digits(el)).toBe('7');
  });
});

describe('mises à jour', () => {
  test('même nombre de chiffres : les colonnes sont réutilisées, seule la valeur glisse', () => {
    set(el, 123, 'fr');
    const before = cols(el);
    set(el, 128, 'fr');
    const after = cols(el);
    expect(digits(el)).toBe('128');
    expect(after[0]).toBe(before[0]);
    expect(after[2]).toBe(before[2]);
    expect(el.querySelector('.sr-only').textContent).toBe('128');
  });

  test('99 → 100 : une colonne apparaît à gauche, unités et dizaines restent les mêmes', () => {
    set(el, 99, 'fr');
    const [tens, units] = cols(el);
    set(el, 100, 'fr');
    const after = cols(el);
    expect(digits(el)).toBe('100');
    expect(after).toHaveLength(3);
    expect(after[1]).toBe(tens);
    expect(after[2]).toBe(units);
  });

  test('les colonnes conservées ne sont jamais retirées puis réinsérées (sinon la transition saute)', async () => {
    set(el, 99, 'fr');
    const box = el.querySelector('.t-roll-cols');
    const records = [];
    const mo = new MutationObserver(r => records.push(...r));
    mo.observe(box, { childList: true });
    set(el, 98, 'fr');       // même largeur : aucune insertion
    set(el, 100, 'fr');      // une colonne entre à gauche, seule
    await Promise.resolve();
    mo.disconnect();
    const removed = records.flatMap(r => [...r.removedNodes]);
    const added = records.flatMap(r => [...r.addedNodes]);
    expect(removed).toHaveLength(0);
    expect(added).toHaveLength(1);
    expect(added[0]).toBe(cols(el)[0]);
  });

  test('colonnes ajoutées à gauche : derrière les colonnes qui sortent, devant les conservées', () => {
    set(el, 5, 'fr');
    const units = cols(el)[0];
    set(el, 1250, 'en');     // « 1,250 » : trois colonnes et un séparateur entrent
    const slots = [...el.querySelector('.t-roll-cols').children];
    expect(slots.map(s => s.className.includes('sep') ? ',' : s.dataset.d).join('')).toBe('1,250');
    expect(slots[slots.length - 1]).toBe(units);
  });

  test('100 → 99 : la colonne de tête se vide puis disparaît', () => {
    set(el, 100, 'fr');
    set(el, 99, 'fr');
    expect(digits(el)).toBe('99');
    expect(el.querySelectorAll('.t-roll-col')).toHaveLength(2);
  });

  test('séparateur de milliers selon la langue, posé comme un caractère fixe', () => {
    set(el, 1234, 'en');
    expect(digits(el)).toBe('1234');
    expect(el.querySelector('.t-roll-sep').textContent).toBe(',');
    set(el, 987, 'en');
    expect(digits(el)).toBe('987');
    expect(el.querySelector('.t-roll-sep')).toBeNull();
  });

  test('valeur identique : rien n\'est recréé', () => {
    set(el, 42, 'fr');
    const before = cols(el);
    set(el, 42, 'fr');
    expect(cols(el)).toEqual(before);
  });
});

describe('robustesse', () => {
  test('élément absent ou valeur non numérique : rien ne lève, rien ne change', () => {
    expect(() => set(null, 3)).not.toThrow();
    set(el, 5, 'fr');
    set(el, NaN, 'fr');
    set(el, undefined, 'fr');
    expect(digits(el)).toBe('5');
  });

  test('sans langue : celle du document, puis le français', () => {
    document.documentElement.lang = 'en';
    set(el, 2500);
    expect(el.querySelector('.t-roll-sep').textContent).toBe(',');
    document.documentElement.lang = '';
  });
});
