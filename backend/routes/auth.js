const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const logger = require('../logger');
const { withTransaction } = require('../db');
const asyncHandler = require('../middleware/asyncHandler');
const {
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  isRefreshTokenValid,
  revokeRefreshToken,
  revokeAllUserRefreshTokens,
  setRefreshCookie,
  clearRefreshCookie,
  REFRESH_COOKIE_NAME,
} = require('../middleware/auth');

module.exports = function createAuthRouter(getPool, { registerLimiter, loginLimiter, emailLimiter, refreshLimiter, resetPasswordLimiter, mailer }) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Auth: inscription & connexion
  // -----------------------------------------------------------------------------
  router.post('/register', registerLimiter, asyncHandler(async (req, res) => {
    const { name, password } = req.body;
    const email = typeof req.body.email === 'string' ? req.body.email.trim().toLowerCase() : req.body.email;

    if (!name || !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
    }

    const userExists = await getPool().query('SELECT id, email FROM users WHERE email = $1', [email]);
    if (userExists.rows.length > 0) {
      return res.status(400).json({ message: 'Email déjà utilisé' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const defaultRole = 3;
    const verifyToken = crypto.randomBytes(32).toString('hex');
    const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000);

    // Transaction : créer user + token de vérification atomiquement
    const newUser = await withTransaction(getPool(), async (client) => {
      const insertResult = await client.query(
        'INSERT INTO users (name, email, password, role_id) VALUES ($1, $2, $3, $4) RETURNING id, name',
        [name, email, hashedPassword, defaultRole]
      );
      const user = insertResult.rows[0];
      await client.query(
        'INSERT INTO email_tokens (user_id, token, type, expires_at) VALUES ($1, $2, $3, $4)',
        [user.id, verifyToken, 'verify', tokenExpiry]
      );
      return user;
    });

    // Envoi de l'email de vérification (1 retry en cas d'échec)
    let emailSent = true;
    try {
      await mailer.sendVerificationEmail(email, newUser.name, verifyToken);
    } catch (mailErr) {
      logger.warn('Premier envoi email échoué, retry...', { error: mailErr.message });
      try {
        await mailer.sendVerificationEmail(email, newUser.name, verifyToken);
      } catch (retryErr) {
        emailSent = false;
        logger.error('Erreur envoi email de vérification après retry', { error: retryErr.message });
      }
    }

    if (emailSent) {
      res.status(201).json({ message: 'Compte créé. Vérifiez votre boîte email pour activer votre compte.' });
    } else {
      res.status(201).json({
        message: 'Compte créé, mais l\'email de vérification n\'a pas pu être envoyé. Utilisez « Renvoyer l\'email » pour réessayer.',
        warning: 'EMAIL_NOT_SENT'
      });
    }
  }));

  router.post('/login', loginLimiter, asyncHandler(async (req, res) => {
    const { password } = req.body;
    const email = typeof req.body.email === 'string' ? req.body.email.trim().toLowerCase() : req.body.email;

    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (!password || typeof password !== 'string') {
      return res.status(400).json({ message: 'Mot de passe requis' });
    }

    const user = await getPool().query(
      'SELECT id, name, email, password, role_id, email_verified FROM users WHERE email = $1',
      [email]
    );
    if (user.rows.length === 0) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    const validPassword = await bcrypt.compare(password, user.rows[0].password);
    if (!validPassword) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    const userData = user.rows[0];

    // Bloquer la connexion si l'email n'est pas vérifié
    if (!userData.email_verified) {
      return res.status(403).json({
        message: 'Votre email n\'est pas encore vérifié. Consultez votre boîte mail.',
        code: 'EMAIL_NOT_VERIFIED',
      });
    }
    const accessToken = generateAccessToken(userData);
    const { token: refreshToken, jti } = generateRefreshToken(userData);

    // Stocker le refresh token en base pour pouvoir le révoquer
    await storeRefreshToken(jti, userData.id);

    setRefreshCookie(res, refreshToken);

    res.json({ message: 'Connexion réussie', token: accessToken });
  }));

  // -----------------------------------------------------------------------------
  // Auth: refresh & logout (try/catch manuels — logique métier dans le catch)
  // -----------------------------------------------------------------------------
  router.post('/refresh', refreshLimiter, async (req, res) => {
    const refreshToken = req.cookies[REFRESH_COOKIE_NAME];
    if (!refreshToken) {
      return res.status(401).json({ message: 'Aucun refresh token', code: 'NO_REFRESH_TOKEN' });
    }

    try {
      const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);

      // S2 FIX : Vérifier que le token existe en base et n'est pas révoqué
      if (!decoded.jti || !(await isRefreshTokenValid(decoded.jti))) {
        clearRefreshCookie(res);
        return res.status(401).json({ message: 'Refresh token révoqué ou invalide', code: 'REFRESH_REVOKED' });
      }

      // Récupérer les données fraîches de l'utilisateur en DB
      const result = await getPool().query(
        'SELECT id, name, email, role_id FROM users WHERE id = $1',
        [decoded.id]
      );
      if (result.rows.length === 0) {
        clearRefreshCookie(res);
        await revokeRefreshToken(decoded.jti);
        return res.status(401).json({ message: 'Utilisateur introuvable', code: 'USER_NOT_FOUND' });
      }

      // Rotation du refresh token : révoquer l'ancien, émettre un nouveau
      await revokeRefreshToken(decoded.jti);

      const user = result.rows[0];
      const newAccessToken = generateAccessToken(user);
      const { token: newRefreshToken, jti: newJti } = generateRefreshToken(user);

      await storeRefreshToken(newJti, user.id);
      setRefreshCookie(res, newRefreshToken);

      res.json({ token: newAccessToken });
    } catch (error) {
      logger.warn('Refresh token invalide', { error: error.message, route: 'POST /refresh' });
      clearRefreshCookie(res);
      return res.status(401).json({ message: 'Refresh token invalide', code: 'REFRESH_INVALID' });
    }
  });

  router.post('/logout', async (req, res) => {
    // S2 FIX : Révoquer le refresh token en base lors de la déconnexion
    const refreshToken = req.cookies[REFRESH_COOKIE_NAME];
    if (refreshToken) {
      try {
        const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);
        if (decoded.jti) {
          await revokeRefreshToken(decoded.jti);
        }
      } catch (err) {
        logger.warn('Logout avec token invalide/expiré', { error: err.message, route: 'POST /logout' });
      }
    }
    clearRefreshCookie(res);
    res.json({ message: 'Déconnexion réussie' });
  });

  // -----------------------------------------------------------------------------
  // Auth : vérification email + mot de passe oublié
  // -----------------------------------------------------------------------------

  // GET /api/auth/verify-email?token= — Activer le compte
  router.get('/auth/verify-email', asyncHandler(async (req, res) => {
    const { token } = req.query;
    if (!token || typeof token !== 'string' || !/^[a-f0-9]{64}$/.test(token)) {
      return res.status(400).json({ message: 'Token invalide' });
    }

    const result = await getPool().query(
      `SELECT id, user_id FROM email_tokens
       WHERE token = $1 AND type = 'verify' AND used_at IS NULL AND expires_at > NOW()`,
      [token]
    );
    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    const { id: tokenId, user_id: userId } = result.rows[0];

    // Transaction : activer le compte + marquer le token comme utilisé
    await withTransaction(getPool(), async (client) => {
      await client.query('UPDATE users SET email_verified = true WHERE id = $1', [userId]);
      await client.query('UPDATE email_tokens SET used_at = NOW() WHERE id = $1', [tokenId]);
    });

    res.json({ message: 'Email vérifié avec succès. Vous pouvez maintenant vous connecter.' });
  }));

  // POST /api/auth/resend-verification — Renvoyer l'email de vérification
  // try/catch manuel : la réponse est envoyée avant le traitement async (sécurité)
  router.post('/auth/resend-verification', emailLimiter, async (req, res) => {
    const email = typeof req.body.email === 'string' ? req.body.email.trim().toLowerCase() : null;
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }

    // Réponse identique quelle que soit l'existence du compte (sécurité)
    res.json({ message: 'Si un compte non vérifié existe, un email vient d\'être envoyé.' });

    try {
      const userResult = await getPool().query(
        'SELECT id, name, email_verified FROM users WHERE email = $1',
        [email]
      );
      if (userResult.rows.length === 0 || userResult.rows[0].email_verified) return;

      const user = userResult.rows[0];

      // Transaction : invalider anciens tokens + créer le nouveau
      const verifyToken = crypto.randomBytes(32).toString('hex');
      const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000);

      await withTransaction(getPool(), async (client) => {
        await client.query(
          `UPDATE email_tokens SET used_at = NOW()
           WHERE user_id = $1 AND type = 'verify' AND used_at IS NULL`,
          [user.id]
        );
        await client.query(
          'INSERT INTO email_tokens (user_id, token, type, expires_at) VALUES ($1, $2, $3, $4)',
          [user.id, verifyToken, 'verify', tokenExpiry]
        );
      });

      await mailer.sendVerificationEmail(email, user.name, verifyToken);
    } catch (err) {
      logger.error('Erreur resend-verification', { error: err.message, route: 'POST /resend-verification' });
    }
  });

  // POST /api/auth/forgot-password — Demander une réinitialisation
  // try/catch manuel : même pattern que resend-verification
  router.post('/auth/forgot-password', emailLimiter, async (req, res) => {
    const email = typeof req.body.email === 'string' ? req.body.email.trim().toLowerCase() : null;
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }

    // Réponse identique quelle que soit l'existence du compte (sécurité)
    res.json({ message: 'Si un compte vérifié existe, un email de réinitialisation vient d\'être envoyé.' });

    try {
      const userResult = await getPool().query(
        'SELECT id, name, email_verified FROM users WHERE email = $1',
        [email]
      );
      if (userResult.rows.length === 0 || !userResult.rows[0].email_verified) return;

      const user = userResult.rows[0];

      // Transaction : invalider anciens tokens + créer le nouveau
      const resetToken = crypto.randomBytes(32).toString('hex');
      const tokenExpiry = new Date(Date.now() + 60 * 60 * 1000); // 1 heure

      await withTransaction(getPool(), async (client) => {
        await client.query(
          `UPDATE email_tokens SET used_at = NOW()
           WHERE user_id = $1 AND type = 'reset' AND used_at IS NULL`,
          [user.id]
        );
        await client.query(
          'INSERT INTO email_tokens (user_id, token, type, expires_at) VALUES ($1, $2, $3, $4)',
          [user.id, resetToken, 'reset', tokenExpiry]
        );
      });

      await mailer.sendPasswordResetEmail(email, user.name, resetToken);
    } catch (err) {
      logger.error('Erreur forgot-password', { error: err.message, route: 'POST /forgot-password' });
    }
  });

  // POST /api/auth/reset-password — Changer le mot de passe avec le token
  router.post('/auth/reset-password', resetPasswordLimiter, asyncHandler(async (req, res) => {
    const { token, password } = req.body;

    if (!token || typeof token !== 'string' || !/^[a-f0-9]{64}$/.test(token)) {
      return res.status(400).json({ message: 'Token invalide' });
    }
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
    }

    const result = await getPool().query(
      `SELECT id, user_id FROM email_tokens
       WHERE token = $1 AND type = 'reset' AND used_at IS NULL AND expires_at > NOW()`,
      [token]
    );
    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    const { id: tokenId, user_id: userId } = result.rows[0];
    const hashedPassword = await bcrypt.hash(password, 10);

    // Transaction : changer le mot de passe + invalider le token + révoquer les sessions
    await withTransaction(getPool(), async (client) => {
      await client.query('UPDATE users SET password = $1 WHERE id = $2', [hashedPassword, userId]);
      await client.query('UPDATE email_tokens SET used_at = NOW() WHERE id = $1', [tokenId]);
      await client.query(
        'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
        [userId]
      );
    });

    res.json({ message: 'Mot de passe réinitialisé avec succès. Vous pouvez maintenant vous connecter.' });
  }));

  return router;
};
