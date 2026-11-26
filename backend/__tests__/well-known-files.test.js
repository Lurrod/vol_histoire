/**
 * Tests — fichiers standard du site : /llms.txt (routes/llms.js),
 * /.well-known/change-password, /opensearch.xml, /.well-known/security.txt,
 * et les ajouts du <head> injectés par serveHtml (opt-in des transitions,
 * lien OpenSearch). Base de données simulée.
 */
const request = require('supertest');

jest.mock('../mailer', () => ({
  verifyConnection: jest.fn().mockResolvedValue(undefined),
}));

const app = require('../app');
const cache = require('../utils/cache');
const { buildLlmsTxt, buildStaticLlmsTxt } = require('../routes/llms');
const { listAirplanesForLlms } = require('../repositories/sitemap');
const {
  injectOpenSearchLink, injectHeadExtras, OPENSEARCH_LINK, MORPH_OPT_IN,
} = require('../middleware/serveHtml');

const SITE = 'https://vol-histoire.titouan-borde.com';

const AIRPLANES = [
  { id: 30, name: 'Dassault Rafale', type_name: 'Chasseur', country_name: 'France', year: 2001 },
  { id: 7, name: 'Projet [secret]\nX', type_name: null, country_name: null, year: null },
];
const WARS = [
  { id: 1, name: 'Guerre de Corée', date_start: '1950-06-25', date_end: '1953-07-27', count: 12 },
  { id: 2, name: 'Guerre du Golfe', date_start: '1991-01-17', date_end: '1991-01-17', count: 1 },
  { id: 3, name: 'Conflit sans appareil', date_start: null, date_end: null, count: 0 },
  { id: 4, name: 'Conflit en cours', date_start: '1948-05-15', date_end: null, count: 30 },
  { id: 5, name: 'Conflit non daté', date_start: null, date_end: null, count: 2 },
];

/** Pool simulé : fiches pour la requête sur airplanes, conflits sinon. */
function fakePool({ airplanes = AIRPLANES, wars = WARS } = {}) {
  return {
    query: jest.fn((sql) => Promise.resolve({ rows: /FROM airplanes a/.test(sql) && !/FROM wars/.test(sql) ? airplanes : wars })),
  };
}

beforeEach(() => cache._resetForTests());

describe('llms.txt — contenu', () => {
  test('format llmstxt.org : titre, résumé en citation, sections de liens', async () => {
    const txt = await buildLlmsTxt(() => fakePool());
    expect(txt.startsWith("# Vol d'Histoire\n\n> Encyclopédie bilingue")).toBe(true);
    expect(txt).toContain("2 fiches d'appareils, 4 conflits");
    for (const h of ['## Pages principales', '## API publique (JSON)', '## Conflits', "## Fiches d'appareils", '## Optional']) {
      expect(txt).toContain(`\n${h}\n`);
    }
    expect(txt).toContain(`- [Hangar](${SITE}/hangar):`);
    expect(txt).toContain(`- [Plan du site](${SITE}/sitemap.xml)`);
    // Réutilisation : rappel des conditions, sans promettre plus que les CGU.
    expect(txt).toMatch(/reproduction interdite sans accord écrit/);
  });

  test('fiches : lien canonique, type, pays et année ; texte neutralisé pour Markdown', async () => {
    const txt = await buildLlmsTxt(() => fakePool());
    expect(txt).toContain(`- [Dassault Rafale](${SITE}/details/dassault-rafale-30): Chasseur, France, 2001`);
    // Crochets et retour à la ligne retirés du nom ; aucune parenthèse de détail vide.
    expect(txt).toMatch(new RegExp(`- \\[Projet secret X\\]\\(${SITE}/details/[a-z0-9-]+-7\\)\\n`));
  });

  test('conflits : seulement ceux qui ont des appareils, période et nombre', async () => {
    const txt = await buildLlmsTxt(() => fakePool());
    expect(txt).toContain(`- [Guerre de Corée](${SITE}/conflits/guerre-de-coree): 1950-1953, 12 appareils`);
    expect(txt).toContain(`- [Guerre du Golfe](${SITE}/conflits/guerre-du-golfe): 1991, 1 appareil`);
    expect(txt).not.toContain('Conflit sans appareil');
    expect(txt).toContain(`- [Conflit en cours](${SITE}/conflits/conflit-en-cours): depuis 1948, 30 appareils`);
    expect(txt).toContain(`- [Conflit non daté](${SITE}/conflits/conflit-non-date): 2 appareils`);
  });

  test('version minimale sans base : pages et API, ni fiches ni conflits', () => {
    const txt = buildStaticLlmsTxt();
    expect(txt).toContain('## Pages principales');
    expect(txt).not.toContain("## Fiches d'appareils");
    expect(txt).toContain("des centaines de fiches d'appareils");
  });

  test('requête : type et pays en français, année de mise en service ou de premier vol', async () => {
    const pool = { query: jest.fn().mockResolvedValue({ rows: [] }) };
    await listAirplanesForLlms(pool);
    const sql = pool.query.mock.calls[0][0];
    expect(sql).toMatch(/COALESCE\(a\.date_operationel, a\.date_first_fly\)/);
    expect(sql).toMatch(/LEFT JOIN type t/);
    expect(sql).toMatch(/LEFT JOIN countries c/);
  });
});

describe('GET /llms.txt', () => {
  test('200 text/plain, mis en cache, puis servi depuis le cache', async () => {
    const pool = fakePool();
    app.setPool(pool);
    const first = await request(app).get('/llms.txt');
    expect(first.status).toBe(200);
    expect(first.headers['content-type']).toMatch(/text\/plain; charset=utf-8/);
    expect(first.headers['x-cache']).toBe('MISS');
    expect(first.text).toContain('Dassault Rafale');
    const calls = pool.query.mock.calls.length;
    const second = await request(app).get('/llms.txt');
    expect(second.headers['x-cache']).toBe('HIT');
    expect(pool.query.mock.calls.length).toBe(calls);
  });

  test('base indisponible : version minimale, cache court', async () => {
    app.setPool({ query: jest.fn().mockRejectedValue(new Error('DB down')) });
    const res = await request(app).get('/llms.txt');
    expect(res.status).toBe(200);
    expect(res.headers['x-cache']).toBe('FALLBACK');
    expect(res.headers['cache-control']).toMatch(/max-age=300/);
    expect(res.text).toContain('## Pages principales');
  });
});

describe('/.well-known et OpenSearch', () => {
  test('change-password : 302 vers l\'onglet Sécurité des réglages', async () => {
    const res = await request(app).get('/.well-known/change-password');
    expect(res.status).toBe(302);
    expect(res.headers.location).toBe('/settings#security');
  });

  test('security.txt : contact, expiration, politique, canonique', async () => {
    const res = await request(app).get('/.well-known/security.txt');
    expect(res.status).toBe(200);
    for (const field of ['Contact:', 'Expires:', 'Policy:', 'Canonical:', 'Preferred-Languages:']) {
      expect(res.text).toContain(field);
    }
  });

  test('opensearch.xml : type OpenSearch, recherche vers le hangar', async () => {
    const res = await request(app).get('/opensearch.xml');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/opensearchdescription\+xml/);
    expect(res.text).toContain(`template="${SITE}/hangar?q={searchTerms}"`);
    expect(res.text).toMatch(/<ShortName>.{1,16}<\/ShortName>/);
  });
});

describe('<head> des pages servies', () => {
  test('lien OpenSearch avant </head>, une fois ; rien sans </head>', () => {
    const out = injectOpenSearchLink('<head>\n</head>');
    expect(out).toBe(`<head>\n  ${OPENSEARCH_LINK}\n</head>`);
    expect(injectOpenSearchLink(out)).toBe(out);
    expect(injectOpenSearchLink('<div></div>')).toBe('<div></div>');
  });

  test('injectHeadExtras : opt-in des transitions en tête, lien OpenSearch en fin', () => {
    const out = injectHeadExtras('<html><head>\n<meta charset="utf-8">\n</head>');
    expect(out.indexOf(MORPH_OPT_IN)).toBeLessThan(out.indexOf('<meta'));
    expect(out.indexOf(OPENSEARCH_LINK)).toBeGreaterThan(out.indexOf('<meta'));
  });

  test('page réelle servie : lien OpenSearch présent (nonce CSP sur le style ajouté)', async () => {
    app.setPool(fakePool());
    const res = await request(app).get('/hangar');
    expect(res.status).toBe(200);
    expect(res.text).toContain(OPENSEARCH_LINK);
    expect(res.text).toMatch(/<style nonce="[^"]+">@view-transition\{navigation:auto\}/);
  });
});
