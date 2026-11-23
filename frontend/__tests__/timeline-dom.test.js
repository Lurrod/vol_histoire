/**
 * Tests DOM — frontend/js/timeline/{render,observers}.js et timeline.js
 * Rendu des chapitres (appareils marquants, piste année par année, pastilles
 * de prototype, conflits et leurs barres de durée, message de filtre vide),
 * suivi de l'année pendant le défilement, révélations, et démarrage de la
 * page (filtre, langue, ancre, erreurs).
 */
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
const fakeT = (key) => key;
const I18N = { currentLang: 'fr', t: fakeT, isLoaded: true };
window.i18n = I18N;
window.VH = {
  shared: {
    buildDetailsPath: (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`,
    picture: {
      pictureHtml: (src, o) => `<picture data-src="${src}"><img alt="${o.alt}"></picture>`,
      thumbHtml: (src) => `<picture class="thumb" data-src="${src}"></picture>`,
    },
  },
};

require('./helpers/motion-env').loadMotion();
const util = require('../js/timeline/util');
const era = require('../js/timeline/era');
require('../js/timeline/data');
const ruler = require('../js/timeline/ruler');
const render = require('../js/timeline/render');
require('../js/timeline/lens');
const observers = require('../js/timeline/observers');
require('../js/timeline/keyboard');

const ROLLING = window.VH.rollingNumber;
const realAdd = window.EventTarget.prototype.addEventListener;

/* ---------------------------------------------------------------------- */
/* Jeu de données                                                          */
/* ---------------------------------------------------------------------- */

const plane = (id, extra = {}) => ({
  id, name: `A${id}`, image_url: `/assets/airplanes/a${id}.jpg`, year: 1960, year_source: 'service',
  status: 'En service', units_built: null, country_name: 'URSS', country_name_en: 'USSR',
  generation: 2, type_name: 'Chasseur', type_name_en: 'Fighter', ...extra,
});

const DECADES = [
  {
    decade: 1950,
    events: [{
      kind: 'war', title_fr: 'Corée', body_fr: 'Premiers duels <jets>', quote_author_fr: 'Un pilote',
      event_date: '1950-06-25', airplane: { id: 7, name: 'MiG-15', image_url: '/assets/airplanes/mig15.jpg' },
    }],
    aircraft: [
      plane(7, { name: 'MiG-15', year: 1950, units_built: 10, generation: 1 }),
      plane(1, {
        name: 'F-86 Sabre', name_en: 'F-86 Sabre (EN)', year: 1953, units_built: 9000, generation: 1,
        country_name: 'États-Unis', country_name_en: 'United States',
      }),
      plane(4, { name: 'Sans année', year: undefined, units_built: 5, generation: null, image_url: null }),
      plane(3, { name: 'X <script>', year: 1955, units_built: null, image_url: null, type_name: 'Bombardier', type_name_en: 'Bomber' }),
    ],
  },
  {
    decade: 1960,
    events: [],
    aircraft: [
      ...Array.from({ length: 8 }, (_, i) => plane(101 + i, { year: 1960 + i, units_built: 1000 - i })),
      plane(109, { year: 1961, units_built: 0, year_source: 'first_flight', status: 'Annulé' }),
      plane(110, { year: 1961, year_source: 'first_flight', status: 'En développement', image_url: null }),
      plane(111, { year: 1964, year_source: 'first_flight', status: 'Retiré' }),
    ],
  },
  { decade: 1990, events: [{ title_fr: 'Sans date' }], aircraft: [] },
];

const WARS = [
  { id: 1, slug: 'guerre-de-coree', name: 'Guerre de Corée', name_en: 'Korean War', start_year: 1950, end_year: 1953, era_decade: 1950, aircraft_ids: [7, 1] },
  { id: 3, slug: 'suez', name: 'Crise de <Suez>', start_year: 1956, end_year: 1956, era_decade: 1950, aircraft_ids: [7] },
  { id: 2, slug: 'viet nam', name: 'Guerre du Viêt Nam', start_year: 1965, end_year: 1975, era_decade: 1960, aircraft_ids: [101, 102] },
  { id: 4, slug: 'ouverte', name: 'Guerre ouverte', start_year: 1991, end_year: null, era_decade: 1990 },
];

/* IntersectionObserver factice : garde les instances pour les déclencher. */
let ioInstances = [];
class FakeIO {
  constructor(cb, opts) {
    this.cb = cb; this.opts = opts; this.targets = [];
    this.disconnect = jest.fn();
    ioInstances.push(this);
  }
  observe(t) { this.targets.push(t); }
  unobserve(t) { this.targets = this.targets.filter(x => x !== t); }
  fire(entries) { this.cb(entries); }
}

function page() {
  document.body.innerHTML = `
    <header class="site-header"></header>
    <section id="tl-intro">
      <span id="tl-stat-events">0</span><span id="tl-stat-aircraft">0</span><span id="tl-stat-wars">0</span>
    </section>
    <div id="tl-bar" class="tl-bar">
      <span id="tl-bar-year">1945</span><span id="tl-bar-era"></span>
      <nav id="tl-ruler"></nav>
      <button type="button" id="tl-lens-toggle" aria-expanded="false"></button>
      <div id="tl-lens">
        <select id="tl-lens-nation"><option value="">Toutes les nations</option></select>
        <select id="tl-lens-type"><option value="">Tous les types</option></select>
        <button type="button" id="tl-lens-reset" hidden></button>
      </div>
      <p id="tl-lens-status"></p>
    </div>
    <div id="tl-chapters"></div>
    <div id="tl-loading"></div>`;
}

// Écouteurs posés sur window pendant un test (défilement, clavier, langue) :
// retirés ensuite pour qu'un démarrage n'agisse pas sur le suivant.
const windowListeners = [];

beforeEach(() => {
  page();
  document.body.removeAttribute('style');
  document.body.className = '';
  ioInstances = [];
  window.IntersectionObserver = global.IntersectionObserver = FakeIO;
  window.scrollTo = jest.fn();
  window.innerHeight = 800;
  global.requestAnimationFrame = window.requestAnimationFrame = jest.fn();
  window.i18n = I18N;
  I18N.currentLang = 'fr';
  I18N.t = fakeT;
  window.VH.rollingNumber = ROLLING;
  window.history.replaceState(null, '', '/timeline');
  ruler._reset();
  observers._reset();
  jest.spyOn(window, 'addEventListener').mockImplementation((type, fn, opts) => {
    windowListeners.push([type, fn]);
    realAdd.call(window, type, fn, opts);
  });
});

afterEach(() => {
  jest.restoreAllMocks();
  windowListeners.splice(0).forEach(([type, fn]) => window.removeEventListener(type, fn));
});

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => [...document.querySelectorAll(sel)];
const chapter = (decade) => document.getElementById(`ch-${decade}`);

/* ====================================================================== */
/* render                                                                 */
/* ====================================================================== */

describe('render — dates clés des conflits (dépliant)', () => {
  const SIX = {
    id: 9, slug: 'guerre-des-six-jours', name: 'Guerre des Six Jours', name_en: 'Six-Day War',
    start_year: 1967, end_year: 1967, era_decade: 1960, aircraft_ids: [101],
    events: [
      { date: '1967-06-05', precision: 'day', title: 'Opération <Moked> *Focus*', title_en: 'Operation Moked' },
      { date: '1967-06-01', precision: 'month', title: 'Mobilisation', title_en: null },
    ],
  };

  afterEach(() => { I18N.currentLang = 'fr'; });

  test('dépliant natif fermé, nombre de dates, dates selon la précision, titres échappés', () => {
    render.renderChapters(DECADES, [SIX]);
    const details = document.querySelector('.tl-conflict .tl-conflict-dates');
    expect(details.tagName).toBe('DETAILS');
    expect(details.open).toBe(false);
    expect(details.querySelector('summary').textContent).toContain('2');
    const items = [...details.querySelectorAll('li')];
    expect(items).toHaveLength(2);
    expect(items[0].querySelector('time').getAttribute('datetime')).toBe('1967-06-05');
    expect(items[0].querySelector('time').textContent).toBe('5 juin 1967');
    expect(items[1].querySelector('time').textContent).toBe('juin 1967');
    expect(items[0].textContent).toContain('Opération <Moked> Focus');
    expect(items[0].querySelector('em').textContent).toBe('Focus');
    expect(items[0].querySelector('moked')).toBeNull();
    expect(details.querySelector('a').getAttribute('href')).toBe('/conflits/guerre-des-six-jours');
  });

  test('anglais : titre anglais, repli sur le français', () => {
    I18N.currentLang = 'en';
    render.renderChapters(DECADES, [SIX]);
    const items = [...document.querySelectorAll('.tl-conflict-dates li')];
    expect(items[0].textContent).toContain('Operation Moked');
    expect(items[0].querySelector('time').textContent).toBe('5 June 1967');
    expect(items[1].textContent).toContain('Mobilisation');
  });

  test('conflit sans date clé : pas de dépliant', () => {
    render.renderChapters(DECADES, [{ ...SIX, events: [] }, { ...SIX, id: 10, events: undefined }]);
    expect(document.querySelector('.tl-conflict-dates')).toBeNull();
  });
});

describe('render — chapitres', () => {
  test('un chapitre par décennie, porteur de data-decade, sans style en ligne', () => {
    render.renderChapters(DECADES, WARS);
    const chapters = $$('.tl-chapter');
    expect(chapters.map(c => c.dataset.decade)).toEqual(['1950', '1960', '1990']);
    chapters.forEach(c => {
      expect(c.getAttribute('style')).toBeNull();
      expect(c.id).toBe(`ch-${c.dataset.decade}`);
      expect(c.getAttribute('aria-labelledby')).toBe(`ch-${c.dataset.decade}-title`);
    });
  });

  test('title card : repli tant que la langue n\'est pas chargée, jamais la clé', () => {
    render.renderChapters(DECADES);
    const second = chapter(1960);
    expect(second.querySelector('.tl-title-chapter').textContent).toBe('Chapitre · 02');
    expect(second.querySelector('.tl-title-span').textContent).toBe('1960–1969');
    expect(second.querySelector('.tl-title-decade-num').textContent).toBe('1960');
    expect(second.querySelector('.tl-title-era').textContent).toBe('');
    expect(second.querySelector('.tl-narrative .tl-section-label').textContent).toBe('Le récit');
    expect(second.querySelector('.tl-narrative-text').textContent).toBe('');
  });

  test('title card : textes d\'ère traduits ; le chapitre 1940 commence en 1945', () => {
    I18N.t = (key) => `T:${key}`;
    render.renderChapters([{ decade: 1940, events: [{ title_fr: 'x' }], aircraft: [] }]);
    expect($('.tl-title-span').textContent).toBe('1945–1949');
    expect($('.tl-title-label').textContent).toBe('T:timeline.era_1940_label2');
    expect($('.tl-title-era').textContent).toBe('T:timeline.era_1940_title2');
    expect($('.tl-narrative-text').textContent).toBe('T:timeline.era_1940_narrative');
  });

  test('blocs événements, conflits et appareils absents quand vides', () => {
    render.renderChapters(DECADES, []);
    expect(chapter(1950).querySelector('.tl-events strong').textContent).toBe('1');
    expect(chapter(1950).querySelector('.tl-aircraft-section > .tl-section-label strong').textContent).toBe('4');
    expect(chapter(1960).querySelector('.tl-events')).toBeNull();
    expect(chapter(1990).querySelector('.tl-aircraft-section')).toBeNull();
    expect($('.tl-conflicts')).toBeNull();
  });

  test('carte d\'événement : genre, date, citation, appareil lié, texte échappé', () => {
    render.renderChapters(DECADES);
    const ev = $('.tl-event');
    expect(ev.classList.contains('tl-event-kind-war')).toBe(true);
    expect(ev.dataset.idx).toBe('0');
    expect(ev.dataset.year).toBe('1950');
    expect(ev.querySelector('.tl-event-year').textContent).toBe('1950');
    expect(ev.querySelector('.tl-event-kind').textContent).toBe('');
    expect(ev.querySelector('.tl-event-date').textContent).toMatch(/25 juin 1950/);
    expect(ev.querySelector('.tl-event-title').textContent).toBe('Corée');
    expect(ev.querySelector('.tl-event-text').textContent).toBe('Premiers duels <jets>');
    expect(ev.querySelector('.tl-event-author').textContent).toBe('— Un pilote');
    expect(ev.querySelector('.tl-event-plane').getAttribute('href')).toBe('/details/mig-15-7');
    expect(ev.querySelector('.tl-event-plane picture')).not.toBeNull();
    expect(ev.querySelector('.tl-event-plane-cta').textContent.trim()).toBe('Lire la fiche');
  });

  test('événement sans genre, date, auteur ni appareil ; appareil lié sans image', () => {
    render.renderChapters([
      ...DECADES.slice(2),
      { decade: 2000, events: [{ title_fr: 'T', airplane: { id: 9, name: 'Drone' } }], aircraft: [] },
    ]);
    const [bare, noImg] = $$('.tl-event');
    expect(bare.classList.contains('tl-event-kind-milestone')).toBe(true);
    expect(bare.querySelector('.tl-event-year').textContent).toBe('');
    expect(bare.querySelector('.tl-event-author')).toBeNull();
    expect(bare.querySelector('.tl-event-plane')).toBeNull();
    expect(noImg.querySelector('.tl-event-plane')).not.toBeNull();
    expect(noImg.querySelector('.tl-event-plane picture')).toBeNull();
  });

  test('renderEventCard : genre neutralisé dans la classe', () => {
    document.body.innerHTML = render.renderEventCard({ kind: 'x" onclick="y', title_fr: 'T' }, 3);
    const ev = $('.tl-event');
    expect(ev.hasAttribute('onclick')).toBe(false);
    expect(ev.dataset.idx).toBe('3');
  });

  test('sans conteneur, le rendu ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => { render.renderChapters(DECADES, WARS); render.renderMessage('x'); }).not.toThrow();
  });

  test('renderChapters : conflits et filtre facultatifs', () => {
    render.renderChapters(DECADES);
    expect($$('.tl-chapter')).toHaveLength(3);
    expect($('.tl-conflicts')).toBeNull();
  });

  test('renderMessage remplace les chapitres par un message échappé', () => {
    render.renderChapters(DECADES);
    render.renderMessage('<b>vide</b>');
    expect($('.tl-chapter')).toBeNull();
    expect($('#tl-chapters .tl-empty-msg').textContent).toBe('<b>vide</b>');
    expect($('#tl-chapters b')).toBeNull();
  });
});

describe('render — appareils', () => {
  test('aircraftTag : rien à la mise en service, sinon annulé / en développement / 1er vol', () => {
    expect(render.aircraftTag(plane(1))).toBe('');
    expect(render.aircraftTag(plane(1, { year_source: 'first_flight', status: 'Annulé' }))).toBe('Annulé');
    expect(render.aircraftTag(plane(1, { year_source: 'first_flight', status: 'En développement' }))).toBe('En développement');
    expect(render.aircraftTag(plane(1, { year_source: 'first_flight', status: 'En service' }))).toBe('1er vol');
    I18N.t = (key) => `T:${key}`;
    expect(render.aircraftTag(plane(1, { year_source: 'first_flight', status: 'Annulé' }))).toBe('T:timeline.tag_cancelled');
    expect(render.aircraftTag(plane(1, { year_source: 'first_flight' }))).toBe('T:timeline.tag_first_flight');
  });

  test('appareils marquants (événement d\'abord, puis production), dans l\'ordre d\'origine', () => {
    render.renderChapters(DECADES);
    const cards = $$('#ch-1950 .tl-plane-card');
    expect(cards.map(c => c.getAttribute('href'))).toEqual([
      '/details/mig-15-7', '/details/f-86-sabre-1', '/details/sans-ann-e-4',
    ]);
    expect($$('#ch-1960 .tl-plane-card')).toHaveLength(8);
    expect($$('#ch-1960 .tl-plane-card').map(c => c.querySelector('.tl-plane-year').textContent))
      .toEqual(['1960', '1961', '1962', '1963', '1964', '1965', '1966', '1967']);
  });

  test('carte d\'appareil : année, génération, image, nom et pays selon la langue', () => {
    I18N.currentLang = 'en';
    render.renderChapters(DECADES);
    const card = $$('#ch-1950 .tl-plane-card')[1];
    expect(card.classList.contains('is-proto')).toBe(false);
    expect(card.querySelector('.tl-plane-year').textContent).toBe('1953');
    expect(card.querySelector('.tl-plane-gen').textContent).toBe('G1');
    expect(card.querySelector('picture').dataset.src).toBe('/assets/airplanes/a1.jpg');
    expect(card.querySelector('img').getAttribute('alt')).toBe('F-86 Sabre (EN)');
    expect(card.querySelector('.tl-plane-name').textContent).toBe('F-86 Sabre (EN)');
    expect(card.querySelector('.tl-plane-country').textContent).toBe('United States');
  });

  test('carte d\'appareil minimale : tiret, ni génération ni image', () => {
    render.renderChapters(DECADES);
    const card = $$('#ch-1950 .tl-plane-card')[2];
    expect(card.querySelector('.tl-plane-year').textContent).toBe('—');
    expect(card.querySelector('.tl-plane-gen')).toBeNull();
    expect(card.querySelector('picture')).toBeNull();
  });

  test('carte d\'un prototype : pastille et classe is-proto', () => {
    document.body.innerHTML = render.renderAircraftCard(plane(5, { year_source: 'first_flight', status: 'Annulé', name: '<i>Arrow</i>' }));
    const card = $('.tl-plane-card');
    expect(card.classList.contains('is-proto')).toBe(true);
    expect(card.querySelector('.tl-plane-tag').textContent).toBe('Annulé');
    expect(card.querySelector('.tl-plane-country').textContent).toBe('URSS · Annulé');
    expect(card.querySelector('.tl-plane-name').textContent).toBe('<i>Arrow</i>');
    expect(card.querySelector('i')).toBeNull();
  });

  test('piste année par année : les autres appareils, groupés par année', () => {
    render.renderChapters(DECADES);
    const runway = chapter(1960).querySelector('.tl-runway');
    expect(runway.querySelector('.tl-sub-label').textContent).toBe('Année par année');
    const rows = [...runway.querySelectorAll('.tl-runway-row')];
    expect(rows.map(r => r.dataset.year)).toEqual(['1961', '1964']);
    expect(rows.map(r => r.querySelector('.tl-runway-year').textContent)).toEqual(['1961', '1964']);
    expect(rows[0].querySelectorAll('.tl-chip')).toHaveLength(2);
    // 1950 : seul l'appareil sans production passe dans la piste.
    expect([...chapter(1950).querySelectorAll('.tl-runway .tl-chip-name')].map(n => n.textContent)).toEqual(['X <script>']);
    expect(chapter(1950).querySelector('.tl-runway script')).toBeNull();
  });

  test('pastilles de la piste : vignette, pays, étiquette de prototype', () => {
    render.renderChapters(DECADES);
    const chips = [...chapter(1960).querySelectorAll('.tl-chip')];
    const [cancelled, inDev, firstFlight] = chips;
    expect(cancelled.getAttribute('href')).toBe('/details/a109-109');
    expect(cancelled.classList.contains('is-proto')).toBe(true);
    expect(cancelled.querySelector('.tl-chip-img picture.thumb').dataset.src).toBe('/assets/airplanes/a109.jpg');
    expect(cancelled.querySelector('.tl-chip-img').getAttribute('aria-hidden')).toBe('true');
    expect(cancelled.querySelector('.tl-chip-tag').textContent).toBe('Annulé');
    expect(cancelled.querySelector('.tl-chip-meta').textContent).toBe('URSS · Annulé');
    expect(inDev.querySelector('.tl-chip-img').innerHTML).toBe('');
    expect(inDev.querySelector('.tl-chip-tag').textContent).toBe('En développement');
    expect(firstFlight.querySelector('.tl-chip-tag').textContent).toBe('1er vol');

    const plain = chapter(1950).querySelector('.tl-chip');
    expect(plain.classList.contains('is-proto')).toBe(false);
    expect(plain.querySelector('.tl-chip-tag')).toBeNull();
    expect(plain.querySelector('.tl-chip-meta').textContent).toBe('URSS');
  });

  test('aucune piste quand tous les appareils sont marquants', () => {
    render.renderChapters([{ decade: 1970, events: [], aircraft: [plane(1, { units_built: 3 })] }]);
    expect($('.tl-runway')).toBeNull();
    expect($$('.tl-plane-card')).toHaveLength(1);
  });

  test('lien vers le hangar : décennie seule, puis avec le filtre courant', () => {
    render.renderChapters(DECADES);
    const link = chapter(1960).querySelector('.tl-hangar-link');
    expect(link.getAttribute('href')).toBe('/hangar?decade=1960');
    expect(link.querySelector('span').textContent).toBe('Voir ces 11 appareils dans le hangar');

    const lens = { nation: 'URSS', type: 'Chasseur', nationLabel: 'URSS', typeLabel: 'Chasseur' };
    render.renderChapters(DECADES, [], lens);
    expect(chapter(1960).querySelector('.tl-hangar-link').getAttribute('href'))
      .toBe('/hangar?decade=1960&country=URSS&type=Chasseur');
  });

  test('lien vers le hangar : libellé traduit avec nombre et décennie', () => {
    I18N.t = (key, p) => (key === 'timeline.hangar_link' ? `${p.n} aircraft of the ${p.decade}s` : key);
    render.renderChapters(DECADES);
    expect(chapter(1950).querySelector('.tl-hangar-link span').textContent).toBe('4 aircraft of the 1950s');
  });

  test('filtre actif sans appareil dans la décennie : message au lieu du bloc', () => {
    const lens = { nation: 'France', type: null, nationLabel: 'France', typeLabel: null };
    render.renderChapters(DECADES, [], lens);
    const section = chapter(1990).querySelector('.tl-aircraft-section');
    expect(section.querySelector('strong').textContent).toBe('0');
    expect(section.querySelector('.tl-lens-empty').textContent).toBe('Aucun appareil pour ce filtre dans cette décennie.');
    expect(section.querySelector('.tl-hangar-link')).toBeNull();
  });

  test('message de filtre vide : nom du filtre transmis à la traduction', () => {
    I18N.t = (key, p) => (key === 'timeline.lens_empty_decade' ? `Rien pour ${p.lens}` : key);
    render.renderChapters(DECADES.slice(2), [], { nation: 'France', type: 'Chasseur', nationLabel: 'France', typeLabel: 'Fighter' });
    expect($('.tl-lens-empty').textContent).toBe('Rien pour France · Fighter');
  });
});

describe('render — conflits', () => {
  beforeEach(() => jest.spyOn(util, 'currentYear').mockReturnValue(2026));

  test('warYears : durée, année unique, conflit en cours', () => {
    expect(render.warYears({ start_year: 1950, end_year: 1953 })).toBe('1950–1953');
    expect(render.warYears({ start_year: 1956, end_year: 1956 })).toBe('1956');
    expect(render.warYears({ start_year: 2022, end_year: null })).toBe('2022–');
  });

  test('chaque conflit dans le chapitre de son début, par date, avec lien et nombre d\'appareils', () => {
    render.renderChapters(DECADES, WARS);
    const list = chapter(1950).querySelector('.tl-conflicts');
    expect(list.querySelector('.tl-section-label').textContent).toBe('Conflits · 2');
    const items = [...list.querySelectorAll('.tl-conflict')];
    expect(items.map(li => li.querySelector('.tl-conflict-name').textContent)).toEqual(['Guerre de Corée', 'Crise de <Suez>']);
    expect(items[0].querySelector('a').getAttribute('href')).toBe('/conflits/guerre-de-coree');
    expect(items[0].querySelector('.tl-conflict-meta').textContent).toBe('1950–1953 · 2 appareils');
    expect(items[1].querySelector('.tl-conflict-meta').textContent).toBe('1956 · 1 appareil');
    expect(chapter(1960).querySelector('.tl-conflict a').getAttribute('href')).toBe('/conflits/viet%20nam');
    expect(chapter(1990).querySelector('.tl-conflict-meta').textContent).toBe('1991– · 0 appareils');
    expect(chapter(1990).querySelector('.tl-conflict').dataset.to).toBe('2026');
  });

  test('nom anglais et nombre traduit (singulier / pluriel)', () => {
    I18N.currentLang = 'en';
    I18N.t = (key, p) => (key.startsWith('timeline.conflict_aircraft_') ? `${key.slice(-3)}:${p.n}` : key);
    render.renderChapters(DECADES, WARS);
    const [korea, suez] = chapter(1950).querySelectorAll('.tl-conflict');
    expect(korea.querySelector('.tl-conflict-name').textContent).toBe('Korean War');
    expect(korea.querySelector('.tl-conflict-meta').textContent).toBe('1950–1953 · her:2');
    expect(suez.querySelector('.tl-conflict-name').textContent).toBe('Crise de <Suez>');
    expect(suez.querySelector('.tl-conflict-meta').textContent).toBe('1956 · one:1');
  });

  test('barres de durée : position et largeur dans la décennie, .continues au-delà', () => {
    render.renderChapters(DECADES, WARS);
    const bar = (li) => [li.style.getPropertyValue('--x'), li.style.getPropertyValue('--w'), li.classList.contains('continues')];
    const [korea, suez] = chapter(1950).querySelectorAll('.tl-conflict');
    expect(bar(korea)).toEqual(['0%', '40%', false]);
    expect(bar(suez)).toEqual(['60%', '10%', false]);
    expect(bar(chapter(1960).querySelector('.tl-conflict'))).toEqual(['50%', '50%', true]);
    expect(bar(chapter(1990).querySelector('.tl-conflict'))).toEqual(['10%', '90%', true]);
    expect(chapter(1950).querySelector('.tl-conflict-track').getAttribute('aria-hidden')).toBe('true');
  });

  test('placeConflictBars : début avant la décennie et largeur minimale', () => {
    document.body.innerHTML = `
      <div id="root">
        <section class="tl-chapter" data-decade="1970">
          <ul><li class="tl-conflict" data-from="1965" data-to="1972"></li></ul>
        </section>
        <section class="tl-chapter" data-decade="1980">
          <ul><li class="tl-conflict" data-from="1989" data-to="1988"></li></ul>
        </section>
      </div>`;
    render.placeConflictBars(document.getElementById('root'));
    const [a, b] = $$('.tl-conflict');
    expect([a.style.getPropertyValue('--x'), a.style.getPropertyValue('--w')]).toEqual(['0%', '30%']);
    expect([b.style.getPropertyValue('--x'), b.style.getPropertyValue('--w')]).toEqual(['90%', '4%']);
  });

  test('renderConflict : nom échappé, conflit sans liste d\'appareils', () => {
    document.body.innerHTML = `<ul>${render.renderConflict({ slug: 's', name: '<img src=x>', start_year: 2001, end_year: 2001 })}</ul>`;
    expect($('img')).toBeNull();
    expect($('.tl-conflict-name').textContent).toBe('<img src=x>');
    expect($('.tl-conflict-meta').textContent).toBe('2001 · 0 appareils');
  });
});

/* ====================================================================== */
/* observers                                                              */
/* ====================================================================== */

describe('observers', () => {
  // innerHeight 800 → ancre à 280 px.
  function layout(rects) {
    $$('.tl-chapter').forEach((c, i) => {
      c.getBoundingClientRect = () => rects[i];
    });
  }
  const rect = (top, height) => ({ top, bottom: top + height, height });
  const barYear = () => $('#tl-bar-year .sr-only') ? $('#tl-bar-year .sr-only').textContent : $('#tl-bar-year').textContent;

  function setup() {
    render.renderChapters(DECADES, WARS);
    ruler.render(DECADES, WARS);
  }

  test('findDominant : chapitre qui chevauche l\'ancre, centre le plus proche', () => {
    const mk = (top, height) => ({ getBoundingClientRect: () => rect(top, height) });
    const a = mk(-500, 1000); const b = mk(100, 2000); const c = mk(900, 500);
    expect(observers.findDominant([a, b, c], 280)).toBe(a);
    expect(observers.findDominant([b, c], 280)).toBe(b);
    expect(observers.findDominant([c], 280)).toBeNull();
    expect(observers.findDominant([], 280)).toBeNull();
  });

  test('chapterFraction : part passée sous l\'ancre, bornée ; hauteur nulle → 0', () => {
    const mk = (top, height) => ({ getBoundingClientRect: () => rect(top, height) });
    expect(observers.chapterFraction(mk(-500, 1000), 280)).toBeCloseTo(0.78);
    expect(observers.chapterFraction(mk(500, 1000), 280)).toBe(0);
    expect(observers.chapterFraction(mk(-2000, 1000), 280)).toBe(1);
    expect(observers.chapterFraction(mk(0, 0), 280)).toBe(0);
  });

  test('staggerDelay : 80 ms par rang, cycle de 6', () => {
    document.body.innerHTML = `<div>${'<a></a>'.repeat(8)}</div>`;
    const cards = $$('a');
    expect(observers.staggerDelay(cards[0])).toBe(0);
    expect(observers.staggerDelay(cards[2])).toBe(160);
    expect(observers.staggerDelay(cards[7])).toBe(80);
  });

  test('update avant le premier chapitre : 1945, aucune ère active', () => {
    setup();
    layout([rect(900, 1000), rect(1900, 1000), rect(2900, 1000)]);
    const clear = jest.spyOn(era, 'clearActiveEra');
    observers.update();
    expect(barYear()).toBe('1945');
    expect(clear).not.toHaveBeenCalled(); // aucune ère n'était active
    expect($$('.tl-chapter.in-view')).toHaveLength(0);
  });

  test('update sur un chapitre : année sous l\'ancre, décennie active, ère montrée une fois par décennie', () => {
    setup();
    I18N.t = (key) => `T:${key}`;
    const show = jest.spyOn(era, 'showActiveEra');
    layout([rect(-2000, 1000), rect(-500, 1000), rect(500, 1000)]);
    observers.update();
    expect(chapter(1960).classList.contains('in-view')).toBe(true);
    expect(barYear()).toBe('1967');
    expect($('[data-decade="1960"].tl-tick').getAttribute('aria-current')).toBe('true');
    expect($('#tl-bar-era').textContent).toBe('T:timeline.era_1960_label2');
    expect(show).toHaveBeenCalledTimes(1);

    layout([rect(-2000, 1000), rect(-700, 1000), rect(300, 1000)]);
    observers.update();
    expect(barYear()).toBe('1969');
    expect(show).toHaveBeenCalledTimes(1);

    layout([rect(-3000, 1000), rect(-1500, 1000), rect(-100, 1000)]);
    observers.update();
    expect(show).toHaveBeenCalledTimes(2);
    expect(show).toHaveBeenLastCalledWith(chapter(1990));
    expect($('[data-decade="1990"].tl-tick').classList.contains('active')).toBe(true);
  });

  test('retour au-dessus du premier chapitre : ère effacée, 1945', () => {
    setup();
    layout([rect(-100, 1000), rect(900, 1000), rect(1900, 1000)]);
    observers.update();
    expect(barYear()).toBe('1953');
    expect(document.body.style.getPropertyValue('--tl-active-era')).not.toBe('');

    const clear = jest.spyOn(era, 'clearActiveEra');
    layout([rect(400, 1000), rect(1400, 1000), rect(2400, 1000)]);
    observers.update();
    expect(clear).toHaveBeenCalledTimes(1);
    expect(barYear()).toBe('1945');
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('');
    expect($('#tl-bar-era').textContent).toBe('');
    expect($$('.tl-tick[aria-current]')).toHaveLength(0);

    observers.update(); // déjà au-dessus : pas de second effacement
    expect(clear).toHaveBeenCalledTimes(1);
  });

  test('entre deux chapitres ou après le dernier, rien ne change', () => {
    setup();
    layout([rect(-2000, 1000), rect(-500, 1000), rect(500, 1000)]);
    observers.update();
    const set = jest.spyOn(ruler, 'setYear');
    layout([rect(-3000, 1000), rect(-2000, 1000), rect(-1000, 1000)]);
    observers.update();
    expect(set).not.toHaveBeenCalled();
    expect(barYear()).toBe('1967');
  });

  test('update sans chapitre : aucune erreur', () => {
    document.getElementById('tl-chapters').innerHTML = '';
    const set = jest.spyOn(ruler, 'setYear');
    expect(() => observers.update()).not.toThrow();
    expect(set).not.toHaveBeenCalled();
  });

  test('observeChapters : suivi du défilement posé une seule fois, mise à jour immédiate', () => {
    setup();
    layout([rect(-2000, 1000), rect(-500, 1000), rect(500, 1000)]);
    const onScroll = jest.spyOn(util, 'onScrollFrame');
    observers.observeChapters();
    observers.observeChapters();
    expect(onScroll).toHaveBeenCalledTimes(1);
    expect(barYear()).toBe('1967');
    // Le rappel de défilement est bien `update`.
    expect(onScroll.mock.calls[0][0]).toBe(observers.update);
  });

  test('observeChapters : la décennie active est réévaluée après un nouveau rendu', () => {
    setup();
    layout([rect(-2000, 1000), rect(-500, 1000), rect(500, 1000)]);
    observers.observeChapters();
    const show = jest.spyOn(era, 'showActiveEra');
    render.renderChapters(DECADES, WARS);
    layout([rect(-2000, 1000), rect(-500, 1000), rect(500, 1000)]);
    observers.observeChapters();
    expect(show).toHaveBeenCalledTimes(1);
    expect(show).toHaveBeenCalledWith(chapter(1960));
  });

  test('révélations : entrée des chapitres, cartes échelonnées, récit et title cards', () => {
    setup();
    layout(DECADES.map(() => rect(2000, 1000)));
    observers.observeChapters();
    expect(ioInstances).toHaveLength(3);
    const [chapterIO, cardIO, narrIO] = ioInstances;
    expect(chapterIO.opts).toEqual({ threshold: 0.05 });
    expect(cardIO.opts).toEqual({ threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
    expect(narrIO.opts).toEqual({ threshold: 0.25 });
    expect(chapterIO.targets).toHaveLength(3);

    const c2 = chapter(1960);
    chapterIO.fire([{ isIntersecting: true, target: c2 }, { isIntersecting: false, target: chapter(1950) }]);
    expect(c2.classList.contains('in-view')).toBe(true);
    expect(chapter(1950).classList.contains('in-view')).toBe(false);
    expect(chapterIO.targets).not.toContain(c2);

    const cards = $$('#ch-1960 .tl-plane-card');
    expect(cardIO.targets).toEqual(expect.arrayContaining([...cards, $('.tl-event')]));
    cardIO.fire([{ isIntersecting: true, target: cards[2] }, { isIntersecting: false, target: cards[3] }]);
    expect(cards[2].classList.contains('reveal')).toBe(true);
    expect(cards[2].style.animationDelay).toBe('160ms');
    expect(cards[3].classList.contains('reveal')).toBe(false);
    expect(cardIO.targets).not.toContain(cards[2]);

    const narrative = $('.tl-narrative');
    narrIO.fire([{ isIntersecting: true, target: narrative }, { isIntersecting: false, target: $('.tl-title-card') }]);
    expect(narrative.classList.contains('reveal')).toBe(true);
    expect($('.tl-title-card').classList.contains('reveal')).toBe(false);
    expect(narrIO.targets).not.toContain(narrative);
  });

  test('nouveau rendu : les anciens observateurs de révélation sont déconnectés', () => {
    setup();
    layout(DECADES.map(() => rect(2000, 1000)));
    observers.observeChapters();
    const first = ioInstances.slice();
    observers.observeChapters();
    expect(ioInstances).toHaveLength(6);
    first.forEach(io => expect(io.disconnect).toHaveBeenCalledTimes(1));
    ioInstances.slice(3).forEach(io => expect(io.disconnect).not.toHaveBeenCalled());
    observers._reset();
    ioInstances.slice(3).forEach(io => expect(io.disconnect).toHaveBeenCalledTimes(1));
  });
});

/* ====================================================================== */
/* timeline.js — démarrage                                                */
/* ====================================================================== */

describe('timeline.js — démarrage', () => {
  const ok = (payload) => () => Promise.resolve({ ok: true, json: () => Promise.resolve(payload) });

  async function boot(fetchImpl, { url = '/timeline' } = {}) {
    jest.resetModules();
    window.history.replaceState(null, '', url);
    global.auth = { init: jest.fn(() => Promise.resolve()), fetchWithTimeout: jest.fn(fetchImpl) };
    global.showToast = jest.fn();
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/timeline');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
  }

  const frame = () => window.requestAnimationFrame.mock.calls.at(-1)[0];
  const stat = (id) => document.getElementById(id).querySelector('.sr-only').textContent;

  afterEach(() => { delete global.showToast; });

  test('succès : chapitres, règle, filtres, totaux, puis chargement masqué', async () => {
    document.querySelector('header').getBoundingClientRect = () => ({ bottom: 64 });
    await boot(ok({ decades: DECADES, wars: WARS }));
    expect(auth.init).toHaveBeenCalled();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/timeline');
    expect(document.body.classList.contains('tl-has-cinematic')).toBe(true);
    expect($('#tl-bar').style.getPropertyValue('--tl-bar-top')).toBe('64px');
    expect($$('.tl-chapter')).toHaveLength(3);
    expect($$('.tl-tick')).toHaveLength(3);
    expect($$('.tl-ruler-war')).toHaveLength(4);
    expect([...$('#tl-lens-nation').options].map(o => o.textContent))
      .toEqual(['Toutes les nations', 'États-Unis (1)', 'URSS (14)']);
    expect([...$('#tl-lens-type').options].map(o => o.textContent))
      .toEqual(['Tous les types', 'Bombardier (1)', 'Chasseur (14)']);
    expect($('#tl-lens-reset').hidden).toBe(true);
    expect($('#tl-lens-status').textContent).toBe('');
    expect(stat('tl-stat-events')).toBe('2');
    expect(stat('tl-stat-aircraft')).toBe('15');
    expect(stat('tl-stat-wars')).toBe('4');
    expect($('#tl-loading').classList.contains('gone')).toBe(false);

    frame()();
    expect($('#tl-loading').classList.contains('gone')).toBe(true);
    expect(window.scrollTo).not.toHaveBeenCalled(); // pas d'ancre
  });

  test('ancre #1962 : saut immédiat au chapitre des années 1960', async () => {
    await boot(ok({ decades: DECADES, wars: WARS }), { url: '/timeline#1962' });
    chapter(1960).getBoundingClientRect = () => ({ top: 2400 });
    frame()();
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 2400 + window.pageYOffset - util.SCROLL_OFFSET, behavior: 'auto' });
  });

  test('filtre lu dans l\'URL : frise filtrée dès le premier rendu', async () => {
    await boot(ok({ decades: DECADES, wars: WARS }), { url: '/timeline?lang=en&nation=%C3%89tats-Unis&type=Inconnu' });
    expect($('#tl-lens-nation').value).toBe('États-Unis');
    expect($('#tl-lens-type').value).toBe('');
    expect($$('#ch-1950 .tl-plane-card').map(c => c.getAttribute('href'))).toEqual(['/details/f-86-sabre-1']);
    expect(chapter(1960).querySelector('.tl-lens-empty')).not.toBeNull();
    expect($$('.tl-conflict').map(li => li.querySelector('.tl-conflict-name').textContent)).toEqual(['Guerre de Corée']);
    expect($$('.tl-ruler-war')).toHaveLength(1);
    expect($('#tl-lens-status').textContent).toBe('États-Unis : 1 appareils');
    // Les totaux de la couverture restent ceux de toute la frise.
    expect(stat('tl-stat-aircraft')).toBe('15');
  });

  test('changement de filtre : nouveau rendu, URL et annonce mises à jour', async () => {
    await boot(ok({ decades: DECADES, wars: WARS }), { url: '/timeline?lang=en#ch-1950' });
    const before = $('.tl-chapter');
    $('#tl-lens-type').value = 'Bombardier';
    $('#tl-lens-type').dispatchEvent(new Event('change'));
    expect($('.tl-chapter')).not.toBe(before);
    expect(window.location.search).toBe('?lang=en&type=Bombardier');
    expect(window.location.hash).toBe('#ch-1950');
    expect($$('.tl-plane-card')).toHaveLength(0);
    expect([...chapter(1950).querySelectorAll('.tl-chip-name')].map(n => n.textContent)).toEqual(['X <script>']);
    expect(chapter(1950).querySelector('.tl-hangar-link').getAttribute('href')).toBe('/hangar?decade=1950&type=Bombardier');
    expect($('#tl-lens-status').textContent).toBe('Bombardier : 1 appareils');
    expect($('#tl-lens-reset').hidden).toBe(false);

    $('#tl-lens-reset').click();
    expect(window.location.search).toBe('?lang=en');
    expect($$('.tl-plane-card').length).toBeGreaterThan(0);
    expect($('#tl-lens-status').textContent).toBe('');
  });

  test('changement de langue : nouveau rendu des chapitres avec le filtre courant', async () => {
    await boot(ok({ decades: DECADES, wars: WARS }), { url: '/timeline?nation=URSS' });
    const before = $('.tl-chapter');
    I18N.currentLang = 'en';
    window.dispatchEvent(new Event('langChanged'));
    expect($('.tl-chapter')).not.toBe(before);
    expect($$('.tl-chapter')).toHaveLength(3);
    expect(chapter(1950).querySelector('.tl-plane-country').textContent).toBe('USSR');
    expect($$('#ch-1950 .tl-plane-card')).toHaveLength(2);
  });

  test('clavier branché : Fin mène au dernier chapitre', async () => {
    await boot(ok({ decades: DECADES, wars: WARS }));
    chapter(1990).getBoundingClientRect = () => ({ top: 3000 });
    document.body.dispatchEvent(new KeyboardEvent('keydown', { key: 'End', bubbles: true, cancelable: true }));
    expect(window.scrollTo).toHaveBeenCalledWith(expect.objectContaining({ top: 3000 + window.pageYOffset - util.SCROLL_OFFSET }));
  });

  test('sans odomètre : totaux posés en texte ; compteur absent toléré', async () => {
    delete window.VH.rollingNumber;
    document.getElementById('tl-stat-wars').remove();
    await boot(ok({ decades: DECADES, wars: WARS }));
    expect(document.getElementById('tl-stat-events').textContent).toBe('2');
    expect(document.getElementById('tl-stat-aircraft').textContent).toBe('15');
  });

  test('attend la langue avant de rendre', async () => {
    jest.useFakeTimers();
    try {
      I18N.isLoaded = false;
      const done = jest.fn();
      jest.resetModules();
      global.auth = { init: () => Promise.resolve(), fetchWithTimeout: ok({ decades: DECADES, wars: [] }) };
      const spy = jest.spyOn(document, 'addEventListener');
      require('../js/timeline');
      const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
      spy.mockRestore();
      onReady().then(done);
      await jest.advanceTimersByTimeAsync(100);
      expect($('.tl-chapter')).toBeNull();
      I18N.t = (key) => `T:${key}`;
      I18N.isLoaded = true;
      await jest.advanceTimersByTimeAsync(30);
      expect(done).toHaveBeenCalled();
      expect($('.tl-title-chapter').textContent).toBe('T:timeline.chapter_label · 01');
    } finally {
      I18N.isLoaded = true;
      jest.useRealTimers();
    }
  });

  test('frise vide : message et chargement masqué', async () => {
    await boot(ok({ decades: [{ decade: 1950, events: [], aircraft: [] }], wars: WARS }));
    expect($('.tl-empty-msg').textContent).toBe('—');
    expect($('.tl-chapter')).toBeNull();
    expect($('#tl-loading').classList.contains('gone')).toBe(true);
  });

  test('frise vide : message traduit', async () => {
    I18N.t = (key) => (key === 'timeline.no_aircraft' ? 'Aucun appareil.' : key);
    await boot(ok({ decades: [] }));
    expect($('.tl-empty-msg').textContent).toBe('Aucun appareil.');
  });

  test('erreur réseau : message d\'erreur, toast et chargement masqué', async () => {
    await boot(() => Promise.resolve({ ok: false, status: 500 }));
    expect($('.tl-empty-msg').textContent).toBe('Erreur de chargement.');
    expect($('#tl-loading').classList.contains('gone')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('Erreur de chargement.', 'error');
  });

  test('erreur réseau avec chapitres rendus par le serveur : ils restent, toast seul', async () => {
    document.getElementById('tl-chapters').innerHTML = '<section class="tl-chapter tl-chapter--ssr" id="ch-1950"><p>Texte serveur</p></section>';
    await boot(() => Promise.resolve({ ok: false, status: 503 }));
    expect($('.tl-chapter--ssr').textContent).toContain('Texte serveur');
    expect($('.tl-empty-msg')).toBeNull();
    expect(showToast).toHaveBeenCalledWith('Erreur de chargement.', 'error');
  });

  test('erreur sans showToast ni écran de chargement : message seul', async () => {
    document.getElementById('tl-loading').remove();
    jest.resetModules();
    global.auth = { init: () => Promise.resolve(), fetchWithTimeout: () => Promise.reject(new Error('timeout')) };
    delete global.showToast;
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/timeline');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await expect(onReady()).resolves.toBeUndefined();
    expect($('.tl-empty-msg').textContent).toBe('Erreur de chargement.');
  });
});
