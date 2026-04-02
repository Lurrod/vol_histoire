#!/usr/bin/env node
/**
 * Seed des comptes de test pour les E2E.
 * Crée les utilisateurs nécessaires s'ils n'existent pas déjà.
 *
 * Usage : node e2e/seed-test-users.js
 * Prérequis : backend/.env configuré + PostgreSQL accessible
 */

require('dotenv').config({ path: require('path').join(__dirname, '../backend/.env') });
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

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
