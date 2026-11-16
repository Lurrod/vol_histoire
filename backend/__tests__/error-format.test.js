/**
 * Format des erreurs 404 et informations exposées par les sondes publiques
 * (audit externe du 2026-11-16).
 *
 * Avant : « Cannot GET /api/login » (page par défaut d'Express) sur l'API,
 * « Not Found » en texte brut sur les fichiers de dev bloqués, et l'uptime du
 * processus (donc la date du dernier redémarrage) sur /api/health et /api/live.
 * Désormais deux formats seulement : JSON sous /api, page 404 du site ailleurs.
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

const mockPool = { query: jest.fn() };

beforeAll(() => app.setPool(mockPool));
beforeEach(() => mockPool.query.mockReset());
afterAll(() => {
  delete app._redisClient;
  app.stopCleanup();
});

const PAGE_404 = 'class="error-page"';

describe('404 sous /api : JSON, jamais la page par défaut d\'Express', () => {
  test.each([
    ['get', '/api/login'],          // route POST seulement
    ['get', '/api/nexiste-pas'],
    ['post', '/api/nexiste-pas'],
    ['delete', '/api/airplanes'],    // méthode non routée
    ['get', '/api'],
  ])('%s %s → 404 JSON', async (method, url) => {
    const res = await request(app)[method](url);
    expect(res.status).toBe(404);
    expect(res.headers['content-type']).toMatch(/application\/json/);
    expect(res.body).toEqual({ message: 'Ressource introuvable' });
    expect(res.text).not.toMatch(/Cannot/);
  });
});

describe('404 hors /api : la page 404 du site', () => {
  test.each([
    ['get', '/package.json'],
    ['get', '/package-lock.json'],
    ['get', '/README.md'],
    ['get', '/node_modules/'],
    ['get', '/node_modules/jest/package.json'],
    ['get', '/fichier-absent.js'],
    ['get', '/assets/absente.png'],
    ['post', '/nexiste-pas'],
    ['put', '/hangar'],
  ])('%s %s → 404 avec la page du site', async (method, url) => {
    // Le slash final est retiré par une 301, comme pour n'importe quel
    // dossier absent : la redirection ne distingue donc rien.
    const res = await request(app)[method](url).redirects(1);
    expect(res.status).toBe(404);
    expect(res.headers['content-type']).toMatch(/text\/html/);
    expect(res.text).toContain(PAGE_404);
    expect(res.text).not.toMatch(/Cannot (GET|POST|PUT)/);
  });

  test('HEAD sur un fichier absent → 404', async () => {
    const res = await request(app).head('/fichier-absent.js');
    expect(res.status).toBe(404);
  });
});

describe('Répertoires statiques : pas de boucle de redirection', () => {
  // canonicalPageRedirect retire le slash final, express.static le remettait
  // (redirect: true par défaut) : /css/ → /css → /css/ → … jusqu'à l'abandon
  // du client. Un répertoire sans slash doit finir en 404, comme une page absente.
  test.each(['/css', '/js', '/assets', '/fonts', '/locales', '/.well-known'])(
    '%s → 404 direct, sans redirection',
    async (url) => {
      const res = await request(app).get(url).redirects(0);
      expect(res.status).toBe(404);
      expect(res.headers.location).toBeUndefined();
      expect(res.text).toContain(PAGE_404);
    },
  );

  test.each(['/css/', '/js/', '/assets/', '/fonts/'])(
    '%s → une seule 301 vers la forme sans slash, puis 404',
    async (url) => {
      const first = await request(app).get(url).redirects(0);
      expect(first.status).toBe(301);
      expect(first.headers.location).toBe(url.slice(0, -1));
      const res = await request(app).get(url).redirects(5);
      expect(res.status).toBe(404);
      expect(res.redirects).toHaveLength(1);
    },
  );

  test('un fichier réel d\'un répertoire statique reste servi', async () => {
    const res = await request(app).get('/css/core.min.css').redirects(0);
    expect(res.status).toBe(200);
  });
});

describe('Sondes publiques : ni uptime ni message d\'erreur interne', () => {
  test('/api/health ne donne plus l\'uptime', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
    const res = await request(app).get('/api/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body).not.toHaveProperty('uptime');
  });

  test('/api/live ne donne plus l\'uptime', async () => {
    const res = await request(app).get('/api/live');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });

  test('/api/ready ne recopie pas le message d\'erreur de Redis', async () => {
    app._redisClient = { ping: jest.fn().mockRejectedValue(new Error('connect ECONNREFUSED 10.0.0.5:6379')) };
    mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
    const res = await request(app).get('/api/ready');
    expect(res.body.redis).toEqual({ configured: true, ok: false });
    expect(JSON.stringify(res.body)).not.toMatch(/ECONNREFUSED|10\.0\.0\.5/);
  });
});
