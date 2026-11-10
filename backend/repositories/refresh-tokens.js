'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — refresh tokens (table refresh_tokens).
// La logique de session (états, rotation transactionnelle, rejeu) vit dans
// middleware/auth.js ; ce module ne fait qu'écrire et lire les lignes.
// -----------------------------------------------------------------------------

async function insert(db, jti, userId, expiresAt) {
  await db.query(
    'INSERT INTO refresh_tokens (jti, user_id, expires_at) VALUES ($1, $2, $3)',
    [jti, userId, expiresAt]
  );
}

/** @returns {Promise<{ user_id: number, revoked: boolean, rotated_at: Date|null, live: boolean }|null>} */
async function findState(db, jti) {
  const result = await db.query(
    'SELECT user_id, revoked, rotated_at, expires_at > NOW() AS live FROM refresh_tokens WHERE jti = $1',
    [jti]
  );
  return result.rows[0] || null;
}

async function revoke(db, jti) {
  await db.query(
    'UPDATE refresh_tokens SET revoked = TRUE WHERE jti = $1',
    [jti]
  );
}

/**
 * Révoque un jeton actif en le marquant comme remplacé par rotation.
 * @returns {Promise<number>} nombre de lignes touchées (0 : déjà révoqué ou absent)
 */
async function markRotated(db, jti) {
  const result = await db.query(
    'UPDATE refresh_tokens SET revoked = TRUE, rotated_at = NOW() WHERE jti = $1 AND revoked = FALSE',
    [jti]
  );
  return result.rowCount;
}

/** Révoque toutes les sessions actives d'un utilisateur. */
async function revokeAllForUser(db, userId) {
  await db.query(
    'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
    [userId]
  );
}

async function deleteExpired(db) {
  await db.query(
    'DELETE FROM refresh_tokens WHERE expires_at < NOW()'
  );
}

module.exports = { insert, findState, revoke, markRotated, revokeAllForUser, deleteExpired };
