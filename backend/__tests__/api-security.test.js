/**
 * Correctifs de sécurité du lot H1 (audit du 10/11/2026) : SEC-002, SEC-003,
 * SEC-006, SEC-008, LEGAL-011 (partie backend). Base simulée.
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const crypto = require('crypto');
const request = require('supertest');
const jwt = require('jsonwebtoken');

jest.mock('../mailer', () => ({
  sendVerificationEmail: jest.fn().mockResolvedValue(undefined),
  sendPasswordResetEmail: jest.fn().mockResolvedValue(undefined),
  sendContactEmail: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeConfirmation: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeNotice: jest.fn().mockResolvedValue(undefined),
  verifyConnection: jest.fn().mockResolvedValue(undefined),
}));

const app = require('../app');
const logger = require('../logger');
const authMiddleware = require('../middleware/auth');
const guards = require('../middleware/input-guards');
const cspReport = require('../middleware/csp-report');
const emailTokensRepo = require('../repositories/email-tokens');

delete process.env.HCAPTCHA_SECRET;

const sha256 = (value) => crypto.createHash('sha256').update(value).digest('hex');
const makeToken = (payload) => jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
const tokenAdmin = makeToken({ id: 1, role: 1 });
const tokenMember = makeToken({ id: 3, role: 3 });

const mockPool = { query: jest.fn() };
const AUTH_STATE = { 1: { role_id: 1, token_version: 0 }, 3: { role_id: 3, token_version: 0 } };

beforeAll(() => {
  app.setPool(mockPool);
  authMiddleware.setAuthStateLoader(async (id) => AUTH_STATE[id] ?? null);
});

beforeEach(() => {
  mockPool.query.mockReset();
  mockPool.query.mockResolvedValue({ rows: [], rowCount: 0 });
});

afterEach(() => {
  jest.restoreAllMocks();
});

afterAll(() => {
  authMiddleware.setAuthStateLoader(null);
  app.stopCleanup();
});

// =============================================================================
// middleware/input-guards.js
// =============================================================================
describe('input-guards — isValidDbId', () => {
  test.each(['1', '42', '2147483647', 1, 0, '0'])('accepte %p', (v) => {
    expect(guards.isValidDbId(v)).toBe(true);
  });

  test.each([
    '2147483648', '99999999999999999999', '-1', '1.5', '1e3', ' 1', 'abc', '', '0x10',
    -1, 1.5, 2147483648, null, undefined, {}, ['1'],
  ])('refuse %p', (v) => {
    expect(guards.isValidDbId(v)).toBe(false);
  });
});

describe('input-guards — cleanSearch', () => {
  test('caractères de contrôle remplacés par une espace, bords retirés', () => {
    expect(guards.cleanSearch('  mi\u0000ra\tge\n ')).toBe('mi ra ge');
    expect(guards.cleanSearch('a\u007Fb')).toBe('a b');
  });

  test('valeur non chaîne (paramètre répété, absent) → chaîne vide', () => {
    expect(guards.cleanSearch(['a', 'b'])).toBe('');
    expect(guards.cleanSearch(undefined)).toBe('');
    expect(guards.cleanSearch(12)).toBe('');
  });

  test('au-delà de la longueur maximale → chaîne vide', () => {
    expect(guards.cleanSearch('x'.repeat(100))).toBe('x'.repeat(100));
    expect(guards.cleanSearch('x'.repeat(101))).toBe('');
    expect(guards.cleanSearch('abcdef', 5)).toBe('');
  });
});

describe('input-guards — containsNul / idParam / rejectNulBytes', () => {
  test('containsNul explore chaînes, tableaux, objets et clés', () => {
    expect(guards.containsNul('a\u0000')).toBe(true);
    expect(guards.containsNul({ a: ['ok', { b: 'x\u0000' }] })).toBe(true);
    expect(guards.containsNul({ ['k\u0000']: 1 })).toBe(true);
    expect(guards.containsNul({ a: ['ok', 1, null, true] })).toBe(false);
    expect(guards.containsNul(undefined)).toBe(false);
  });

  test('containsNul : imbrication excessive considérée comme suspecte', () => {
    let deep = 'x';
    for (let i = 0; i < 30; i++) deep = [deep];
    expect(guards.containsNul(deep)).toBe(true);
  });

  test('idParam : 400 avec le message fourni, next() sinon', () => {
    const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    const next = jest.fn();
    guards.idParam('ID avion invalide')({}, res, next, '2147483648');
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({ message: 'ID avion invalide' });
    expect(next).not.toHaveBeenCalled();
    guards.idParam()({}, res, next, '12');
    expect(next).toHaveBeenCalledTimes(1);
  });

  test('rejectNulBytes : 400 sur la requête ou le corps', () => {
    const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    const next = jest.fn();
    guards.rejectNulBytes({ query: {}, body: { name: 'a\u0000' } }, res, next);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(next).not.toHaveBeenCalled();
    guards.rejectNulBytes({ query: { q: 'ok' }, body: undefined }, res, next);
    expect(next).toHaveBeenCalledTimes(1);
  });
});

// =============================================================================
// SEC-003 — identifiants hors plage et octet NUL : 400 avant toute requête SQL
// =============================================================================
describe('SEC-003 — routes à identifiant', () => {
  const BAD_IDS = ['2147483648', '99999999999999999999', '-1', '1.5', 'abc'];

  test.each(BAD_IDS)('GET /api/airplanes/%s → 400 sans requête SQL', async (id) => {
    const res = await request(app).get(`/api/airplanes/${id}`);
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('ID invalide');
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test.each(['armament', 'tech', 'missions', 'wars', 'related', 'lineage'])(
    'GET /api/airplanes/2147483648/%s → 400', async (sub) => {
      const res = await request(app).get(`/api/airplanes/2147483648/${sub}`);
      expect(res.status).toBe(400);
      expect(mockPool.query).not.toHaveBeenCalled();
    }
  );

  test('identifiant à la borne int4 accepté (2147483647 → 404, pas 400)', async () => {
    const res = await request(app).get('/api/airplanes/2147483647');
    expect(res.status).toBe(404);
  });

  test('favoris, utilisateurs, administration : 400 hors plage', async () => {
    const fav = await request(app).post('/api/favorites/2147483648').set('Authorization', `Bearer ${tokenMember}`);
    expect(fav.status).toBe(400);
    expect(fav.body.message).toBe('ID avion invalide');
    const user = await request(app).get('/api/users/99999999999').set('Authorization', `Bearer ${tokenAdmin}`);
    expect(user.status).toBe(400);
    const admin = await request(app).put('/api/admin/users/2147483648').set('Authorization', `Bearer ${tokenAdmin}`).send({ role_id: 2 });
    expect(admin.status).toBe(400);
    const del = await request(app).delete('/api/airplanes/-5').set('Authorization', `Bearer ${tokenAdmin}`);
    expect(del.status).toBe(400);
  });

  test('facettes : generation hors plage ou non numérique → 400', async () => {
    for (const g of ['99999999999', 'abc', '0']) {
      const res = await request(app).get(`/api/airplanes/facets?generation=${g}`);
      expect(res.status).toBe(400);
    }
    expect(mockPool.query).not.toHaveBeenCalled();
  });
});

describe('SEC-003 — recherche et corps', () => {
  test('GET /api/airplanes?search=%00 → 400 sans requête SQL', async () => {
    const res = await request(app).get('/api/airplanes?search=%00');
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('INVALID_CHARACTER');
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test('GET /api/users?search=a%00 (admin) → 400', async () => {
    const res = await request(app).get('/api/users?search=a%00').set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(400);
  });

  test('tabulation dans la recherche : nettoyée, la requête part', async () => {
    mockPool.query.mockResolvedValue({ rows: [{ total: 0 }], rowCount: 0 });
    const res = await request(app).get('/api/airplanes?search=mi%09rage');
    expect(res.status).toBe(200);
    const params = mockPool.query.mock.calls.flatMap((c) => c[1] || []);
    expect(params).toContain('mi rage');
    expect(params.some((p) => typeof p === 'string' && p.includes('\t'))).toBe(false);
  });

  test('octet NUL dans un corps JSON → 400', async () => {
    const res = await request(app).post('/api/login').send({ email: 'a@b.fr\u0000', password: 'x' });
    expect(res.status).toBe(400);
    expect(mockPool.query).not.toHaveBeenCalled();
  });
});

// =============================================================================
// SEC-002 — erreurs de lecture du corps : 400 / 413, pas d'« Erreur non gérée »
// =============================================================================
describe('SEC-002 — corps invalide ou trop gros', () => {
  test('JSON mal formé → 400 en français, rien journalisé en erreur', async () => {
    const spy = jest.spyOn(logger, 'error');
    const res = await request(app).post('/api/login').set('Content-Type', 'application/json').send('{"email":');
    expect(res.status).toBe(400);
    expect(res.body).toEqual({ message: 'Corps de requête JSON invalide' });
    expect(spy).not.toHaveBeenCalled();
  });

  test('corps > 100 Ko → 413, rien journalisé en erreur', async () => {
    const spy = jest.spyOn(logger, 'error');
    const res = await request(app).post('/api/contact').set('Content-Type', 'application/json')
      .send(JSON.stringify({ message: 'x'.repeat(200 * 1024) }));
    expect(res.status).toBe(413);
    expect(res.body.message).toMatch(/trop volumineux/);
    expect(spy).not.toHaveBeenCalled();
  });

  test('encodage non pris en charge → 415', async () => {
    const res = await request(app).post('/api/login').set('Content-Type', 'application/json; charset=klingon').send('{}');
    expect(res.status).toBe(415);
  });

  test('une vraie erreur reste un 500 journalisé', async () => {
    const spy = jest.spyOn(logger, 'error').mockImplementation(() => ({ errorId: 'abc' }));
    mockPool.query.mockRejectedValue(new Error('panne'));
    const res = await request(app).get('/api/airplanes/12');
    expect(res.status).toBe(500);
    expect(spy).toHaveBeenCalledWith('Erreur non gérée', expect.any(Object));
  });
});

// =============================================================================
// SEC-006 — CSP : nonce + strict-dynamic, plus de CDN Sentry, remontée
// =============================================================================
describe('SEC-006 — en-têtes CSP', () => {
  test('script-src : nonce de la requête + strict-dynamic, sans CDN Sentry', async () => {
    const res = await request(app).get('/api/config');
    const csp = res.headers['content-security-policy'];
    const scriptSrc = csp.match(/script-src [^;]*/)[0];
    expect(scriptSrc).toMatch(/'nonce-[A-Za-z0-9+/=]+'/);
    expect(scriptSrc).toContain("'strict-dynamic'");
    expect(scriptSrc).not.toContain("'unsafe-inline'");
    expect(csp).not.toContain('sentry');
  });

  test('report-uri, report-to et Reporting-Endpoints visent /api/csp-report', async () => {
    const res = await request(app).get('/api/config');
    const csp = res.headers['content-security-policy'];
    expect(csp).toContain('report-uri /api/csp-report');
    expect(csp).toContain('report-to csp-endpoint');
    expect(res.headers['reporting-endpoints']).toBe('csp-endpoint="/api/csp-report"');
  });

  test('page HTML : le nonce de l\'en-tête est posé sur les scripts locaux', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    const nonce = res.headers['content-security-policy'].match(/script-src 'nonce-([^']+)'/)[1];
    const scripts = res.text.match(/<script\b[^>]*\bsrc=[^>]*>/gi) || [];
    expect(scripts.length).toBeGreaterThan(3);
    for (const tag of scripts) expect(tag).toContain(`nonce="${nonce}"`);
  });
});

describe('SEC-006 — POST /api/csp-report', () => {
  const legacy = {
    'csp-report': {
      'document-uri': 'https://vol-histoire.titouan-borde.com/reset-password?token=abcdef#x',
      'blocked-uri': 'https://evil.example/x.js?q=1',
      'violated-directive': 'script-src-elem',
      'effective-directive': 'script-src-elem',
      'original-policy': "default-src 'self'",
      disposition: 'enforce',
      'line-number': 12,
      'source-file': 'https://vol-histoire.titouan-borde.com/js/app.js?v=1',
      'status-code': 200,
    },
  };

  test('format application/csp-report → 204 et une ligne warn sans requête ni IP', async () => {
    const spy = jest.spyOn(logger, 'warn').mockImplementation(() => ({}));
    const res = await request(app).post('/api/csp-report')
      .set('Content-Type', 'application/csp-report').send(JSON.stringify(legacy));
    expect(res.status).toBe(204);
    const call = spy.mock.calls.find((c) => c[0] === 'Violation CSP');
    expect(call).toBeDefined();
    expect(call[1]).toEqual({
      documentUrl: 'https://vol-histoire.titouan-borde.com/reset-password',
      blockedUrl: 'https://evil.example/x.js',
      directive: 'script-src-elem',
      disposition: 'enforce',
      sourceFile: 'https://vol-histoire.titouan-borde.com/js/app.js',
      line: 12,
      column: undefined,
      sample: undefined,
    });
    expect(JSON.stringify(call[1])).not.toMatch(/token=|abcdef/);
    expect(Object.keys(call[1])).not.toEqual(expect.arrayContaining(['ip']));
  });

  test('format application/reports+json (lot) → 204, rapports non-CSP ignorés', async () => {
    const spy = jest.spyOn(logger, 'warn').mockImplementation(() => ({}));
    const batch = [
      { type: 'csp-violation', body: { documentURL: 'https://site.test/hangar', blockedURL: 'inline', effectiveDirective: 'style-src-attr', disposition: 'enforce', sample: 'color:red' } },
      { type: 'deprecation', body: { id: 'x' } },
    ];
    const res = await request(app).post('/api/csp-report')
      .set('Content-Type', 'application/reports+json').send(JSON.stringify(batch));
    expect(res.status).toBe(204);
    const calls = spy.mock.calls.filter((c) => c[0] === 'Violation CSP');
    expect(calls).toHaveLength(1);
    expect(calls[0][1]).toMatchObject({ documentUrl: 'https://site.test/hangar', blockedUrl: 'inline', directive: 'style-src-attr', sample: 'color:red' });
  });

  test('autre type de contenu → 415', async () => {
    const res = await request(app).post('/api/csp-report').send(legacy);
    expect(res.status).toBe(415);
  });

  test('corps > 16 Ko → 413', async () => {
    const big = { 'csp-report': { 'document-uri': `https://site.test/${'x'.repeat(20 * 1024)}` } };
    const res = await request(app).post('/api/csp-report')
      .set('Content-Type', 'application/csp-report').send(JSON.stringify(big));
    expect(res.status).toBe(413);
  });
});

describe('csp-report — normalisation', () => {
  test('stripUrl : origine + chemin, mots-clés conservés, champs bornés', () => {
    expect(cspReport.stripUrl('https://u:p@site.test/a/b?c=d#e')).toBe('https://site.test/a/b');
    expect(cspReport.stripUrl('inline')).toBe('inline');
    expect(cspReport.stripUrl('data:text/javascript,alert(1)')).toBe('data');
    expect(cspReport.stripUrl('')).toBeUndefined();
    expect(cspReport.stripUrl(42)).toBeUndefined();
    expect(cspReport.stripUrl('x'.repeat(500)).length).toBeLessThanOrEqual(201);
  });

  test('extractReports : lot borné, entrées invalides ignorées', () => {
    const many = Array.from({ length: 50 }, () => ({ type: 'csp-violation', body: { documentURL: 'https://s.test/' } }));
    expect(cspReport.extractReports(many)).toHaveLength(cspReport.MAX_REPORTS_PER_BATCH);
    expect(cspReport.extractReports([null, 1, { type: 'csp-violation' }])).toEqual([]);
    expect(cspReport.extractReports({ foo: 1 })).toEqual([]);
    expect(cspReport.extractReports(null)).toEqual([]);
    expect(cspReport.extractReports({ 'csp-report': 'x' })).toEqual([]);
  });

  test('normalizeReport : numéros de ligne invalides ignorés', () => {
    expect(cspReport.normalizeReport({ 'violated-directive': 'img-src', 'line-number': -3 }).line).toBeUndefined();
    expect(cspReport.normalizeReport({ lineNumber: 'abc', columnNumber: 4 })).toMatchObject({ line: undefined, column: 4 });
  });
});

// =============================================================================
// SEC-008 — jetons envoyés par email : seule leur empreinte est stockée
// =============================================================================
describe('SEC-008 — repositories/email-tokens.js', () => {
  const TOKEN = 'a'.repeat(64);
  const db = () => ({ query: jest.fn().mockResolvedValue({ rows: [{ id: 1, user_id: 7, new_email: null }], rowCount: 1 }) });

  test('hashToken : SHA-256 hexadécimal', () => {
    expect(emailTokensRepo.hashToken(TOKEN)).toBe(sha256(TOKEN));
    expect(emailTokensRepo.hashToken(TOKEN)).toMatch(/^[a-f0-9]{64}$/);
  });

  test('replaceOpen écrit l\'empreinte dans token_hash, jamais le jeton', async () => {
    const fake = db();
    await emailTokensRepo.replaceOpen(fake, { userId: 7, type: 'reset', token: TOKEN, expiresAt: new Date() });
    const insert = fake.query.mock.calls.find((c) => /INSERT INTO email_tokens/.test(c[0]));
    expect(insert[0]).toContain('token_hash');
    expect(insert[1][1]).toBe(sha256(TOKEN));
    expect(insert[1]).not.toContain(TOKEN);
  });

  test('consume et findOpenReset comparent sur l\'empreinte', async () => {
    const fake = db();
    await emailTokensRepo.consume(fake, TOKEN, 'verify');
    await emailTokensRepo.findOpenReset(fake, TOKEN);
    for (const [sql, params] of fake.query.mock.calls) {
      expect(sql).toContain('token_hash = $1');
      expect(params[0]).toBe(sha256(TOKEN));
    }
  });

  test('parcours mot de passe oublié : l\'empreinte en base correspond au jeton envoyé', async () => {
    const mailer = require('../mailer');
    mockPool.connect = jest.fn().mockResolvedValue({ query: mockPool.query, release: jest.fn() });
    mockPool.query.mockImplementation(async (sql) => {
      if (/FROM users/.test(sql)) return { rows: [{ id: 9, name: 'Oubli', email_verified: true }], rowCount: 1 };
      return { rows: [], rowCount: 1 };
    });
    const res = await request(app).post('/api/auth/forgot-password').send({ email: 'oubli@test.fr' });
    expect(res.status).toBe(200);
    for (let i = 0; i < 50 && !mailer.sendPasswordResetEmail.mock.calls.length; i++) {
      await new Promise((r) => setTimeout(r, 10));
    }
    const sent = mailer.sendPasswordResetEmail.mock.calls.at(-1)[2];
    const insert = mockPool.query.mock.calls.find((c) => /INSERT INTO email_tokens/.test(c[0]));
    expect(insert[1][1]).toBe(sha256(sent));
    expect(insert[1][1]).not.toBe(sent);
  });
});

// =============================================================================
// LEGAL-011 — GET /api/users/me/export
// =============================================================================
describe('LEGAL-011 — export des données personnelles', () => {
  const USER = {
    id: 3, name: 'Membre', email: 'member@test.com', role: 'utilisateur', email_verified: true,
    created_at: '2026-01-02T10:00:00.000Z', updated_at: '2026-03-04T10:00:00.000Z',
    failed_login_count: 0, locked_until: null,
  };
  const FAVORITES = [{ airplane_id: 30, name: 'Rafale', added_at: '2026-05-06T10:00:00.000Z' }];

  const mockExportQueries = (user = USER) => {
    mockPool.query.mockImplementation(async (sql) => {
      if (/FROM users u/.test(sql)) return { rows: user ? [user] : [] };
      if (/FROM favorites f/.test(sql)) return { rows: FAVORITES };
      return { rows: [] };
    });
  };

  test('sans authentification → 403', async () => {
    const res = await request(app).get('/api/users/me/export');
    expect(res.status).toBe(403);
  });

  test('200 : contrat JSON, pièce jointe, no-store', async () => {
    mockExportQueries();
    const res = await request(app).get('/api/users/me/export').set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/^application\/json/);
    expect(res.headers['content-disposition']).toBe('attachment; filename="vol-histoire-donnees-3.json"');
    expect(res.headers['cache-control']).toBe('no-store');
    const body = JSON.parse(res.text);
    expect(Object.keys(body).sort()).toEqual(['consent', 'exported_at', 'favorites', 'user']);
    expect(new Date(body.exported_at).toString()).not.toBe('Invalid Date');
    expect(body.user).toEqual(USER);
    expect(body.favorites).toEqual(FAVORITES);
    expect(body.consent).toBeNull();
  });

  test('ne lit que le compte du jeton, sans hash ni jetons', async () => {
    mockExportQueries();
    await request(app).get('/api/users/me/export').set('Authorization', `Bearer ${tokenMember}`);
    const userQuery = mockPool.query.mock.calls.find((c) => /FROM users u/.test(c[0]));
    expect(userQuery[1]).toEqual([3]);
    expect(userQuery[0]).not.toMatch(/password|token_version/);
    const favQuery = mockPool.query.mock.calls.find((c) => /FROM favorites f/.test(c[0]));
    expect(favQuery[1]).toEqual([3]);
  });

  test('compte supprimé entre-temps → 404', async () => {
    mockExportQueries(null);
    const res = await request(app).get('/api/users/me/export').set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(404);
  });
});
