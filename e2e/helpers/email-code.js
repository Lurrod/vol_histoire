// e2e/helpers/email-code.js
// Les specs ne lisent pas les emails : une fois un code émis par le serveur
// (inscription, mot de passe oublié), on remplace son empreinte en base par
// celle d'un code connu, calculée avec la même fonction et la même clé
// (JWT_SECRET du backend). La base visée est celle du serveur de test :
// variables DB_* du processus Playwright, sinon backend/.env.
const path = require('path');

const backend = (p) => path.join(__dirname, '../../backend', p);
require(backend('node_modules/dotenv')).config({ path: backend('.env') });
const { Pool } = require(backend('node_modules/pg'));
const bcrypt = require(backend('node_modules/bcryptjs'));
const { hashCode } = require(backend('repositories/email-tokens'));

const KNOWN_CODE = '123456';

async function withPool(fn) {
  const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
  });
  try {
    return await fn(pool);
  } finally {
    await pool.end();
  }
}

/**
 * Attend le code ouvert d'un compte (il est émis après la réponse HTTP),
 * puis le remplace par KNOWN_CODE.
 */
async function setKnownCode(email, type, timeoutMs = 8000) {
  return withPool(async (pool) => {
    const deadline = Date.now() + timeoutMs;
    for (;;) {
      const found = await pool.query(
        `SELECT t.id, t.user_id FROM email_tokens t JOIN users u ON u.id = t.user_id
         WHERE u.email = $1 AND t.type = $2 AND t.used_at IS NULL
         ORDER BY t.id DESC LIMIT 1`,
        [email, type]
      );
      const row = found.rows[0];
      if (row) {
        await pool.query('UPDATE email_tokens SET token_hash = $1 WHERE id = $2',
          [hashCode(row.user_id, type, KNOWN_CODE), row.id]);
        return KNOWN_CODE;
      }
      if (Date.now() > deadline) throw new Error(`Aucun code ${type} émis pour ${email}`);
      await new Promise((r) => setTimeout(r, 200));
    }
  });
}

/** Compte activé, propre à une spec (mot de passe connu). */
async function createVerifiedUser(email, password, name = 'Pilote E2E') {
  const hashed = await bcrypt.hash(password, 10);
  await withPool((pool) => pool.query(
    'INSERT INTO users (name, email, password, role_id, email_verified) VALUES ($1, $2, $3, 3, true)',
    [name, email, hashed]
  ));
}

async function deleteUser(email) {
  await withPool((pool) => pool.query('DELETE FROM users WHERE email = $1', [email]));
}

module.exports = { KNOWN_CODE, setKnownCode, createVerifiedUser, deleteUser };
