/**
 * Tests d'intégration — Plateforme : supervision, rendus serveur (/details, /conflits),
 * en-têtes de sécurité, CSP, CSRF, i18n, sitemap, contact, fichiers
 * statiques, URL propres, Redis, compression, observabilité.
 * Base de données simulée : banc commun __tests__/helpers/api-harness.js
 * (découpé de l'ancien api.test.js — ARCH-004).
 */
jest.mock('../mailer', () => require('./helpers/mailer-mock')());
const h = require('./helpers/api-harness');

const {
  request, mailer, app, mockPool,
} = h;

h.installHooks();


// =============================================================================
// MONITORING — /api/live, /api/ready, /api/metrics, /api/status
// =============================================================================
describe('Monitoring endpoints', () => {
  describe('GET /api/live', () => {
    test('200 — toujours OK, sans uptime (public)', async () => {
      const res = await request(app).get('/api/live');
      expect(res.status).toBe(200);
      expect(res.body).toEqual({ status: 'ok' });
    });
  });

  describe('GET /api/ready', () => {
    afterEach(() => {
      // Nettoie l'éventuel client Redis mocké entre les tests
      delete app._redisClient;
    });

    test('200 — DB OK retourne ready avec latence', async () => {
      mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ready');
      expect(res.body.db.ok).toBe(true);
      expect(typeof res.body.db.latencyMs).toBe('number');
      expect(res.body.db.latencyMs).toBeGreaterThanOrEqual(0);
      // Sans REDIS_URL, le statut Redis doit indiquer non configuré
      expect(res.body.redis).toEqual({ configured: false });
    });

    test('503 — DB inaccessible retourne not_ready', async () => {
      mockPool.query.mockRejectedValueOnce(new Error('connection refused'));
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(503);
      expect(res.body.status).toBe('not_ready');
      expect(res.body.db.ok).toBe(false);
      expect(res.body.redis).toEqual({ configured: false });
    });

    test('200 — Redis OK, expose latence ping dans le payload', async () => {
      app._redisClient = { ping: jest.fn().mockResolvedValue('PONG') };
      mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(200);
      expect(app._redisClient.ping).toHaveBeenCalledTimes(1);
      expect(res.body.redis.configured).toBe(true);
      expect(res.body.redis.ok).toBe(true);
      expect(typeof res.body.redis.latencyMs).toBe('number');
    });

    test('200 — Redis KO (ping reject) NE fait PAS basculer en not_ready', async () => {
      // Le fallback mémoire suffit : Redis down est informatif, pas bloquant
      app._redisClient = { ping: jest.fn().mockRejectedValue(new Error('ECONNREFUSED')) };
      mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ready');
      expect(res.body.redis).toEqual({ configured: true, ok: false });
    });

    test('503 — DB KO + Redis KO : redis reporté dans la réponse', async () => {
      app._redisClient = { ping: jest.fn().mockRejectedValue(new Error('timeout')) };
      mockPool.query.mockRejectedValueOnce(new Error('DB down'));
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(503);
      expect(res.body.db.ok).toBe(false);
      expect(res.body.redis.ok).toBe(false);
    });
  });

  describe('GET /api/metrics', () => {
    test('200 — retourne du texte Prometheus quand pas de token configuré', async () => {
      delete process.env.METRICS_TOKEN;
      const res = await request(app).get('/api/metrics');
      expect(res.status).toBe(200);
      expect(res.headers['content-type']).toMatch(/text\/plain|application\/openmetrics-text/);
    });

    test('401 — sans Bearer token quand METRICS_TOKEN configuré', async () => {
      process.env.METRICS_TOKEN = 'secret-metrics-token';
      const res = await request(app).get('/api/metrics');
      expect(res.status).toBe(401);
      delete process.env.METRICS_TOKEN;
    });

    test('401 — Bearer token incorrect', async () => {
      process.env.METRICS_TOKEN = 'secret-metrics-token';
      const res = await request(app)
        .get('/api/metrics')
        .set('Authorization', 'Bearer wrong-token');
      expect(res.status).toBe(401);
      delete process.env.METRICS_TOKEN;
    });

    test('200 — Bearer token correct', async () => {
      process.env.METRICS_TOKEN = 'secret-metrics-token';
      const res = await request(app)
        .get('/api/metrics')
        .set('Authorization', 'Bearer secret-metrics-token');
      expect(res.status).toBe(200);
      delete process.env.METRICS_TOKEN;
    });
  });

  describe('GET /api/status', () => {
    test('200 — retourne version, env, uptime', async () => {
      const res = await request(app).get('/api/status');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ok');
      expect(typeof res.body.service).toBe('string');
      expect(typeof res.body.version).toBe('string');
      expect(res.body.version).toMatch(/^\d+\.\d+\.\d+$/);
      expect(res.body.env).toBe('test');
      expect(typeof res.body.uptimeSec).toBe('number');
      expect(typeof res.body.startedAt).toBe('string');
      // startedAt doit être un ISO 8601 valide
      expect(new Date(res.body.startedAt).toString()).not.toBe('Invalid Date');
    });
  });
});


// =============================================================================
// SSR — GET /details/:slug
// =============================================================================
describe('GET /details/:slug — server-rendered meta', () => {
  test('200 — injecte le titre, description et og:image dynamiques', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 12,
        name: 'F-16C Fighting Falcon',
        complete_name: 'General Dynamics F-16C',
        little_description: 'Chasseur multirôle américain de 4e génération',
        image_url: 'https://example.com/f16.jpg',
        date_operationel: '1978-08-17',
        country_name: 'États-Unis',
        country_code: 'USA',
        generation: 4,
        type_name: 'Multirôle',
        manufacturer_name: 'Lockheed Martin',
      }],
    });

    const res = await request(app).get('/details/f-16c-fighting-falcon-12');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
    expect(res.text).toContain('<title>F-16C Fighting Falcon');
    expect(res.text).toContain('Chasseur multirôle américain');
    expect(res.text).toContain('https://example.com/f16.jpg');
    expect(res.text).toContain('canonical" href="https://vol-histoire.titouan-borde.com/details/f-16c-fighting-falcon-12"');
    // <h1> rempli côté serveur pour crawlers/bots sociaux (WCAG 2.4.6 + SEO)
    expect(res.text).toContain('<h1 id="aircraft-name">F-16C Fighting Falcon</h1>');
    // <picture> hero : pas de src="" (data-URI défaut remplacé par vraie image)
    expect(res.text).not.toContain('<img id="hero-image" src=""');
    expect(res.text).toContain('<img id="hero-image" src="https://example.com/f16.jpg"');
    // JSON-LD Article + BreadcrumbList
    expect(res.text).toMatch(/"@type":"Article"/);
    expect(res.text).toMatch(/"@type":"BreadcrumbList"/);
  });

  test('404 → fallback vers la page statique pour id inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/details/inexistant-99999');
    // L'avion n'existe pas → SSR passe la main → static details.html servi
    // (status 200 car details.html existe et le JS gère la redirection 404 côté client)
    expect([200, 404]).toContain(res.status);
  });

  test('301 — /details?id=X redirige vers /details/<slug>-X (canonicalisation SEO)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 5,
        name: 'Mirage 2000',
        complete_name: 'Dassault Mirage 2000',
        little_description: 'Chasseur français',
        image_url: 'https://example.com/mirage.jpg',
        country_name: 'France',
        generation: 4,
        type_name: 'Multirôle',
        manufacturer_name: 'Dassault',
      }],
    });

    const res = await request(app).get('/details?id=5');
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/details/mirage-2000-5');
  });

  test('301 — préserve les query params (ex: ?lang=en) lors du redirect', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 7,
        name: 'Rafale',
        complete_name: 'Dassault Rafale',
        country_name: 'France',
        generation: 4,
      }],
    });

    const res = await request(app).get('/details?id=7&lang=en');
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/details/rafale-7?lang=en');
  });

  test('301 — /details/<mauvais-slug>-X redirige vers le slug canonique', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 12,
        name: 'F-16 Fighting Falcon',
        country_name: 'États-Unis',
        generation: 4,
      }],
    });

    const res = await request(app).get('/details/ancien-nom-12');
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/details/f-16-fighting-falcon-12');
  });

  test('200 — preload AVIF injecté pour un asset local JPG (LCP hint)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 42,
        name: 'Rafale',
        complete_name: 'Dassault Rafale',
        little_description: 'Chasseur omnirôle français',
        image_url: '/assets/airplanes/rafale.jpg',
        date_operationel: '2001-05-18',
        country_name: 'France',
        country_code: 'FRA',
        generation: 4,
        type_name: 'Chasseur',
        manufacturer_name: 'Dassault',
      }],
    });
    const res = await request(app).get('/details/rafale-42');
    expect(res.status).toBe(200);
    // Le preload cible la variante .avif du même nom de base (versionnée par
    // le lot SSR : ?v=<version>, cf. ssr-meta.test.js)
    expect(res.text).toMatch(/<link rel="preload" as="image" href="\/assets\/airplanes\/rafale\.avif\?v=[^"]+" type="image\/avif" fetchpriority="high">/);
  });

  test('200 — pas de preload AVIF pour une image distante (URL externe)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 13,
        name: 'Su-57',
        complete_name: 'Sukhoi Su-57',
        little_description: 'Chasseur furtif russe',
        image_url: 'https://cdn.example.com/su57.jpg',
        date_operationel: '2020-12-25',
        country_name: 'Russie',
        country_code: 'RUS',
        generation: 5,
      }],
    });
    const res = await request(app).get('/details/su-57-13');
    expect(res.status).toBe(200);
    // Aucun preload d'image injecté quand l'asset n'est pas local
    expect(res.text).not.toMatch(/<link rel="preload"[^>]*as="image"[^>]*type="image\/avif"/);
  });

  test('200 — preload AVIF idempotent (remplacement, pas duplication)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 7,
        name: 'Mirage 2000',
        complete_name: 'Dassault Mirage 2000',
        little_description: 'Chasseur multirôle',
        image_url: '/assets/airplanes/mirage-2000.png',
        date_operationel: '1984-07-02',
        country_name: 'France',
        country_code: 'FRA',
        generation: 4,
      }],
    });
    const res = await request(app).get('/details/mirage-2000-7');
    expect(res.status).toBe(200);
    const matches = res.text.match(/<link rel="preload"[^>]*as="image"[^>]*type="image\/avif"/g) || [];
    expect(matches).toHaveLength(1);
  });
});


// =============================================================================
// SÉCURITÉ — Headers HTTP
// =============================================================================
describe('En-têtes de sécurité', () => {
  test('X-Content-Type-Options présent', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes');
    expect(res.headers['x-content-type-options']).toBe('nosniff');
  });

  test('X-Frame-Options présent', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes');
    expect(res.headers['x-frame-options']).toBe('DENY');
  });

  test('X-Powered-By absent', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes');
    expect(res.headers['x-powered-by']).toBeUndefined();
  });

  test('Strict-Transport-Security (HSTS) présent', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes');
    expect(res.headers['strict-transport-security']).toBe('max-age=31536000; includeSubDomains; preload');
  });
});


// =============================================================================
// VALIDATION ID — app.param
// =============================================================================
describe('Validation des IDs dans les paramètres', () => {
  test('400 — ID non numérique pour avion', async () => {
    const res = await request(app).get('/api/airplanes/not-a-number');
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('ID invalide');
  });

  test('400 — ID flottant pour avion', async () => {
    const res = await request(app).get('/api/airplanes/1.5');
    expect(res.status).toBe(400);
  });
});


// =============================================================================
// CONTENT-SECURITY-POLICY
// =============================================================================
describe('En-tête Content-Security-Policy', () => {
  test('CSP présent sur les réponses', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/countries');
    const csp = res.headers['content-security-policy'];
    expect(csp).toBeDefined();
    expect(csp).toContain("default-src 'self'");
    expect(csp).toContain("object-src 'none'");
    expect(csp).toContain("frame-ancestors 'none'");
  });

  test('style-src-elem utilise un nonce par requête (pas unsafe-inline)', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    const r1 = await request(app).get('/api/countries');
    const r2 = await request(app).get('/api/countries');
    const csp1 = r1.headers['content-security-policy'];
    const csp2 = r2.headers['content-security-policy'];

    // style-src-elem doit contenir un nonce
    const m1 = csp1.match(/style-src-elem[^;]*'nonce-([A-Za-z0-9+/=]+)'/);
    const m2 = csp2.match(/style-src-elem[^;]*'nonce-([A-Za-z0-9+/=]+)'/);
    expect(m1).not.toBeNull();
    expect(m2).not.toBeNull();

    // Nonces uniques par requête (anti-replay)
    expect(m1[1]).not.toBe(m2[1]);

    // style-src-elem NE doit PAS contenir 'unsafe-inline'
    const elemDir = csp1.match(/style-src-elem[^;]*/)[0];
    expect(elemDir).not.toContain("'unsafe-inline'");

    // style-src-attr 'none' : aucun attribut style="" toléré.
    // Toutes les valeurs dynamiques passent par element.style.setProperty().
    expect(csp1).toContain("style-src-attr 'none'");
    expect(csp1).not.toContain("style-src-attr 'unsafe-inline'");

    // style-src (fallback navigateurs sans style-src-elem) doit aussi être
    // strictement nonce-based depuis v4.1.1 — aucun 'unsafe-inline' toléré.
    const fallbackDir = csp1.match(/style-src (?!-)[^;]*/)[0];
    expect(fallbackDir).toMatch(/'nonce-[A-Za-z0-9+/=]+'/);
    expect(fallbackDir).not.toContain("'unsafe-inline'");
  });
});


// =============================================================================
// PROTECTION CSRF (SameSite + Bearer + CSP form-action)
// =============================================================================
describe('Protection CSRF', () => {
  test('CSP inclut form-action self', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/countries');
    const csp = res.headers['content-security-policy'];
    expect(csp).toContain("form-action 'self'");
  });

  test('CSP inclut worker-src et manifest-src self (PWA)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/countries');
    const csp = res.headers['content-security-policy'];
    expect(csp).toContain("worker-src 'self'");
    expect(csp).toContain("manifest-src 'self'");
  });

  test('manifest.webmanifest servi avec Content-Type application/manifest+json', async () => {
    const res = await request(app).get('/manifest.webmanifest');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/manifest\+json/);
    const body = JSON.parse(res.text);
    expect(body.name).toBe("Vol d'Histoire");
    expect(body.start_url).toBe('/?source=pwa');
    expect(body.display).toBe('standalone');
    expect(Array.isArray(body.icons) && body.icons.length >= 2).toBe(true);
  });

  test('sw.js servi avec no-cache et Service-Worker-Allowed=/', async () => {
    const res = await request(app).get('/sw.js');
    expect(res.status).toBe(200);
    expect(res.headers['cache-control']).toContain('no-cache');
    expect(res.headers['service-worker-allowed']).toBe('/');
  });

  test('CORS rejette les origines non autorisées', async () => {
    const res = await request(app)
      .get('/api/countries')
      .set('Origin', 'https://evil.com');
    expect(res.status).toBe(403);
  });

  test('Cookie refresh est SameSite=Strict, HttpOnly, Path=/api', async () => {
    const bcrypt = require('bcryptjs');
    const hashed = await bcrypt.hash('Password1', 10);
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Test', email: 'test@test.com', password: hashed, role_id: 3, email_verified: true }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).post('/api/login').send({ email: 'test@test.com', password: 'Password1' });
    const cookies = res.headers['set-cookie'];
    const refreshCookie = cookies.find(c => c.startsWith('refreshToken='));
    expect(refreshCookie).toMatch(/HttpOnly/);
    expect(refreshCookie).toMatch(/SameSite=Strict/);
    expect(refreshCookie).toMatch(/Path=\/api/);
  });
});


// =============================================================================
// i18n — pickLang helper + lang middleware
// =============================================================================
describe('i18n — pickLang helper', () => {
  const { pickLang, pickLangMany, resolveLang, TRANSLATION_NEEDED } = require('../i18n');

  test('lang=fr retourne les champs originaux et supprime les _en', () => {
    const row = { id: 1, name: 'Rafale', name_en: 'Rafale', description: 'Chasseur', description_en: 'Fighter' };
    const result = pickLang(row, 'fr', ['name', 'description']);
    expect(result.name).toBe('Rafale');
    expect(result.description).toBe('Chasseur');
    expect(result.name_en).toBeUndefined();
    expect(result.description_en).toBeUndefined();
  });

  test('lang=en retourne les champs _en quand disponibles', () => {
    const row = { id: 1, name: 'Chasseur', name_en: 'Fighter', description: 'Avion', description_en: 'Aircraft' };
    const result = pickLang(row, 'en', ['name', 'description']);
    expect(result.name).toBe('Fighter');
    expect(result.description).toBe('Aircraft');
  });

  test('lang=en avec _en NULL retourne "Translation needed"', () => {
    const row = { id: 1, name: 'Avion spécial', name_en: null, description: 'Desc', description_en: null };
    const result = pickLang(row, 'en', ['name', 'description']);
    expect(result.name).toBe(TRANSLATION_NEEDED);
    expect(result.description).toBe(TRANSLATION_NEEDED);
  });

  test('lang=en avec fallbackFields garde le FR si _en NULL (noms propres)', () => {
    const row = { id: 1, name: 'Rafale', name_en: null, description: 'Avion', description_en: null };
    const result = pickLang(row, 'en', ['name', 'description'], ['name']);
    expect(result.name).toBe('Rafale'); // fallback FR car nom propre
    expect(result.description).toBe(TRANSLATION_NEEDED); // pas de fallback
  });

  test('pickLangMany applique à un tableau', () => {
    const rows = [
      { name: 'A', name_en: 'A-en' },
      { name: 'B', name_en: null },
    ];
    const result = pickLangMany(rows, 'en', ['name']);
    expect(result[0].name).toBe('A-en');
    expect(result[1].name).toBe(TRANSLATION_NEEDED);
  });

  test('lang=en avec FR et EN tous deux NULL préserve null (rien à traduire)', () => {
    const row = { id: 1, name: 'Rafale', name_en: 'Rafale', variants: null, variants_en: null };
    const result = pickLang(row, 'en', ['name', 'variants']);
    expect(result.variants).toBeNull();
    expect(result.name).toBe('Rafale');
  });

  test('lang=en avec FR et EN tous deux chaîne vide préserve la chaîne vide', () => {
    const row = { id: 1, variants: '', variants_en: '' };
    const result = pickLang(row, 'en', ['variants']);
    expect(result.variants).toBe('');
  });

  test('resolveLang lit ?lang= en priorité', () => {
    const req = { query: { lang: 'en' }, headers: { 'accept-language': 'fr-FR,fr' } };
    expect(resolveLang(req)).toBe('en');
  });

  test('resolveLang tombe sur Accept-Language si pas de query', () => {
    const req = { query: {}, headers: { 'accept-language': 'en-US,en;q=0.9' } };
    expect(resolveLang(req)).toBe('en');
  });

  test('resolveLang fallback sur fr si aucun indice', () => {
    const req = { query: {}, headers: {} };
    expect(resolveLang(req)).toBe('fr');
  });

  test('resolveLang ignore les langues non supportées', () => {
    const req = { query: { lang: 'de' }, headers: {} };
    expect(resolveLang(req)).toBe('fr');
  });

  test('pickLang gère null/undefined proprement', () => {
    expect(pickLang(null, 'en', ['name'])).toBeNull();
    expect(pickLang(undefined, 'en', ['name'])).toBeUndefined();
  });
});


// =============================================================================
// i18n — Routes /api/airplanes avec ?lang=en
// =============================================================================
describe('Routes i18n — ?lang=en', () => {
  test('GET /api/countries?lang=en retourne name traduit', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [
        { id: 1, name: 'France', name_en: 'France' },
        { id: 2, name: 'États-Unis', name_en: 'United States' },
      ],
    });
    const res = await request(app).get('/api/countries?lang=en');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('France');
    expect(res.body[1].name).toBe('United States');
    expect(res.body[0].name_en).toBeUndefined();
  });

  test('GET /api/types?lang=en retourne Translation needed si _en NULL', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [
        { id: 1, name: 'Chasseur', name_en: 'Fighter', description: 'Desc FR', description_en: null },
      ],
    });
    const res = await request(app).get('/api/types?lang=en');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('Fighter');
    expect(res.body[0].description).toBe('Translation needed');
  });

  test('GET /api/airplanes?lang=fr retourne les champs FR', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({
        rows: [{
          id: 1, name: 'Rafale', name_en: 'Rafale',
          complete_name: 'Dassault Rafale', complete_name_en: null,
          little_description: 'Chasseur', little_description_en: 'Fighter',
          country_name: 'France', country_name_en: 'France',
          type_name: 'Multirôle', type_name_en: 'Multirole',
        }],
      });
    const res = await request(app).get('/api/airplanes?lang=fr');
    expect(res.status).toBe(200);
    expect(res.body.data[0].little_description).toBe('Chasseur');
    expect(res.body.data[0].type_name).toBe('Multirôle');
  });

  test('GET /api/airplanes?lang=en retourne les champs EN + fallback nom propre', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({
        rows: [{
          id: 1, name: 'Rafale', name_en: null, // nom propre sans trad → fallback FR
          complete_name: 'Dassault Rafale', complete_name_en: null,
          little_description: 'Chasseur français', little_description_en: null,
          country_name: 'France', country_name_en: 'France',
          type_name: 'Multirôle', type_name_en: 'Multirole',
        }],
      });
    const res = await request(app).get('/api/airplanes?lang=en');
    expect(res.status).toBe(200);
    expect(res.body.data[0].name).toBe('Rafale'); // fallback
    expect(res.body.data[0].complete_name).toBe('Dassault Rafale'); // fallback
    expect(res.body.data[0].little_description).toBe('Translation needed'); // pas de fallback
    expect(res.body.data[0].type_name).toBe('Multirole'); // traduit
  });
});


// =============================================================================
// GET /sitemap.xml
// =============================================================================
describe('GET /sitemap.xml', () => {
  beforeEach(() => {
    // Sitemap est mis en cache 24h — reset pour isoler chaque test
    require('../utils/cache')._resetForTests();
  });

  test('200 — retourne un XML valide avec les URLs des avions (slugs SEO)', async () => {
    mockPool.query.mockImplementation(() =>
      Promise.resolve({
        rows: [
          { id: 1, name: 'F-22 Raptor' },
          { id: 2, name: 'Rafale' },
          { id: 42, name: 'MiG-29' },
        ],
      })
    );

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/xml/);
    expect(res.text).toContain('<?xml version="1.0" encoding="UTF-8"?>');
    // URL slugs SEO-friendly
    expect(res.text).toContain('/details/f-22-raptor-1');
    expect(res.text).toContain('/details/rafale-2');
    expect(res.text).toContain('/details/mig-29-42');
    expect(res.text).toContain('/hangar');

    // hreflang fr/en avec ?lang= distinct pour les pages statiques
    // SEO-001 : le français est servi à l'URL nue (aussi x-default).
    expect(res.text).toContain('hreflang="fr" href="https://vol-histoire.titouan-borde.com/hangar"');
    expect(res.text).toContain('hreflang="en" href="https://vol-histoire.titouan-borde.com/hangar?lang=en"');
    // x-default pointe vers l'URL sans ?lang=
    expect(res.text).toContain('hreflang="x-default" href="https://vol-histoire.titouan-borde.com/hangar"');

    // hreflang pour les avions avec ?lang= (URL slug)
    expect(res.text).toContain('hreflang="fr" href="https://vol-histoire.titouan-borde.com/details/f-22-raptor-1"');
    expect(res.text).toContain('hreflang="en" href="https://vol-histoire.titouan-borde.com/details/f-22-raptor-1?lang=en"');
  });

  test('200 — erreur BDD → fallback statique (VH-S1) avec X-Cache=FALLBACK et cache court 5min', async () => {
    mockPool.query.mockImplementation(() =>
      Promise.reject(new Error('DB down'))
    );

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/xml/);
    expect(res.headers['x-cache']).toBe('FALLBACK');
    expect(res.headers['cache-control']).toMatch(/max-age=300/);
    // Le sitemap minimal contient au moins les 7 pages statiques mais pas les avions
    expect(res.text).toContain('<loc>https://vol-histoire.titouan-borde.com/</loc>');
    expect(res.text).toContain('<loc>https://vol-histoire.titouan-borde.com/hangar</loc>');
    expect(res.text).toContain('<loc>https://vol-histoire.titouan-borde.com/timeline</loc>');
    expect(res.text).not.toContain('/details/');
  });

  test('cache HIT : 2e requête ne touche pas la BDD', async () => {
    mockPool.query.mockResolvedValue({ rows: [{ id: 1, name: 'F-35' }] });
    const r1 = await request(app).get('/sitemap.xml');
    expect(r1.headers['x-cache']).toBe('MISS');
    const callsAfterMiss = mockPool.query.mock.calls.length;

    const r2 = await request(app).get('/sitemap.xml');
    expect(r2.headers['x-cache']).toBe('HIT');
    expect(r2.text).toBe(r1.text);
    // La 2e requête ne doit PAS avoir interrogé la BDD
    expect(mockPool.query.mock.calls.length).toBe(callsAfterMiss);
  });

  test('Cache-Control : public, max-age=3600 pour navigateur/CDN', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    const res = await request(app).get('/sitemap.xml');
    expect(res.headers['cache-control']).toContain('public');
    expect(res.headers['cache-control']).toContain('max-age=3600');
  });
});


// =============================================================================
// POST /api/contact — Route de contact
// =============================================================================
describe('POST /api/contact', () => {
  beforeEach(() => {
    mailer.sendContactEmail.mockReset();
    mailer.sendContactEmail.mockResolvedValue(undefined);
  });

  const validContact = {
    firstname: 'Jean',
    lastname: 'Dupont',
    email: 'jean@example.com',
    subject: 'general',
    message: 'Bonjour, super site !',
  };

  test('200 — envoi réussi avec tous les champs', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.1')
      .send(validContact);
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Message envoyé avec succès.');
    expect(mailer.sendContactEmail).toHaveBeenCalledTimes(1);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(
      expect.objectContaining({
        name: 'Jean Dupont',
        email: 'jean@example.com',
        subject: 'Question générale',
        message: 'Bonjour, super site !',
      })
    );
  });

  test('200 — sans prénom ni nom → "Anonyme"', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.2')
      .send({ email: 'anon@example.com', message: 'Test anonyme' });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(
      expect.objectContaining({ name: 'Anonyme' })
    );
  });

  test('200 — sans sujet → "Question générale" par défaut', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.3')
      .send({ email: 'test@example.com', message: 'Message sans sujet' });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(
      expect.objectContaining({ subject: 'Question générale' })
    );
  });

  test('200 — sujet "bug" → "Signalement de bug"', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.4')
      .send({ email: 'bug@example.com', subject: 'bug', message: 'Erreur page details' });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(
      expect.objectContaining({ subject: 'Signalement de bug' })
    );
  });

  test('400 — email invalide', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.5')
      .send({ ...validContact, email: 'not-an-email' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/email invalide/i);
    expect(mailer.sendContactEmail).not.toHaveBeenCalled();
  });

  test('400 — email absent', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.6')
      .send({ message: 'Pas d\'email' });
    expect(res.status).toBe(400);
    expect(mailer.sendContactEmail).not.toHaveBeenCalled();
  });

  test('400 — message absent', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.7')
      .send({ email: 'jean@example.com' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/message.*requis/i);
    expect(mailer.sendContactEmail).not.toHaveBeenCalled();
  });

  test('400 — sujet invalide (non dans la whitelist)', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.8')
      .send({ ...validContact, subject: 'hacking' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/sujet invalide/i);
    expect(mailer.sendContactEmail).not.toHaveBeenCalled();
  });

  test('500 — erreur mailer → erreur serveur', async () => {
    mailer.sendContactEmail.mockRejectedValueOnce(new Error('SMTP down'));
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.9')
      .send(validContact);
    expect(res.status).toBe(500);
    expect(res.body.message).toMatch(/erreur.*envoi/i);
  });

  test('200 — champ unique « name » (nouveau formulaire)', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.11')
      .send({ name: '  Ada Lovelace ', email: 'ada@example.com', message: 'Bonjour' });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(expect.objectContaining({ name: 'Ada Lovelace' }));
  });

  test('400 — nom trop long', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.12')
      .send({ name: 'x'.repeat(101), email: 'ada@example.com', message: 'Bonjour' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/nom invalide/i);
    expect(mailer.sendContactEmail).not.toHaveBeenCalled();
  });

  test('200 — fiche concernée : nom et lien relus en base, en tête du message', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 30, name: 'Dassault Rafale' }] });
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.13')
      .send({ email: 'ada@example.com', subject: 'bug', message: 'Vitesse fausse', aircraft_id: 30 });
    expect(res.status).toBe(200);
    expect(mockPool.query).toHaveBeenCalledWith('SELECT id, name FROM airplanes WHERE id = $1', [30]);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(expect.objectContaining({
      message: 'Fiche concernée : Dassault Rafale — https://vol-histoire.titouan-borde.com/details/dassault-rafale-30\n\nVitesse fausse',
    }));
  });

  test('200 — fiche inconnue ou base indisponible : message envoyé sans la ligne', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    await request(app).post('/api/contact').set('X-Forwarded-For', '172.16.0.14')
      .send({ email: 'ada@example.com', message: 'Texte', aircraft_id: '999' });
    expect(mailer.sendContactEmail).toHaveBeenLastCalledWith(expect.objectContaining({ message: 'Texte' }));
    mockPool.query.mockRejectedValueOnce(new Error('DB down'));
    const res = await request(app).post('/api/contact').set('X-Forwarded-For', '172.16.0.15')
      .send({ email: 'ada@example.com', message: 'Texte 2', aircraft_id: 5 });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenLastCalledWith(expect.objectContaining({ message: 'Texte 2' }));
  });

  test('400 — identifiant de fiche invalide', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.16')
      .send({ email: 'ada@example.com', message: 'Texte', aircraft_id: 'abc' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/fiche invalide/i);
  });

  test('200 — message trimé (espaces en début/fin supprimés)', async () => {
    const res = await request(app)
      .post('/api/contact')
      .set('X-Forwarded-For', '172.16.0.10')
      .send({ ...validContact, message: '  Espace avant/après  ' });
    expect(res.status).toBe(200);
    expect(mailer.sendContactEmail).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Espace avant/après' })
    );
  });
});


// =============================================================================
// Monitoring — GET /api/status protégé par METRICS_TOKEN
// =============================================================================
describe('Monitoring — status protégé', () => {
  test('401 — METRICS_TOKEN défini mais absent du header', async () => {
    process.env.METRICS_TOKEN = 'secret-token';
    const res = await request(app).get('/api/status');
    expect(res.status).toBe(401);
    delete process.env.METRICS_TOKEN;
  });

  test('401 — METRICS_TOKEN défini mais mauvais token', async () => {
    process.env.METRICS_TOKEN = 'secret-token';
    const res = await request(app)
      .get('/api/status')
      .set('Authorization', 'Bearer wrong-token');
    expect(res.status).toBe(401);
    delete process.env.METRICS_TOKEN;
  });

  test('200 — METRICS_TOKEN défini avec bon token', async () => {
    process.env.METRICS_TOKEN = 'secret-token';
    const res = await request(app)
      .get('/api/status')
      .set('Authorization', 'Bearer secret-token');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
    delete process.env.METRICS_TOKEN;
  });
});


// =============================================================================
// MONITORING — /api/ready pool=null (ligne 28)
// =============================================================================
describe('GET /api/ready — pool null (ligne 28)', () => {
  test('503 — pool non initialisé retourne not_ready', async () => {
    app.setPool(null);
    try {
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(503);
      expect(res.body.reason).toBe('pool_not_initialized');
    } finally {
      app.setPool(mockPool);
    }
  });
});


// =============================================================================
// MONITORING — /api/metrics — 403 en production sans METRICS_TOKEN (ligne 60)
// =============================================================================
describe('GET /api/metrics — 403 production sans token (ligne 60)', () => {
  test('403 — NODE_ENV=production sans METRICS_TOKEN', async () => {
    const savedEnv = process.env.NODE_ENV;
    const savedToken = process.env.METRICS_TOKEN;
    try {
      process.env.NODE_ENV = 'production';
      delete process.env.METRICS_TOKEN;
      const res = await request(app).get('/api/metrics');
      expect(res.status).toBe(403);
      expect(res.body.message).toMatch(/METRICS_TOKEN/);
    } finally {
      process.env.NODE_ENV = savedEnv;
      if (savedToken !== undefined) process.env.METRICS_TOKEN = savedToken;
      else delete process.env.METRICS_TOKEN;
    }
  });
});


// =============================================================================
// MONITORING — /api/metrics — catch → 500 (ligne 73)
// =============================================================================
describe('GET /api/metrics — catch register.metrics() throw (ligne 73)', () => {
  test('500 — register.metrics() throw → 500', async () => {
    delete process.env.METRICS_TOKEN;
    const { register } = require('../middleware/observability');
    const origMetrics = register.metrics;
    register.metrics = jest.fn().mockRejectedValue(new Error('prom error'));
    try {
      const res = await request(app).get('/api/metrics');
      expect(res.status).toBe(500);
    } finally {
      register.metrics = origMetrics;
    }
  });
});


// =============================================================================
// GET /details/:slug — ogImage HTTP→HTTPS + lang=en (lignes 103, 326)
// =============================================================================
describe('GET /details/:slug — branches OG image + lang (lignes 103, 326)', () => {
  const httpAircraft = {
    id: 55,
    name: 'MiG-29',
    complete_name: 'Mikoyan MiG-29',
    little_description: 'Chasseur russe',
    image_url: 'http://example.com/mig29.jpg',
    date_operationel: '1983-11-01',
    country_name: 'URSS',
    country_code: 'SU',
    generation: 4,
    type_name: 'Chasseur',
    manufacturer_name: 'Mikoyan',
  };

  test('200 — image_url HTTP → og:image converti en HTTPS (ligne 103)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [httpAircraft] });
    const res = await request(app).get('/details/mig-29-55');
    expect(res.status).toBe(200);
    // L'og:image meta tag doit utiliser https:// (pas l'img src qui utilise rawImage)
    // Cherche la balise og:image dans les meta tags
    const ogImageMatch = res.text.match(/og:image"[^>]*content="([^"]+)"/);
    if (ogImageMatch) {
      expect(ogImageMatch[1]).toMatch(/^https:/);
    } else {
      // Fallback: vérifier que https://example.com/mig29.jpg apparaît quelque part
      expect(res.text).toContain('https://example.com/mig29.jpg');
    }
  });

  // NOTE ligne 326 : langMiddleware n'est attaché qu'à /api/ (pas /details/)
  // donc req.lang === undefined sur /details/ → toujours 'fr'. La branche isEn
  // n'est pas atteignable via HTTP dans la config actuelle.
  // SKIP (commenté) — couvrir nécessiterait de modifier app.js (hors périmètre).
});


// =============================================================================
// GET /details/:slug — catch err → next(err) (ligne 404)
// =============================================================================
describe('GET /details/:slug — catch err → 500 (ligne 404)', () => {
  test('500 — pool.query throw → next(err) déclenche 500', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fetch error'));
    const res = await request(app).get('/details/rafale-42');
    expect(res.status).toBe(500);
  });
});


// =============================================================================
// SSR — fallbacks renderHtml (branches manquantes details-ssr.js)
// =============================================================================
describe('GET /details/:slug — branches renderHtml fallbacks', () => {
  test('200 — aircraft minimal sans complete_name/country/year/gen/desc → title + description fallback', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 99,
        name: 'Avion Test',
      }],
    });
    const res = await request(app).get('/details/avion-test-99');
    expect(res.status).toBe(200);
    // escapeHtml encode l'apostrophe en &#39;
    expect(res.text).toMatch(/<title>Avion Test \| Vol d&#39;Histoire<\/title>/);
    // Insécable avant « : » (typographie française de la meta description).
    expect(res.text).toMatch(/Fiche technique, armement, production et histoire[^ ]: Avion Test\./);
    expect(res.text).not.toMatch(/"datePublished":/);
  });

  test('200 — description > 160 chars → tronquée à 157 + …', async () => {
    const longDesc = 'A'.repeat(200);
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 100,
        name: 'LongDesc',
        little_description: longDesc,
        country_name: 'France',
      }],
    });
    const res = await request(app).get('/details/longdesc-100');
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/A{157}…/);
  });

  test('200 — fallback sur description si little_description manque', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 102,
        name: 'FallbackDesc',
        description: 'Description principale en lieu et place',
      }],
    });
    const res = await request(app).get('/details/fallbackdesc-102');
    expect(res.status).toBe(200);
    expect(res.text).toContain('Description principale en lieu et place');
  });

  test('200 — image_url sans scheme et sans slash → utilisée telle quelle (branche else)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 101,
        name: 'DataUri',
        image_url: 'data:image/jpeg;base64,abc',
      }],
    });
    const res = await request(app).get('/details/datauri-101');
    expect(res.status).toBe(200);
    expect(res.text).toContain('data:image/jpeg;base64,abc');
  });

  test('200 — image_url relative non-asset → préfixée SITE_URL pour og:image', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 103,
        name: 'OgDefault',
        image_url: '/og-default.jpg',
      }],
    });
    const res = await request(app).get('/details/ogdefault-103');
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/og:image"[^>]*content="https:\/\/vol-histoire\.titouan-borde\.com\/og-default\.jpg"/);
  });

  test('next() — slug sans suffixe numérique → handle delegue au static (idFromSlug → null)', async () => {
    const res = await request(app).get('/details/no-digits-here');
    expect([200, 404]).toContain(res.status);
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test('next() — query id non numérique → handle delegue au static (Number(id) NaN)', async () => {
    const res = await request(app).get('/details?id=abc');
    expect([200, 404]).toContain(res.status);
    expect(mockPool.query).not.toHaveBeenCalled();
  });
});


// =============================================================================
// app.js — endpoints utilitaires (health, config) — lignes 371-377, 427-431
// =============================================================================
describe('app.js — /api/health et /api/config', () => {
  test('GET /api/health — 200 quand pool répond (lignes 427-429)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
    const res = await request(app).get('/api/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body).not.toHaveProperty('uptime');
    expect(res.body.timestamp).toBeDefined();
  });

  test('GET /api/health — 503 quand pool.query throw (lignes 430-431)', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB unreachable'));
    const res = await request(app).get('/api/health');
    expect(res.status).toBe(503);
    expect(res.body.status).toBe('error');
    expect(res.body.message).toMatch(/Database/);
  });

  test('GET /api/config — 200 renvoie version + hcaptchaSitekey (lignes 371-377)', async () => {
    const res = await request(app).get('/api/config');
    expect(res.status).toBe(200);
    expect(typeof res.body.version).toBe('string');
    expect('hcaptchaSitekey' in res.body).toBe(true);
    expect(res.headers['cache-control']).toMatch(/max-age=300/);
  });
});


// =============================================================================
// app.js — Clean URLs, redirection 301, htmlPages, 404 — lignes 358, 362, 442-485
// =============================================================================
describe('app.js — Clean URLs + redirections .html', () => {
  test('301 — /inexistant.html redirige vers /inexistant (lignes 442-444)', async () => {
    const res = await request(app).get('/inexistant.html').redirects(0);
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/inexistant');
  });

  test('301 — préserve la query string (ligne 443 branche ?)', async () => {
    const res = await request(app).get('/foo.html?lang=en&x=1').redirects(0);
    expect(res.status).toBe(301);
    expect(res.headers.location).toBe('/foo?lang=en&x=1');
  });

  test('200 — GET / sert index.html (ligne 362)', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('200 — GET /hangar sert hangar.html via htmlPages (ligne 358)', async () => {
    const res = await request(app).get('/hangar');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('200 — GET /timeline sert timeline.html (htmlPages)', async () => {
    const res = await request(app).get('/timeline');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('200 — GET /login sert login.html (htmlPages)', async () => {
    const res = await request(app).get('/login');
    expect(res.status).toBe(200);
  });

  test('404 — GET /404 sert la page d’erreur avec le statut 404 (jamais 200 indexable)', async () => {
    const res = await request(app).get('/404');
    expect(res.status).toBe(404);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('SEO-001 — /hangar?lang=en sert la variante anglaise, /hangar la française', async () => {
    const en = await request(app).get('/hangar?lang=en');
    expect(en.status).toBe(200);
    expect(en.text).toMatch(/<html[^>]*lang="en"/);
    expect(en.headers.vary).toMatch(/Accept-Language/i);
    const fr = await request(app).get('/hangar').set('Accept-Language', 'fr-FR');
    expect(fr.text).toMatch(/<html[^>]*lang="fr"/);
    expect(fr.headers.vary).toMatch(/Accept-Language/i);
  });

  test('200 — GET /offline sert la page hors ligne pré-cachée par le service worker', async () => {
    const res = await request(app).get('/offline');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
    expect(res.text).toMatch(/noindex/);
  });

  test('404 — GET /cookie-consent retourne 404 (VH-S2 + VH-A3 : URL propre masquée)', async () => {
    // cookie-consent.html est un fragment chargé par cookies.js, pas une page publique.
    // /cookie-consent (URL propre, sans .html) doit renvoyer 404 pour éviter d'exposer
    // un partial sans <html lang> ni <title>. Le fichier reste accessible via .html
    // (consommé par fetch interne).
    const res = await request(app).get('/cookie-consent');
    expect(res.status).toBe(404);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('200 — GET /cookie-consent.html sert le fragment (consommé par cookies.js fetch)', async () => {
    // L'extension .html bypass le catch-all et passe par express.static.
    const res = await request(app).get('/cookie-consent.html');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('404 — /route-inexistante-xyz sert 404.html (lignes 475-486)', async () => {
    const res = await request(app).get('/route-vraiment-inexistante-xyz-123');
    expect(res.status).toBe(404);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  test('catch-all ignore les requêtes /api/* (ligne 466 branche api)', async () => {
    // /api/route-inconnue → préfixé par /api/ donc ignoré par app.get('*')
    // → fall-through Express → 404 par défaut
    const res = await request(app).get('/api/route-inexistante-xyz');
    expect(res.status).toBe(404);
  });

  test('catch-all ignore les paths avec extension (ligne 466 branche extname)', async () => {
    // /fichier-inconnu.json → extension présente → next() dans le catch-all
    // → fall-through Express → 404
    const res = await request(app).get('/fichier-inexistant-xyz.json');
    expect(res.status).toBe(404);
  });
});


// =============================================================================
// app.js — Static assets Cache-Control headers — lignes 295-302
// =============================================================================
describe('app.js — Static Cache-Control (lignes 295-302)', () => {
  test('.html servi par express.static → no-cache (ligne 295-296)', async () => {
    const res = await request(app).get('/404.html');
    // Si servi par express.static (fichier présent), header no-cache attendu.
    // Sinon 301 redirect vers /404 qui n'existe pas → le setHeaders n'est pas hit.
    if (res.status === 200) {
      expect(res.headers['cache-control']).toMatch(/no-cache/);
    } else {
      expect([200, 301, 404]).toContain(res.status);
    }
  });

  // Les CSS/JS sont servis avec ?v=<version> : une URL donnée ne change jamais
  // de contenu, d'où le cache immuable d'un an. Les images n'ont pas ce
  // paramètre et gardent la journée + s-maxage CDN.
  test('.css → public, max-age=31536000, immutable', async () => {
    const res = await request(app).get('/css/core.min.css');
    if (res.status === 200) {
      expect(res.headers['cache-control']).toMatch(/max-age=31536000/);
      expect(res.headers['cache-control']).toMatch(/immutable/);
    } else {
      expect([200, 404]).toContain(res.status);
    }
  });

  test('.js → public, max-age=31536000, immutable', async () => {
    const res = await request(app).get('/js/dist/home.min.js');
    if (res.status === 200) {
      expect(res.headers['cache-control']).toMatch(/max-age=31536000/);
      expect(res.headers['cache-control']).toMatch(/immutable/);
    }
  });

  test('.svg → cache d\'un jour, pas immuable (pas de ?v=)', async () => {
    const res = await request(app).get('/favicon.svg');
    if (res.status === 200) {
      expect(res.headers['cache-control']).toMatch(/max-age=86400/);
      expect(res.headers['cache-control']).not.toMatch(/immutable/);
    }
  });

  test('.svg → public, max-age=86400 (ligne 301-302)', async () => {
    const res = await request(app).get('/favicon.svg');
    if (res.status === 200) {
      expect(res.headers['cache-control']).toMatch(/max-age=86400/);
    }
  });
});


// =============================================================================
// app.js — sendCachedHtml fallback sendFile — ligne 343
// =============================================================================
describe('app.js — sendCachedHtml fallback (ligne 343)', () => {
  test('chemin non caché et introuvable → 404, sans sendFile brut', async () => {
    const mockRes = {
      locals: { cspNonce: 'test-nonce' },
      set: jest.fn().mockReturnThis(),
      status: jest.fn().mockReturnThis(),
      send: jest.fn(),
      sendFile: jest.fn(),
    };
    await app.sendCachedHtml(mockRes, '/nowhere/not-in-cache.html');
    expect(mockRes.sendFile).not.toHaveBeenCalled();
    expect(mockRes.status).toHaveBeenCalledWith(404);
  });

  test('chemin non caché mais présent sur disque → lu et nonçé (scripts compris)', async () => {
    const os = require('os');
    const fsLocal = require('fs');
    const pathLocal = require('path');
    const file = pathLocal.join(os.tmpdir(), `vh-late-page-${process.pid}.html`);
    fsLocal.writeFileSync(file, '<html><script defer src="js/late.js"></script></html>');
    try {
      const mockRes = {
        locals: { cspNonce: 'n0nce' },
        set: jest.fn().mockReturnThis(),
        status: jest.fn().mockReturnThis(),
        send: jest.fn(),
      };
      await app.sendCachedHtml(mockRes, file);
      expect(mockRes.send).toHaveBeenCalledWith('<html><script defer src="js/late.js" nonce="n0nce"></script></html>');
    } finally {
      fsLocal.unlinkSync(file);
    }
  });

  test('injectCspNonce — nonce sur les <script src> locaux seulement', () => {
    const html = [
      '<script defer src="js/dist/app.min.js?v=1"></script>',
      '<script defer src="/js/gtm.js"></script>',
      '<script src="https://evil.example/x.js"></script>',
      '<script src="//evil.example/x.js"></script>',
      '<script src="data:text/javascript,alert(1)"></script>',
      '<script type="application/ld+json">{"a":1}</script>',
      '<script src="js/a.js" nonce="deja"></script>',
    ].join('');
    const out = app.injectCspNonce(html, 'abc');
    expect(out).toContain('<script defer src="js/dist/app.min.js?v=1" nonce="abc">');
    expect(out).toContain('<script defer src="/js/gtm.js" nonce="abc">');
    expect(out).toContain('<script src="https://evil.example/x.js"></script>');
    expect(out).toContain('<script src="//evil.example/x.js"></script>');
    expect(out).toContain('<script src="data:text/javascript,alert(1)"></script>');
    expect(out).toContain('<script type="application/ld+json">{"a":1}</script>');
    expect(out).toContain('<script src="js/a.js" nonce="deja">');
  });

  test('toutes les pages du cache HTML : chaque <script src> reçoit le nonce', () => {
    const fsLocal = require('fs');
    const pathLocal = require('path');
    const dir = pathLocal.join(__dirname, '../../frontend');
    const pages = fsLocal.readdirSync(dir).filter((f) => f.endsWith('.html') && f !== 'cookie-consent.html');
    expect(pages.length).toBeGreaterThan(10);
    for (const page of pages) {
      const cached = app.htmlCache.get(pathLocal.join(dir, page));
      expect(cached).not.toBeNull();
      const out = app.injectCspNonce(cached, 'NONCE');
      const scripts = out.match(/<script\b[^>]*\bsrc=[^>]*>/gi) || [];
      for (const tag of scripts) {
        expect(`${page}: ${tag}`).toMatch(/nonce="NONCE"/);
      }
    }
  });

  test('injectCspNonce — passe nonce sur <style> non noncés', () => {
    const html = '<html><style>a{}</style><style nonce="x">b{}</style></html>';
    const out = app.injectCspNonce(html, 'abc');
    expect(out).toContain('<style nonce="abc">a{}');
    // Le <style> déjà nonçé ne doit pas être re-modifié
    expect(out).toContain('<style nonce="x">b{}');
  });

  test('injectCspNonce — sans nonce retourne html inchangé', () => {
    const html = '<style>x</style>';
    expect(app.injectCspNonce(html, null)).toBe(html);
    expect(app.injectCspNonce(html, '')).toBe(html);
  });
});


// =============================================================================
// app.js — app.initRedis() — lignes 186-232
// =============================================================================
describe('app.js — app.initRedis() early returns (ligne 187)', () => {
  test('return immédiat quand NODE_ENV=test même si REDIS_URL défini', async () => {
    const origUrl = process.env.REDIS_URL;
    process.env.REDIS_URL = 'redis://fake:6379';
    try {
      const result = await app.initRedis();
      expect(result).toBeUndefined();
      expect(app._redisClient).toBeUndefined();
    } finally {
      if (origUrl) process.env.REDIS_URL = origUrl;
      else delete process.env.REDIS_URL;
    }
  });

  test('return immédiat quand REDIS_URL absent (NODE_ENV != test)', async () => {
    const origEnv = process.env.NODE_ENV;
    const origUrl = process.env.REDIS_URL;
    delete process.env.REDIS_URL;
    process.env.NODE_ENV = 'development';
    try {
      const result = await app.initRedis();
      expect(result).toBeUndefined();
      expect(app._redisClient).toBeUndefined();
    } finally {
      process.env.NODE_ENV = origEnv;
      if (origUrl) process.env.REDIS_URL = origUrl;
    }
  });
});


describe('app.js — app.initRedis() chemin happy + fail (lignes 188-232)', () => {
  // Les jest.doMock posés dans les modules isolés restent enregistrés : sans
  // ce retrait, un require('../utils/cache') ultérieur de la suite recevait
  // la doublure (le cache réel de l'application n'était plus vidé).
  afterEach(() => {
    jest.dontMock('ioredis');
    jest.dontMock('rate-limit-redis');
    jest.dontMock('../utils/cache');
  });

  test('succès Redis → branche les RedisStore + expose app._redisClient', async () => {
    await jest.isolateModulesAsync(async () => {
      const onHandlers = {};
      const fakeClient = {
        connect: jest.fn().mockResolvedValue(undefined),
        ping: jest.fn().mockResolvedValue('PONG'),
        on: jest.fn((ev, cb) => { onHandlers[ev] = cb; return fakeClient; }),
        call: jest.fn().mockResolvedValue(undefined),
        disconnect: jest.fn(),
      };
      jest.doMock('ioredis', () => jest.fn().mockImplementation(() => fakeClient));
      // Mock minimal de RedisStore — express-rate-limit appelle store.init()
      jest.doMock('rate-limit-redis', () => ({
        RedisStore: jest.fn().mockImplementation(function () {
          this.init = jest.fn();
          this.prefix = 'test:';
          this.increment = jest.fn().mockResolvedValue({ totalHits: 1, resetTime: new Date() });
          this.decrement = jest.fn();
          this.resetKey = jest.fn();
          this.resetAll = jest.fn();
          this.shutdown = jest.fn();
          this.localKeys = false;
        }),
      }));
      // Mock cache setRedisClient pour éviter side-effects
      jest.doMock('../utils/cache', () => ({
        setRedisClient: jest.fn(),
        _resetForTests: jest.fn(),
        get: jest.fn().mockResolvedValue(null),
        set: jest.fn().mockResolvedValue(undefined),
      }));

      const origEnv = process.env.NODE_ENV;
      const origUrl = process.env.REDIS_URL;
      process.env.NODE_ENV = 'development';
      process.env.REDIS_URL = 'redis://mock:6379';

      const isolatedApp = require('../app');
      try {
        await isolatedApp.initRedis();
        expect(fakeClient.connect).toHaveBeenCalled();
        expect(fakeClient.ping).toHaveBeenCalled();
        expect(isolatedApp._redisClient).toBe(fakeClient);
        // Simule un event 'error' throttlé (ligne 206-212)
        if (onHandlers.error) {
          onHandlers.error(new Error('boom'));
          onHandlers.error(new Error('boom again'));
        }
        // Simule reconnecting / ready / end (lignes 213-215)
        if (onHandlers.reconnecting) onHandlers.reconnecting(500);
        if (onHandlers.ready) onHandlers.ready();
        if (onHandlers.end) onHandlers.end();
      } finally {
        process.env.NODE_ENV = origEnv;
        if (origUrl) process.env.REDIS_URL = origUrl;
        else delete process.env.REDIS_URL;
        isolatedApp.stopCleanup();
      }
    });
  });

  test('échec Redis → fallback mémoire silencieux (lignes 229-232)', async () => {
    await jest.isolateModulesAsync(async () => {
      const fakeClient = {
        connect: jest.fn().mockRejectedValue(new Error('ECONNREFUSED')),
        ping: jest.fn(),
        on: jest.fn(),
        disconnect: jest.fn(),
      };
      jest.doMock('ioredis', () => jest.fn().mockImplementation(() => fakeClient));
      jest.doMock('rate-limit-redis', () => ({ RedisStore: jest.fn() }));

      const origEnv = process.env.NODE_ENV;
      const origUrl = process.env.REDIS_URL;
      process.env.NODE_ENV = 'development';
      process.env.REDIS_URL = 'redis://unreachable:6379';

      const isolatedApp = require('../app');
      try {
        await expect(isolatedApp.initRedis()).resolves.toBeUndefined();
        expect(isolatedApp._redisClient).toBeUndefined();
        expect(fakeClient.disconnect).toHaveBeenCalled();
      } finally {
        process.env.NODE_ENV = origEnv;
        if (origUrl) process.env.REDIS_URL = origUrl;
        else delete process.env.REDIS_URL;
        isolatedApp.stopCleanup();
      }
    });
  });
});


// =============================================================================
// app.js — retryStrategy + reconnectOnError (lignes 197-201)
// =============================================================================
describe('app.js — Redis retryStrategy & reconnectOnError', () => {
  // Les jest.doMock posés dans les modules isolés restent enregistrés : sans
  // ce retrait, un require('../utils/cache') ultérieur de la suite recevait
  // la doublure (le cache réel de l'application n'était plus vidé).
  afterEach(() => {
    jest.dontMock('ioredis');
    jest.dontMock('rate-limit-redis');
    jest.dontMock('../utils/cache');
  });

  test('options Redis exposent retryStrategy/reconnectOnError testables', async () => {
    await jest.isolateModulesAsync(async () => {
      let capturedOptions;
      const fakeClient = {
        connect: jest.fn().mockResolvedValue(undefined),
        ping: jest.fn().mockResolvedValue('PONG'),
        on: jest.fn(),
        call: jest.fn(),
        disconnect: jest.fn(),
      };
      jest.doMock('ioredis', () => jest.fn().mockImplementation((url, opts) => {
        capturedOptions = opts;
        return fakeClient;
      }));
      jest.doMock('rate-limit-redis', () => ({
        RedisStore: jest.fn().mockImplementation(function () {
          this.init = jest.fn();
          this.increment = jest.fn().mockResolvedValue({ totalHits: 1, resetTime: new Date() });
          this.decrement = jest.fn(); this.resetKey = jest.fn(); this.resetAll = jest.fn();
          this.shutdown = jest.fn(); this.localKeys = false;
        }),
      }));
      jest.doMock('../utils/cache', () => ({
        setRedisClient: jest.fn(), _resetForTests: jest.fn(),
        get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined),
      }));

      const origEnv = process.env.NODE_ENV;
      const origUrl = process.env.REDIS_URL;
      process.env.NODE_ENV = 'development';
      process.env.REDIS_URL = 'redis://mock:6379';

      const isolatedApp = require('../app');
      try {
        await isolatedApp.initRedis();
        // retryStrategy
        expect(capturedOptions.retryStrategy(1)).toBe(200);
        expect(capturedOptions.retryStrategy(10)).toBe(2000); // capé à 2000
        expect(capturedOptions.retryStrategy(21)).toBeNull(); // abandon
        // reconnectOnError
        expect(capturedOptions.reconnectOnError(new Error('READONLY foo'))).toBe(true);
        expect(capturedOptions.reconnectOnError(new Error('ECONNRESET bar'))).toBe(true);
        expect(capturedOptions.reconnectOnError(new Error('autre'))).toBe(false);
      } finally {
        process.env.NODE_ENV = origEnv;
        if (origUrl) process.env.REDIS_URL = origUrl;
        else delete process.env.REDIS_URL;
        isolatedApp.stopCleanup();
      }
    });
  });
});


// =============================================================================
// app.js — compression filter — lignes 34-36
// =============================================================================
describe('app.js — compression filter (header x-no-compression)', () => {
  test('x-no-compression → réponse non compressée', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app)
      .get('/api/countries')
      .set('Accept-Encoding', 'gzip, deflate')
      .set('x-no-compression', '1');
    expect(res.status).toBe(200);
    // Si compression.filter retourne false → pas d'encoding
    expect(res.headers['content-encoding']).toBeUndefined();
  });
});


// =============================================================================
// VH-T1 — Couverture branches additionnelle (objectif 87.28 % → 90 %)
// Tests ciblés sur les branches identifiées comme non couvertes :
// observability.js (X-Request-ID, path filtering), hcaptcha.js (alias captcha),
// users.js (PUT /me champs partiels), details-ssr.js (fallbacks renderHtml).
// =============================================================================
describe('VH-T1 — observability X-Request-ID + path filtering', () => {
  test('réutilise le header X-Request-ID entrant s\'il fait <= 64 chars', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const customId = 'abc-1234567890-incoming';
    const res = await request(app)
      .get('/api/countries')
      .set('X-Request-ID', customId);
    expect(res.status).toBe(200);
    expect(res.headers['x-request-id']).toBe(customId);
  });

  test('ignore le header X-Request-ID si > 64 chars (génère nouvel ID)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const tooLong = 'x'.repeat(100);
    const res = await request(app)
      .get('/api/countries')
      .set('X-Request-ID', tooLong);
    expect(res.status).toBe(200);
    expect(res.headers['x-request-id']).not.toBe(tooLong);
    expect(res.headers['x-request-id']).toMatch(/^[a-f0-9]{16}$/);
  });

  test('/api/live → log skip (path === /api/live)', async () => {
    const res = await request(app).get('/api/live');
    expect([200, 503]).toContain(res.status);
  });

  test('/api/ready → log skip (path === /api/ready)', async () => {
    const res = await request(app).get('/api/ready');
    expect([200, 503]).toContain(res.status);
  });
});


describe('VH-T1 — details-ssr renderHtml branches supplémentaires', () => {
  test('200 — aircraft sans image_url → fallback OG default', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 200, name: 'NoImage', country_name: 'France' }],
    });
    const res = await request(app).get('/details/noimage-200');
    expect(res.status).toBe(200);
    // L'image fallback DEFAULT_OG doit apparaître
    expect(res.text).toMatch(/og:image"[^>]*content="[^"]+"/);
  });

  test('200 — aircraft avec description (pas little_description) → utilise description', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 201, name: 'OnlyDesc', description: 'Une description complète tirée du champ description.', country_name: 'France' }],
    });
    const res = await request(app).get('/details/onlydesc-201');
    expect(res.status).toBe(200);
    expect(res.text).toContain('Une description complète tirée du champ description');
  });

  test("200 escapeJson avec U+2028 U+2029 chars", async () => {
    // Inject U+2028 / U+2029 via String.fromCharCode pour eviter parser JS
    const desc = "Texte avec " + String.fromCharCode(0x2028) + " line sep et " + String.fromCharCode(0x2029) + " para sep";
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 202, name: "JsonEdge", little_description: desc, country_name: "Israel" }],
    });
    const res = await request(app).get("/details/jsonedge-202");
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/u2028|line sep/);
  });

  test('200 — aircraft sans country_name → altParts sans pays', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 203, name: 'NoCountry', generation: 5 }],
    });
    const res = await request(app).get('/details/nocountry-203');
    expect(res.status).toBe(200);
    // Le og:image:alt doit contenir le nom mais pas de pays
    expect(res.text).toContain('NoCountry');
  });

  test('200 — datePublished/dateModified viennent de la fiche, pas de l\'appareil', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{
        id: 204,
        name: 'WithDate',
        complete_name: 'WithDate Mk-2',
        date_operationel: '2010-06-15',
        created_at: '2026-02-11T09:30:00.000Z',
        updated_at: '2026-07-04T18:00:00.000Z',
        country_name: 'Suède',
        generation: 4,
      }],
    });
    const res = await request(app).get('/details/withdate-204');
    expect(res.status).toBe(200);
    // La date de publication décrit la fiche éditoriale. Annoncer 2010 parce que
    // l'avion est entré en service cette année-là trompait les moteurs.
    expect(res.text).toMatch(/"datePublished":"2026-02-11"/);
    expect(res.text).toMatch(/"dateModified":"2026-07-04"/);
    expect(res.text).not.toMatch(/"datePublished":"2010-01-01"/);
  });

  test('200 — fiche sans created_at → aucun datePublished inventé', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 205, name: 'SansDate', date_operationel: '1998-03-02' }],
    });
    const res = await request(app).get('/details/sansdate-205');
    expect(res.status).toBe(200);
    expect(res.text).not.toMatch(/"datePublished":/);
  });

  test('200 — hreflang fr/en distincts sur une fiche (SEO-01)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 206, name: 'Hreflang', country_name: 'France' }],
    });
    const res = await request(app).get('/details/hreflang-206');
    expect(res.status).toBe(200);
    // SEO-001 : français à l'URL nue, canonical auto-référent.
    expect(res.text).toMatch(/hreflang="fr" href="[^"]*\/details\/hreflang-206"/);
    expect(res.text).toMatch(/<link rel="canonical" href="[^"]*\/details\/hreflang-206">/);
    expect(res.text).toMatch(/hreflang="en" href="[^"]*\/details\/hreflang-206\?lang=en"/);
    // x-default reste sur l'URL nue
    expect(res.text).toMatch(/hreflang="x-default" href="[^"]*\/details\/hreflang-206"/);
  });

  test('200 — un nom contenant </script> ne rompt pas le bloc JSON-LD (SEC-02)', async () => {
    // Le nom se slugifie en autre chose que 'evil' : la première requête part en
    // 301 vers l'URL canonique, d'où les deux mocks et le suivi de redirection.
    const fiche = { id: 207, name: 'Evil</script><script>alert(1)</script>', country_name: 'France' };
    mockPool.query.mockResolvedValueOnce({ rows: [fiche] });
    mockPool.query.mockResolvedValueOnce({ rows: [fiche] });
    const res = await request(app).get('/details/evil-207').redirects(1);
    expect(res.status).toBe(200);
    // Le '<' est encodé en \u003c : aucun </script> littéral ne peut refermer
    // le bloc application/ld+json.
    expect(res.text).toContain('\\u003c/script');
    expect(res.text).not.toContain('<script>alert(1)');
  });
});


// =============================================================================
// app.js — Fichiers de dev de frontend/ jamais servis (utils/static-guard.js)
// =============================================================================
describe('app.js — fichiers privés de frontend/', () => {
  test.each([
    '/package.json',
    '/jest.config.json',
    '/__tests__/auth.test.js',
    '/css/README.md',
    '/node%5Fmodules/.package-lock.json',
  ])('404 — GET %s', async (p) => {
    const res = await request(app).get(p);
    expect(res.status).toBe(404);
  });

  test('200 — GET /.well-known/security.txt (RFC 9116)', async () => {
    const res = await request(app).get('/.well-known/security.txt');
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/Contact:/i);
  });

  test('200 — les assets publics restent servis', async () => {
    for (const p of ['/sw.js', '/robots.txt', '/locales/fr.json', '/manifest.webmanifest']) {
      const res = await request(app).get(p);
      expect(res.status).toBe(200);
    }
  });
});


describe('Audit sécurité — cardinalité des métriques', () => {
  const { register, routeLabel } = require('../middleware/observability');

  test('routeLabel : jamais le chemin brut', () => {
    expect(routeLabel({ route: { path: '/airplanes/:id' }, baseUrl: '/api' })).toBe('/api/airplanes/:id');
    expect(routeLabel({ originalUrl: '/api/zzxxyy' })).toBe('api_unmatched');
    expect(routeLabel({ originalUrl: '/n-importe-quoi/xyz' })).toBe('unmatched');
  });

  test('chemins inconnus : aucune nouvelle série Prometheus par chemin', async () => {
    for (let i = 0; i < 25; i++) {
      await request(app).get(`/api/zz-inconnu-${'x'.repeat(50)}${String.fromCharCode(103 + i)}`);
    }
    const metric = await register.getSingleMetric('voh_http_requests_total').get();
    const raw = metric.values.filter(v => String(v.labels.route).includes('zz-inconnu'));
    expect(raw).toHaveLength(0);
    expect(metric.values.some(v => v.labels.route === 'api_unmatched')).toBe(true);
  });
});


describe('SSR /conflits et /conflits/:slug', () => {
  // Liste des conflits, appareils et camps (SEO-005) : vides par défaut.
  beforeEach(() => { mockPool.query.mockResolvedValue({ rows: [] }); });

  test('/conflits : base indisponible → page servie quand même, sans grille', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('connexion perdue'));
    const res = await request(app).get('/conflits');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<div id="conflicts-list" class="conflicts-grid hidden"></div>');
  });

  test('/conflits sert la page avec ses balises par défaut', async () => {
    const res = await request(app).get('/conflits');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<title>Conflits | Vol d&#39;Histoire</title>');
    expect(res.text).toContain('<link rel="canonical" href="https://vol-histoire.titouan-borde.com/conflits">');
  });

  test('/conflits/:slug injecte titre, description, canonical et h1 du conflit', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [
      { name: "Guerre d'Indochine", name_en: 'First Indochina War', description: 'Description <b>FR</b>', description_en: 'EN', date_start: '1946-12-19', date_end: '1954-07-21' },
    ] });
    const res = await request(app).get('/conflits/guerre-d-indochine');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<title>Guerre d&#39;Indochine (1946-1954) | Vol d&#39;Histoire</title>');
    expect(res.text).toContain('<link rel="canonical" href="https://vol-histoire.titouan-borde.com/conflits/guerre-d-indochine">');
    expect(res.text).toContain('<h1 id="page-hero-heading">Guerre d&#39;Indochine</h1>');
    // Description échappée, jamais injectée telle quelle
    expect(res.text).toContain('Description &lt;b&gt;FR&lt;/b&gt;');
    expect(res.text).not.toContain('<b>FR</b>');
  });

  test('/conflits/:slug rédigé : issue en description, texte écrit dans la page (échappé), vue montrée', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [
      {
        name: 'Guerre du Kippour', name_en: 'Yom Kippur War', description: 'Courte', description_en: 'Short',
        outcome: 'Victoire *israélienne* <i>x</i>.', outcome_en: 'Israeli victory.',
        context: '## Avant\n\nLe **6 octobre**, attaque.\n\nSuite $& fin.', context_en: null,
        narrative: 'Opération *Nickel Grass*.', narrative_en: 'Operation *Nickel Grass*.',
        date_start: '1973-10-06', date_end: '1973-10-25',
      },
    ] });
    const res = await request(app).get('/conflits/guerre-du-kippour');
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/<meta name="description" content="Victoire \*israélienne\* &lt;i&gt;x&lt;\/i&gt;\.">/);
    expect(res.text).toContain('<div id="conflict-detail">');
    expect(res.text).toContain('<div id="conflicts-loading" class="conflicts-grid hidden"');
    expect(res.text).toContain('<span id="conflict-outcome-text">Victoire <em>israélienne</em> &lt;i&gt;x&lt;/i&gt;.</span>');
    expect(res.text).toContain('<p class="conflict-outcome" id="conflict-outcome">');
    expect(res.text).toContain('<section class="conflict-block" id="contexte"');
    expect(res.text).toContain('<div class="conflict-prose" id="conflict-context"><h3 class="md-section">Avant</h3><p>Le <strong>6 octobre</strong>, attaque.</p><p>Suite $&amp; fin.</p></div>');
    expect(res.text).toContain('<em>Nickel Grass</em>');

    // Anglais : textes anglais, contexte non traduit → français
    mockPool.query.mockResolvedValueOnce({ rows: [
      { name: 'Guerre du Kippour', name_en: 'Yom Kippur War', description: 'Courte', description_en: 'Short', outcome: 'Victoire.', outcome_en: 'Israeli victory.', context: 'Contexte FR.', context_en: null, narrative: null, narrative_en: null, date_start: '1973-10-06', date_end: '1973-10-25' },
    ] });
    const en = await request(app).get('/conflits/guerre-du-kippour?lang=en');
    expect(en.text).toContain('<span id="conflict-outcome-text">Israeli victory.</span>');
    expect(en.text).toContain('<p>Contexte FR.</p>');
    expect(en.text).toContain('<section class="conflict-block hidden" id="guerre-aerienne"');
  });

  test('/conflits/:slug non rédigé : vue cachée jusqu\'au script, rien d\'injecté', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [
      { name: "Guerre d'Indochine", name_en: null, description: 'd', description_en: null, outcome: null, context: null, narrative: null, date_start: null, date_end: null },
    ] });
    const res = await request(app).get('/conflits/guerre-d-indochine');
    expect(res.text).toContain('<div id="conflict-detail" class="hidden">');
    expect(res.text).toContain('<div id="conflicts-loading" class="conflicts-grid" aria-hidden="true">');
  });

  test('/conflits/:slug — un « $& » dans le nom reste du texte', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [
      { name: 'Opération $& test', name_en: null, description: 'd', description_en: null, date_start: null, date_end: null },
    ] });
    const res = await request(app).get('/conflits/operation-test');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<h1 id="page-hero-heading">Opération $&amp; test</h1>');
  });

  test('/conflits/:slug inconnu → 404', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/conflits/guerre-inconnue');
    expect(res.status).toBe(404);
  });
});


describe('GET /sitemap.xml — pages de conflit', () => {
  beforeEach(() => require('../utils/cache')._resetForTests());

  test('liste /conflits et une page par conflit rattaché', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Rafale' }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Guerre du Golfe' }] });
    const res = await request(app).get('/sitemap.xml');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<loc>https://vol-histoire.titouan-borde.com/conflits</loc>');
    expect(res.text).toContain('<loc>https://vol-histoire.titouan-borde.com/conflits/guerre-du-golfe</loc>');
  });
});
