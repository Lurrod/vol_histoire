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
const usersRepo = require('../repositories/users');
const emailTokensRepo = require('../repositories/email-tokens');
const refreshTokensRepo = require('../repositories/refresh-tokens');
const favoritesRepo = require('../repositories/favorites');
const { idParam, cleanSearch } = require('../middleware/input-guards');

// Durée de validité du lien de confirmation d'un changement d'adresse
const EMAIL_CHANGE_TTL_MS = 30 * 60 * 1000;

const passThrough = (req, res, next) => next();

module.exports = function createUsersRouter(getPool, { mailer, dataExportLimiter = passThrough } = {}) {
  const router = express.Router();

  // Validation des IDs : entier int4 positif, sinon 400 (SEC-003).
  router.param('id', idParam());

  // -----------------------------------------------------------------------------
  // Utilisateurs
  // -----------------------------------------------------------------------------
  router.get('/users', authorize([1]), asyncHandler(async (req, res) => {
    const page = Math.max(1, parseInt(req.query.page, 10) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 20));
    const offset = (page - 1) * limit;
    const search = cleanSearch(req.query.search);

    const { total, rows } = await usersRepo.findPage(getPool(), { search, limit, offset });
    res.json({
      data: rows,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) }
    });
  }));

  // Export des données personnelles du compte connecté (droit d'accès et à la
  // portabilité, LEGAL-011) : profil et favoris, en JSON téléchargeable.
  // Le choix de cookies n'est conservé que dans le navigateur : `consent` vaut
  // null côté serveur. Déclarée avant /users/:id par lisibilité (« me » n'est
  // de toute façon pas un identifiant valide).
  router.get('/users/me/export', dataExportLimiter, authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const userId = Number(req.user.id);
    const [user, favorites] = await Promise.all([
      usersRepo.findForExport(getPool(), userId),
      favoritesRepo.listForExport(getPool(), userId),
    ]);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    const payload = {
      exported_at: new Date().toISOString(),
      user,
      favorites,
      consent: null,
    };
    res.set('Cache-Control', 'no-store');
    res.set('Content-Disposition', `attachment; filename="vol-histoire-donnees-${userId}.json"`);
    res.type('application/json; charset=utf-8').send(JSON.stringify(payload, null, 2));
  }));

  router.get('/users/:id', authorize([1, 2, 3]), isOwnerOrAdmin('id'), asyncHandler(async (req, res) => {
    const user = await usersRepo.findPublicById(getPool(), req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json(user);
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

    const user = await usersRepo.findWithPassword(getPool(), id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
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
    const changes = { name: name || undefined, email: directEmail || undefined, passwordHash: hashedPassword || undefined };
    const writes = Boolean(name || directEmail || hashedPassword);
    const revokesSessions = Boolean(hashedPassword || directEmail);

    let updated;
    try {
      updated = await withTransaction(getPool(), async (client) => {
        let row = { id: user.id, name: user.name, email: user.email };
        if (writes) {
          row = await usersRepo.updateProfile(client, id, changes);
        }
        if (revokesSessions) {
          await refreshTokensRepo.revokeAllForUser(client, id);
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
    await withTransaction(getPool(), (client) =>
      emailTokensRepo.replaceOpen(client, { userId: user.id, type: 'email', token, expiresAt, newEmail })
    );
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

    const changes = {
      name: name !== undefined ? name.trim() : undefined,
      email: email !== undefined ? email.trim().toLowerCase() : undefined,
      roleId: role_id !== undefined ? Number(role_id) : undefined,
    };

    if (Object.values(changes).every((v) => v === undefined)) {
      return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
    }

    try {
      // Un changement d'email ou de role par un admin doit invalider les
      // sessions en cours : l'identité ou le scope d'autorisation change,
      // les JWT/refresh tokens existants ne doivent plus être utilisables
      // (révocation des refresh tokens + incrément de token_version).
      const revokeSessions = email !== undefined || role_id !== undefined;

      let updated;
      if (revokeSessions) {
        updated = await withTransaction(getPool(), async (client) => {
          const row = await usersRepo.adminUpdate(client, id, changes);
          if (row) {
            await refreshTokensRepo.revokeAllForUser(client, id);
            await bumpTokenVersion(client, id);
          }
          return row;
        });
      } else {
        updated = await usersRepo.adminUpdate(getPool(), id, changes);
      }

      if (!updated) {
        return res.status(404).json({ message: 'Utilisateur non trouvé' });
      }
      res.json(updated);
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
    const deleted = await withTransaction(getPool(), async (client) => {
      await refreshTokensRepo.revokeAllForUser(client, id);
      return usersRepo.deleteById(client, id);
    });
    if (!deleted) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json({ message: 'Compte supprimé avec succès' });
  }));

  return router;
};
