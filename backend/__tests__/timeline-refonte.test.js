/**
 * Refonte de la frise : charge utile (années réelles, premier vol, conflits),
 * rendu serveur des chapitres sur /timeline, filtre `decade` du hangar
 * (GET /api/airplanes et /api/airplanes/facets). Base de données simulée.
 */
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const request = require('supertest');

jest.mock('../mailer', () => ({
  sendVerificationEmail: jest.fn(),
  sendPasswordResetEmail: jest.fn(),
  sendContactEmail: jest.fn(),
  sendEmailChangeConfirmation: jest.fn(),
  sendEmailChangeNotice: jest.fn(),
  sendAccountExistsNotice: jest.fn(),
  verifyConnection: jest.fn(),
}));

const app = require('../app');
const cache = require('../utils/cache');
const payload = require('../utils/timeline-payload');
const ssr = require('../utils/timeline-ssr');
const { isValidDecade } = require('../middleware/input-guards');

const mockPool = { query: jest.fn() };

beforeAll(() => app.setPool(mockPool));
beforeEach(() => {
  mockPool.query.mockReset();
  cache._resetForTests();
});
afterAll(() => app.stopCleanup());

const EVENT = {
  id: 1, event_date: '1950-06-25', era_decade: 1950, kind: 'war',
  title_fr: 'Corée <duel>', title_en: 'Korea', body_fr: 'Premiers duels.', body_en: 'First duels.',
  quote_author_fr: 'Un pilote', quote_author_en: 'A pilot',
  airplane_id: 7, airplane_name: 'MiG-15', airplane_name_en: null, airplane_image_url: 'mig15.jpg',
  airplane_little_description: null, airplane_little_description_en: null,
};
const AIRCRAFT = [
  { id: 7, name: 'MiG-15', name_en: null, image_url: 'mig15.jpg', status: 'Retiré', units_built: '18000',
    year: 1949, year_source: 'service', era_decade: 1940, country_name: 'Russie', country_name_en: 'Russia',
    generation: 1, type_name: 'Chasseur', type_name_en: 'Fighter' },
  { id: 9, name: 'Avro Canada CF-105 Arrow', name_en: null, image_url: null, status: 'Annulé', units_built: null,
    year: 1958, year_source: 'first_flight', era_decade: 1950, country_name: 'Canada', country_name_en: 'Canada',
    generation: 2, type_name: 'Intercepteur', type_name_en: 'Interceptor' },
  { id: 11, name: 'X-59', name_en: null, image_url: null, status: 'En développement', units_built: 1,
    year: 2024, year_source: 'first_flight', era_decade: 2020, country_name: 'États-Unis', country_name_en: 'United States',
    generation: 5, type_name: 'Recherche', type_name_en: 'Research' },
  { id: 12, name: 'Prototype', name_en: null, image_url: null, status: 'Retiré', units_built: null,
    year: 1956, year_source: 'first_flight', era_decade: 1950, country_name: 'France', country_name_en: 'France',
    generation: 2, type_name: 'Recherche', type_name_en: 'Research' },
];
const WARS = [
  { id: 4, name: 'Guerre de Corée', name_en: 'Korean War', date_start: new Date(1950, 5, 25), date_end: new Date(1953, 6, 27), aircraft_ids: [7] },
  { id: 5, name: 'Crise de Suez', name_en: 'Suez Crisis', date_start: '1956-10-29', date_end: '1956-11-07', aircraft_ids: [9, 12] },
  { id: 6, name: 'Guerre en cours', name_en: null, date_start: '2022-02-24', date_end: null, aircraft_ids: [11] },
];

function mockTimelineQueries() {
  mockPool.query
    .mockResolvedValueOnce({ rows: [EVENT] })
    .mockResolvedValueOnce({ rows: AIRCRAFT })
    .mockResolvedValueOnce({ rows: WARS });
}

describe('utils/timeline-payload', () => {
  test('yearOf : Date, ISO, vide et invalide', () => {
    expect(payload.yearOf(new Date(1962, 9, 16))).toBe(1962);
    expect(payload.yearOf('1950-06-25')).toBe(1950);
    expect(payload.yearOf(null)).toBeNull();
    expect(payload.yearOf('')).toBeNull();
    expect(payload.yearOf(new Date('nope'))).toBeNull();
    expect(payload.yearOf('abc')).toBeNull();
  });

  test('buildPayload : appareils au premier vol, conflits datés et rangés', () => {
    const out = payload.buildPayload({ events: [EVENT], aircraft: AIRCRAFT, wars: WARS });
    expect(out.decades.map(d => d.decade)).toEqual(payload.DECADES);
    const d50 = out.decades.find(d => d.decade === 1950);
    expect(d50.aircraft.map(a => [a.id, a.year_source])).toEqual([[9, 'first_flight'], [12, 'first_flight']]);
    expect(out.decades.find(d => d.decade === 1940).aircraft[0].units_built).toBe(18000);
    expect(out.wars.map(w => [w.slug, w.start_year, w.end_year, w.era_decade])).toEqual([
      ['guerre-de-coree', 1950, 1953, 1950],
      ['crise-de-suez', 1956, 1956, 1950],
      ['guerre-en-cours', 2022, null, 2020],
    ]);
  });

  test('buildPayload : conflits sans date ou hors des décennies écartés, wars facultatif', () => {
    const out = payload.buildPayload({
      events: [], aircraft: [],
      wars: [{ id: 1, name: 'Sans date', date_start: null, aircraft_ids: [1] },
        { id: 2, name: 'Ancienne', date_start: '1914-08-01', date_end: null, aircraft_ids: null }],
    });
    expect(out.wars).toEqual([]);
    expect(payload.buildPayload({ events: [], aircraft: [] }).wars).toEqual([]);
  });
});

describe('GET /api/timeline — conflits et premier vol', () => {
  test('la charge utile porte les conflits et la source de l\'année', async () => {
    mockTimelineQueries();
    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    expect(res.body.wars).toHaveLength(3);
    const arrow = res.body.decades.find(d => d.decade === 1950).aircraft.find(a => a.id === 9);
    expect(arrow).toMatchObject({ year: 1958, year_source: 'first_flight', status: 'Annulé' });
    // La requête des appareils retombe sur le premier vol.
    expect(mockPool.query.mock.calls[1][0]).toContain('COALESCE(a.date_operationel, a.date_first_fly)');
  });
});

describe('utils/timeline-ssr', () => {
  const data = payload.buildPayload({ events: [EVENT], aircraft: AIRCRAFT, wars: WARS });

  test('chapitres non vides, textes du chapitre, événements, conflits et appareils (fr)', () => {
    const html = ssr.renderChaptersHtml(data, 'fr');
    expect(html.match(/class="tl-chapter tl-chapter--ssr"/g)).toHaveLength(3); // 1940, 1950, 2020
    expect(html).toContain('id="ch-1950"');
    expect(html).toContain('Corée &lt;duel&gt;');
    expect(html).toContain('— Un pilote');
    expect(html).toContain('href="/details/mig-15-7"');
    expect(html).toContain('href="/conflits/guerre-de-coree"');
    expect(html).toContain('1950–1953');
    expect(html).toContain('>1956 · '); // conflit d'une seule année
    expect(html).toContain('2022–'); // conflit en cours
    expect(html).toContain('class="tl-chip is-proto"');
    expect(html).toContain('Annulé');
    expect(html).toContain('En développement');
    expect(html).toContain('1er vol');
    expect(html).toContain('href="/hangar?decade=1950"');
    expect(html).toContain('<span class="tl-title-span">1945–1949</span>');
  });

  test('anglais : textes et noms traduits', () => {
    const html = ssr.renderChaptersHtml(data, 'en');
    expect(html).toContain('Korea');
    expect(html).toContain('Korean War');
    expect(html).toContain('Russia');
    expect(html).toContain('Cancelled');
    expect(html).toContain('First flight');
  });

  test('injectChapters : remplace le marqueur, page inchangée sans marqueur', () => {
    const page = `<div id="tl-chapters">${ssr.MARKER}</div>`;
    expect(ssr.injectChapters(page, data, 'fr')).toContain('tl-chapter--ssr');
    expect(ssr.injectChapters('<p>rien</p>', data, 'fr')).toBe('<p>rien</p>');
    expect(ssr.renderChaptersHtml({}, 'fr')).toBe('');
  });

  test('traduction : paramètres remplacés, repli sans clé', () => {
    expect(ssr._tr({ k: '{n} appareils' }, 'k', '', { n: 3 })).toBe('3 appareils');
    expect(ssr._tr({}, 'absente', 'repli')).toBe('repli');
  });
});

describe('dates clés des conflits (dépliant de la frise)', () => {
  // Daté des années 1950 : buildPayload écarte un conflit dont la décennie n'a
  // aucun appareil (le jeu d'essai n'en a qu'en 1940, 1950 et 2020).
  const SIX_JOURS = {
    id: 8, name: 'Guerre des Six Jours', name_en: 'Six-Day War', date_start: '1956-06-05', date_end: '1956-06-10',
    aircraft_ids: [7],
    events: [
      { date: '1967-06-05', precision: 'day', title: 'Opération <Moked> *Focus*', title_en: 'Operation Moked' },
      { date: '1967-06-01', precision: 'month', title: 'Mobilisation', title_en: null },
      { date: '1967-01-01', precision: 'year', title: 'Tensions', title_en: 'Tensions' },
    ],
  };
  const data = payload.buildPayload({ events: [], aircraft: AIRCRAFT, wars: [SIX_JOURS, WARS[1]] });

  test('clé de cache relevée : la forme du conflit change', () => {
    expect(payload.CACHE_KEY).toBe('vdh:timeline:v3');
  });

  test('buildPayload : dates clés gardées dans leur ordre, liste vide par défaut', () => {
    const six = data.wars.find((w) => w.slug === 'guerre-des-six-jours');
    expect(six.events).toEqual(SIX_JOURS.events);
    expect(data.wars.find((w) => w.slug === 'crise-de-suez').events).toEqual([]);
  });

  test('rendu serveur (fr) : dépliant, nombre de dates, dates selon leur précision, titres échappés', () => {
    const html = ssr.renderChaptersHtml(data, 'fr');
    expect(html).toContain('<details class="tl-conflict-dates">');
    expect(html).toContain('3 dates clés');
    expect(html).toContain('<time datetime="1967-06-05">5 juin 1967</time>');
    expect(html).toContain('<time datetime="1967-06">juin 1967</time>');
    expect(html).toContain('<time datetime="1967">1967</time>');
    expect(html).toContain('Opération &lt;Moked&gt; <em>Focus</em>');
    expect(html).toContain('href="/conflits/guerre-des-six-jours"');
    // Un conflit sans date clé n'a pas de dépliant.
    expect(html.match(/<details class="tl-conflict-dates">/g)).toHaveLength(1);
  });

  test('rendu serveur (en) : dates et titres anglais, repli sur le titre français', () => {
    const html = ssr.renderChaptersHtml(data, 'en');
    expect(html).toContain('3 key dates');
    expect(html).toContain('5 June 1967');
    expect(html).toContain('June 1967');
    expect(html).toContain('Operation Moked');
    expect(html).toContain('Mobilisation');
  });
});

describe('GET /timeline — rendu serveur', () => {
  test('la page contient le texte des chapitres', async () => {
    mockTimelineQueries();
    const res = await request(app).get('/timeline');
    expect(res.status).toBe(200);
    expect(res.text).toContain('tl-chapter--ssr');
    expect(res.text).toContain('href="/conflits/crise-de-suez"');
    expect(res.text).not.toContain('<!-- @tl-chapters -->');
    expect(res.headers.vary).toMatch(/Accept-Language/);
  });

  test('HTML gardé tant que la charge utile ne change pas (second appel sans base)', async () => {
    mockTimelineQueries();
    const first = await request(app).get('/timeline');
    const second = await request(app).get('/timeline'); // charge utile en cache
    expect(mockPool.query).toHaveBeenCalledTimes(3);
    const strip = html => html.replace(/nonce="[^"]*"/g, '');
    expect(strip(second.text)).toBe(strip(first.text));
  });

  test('en anglais : chapitres traduits', async () => {
    mockTimelineQueries();
    const res = await request(app).get('/timeline?lang=en');
    expect(res.status).toBe(200);
    expect(res.text).toContain('Suez Crisis');
  });

  test('base indisponible : la page part sans chapitres', async () => {
    mockPool.query.mockRejectedValue(new Error('db down'));
    const res = await request(app).get('/timeline');
    expect(res.status).toBe(200);
    expect(res.text).not.toContain('tl-chapter--ssr');
    expect(res.text).toContain('id="tl-chapters"');
  });
});

describe('filtre decade (hangar)', () => {
  test('isValidDecade : décennies de la frise seulement', () => {
    ['1940', '1950', '1990', '2000', '2020', 2010].forEach(v => expect(isValidDecade(v)).toBe(true));
    ['1930', '2030', '1955', 'abc', '', '19500'].forEach(v => expect(isValidDecade(v)).toBe(false));
  });

  test('GET /api/airplanes?decade=1950 : mise en service, à défaut premier vol', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes?decade=1950');
    expect(res.status).toBe(200);
    const [sql, params] = mockPool.query.mock.calls[0];
    expect(sql).toContain('EXTRACT(YEAR FROM COALESCE(a.date_operationel, a.date_first_fly))::int / 10 * 10 = $1');
    expect(params[0]).toBe(1950);
  });

  test('GET /api/airplanes?decade=1955 → 400', async () => {
    const res = await request(app).get('/api/airplanes?decade=1955');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/decade invalide/);
  });

  test('facettes : decade appliquée à chaque groupe, 400 si invalide', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    const ok = await request(app).get('/api/airplanes/facets?decade=1960');
    expect(ok.status).toBe(200);
    expect(mockPool.query.mock.calls.every(([sql]) => sql.includes('COALESCE(a.date_operationel, a.date_first_fly)'))).toBe(true);
    const bad = await request(app).get('/api/airplanes/facets?decade=60');
    expect(bad.status).toBe(400);
  });
});
