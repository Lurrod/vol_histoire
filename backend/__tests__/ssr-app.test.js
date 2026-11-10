/**
 * Tests d'intégration HTTP — service des pages (app.js) : URL canoniques
 * (HTML-002), langue des rendus serveur (HTML-001), cache des images
 * (PERF-010), icônes et visuel OG (HTML-004, HTML-007), en-tête partagé
 * (ARCH-006). Base de données simulée.
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
  verifyConnection: jest.fn(),
}));

const app = require('../app');

const mockPool = { query: jest.fn() };

beforeAll(() => app.setPool(mockPool));
beforeEach(() => mockPool.query.mockReset());
afterAll(() => app.stopCleanup());

describe('HTML-002 — variantes d\'URL redirigées en 301 avant express.static', () => {
  test.each([
    ['/index.html', '/'],
    ['/index', '/'],
    ['/hangar.html', '/hangar'],
    ['/HANGAR', '/hangar'],
    ['/hangar/', '/hangar'],
    ['/conflits/', '/conflits'],
    ['/Timeline.HTML', '/timeline'],
    ['/hangar.html?lang=en&q=Mira', '/hangar?lang=en&q=Mira'],
  ])('%s → %s', async (from, to) => {
    const res = await request(app).get(from).redirects(0);
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe(to);
  });

  test('les fichiers demandés sous leur nom complet restent servis', async () => {
    expect((await request(app).get('/cookie-consent.html')).status).toBe(200);
    expect((await request(app).get('/googleb250c8eb3ae5dfa7.html')).status).toBe(200);
  });

  test('un asset garde sa casse et son extension (pas de redirection)', async () => {
    const res = await request(app).get('/assets/logo/icon-48.png').redirects(0);
    expect(res.status).toBe(200);
  });

  test('pas de redirection ouverte vers un autre domaine', async () => {
    const res = await request(app).get('//evil.example/').redirects(0);
    expect(res.headers.location || '').not.toMatch(/^\/\//);
  });

  test('/api n\'est jamais redirigé', async () => {
    const res = await request(app).get('/api/route-inexistante/').redirects(0);
    expect(res.status).toBe(404);
  });
});

describe('ARCH-006 — en-tête et pied de page partagés', () => {
  test('/ : en-tête complet, Accueil marqué, aucun marqueur restant', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<a href="/" class="active" aria-current="page">');
    expect(res.text).not.toContain('@include');
    expect(res.text).toContain('<footer>');
  });

  test('/hangar : seul Hangar est marqué', async () => {
    const res = await request(app).get('/hangar');
    expect(res.text.match(/aria-current="page">/g)).toHaveLength(1);
    expect(res.text).toContain('<a href="/hangar" class="active" aria-current="page">');
  });

  test('PERF-001 : les preload de polices ont la même URL que @font-face', async () => {
    const res = await request(app).get('/');
    expect(res.text).toContain('href="fonts/DMSans.woff2" as="font"');
    expect(res.text).not.toMatch(/woff2\?v=/);
  });
});

describe('HTML-001 — langue des rendus serveur', () => {
  const war = {
    id: 1, name: 'Annexion de Goa', name_en: 'Annexation of Goa', description: 'FR', description_en: 'EN',
    date_start: '1961-12-17', date_end: '1961-12-19', image_url: '/assets/airplanes/canberra.jpg',
  };

  test('/conflits/:slug avec Accept-Language anglais : titre, h1, lang et Vary', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [war] });
    const res = await request(app).get('/conflits/annexion-de-goa').set('Accept-Language', 'en-US,en;q=0.9');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<html lang="en">');
    expect(res.text).toContain('<title>Annexation of Goa (1961) | Vol d&#39;Histoire</title>');
    expect(res.text).toContain('<h1 id="page-hero-heading">Annexation of Goa</h1>');
    expect(res.text).toContain('<meta property="og:image" content="https://vol-histoire.titouan-borde.com/assets/airplanes/canberra.jpg">');
    expect(res.text).toContain('hreflang="en" href="https://vol-histoire.titouan-borde.com/conflits/annexion-de-goa?lang=en"');
    expect(res.headers.vary).toMatch(/Accept-Language/);
  });

  test('/conflits/:slug?lang=fr l\'emporte sur Accept-Language', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [war] });
    const res = await request(app).get('/conflits/annexion-de-goa?lang=fr').set('Accept-Language', 'en');
    expect(res.text).toContain('<h1 id="page-hero-heading">Annexion de Goa</h1>');
  });

  test('/details/:slug?lang=en : description anglaise et JSON-LD non doublé', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{
      id: 31, name: 'SR-71 Blackbird', little_description: 'Avion espion', little_description_en: 'Spy plane',
      image_url: '/assets/airplanes/sr71.jpg',
    }] });
    const res = await request(app).get('/details/sr-71-blackbird-31?lang=en');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<meta name="description" content="Spy plane. Specifications, armament, production and history of the SR-71 Blackbird.">');
    expect(res.text).toContain('<html lang="en">');
    // SEO-001 : la version anglaise se canonicalise sur elle-même.
    expect(res.text).toContain('<link rel="canonical" href="https://vol-histoire.titouan-borde.com/details/sr-71-blackbird-31?lang=en">');
    expect(res.text).toContain('<link rel="alternate" hreflang="fr" href="https://vol-histoire.titouan-borde.com/details/sr-71-blackbird-31">');
    expect(res.text).toContain('<meta property="og:locale" content="en_US">');
    expect(res.text.match(/application\/ld\+json/g)).toHaveLength(2);
    expect(res.text).toContain('"publisher":{"@type":"Organization","name":"Vol d\'Histoire","url":"https://vol-histoire.titouan-borde.com","logo":{"@type":"ImageObject","url":"https://vol-histoire.titouan-borde.com/assets/logo/icon-512.png"');
  });
});

describe('SEO-009 — /details sans fiche : 404 réel, jamais 200 indexable', () => {
  test.each([
    ['/details'],
    ['/details?id=abc'],
    ['/details?id=0'],
    ['/details?id=99999999999'],
    ['/details?id=2147483648'],
    ['/details/x-99999999999'],
    ['/details/x-2147483648'],
    ['/details/sans-identifiant'],
  ])('%s → 404 sans requête en base', async (url) => {
    const res = await request(app).get(url).redirects(0);
    expect(res.status).toBe(404);
    expect(res.text).toContain('noindex');
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test.each([
    ['/details?id=424242'],
    ['/details/inconnu-424242'],
  ])('%s (fiche absente) → 404', async (url) => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get(url).redirects(0);
    expect(res.status).toBe(404);
    expect(res.text).not.toContain('<link rel="canonical" href="https://vol-histoire.titouan-borde.com/details">');
  });

  test('/details?id=X → 301 vers le slug, ?lang=en conservé', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 31, name: 'SR-71 Blackbird' }] });
    const res = await request(app).get('/details?id=31&lang=en').redirects(0);
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/details/sr-71-blackbird-31?lang=en');
  });
});

describe('PERF-010 — cache des images selon le versionnement', () => {
  test('image versionnée (?v=) → un an immuable', async () => {
    const res = await request(app).get('/assets/logo/icon-48.png?v=4.14.0');
    expect(res.status).toBe(200);
    expect(res.headers['cache-control']).toBe('public, max-age=31536000, immutable');
  });

  test('image non versionnée → une journée revalidée en arrière-plan', async () => {
    const res = await request(app).get('/og-default.jpg');
    expect(res.status).toBe(200);
    expect(res.headers['cache-control']).toBe('public, max-age=86400, s-maxage=604800, stale-while-revalidate=604800');
  });

  test('un autre paramètre que v ne rend pas l\'URL immuable', async () => {
    const res = await request(app).get('/assets/logo/icon-48.png?vv=1');
    expect(res.headers['cache-control']).not.toMatch(/immutable/);
  });
});

describe('HTML-004 / HTML-007 — icônes et visuel de partage', () => {
  test.each([
    ['/favicon.ico', /image\/(x-icon|vnd\.microsoft\.icon)/],
    ['/apple-touch-icon.png', /image\/png/],
    ['/assets/logo/icon-48.png', /image\/png/],
    ['/og-default.jpg', /image\/jpeg/],
  ])('%s existe', async (url, type) => {
    const res = await request(app).get(url);
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(type);
  });
});
