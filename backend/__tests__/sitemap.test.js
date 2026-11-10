/**
 * Tests unitaires — routes/sitemap.js (SEO-001, SEO-008) et
 * repositories/sitemap.js. Base de données simulée.
 */
const { buildSitemapXml, buildStaticSitemapXml } = require('../routes/sitemap');
const { listAirplanesForSitemap } = require('../repositories/sitemap');

const SITE = 'https://vol-histoire.titouan-borde.com';

/** Pool simulé : répond selon la requête (fiches, puis conflits). */
function fakePool({ airplanes = [], wars = [] } = {}) {
  return {
    query: jest.fn((sql) => Promise.resolve({
      rows: /FROM airplanes/.test(sql) && !/FROM wars/.test(sql) ? airplanes : wars,
    })),
  };
}

function urlBlocks(xml) {
  return [...xml.matchAll(/<url>([\s\S]*?)<\/url>/g)].map(m => m[1]);
}

function blockFor(xml, loc) {
  return urlBlocks(xml).find(b => b.includes(`<loc>${loc}</loc>`));
}

describe('sitemap — versions linguistiques (SEO-001)', () => {
  test('une <url> par langue, alternates réciproques fr / en / x-default', async () => {
    const pool = fakePool({ airplanes: [{ id: 31, name: 'SR-71 Blackbird', updated_at: null }] });
    const xml = await buildSitemapXml(() => pool);
    const fr = blockFor(xml, `${SITE}/details/sr-71-blackbird-31`);
    const en = blockFor(xml, `${SITE}/details/sr-71-blackbird-31?lang=en`);
    expect(fr).toBeDefined();
    expect(en).toBeDefined();
    for (const block of [fr, en]) {
      expect(block).toContain(`hreflang="fr" href="${SITE}/details/sr-71-blackbird-31" />`);
      expect(block).toContain(`hreflang="en" href="${SITE}/details/sr-71-blackbird-31?lang=en" />`);
      expect(block).toContain(`hreflang="x-default" href="${SITE}/details/sr-71-blackbird-31" />`);
    }
    // Plus aucune URL ?lang=fr : le français est servi à l'URL nue.
    expect(xml).not.toContain('lang=fr');
  });

  test('changefreq et priority ne sont plus publiés', async () => {
    const xml = await buildSitemapXml(() => fakePool());
    expect(xml).not.toMatch(/changefreq|priority/);
  });

  test('pages fixes publiques présentes, crédits photo compris', async () => {
    const xml = await buildSitemapXml(() => fakePool());
    for (const page of ['/', '/hangar', '/timeline', '/conflits', '/credits', '/contact', '/cgu']) {
      expect(blockFor(xml, `${SITE}${page}`)).toBeDefined();
      expect(blockFor(xml, `${SITE}${page}?lang=en`)).toBeDefined();
    }
  });

  test('pages non indexables absentes (hors ligne, 404, compte, favoris)', async () => {
    const xml = await buildSitemapXml(() => fakePool());
    for (const page of ['/offline', '/404', '/login', '/settings', '/favorites', '/details<']) {
      expect(xml).not.toContain(`${SITE}${page}`);
    }
  });
});

describe('sitemap — lastmod réel (SEO-008)', () => {
  const airplanes = [
    { id: 1, name: 'Rafale', updated_at: new Date('2026-03-04T10:00:00Z') },
    { id: 2, name: 'Mirage 2000', updated_at: '2026-09-07T09:14:40.347Z' },
    { id: 3, name: 'Sans date', updated_at: null },
  ];

  test('fiche : date de sa dernière écriture en base, pas la date du jour', async () => {
    const xml = await buildSitemapXml(() => fakePool({ airplanes, wars: [{ name: 'Guerre du Golfe' }] }));
    expect(blockFor(xml, `${SITE}/details/rafale-1`)).toContain('<lastmod>2026-03-04</lastmod>');
    expect(blockFor(xml, `${SITE}/details/rafale-1?lang=en`)).toContain('<lastmod>2026-03-04</lastmod>');
    expect(blockFor(xml, `${SITE}/details/mirage-2000-2`)).toContain('<lastmod>2026-09-07</lastmod>');
    expect(blockFor(xml, `${SITE}/details/sans-date-3`)).not.toContain('<lastmod>');
  });

  test('hangar et accueil : date de la fiche la plus récente ; autres pages sans lastmod', async () => {
    const xml = await buildSitemapXml(() => fakePool({ airplanes, wars: [{ name: 'Guerre du Golfe' }] }));
    expect(blockFor(xml, `${SITE}/hangar`)).toContain('<lastmod>2026-09-07</lastmod>');
    expect(blockFor(xml, `${SITE}/`)).toContain('<lastmod>2026-09-07</lastmod>');
    expect(blockFor(xml, `${SITE}/cgu`)).not.toContain('<lastmod>');
    expect(blockFor(xml, `${SITE}/conflits/guerre-du-golfe`)).not.toContain('<lastmod>');
    const today = new Date().toISOString().slice(0, 10);
    if (!['2026-03-04', '2026-09-07'].includes(today)) expect(xml).not.toContain(today);
  });

  test('repli sans base : pages fixes seulement, sans aucune date', () => {
    const xml = buildStaticSitemapXml();
    expect(xml).toContain(`<loc>${SITE}/hangar</loc>`);
    expect(xml).toContain(`<loc>${SITE}/hangar?lang=en</loc>`);
    expect(xml).not.toContain('<lastmod>');
    expect(xml).not.toContain('/details/');
  });
});

describe('repositories/sitemap', () => {
  test('listAirplanesForSitemap : id, nom et updated_at', async () => {
    const pool = { query: jest.fn().mockResolvedValue({ rows: [{ id: 1, name: 'A', updated_at: null }] }) };
    await expect(listAirplanesForSitemap(pool)).resolves.toEqual([{ id: 1, name: 'A', updated_at: null }]);
    expect(pool.query.mock.calls[0][0]).toMatch(/SELECT id, name, updated_at FROM airplanes/);
  });
});
