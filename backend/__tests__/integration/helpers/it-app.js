'use strict';

// Application Express branchée sur la base d'intégration.
//
// Le mailer est simulé : backend/.env porte de vrais identifiants SMTP, et une
// suite d'intégration ne doit jamais envoyer d'email. jest.mock appelé ici
// s'applique au registre de modules du fichier de test qui requiert ce helper,
// à condition que ce dernier soit requis AVANT l'application.

process.env.NODE_ENV = 'test';
// Journal d'accès silencieux (une ligne par requête sinon) ; les erreurs restent visibles.
process.env.LOG_LEVEL = process.env.IT_LOG_LEVEL || 'error';
process.env.JWT_SECRET = process.env.JWT_SECRET_IT || 'it-secret-key-for-jest-minimum-32-chars';
process.env.REFRESH_SECRET = process.env.REFRESH_SECRET_IT || 'it-refresh-secret-key-for-jest-min-32';

jest.mock('../../../mailer', () => ({
  sendVerificationEmail: jest.fn().mockResolvedValue(undefined),
  sendPasswordResetEmail: jest.fn().mockResolvedValue(undefined),
  sendContactEmail: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeConfirmation: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeNotice: jest.fn().mockResolvedValue(undefined),
  sendWelcomeEmail: jest.fn().mockResolvedValue(undefined),
  verifyConnection: jest.fn().mockResolvedValue(undefined),
}));

const request = require('supertest');
const { setupItDatabase, IT_PASSWORD } = require('./it-db');

/**
 * Charge la base de la suite, branche l'application dessus et renvoie
 * { app, pool, mailer, login }.
 * @param {string} suite
 */
async function startItApp(suite) {
  const pool = await setupItDatabase(suite);
  const app = require('../../../app');
  // dotenv (chargé par app.js) a pu réinjecter le secret hCaptcha du .env.
  delete process.env.HCAPTCHA_SECRET;
  app.setPool(pool);
  const cache = require('../../../utils/cache');
  cache._resetForTests();
  const mailer = require('../../../mailer');

  /** Connexion réelle (bcrypt + refresh token en base) → access token. */
  async function login(email, password = IT_PASSWORD) {
    const res = await request(app).post('/api/login').send({ email, password });
    if (res.status !== 200) throw new Error(`Connexion IT impossible pour ${email} : ${res.status} ${JSON.stringify(res.body)}`);
    return res.body.token;
  }

  async function stop() {
    app.stopCleanup();
    await pool.end();
  }

  return { app, pool, mailer, login, stop };
}

module.exports = { startItApp };
