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
    mockPool.query.mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(2);
  });

  test('200 — filtre par pays', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA');
    expect(res.status).toBe(200);
    expect(mockPool.query).toHaveBeenCalledWith(
      expect.stringContaining('WHERE'),
      expect.arrayContaining(['USA'])
    );
  });

  test('200 — filtre par génération (castée en nombre)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?generation=5');
    expect(res.status).toBe(200);
    // S4 FIX : vérifier que generation est passée comme Number, pas comme String
    expect(mockPool.query).toHaveBeenCalledWith(
      expect.stringContaining('g.generation = $1'),
      [5]
    );
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
    mockPool.query.mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA&generation=5');
    expect(res.status).toBe(200);
    // S4 FIX : les deux filtres doivent être combinés avec AND
    const queryCall = mockPool.query.mock.calls[0];
    expect(queryCall[0]).toContain('c.name = $1');
    expect(queryCall[0]).toContain('g.generation = $2');
    expect(queryCall[0]).toContain('AND');
    expect(queryCall[1]).toEqual(['USA', 5]);
  });

  test('200 — tri alphabétique', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=alphabetical');
    expect(res.status).toBe(200);
    expect(mockPool.query).toHaveBeenCalledWith(
      expect.stringContaining('ORDER BY a.name ASC'),
      []
    );
  });

  test('200 — tri inconnu → fallback ORDER BY a.id ASC', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=INVALID_SORT');
    expect(res.status).toBe(200);
    expect(mockPool.query).toHaveBeenCalledWith(
      expect.stringContaining('ORDER BY a.id ASC'),
      []
    );
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(500);
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
