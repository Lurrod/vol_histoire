/**
 * Tests — frontend/js/details/key-dates.js : dates clés de la fiche.
 *
 * La base ne connaît souvent que le mois (date au 1er) ou l'année (date au
 * 1er janvier) : la fiche n'invente pas une précision qui n'existe pas, et
 * l'écart entre deux jalons suit la précision la plus faible des deux.
 */

const dict = {
  'details.not_specified': 'Non précisé',
  'details.span_year': '{n} an',
  'details.span_years': '{n} ans',
  'details.span_month': '{n} mois',
  'details.span_months': '{n} mois',
  'details.span_and': '{a} et {b}',
  'details.span_after': '{span} plus tard',
  'details.span_after_approx': 'environ {span} plus tard',
};
global.i18n = {
  currentLang: 'fr',
  t: (k, p = {}) => Object.entries(p).reduce((s, [key, v]) => s.replace(`{${key}}`, v), dict[k] || k),
};
window.VH = {};
const kd = require('../js/details/key-dates');

describe('precision', () => {
  test('jour connu, mois seul (1er du mois), année seule (1er janvier)', () => {
    expect(kd.parse('1986-07-04T00:00:00').precision).toBe('day');
    expect(kd.parse('2001-05-01T00:00:00').precision).toBe('month');
    expect(kd.parse('1982-01-01T00:00:00').precision).toBe('year');
  });

  test('date absente ou invalide : null', () => {
    expect(kd.parse(null)).toBeNull();
    expect(kd.parse('pas une date')).toBeNull();
  });
});

describe('format', () => {
  test('fr : jour, mois, année selon la précision', () => {
    expect(kd.format('1986-07-04T00:00:00', 'fr')).toBe('4 juillet 1986');
    expect(kd.format('2001-05-01T00:00:00', 'fr')).toBe('mai 2001');
    expect(kd.format('1982-01-01T00:00:00', 'fr')).toBe('1982');
  });

  test('en : format britannique', () => {
    expect(kd.format('1986-07-04T00:00:00', 'en')).toBe('4 July 1986');
    expect(kd.format('2001-05-01T00:00:00', 'en')).toBe('May 2001');
  });

  test('absente : « non précisé »', () => {
    expect(kd.format(null, 'fr')).toBe('Non précisé');
  });
});

describe('écart entre deux jalons', () => {
  test('années et mois, au jour près', () => {
    expect(kd.span('1982-12-15T00:00:00', '1986-07-04T00:00:00')).toEqual({ years: 3, months: 6, approx: false });
  });

  test('précision au mois : mois entiers', () => {
    expect(kd.span('1986-07-04T00:00:00', '2001-05-01T00:00:00')).toEqual({ years: 14, months: 10, approx: false });
  });

  test('une des deux à l\'année : années seules, approché', () => {
    expect(kd.span('1982-01-01T00:00:00', '1986-07-04T00:00:00')).toEqual({ years: 4, months: 0, approx: true });
  });

  test('ordre inversé, date manquante ou écart nul : rien', () => {
    expect(kd.span('1990-01-04T00:00:00', '1986-07-04T00:00:00')).toBeNull();
    expect(kd.span(null, '1986-07-04T00:00:00')).toBeNull();
    expect(kd.span('1986-07-04T00:00:00', '1986-07-20T00:00:00')).toBeNull();
  });

  test('texte : singulier, pluriel, « et », « environ »', () => {
    expect(kd.spanText({ years: 1, months: 0, approx: false })).toBe('1 an plus tard');
    expect(kd.spanText({ years: 3, months: 6, approx: false })).toBe('3 ans et 6 mois plus tard');
    expect(kd.spanText({ years: 0, months: 7, approx: false })).toBe('7 mois plus tard');
    expect(kd.spanText({ years: 4, months: 0, approx: true })).toBe('environ 4 ans plus tard');
  });
});

describe('render', () => {
  beforeEach(() => {
    document.body.innerHTML = ['date-concept', 'date-first-fly', 'date-operational'].map(id =>
      `<li id="${id}"><p class="timeline-date">-</p><p class="milestone-span" hidden></p></li>`).join('');
  });

  test('dates posées, écart affiché sous les jalons 2 et 3', () => {
    kd.render({ date_concept: '1982-12-15T00:00:00', date_first_fly: '1986-07-04T00:00:00', date_operationel: '2001-05-01T00:00:00' });
    expect(document.querySelector('#date-operational .timeline-date').textContent).toBe('mai 2001');
    expect(document.querySelector('#date-concept .milestone-span').hidden).toBe(true);
    const second = document.querySelector('#date-first-fly .milestone-span');
    expect(second.hidden).toBe(false);
    expect(second.textContent).toBe('3 ans et 6 mois plus tard');
    expect(document.querySelector('#date-operational .milestone-span').textContent).toBe('14 ans et 10 mois plus tard');
  });

  test('jalon précédent absent : l\'écart se mesure depuis le dernier connu', () => {
    kd.render({ date_concept: '1982-12-15T00:00:00', date_first_fly: null, date_operationel: '1986-12-20T00:00:00' });
    expect(document.querySelector('#date-first-fly .milestone-span').hidden).toBe(true);
    expect(document.querySelector('#date-operational .milestone-span').textContent).toBe('4 ans plus tard');
  });

  test('rendu répété (changement de langue) : un écart disparu est masqué', () => {
    kd.render({ date_concept: '1982-12-15T00:00:00', date_first_fly: '1986-07-04T00:00:00' });
    kd.render({ date_concept: null, date_first_fly: '1986-07-04T00:00:00' });
    expect(document.querySelector('#date-first-fly .milestone-span').hidden).toBe(true);
  });
});

describe('dates de calendrier (« AAAA-MM-JJ », format de l’API)', () => {
  test('lues chiffre par chiffre et formatées en UTC : le jour ne recule pas', () => {
    expect(kd.format('1974-12-23', 'fr')).toBe('23 décembre 1974');
    expect(kd.format('1986-10-01', 'fr')).toBe('octobre 1986');
    expect(kd.format('1978-01-01', 'fr')).toBe('1978');
  });

  test('ancien format (minuit heure de Paris en UTC) : même résultat', () => {
    expect(kd.format('1986-09-30T23:00:00.000Z', 'fr')).toBe('octobre 1986');
    expect(kd.format('1986-07-03T22:00:00.000Z', 'fr')).toBe('4 juillet 1986');
    expect(kd.format('1977-12-31T23:00:00.000Z', 'fr')).toBe('1978');
  });
});
