/**
 * hCaptcha : le serveur exige le jeton dès que la clé secrète est posée
 * (audit du 2026-11-16, « contournement possible du captcha »).
 *
 * Constats vérifiés en production avant correction : jeton absent, vide, en
 * tableau ou bidon → 400 CAPTCHA_FAILED (pas de contournement) ; mais une
 * requête SANS corps → 500 (Express 5 laisse req.body à undefined), comme sur
 * /login, /auth/verify-email, /auth/reset-password, /auth/confirm-email-change.
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
const { verify, captchaConfigErrors } = require('../middleware/hcaptcha');

const mockPool = { query: jest.fn() };
const realFetch = global.fetch;

beforeAll(() => app.setPool(mockPool));
beforeEach(() => {
  mockPool.query.mockReset();
  process.env.HCAPTCHA_SECRET = 'test-secret';
  global.fetch = jest.fn();
});
afterEach(() => {
  delete process.env.HCAPTCHA_SECRET;
  delete process.env.HCAPTCHA_SITEKEY;
  process.env.NODE_ENV = 'test';
  global.fetch = realFetch;
});
afterAll(() => app.stopCleanup());

// /login ajouté le 2026-11-16 : sans captcha, le bourrage d'identifiants ne
// butait que sur le limiteur par IP (20 / 15 min) et le verrou par compte.
const CAPTCHA_ROUTES = ['/api/register', '/api/login', '/api/contact', '/api/auth/forgot-password'];

describe('clé secrète posée : jeton exigé sur les quatre formulaires', () => {
  test.each(CAPTCHA_ROUTES)('%s — corps JSON sans jeton → 400, hCaptcha jamais appelé', async (url) => {
    const res = await request(app).post(url).send({ email: 'a@b.fr', name: 'A', message: 'x', password: 'Abcdefg1' });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CAPTCHA_FAILED');
    expect(global.fetch).not.toHaveBeenCalled();
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test.each(CAPTCHA_ROUTES)('%s — sans corps du tout → 400, pas 500', async (url) => {
    const res = await request(app).post(url);
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CAPTCHA_FAILED');
  });

  test.each([
    ['tableau', { 'h-captcha-response': ['x'] }],
    ['objet', { 'h-captcha-response': { a: 1 } }],
    ['chaîne vide', { 'h-captcha-response': '' }],
    ['nombre', { captcha: 123 }],
  ])('jeton %s → 400 sans appel à hCaptcha', async (_label, body) => {
    const res = await request(app).post('/api/contact').send(body);
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CAPTCHA_FAILED');
    expect(global.fetch).not.toHaveBeenCalled();
  });

  test('jeton refusé par hCaptcha → 400', async () => {
    global.fetch.mockResolvedValue({ ok: true, json: async () => ({ success: false }) });
    const res = await request(app).post('/api/contact').send({ 'h-captcha-response': 'bidon' });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CAPTCHA_FAILED');
  });

  test('hCaptcha injoignable → 400 (on ne laisse pas passer)', async () => {
    global.fetch.mockRejectedValue(new Error('ETIMEDOUT'));
    const res = await request(app).post('/api/contact').send({ 'h-captcha-response': 'tok' });
    expect(res.status).toBe(400);
  });
});

describe('vérification liée à la clé publique du site', () => {
  test('la sitekey est transmise à siteverify quand elle est configurée', async () => {
    process.env.HCAPTCHA_SITEKEY = 'site-key-123';
    global.fetch.mockResolvedValue({ ok: true, json: async () => ({ success: true }) });
    await verify('tok', '1.2.3.4');
    const body = new URLSearchParams(global.fetch.mock.calls[0][1].body);
    expect(body.get('sitekey')).toBe('site-key-123');
    expect(body.get('response')).toBe('tok');
  });
});

describe('sans clé secrète', () => {
  test('hors production : vérification sautée (développement local)', async () => {
    delete process.env.HCAPTCHA_SECRET;
    expect(await verify(undefined)).toEqual({ ok: true, skipped: true });
  });

  test('en production : refus (fermé par défaut), jamais « tout passe »', async () => {
    delete process.env.HCAPTCHA_SECRET;
    process.env.NODE_ENV = 'production';
    const result = await verify('tok');
    expect(result.ok).toBe(false);
    expect(result.reason).toBe('not-configured');
    expect(global.fetch).not.toHaveBeenCalled();
  });
});

describe('captchaConfigErrors : contrôle au démarrage', () => {
  test.each([
    [{ NODE_ENV: 'production', HCAPTCHA_SECRET: 's', HCAPTCHA_SITEKEY: 'k' }, []],
    [{ NODE_ENV: 'production', HCAPTCHA_SECRET: 's' }, ['HCAPTCHA_SITEKEY']],
    [{ NODE_ENV: 'production', HCAPTCHA_SITEKEY: 'k' }, ['HCAPTCHA_SECRET']],
    [{ NODE_ENV: 'production' }, ['HCAPTCHA_SECRET', 'HCAPTCHA_SITEKEY']],
    [{ NODE_ENV: 'development' }, []],
    [{ NODE_ENV: 'test', HCAPTCHA_SITEKEY: 'k' }, []],
  ])('%j → manquantes : %j', (env, expected) => {
    expect(captchaConfigErrors(env)).toEqual(expected);
  });
});

describe('POST sans corps : 400, jamais 500 (Express 5 laisse req.body indéfini)', () => {
  test.each([
    '/api/login',
    '/api/auth/verify-email',
    '/api/auth/reset-password',
    '/api/auth/confirm-email-change',
  ])('%s', async (url) => {
    const res = await request(app).post(url);
    expect(res.status).toBe(400);
  });
});
