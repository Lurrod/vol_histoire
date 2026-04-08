#!/usr/bin/env node
/**
 * Seed des comptes de test pour les E2E.
 * Crée les utilisateurs nécessaires s'ils n'existent pas déjà.
 *
 * Usage : node e2e/seed-test-users.js
 * Prérequis : backend/.env configuré + PostgreSQL accessible
 *
 * SÉCURITÉ : ce script crée un compte admin avec mot de passe trivial
 * (test@gmail.com / test). Refus catégorique en production pour éviter
 * un désastre catastrophique si quelqu'un l'exécute par mégarde sur le serveur.
 */

// Garde-fou : refuse l'exécution en production. Vérifie plusieurs signaux
// pour ne pas pouvoir être contourné par une simple variable d'env oubliée.
(function refuseInProduction() {
  const env = (process.env.NODE_ENV || '').toLowerCase();
  const isProd =
    env === 'production' ||
    env === 'prod' ||
    process.env.VOL_HISTOIRE_PROD === '1' ||
    /vol-histoire\.titouan-borde\.com/i.test(process.env.PUBLIC_URL || '') ||
    /vol-histoire\.titouan-borde\.com/i.test(process.env.SERVER_HOST || '');

  if (isProd) {
    console.error('');
    console.error('  ╔════════════════════════════════════════════════════════════╗');
    console.error('  ║  REFUS D\'EXÉCUTION                                         ║');
    console.error('  ║  seed-test-users.js NE DOIT JAMAIS tourner en production.  ║');
    console.error('  ║  Il créerait un compte admin avec un mot de passe trivial. ║');
    console.error('  ╚════════════════════════════════════════════════════════════╝');
    console.error('');
    console.error('  NODE_ENV    =', JSON.stringify(process.env.NODE_ENV));
    console.error('  Pour exécuter en local : NODE_ENV=test node e2e/seed-test-users.js');
    console.error('');
    process.exit(1);
  }

  // Si NODE_ENV n'est pas explicitement 'test', warn loud — les CI/local doivent
  // l'avoir défini. Empêche l'exécution silencieuse "par défaut".
  if (env !== 'test') {
    console.error('');
    console.error('  ⚠️  NODE_ENV doit être défini à "test" pour exécuter ce script.');
    console.error('     NODE_ENV actuel :', JSON.stringify(process.env.NODE_ENV));
    console.error('     Lancez : NODE_ENV=test node e2e/seed-test-users.js');
    console.error('');
    process.exit(1);
  }
})();

// dotenv optionnel : en CI les variables sont déjà injectées via l'env du job.
// En local, charge backend/.env si dotenv est disponible (via backend/node_modules).
try {
  require('dotenv').config({ path: require('path').join(__dirname, '../backend/.env') });
} catch {
  // dotenv non disponible — on suppose que les env vars sont déjà définies
}
// pg et bcryptjs sont résolus depuis backend/node_modules (pas de dépendance e2e dédiée)
const path = require('path');
const Module = require('module');
const backendNodeModules = path.join(__dirname, '../backend/node_modules');
Module.globalPaths.push(backendNodeModules);
const { Pool } = require(path.join(backendNodeModules, 'pg'));
const bcrypt = require(path.join(backendNodeModules, 'bcryptjs'));

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

const TEST_USERS = [
  { name: 'Admin',    email: 'test@gmail.com',                password: 'test',      role_id: 1 },
  { name: 'Titouan',  email: 'titouan.borde.47@gmail.com',    password: 'Titouan1.', role_id: 3 },
];

async function seed() {
  for (const user of TEST_USERS) {
    const exists = await pool.query('SELECT id FROM users WHERE email = $1', [user.email]);
    if (exists.rows.length > 0) {
      console.log(`  OK ${user.email} existe deja (id=${exists.rows[0].id})`);
      continue;
    }

    const hashed = await bcrypt.hash(user.password, 10);
    const result = await pool.query(
      'INSERT INTO users (name, email, password, role_id, email_verified) VALUES ($1, $2, $3, $4, true) RETURNING id',
      [user.name, user.email, hashed, user.role_id]
    );
    console.log(`  + ${user.email} cree (id=${result.rows[0].id}, role=${user.role_id})`);
  }
}

seed()
  .then(() => { console.log('Seed termine.'); process.exit(0); })
  .catch(err => { console.error('Erreur seed:', err.message); process.exit(1); })
  .finally(() => pool.end());
