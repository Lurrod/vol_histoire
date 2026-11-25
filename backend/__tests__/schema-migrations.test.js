/**
 * Suivi des migrations (DEVOPS-003).
 */
const fs = require('fs');
const path = require('path');
const { REQUIRED_MIGRATIONS, missingMigrations, checkSchema } = require('../utils/schema-migrations');

const pool = (impl) => ({ query: jest.fn(impl) });
const logger = { error: jest.fn(), warn: jest.fn() };

test('la liste requise correspond aux scripts de backend/migrations/', () => {
  const files = fs.readdirSync(path.join(__dirname, '../migrations'))
    .filter((f) => /^\d{3}_.+\.sql$/.test(f)).map((f) => f.replace(/\.sql$/, '')).sort();
  expect([...REQUIRED_MIGRATIONS]).toEqual(files);
});

test('chaque script après 004 s’inscrit dans schema_migrations', () => {
  REQUIRED_MIGRATIONS.filter((n) => n >= '005').forEach((name) => {
    const sql = fs.readFileSync(path.join(__dirname, '../migrations', `${name}.sql`), 'utf8');
    const insert = sql.slice(sql.indexOf('INSERT INTO schema_migrations'));
    expect(insert).toContain(`('${name}')`);
  });
});

test('db.sql inscrit toutes les migrations (installation neuve à jour)', () => {
  const sql = fs.readFileSync(path.join(__dirname, '../db_backup/db.sql'), 'utf8');
  REQUIRED_MIGRATIONS.forEach((name) => expect(sql).toContain(`('${name}')`));
});

test('missingMigrations : manquantes, toutes si la table est absente', async () => {
  expect(await missingMigrations(pool(async () => ({ rows: REQUIRED_MIGRATIONS.map((name) => ({ name })) })))).toEqual([]);
  expect(await missingMigrations(pool(async () => ({ rows: [{ name: '001_mise_a_niveau' }] })))).toEqual(REQUIRED_MIGRATIONS.slice(1));
  const absent = Object.assign(new Error('relation "schema_migrations" does not exist'), { code: '42P01' });
  expect(await missingMigrations(pool(async () => { throw absent; }))).toEqual([...REQUIRED_MIGRATIONS]);
  await expect(missingMigrations(pool(async () => { throw new Error('réseau'); }))).rejects.toThrow('réseau');
});

test('checkSchema : production → démarrage refusé ; ailleurs → avertissement', async () => {
  const none = pool(async () => ({ rows: [] }));
  await expect(checkSchema(none, { env: { NODE_ENV: 'production' }, logger })).rejects.toThrow(/Migrations non jouées/);
  expect(logger.error).toHaveBeenCalled();
  await expect(checkSchema(none, { env: { NODE_ENV: 'development' }, logger })).resolves.toHaveLength(REQUIRED_MIGRATIONS.length);
  expect(logger.warn).toHaveBeenCalled();
  const all = pool(async () => ({ rows: REQUIRED_MIGRATIONS.map((name) => ({ name })) }));
  await expect(checkSchema(all, { env: { NODE_ENV: 'production' }, logger })).resolves.toEqual([]);
});
