/**
 * GET /api/credits — crédits photo de toutes les fiches (page /credits).
 * Base simulée, comme api.test.js.
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const request = require('supertest');
const app = require('../app');

const mockPool = { query: jest.fn() };

beforeAll(() => {
  app.setPool(mockPool);
});

beforeEach(() => {
  mockPool.query.mockReset();
});

describe('GET /api/credits', () => {
  const rows = [
    { id: 30, name: 'Rafale', name_en: null, image_credit: 'Jane Doe', image_licence: 'CC BY-SA 4.0' },
    { id: 12, name: 'F-22 Raptor', name_en: 'F-22 Raptor', image_credit: null, image_licence: 'Domaine public' },
  ];

  test('200 — renvoie les champs attendus par la page, sans autre colonne', async () => {
    mockPool.query.mockResolvedValueOnce({ rows });
    const res = await request(app).get('/api/credits');
    expect(res.status).toBe(200);
    expect(res.body).toEqual(rows);
    expect(Object.keys(res.body[0]).sort()).toEqual(['id', 'image_credit', 'image_licence', 'name', 'name_en']);
  });

  test('requête sans paramètre utilisateur, triée par nom', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    await request(app).get('/api/credits');
    const [sql, params] = mockPool.query.mock.calls[0];
    expect(sql).toMatch(/FROM airplanes/);
    expect(sql).toMatch(/ORDER BY/);
    expect(params).toBeUndefined();
  });

  test('réponse publique mise en cache', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/credits');
    expect(res.headers['cache-control']).toMatch(/public/);
    expect(res.headers['cache-control']).toMatch(/max-age=\d+/);
  });

  test('500 — erreur de base gérée par le gestionnaire global', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('panne'));
    const res = await request(app).get('/api/credits');
    expect(res.status).toBe(500);
  });
});

describe('GET /credits', () => {
  test('200 — la page Crédits photo est servie en URL propre', async () => {
    const res = await request(app).get('/credits');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });
});
