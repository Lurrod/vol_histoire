'use strict';

/**
 * Intégration SQL — correctifs de sécurité du lot H1 sur une vraie base :
 * SEC-003 (identifiants hors plage, octet NUL : plus d'erreur PostgreSQL),
 * SEC-002 (corps invalides), SEC-008 (migrations 003 des jetons hachés et
 * 004 des codes à 6 chiffres),
 * LEGAL-011 (export des données personnelles).
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { Pool } = require('pg');
const request = require('supertest');
const { describeIt, airplaneId } = require('./helpers/it-db');
const { startItApp } = require('./helpers/it-app');

const IT_URL = process.env.IT_DATABASE_URL || '';
const MIGRATION_003 = path.join(__dirname, '../../migrations/003_jetons_haches.sql');
const MIGRATION_004 = path.join(__dirname, '../../migrations/004_codes_email.sql');
const sha256 = (value) => crypto.createHash('sha256').update(value).digest('hex');

describeIt('Intégration SQL — sécurité (lot H1)', () => {
  let ctx;
  let adminToken;
  let memberToken;
  let errorSpy;

  beforeAll(async () => {
    ctx = await startItApp('security');
    adminToken = await ctx.login('admin@it.local');
    memberToken = await ctx.login('member@it.local');
  }, 60000);

  beforeEach(() => {
    // Aucune de ces requêtes ne doit produire d'« Erreur non gérée ».
    errorSpy = jest.spyOn(require('../../logger'), 'error');
  });

  afterEach(() => {
    expect(errorSpy).not.toHaveBeenCalled();
    errorSpy.mockRestore();
  });

  afterAll(async () => {
    if (ctx) await ctx.stop();
  });

  const api = () => request(ctx.app);

  describe('SEC-003 — identifiants et recherche', () => {
    test.each([
      '/api/airplanes/2147483648',
      '/api/airplanes/99999999999999999999',
      '/api/airplanes/-1',
      '/api/airplanes/2147483648/lineage',
      '/api/airplanes/2147483648/related',
      '/api/airplanes/facets?generation=99999999999',
      '/api/airplanes?search=%00',
      '/api/airplanes?search=mirage%00',
      '/api/airplanes?country=%00',
    ])('GET %s → 400', async (url) => {
      const res = await api().get(url);
      expect(res.status).toBe(400);
    });

    test('borne int4 exacte : 404 propre', async () => {
      const res = await api().get('/api/airplanes/2147483647');
      expect(res.status).toBe(404);
    });

    test('recherche avec caractères de contrôle : nettoyée, résultats rendus', async () => {
      const res = await api().get('/api/airplanes?search=%09mira%0A');
      expect(res.status).toBe(200);
      expect(res.body.data.map((a) => a.name)).toEqual(expect.arrayContaining([expect.stringMatching(/Mirage/)]));
    });

    test('favoris, profils et administration hors plage → 400', async () => {
      const fav = await api().post('/api/favorites/2147483648').set('Authorization', `Bearer ${memberToken}`);
      expect(fav.status).toBe(400);
      const user = await api().get('/api/users/2147483648').set('Authorization', `Bearer ${adminToken}`);
      expect(user.status).toBe(400);
      const search = await api().get('/api/users?search=%00').set('Authorization', `Bearer ${adminToken}`);
      expect(search.status).toBe(400);
      const ok = await api().get('/api/users?search=it%09local').set('Authorization', `Bearer ${adminToken}`);
      expect(ok.status).toBe(200);
    });
  });

  describe('SEC-002 — corps de requête', () => {
    test('JSON mal formé → 400, corps trop gros → 413', async () => {
      const bad = await api().post('/api/login').set('Content-Type', 'application/json').send('{"email":');
      expect(bad.status).toBe(400);
      const big = await api().post('/api/contact').set('Content-Type', 'application/json')
        .send(JSON.stringify({ message: 'x'.repeat(150 * 1024) }));
      expect(big.status).toBe(413);
    });

    test('octet NUL dans un corps → 400 (PostgreSQL le refuserait)', async () => {
      const res = await api().post('/api/login').send({ email: 'admin@it.local\u0000', password: 'x' });
      expect(res.status).toBe(400);
    });
  });

  describe('LEGAL-011 — GET /api/users/me/export', () => {
    test('profil et favoris réels, sans hash ni jetons', async () => {
      const rafale = await airplaneId(ctx.pool, 'Rafale');
      const added = await api().post(`/api/favorites/${rafale}`).set('Authorization', `Bearer ${memberToken}`);
      expect([200, 201]).toContain(added.status);

      const res = await api().get('/api/users/me/export').set('Authorization', `Bearer ${memberToken}`);
      expect(res.status).toBe(200);
      expect(res.headers['cache-control']).toBe('no-store');
      const body = JSON.parse(res.text);
      const member = (await ctx.pool.query("SELECT id FROM users WHERE email = 'member@it.local'")).rows[0];
      expect(res.headers['content-disposition']).toBe(`attachment; filename="vol-histoire-donnees-${member.id}.json"`);
      expect(body.user).toMatchObject({ id: member.id, email: 'member@it.local', role: 'utilisateur', email_verified: true });
      expect(body.user).not.toHaveProperty('password');
      expect(body.user).not.toHaveProperty('token_version');
      expect(body.favorites).toEqual([{ airplane_id: rafale, name: 'Rafale', added_at: expect.any(String) }]);
      expect(body.consent).toBeNull();
      expect(res.text).not.toMatch(/\$2[aby]\$/); // aucun hash bcrypt
    });
  });
});

// Les migrations se jouent sur un schéma à part, à l'état d'avant (colonne
// `token` en clair) : 003 doit hacher sur place et être rejouable ; 004 (codes
// à 6 chiffres) ajoute le compteur d'essais, clôt les liens encore ouverts,
// est rejouable, et le code applicatif fonctionne sur la table obtenue.
describeIt('Intégration SQL — migrations 003_jetons_haches.sql et 004_codes_email.sql', () => {
  const SCHEMA = 'it_migration_003';
  let pool;

  beforeAll(async () => {
    const admin = new Pool({ connectionString: IT_URL, max: 1 });
    try {
      await admin.query(`DROP SCHEMA IF EXISTS ${SCHEMA} CASCADE`);
      await admin.query(`CREATE SCHEMA ${SCHEMA}`);
    } finally {
      await admin.end();
    }
    pool = new Pool({ connectionString: IT_URL, max: 2, options: `-c search_path=${SCHEMA}` });
    await pool.query(`
      CREATE TABLE users (id SERIAL PRIMARY KEY);
      CREATE TABLE email_tokens (
        id          SERIAL PRIMARY KEY,
        user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        token       VARCHAR(64) NOT NULL UNIQUE,
        type        VARCHAR(10) NOT NULL CHECK (type IN ('verify', 'reset', 'email')),
        new_email   VARCHAR(255) NULL,
        expires_at  TIMESTAMPTZ NOT NULL,
        used_at     TIMESTAMPTZ,
        created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
      CREATE INDEX idx_email_tokens_token ON email_tokens (token) WHERE used_at IS NULL;
      INSERT INTO users DEFAULT VALUES;
      INSERT INTO email_tokens (user_id, token, type, expires_at)
        VALUES (1, '${'b'.repeat(64)}', 'reset', NOW() + INTERVAL '15 minutes');
    `);
  }, 30000);

  afterAll(async () => {
    if (pool) {
      await pool.query(`DROP SCHEMA IF EXISTS ${SCHEMA} CASCADE`);
      await pool.end();
    }
  });

  test('003 : hache les jetons en place, rejouable, empreinte unique', async () => {
    const sql = fs.readFileSync(MIGRATION_003, 'utf8');
    await pool.query(sql);
    await pool.query(sql); // rejouable

    const columns = (await pool.query(
      `SELECT column_name FROM information_schema.columns
       WHERE table_schema = $1 AND table_name = 'email_tokens' ORDER BY column_name`, [SCHEMA]
    )).rows.map((r) => r.column_name);
    expect(columns).toContain('token_hash');
    expect(columns).not.toContain('token');

    const { rows } = await pool.query('SELECT token_hash FROM email_tokens');
    expect(rows).toEqual([{ token_hash: sha256('b'.repeat(64)) }]);

    // Le jeton antérieur reste ouvert jusqu'à la migration 004
    const open = await pool.query('SELECT user_id FROM email_tokens WHERE token_hash = $1 AND used_at IS NULL', [sha256('b'.repeat(64))]);
    expect(open.rows).toEqual([{ user_id: 1 }]);

    await expect(pool.query(
      "INSERT INTO email_tokens (user_id, token_hash, type, expires_at) VALUES (1, $1, 'verify', NOW())",
      [sha256('b'.repeat(64))]
    )).rejects.toThrow(/email_tokens_token_hash_key/);
    const index = await pool.query(
      "SELECT 1 FROM pg_indexes WHERE schemaname = $1 AND indexname = 'idx_email_tokens_token'", [SCHEMA]
    );
    expect(index.rowCount).toBe(0);
  });

  test('004 : compteur d\'essais à 0, liens ouverts clos, rejouable', async () => {
    const sql = fs.readFileSync(MIGRATION_004, 'utf8');
    await pool.query(sql);
    await pool.query(sql); // rejouable

    const column = (await pool.query(
      `SELECT data_type, is_nullable, column_default FROM information_schema.columns
       WHERE table_schema = $1 AND table_name = 'email_tokens' AND column_name = 'attempts'`, [SCHEMA]
    )).rows[0];
    expect(column).toEqual({ data_type: 'smallint', is_nullable: 'NO', column_default: '0' });

    const { rows } = await pool.query('SELECT attempts, used_at FROM email_tokens');
    expect(rows).toHaveLength(1);
    expect(rows[0].attempts).toBe(0);
    expect(rows[0].used_at).not.toBeNull();
  });

  test('004 : le dépôt des codes fonctionne sur la table migrée', async () => {
    const emailTokensRepo = require('../../repositories/email-tokens');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);
    await emailTokensRepo.replaceOpen(pool, { userId: 1, type: 'reset', code: '042042', expiresAt });
    // L'ancienne ligne du même compte et du même type a disparu
    expect((await pool.query("SELECT COUNT(*)::int AS n FROM email_tokens WHERE type = 'reset'")).rows[0].n).toBe(1);

    expect(await emailTokensRepo.checkCode(pool, { userId: 1, type: 'reset', code: '000000' })).toEqual({ ok: false });
    expect((await pool.query("SELECT attempts FROM email_tokens WHERE type = 'reset'")).rows[0].attempts).toBe(1);
    expect(await emailTokensRepo.checkCode(pool, { userId: 1, type: 'reset', code: '042042', consume: true }))
      .toEqual({ ok: true, new_email: null });
    expect(await emailTokensRepo.checkCode(pool, { userId: 1, type: 'reset', code: '042042' })).toEqual({ ok: false });
  });
});
