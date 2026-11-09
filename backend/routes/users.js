const express = require('express');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const {
  authorize,
  isOwnerOrAdmin,
  bumpTokenVersion,
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  setRefreshCookie,
} = require('../middleware/auth');
const logger = require('../logger');
const { withTransaction } = require('../db');
const asyncHandler = require('../middleware/asyncHandler');

// Durée de validité du lien de confirmation d'un changement d'adresse
const EMAIL_CHANGE_TTL_MS = 30 * 60 * 1000;

module.exports = function createUsersRouter(getPool, { mailer } = {}) {
  const router = express.Router();

  // Validation des IDs
  router.param('id', (req, res, next, value) => {
    if (!/^\d+$/.test(value)) {
      return res.status(400).json({ message: 'ID invalide' });
    }
    next();
  });

  // -----------------------------------------------------------------------------
  // Utilisateurs
  // -----------------------------------------------------------------------------
  router.get('/users', authorize([1]), asyncHandler(async (req, res) => {
    const page = Math.max(1, parseInt(req.query.page, 10) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 20));
    const offset = (page - 1) * limit;
    const search = typeof req.query.search === 'string' ? req.query.search.trim() : '';

    const whereParts = [];
    const whereValues = [];
    if (search) {
      whereValues.push(`%${search}%`);
      whereParts.push(`(name ILIKE $${whereValues.length} OR email ILIKE $${whereValues.length})`);
    }
    const whereSql = whereParts.length ? `WHERE ${whereParts.join(' AND ')}` : '';

    const countResult = await getPool().query(
      `SELECT COUNT(*) FROM users ${whereSql}`,
      whereValues
    );
    const total = parseInt(countResult.rows[0].count, 10);

    const listValues = [...whereValues, limit, offset];
    const result = await getPool().query(
      `SELECT id, name, email, role_id FROM users ${whereSql} ORDER BY id LIMIT $${listValues.length - 1} OFFSET $${listValues.length}`,
      listValues
    );
    res.json({
      data: result.rows,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) }
    });
  }));

  router.get('/users/:id', authorize([1, 2, 3]), isOwnerOrAdmin('id'), asyncHandler(async (req, res) => {
    const { id } = req.params;

    const result = await getPool().query('SELECT id, name, email, role_id FROM users WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json(result.rows[0]);
  }));

  // Changement de profil. Pour son propre compte, l'email et le mot de passe
  // exigent le mot de passe actuel : un access token volé (XSS, poste resté
  // ouvert) ne doit pas suffire à s'approprier durablement le compte.
  // Le nouvel email n'est appliqué qu'après clic sur un lien envoyé à cette
  // adresse (POST /auth/confirm-email-change) ; la réponse est identique que
  // l'adresse soit libre ou déjà prise, pour ne pas révéler les comptes existants.
  router.put('/users/:id', authorize([1, 2, 3]), isOwnerOrAdmin('id'), asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { name, email, password, currentPassword } = req.body;

    if (name !== undefined && !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (email !== undefined && !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (password !== undefined && !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
    }

    const current = await getPool().query('SELECT id, name, email, password FROM users WHERE id = $1', [id]);
    if (current.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    const user = current.rows[0];
    const isSelf = Number(req.user.id) === Number(id);
    const newEmail = email ? email.trim().toLowerCase() : null;
    const emailChanges = Boolean(newEmail) && newEmail !== user.email;

    if (!name && !emailChanges && !password) {
      return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
    }

    if (isSelf && (emailChanges || password)) {
      if (typeof currentPassword !== 'string' || !currentPassword) {
        return res.status(400).json({ message: 'Mot de passe actuel requis', code: 'CURRENT_PASSWORD_REQUIRED' });
      }
      if (!(await bcrypt.compare(currentPassword, user.password))) {
        return res.status(403).json({ message: 'Mot de passe actuel incorrect', code: 'CURRENT_PASSWORD_INVALID' });
      }
    }

    const hashedPassword = password ? await bcrypt.hash(password, 12) : null;
    // Un admin agissant sur le compte d'un autre applique l'email directement.
    const directEmail = emailChanges && !isSelf ? newEmail : null;
    const fields = [];
    const values = [];
    if (name) { values.push(name); fields.push(`name = $${values.length}`); }
    if (directEmail) { values.push(directEmail); fields.push(`email = $${values.length}`); }
    if (hashedPassword) { values.push(hashedPassword); fields.push(`password = $${values.length}`); }
    const revokesSessions = Boolean(hashedPassword || directEmail);

    let updated;
    try {
      updated = await withTransaction(getPool(), async (client) => {
        let row = { id: user.id, name: user.name, email: user.email };
        if (fields.length > 0) {
          values.push(id);
          const upd = await client.query(
            `UPDATE users SET ${fields.join(', ')} WHERE id = $${values.length} RETURNING id, name, email, role_id, token_version`,
            values
          );
          row = upd.rows[0];
        }
        if (revokesSessions) {
          await client.query('UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE', [id]);
          row = { ...row, token_version: await bumpTokenVersion(client, id) };
        }
        return row;
      });
    } catch (error) {
      if (error.code === '23505') {
        return res.status(409).json({ message: 'Cet email est déjà utilisé' });
      }
      throw error;
    }

    const emailChangePending = emailChanges && isSelf;
    if (emailChangePending) {
      await requestEmailChange(user, newEmail);
    }

    const body = {
      message: emailChangePending
        ? 'Un lien de confirmation a été envoyé à la nouvelle adresse. Elle remplacera l\'actuelle après validation.'
        : 'Mise à jour réussie',
      user: { id: updated.id, name: updated.name, email: updated.email, role_id: updated.role_id },
      emailChangePending,
    };

    // Changement de son propre mot de passe : toutes les sessions sont coupées,
    // y compris celle-ci ; on en rouvre une neuve pour ne pas déconnecter
    // l'utilisateur qui vient d'agir.
    if (isSelf && revokesSessions) {
      const fresh = { ...updated, role_id: updated.role_id ?? req.user.role };
      const { token: refreshToken, jti } = generateRefreshToken(fresh);
      await storeRefreshToken(jti, fresh.id);
      setRefreshCookie(res, refreshToken);
      body.token = generateAccessToken(fresh);
    }

    res.json(body);
  }));

  /**
   * Prépare un changement d'adresse : jeton 'email' porteur de la nouvelle
   * adresse, lien envoyé à celle-ci, avertissement envoyé à l'ancienne.
   * Les échecs d'envoi sont journalisés sans changer la réponse.
   */
  async function requestEmailChange(user, newEmail) {
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + EMAIL_CHANGE_TTL_MS);
    await withTransaction(getPool(), async (client) => {
      await client.query(
        "UPDATE email_tokens SET used_at = NOW() WHERE user_id = $1 AND type = 'email' AND used_at IS NULL",
        [user.id]
      );
      await client.query(
        'INSERT INTO email_tokens (user_id, token, type, expires_at, new_email) VALUES ($1, $2, $3, $4, $5)',
        [user.id, token, 'email', expiresAt, newEmail]
      );
    });
    try {
      await mailer.sendEmailChangeConfirmation(newEmail, user.name, token);
      await mailer.sendEmailChangeNotice(user.email, user.name);
    } catch (err) {
      logger.error('Erreur envoi emails de changement d\'adresse', { error: err.message, userId: user.id });
    }
  }

  // try/catch manuel : logique métier dans le catch (error.code 23505 → 409)
  router.put('/admin/users/:id', authorize([1]), async (req, res) => {
    const { id } = req.params;
    const { name, email, role_id } = req.body;

    if (!name || !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (email !== undefined && !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    const validRoles = [1, 2, 3];
    if (role_id === undefined || !validRoles.includes(Number(role_id))) {
      return res.status(400).json({ message: 'Rôle invalide (1 = admin, 2 = éditeur, 3 = membre)' });
    }

    const fields = [];
    const values = [];
    let i = 1;
    if (name !== undefined) { fields.push(`name = $${i++}`); values.push(name.trim()); }
    if (email !== undefined) { fields.push(`email = $${i++}`); values.push(email.trim().toLowerCase()); }
    if (role_id !== undefined) { fields.push(`role_id = $${i++}`); values.push(Number(role_id)); }

    if (fields.length === 0) {
      return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
    }

    try {
      values.push(id);
      const query = `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`;

      // Un changement d'email ou de role par un admin doit invalider les
      // sessions en cours : l'identité ou le scope d'autorisation change,
      // les JWT/refresh tokens existants ne doivent plus être utilisables
      // (révocation des refresh tokens + incrément de token_version).
      const revokeSessions = email !== undefined || role_id !== undefined;

      let result;
      if (revokeSessions) {
        result = await withTransaction(getPool(), async (client) => {
          const upd = await client.query(query, values);
          if (upd.rows.length > 0) {
            await client.query(
              'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
              [id]
            );
            await bumpTokenVersion(client, id);
          }
          return upd;
        });
      } else {
        result = await getPool().query(query, values);
      }

      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Utilisateur non trouvé' });
      }
      res.json(result.rows[0]);
    } catch (error) {
      if (error.code === '23505') {
        return res.status(409).json({ message: 'Cet email est déjà utilisé' });
      }
      const entry = logger.error('Erreur admin mise à jour utilisateur', { error: error.message, route: `PUT /admin/users/${id}` });
      res.status(500).json({ error: 'Erreur serveur', errorId: entry.errorId });
    }
  });

  router.delete('/users/:id', authorize([1, 2, 3]), isOwnerOrAdmin('id'), asyncHandler(async (req, res) => {
    const { id } = req.params;

    // Transaction : révoquer les sessions + supprimer le compte
    const result = await withTransaction(getPool(), async (client) => {
      await client.query(
        'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
        [id]
      );
      return client.query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);
    });
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json({ message: 'Compte supprimé avec succès' });
  }));

  return router;
};
