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

// Mot de passe commun aux comptes de peuplement (respecte isValidPassword :
// 8-128 chars, ≥1 maj, ≥1 min, ≥1 chiffre). Trivial volontairement — test only.
const FILLER_PASSWORD = 'Testuser1';

const FILLER_USERS = [
  { name: 'Alice Martin',      email: 'alice.martin@test.local',      role_id: 3 },
  { name: 'Bob Durand',        email: 'bob.durand@test.local',        role_id: 3 },
  { name: 'Clara Dubois',      email: 'clara.dubois@test.local',      role_id: 3 },
  { name: 'David Laurent',     email: 'david.laurent@test.local',     role_id: 3 },
  { name: 'Emma Moreau',       email: 'emma.moreau@test.local',       role_id: 3 },
  { name: 'François Petit',    email: 'francois.petit@test.local',    role_id: 2 },
  { name: 'Gabriel Leroy',     email: 'gabriel.leroy@test.local',     role_id: 3 },
  { name: 'Hélène Roux',       email: 'helene.roux@test.local',       role_id: 3 },
  { name: 'Isabelle Girard',   email: 'isabelle.girard@test.local',   role_id: 3 },
  { name: 'Julien Bonnet',     email: 'julien.bonnet@test.local',     role_id: 2 },
  { name: 'Karine Fontaine',   email: 'karine.fontaine@test.local',   role_id: 3 },
  { name: 'Louis Chevalier',   email: 'louis.chevalier@test.local',   role_id: 3 },
  { name: 'Marie Lambert',     email: 'marie.lambert@test.local',     role_id: 3 },
  { name: 'Nicolas Mercier',   email: 'nicolas.mercier@test.local',   role_id: 3 },
  { name: 'Océane Blanc',      email: 'oceane.blanc@test.local',      role_id: 3 },
  { name: 'Paul Rousseau',     email: 'paul.rousseau@test.local',     role_id: 2 },
  { name: 'Quentin Vincent',   email: 'quentin.vincent@test.local',   role_id: 3 },
  { name: 'Raphaëlle Morel',   email: 'raphaelle.morel@test.local',   role_id: 3 },
  { name: 'Sébastien Garnier', email: 'sebastien.garnier@test.local', role_id: 3 },
  { name: 'Thomas Faure',      email: 'thomas.faure@test.local',      role_id: 3 },
  { name: 'Ursula Noel',       email: 'ursula.noel@test.local',       role_id: 3 },
  { name: 'Victor Perrin',     email: 'victor.perrin@test.local',     role_id: 3 },
  { name: 'Wendy Lemoine',     email: 'wendy.lemoine@test.local',     role_id: 3 },
  { name: 'Xavier Robin',      email: 'xavier.robin@test.local',      role_id: 3 },
  { name: 'Yasmine Clement',   email: 'yasmine.clement@test.local',   role_id: 2 },
  { name: 'Zoé Bernard',       email: 'zoe.bernard@test.local',       role_id: 3 },
];

const TEST_USERS = [
  { name: 'Admin',    email: 'test@gmail.com',                password: 'test',      role_id: 1 },
  { name: 'Titouan',  email: 'titouan.borde.47@gmail.com',    password: 'Titouan1.', role_id: 3 },
  ...FILLER_USERS.map(u => ({ ...u, password: FILLER_PASSWORD })),
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
