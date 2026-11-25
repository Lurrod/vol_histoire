/**
 * Limiteur de la vérification du mot de passe actuel (SEC-005) : seuls les
 * échecs comptent, par compte connecté.
 */
const express = require('express');
const request = require('supertest');
const { createRateLimiters, LIMITER_DEFS } = require('../middleware/rate-limiters');

describe('limiteur currentPassword', () => {
  const env = process.env.NODE_ENV;
  // En NODE_ENV=test, les limiteurs sont désactivés (skip) : on les active ici.
  beforeAll(() => { process.env.NODE_ENV = 'development'; });
  afterAll(() => { process.env.NODE_ENV = env; });

  function appFor() {
    const { limiters } = createRateLimiters();
    const app = express();
    app.use((req, res, next) => { req.user = { id: Number(req.get('x-user')) }; next(); });
    app.post('/check', limiters.currentPassword, (req, res) => res.status(req.get('x-ok') ? 200 : 403).end());
    return app;
  }

  test('déclaré : 10 échecs par compte', () => {
    const def = LIMITER_DEFS.find((d) => d.key === 'currentPassword');
    expect(def).toMatchObject({ max: 10, perUser: true, failuresOnly: true });
  });

  test('les réussites ne comptent pas ; le 11e échec est refusé en 429', async () => {
    const app = appFor();
    for (let i = 0; i < 20; i++) {
      expect((await request(app).post('/check').set('x-user', '1').set('x-ok', '1')).status).toBe(200);
    }
    for (let i = 0; i < 10; i++) {
      expect((await request(app).post('/check').set('x-user', '1')).status).toBe(403);
    }
    expect((await request(app).post('/check').set('x-user', '1')).status).toBe(429);
  });

  test('clé par compte : un autre compte derrière la même IP n’est pas bloqué', async () => {
    const app = appFor();
    for (let i = 0; i < 10; i++) await request(app).post('/check').set('x-user', '1');
    expect((await request(app).post('/check').set('x-user', '1')).status).toBe(429);
    expect((await request(app).post('/check').set('x-user', '2')).status).toBe(403);
  });
});
