'use strict';

/**
 * Intégration SQL — comptes et sessions : routes/auth.js, routes/users.js,
 * routes/favorites.js, middleware/auth.js (refresh tokens, token_version).
 */

const crypto = require('crypto');
const request = require('supertest');
const { describeIt, airplaneId, IT_PASSWORD } = require('./helpers/it-db');
const { startItApp } = require('./helpers/it-app');

// Les routes d'inscription, de renvoi et d'oubli répondent AVANT de travailler
// (anti-énumération) : on attend que la base reflète le travail.
async function waitFor(fn, { timeoutMs = 5000, stepMs = 25 } = {}) {
  const end = Date.now() + timeoutMs;
  for (;;) {
    const value = await fn();
    if (value) return value;
    if (Date.now() > end) throw new Error('Condition non atteinte dans le délai');
    await new Promise((r) => setTimeout(r, stepMs));
  }
}

function refreshCookie(res) {
  const raw = (res.headers['set-cookie'] || []).find((c) => c.startsWith('refreshToken='));
  if (!raw) throw new Error('Pas de cookie refreshToken');
  return raw.split(';')[0];
}

describeIt('Intégration SQL — comptes et sessions', () => {
  let ctx;
  let adminToken;

  beforeAll(async () => {
    ctx = await startItApp('accounts');
    adminToken = await ctx.login('admin@it.local');
  }, 60000);

  afterAll(async () => {
    if (ctx) await ctx.stop();
  });

  const api = () => request(ctx.app);
  const userByEmail = async (email) =>
    (await ctx.pool.query('SELECT * FROM users WHERE email = $1', [email])).rows[0];
  const sha256 = (value) => crypto.createHash('sha256').update(value).digest('hex');
  // La base ne garde que l'empreinte du jeton (SEC-008) : le jeton en clair se
  // retrouve dans les emails simulés, et doit correspondre à l'empreinte.
  const mailedTokens = () => [
    ctx.mailer.sendVerificationEmail,
    ctx.mailer.sendPasswordResetEmail,
    ctx.mailer.sendEmailChangeConfirmation,
  ].flatMap((fn) => fn.mock.calls.map((args) => args[2]));
  const openToken = async (userId, type) => {
    const row = (await ctx.pool.query(
      'SELECT token_hash, new_email FROM email_tokens WHERE user_id = $1 AND type = $2 AND used_at IS NULL',
      [userId, type]
    )).rows[0];
    if (!row) return undefined;
    const token = mailedTokens().find((t) => typeof t === 'string' && sha256(t) === row.token_hash);
    // L'email part après l'écriture en base : on attend qu'il soit « envoyé ».
    return token ? { ...row, token } : undefined;
  };

  describe('inscription → vérification → connexion', () => {
    const email = 'nouveau@it.local';
    const newPassword = 'Nouveau123';

    test('register crée le compte et un jeton de vérification', async () => {
      const res = await api().post('/api/register').send({ name: 'Nouveau IT', email: 'Nouveau@IT.local', password: 'Inscrit123' });
      expect(res.status).toBe(201);
      const user = await waitFor(() => userByEmail(email));
      expect(user.email_verified).toBe(false);
      expect(user.role_id).toBe(3);
      const open = await waitFor(() => openToken(user.id, 'verify'));
      expect(ctx.mailer.sendVerificationEmail).toHaveBeenCalledWith(email, 'Nouveau IT', expect.stringMatching(/^[a-f0-9]{64}$/));
      // SEC-008 : seule l'empreinte est en base, jamais le jeton envoyé.
      expect(open.token_hash).toBe(sha256(open.token));
      expect(open.token_hash).not.toBe(open.token);
      const plain = await ctx.pool.query('SELECT 1 FROM email_tokens WHERE token_hash = $1', [open.token]);
      expect(plain.rowCount).toBe(0);
    });

    test('register à nouveau sur un compte non vérifié : nouveau jeton, l\'ancien est clos', async () => {
      const user = await userByEmail(email);
      const first = await openToken(user.id, 'verify');
      const res = await api().post('/api/register').send({ name: 'Nouveau Bis', email, password: 'Inscrit123' });
      expect(res.status).toBe(201);
      const second = await waitFor(async () => {
        const t = await openToken(user.id, 'verify');
        return t && t.token !== first.token ? t : null;
      });
      expect(second.token).not.toBe(first.token);
      expect((await userByEmail(email)).name).toBe('Nouveau Bis');
    });

    test('resend-verification remplace le jeton ouvert', async () => {
      const user = await userByEmail(email);
      const before = await openToken(user.id, 'verify');
      const res = await api().post('/api/auth/resend-verification').send({ email });
      expect(res.status).toBe(200);
      await waitFor(async () => {
        const t = await openToken(user.id, 'verify');
        return t && t.token !== before.token;
      });
    });

    test('connexion refusée tant que l\'email n\'est pas vérifié', async () => {
      const res = await api().post('/api/login').send({ email, password: 'Inscrit123' });
      expect(res.status).toBe(403);
      expect(res.body.code).toBe('EMAIL_NOT_VERIFIED');
    });

    test('verify-email active le compte avec le mot de passe choisi à la vérification', async () => {
      const user = await userByEmail(email);
      const { token } = await openToken(user.id, 'verify');
      const res = await api().post('/api/auth/verify-email').send({ token, password: newPassword });
      expect(res.status).toBe(200);
      const after = await userByEmail(email);
      expect(after.email_verified).toBe(true);
      expect(after.token_version).toBe(user.token_version + 1);
      // Jeton à usage unique
      const replay = await api().post('/api/auth/verify-email').send({ token, password: newPassword });
      expect(replay.status).toBe(400);
      // Le mot de passe de l'inscription n'est pas celui qui est activé
      const old = await api().post('/api/login').send({ email, password: 'Inscrit123' });
      expect(old.status).toBe(400);
      const ok = await api().post('/api/login').send({ email, password: newPassword });
      expect(ok.status).toBe(200);
    });
  });

  describe('refresh tokens', () => {
    test('rotation, puis rejeu de l\'ancien jeton → toutes les sessions révoquées', async () => {
      const login = await api().post('/api/login').send({ email: 'member@it.local', password: IT_PASSWORD });
      expect(login.status).toBe(200);
      const first = refreshCookie(login);

      const rotated = await api().post('/api/refresh').set('Cookie', first);
      expect(rotated.status).toBe(200);
      expect(rotated.body.token).toEqual(expect.any(String));
      const second = refreshCookie(rotated);

      const replay = await api().post('/api/refresh').set('Cookie', first);
      expect(replay.status).toBe(401);
      expect(replay.body.code).toBe('REFRESH_REPLAY');

      const member = await userByEmail('member@it.local');
      const { rows } = await ctx.pool.query(
        'SELECT COUNT(*)::int AS n FROM refresh_tokens WHERE user_id = $1 AND revoked = FALSE', [member.id]
      );
      expect(rows[0].n).toBe(0);
      const afterReplay = await api().post('/api/refresh').set('Cookie', second);
      expect(afterReplay.status).toBe(401);
    });

    test('logout révoque le refresh token en base', async () => {
      const login = await api().post('/api/login').send({ email: 'editor@it.local', password: IT_PASSWORD });
      const cookie = refreshCookie(login);
      const out = await api().post('/api/logout').set('Cookie', cookie);
      expect(out.status).toBe(200);
      const again = await api().post('/api/refresh').set('Cookie', cookie);
      expect(again.status).toBe(401);
      expect(again.body.code).toBe('REFRESH_REVOKED');
    });

    test('nettoyage des jetons expirés et des comptes non vérifiés', async () => {
      const auth = require('../../middleware/auth');
      await expect(auth.cleanupExpiredTokens()).resolves.toBeUndefined();
      await ctx.pool.query(
        "INSERT INTO users (name, email, password, created_at) VALUES ('Vieux', 'vieux@it.local', 'x', NOW() - INTERVAL '8 days')"
      );
      await expect(auth.cleanupUnverifiedUsers()).resolves.toBeGreaterThanOrEqual(1);
      expect(await userByEmail('vieux@it.local')).toBeUndefined();
    });
  });

  describe('verrouillage du login', () => {
    test('10 échecs comptés en SQL verrouillent le compte', async () => {
      const email = 'lock@it.local';
      const hash = (await userByEmail('member@it.local')).password;
      await ctx.pool.query(
        "INSERT INTO users (name, email, password, email_verified) VALUES ('Lock', $1, $2, TRUE)", [email, hash]
      );
      await Promise.all(Array.from({ length: 10 }, () =>
        api().post('/api/login').send({ email, password: 'Mauvais123' })
      ));
      const user = await userByEmail(email);
      expect(user.failed_login_count).toBe(10);
      expect(new Date(user.locked_until).getTime()).toBeGreaterThan(Date.now());
      const blocked = await api().post('/api/login').send({ email, password: IT_PASSWORD });
      expect(blocked.status).toBe(400);
    });

    test('une connexion réussie remet le compteur à zéro', async () => {
      const email = 'reset-count@it.local';
      const hash = (await userByEmail('member@it.local')).password;
      await ctx.pool.query(
        "INSERT INTO users (name, email, password, email_verified, failed_login_count) VALUES ('Compteur', $1, $2, TRUE, 3)",
        [email, hash]
      );
      const ok = await api().post('/api/login').send({ email, password: IT_PASSWORD });
      expect(ok.status).toBe(200);
      expect((await userByEmail(email)).failed_login_count).toBe(0);
    });
  });

  describe('mot de passe oublié', () => {
    test('forgot-password → reset-password → connexion avec le nouveau mot de passe', async () => {
      const email = 'oubli@it.local';
      const hash = (await userByEmail('member@it.local')).password;
      const { rows } = await ctx.pool.query(
        "INSERT INTO users (name, email, password, email_verified) VALUES ('Oubli', $1, $2, TRUE) RETURNING id",
        [email, hash]
      );
      const userId = rows[0].id;
      const res = await api().post('/api/auth/forgot-password').send({ email });
      expect(res.status).toBe(200);
      const { token } = await waitFor(() => openToken(userId, 'reset'));

      const reset = await api().post('/api/auth/reset-password').send({ token, password: 'Change123' });
      expect(reset.status).toBe(200);
      const reuse = await api().post('/api/auth/reset-password').send({ token, password: 'Change456' });
      expect(reuse.status).toBe(400);
      expect((await api().post('/api/login').send({ email, password: 'Change123' })).status).toBe(200);
    });
  });

  describe('utilisateurs', () => {
    test('GET /api/users — liste paginée et recherche ILIKE (admin)', async () => {
      const all = await api().get('/api/users?limit=2').set('Authorization', `Bearer ${adminToken}`);
      expect(all.status).toBe(200);
      expect(all.body.data).toHaveLength(2);
      expect(all.body.meta.total).toBeGreaterThanOrEqual(3);
      const found = await api().get('/api/users').query({ search: 'editor@' }).set('Authorization', `Bearer ${adminToken}`);
      expect(found.body.data.map((u) => u.email)).toEqual(['editor@it.local']);
    });

    test('GET /api/users/:id — son propre profil', async () => {
      const token = await ctx.login('editor@it.local');
      const me = await userByEmail('editor@it.local');
      const res = await api().get(`/api/users/${me.id}`).set('Authorization', `Bearer ${token}`);
      expect(res.status).toBe(200);
      expect(res.body).toEqual({ id: me.id, name: 'Editeur IT', email: 'editor@it.local', role_id: 2 });
    });

    test('PUT /api/users/:id — mot de passe : sessions coupées, nouvelle session ouverte', async () => {
      const email = 'profil@it.local';
      const hash = (await userByEmail('member@it.local')).password;
      await ctx.pool.query("INSERT INTO users (name, email, password, email_verified) VALUES ('Profil', $1, $2, TRUE)", [email, hash]);
      const token = await ctx.login(email);
      const me = await userByEmail(email);

      const res = await api().put(`/api/users/${me.id}`).set('Authorization', `Bearer ${token}`)
        .send({ name: 'Profil Renommé', password: 'Profil123', currentPassword: IT_PASSWORD });
      expect(res.status).toBe(200);
      expect(res.body.user.name).toBe('Profil Renommé');
      expect(res.body.token).toEqual(expect.any(String));
      const after = await userByEmail(email);
      expect(after.token_version).toBe(me.token_version + 1);
      // L'ancien access token est refusé (token_version comparé en base)
      const stale = await api().get(`/api/users/${me.id}`).set('Authorization', `Bearer ${token}`);
      expect(stale.status).toBe(401);
      const fresh = await api().get(`/api/users/${me.id}`).set('Authorization', `Bearer ${res.body.token}`);
      expect(fresh.status).toBe(200);
    });

    test('PUT /api/users/:id — changement d\'email confirmé par lien', async () => {
      const email = 'ancien@it.local';
      const hash = (await userByEmail('member@it.local')).password;
      await ctx.pool.query("INSERT INTO users (name, email, password, email_verified) VALUES ('Ancien', $1, $2, TRUE)", [email, hash]);
      const token = await ctx.login(email);
      const me = await userByEmail(email);

      const res = await api().put(`/api/users/${me.id}`).set('Authorization', `Bearer ${token}`)
        .send({ email: 'Nouvelle@IT.local', currentPassword: IT_PASSWORD });
      expect(res.status).toBe(200);
      expect(res.body.emailChangePending).toBe(true);
      const pending = await openToken(me.id, 'email');
      expect(pending.new_email).toBe('nouvelle@it.local');

      const confirm = await api().post('/api/auth/confirm-email-change').send({ token: pending.token });
      expect(confirm.status).toBe(200);
      expect((await ctx.pool.query('SELECT email FROM users WHERE id = $1', [me.id])).rows[0].email).toBe('nouvelle@it.local');
    });

    test('confirm-email-change : adresse prise entre-temps → 409', async () => {
      const hash = (await userByEmail('member@it.local')).password;
      const { rows } = await ctx.pool.query(
        "INSERT INTO users (name, email, password, email_verified) VALUES ('Course', 'course@it.local', $1, TRUE) RETURNING id", [hash]
      );
      await ctx.pool.query(
        "INSERT INTO email_tokens (user_id, token_hash, type, expires_at, new_email) VALUES ($1, $2, 'email', NOW() + INTERVAL '1 hour', 'editor@it.local')",
        [rows[0].id, sha256('c'.repeat(64))]
      );
      const res = await api().post('/api/auth/confirm-email-change').send({ token: 'c'.repeat(64) });
      expect(res.status).toBe(409);
      expect(res.body.code).toBe('EMAIL_TAKEN');
    });

    test('PUT /api/admin/users/:id — rôle changé, sessions révoquées, email en double → 409', async () => {
      const target = await userByEmail('member@it.local');
      const res = await api().put(`/api/admin/users/${target.id}`).set('Authorization', `Bearer ${adminToken}`)
        .send({ name: 'Membre IT', role_id: 2 });
      expect(res.status).toBe(200);
      expect(res.body.role_id).toBe(2);
      expect((await userByEmail('member@it.local')).token_version).toBe(target.token_version + 1);

      const back = await api().put(`/api/admin/users/${target.id}`).set('Authorization', `Bearer ${adminToken}`)
        .send({ name: 'Membre IT', role_id: 3 });
      expect(back.status).toBe(200);

      const dup = await api().put(`/api/admin/users/${target.id}`).set('Authorization', `Bearer ${adminToken}`)
        .send({ name: 'Membre IT', email: 'editor@it.local', role_id: 3 });
      expect(dup.status).toBe(409);

      const missing = await api().put('/api/admin/users/999999').set('Authorization', `Bearer ${adminToken}`)
        .send({ name: 'Personne', role_id: 3 });
      expect(missing.status).toBe(404);
    });

    test('DELETE /api/users/:id — compte supprimé, favoris en cascade', async () => {
      const hash = (await userByEmail('editor@it.local')).password;
      const { rows } = await ctx.pool.query(
        "INSERT INTO users (name, email, password, email_verified) VALUES ('Partant', 'partant@it.local', $1, TRUE) RETURNING id", [hash]
      );
      const id = rows[0].id;
      const rafale = await airplaneId(ctx.pool, 'Rafale');
      await ctx.pool.query('INSERT INTO favorites (user_id, airplane_id) VALUES ($1, $2)', [id, rafale]);
      const token = await ctx.login('partant@it.local');
      const res = await api().delete(`/api/users/${id}`).set('Authorization', `Bearer ${token}`);
      expect(res.status).toBe(200);
      const fav = await ctx.pool.query('SELECT 1 FROM favorites WHERE user_id = $1', [id]);
      expect(fav.rows).toHaveLength(0);
      const again = await api().delete(`/api/users/${id}`).set('Authorization', `Bearer ${adminToken}`);
      expect(again.status).toBe(404);
    });
  });

  describe('favoris', () => {
    test('ajout, doublon ignoré, liste, statut, retrait', async () => {
      const token = await ctx.login('editor@it.local');
      const rafale = await airplaneId(ctx.pool, 'Rafale');
      const mirage = await airplaneId(ctx.pool, 'Mirage 2000');
      const auth = { Authorization: `Bearer ${token}` };

      expect((await api().post(`/api/favorites/${rafale}`).set(auth)).status).toBe(201);
      expect((await api().post(`/api/favorites/${rafale}`).set(auth)).status).toBe(201); // ON CONFLICT DO NOTHING
      expect((await api().post(`/api/favorites/${mirage}`).set(auth)).status).toBe(201);

      const list = await api().get('/api/favorites').set(auth);
      expect(list.status).toBe(200);
      expect(list.body.map((a) => a.name).sort()).toEqual(['Mirage 2000', 'Rafale']);
      expect(list.body[0]).toEqual(expect.objectContaining({ country_code: 'FRA', favorited_at: expect.any(String) }));

      const flag = await api().get(`/api/airplanes/${rafale}/favorite`).set(auth);
      expect(flag.body.isFavorite).toBe(true);

      expect((await api().delete(`/api/favorites/${rafale}`).set(auth)).status).toBe(200);
      expect((await api().delete(`/api/favorites/${rafale}`).set(auth)).status).toBe(404);
    });

    test('appareil inexistant : violation de clé étrangère → 404', async () => {
      const token = await ctx.login('editor@it.local');
      const res = await api().post('/api/favorites/999999').set('Authorization', `Bearer ${token}`);
      expect(res.status).toBe(404);
      expect(res.body.message).toBe('Avion introuvable');
    });
  });
});
