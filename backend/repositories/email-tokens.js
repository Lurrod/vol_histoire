'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — codes à usage unique envoyés par email (table
// email_tokens) : 'verify' (activation), 'reset' (mot de passe oublié),
// 'email' (changement d'adresse, porteur de new_email).
//
// Un code fait 6 chiffres : un million de valeurs. Trois protections le
// rendent sûr malgré sa brièveté :
//   - un seul code ouvert par compte et par type, valable quelques minutes ;
//   - MAX_ATTEMPTS essais manqués, puis le code est clos (colonne attempts) ;
//   - seule son empreinte HMAC est stockée, liée au compte et au type, avec
//     une clé dérivée de JWT_SECRET : une fuite de la table ne permet pas de
//     retrouver les codes par simple énumération des 10⁶ valeurs.
// Les limiteurs de débit des routes s'ajoutent à ces barrages.
// -----------------------------------------------------------------------------

const crypto = require('crypto');

const CODE_LENGTH = 6;
const MAX_ATTEMPTS = 5;

/** Clé HMAC des codes, dérivée du secret des jetons (aucune variable de plus). */
function codeKey() {
  const secret = process.env.JWT_SECRET;
  if (!secret) throw new Error('JWT_SECRET manquant : impossible de chiffrer les codes email');
  return crypto.createHmac('sha256', secret).update('vh-email-code').digest();
}

/** Code à 6 chiffres, zéros de tête compris (« 004217 »). */
function generateCode() {
  return String(crypto.randomInt(0, 10 ** CODE_LENGTH)).padStart(CODE_LENGTH, '0');
}

/** @returns {boolean} six chiffres exactement */
function isCodeFormat(code) {
  return typeof code === 'string' && /^[0-9]{6}$/.test(code);
}

/**
 * Empreinte stockée : HMAC-SHA256 hexadécimal (64 caractères), liée au compte
 * et au type pour qu'un même code n'ait pas la même empreinte ailleurs.
 */
function hashCode(userId, type, code) {
  return crypto.createHmac('sha256', codeKey()).update(`${type}:${userId}:${code}`).digest('hex');
}

/** Clôt les codes encore ouverts d'un type donné pour un utilisateur. */
async function closeOpen(db, userId, type) {
  await db.query(
    'UPDATE email_tokens SET used_at = NOW() WHERE user_id = $1 AND type = $2 AND used_at IS NULL',
    [userId, type]
  );
}

/**
 * Remplace les codes d'un type par un nouveau. Les anciennes lignes du même
 * compte et du même type sont supprimées, pas seulement closes : un code peut
 * revenir un jour à l'identique, et son empreinte heurterait la contrainte
 * UNIQUE de token_hash. À appeler dans une transaction (`db` = client).
 */
async function replaceOpen(db, { userId, type, code, expiresAt, newEmail = null }) {
  await db.query('DELETE FROM email_tokens WHERE user_id = $1 AND type = $2', [userId, type]);
  await db.query(
    'INSERT INTO email_tokens (user_id, token_hash, type, expires_at, new_email) VALUES ($1, $2, $3, $4, $5)',
    [userId, hashCode(userId, type, code), type, expiresAt, newEmail]
  );
}

function sameHash(a, b) {
  const left = Buffer.from(String(a), 'hex');
  const right = Buffer.from(String(b), 'hex');
  return left.length === right.length && crypto.timingSafeEqual(left, right);
}

/**
 * Vérifie un code. À appeler dans une transaction : la ligne est verrouillée
 * (FOR UPDATE), si bien que deux essais simultanés ne se partagent pas le
 * même compteur, et un code ne peut être consommé qu'une fois.
 *
 * Un code faux compte un essai ; au plafond, le code est clos. Un code juste
 * est consommé si `consume` est vrai (activation, réinitialisation,
 * changement d'adresse), simplement confirmé sinon (étape « code » de la page
 * de connexion, avant le choix du mot de passe).
 *
 * @returns {Promise<{ ok: true, new_email: string|null }|{ ok: false }>}
 */
async function checkCode(db, { userId, type, code, consume = false }) {
  if (!isCodeFormat(code)) return { ok: false };
  const found = await db.query(
    `SELECT id, token_hash, attempts, new_email FROM email_tokens
     WHERE user_id = $1 AND type = $2 AND used_at IS NULL AND expires_at > NOW()
     ORDER BY id DESC LIMIT 1
     FOR UPDATE`,
    [userId, type]
  );
  const row = found.rows[0];
  if (!row) return { ok: false };

  if (!sameHash(row.token_hash, hashCode(userId, type, code))) {
    await db.query(
      `UPDATE email_tokens
          SET attempts = attempts + 1,
              used_at = CASE WHEN attempts + 1 >= $2 THEN NOW() ELSE used_at END
        WHERE id = $1`,
      [row.id, MAX_ATTEMPTS]
    );
    return { ok: false };
  }

  if (consume) {
    await db.query('UPDATE email_tokens SET used_at = NOW() WHERE id = $1', [row.id]);
  }
  return { ok: true, new_email: row.new_email };
}

/**
 * Purge des codes devenus inutiles (LEGAL-007) : consommés (ou fermés), ou
 * expirés depuis plus d'un jour. Seul un code ouvert et valide sert encore
 * (checkCode exige used_at IS NULL et expires_at > NOW()). Sans cette purge,
 * une ligne ne disparaissait qu'à l'émission d'un nouveau code du même type
 * ou à la suppression du compte : l'adresse demandée lors d'un changement
 * abandonné (new_email) restait en clair sans limite de durée.
 * @returns {Promise<number>} lignes supprimées
 */
async function deleteSpent(db) {
  const result = await db.query(
    "DELETE FROM email_tokens WHERE used_at IS NOT NULL OR expires_at < NOW() - INTERVAL '1 day'"
  );
  return result.rowCount || 0;
}

module.exports = {
  CODE_LENGTH, MAX_ATTEMPTS,
  generateCode, isCodeFormat, hashCode, closeOpen, replaceOpen, checkCode, deleteSpent,
};
