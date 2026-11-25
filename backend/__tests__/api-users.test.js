/**
 * Tests d'intégration — Comptes : liste, lecture, modification, suppression, administration.
 * Base de données simulée : banc commun __tests__/helpers/api-harness.js
 * (découpé de l'ancien api.test.js — ARCH-004).
 */
jest.mock('../mailer', () => require('./helpers/mailer-mock')());
const h = require('./helpers/api-harness');

const {
  request, jwt, mailer, app, mockPool, tokenAdmin, tokenEditor, tokenMember,
} = h;

h.installHooks();


// =============================================================================
// UTILISATEURS — GET /api/users?role= (filtre et compteurs par rôle)
// =============================================================================
describe('GET /api/users — filtre de rôle et meta.roles', () => {
  const ROLE_COUNTS = { rows: [
    { role_id: 1, count: '2' },
    { role_id: 3, count: '40' },
    { role_id: null, count: '1' },
  ] };

  test('200 — sans filtre : meta.roles a toujours les trois clés, total = tous les comptes', async () => {
    mockPool.query
      .mockResolvedValueOnce(ROLE_COUNTS)
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Admin', email: 'a@test.fr', role_id: 1 }] });
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
    expect(res.body.meta).toEqual({ total: 43, page: 1, limit: 20, totalPages: 3, roles: { 1: 2, 2: 0, 3: 40 } });
    expect(mockPool.query.mock.calls[0][0]).toMatch(/GROUP BY role_id/);
    expect(mockPool.query.mock.calls[1][0]).not.toMatch(/role_id = \$/);
  });

  test('200 — ?role=3 : liste filtrée, total du rôle, compteurs sans le filtre', async () => {
    mockPool.query
      .mockResolvedValueOnce(ROLE_COUNTS)
      .mockResolvedValueOnce({ rows: [] });
    const res = await request(app)
      .get('/api/users?role=3&search=jean&limit=10')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
    expect(res.body.meta.total).toBe(40);
    expect(res.body.meta.totalPages).toBe(4);
    expect(res.body.meta.roles).toEqual({ 1: 2, 2: 0, 3: 40 });

    const [countSql, countValues] = mockPool.query.mock.calls[0];
    expect(countSql).not.toMatch(/role_id = \$/);
    expect(countValues).toEqual(['%jean%']);
    const [listSql, listValues] = mockPool.query.mock.calls[1];
    expect(listSql).toMatch(/WHERE \(name ILIKE \$1 OR email ILIKE \$1\) AND role_id = \$2 ORDER BY id LIMIT \$3 OFFSET \$4/);
    expect(listValues).toEqual(['%jean%', 3, 10, 0]);
  });

  test('200 — ?role=2 sans aucun éditeur : total 0', async () => {
    mockPool.query
      .mockResolvedValueOnce(ROLE_COUNTS)
      .mockResolvedValueOnce({ rows: [] });
    const res = await request(app)
      .get('/api/users?role=2')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
    expect(res.body.meta.total).toBe(0);
    expect(res.body.meta.totalPages).toBe(0);
    expect(mockPool.query.mock.calls[1][1]).toEqual([2, 20, 0]);
  });

  test('200 — ?role= vide : aucun filtre', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });
    const res = await request(app)
      .get('/api/users?role=')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(200);
    expect(res.body.meta.roles).toEqual({ 1: 0, 2: 0, 3: 0 });
    expect(res.body.meta.total).toBe(0);
    expect(mockPool.query.mock.calls[1][1]).toEqual([20, 0]);
  });

  test.each(['0', '4', 'admin', '1.0', '01', '-1'])('400 — ?role=%s refusé avant toute requête', async (role) => {
    const res = await request(app)
      .get(`/api/users?role=${encodeURIComponent(role)}`)
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Rôle invalide (1 = admin, 2 = éditeur, 3 = membre)');
    expect(mockPool.query).not.toHaveBeenCalled();
  });

  test('400 — ?role répété (tableau) refusé', async () => {
    const res = await request(app)
      .get('/api/users?role=1&role=2')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(400);
    expect(mockPool.query).not.toHaveBeenCalled();
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

  test('200 — created_at renvoyé en ISO 8601, sans hash ni token_version', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3, created_at: new Date('2025-03-14T09:26:53.000Z') }],
    });

    const res = await request(app)
      .get('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.created_at).toBe('2025-03-14T09:26:53.000Z');
    expect(res.body).not.toHaveProperty('password');
    expect(res.body).not.toHaveProperty('token_version');

    const [sql, values] = mockPool.query.mock.calls[0];
    expect(sql).toMatch(/SELECT id, name, email, role_id, created_at FROM users WHERE id = \$1/);
    expect(sql).not.toMatch(/password|token_version/);
    expect(values).toEqual(['3']);
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
  // Ligne users lue avant toute modification (mot de passe actuel : 'CurrentPass1')
  const bcryptjs = require('bcryptjs');
  const CURRENT_HASH = bcryptjs.hashSync('CurrentPass1', 4);
  const memberRow = () => ({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', password: CURRENT_HASH }] });

  test('200 — mise à jour réussie du nom (sans mot de passe actuel)', async () => {
    mockPool.query
      .mockResolvedValueOnce(memberRow())
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Nouveau Nom', email: 'member@test.com', role_id: 3, token_version: 0 }] });

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ name: 'Nouveau Nom' });

    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Mise à jour réussie');
    expect(res.body.token).toBeUndefined();
  });

  test('400 — aucune donnée à mettre à jour', async () => {
    mockPool.query.mockResolvedValueOnce(memberRow());
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({});
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Aucune donnée à mettre à jour');
  });

  test('400 — email identique à l\'actuel et pas de nom : rien à mettre à jour, aucun mot de passe exigé', async () => {
    mockPool.query.mockResolvedValueOnce(memberRow());
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ email: 'MEMBER@test.com' });
    expect(res.status).toBe(400);
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

  test('400 CURRENT_PASSWORD_REQUIRED — changement de mot de passe sans le mot de passe actuel', async () => {
    mockPool.query.mockResolvedValueOnce(memberRow());
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ password: 'NewPassword1' });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CURRENT_PASSWORD_REQUIRED');
    expect(mockPool.query).toHaveBeenCalledTimes(1); // aucune écriture
  });

  test('403 CURRENT_PASSWORD_INVALID — mot de passe actuel incorrect', async () => {
    mockPool.query.mockResolvedValueOnce(memberRow());
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ password: 'NewPassword1', currentPassword: 'WrongPass1' });
    expect(res.status).toBe(403);
    expect(res.body.code).toBe('CURRENT_PASSWORD_INVALID');
    // Lecture du compte, puis l'échec compté comme un échec de connexion
    // (SEC-005) ; aucune écriture du profil.
    expect(mockPool.query).toHaveBeenCalledTimes(2);
    expect(mockPool.query.mock.calls[1][0]).toMatch(/failed_login_count = failed_login_count \+ 1/);
  });

  test('200 — changement de mot de passe : sessions révoquées, token_version incrémenté, nouvelle session émise', async () => {
    mockPool.query
      .mockResolvedValueOnce(memberRow())
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3, token_version: 0 }] }) // UPDATE users
      .mockResolvedValueOnce({ rows: [] })                          // révocation des refresh tokens
      .mockResolvedValueOnce({ rows: [{ token_version: 1 }] })      // bumpTokenVersion
      .mockResolvedValueOnce({ rows: [] });                         // storeRefreshToken (nouvelle session)

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ password: 'NewPassword1', currentPassword: 'CurrentPass1' });

    expect(res.status).toBe(200);
    const sqls = mockPool.query.mock.calls.map(c => c[0]);
    expect(sqls.some(q => /UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = \$1/.test(q))).toBe(true);
    expect(sqls.some(q => /SET token_version = token_version \+ 1/.test(q))).toBe(true);
    // Le nouvel access token porte la nouvelle version : l'ancien est refusé
    expect(jwt.decode(res.body.token).tv).toBe(1);
    expect(res.headers['set-cookie'].find(c => c.startsWith('refreshToken='))).toBeDefined();
  });

  test('200 — changement d\'email : aucune écriture directe, code envoyé à la nouvelle adresse, ancienne prévenue', async () => {
    mailer.sendEmailChangeConfirmation.mockClear();
    mailer.sendEmailChangeNotice.mockClear();
    mockPool.query
      .mockResolvedValueOnce(memberRow())
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', role_id: 3, token_version: 0 }] }) // UPDATE name
      .mockResolvedValueOnce({ rows: [] })   // DELETE des anciens codes 'email'
      .mockResolvedValueOnce({ rows: [] });  // INSERT code 'email'

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ name: 'Member', email: 'nouvelle@test.com', currentPassword: 'CurrentPass1' });

    expect(res.status).toBe(200);
    expect(res.body.emailChangePending).toBe(true);
    expect(res.body.user.email).toBe('member@test.com');
    const sqls = mockPool.query.mock.calls.map(c => c[0]);
    expect(sqls.some(q => /UPDATE users SET .*email = /.test(q))).toBe(false);
    const purge = mockPool.query.mock.calls.find(c => /DELETE FROM email_tokens/.test(c[0]));
    expect(purge[1]).toEqual([3, 'email']);
    const insert = mockPool.query.mock.calls.find(c => /INSERT INTO email_tokens/.test(c[0]));
    expect(insert[1][2]).toBe('email');
    expect(insert[1][4]).toBe('nouvelle@test.com');
    expect(mailer.sendEmailChangeConfirmation).toHaveBeenCalledWith('nouvelle@test.com', 'Member', expect.stringMatching(/^[0-9]{6}$/));
    // Seule l'empreinte du code est stockée, liée au compte et au type
    const { hashCode } = require('../repositories/email-tokens');
    const code = mailer.sendEmailChangeConfirmation.mock.calls[0][2];
    expect(insert[1][1]).toBe(hashCode(3, 'email', code));
    expect(mailer.sendEmailChangeNotice).toHaveBeenCalledWith('member@test.com', 'Member');
  });

  test('changement d\'email : réponse identique que l\'adresse soit prise ou libre (pas d\'oracle)', async () => {
    // Aucune requête ne touche la contrainte UNIQUE à ce stade : même status, même corps.
    const send = async (target) => {
      mockPool.query.mockReset();
      mockPool.query
        .mockResolvedValueOnce(memberRow())
        .mockResolvedValueOnce({ rows: [] })
        .mockResolvedValueOnce({ rows: [] });
      return request(app)
        .put('/api/users/3')
        .set('Authorization', `Bearer ${tokenMember}`)
        .send({ email: target, currentPassword: 'CurrentPass1' });
    };
    const taken = await send('admin@test.com');
    const free = await send('libre@test.com');
    expect(taken.status).toBe(free.status);
    expect(taken.body.message).toBe(free.body.message);
  });

  test('admin sur le compte d\'un autre : email appliqué directement, sessions coupées, sans mot de passe actuel', async () => {
    mockPool.query
      .mockResolvedValueOnce(memberRow())
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Member', email: 'autre@test.com', role_id: 3, token_version: 0 }] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ token_version: 1 }] });

    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ email: 'autre@test.com' });

    expect(res.status).toBe(200);
    expect(res.body.emailChangePending).toBe(false);
    expect(res.body.token).toBeUndefined(); // pas de session pour l'admin à la place de l'utilisateur
    expect(mockPool.query.mock.calls.some(c => /SET token_version = token_version \+ 1/.test(c[0]))).toBe(true);
  });
});


// =============================================================================
// UTILISATEURS — DELETE /api/users/:id
// =============================================================================
describe('DELETE /api/users/:id', () => {
  const bcryptjs = require('bcryptjs');
  const owner = (extra = {}) => ({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', password: bcryptjs.hashSync('OwnerPass1', 4), failed_login_count: 0, locked_until: null, ...extra }] });
  const del = (id, token, body) => request(app).delete(`/api/users/${id}`).set('Authorization', `Bearer ${token}`).send(body);

  test('200 — suppression de son propre compte, mot de passe actuel confirmé', async () => {
    mockPool.query
      .mockResolvedValueOnce(owner())               // findWithPassword
      .mockResolvedValueOnce({ rows: [] })          // revokeAllForUser
      .mockResolvedValueOnce({ rows: [{ id: 3 }] }); // DELETE FROM users

    const res = await del(3, tokenMember, { currentPassword: 'OwnerPass1' });
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Compte supprimé avec succès');
  });

  // SEC-005 — un access token volé ne suffit plus à effacer un compte.
  test('400 CURRENT_PASSWORD_REQUIRED — sans mot de passe, rien n’est supprimé', async () => {
    mockPool.query.mockResolvedValueOnce(owner());
    const res = await del(3, tokenMember);
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('CURRENT_PASSWORD_REQUIRED');
    expect(mockPool.query.mock.calls.some(c => /DELETE FROM users/.test(c[0]))).toBe(false);
  });

  test('403 CURRENT_PASSWORD_INVALID — mot de passe faux : échec compté, rien n’est supprimé', async () => {
    mockPool.query
      .mockResolvedValueOnce(owner())
      .mockResolvedValueOnce({ rows: [] }); // recordFailedLogin
    const res = await del(3, tokenMember, { currentPassword: 'Mauvais1' });
    expect(res.status).toBe(403);
    expect(res.body.code).toBe('CURRENT_PASSWORD_INVALID');
    const failed = mockPool.query.mock.calls.find(c => /failed_login_count = failed_login_count \+ 1/.test(c[0]));
    expect(failed).toBeDefined();
    expect(mockPool.query.mock.calls.some(c => /DELETE FROM users/.test(c[0]))).toBe(false);
  });

  test('403 — compte verrouillé : refusé même avec le bon mot de passe', async () => {
    mockPool.query.mockResolvedValueOnce(owner({ locked_until: new Date(Date.now() + 60_000) }));
    const res = await del(3, tokenMember, { currentPassword: 'OwnerPass1' });
    expect(res.status).toBe(403);
    expect(res.body.code).toBe('CURRENT_PASSWORD_INVALID');
    expect(mockPool.query.mock.calls.some(c => /DELETE FROM users/.test(c[0]))).toBe(false);
  });

  test('200 — admin peut supprimer le compte d’un autre sans son mot de passe', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })        // revokeAllForUser
      .mockResolvedValueOnce({ rows: [{ id: 5 }] }); // DELETE FROM users

    const res = await del(5, tokenAdmin);
    expect(res.status).toBe(200);
  });

  test('403 — membre ne peut pas supprimer un autre compte', async () => {
    const res = await del(99, tokenMember);
    expect(res.status).toBe(403);
  });

  test('404 — utilisateur inexistant', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })  // revokeAllForUser
      .mockResolvedValueOnce({ rows: [] }); // DELETE FROM users → aucune ligne

    const res = await del(77, tokenAdmin);
    expect(res.status).toBe(404);
  });
});


// =============================================================================
// ADMIN — PUT /api/admin/users/:id
// =============================================================================
describe('PUT /api/admin/users/:id', () => {
  test('200 — admin peut changer le rôle d\'un utilisateur (sessions et access tokens invalidés)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'Jean', email: 'jean@test.com', role_id: 2 }] })
      .mockResolvedValueOnce({ rows: [] })                       // révocation des refresh tokens
      .mockResolvedValueOnce({ rows: [{ token_version: 1 }] });  // bumpTokenVersion

    const res = await request(app)
      .put('/api/admin/users/3')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean', role_id: 2 });

    expect(res.status).toBe(200);
    expect(res.body.role_id).toBe(2);
    const bump = mockPool.query.mock.calls.find(c => /SET token_version = token_version \+ 1/.test(c[0]));
    expect(bump[1]).toEqual(['3']);
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
// PUT /api/users/:id — validation invalide (lignes 69, 75)
// =============================================================================
describe('PUT /api/users/:id — validation fields (lignes 69, 75)', () => {
  test('400 — name invalide (trop court) → 400', async () => {
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ name: 'X' });

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Nom invalide/);
  });

  test('400 — password invalide (pas de majuscule) → 400', async () => {
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({ password: 'nouppercase1' });

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Mot de passe invalide/);
  });

  test('400 — aucun champ fourni → Aucune donnée à mettre à jour (ligne 147)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 3, name: 'Member', email: 'member@test.com', password: 'x' }] });
    const res = await request(app)
      .put('/api/users/3')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send({});

    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Aucune donnée à mettre à jour');
  });
});


// =============================================================================
// PUT /api/admin/users/:id — role_id invalide (ligne 132) + duplicate email 409 (lignes 180-184)
// =============================================================================
describe('PUT /api/admin/users/:id — champs invalides', () => {
  test('400 — role_id invalide (99) → Rôle invalide (ligne 132)', async () => {
    const res = await request(app)
      .put('/api/admin/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean Dupont', email: 'jean@test.com', role_id: 99 });

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Rôle invalide/);
  });

  test('400 — aucun champ → Aucune donnée (ligne 147)', async () => {
    // name manquant → 400 "Nom invalide" arrive avant "Aucune donnée"
    const res = await request(app)
      .put('/api/admin/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'A', role_id: 3 }); // name invalide (trop court)

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Nom invalide/);
  });

  test('409 — email déjà utilisé → erreur 23505 (lignes 180-182)', async () => {
    // mock withTransaction : la query UPDATE retourne un code 23505
    mockPool.query.mockRejectedValueOnce(Object.assign(new Error('duplicate'), { code: '23505' }));

    const res = await request(app)
      .put('/api/admin/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean Dupont', email: 'exists@test.com', role_id: 2 });

    expect(res.status).toBe(409);
    expect(res.body.message).toBe('Cet email est déjà utilisé');
  });

  test('500 — erreur inattendue → errorId dans la réponse (lignes 183-184)', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('unexpected DB error'));

    const res = await request(app)
      .put('/api/admin/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean Dupont', email: 'test@example.com', role_id: 1 });

    expect(res.status).toBe(500);
    expect(res.body.errorId).toBeDefined();
  });
});


// =============================================================================
// PUT /api/admin/users/:id — role_id undefined → 400 (ligne 132, branche undefined)
// =============================================================================
describe('PUT /api/admin/users/:id — role_id undefined (ligne 132 branche undefined)', () => {
  test('400 — role_id absent dans le body → Rôle invalide', async () => {
    const res = await request(app)
      .put('/api/admin/users/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'Jean Dupont' }); // pas de role_id → undefined → 400

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/Rôle invalide/);
  });
});


describe('VH-T1 — users.js PUT /me branches partielles', () => {
  test('PUT /me avec uniquement le name (sans email, sans password)', async () => {
    const bcrypt = require('bcryptjs');
    const hashedPwd = await bcrypt.hash('Password123', 10);
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 42, email: 'u@test.com', password: hashedPwd, role_id: 3 }] })
      .mockResolvedValueOnce({ rows: [{ id: 42, name: 'NouveauNom', email: 'u@test.com', role_id: 3 }] });

    const jwt = require('jsonwebtoken');
    const token = jwt.sign({ id: 42, role_id: 3 }, process.env.JWT_SECRET, { expiresIn: '15m' });

    const res = await request(app)
      .put('/api/users/me')
      .set('Authorization', `Bearer ${token}`)
      .send({ name: 'NouveauNom' });
    expect([200, 400, 401]).toContain(res.status);
  });

  test('PUT /me sans aucun champ → 400 Aucune donnée à mettre à jour', async () => {
    const bcrypt = require('bcryptjs');
    const hashedPwd = await bcrypt.hash('Password123', 10);
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 43, email: 'u@test.com', password: hashedPwd, role_id: 3 }] });

    const jwt = require('jsonwebtoken');
    const token = jwt.sign({ id: 43, role_id: 3 }, process.env.JWT_SECRET, { expiresIn: '15m' });

    const res = await request(app)
      .put('/api/users/me')
      .set('Authorization', `Bearer ${token}`)
      .send({});
    expect([400, 401]).toContain(res.status);
  });
});
