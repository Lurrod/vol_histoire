/**
 * Tests d'intégration — Routes API (app.js)
 * La base de données est entièrement mockée (pas de vraie connexion PostgreSQL).
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const request = require('supertest');
const jwt = require('jsonwebtoken');

// Mock du mailer — aucun email réel en tests
jest.mock('../mailer', () => ({
  sendVerificationEmail: jest.fn().mockResolvedValue(undefined),
  sendPasswordResetEmail: jest.fn().mockResolvedValue(undefined),
  verifyConnection: jest.fn().mockResolvedValue(undefined),
}));
const mailer = require('../mailer');

const app = require('../app');

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

beforeAll(() => {
  app.setPool(mockPool);
});

beforeEach(() => {
  mockPool.query.mockReset();
  app.invalidateStatsCache?.();
  app.invalidateAirplanesReferentialCache?.();
});

afterAll(() => {
  app.stopCleanup();
});

// =============================================================================
// AUTH — POST /api/register
// =============================================================================
describe('POST /api/register', () => {
  const validPayload = {
    name: 'Jean Dupont',
    email: 'jean@example.com',
    password: 'Password123',
  };

  test('201 — inscription réussie (email normalisé en minuscules)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })                        // utilisateur n'existe pas
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Jean Dupont' }] }) // INSERT users RETURNING
      .mockResolvedValueOnce({ rows: [] });                       // INSERT email_tokens

    const res = await request(app).post('/api/register').send({ ...validPayload, email: 'Jean@Example.COM' });
    expect(res.status).toBe(201);
    expect(res.body.message).toBe('Compte créé. Vérifiez votre boîte email pour activer votre compte.');
    // Vérifier que la query INSERT a bien reçu l'email normalisé
    const insertCall = mockPool.query.mock.calls[1];
    expect(insertCall[1][1]).toBe('jean@example.com');
    // Vérifier que l'email de vérification a bien été envoyé
    expect(mailer.sendVerificationEmail).toHaveBeenCalledWith('jean@example.com', 'Jean Dupont', expect.any(String));
  });

  test('400 — email déjà utilisé', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1 }] }); // utilisateur existe

    const res = await request(app).post('/api/register').send(validPayload);
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email déjà utilisé');
  });

  test('400 — nom invalide (trop court)', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, name: 'J' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Nom invalide/);
  });

  test('400 — email invalide', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, email: 'notanemail' });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email invalide');
  });

  test('400 — mot de passe trop court (< 8 caractères)', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, password: 'Ab1xxxx' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('400 — mot de passe sans majuscule', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, password: 'abcdefg1' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('400 — mot de passe sans minuscule', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, password: 'ABCDEFG1' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('400 — mot de passe sans chiffre', async () => {
    const res = await request(app).post('/api/register').send({ ...validPayload, password: 'Abcdefgh' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('201 — mot de passe de 8 caractères conforme accepté', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ id: 2, name: 'Jean Dupont' }] })
      .mockResolvedValueOnce({ rows: [] }); // INSERT email_tokens

    const res = await request(app).post('/api/register').send({ ...validPayload, password: 'Abcdef1x' });
    expect(res.status).toBe(201);
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).post('/api/register').send(validPayload);
    expect(res.status).toBe(500);
  });
});

// =============================================================================
// AUTH — POST /api/login
// =============================================================================
describe('POST /api/login', () => {
  const bcrypt = require('bcryptjs');

  test('200 — connexion réussie avec access token et refresh cookie (email normalisé)', async () => {
    const hashedPwd = await bcrypt.hash('password123', 10);
    mockPool.query
      .mockResolvedValueOnce({
        rows: [{ id: 1, name: 'Admin', email: 'admin@test.com', password: hashedPwd, role_id: 1, email_verified: true }],
      })
      .mockResolvedValueOnce({ rows: [] }); // INSERT INTO refresh_tokens (storeRefreshToken)

    const res = await request(app).post('/api/login').send({
      email: 'ADMIN@TEST.COM', // majuscules intentionnelles
      password: 'password123',
    });
    // Vérifier que la query SELECT a bien reçu l'email normalisé
    const selectCall = mockPool.query.mock.calls[0];
    expect(selectCall[1][0]).toBe('admin@test.com');
    expect(res.status).toBe(200);
    expect(res.body.token).toBeDefined();
    expect(res.body.message).toBe('Connexion réussie');

    // Vérifier que le access token expire en 15 minutes
    const payload = jwt.decode(res.body.token);
    const ttl = payload.exp - payload.iat;
    expect(ttl).toBe(15 * 60); // 900 secondes

    // Vérifier le cookie refreshToken
    const cookies = res.headers['set-cookie'];
    expect(cookies).toBeDefined();
    const refreshCookie = cookies.find(c => c.startsWith('refreshToken='));
    expect(refreshCookie).toBeDefined();
    expect(refreshCookie).toMatch(/HttpOnly/);
    expect(refreshCookie).toMatch(/SameSite=Strict/);
    expect(refreshCookie).toMatch(/Path=\/api/);
  });

  test('400 — utilisateur inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).post('/api/login').send({
      email: 'unknown@test.com',
      password: 'password123',
    });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email ou mot de passe incorrect');
  });

  test('400 — mauvais mot de passe', async () => {
    const hashedPwd = await bcrypt.hash('correctpassword', 10);
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'Test', email: 'test@test.com', password: hashedPwd, role_id: 3 }],
    });

    const res = await request(app).post('/api/login').send({
      email: 'test@test.com',
      password: 'wrongpassword',
    });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email ou mot de passe incorrect');
  });

  test('400 — email invalide', async () => {
    const res = await request(app).post('/api/login').send({
      email: 'invalidemail',
      password: 'password123',
    });
    expect(res.status).toBe(400);
  });

  test('400 — mot de passe absent', async () => {
    const res = await request(app).post('/api/login').send({ email: 'test@test.com' });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Mot de passe requis');
  });

  test('403 — email non vérifié → code EMAIL_NOT_VERIFIED', async () => {
    const hashedPwd = await bcrypt.hash('Password123', 10);
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 5, name: 'Jean', email: 'jean@test.com', password: hashedPwd, role_id: 3, email_verified: false }],
    });

    const res = await request(app).post('/api/login').send({
      email: 'jean@test.com',
      password: 'Password123',
    });
    expect(res.status).toBe(403);
    expect(res.body.code).toBe('EMAIL_NOT_VERIFIED');
  });
});

// =============================================================================
// AUTH — Middleware authorize
// =============================================================================
describe('Middleware authorize', () => {
  test('403 — aucun token fourni', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(403);
    expect(res.body.message).toBe('Accès interdit');
  });

  test('401 — token invalide / corrompu → code TOKEN_INVALID', async () => {
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', 'Bearer invalidtoken');
    expect(res.status).toBe(401);
    expect(res.body.message).toBe('Token invalide');
    expect(res.body.code).toBe('TOKEN_INVALID');
  });

  test('401 — token expiré → code TOKEN_EXPIRED', async () => {
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${tokenExpired}`);
    expect(res.status).toBe(401);
    expect(res.body.message).toBe('Token expiré');
    expect(res.body.code).toBe('TOKEN_EXPIRED');
  });

  test('403 — rôle insuffisant (membre accède à /api/users)', async () => {
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
    expect(res.body.message).toBe('Accès non autorisé');
  });

  test('200 — admin accède à /api/users', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ count: '0' }] }); // COUNT
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // SELECT
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
  });
});

// =============================================================================
// AUTH — POST /api/refresh
// =============================================================================
describe('POST /api/refresh', () => {
  test('200 — nouveau access token avec refresh cookie valide + rotation du token', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ '?column?': 1 }] })  // isRefreshTokenValid → trouvé
      .mockResolvedValueOnce({                                 // SELECT user
        rows: [{ id: 1, name: 'Admin', email: 'admin@test.com', role_id: 1 }],
      })
      .mockResolvedValueOnce({ rows: [] })                     // revokeRefreshToken (UPDATE)
      .mockResolvedValueOnce({ rows: [] });                    // storeRefreshToken (INSERT)

    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${refreshTokenValid}`);

    expect(res.status).toBe(200);
    expect(res.body.token).toBeDefined();

    // Vérifier que le nouveau access token est valide et a les bonnes données
    const payload = jwt.verify(res.body.token, process.env.JWT_SECRET);
    expect(payload.id).toBe(1);
    expect(payload.name).toBe('Admin');
    expect(payload.role).toBe(1);

    // Vérifier qu'un nouveau refresh cookie est émis (rotation)
    const cookies = res.headers['set-cookie'];
    expect(cookies).toBeDefined();
    const refreshCookie = cookies.find(c => c.startsWith('refreshToken='));
    expect(refreshCookie).toBeDefined();
  });

  test('401 — aucun cookie refresh', async () => {
    const res = await request(app).post('/api/refresh');
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('NO_REFRESH_TOKEN');
  });

  test('401 — refresh token expiré', async () => {
    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${refreshTokenExpired}`);
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('REFRESH_INVALID');
  });

  test('401 — refresh token signé avec mauvais secret', async () => {
    const badToken = jwt.sign({ id: 1, role: 1, jti: 'bad-jti' }, 'wrong-secret', { expiresIn: '7d' });
    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${badToken}`);
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('REFRESH_INVALID');
  });

  test('401 — refresh token révoqué en base', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] });  // isRefreshTokenValid → non trouvé (révoqué)

    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${refreshTokenValid}`);
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('REFRESH_REVOKED');
  });

  test('401 — utilisateur supprimé entre-temps', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ '?column?': 1 }] })  // isRefreshTokenValid → ok
      .mockResolvedValueOnce({ rows: [] })                     // SELECT user → not found
      .mockResolvedValueOnce({ rows: [] });                    // revokeRefreshToken

    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${refreshTokenValid}`);
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('USER_NOT_FOUND');
  });

  test('refresh recharge les données fraîches depuis la DB', async () => {
    // Simuler un changement de rôle en DB
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ '?column?': 1 }] })  // isRefreshTokenValid
      .mockResolvedValueOnce({                                 // SELECT user (données modifiées)
        rows: [{ id: 1, name: 'Admin Renamed', email: 'new@test.com', role_id: 2 }],
      })
      .mockResolvedValueOnce({ rows: [] })                     // revokeRefreshToken
      .mockResolvedValueOnce({ rows: [] });                    // storeRefreshToken

    const res = await request(app)
      .post('/api/refresh')
      .set('Cookie', `refreshToken=${refreshTokenValid}`);

    expect(res.status).toBe(200);
    const payload = jwt.decode(res.body.token);
    expect(payload.name).toBe('Admin Renamed');
    expect(payload.email).toBe('new@test.com');
    expect(payload.role).toBe(2);
  });
});

// =============================================================================
// AUTH — POST /api/logout
// =============================================================================
describe('POST /api/logout', () => {
  test('200 — déconnexion réussie, cookie supprimé et token révoqué en base', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // revokeRefreshToken (UPDATE)

    const res = await request(app)
      .post('/api/logout')
      .set('Cookie', `refreshToken=${refreshTokenValid}`);

    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Déconnexion réussie');

    // Vérifier que le cookie refreshToken est vidé
    const cookies = res.headers['set-cookie'];
    expect(cookies).toBeDefined();
    const refreshCookie = cookies.find(c => c.startsWith('refreshToken='));
    expect(refreshCookie).toBeDefined();
    // Cookie cleared = valeur vide ou expires dans le passé
    expect(refreshCookie).toMatch(/refreshToken=;|Expires=Thu, 01 Jan 1970/i);

    // Vérifier que revokeRefreshToken a été appelé
    expect(mockPool.query).toHaveBeenCalledWith(
      expect.stringContaining('UPDATE refresh_tokens SET revoked = TRUE'),
      expect.arrayContaining(['test-jti-1'])
    );
  });

  test('200 — fonctionne même sans cookie (idempotent)', async () => {
    const res = await request(app).post('/api/logout');
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Déconnexion réussie');
  });
});

// =============================================================================
// UTILISATEURS — GET /api/users/:id
// =============================================================================
describe('GET /api/users/:id', () => {
  test('200 — admin peut voir n\'importe quel profil', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 5, name: 'Jean', email: 'jean@test.com', role_id: 3 }],
    });

    const res = await request(app)
      .get('/api/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
    expect(res.body.id).toBe(5);
  });

  test('200 — membre peut voir son propre profil', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3 }],
    });

    const res = await request(app)
      .get('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
  });

  test('403 — membre ne peut pas voir le profil d\'un autre', async () => {
    const res = await request(app)
      .get('/api/users/99')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
  });

  test('404 — utilisateur inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .get('/api/users/1')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(404);
  });

  test('400 — ID non numérique', async () => {
    const res = await request(app)
      .get('/api/users/abc')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('ID invalide');
  });
});

// =============================================================================
// UTILISATEURS — PUT /api/users/:id
// =============================================================================
describe('PUT /api/users/:id', () => {
  test('200 — mise à jour réussie du nom', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 3, name: 'Nouveau Nom', email: 'member@test.com', role_id: 3 }],
    });

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ name: 'Nouveau Nom' });

    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Mise à jour réussie');
  });

  test('400 — aucune donnée à mettre à jour', async () => {
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({});
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Aucune donnée à mettre à jour');
  });

  test('400 — email invalide', async () => {
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ email: 'bademail' });
    expect(res.status).toBe(400);
  });

  test('403 — membre ne peut pas modifier un autre compte', async () => {
    const res = await request(app)
      .put('/api/users/99')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ name: 'Pirate' });
    expect(res.status).toBe(403);
  });

  test('404 — utilisateur inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .put('/api/users/1')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Ghost' });
    expect(res.status).toBe(404);
  });

  test('200 — changement de mot de passe révoque les refresh tokens', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3 }] }) // UPDATE users
      .mockResolvedValueOnce({ rows: [] }); // revokeAllUserRefreshTokens

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ password: 'NewPassword1' });

    expect(res.status).toBe(200);
    // Vérifier que revokeAllUserRefreshTokens a bien été appelé (2 queries au total)
    expect(mockPool.query).toHaveBeenCalledTimes(2);
    const revokeCall = mockPool.query.mock.calls[1];
    expect(revokeCall[0]).toMatch(/UPDATE refresh_tokens SET revoked = TRUE/);
  });
});

// =============================================================================
// UTILISATEURS — DELETE /api/users/:id
// =============================================================================
describe('DELETE /api/users/:id', () => {
  test('200 — suppression réussie (propriétaire)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })        // revokeAllUserRefreshTokens
      .mockResolvedValueOnce({ rows: [{ id: 3 }] }); // DELETE FROM users

    const res = await request(app)
      .delete('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Compte supprimé avec succès');
  });

  test('200 — admin peut supprimer n\'importe quel compte', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })        // revokeAllUserRefreshTokens
      .mockResolvedValueOnce({ rows: [{ id: 5 }] }); // DELETE FROM users

    const res = await request(app)
      .delete('/api/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
  });

  test('403 — membre ne peut pas supprimer un autre compte', async () => {
    const res = await request(app)
      .delete('/api/users/99')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
  });

  test('404 — utilisateur inexistant', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })  // revokeAllUserRefreshTokens
      .mockResolvedValueOnce({ rows: [] }); // DELETE FROM users → aucune ligne

    const res = await request(app)
      .delete('/api/users/1')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(404);
  });
});

// =============================================================================
// AVIONS — GET /api/airplanes
// =============================================================================
describe('GET /api/airplanes', () => {
  const mockPlanes = [
    { id: 1, name: 'F-22', country_name: 'USA', generation: 5 },
    { id: 2, name: 'Rafale', country_name: 'France', generation: 4 },
  ];

  test('200 — retourne la liste des avions', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(2);
    expect(res.body.total).toBe(2);
  });

  test('200 — filtre par pays', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA');
    expect(res.status).toBe(200);
  });

  test('200 — filtre par génération (castée en nombre)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] }) // whitelist gens
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] })                  // whitelist types
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?generation=5');
    expect(res.status).toBe(200);
  });

  test('400 — generation hors whitelist (99)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] });

    const res = await request(app).get('/api/airplanes?generation=99');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/generation invalide/);
  });

  test('400 — type hors whitelist', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] });

    const res = await request(app).get('/api/airplanes?type=NotAType');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/type invalide/);
  });

  test('200 — type valide passe la whitelist', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }, { name: 'Bombardier' }] })
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?type=Chasseur');
    expect(res.status).toBe(200);
  });

  test('400 — generation invalide (texte)', async () => {
    const res = await request(app).get('/api/airplanes?generation=abc');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/generation invalide/);
  });

  test('400 — generation invalide (0)', async () => {
    const res = await request(app).get('/api/airplanes?generation=0');
    expect(res.status).toBe(400);
  });

  test('400 — generation invalide (négatif)', async () => {
    const res = await request(app).get('/api/airplanes?generation=-1');
    expect(res.status).toBe(400);
  });

  test('200 — filtres combinés country + generation (AND)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] }) // whitelist gens
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] }) // whitelist types
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA&generation=5');
    expect(res.status).toBe(200);
    // Le COUNT est le 3ème call (après les 2 whitelist queries)
    const countCall = mockPool.query.mock.calls[2];
    expect(countCall[0]).toContain('c.name = $1');
    expect(countCall[0]).toContain('g.generation = $2');
    expect(countCall[0]).toContain('AND');
    expect(countCall[1]).toEqual(expect.arrayContaining(['USA', 5]));
  });

  test('200 — tri alphabétique', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=alphabetical');
    expect(res.status).toBe(200);
  });

  test('200 — tri inconnu → fallback ORDER BY a.id ASC', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=INVALID_SORT');
    expect(res.status).toBe(200);
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(500);
  });
});

// =============================================================================
// AVIONS — GET /api/airplanes/facets
// =============================================================================
describe('GET /api/airplanes/facets', () => {
  test('200 — retourne les trois groupes de facettes', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: 'France', n: 5 }, { k: 'USA', n: 8 }] })
      .mockResolvedValueOnce({ rows: [{ k: 4, n: 10 }, { k: 5, n: 3 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Chasseur', n: 9 }, { k: 'Bombardier', n: 4 }] });

    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('countries');
    expect(res.body).toHaveProperty('generations');
    expect(res.body).toHaveProperty('types');
    expect(res.body.countries).toEqual({ France: 5, USA: 8 });
    expect(res.body.generations).toEqual({ 4: 10, 5: 3 });
    expect(res.body.types).toEqual({ Chasseur: 9, Bombardier: 4 });
  });

  test('200 — accepte les filtres country/generation/type en query', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: 'France', n: 2 }] })
      .mockResolvedValueOnce({ rows: [{ k: 4, n: 2 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Multirôle', n: 2 }] });

    const res = await request(app)
      .get('/api/airplanes/facets')
      .query({ country: 'France', generation: '4', type: 'Multirôle' });
    expect(res.status).toBe(200);
    // Chaque groupe exclut son propre filtre (pattern facet), donc 3 queries lancées
    expect(mockPool.query).toHaveBeenCalledTimes(3);
  });

  test('200 — ignore les clés nulles dans les réponses', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: null, n: 0 }, { k: 'France', n: 5 }] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(200);
    expect(res.body.countries).toEqual({ France: 5 });
  });
});

// =============================================================================
// MONITORING — /api/live, /api/ready, /api/metrics, /api/status
// =============================================================================
describe('Monitoring endpoints', () => {
  describe('GET /api/live', () => {
    test('200 — toujours OK avec uptime', async () => {
      const res = await request(app).get('/api/live');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ok');
      expect(typeof res.body.uptime).toBe('number');
      expect(res.body.uptime).toBeGreaterThanOrEqual(0);
    });
  });

  describe('GET /api/ready', () => {
    test('200 — DB OK retourne ready avec latence', async () => {
      mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ready');
      expect(res.body.db.ok).toBe(true);
      expect(typeof res.body.db.latencyMs).toBe('number');
      expect(res.body.db.latencyMs).toBeGreaterThanOrEqual(0);
    });

    test('503 — DB inaccessible retourne not_ready', async () => {
      mockPool.query.mockRejectedValueOnce(new Error('connection refused'));
      const res = await request(app).get('/api/ready');
      expect(res.status).toBe(503);
      expect(res.body.status).toBe('not_ready');
      expect(res.body.db.ok).toBe(false);
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
    test('200 — retourne version, env, uptime, sentry status', async () => {
      const res = await request(app).get('/api/status');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ok');
      expect(typeof res.body.service).toBe('string');
      expect(typeof res.body.version).toBe('string');
      expect(res.body.version).toMatch(/^\d+\.\d+\.\d+$/);
      expect(res.body.env).toBe('test');
      expect(typeof res.body.sentry).toBe('boolean');
      expect(typeof res.body.uptimeSec).toBe('number');
      expect(typeof res.body.startedAt).toBe('string');
      // startedAt doit être un ISO 8601 valide
      expect(new Date(res.body.startedAt).toString()).not.toBe('Invalid Date');
    });

    test('200 — expose le commit si GIT_COMMIT est défini', async () => {
      process.env.GIT_COMMIT = 'abc1234';
      const res = await request(app).get('/api/status');
      expect(res.status).toBe(200);
      expect(res.body.commit).toBe('abc1234');
      delete process.env.GIT_COMMIT;
    });

    test('200 — commit null si GIT_COMMIT non défini', async () => {
      delete process.env.GIT_COMMIT;
      const res = await request(app).get('/api/status');
      expect(res.status).toBe(200);
      expect(res.body.commit).toBeNull();
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

  test('200 — supporte aussi /details?id=X', async () => {
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
    expect(res.status).toBe(200);
    expect(res.text).toContain('<title>Mirage 2000');
    expect(res.text).toContain('https://example.com/mirage.jpg');
  });
});

// =============================================================================
// AVIONS — GET /api/airplanes/:id
// =============================================================================
describe('GET /api/airplanes/:id', () => {
  test('200 — retourne le détail d\'un avion', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'F-22 Raptor', manufacturer_name: 'Lockheed' }],
    });

    const res = await request(app).get('/api/airplanes/1');
    expect(res.status).toBe(200);
    expect(res.body.name).toBe('F-22 Raptor');
  });

  test('404 — avion inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes/999');
    expect(res.status).toBe(404);
    expect(res.body.message).toBe('Avion non trouvé');
  });

  test('400 — ID non numérique', async () => {
    const res = await request(app).get('/api/airplanes/abc');
    expect(res.status).toBe(400);
  });
});

// =============================================================================
// AVIONS — POST /api/airplanes
// =============================================================================
describe('POST /api/airplanes', () => {
  const validAirplane = {
    name: 'Mirage 2000',
    complete_name: 'Dassault Mirage 2000',
    little_description: 'Chasseur français',
    image_url: 'https://example.com/mirage.jpg',
    description: null,
    country_id: 2,
    date_concept: '1972-01-01',
    date_first_fly: '1978-03-10',
    date_operationel: '1984-07-01',
    max_speed: 2336,
    max_range: 1850,
    id_manufacturer: 1,
    id_generation: 4,
    type: 1,
    status: 'en service',
    weight: 7500,
  };

  const fkAllValid = { rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }] };

  test('201 — création réussie (admin)', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 10, name: 'Mirage 2000' }] });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(validAirplane);

    expect(res.status).toBe(201);
    expect(res.body.name).toBe('Mirage 2000');
  });

  test('201 — création réussie (éditeur)', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 11, name: 'Mirage 2000' }] });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenEditor}`)
      .send(validAirplane);

    expect(res.status).toBe(201);
  });

  test('400 — country_id inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: false, manufacturer_ok: true, generation_ok: true, type_ok: true }],
    });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, country_id: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('country_id invalide');
  });

  test('400 — plusieurs FK invalides', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: false, generation_ok: false, type_ok: true }],
    });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, id_manufacturer: 9999, id_generation: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('id_manufacturer invalide');
    expect(res.body.errors).toContain('id_generation invalide');
  });

  test('403 — membre ne peut pas créer un avion', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send(validAirplane);
    expect(res.status).toBe(403);
  });

  test('400 — nom manquant', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, name: '' });

    expect(res.status).toBe(400);
    expect(res.body.errors).toBeDefined();
  });

  test('400 — URL image invalide', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, image_url: 'not-a-url' });

    expect(res.status).toBe(400);
  });

  test('403 — sans token', async () => {
    const res = await request(app).post('/api/airplanes').send(validAirplane);
    expect(res.status).toBe(403);
  });
});

// =============================================================================
// AVIONS — PUT /api/airplanes/:id
// =============================================================================
describe('PUT /api/airplanes/:id', () => {
  const updatedData = {
    name: 'F-16 Block 60',
    complete_name: 'F-16 Fighting Falcon Block 60',
    little_description: null,
    image_url: null,
    description: null,
    country_id: 1,
    date_concept: null,
    date_first_fly: null,
    date_operationel: null,
    max_speed: 2100,
    max_range: 4200,
    id_manufacturer: null,
    id_generation: null,
    type: null,
    status: null,
    weight: null,
  };

  const fkAllValid = { rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }] };

  test('200 — mise à jour réussie', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 5, name: 'F-16 Block 60' }] });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(updatedData);

    expect(res.status).toBe(200);
  });

  test('404 — avion inexistant', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .put('/api/airplanes/999')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(updatedData);

    expect(res.status).toBe(404);
  });

  test('400 — type inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: false }],
    });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...updatedData, type: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('type invalide');
  });

  test('403 — membre ne peut pas modifier un avion', async () => {
    const res = await request(app)
      .put('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send(updatedData);
    expect(res.status).toBe(403);
  });
});

// =============================================================================
// AVIONS — DELETE /api/airplanes/:id
// =============================================================================
describe('DELETE /api/airplanes/:id', () => {
  test('200 — suppression réussie', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 3, name: 'Jaguar' }] });

    const res = await request(app)
      .delete('/api/airplanes/3')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(200);
    expect(res.body.message).toContain('Jaguar');
  });

  test('404 — avion inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .delete('/api/airplanes/999')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(404);
  });

  test('403 — éditeur peut supprimer un avion', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'F-22' }] });

    const res = await request(app)
      .delete('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenEditor}`);
    expect(res.status).toBe(200);
  });

  test('403 — membre ne peut pas supprimer', async () => {
    const res = await request(app)
      .delete('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
  });
});

// =============================================================================
// AVIONS — Routes relations (armement, tech, missions, guerres)
// =============================================================================
describe('Relations avions', () => {
  test('GET /api/airplanes/:id/armament — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ name: 'AIM-120', description: 'Missile air-air' }],
    });
    const res = await request(app).get('/api/airplanes/1/armament');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('AIM-120');
  });

  test('GET /api/airplanes/:id/tech — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ name: 'Stealth', description: 'Furtivité' }] });
    const res = await request(app).get('/api/airplanes/1/tech');
    expect(res.status).toBe(200);
  });

  test('GET /api/airplanes/:id/missions — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ name: 'CAS', description: 'Appui aérien' }] });
    const res = await request(app).get('/api/airplanes/1/missions');
    expect(res.status).toBe(200);
  });

  test('GET /api/airplanes/:id/wars — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ name: 'Guerre du Golfe', date_start: '1990-08-02', date_end: '1991-02-28' }],
    });
    const res = await request(app).get('/api/airplanes/1/wars');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('Guerre du Golfe');
  });

  test('500 — erreur DB sur armament', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/airplanes/1/armament');
    expect(res.status).toBe(500);
  });

  test('GET /api/airplanes/:id/related — 200 (toutes les relations)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ name: 'Missile MICA', description: 'IR/EM' }] }) // armement
      .mockResolvedValueOnce({ rows: [{ name: 'RBE2-AA', description: 'Radar AESA' }] }) // tech
      .mockResolvedValueOnce({ rows: [{ name: 'Supériorité aérienne', description: '' }] }) // missions
      .mockResolvedValueOnce({ rows: [{ name: 'Opération Serval', date_start: '2013', date_end: '2014', description: '' }] }); // wars

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('armament');
    expect(res.body).toHaveProperty('tech');
    expect(res.body).toHaveProperty('missions');
    expect(res.body).toHaveProperty('wars');
    expect(res.body.armament[0].name).toBe('Missile MICA');
  });

  test('GET /api/airplanes/:id/related — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(500);
    expect(res.body.message).toBe('Erreur interne du serveur');
    expect(res.body.errorId).toBeDefined();
  });
});

// =============================================================================
// RÉFÉRENTIELS — countries, generations, types, manufacturers
// =============================================================================
describe('Référentiels', () => {
  test('GET /api/countries — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'France' }, { id: 2, name: 'USA' }] });
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
  });

  test('GET /api/generations — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] });
    const res = await request(app).get('/api/generations');
    expect(res.status).toBe(200);
    expect(res.body).toEqual([4, 5]);
  });

  test('GET /api/types — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'Chasseur' }] });
    const res = await request(app).get('/api/types');
    expect(res.status).toBe(200);
  });

  test('GET /api/manufacturers — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'Dassault', country_name: 'France' }],
    });
    const res = await request(app).get('/api/manufacturers');
    expect(res.status).toBe(200);
  });

  test('500 — erreur DB sur countries', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(500);
  });

  test('GET /api/countries — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(500);
  });

  test('GET /api/generations — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/generations');
    expect(res.status).toBe(500);
  });

  test('GET /api/types — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/types');
    expect(res.status).toBe(500);
  });
});

// =============================================================================
// FAVORIS
// =============================================================================
describe('Favoris', () => {
  test('GET /api/favorites — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'F-22', favorited_at: new Date() }],
    });

    const res = await request(app)
      .get('/api/favorites')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
  });

  test('GET /api/favorites — 403 sans token', async () => {
    const res = await request(app).get('/api/favorites');
    expect(res.status).toBe(403);
  });

  test('POST /api/favorites/:airplaneId — 201', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .post('/api/favorites/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(201);
    expect(res.body.message).toBe('Ajouté aux favoris');
  });

  test('DELETE /api/favorites/:airplaneId — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 1 });

    const res = await request(app)
      .delete('/api/favorites/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Supprimé des favoris');
  });

  test('DELETE /api/favorites/:airplaneId — 404 non trouvé', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 0 });

    const res = await request(app)
      .delete('/api/favorites/99')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(404);
  });

  test('GET /api/airplanes/:id/favorite — isFavorite: true', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });

    const res = await request(app)
      .get('/api/airplanes/1/favorite')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.isFavorite).toBe(true);
  });

  test('GET /api/airplanes/:id/favorite — isFavorite: false', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .get('/api/airplanes/1/favorite')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.isFavorite).toBe(false);
  });
});

// =============================================================================
// STATISTIQUES — GET /api/stats
// =============================================================================
describe('GET /api/stats', () => {
  test('200 — retourne les statistiques', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ total: 47 }] })
      .mockResolvedValueOnce({ rows: [{ earliest: 1953, latest: 2023 }] })
      .mockResolvedValueOnce({ rows: [{ total: 12 }] });

    const res = await request(app).get('/api/stats');
    expect(res.status).toBe(200);
    expect(res.body.airplanes).toBe(47);
    expect(res.body.earliest_year).toBe(1953);
    expect(res.body.latest_year).toBe(2023);
    expect(res.body.countries).toBe(12);
  });

  test('500 — erreur DB', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/stats');
    expect(res.status).toBe(500);
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
// ADMIN — PUT /api/admin/users/:id
// =============================================================================
describe('PUT /api/admin/users/:id', () => {
  test('200 — admin peut changer le rôle d\'un utilisateur', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 3, name: 'Jean', email: 'jean@test.com', role_id: 2 }],
    });

    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean', role_id: 2 });

    expect(res.status).toBe(200);
    expect(res.body.role_id).toBe(2);
  });

  test('403 — éditeur ne peut pas accéder à la route admin', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenEditor}`)
      .send({ name: 'Jean', role_id: 2 });
    expect(res.status).toBe(403);
  });

  test('404 — utilisateur inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .put('/api/admin/users/999')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Ghost', role_id: 3 });
    expect(res.status).toBe(404);
  });

  test('400 — nom invalide (trop court)', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'J', role_id: 2 });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Nom invalide/);
  });

  test('400 — nom manquant', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ role_id: 2 });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Nom invalide/);
  });

  test('400 — role_id invalide (0)', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean', role_id: 0 });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Rôle invalide/);
  });

  test('400 — role_id invalide (99)', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean', role_id: 99 });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Rôle invalide/);
  });

  test('400 — role_id manquant', async () => {
    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Rôle invalide/);
  });
});

// =============================================================================
// AUTH — GET /api/auth/verify-email
// =============================================================================
describe('GET /api/auth/verify-email', () => {
  const validToken = 'a'.repeat(64); // 64 chars hex valide

  test('200 — token valide → compte vérifié', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 5, user_id: 1 }] }) // SELECT email_tokens
      .mockResolvedValueOnce({ rows: [] })                       // UPDATE users email_verified
      .mockResolvedValueOnce({ rows: [] });                      // UPDATE email_tokens used_at

    const res = await request(app).get(`/api/auth/verify-email?token=${validToken}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toMatch(/vérifié/);
  });

  test('400 — token absent', async () => {
    const res = await request(app).get('/api/auth/verify-email');
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Token invalide');
  });

  test('400 — token format invalide (pas hex)', async () => {
    const res = await request(app).get('/api/auth/verify-email?token=notahextoken');
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Token invalide');
  });

  test('400 — token valide mais non trouvé / expiré → TOKEN_INVALID', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // token non trouvé

    const res = await request(app).get(`/api/auth/verify-email?token=${validToken}`);
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('TOKEN_INVALID');
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app).get(`/api/auth/verify-email?token=${validToken}`);
    expect(res.status).toBe(500);
  });
});

// =============================================================================
// AUTH — POST /api/auth/resend-verification
// =============================================================================
describe('POST /api/auth/resend-verification', () => {
  beforeEach(() => {
    mailer.sendVerificationEmail.mockClear();
  });

  test('200 — email valide → toujours 200 (sécurité)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Jean', email_verified: false }] }) // SELECT user
      .mockResolvedValueOnce({ rows: [] })  // UPDATE anciens tokens
      .mockResolvedValueOnce({ rows: [] }); // INSERT nouveau token

    const res = await request(app)
      .post('/api/auth/resend-verification')
      .send({ email: 'jean@test.com' });
    expect(res.status).toBe(200);
  });

  test('200 — email inconnu → toujours 200 (pas de fuite d\'info)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // utilisateur inexistant

    const res = await request(app)
      .post('/api/auth/resend-verification')
      .send({ email: 'inconnu@test.com' });
    expect(res.status).toBe(200);
  });

  test('400 — email invalide', async () => {
    const res = await request(app)
      .post('/api/auth/resend-verification')
      .send({ email: 'notanemail' });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email invalide');
  });

  test('400 — body vide', async () => {
    const res = await request(app)
      .post('/api/auth/resend-verification')
      .send({});
    expect(res.status).toBe(400);
  });
});

// =============================================================================
// AUTH — POST /api/auth/forgot-password
// =============================================================================
describe('POST /api/auth/forgot-password', () => {
  beforeEach(() => {
    mailer.sendPasswordResetEmail.mockClear();
  });

  test('200 — email vérifié existant → toujours 200', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Jean', email_verified: true }] }) // SELECT user
      .mockResolvedValueOnce({ rows: [] })  // UPDATE anciens tokens reset
      .mockResolvedValueOnce({ rows: [] }); // INSERT nouveau token reset

    const res = await request(app)
      .post('/api/auth/forgot-password')
      .send({ email: 'jean@test.com' });
    expect(res.status).toBe(200);
  });

  test('200 — compte non vérifié → toujours 200 (pas d\'email envoyé)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 2, name: 'Paul', email_verified: false }] });

    const res = await request(app)
      .post('/api/auth/forgot-password')
      .send({ email: 'paul@test.com' });
    expect(res.status).toBe(200);
  });

  test('200 — email inconnu → toujours 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .post('/api/auth/forgot-password')
      .send({ email: 'inconnu@test.com' });
    expect(res.status).toBe(200);
  });

  test('400 — email invalide', async () => {
    const res = await request(app)
      .post('/api/auth/forgot-password')
      .send({ email: 'invalid' });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Email invalide');
  });
});

// =============================================================================
// AUTH — POST /api/auth/reset-password
// =============================================================================
describe('POST /api/auth/reset-password', () => {
  const validToken = 'b'.repeat(64);
  const validPassword = 'NewPass123';

  test('200 — token valide + mot de passe conforme → réinitialisation réussie', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 5, user_id: 1 }] }) // SELECT email_tokens
      .mockResolvedValueOnce({ rows: [] })                       // UPDATE users SET password
      .mockResolvedValueOnce({ rows: [] })                       // UPDATE email_tokens used_at
      .mockResolvedValueOnce({ rows: [] });                      // revokeAllUserRefreshTokens

    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: validPassword });
    expect(res.status).toBe(200);
    expect(res.body.message).toMatch(/réinitialisé/);
  });

  test('400 — token absent', async () => {
    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ password: validPassword });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Token invalide');
  });

  test('400 — token format invalide', async () => {
    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: 'invalid', password: validPassword });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Token invalide');
  });

  test('400 — mot de passe invalide (trop court)', async () => {
    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: 'short' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('400 — token non trouvé / expiré → TOKEN_INVALID', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // token non trouvé

    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: validPassword });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('TOKEN_INVALID');
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: validPassword });
    expect(res.status).toBe(500);
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
  test('200 — retourne un XML valide avec les URLs des avions', async () => {
    mockPool.query.mockImplementation(() =>
      Promise.resolve({
        rows: [{ id: 1 }, { id: 2 }, { id: 42 }],
      })
    );

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/xml/);
    expect(res.text).toContain('<?xml version="1.0" encoding="UTF-8"?>');
    expect(res.text).toContain('/details?id=1');
    expect(res.text).toContain('/details?id=2');
    expect(res.text).toContain('/details?id=42');
    expect(res.text).toContain('/hangar');
  });

  test('500 — erreur BDD → réponse texte erreur serveur', async () => {
    mockPool.query.mockImplementation(() =>
      Promise.reject(new Error('DB down'))
    );

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(500);
    expect(res.body.message).toBe('Erreur interne du serveur');
    expect(res.body.errorId).toBeDefined();
  });
});

// =============================================================================
// REGISTER — Mailer failure handling (S3)
// =============================================================================
describe('POST /api/register — gestion échec mailer', () => {
  const validPayload = {
    name: 'Marie Curie',
    email: 'marie@example.com',
    password: 'Password123',
  };

  beforeEach(() => {
    mailer.sendVerificationEmail.mockReset();
  });

  // IPs uniques pour contourner le rate limiter register (10/15min par IP)
  test('201 — premier envoi échoue, retry réussit → pas de warning', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ id: 10, name: 'Marie Curie' }] })
      .mockResolvedValueOnce({ rows: [] });

    mailer.sendVerificationEmail
      .mockRejectedValueOnce(new Error('SMTP timeout'))
      .mockResolvedValueOnce(undefined);

    const res = await request(app)
      .post('/api/register')
      .set('X-Forwarded-For', '10.0.0.1')
      .send(validPayload);
    expect(res.status).toBe(201);
    expect(res.body.warning).toBeUndefined();
    expect(mailer.sendVerificationEmail).toHaveBeenCalledTimes(2);
  });

  test('201 — premier ET second envois échouent → warning EMAIL_NOT_SENT', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ id: 11, name: 'Marie Curie' }] })
      .mockResolvedValueOnce({ rows: [] });

    mailer.sendVerificationEmail
      .mockRejectedValueOnce(new Error('SMTP down'))
      .mockRejectedValueOnce(new Error('SMTP still down'));

    const res = await request(app)
      .post('/api/register')
      .set('X-Forwarded-For', '10.0.0.2')
      .send(validPayload);
    expect(res.status).toBe(201);
    expect(res.body.warning).toBe('EMAIL_NOT_SENT');
    expect(res.body.message).toMatch(/Renvoyer/);
    expect(mailer.sendVerificationEmail).toHaveBeenCalledTimes(2);
  });

  test('201 — compte créé en BD même si mailer échoue (pas de rollback)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ id: 12, name: 'Marie Curie' }] })
      .mockResolvedValueOnce({ rows: [] });

    mailer.sendVerificationEmail.mockRejectedValue(new Error('SMTP unreachable'));

    const res = await request(app)
      .post('/api/register')
      .set('X-Forwarded-For', '10.0.0.3')
      .send(validPayload);
    expect(res.status).toBe(201);
    // INSERT users a bien été appelé (compte persisté)
    const insertUsersCall = mockPool.query.mock.calls.find(
      (c) => typeof c[0] === 'string' && c[0].includes('INSERT INTO users')
    );
    expect(insertUsersCall).toBeDefined();
  });
});

// =============================================================================
// RESET-PASSWORD — Cas combinés (S2/S3)
// =============================================================================
describe('POST /api/auth/reset-password — cas combinés', () => {
  const validToken = 'c'.repeat(64);
  const validPassword = 'BrandNew123';

  test('400 — token ET password tous deux invalides → erreur token en premier', async () => {
    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: 'bad', password: 'short' });
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Token invalide');
  });

  test('400 — token valide format mais password trop court', async () => {
    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: 'Ab1' });
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
    // Aucune query SQL ne doit avoir été exécutée (validation avant DB)
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test('500 — échec UPDATE users → rollback transaction', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 7, user_id: 42 }] }) // SELECT email_tokens OK
      .mockRejectedValueOnce(new Error('UPDATE users failed'));   // UPDATE password KO

    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: validPassword });
    expect(res.status).toBe(500);
  });

  test('200 — révoque tous les refresh tokens de l\'utilisateur', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 8, user_id: 99 }] })
      .mockResolvedValueOnce({ rows: [] }) // UPDATE users
      .mockResolvedValueOnce({ rows: [] }) // UPDATE email_tokens
      .mockResolvedValueOnce({ rows: [] }); // UPDATE refresh_tokens

    const res = await request(app)
      .post('/api/auth/reset-password')
      .send({ token: validToken, password: validPassword });
    expect(res.status).toBe(200);

    // Vérifier la révocation des refresh tokens (4ème call)
    const revokeCall = mockPool.query.mock.calls.find(
      (c) => typeof c[0] === 'string' && c[0].includes('UPDATE refresh_tokens')
    );
    expect(revokeCall).toBeDefined();
    expect(revokeCall[1]).toEqual([99]);
  });
});

// =============================================================================
// REFERENTIALS — Endpoint combiné + Cache-Control
// =============================================================================
describe('GET /api/referentials', () => {
  test('200 — retourne countries, generations, types, manufacturers en 1 réponse', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'France' }] })           // countries
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] }) // generations
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Chasseur', description: null }] }) // types
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Dassault', code: 'DAS', country_id: 1, country_name: 'France' }] }); // manufacturers

    const res = await request(app).get('/api/referentials');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('countries');
    expect(res.body).toHaveProperty('generations');
    expect(res.body).toHaveProperty('types');
    expect(res.body).toHaveProperty('manufacturers');
    expect(res.body.generations).toEqual([4, 5]);
    expect(res.body.countries).toHaveLength(1);
  });

  test('200 — header Cache-Control présent (cacheable)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/referentials');
    expect(res.headers['cache-control']).toBeDefined();
    expect(res.headers['cache-control']).toMatch(/public/);
    expect(res.headers['cache-control']).toMatch(/max-age=\d+/);
  });

  test('500 — une des 4 requêtes échoue → erreur globale', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockRejectedValueOnce(new Error('DB error'))
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/referentials');
    expect(res.status).toBe(500);
  });

  test('Cache-Control présent sur /api/types (référentiel individuel)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'X', description: null }] });
    const res = await request(app).get('/api/types');
    expect(res.headers['cache-control']).toMatch(/public/);
  });
});

// =============================================================================
// isOwnerOrAdmin — middleware (refactor task #7)
// =============================================================================
describe('Middleware isOwnerOrAdmin', () => {
  test('GET /api/users/:id — membre accède à son propre profil → 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3 }],
    });
    const res = await request(app).get('/api/users/3').set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
  });

  test('GET /api/users/:id — membre accède au profil d\'un autre → 403', async () => {
    const res = await request(app).get('/api/users/99').set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
    expect(res.body.message).toBe('Accès non autorisé');
  });

  test('GET /api/users/:id — admin accède à n\'importe quel profil → 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 99, name: 'Other', email: 'o@x.fr', role_id: 3 }],
    });
    const res = await request(app).get('/api/users/99').set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
  });

  test('DELETE /api/users/:id — membre tente de supprimer un autre compte → 403', async () => {
    const res = await request(app).delete('/api/users/99').set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
  });

  test('PUT /api/users/:id — éditeur tente de modifier un autre compte → 403', async () => {
    const res = await request(app)
      .put('/api/users/99')
      .set('Authorization', `Bearer ${tokenEditor}`)
      .send({ name: 'Hack' });
    expect(res.status).toBe(403);
  });
});

// =============================================================================
// cleanupUnverifiedUsers (S1)
// =============================================================================
describe('cleanupUnverifiedUsers', () => {
  const { cleanupUnverifiedUsers } = require('../middleware/auth');

  test('supprime les comptes non vérifiés > 7j et retourne le count', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 5 });
    const deleted = await cleanupUnverifiedUsers();
    expect(deleted).toBe(5);

    const call = mockPool.query.mock.calls[0];
    expect(call[0]).toMatch(/DELETE FROM users/);
    expect(call[0]).toMatch(/email_verified = FALSE/);
    expect(call[0]).toMatch(/INTERVAL '7 days'/);
  });

  test('retourne 0 si aucun compte à supprimer', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 0 });
    const deleted = await cleanupUnverifiedUsers();
    expect(deleted).toBe(0);
  });

  test('rowCount null → retourne 0', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: null });
    const deleted = await cleanupUnverifiedUsers();
    expect(deleted).toBe(0);
  });

  test('propage l\'erreur DB', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB locked'));
    await expect(cleanupUnverifiedUsers()).rejects.toThrow('DB locked');
  });
});
