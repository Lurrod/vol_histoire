const express = require('express');
const bcrypt = require('bcryptjs');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const { authorize, isOwnerOrAdmin, revokeAllUserRefreshTokens } = require('../middleware/auth');
const logger = require('../logger');
const { withTransaction } = require('../db');
const asyncHandler = require('../middleware/asyncHandler');

module.exports = function createUsersRouter(getPool) {
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

    const countResult = await getPool().query('SELECT COUNT(*) FROM users');
    const total = parseInt(countResult.rows[0].count, 10);

    const result = await getPool().query(
      'SELECT id, name, email, role_id FROM users ORDER BY id LIMIT $1 OFFSET $2',
      [limit, offset]
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

  router.put('/users/:id', authorize([1, 2, 3]), isOwnerOrAdmin('id'), asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { name, email, password } = req.body;

    if (name !== undefined && !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (email !== undefined && !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (password !== undefined && !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
    }

    let hashedPassword;
    if (password) {
      hashedPassword = await bcrypt.hash(password, 10);
    }

    const ALLOWED_FIELDS = { name: 'name', email: 'email', password: 'password' };
    const fields = [];
    const values = [];
    let i = 1;

    if (name) { fields.push(`${ALLOWED_FIELDS.name} = $${i++}`); values.push(name); }
    if (email) { fields.push(`${ALLOWED_FIELDS.email} = $${i++}`); values.push(email.trim().toLowerCase()); }
    if (password) { fields.push(`${ALLOWED_FIELDS.password} = $${i++}`); values.push(hashedPassword); }

    if (fields.length === 0) {
      return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
    }

    values.push(id);
    const query = `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`;

    // Transaction si changement de mot de passe ou d'email (update + révocation des sessions)
    let result;
    if (password || email) {
      result = await withTransaction(getPool(), async (client) => {
        const res = await client.query(query, values);
        if (res.rows.length > 0) {
          await client.query(
            'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
            [id]
          );
        }
        return res;
      });
    } else {
      result = await getPool().query(query, values);
    }

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }

    res.json({ message: 'Mise à jour réussie', user: result.rows[0] });
  }));

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
      const result = await getPool().query(
        `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`,
        values
      );
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
