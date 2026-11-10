'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — comptes utilisateurs (table users).
//
// Les fonctions qui écrivent dans le cadre d'une opération à plusieurs étapes
// (vérification, réinitialisation, changement d'adresse…) reçoivent le client
// de la transaction ouverte par l'appelant (db.js#withTransaction).
// -----------------------------------------------------------------------------

// --- Lecture ------------------------------------------------------------------

/** Ligne utile à la connexion (hash, verrouillage, version de jeton). */
async function findForLogin(db, email) {
  const result = await db.query(
    'SELECT id, name, email, password, role_id, token_version, email_verified, failed_login_count, locked_until FROM users WHERE email = $1',
    [email]
  );
  return result.rows[0] || null;
}

/** @returns {Promise<{ id: number, email_verified: boolean }|null>} */
async function findRegistrationState(db, email) {
  const result = await db.query('SELECT id, email_verified FROM users WHERE email = $1', [email]);
  return result.rows[0] || null;
}

/** Destinataire d'un email transactionnel. @returns {Promise<{ id, name, email_verified }|null>} */
async function findMailRecipient(db, email) {
  const result = await db.query(
    'SELECT id, name, email_verified FROM users WHERE email = $1',
    [email]
  );
  return result.rows[0] || null;
}

/** Données d'un nouveau jeton de session. */
async function findSessionUser(db, id) {
  const result = await db.query(
    'SELECT id, name, email, role_id, token_version FROM users WHERE id = $1',
    [id]
  );
  return result.rows[0] || null;
}

async function findContact(db, id) {
  const result = await db.query('SELECT name, email FROM users WHERE id = $1', [id]);
  return result.rows[0] || null;
}

/** Profil public (sans hash). */
async function findPublicById(db, id) {
  const result = await db.query('SELECT id, name, email, role_id FROM users WHERE id = $1', [id]);
  return result.rows[0] || null;
}

/**
 * Données personnelles du compte pour l'export (LEGAL-011) : toutes les
 * colonnes de `users` sauf le hash du mot de passe et `token_version`
 * (mécanique interne de révocation), avec le nom du rôle.
 */
async function findForExport(db, id) {
  const result = await db.query(
    `SELECT u.id, u.name, u.email, r.name AS role, u.email_verified,
            u.created_at, u.updated_at, u.failed_login_count, u.locked_until
     FROM users u
     LEFT JOIN roles r ON r.id = u.role_id
     WHERE u.id = $1`,
    [id]
  );
  return result.rows[0] || null;
}

/** Profil avec hash, pour vérifier le mot de passe actuel. */
async function findWithPassword(db, id) {
  const result = await db.query('SELECT id, name, email, password FROM users WHERE id = $1', [id]);
  return result.rows[0] || null;
}

/** Rôle et version de jeton, relus par authorize() à chaque requête. */
async function findAuthState(db, id) {
  const result = await db.query('SELECT role_id, token_version FROM users WHERE id = $1', [id]);
  return result.rows[0] || null;
}

/**
 * Page de la liste d'administration, recherche ILIKE sur nom et email.
 * @returns {Promise<{ total: number, rows: object[] }>}
 */
async function findPage(db, { search, limit, offset }) {
  const whereParts = [];
  const whereValues = [];
  if (search) {
    whereValues.push(`%${search}%`);
    whereParts.push(`(name ILIKE $${whereValues.length} OR email ILIKE $${whereValues.length})`);
  }
  const whereSql = whereParts.length ? `WHERE ${whereParts.join(' AND ')}` : '';

  const countResult = await db.query(
    `SELECT COUNT(*) FROM users ${whereSql}`,
    whereValues
  );
  const total = parseInt(countResult.rows[0].count, 10);

  const listValues = [...whereValues, limit, offset];
  const result = await db.query(
    `SELECT id, name, email, role_id FROM users ${whereSql} ORDER BY id LIMIT $${listValues.length - 1} OFFSET $${listValues.length}`,
    listValues
  );
  return { total, rows: result.rows };
}

// --- Inscription et connexion -------------------------------------------------

/** @returns {Promise<number>} id du compte créé */
async function insert(db, { name, email, passwordHash, roleId }) {
  const result = await db.query(
    'INSERT INTO users (name, email, password, role_id) VALUES ($1, $2, $3, $4) RETURNING id',
    [name, email, passwordHash, roleId]
  );
  return result.rows[0].id;
}

/** Renomme un compte tant qu'il n'est pas vérifié (nouvelle inscription). */
async function renameUnverified(db, id, name) {
  await db.query('UPDATE users SET name = $1 WHERE id = $2 AND email_verified = FALSE', [name, id]);
}

/**
 * Échec de connexion compté en SQL (`failed_login_count + 1`) : la valeur lue
 * avant bcrypt est périmée dès que des tentatives arrivent en parallèle, un
 * `SET failed_login_count = $1` calculé en JS perdrait des échecs. Au seuil,
 * le compte est verrouillé `lockMinutes` minutes.
 */
async function recordFailedLogin(db, id, { maxAttempts, lockMinutes }) {
  await db.query(
    `UPDATE users
           SET failed_login_count = failed_login_count + 1,
               locked_until = CASE
                 WHEN failed_login_count + 1 >= $1 THEN NOW() + ($2 || ' minutes')::interval
                 ELSE locked_until
               END
           WHERE id = $3`,
    [maxAttempts, String(lockMinutes), id]
  );
}

async function resetFailedLogins(db, id) {
  await db.query(
    'UPDATE users SET failed_login_count = 0, locked_until = NULL WHERE id = $1',
    [id]
  );
}

// --- Écritures liées aux jetons email ----------------------------------------

/** Vérification : mot de passe choisi par le titulaire de la boîte, compte activé. */
async function activateWithPassword(db, id, passwordHash) {
  await db.query(
    `UPDATE users
         SET password = $1, email_verified = TRUE, failed_login_count = 0, locked_until = NULL,
             token_version = token_version + 1
         WHERE id = $2`,
    [passwordHash, id]
  );
}

/** Changement d'adresse confirmé (lève 23505 si l'adresse a été prise entre-temps). */
async function applyEmailChange(db, id, email) {
  await db.query(
    'UPDATE users SET email = $1, email_verified = TRUE, token_version = token_version + 1 WHERE id = $2',
    [email, id]
  );
}

async function resetPassword(db, id, passwordHash) {
  await db.query(
    'UPDATE users SET password = $1, failed_login_count = 0, locked_until = NULL, token_version = token_version + 1 WHERE id = $2',
    [passwordHash, id]
  );
}

// --- Profil et administration -------------------------------------------------

/**
 * UPDATE des seules colonnes fournies, dans l'ordre (name, email, password).
 * @param {{ name?: string, email?: string, passwordHash?: string }} changes
 * @returns {Promise<object|null>} { id, name, email, role_id, token_version }, null si rien à écrire
 */
async function updateProfile(db, id, { name, email, passwordHash }) {
  const fields = [];
  const values = [];
  if (name) { values.push(name); fields.push(`name = $${values.length}`); }
  if (email) { values.push(email); fields.push(`email = $${values.length}`); }
  if (passwordHash) { values.push(passwordHash); fields.push(`password = $${values.length}`); }
  if (fields.length === 0) return null;
  values.push(id);
  const result = await db.query(
    `UPDATE users SET ${fields.join(', ')} WHERE id = $${values.length} RETURNING id, name, email, role_id, token_version`,
    values
  );
  return result.rows[0];
}

/**
 * UPDATE d'administration (nom, email, rôle) ; les valeurs undefined sont ignorées.
 * @returns {Promise<object|null>} { id, name, email, role_id }, null si l'id n'existe pas
 */
async function adminUpdate(db, id, { name, email, roleId }) {
  const fields = [];
  const values = [];
  let i = 1;
  if (name !== undefined) { fields.push(`name = $${i++}`); values.push(name); }
  if (email !== undefined) { fields.push(`email = $${i++}`); values.push(email); }
  if (roleId !== undefined) { fields.push(`role_id = $${i++}`); values.push(roleId); }
  values.push(id);
  const result = await db.query(
    `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`,
    values
  );
  return result.rows[0] || null;
}

/**
 * Incrémente users.token_version : tous les access tokens déjà émis pour ce
 * compte cessent d'être acceptés par authorize().
 * @returns {Promise<number|null>} nouvelle version, null si l'id n'existe pas
 */
async function bumpTokenVersion(db, id) {
  const result = await db.query(
    'UPDATE users SET token_version = token_version + 1 WHERE id = $1 RETURNING token_version',
    [id]
  );
  return result.rows[0] ? Number(result.rows[0].token_version) : null;
}

/** @returns {Promise<boolean>} true si le compte existait */
async function deleteById(db, id) {
  const result = await db.query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);
  return result.rows.length > 0;
}

/**
 * Supprime les comptes non vérifiés depuis plus de 7 jours (les email_tokens
 * suivent par ON DELETE CASCADE). @returns {Promise<number>} comptes supprimés
 */
async function deleteStaleUnverified(db) {
  const result = await db.query(
    `DELETE FROM users
     WHERE email_verified = FALSE
       AND created_at < NOW() - INTERVAL '7 days'`
  );
  return result.rowCount || 0;
}

module.exports = {
  findForLogin,
  findRegistrationState,
  findMailRecipient,
  findSessionUser,
  findContact,
  findPublicById,
  findForExport,
  findWithPassword,
  findAuthState,
  findPage,
  insert,
  renameUnverified,
  recordFailedLogin,
  resetFailedLogins,
  activateWithPassword,
  applyEmailChange,
  resetPassword,
  updateProfile,
  adminUpdate,
  bumpTokenVersion,
  deleteById,
  deleteStaleUnverified,
};
