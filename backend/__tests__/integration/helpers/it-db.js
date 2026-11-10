'use strict';

// -----------------------------------------------------------------------------
// Base d'intégration : vraie base PostgreSQL, schéma neuf par fichier de test.
//
// Activée par IT_DATABASE_URL (ex. postgres://vol_user:***@localhost:5432/vol_histoire_it).
// Sans elle, les suites d'intégration sont sautées et `npm test` reste vert sur
// une machine sans PostgreSQL.
//
// Chaque fichier de test reçoit son propre schéma (`it_<suite>`), recréé à
// chaque exécution et désigné par search_path : les fichiers peuvent tourner en
// parallèle sans se marcher dessus, et la base n'accumule aucun état d'une
// exécution à l'autre.
//
// Garde-fou : la base visée doit se terminer par `_it`. `vol_histoire` (dev) et
// `vol_histoire_test` (E2E) ne peuvent donc jamais être touchées par erreur.
// -----------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

const IT_URL = process.env.IT_DATABASE_URL || '';
const DB_BACKUP = path.join(__dirname, '../../../db_backup');

// Petit jeu de fiches : la lignée Dassault complète (Ouragan → Rafale, 7 maillons,
// pour la filiation), des rivaux soviétiques et américains (conflits, missions,
// rivalités croisées) et le MiG 1.44, premier vol le 29/02/2000 (éphéméride).
// Ordre alphabétique, comme une installation réelle.
const FIXTURE_FILES = [
  'f15_eagle.sql',
  'f16_fighting_falcon.sql',
  'mig144.sql',
  'mig_21.sql',
  'mig_29.sql',
  'mirage_2000.sql',
  'mirage_3.sql',
  'mirage_f1.sql',
  'mystere_4.sql',
  'ouragan.sql',
  'rafale.sql',
  'su_27.sql',
  'super_mystere_b2.sql',
];

// Comptes créés directement en base (coût bcrypt bas : seul le hash compte).
const IT_PASSWORD = 'Password123';
const IT_USERS = [
  { name: 'Admin IT', email: 'admin@it.local', role_id: 1 },
  { name: 'Editeur IT', email: 'editor@it.local', role_id: 2 },
  { name: 'Membre IT', email: 'member@it.local', role_id: 3 },
];

function databaseName(url) {
  try {
    return decodeURIComponent(new URL(url).pathname.replace(/^\//, ''));
  } catch {
    return '';
  }
}

const IT_ENABLED = Boolean(IT_URL) && /_it$/.test(databaseName(IT_URL));

if (IT_URL && !IT_ENABLED) {
  throw new Error(`IT_DATABASE_URL doit viser une base dont le nom finit par "_it" (reçu : "${databaseName(IT_URL)}")`);
}

/**
 * `describe` si la base d'intégration est configurée, sinon un bloc sauté dont
 * le titre explique pourquoi.
 */
function describeIt(title, fn) {
  if (IT_ENABLED) return describe(title, fn);
  return describe.skip(`${title} — sauté : IT_DATABASE_URL absent (voir __tests__/integration/helpers/it-db.js)`, () => {
    test('nécessite une base PostgreSQL', () => {});
  });
}

// Les GRANT de db.sql visent la base de production (`vol_histoire`) et le rôle
// `vol_user` : ils échoueraient sur une autre base ou un autre rôle et, envoyés
// en un seul lot, interrompraient tout le chargement. Ils ne servent à rien ici.
function stripGrants(sql) {
  return sql.replace(/^\s*GRANT\b[^;]*;\s*$/gim, '');
}

function readSql(file) {
  return fs.readFileSync(path.join(DB_BACKUP, file), 'utf8');
}

/**
 * Crée un pool limité au schéma `it_<suite>`, recrée ce schéma et y charge
 * db.sql, les fiches, zz_backfill_relations.sql, la frise et les comptes.
 * @param {string} suite identifiant court ([a-z_]+)
 * @returns {Promise<import('pg').Pool>}
 */
async function setupItDatabase(suite) {
  if (!/^[a-z_]+$/.test(suite)) throw new Error(`Nom de suite invalide : ${suite}`);
  const schema = `it_${suite}`;

  const admin = new Pool({ connectionString: IT_URL, max: 1 });
  try {
    await admin.query(`DROP SCHEMA IF EXISTS ${schema} CASCADE`);
    await admin.query(`CREATE SCHEMA ${schema}`);
  } finally {
    await admin.end();
  }

  const pool = new Pool({ connectionString: IT_URL, max: 5, options: `-c search_path=${schema}` });

  await pool.query(stripGrants(readSql('db.sql')));
  for (const file of FIXTURE_FILES) {
    await pool.query(readSql(file));
  }
  await pool.query(readSql('zz_backfill_relations.sql'));
  await pool.query(stripGrants(readSql('timeline_events.sql')));

  const hash = await bcrypt.hash(IT_PASSWORD, 4);
  for (const u of IT_USERS) {
    await pool.query(
      'INSERT INTO users (name, email, password, role_id, email_verified) VALUES ($1, $2, $3, $4, TRUE)',
      [u.name, u.email, hash, u.role_id]
    );
  }
  return pool;
}

/** Identifiant d'un appareil par son nom exact. */
async function airplaneId(pool, name) {
  const { rows } = await pool.query('SELECT id FROM airplanes WHERE name = $1', [name]);
  if (!rows[0]) throw new Error(`Appareil absent du jeu d'intégration : ${name}`);
  return rows[0].id;
}

module.exports = {
  IT_ENABLED,
  IT_PASSWORD,
  IT_USERS,
  FIXTURE_FILES,
  describeIt,
  setupItDatabase,
  airplaneId,
};
