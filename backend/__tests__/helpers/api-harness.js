/**
 * Banc commun des suites d'API (api-*.test.js) : application, pool
 * PostgreSQL simulé, jetons de test, état des comptes lu par authorize().
 * La base de données est entièrement mockée (pas de vraie connexion).
 *
 * Chaque suite déclare d'abord le mock du mailer (jest.mock est remonté en
 * tête du fichier de test, avant tout require) puis charge ce banc :
 *
 *   jest.mock('../mailer', () => require('./helpers/mailer-mock')());
 *   const h = require('./helpers/api-harness');
 *   h.installHooks();
 */
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const request = require('supertest');
const jwt = require('jsonwebtoken');

const mailer = require('../../mailer');
const app = require('../../app');

// Désactiver hCaptcha en tests — APRÈS le require('../app') car
// dotenv.config() dans app.js recharge les variables depuis .env
delete process.env.HCAPTCHA_SECRET;

// =============================================================================
// Helpers — génération de tokens JWT de test
// =============================================================================
function makeToken(payload) {
  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
}

function makeRefreshToken(payload) {
  return jwt.sign({ ...payload, jti: 'test-jti-' + (payload.id || 0) }, process.env.REFRESH_SECRET, { expiresIn: '7d' });
}

const tokenAdmin   = makeToken({ id: 1, name: 'Admin',   role: 1, email: 'admin@test.com' });
const tokenEditor  = makeToken({ id: 2, name: 'Editor',  role: 2, email: 'editor@test.com' });
const tokenMember  = makeToken({ id: 3, name: 'Member',  role: 3, email: 'member@test.com' });
const tokenExpired = jwt.sign({ id: 99, role: 1 }, process.env.JWT_SECRET, { expiresIn: '-1s' });
const refreshTokenValid = makeRefreshToken({ id: 1, role: 1 });
const refreshTokenExpired = jwt.sign({ id: 1, role: 1, jti: 'expired-jti' }, process.env.REFRESH_SECRET, { expiresIn: '-1s' });

// =============================================================================
// Mock du pool PostgreSQL
// =============================================================================
const mockPool = {
  query: jest.fn(),
  // Support des transactions (withTransaction appelle pool.connect())
  connect: jest.fn().mockImplementation(() => {
    const TX_CMDS = new Set(['BEGIN', 'COMMIT', 'ROLLBACK']);
    const client = {
      query: (...args) => {
        // Ignorer les commandes transactionnelles pour ne pas décaler les mocks
        if (typeof args[0] === 'string' && TX_CMDS.has(args[0])) {
          return Promise.resolve();
        }
        return mockPool.query(...args);
      },
      release: jest.fn(),
    };
    return Promise.resolve(client);
  }),
};

// État des comptes lu par authorize() (rôle + token_version). Les jetons de
// test 1/2/3 correspondent à des comptes admin/éditeur/membre en version 0 ;
// un test peut modifier cet objet (sur place) pour simuler une rétrogradation,
// une suppression (null) ou un changement de mot de passe (version incrémentée).
const authMiddleware = require('../../middleware/auth');
const DEFAULT_AUTH_STATE = { 1: { role_id: 1, token_version: 0 }, 2: { role_id: 2, token_version: 0 }, 3: { role_id: 3, token_version: 0 } };
const authState = {};

function resetAuthState() {
  Object.keys(authState).forEach((k) => { delete authState[k]; });
  Object.assign(authState, DEFAULT_AUTH_STATE);
}

function installHooks() {
  beforeAll(() => {
    app.setPool(mockPool);
    authMiddleware.setAuthStateLoader(async (id) => authState[id] ?? null);
  });

  beforeEach(() => {
    // Avant chaque test, pas seulement en tête de fichier : un test qui
    // recharge app.js relance dotenv.config(), qui repose la clé hCaptcha du
    // .env local — les tests suivants (login compris) butaient alors sur le captcha.
    delete process.env.HCAPTCHA_SECRET;
    resetAuthState();
    mockPool.query.mockReset();
    app.invalidateStatsCache?.();
    app.invalidateAirplanesReferentialCache?.();
    app.invalidateTimelineCache?.();
  });

  afterAll(() => {
    app.stopCleanup();
  });
}

// =============================================================================
// Codes envoyés par email (activation, mot de passe, changement d'adresse)
// =============================================================================
const emailCodes = require('../../repositories/email-tokens');
const GOOD_CODE = '123456';
const WRONG_CODE = '654321';
// Les codes ne sont jamais stockés en clair : les lignes simulées portent
// l'empreinte HMAC que calcule le dépôt (repositories/email-tokens.js).
/** Ligne email_tokens ouverte (SELECT … FOR UPDATE) pour un code donné. */
function codeRow(userId, type, code = GOOD_CODE, extra = {}) {
  return { rows: [{ id: 50, token_hash: emailCodes.hashCode(userId, type, code), attempts: 0, new_email: null, ...extra }] };
}
const unverifiedUser = { rows: [{ id: 7, name: 'Jean', email_verified: false }] };
const verifiedUser = { rows: [{ id: 7, name: 'Jean', email_verified: true }] };
const findSql = (re) => mockPool.query.mock.calls.find(c => re.test(c[0]));
const hasSql = (re) => mockPool.query.mock.calls.some(c => re.test(c[0]));

module.exports = {
  request, jwt, mailer, app, mockPool, authMiddleware, authState, installHooks,
  makeToken, makeRefreshToken,
  tokenAdmin, tokenEditor, tokenMember, tokenExpired, refreshTokenValid, refreshTokenExpired,
  emailCodes, GOOD_CODE, WRONG_CODE, codeRow, unverifiedUser, verifiedUser, findSql, hasSql,
};
