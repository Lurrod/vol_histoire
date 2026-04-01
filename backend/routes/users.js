const express = require('express');
const bcrypt = require('bcryptjs');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const { authorize, revokeAllUserRefreshTokens } = require('../middleware/auth');

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
  router.get('/users', authorize([1]), async (req, res) => {
    try {
      const result = await getPool().query('SELECT id, name, email, role_id FROM users');
      res.json(result.rows);
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/users/:id', authorize([1, 2, 3]), async (req, res) => {
    const { id } = req.params;
    const requester = req.user;
    if (Number(requester.id) !== Number(id) && requester.role !== 1) {
      return res.status(403).json({ message: 'Accès non autorisé' });
    }

    try {
      const result = await getPool().query('SELECT id, name, email, role_id FROM users WHERE id = $1', [id]);
      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Utilisateur non trouvé' });
      }
      res.json(result.rows[0]);
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur' });
    }
  });

  router.put('/users/:id', authorize([1, 2, 3]), async (req, res) => {
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

    const requester = req.user;
    if (Number(requester.id) !== Number(id) && requester.role !== 1) {
      return res.status(403).json({ message: 'Accès non autorisé' });
    }

    try {
      let hashedPassword;
      if (password) {
        hashedPassword = await bcrypt.hash(password, 10);
      }

      const fields = [];
      const values = [];
      let i = 1;

      if (name) { fields.push(`name = $${i++}`); values.push(name); }
      if (email) { fields.push(`email = $${i++}`); values.push(email.trim().toLowerCase()); }
      if (password) { fields.push(`password = $${i++}`); values.push(hashedPassword); }

      if (fields.length === 0) {
        return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
      }

      values.push(id);
      const query = `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`;
      const result = await getPool().query(query, values);

      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Utilisateur non trouvé' });
      }

      // Révoquer tous les refresh tokens lors d'un changement de mot de passe
      if (password) {
        await revokeAllUserRefreshTokens(id);
      }

      res.json({ message: 'Mise à jour réussie', user: result.rows[0] });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur' });
    }
  });

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
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.delete('/users/:id', authorize([1, 2, 3]), async (req, res) => {
    const { id } = req.params;
    const requester = req.user;
    if (Number(requester.id) !== Number(id) && requester.role !== 1) {
      return res.status(403).json({ message: 'Accès non autorisé' });
    }

    try {
      await revokeAllUserRefreshTokens(id);
      const result = await getPool().query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);
      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Utilisateur non trouvé' });
      }
      res.json({ message: 'Compte supprimé avec succès' });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur' });
    }
  });

  return router;
};
