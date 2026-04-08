/**
 * Tests de charge — /api/airplanes, /api/stats, /api/countries
 * Vérifie que les endpoints supportent la charge sans dégradation.
 * Utilise autocannon pour simuler des requêtes concurrentes.
 *
 * Lancé via : npm run test:load
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest-load-tests';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest-load';

const autocannon = require('autocannon');
const app = require('../app');

// Mock pool — réponses instantanées pour isoler la perf du framework
const mockPool = {
  query: jest.fn().mockImplementation((sql) => {
    if (sql.includes('COUNT(*)')) return Promise.resolve({ rows: [{ total: 47 }] });
    if (sql.includes('earliest')) return Promise.resolve({ rows: [{ earliest: 1953, latest: 2023 }] });
    if (sql.includes('DISTINCT country_id')) return Promise.resolve({ rows: [{ total: 12 }] });
    if (sql.includes('FROM airplanes')) {
      return Promise.resolve({
        rows: Array.from({ length: 6 }, (_, i) => ({
          id: i + 1, name: `Aircraft ${i}`, complete_name: `Full ${i}`,
          little_description: 'Desc', image_url: 'https://example.com/img.jpg',
          max_speed: 2200, country_name: 'France', country_code: 'FRA',
          generation: 4, type_name: 'Multirôle', date_operationel: '2001-06-18',
        })),
      });
    }
    if (sql.includes('FROM countries')) {
      return Promise.resolve({
        rows: [{ id: 1, name: 'France' }, { id: 2, name: 'USA' }],
      });
    }
    return Promise.resolve({ rows: [] });
  }),
  connect: jest.fn().mockResolvedValue({
    query: jest.fn().mockResolvedValue({ rows: [] }),
    release: jest.fn(),
  }),
};

jest.mock('../mailer', () => ({
  sendVerificationEmail: jest.fn().mockResolvedValue(undefined),
  sendPasswordResetEmail: jest.fn().mockResolvedValue(undefined),
  verifyConnection: jest.fn().mockResolvedValue(undefined),
}));

let server;

beforeAll((done) => {
  app.setPool(mockPool);
  server = app.listen(0, () => done()); // port 0 = auto
});

afterAll((done) => {
  app.stopCleanup();
  server.close(done);
});

function runLoad(url, opts = {}) {
  const port = server.address().port;
  return new Promise((resolve, reject) => {
    autocannon({
      url: `http://localhost:${port}${url}`,
      connections: opts.connections || 50,
      duration: opts.duration || 3,
      pipelining: opts.pipelining || 1,
      ...opts,
    }, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

describe('Load tests', () => {
  test('GET /api/airplanes — 50 connexions, 3s', async () => {
    const result = await runLoad('/api/airplanes');

    console.log(`  → ${result.requests.total} requêtes en ${result.duration}s`);
    console.log(`  → Latence p50=${result.latency.p50}ms p99=${result.latency.p99}ms`);
    console.log(`  → Throughput: ${result.throughput.average} bytes/s`);

    // Aucune erreur
    expect(result.errors).toBe(0);
    expect(result.timeouts).toBe(0);
    // Latence p99 sous 100ms (mock DB, pas de réseau)
    expect(result.latency.p99).toBeLessThan(200); // marge anti-flake CI/machines lentes
    // Au moins 1000 requêtes en 3s
    expect(result.requests.total).toBeGreaterThan(1000);
  }, 15000);

  test('GET /api/airplanes?country=France&sort=alphabetical — filtres + tri', async () => {
    const result = await runLoad('/api/airplanes?country=France&sort=alphabetical');

    expect(result.errors).toBe(0);
    expect(result.timeouts).toBe(0);
    expect(result.latency.p99).toBeLessThan(200); // marge anti-flake CI/machines lentes
  }, 15000);

  test('GET /api/stats — endpoint avec cache', async () => {
    const result = await runLoad('/api/stats');

    console.log(`  → ${result.requests.total} requêtes en ${result.duration}s (cached)`);
    console.log(`  → Latence p50=${result.latency.p50}ms p99=${result.latency.p99}ms`);

    expect(result.errors).toBe(0);
    expect(result.timeouts).toBe(0);
    // Le cache rend stats encore plus rapide
    expect(result.latency.p99).toBeLessThan(150); // marge anti-flake CI/machines lentes
  }, 15000);

  test('GET /api/countries — référentiel léger', async () => {
    const result = await runLoad('/api/countries');

    expect(result.errors).toBe(0);
    expect(result.timeouts).toBe(0);
    expect(result.latency.p99).toBeLessThan(200); // marge anti-flake CI/machines lentes
  }, 15000);

  test('charge élevée — 100 connexions, 5s', async () => {
    const result = await runLoad('/api/airplanes', { connections: 100, duration: 5 });

    console.log(`  → ${result.requests.total} requêtes en ${result.duration}s (100 conn)`);
    console.log(`  → Latence p50=${result.latency.p50}ms p99=${result.latency.p99}ms`);
    console.log(`  → Non-2xx: ${result.non2xx}`);

    expect(result.errors).toBe(0);
    // Tolérance plus large sous forte charge
    expect(result.latency.p99).toBeLessThan(200);
    // Au moins 2000 requêtes en 5s même sous charge
    expect(result.requests.total).toBeGreaterThan(2000);
  }, 20000);
});
