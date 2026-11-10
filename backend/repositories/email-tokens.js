'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — jetons à usage unique envoyés par email (table
// email_tokens) : 'verify' (activation), 'reset' (mot de passe oublié),
// 'email' (changement d'adresse, porteur de new_email).
//
// Seule l'empreinte SHA-256 du jeton est stockée (colonne token_hash, SEC-008) :
// le jeton en clair ne vit que dans l'email. Une fuite de la table ou d'une
// sauvegarde ne permet donc plus de réinitialiser un mot de passe. Un SHA-256
// sans sel suffit : le jeton fait 256 bits aléatoires, rien à deviner par
// dictionnaire. Les appelants manipulent toujours le jeton en clair.
// -----------------------------------------------------------------------------

const crypto = require('crypto');

/**
 * Empreinte stockée d'un jeton : SHA-256 hexadécimal (64 caractères).
 * Identique à `encode(sha256(convert_to(token, 'UTF8')), 'hex')` côté SQL,
 * ce qu'utilise la migration 003 pour les jetons déjà en base.
 * @param {string} token
 * @returns {string}
 */
function hashToken(token) {
  return crypto.createHash('sha256').update(String(token), 'utf8').digest('hex');
}

/** Clôt les jetons encore ouverts d'un type donné pour un utilisateur. */
async function closeOpen(db, userId, type) {
  await db.query(
    'UPDATE email_tokens SET used_at = NOW() WHERE user_id = $1 AND type = $2 AND used_at IS NULL',
    [userId, type]
  );
}

/**
 * Remplace le jeton ouvert d'un type par un nouveau (clôture puis insertion).
 * À appeler dans une transaction (`db` = client) pour que les deux écritures
 * soient atomiques.
 */
async function replaceOpen(db, { userId, type, token, expiresAt, newEmail = null }) {
  await closeOpen(db, userId, type);
  await db.query(
    'INSERT INTO email_tokens (user_id, token_hash, type, expires_at, new_email) VALUES ($1, $2, $3, $4, $5)',
    [userId, hashToken(token), type, expiresAt, newEmail]
  );
}

/**
 * Consomme un jeton valide. Le UPDATE gardé par `used_at IS NULL` rend la
 * consommation atomique : deux requêtes concurrentes avec le même jeton ne
 * peuvent pas réussir toutes les deux.
 * @returns {Promise<{ user_id: number, new_email: string|null }|null>}
 */
async function consume(db, token, type) {
  const result = await db.query(
    `UPDATE email_tokens SET used_at = NOW()
     WHERE token_hash = $1 AND type = $2 AND used_at IS NULL AND expires_at > NOW()
     RETURNING user_id, new_email`,
    [hashToken(token), type]
  );
  return result.rows[0] || null;
}

/** Jeton de réinitialisation ouvert et non expiré. @returns {Promise<{ id: number, user_id: number }|null>} */
async function findOpenReset(db, token) {
  const result = await db.query(
    `SELECT id, user_id FROM email_tokens
     WHERE token_hash = $1 AND type = 'reset' AND used_at IS NULL AND expires_at > NOW()`,
    [hashToken(token)]
  );
  return result.rows[0] || null;
}

/** @returns {Promise<boolean>} false si le jeton a été consommé entre-temps */
async function markUsed(db, tokenId) {
  const result = await db.query(
    'UPDATE email_tokens SET used_at = NOW() WHERE id = $1 AND used_at IS NULL',
    [tokenId]
  );
  return result.rowCount !== 0;
}

module.exports = { hashToken, closeOpen, replaceOpen, consume, findOpenReset, markUsed };
