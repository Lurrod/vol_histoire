const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const logger = require('../logger');
const { withTransaction } = require('../db');
const asyncHandler = require('../middleware/asyncHandler');
const verifyHcaptcha = require('../middleware/hcaptcha');
const {
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  getRefreshTokenState,
  revokeRefreshToken,
  rotateRefreshToken,
  revokeAllUserRefreshTokens,
  setRefreshCookie,
  clearRefreshCookie,
  REFRESH_COOKIE_NAME,
  JWT_VERIFY_OPTIONS,
} = require('../middleware/auth');

module.exports = function createAuthRouter(getPool, { registerLimiter, loginLimiter, emailLimiter, refreshLimiter, resetPasswordLimiter, mailer }) {
  const router = express.Router();

  const VERIFY_TOKEN_TTL_MS = 30 * 60 * 1000;
  const RESET_TOKEN_TTL_MS = 15 * 60 * 1000;

  /**
   * Invalide les jetons email ouverts du même type pour l'utilisateur, puis en
   * crée un nouveau. `newEmail` ne sert qu'au type 'email' (changement d'adresse).
   * @returns {Promise<string>} le jeton (64 hex)
   */
  async function issueEmailToken(userId, type, ttlMs, newEmail = null) {
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + ttlMs);
    await withTransaction(getPool(), async (client) => {
      await client.query(
        'UPDATE email_tokens SET used_at = NOW() WHERE user_id = $1 AND type = $2 AND used_at IS NULL',
        [userId, type]
      );
      await client.query(
        'INSERT INTO email_tokens (user_id, token, type, expires_at, new_email) VALUES ($1, $2, $3, $4, $5)',
        [userId, token, type, expiresAt, newEmail]
      );
    });
    return token;
  }

  /**
   * Consomme un jeton email à usage unique dans la transaction donnée.
   * Le UPDATE gardé par `used_at IS NULL` rend la consommation atomique : deux
   * requêtes concurrentes avec le même jeton ne peuvent pas réussir toutes les deux.
   * @returns {Promise<{ user_id: number, new_email: string|null }|null>}
   */
  async function consumeEmailToken(client, token, type) {
    const result = await client.query(
      `UPDATE email_tokens SET used_at = NOW()
       WHERE token = $1 AND type = $2 AND used_at IS NULL AND expires_at > NOW()
       RETURNING user_id, new_email`,
      [token, type]
    );
    return result.rows[0] || null;
  }

  // -----------------------------------------------------------------------------
  // Auth: inscription & connexion
  // -----------------------------------------------------------------------------
  router.post('/register', registerLimiter, verifyHcaptcha, asyncHandler(async (req, res) => {
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

    const userExists = await getPool().query('SELECT id, email_verified FROM users WHERE email = $1', [email]);
    const hashedPassword = await bcrypt.hash(password, 12);

    // Anti-énumération : réponse identique, envoyée AVANT tout travail qui
    // dépend de l'existence du compte (transaction, envoi SMTP). Sinon le délai
    // de l'envoi trahirait les adresses non inscrites.
    res.status(201).json({ message: 'Compte créé. Vérifiez votre boîte email pour activer votre compte.' });

    try {
      const existing = userExists.rows[0];
      if (existing && existing.email_verified) return;

      let userId;
      if (existing) {
        // Compte non vérifié déjà présent : le mot de passe actif sera choisi
        // au moment de la vérification par le titulaire de la boîte (voir
        // POST /auth/verify-email) ; on envoie simplement un nouveau lien.
        userId = existing.id;
        await getPool().query('UPDATE users SET name = $1 WHERE id = $2 AND email_verified = FALSE', [name, userId]);
      } else {
        const insertResult = await getPool().query(
          'INSERT INTO users (name, email, password, role_id) VALUES ($1, $2, $3, $4) RETURNING id',
          [name, email, hashedPassword, 3]
        );
        userId = insertResult.rows[0].id;
      }

      const verifyToken = await issueEmailToken(userId, 'verify', VERIFY_TOKEN_TTL_MS);
      try {
        await mailer.sendVerificationEmail(email, name, verifyToken);
      } catch (mailErr) {
        logger.warn('Premier envoi email échoué, retry...', { error: mailErr.message });
        await mailer.sendVerificationEmail(email, name, verifyToken);
      }
    } catch (err) {
      logger.error('Erreur inscription (après réponse)', { error: err.message, route: 'POST /register' });
    }
  }));

  // Lockout par compte — défense contre credential-stuffing distribué
  // (rate-limit IP insuffisant si botnet). Constantes volontairement
  // conservatrices : un user qui oublie son mdp a 10 essais avant blocage.
  const LOCKOUT_MAX_ATTEMPTS = 10;
  const LOCKOUT_DURATION_MIN = 15;

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
      'SELECT id, name, email, password, role_id, token_version, email_verified, failed_login_count, locked_until FROM users WHERE email = $1',
      [email]
    );

    // Anti timing-attack : bcrypt.compare est toujours exécuté, même si
    // l'utilisateur n'existe pas, pour garantir un temps de réponse constant.
    const DUMMY_HASH = '$2a$12$mPEeg.GN9eKdtN4Hd23tve9R3aTnsNjlXIz9.tO5hM2ZU1EPP3BvC';
    const storedHash = user.rows.length > 0 ? user.rows[0].password : DUMMY_HASH;
    const validPassword = await bcrypt.compare(password, storedHash);

    const userData = user.rows[0];

    // Compte verrouillé : message générique pour ne pas leaker l'existence
    // d'un compte (user enumeration). Même status/message qu'un mdp incorrect
    // côté client, mais on log le blocage côté serveur.
    if (userData && userData.locked_until && new Date(userData.locked_until) > new Date()) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    if (user.rows.length === 0 || !validPassword) {
      // Incrément du compteur d'échecs si le compte existe.
      // Si seuil atteint : verrouillage du compte pour LOCKOUT_DURATION_MIN minutes.
      // On ne révèle pas au client qu'un compte existe : 400 générique dans tous les cas.
      // Incrément atomique côté SQL : la valeur lue plus haut est périmée dès
      // que des tentatives arrivent en parallèle (bcrypt.compare rend la main),
      // et un `SET failed_login_count = $1` calculé en JS perdrait des échecs.
      if (userData) {
        await getPool().query(
          `UPDATE users
           SET failed_login_count = failed_login_count + 1,
               locked_until = CASE
                 WHEN failed_login_count + 1 >= $1 THEN NOW() + ($2 || ' minutes')::interval
                 ELSE locked_until
               END
           WHERE id = $3`,
          [LOCKOUT_MAX_ATTEMPTS, String(LOCKOUT_DURATION_MIN), userData.id]
        );
      }
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    // Bloquer la connexion si l'email n'est pas vérifié
    if (!userData.email_verified) {
      return res.status(403).json({
        message: 'Votre email n\'est pas encore vérifié. Consultez votre boîte mail.',
        code: 'EMAIL_NOT_VERIFIED',
      });
    }

    // Login réussi : reset compteur + lockout
    if (userData.failed_login_count > 0 || userData.locked_until) {
      await getPool().query(
        'UPDATE users SET failed_login_count = 0, locked_until = NULL WHERE id = $1',
        [userData.id]
      );
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
      const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET, JWT_VERIFY_OPTIONS);

      const tokenState = decoded.jti ? await getRefreshTokenState(decoded.jti) : { state: 'unknown' };

      // Un jeton déjà remplacé par rotation qui revient : quelqu'un d'autre a
      // rafraîchi avec, ou rafraîchit encore. On ne peut pas savoir lequel des
      // deux est légitime : on coupe toute la session de l'utilisateur.
      if (tokenState.state === 'reused') {
        logger.warn('Replay refresh token détecté — révocation totale', {
          userId: tokenState.userId, jti: decoded.jti, route: 'POST /refresh',
        });
        await revokeAllUserRefreshTokens(tokenState.userId).catch(() => {});
        clearRefreshCookie(res);
        return res.status(401).json({ message: 'Session compromise', code: 'REFRESH_REPLAY' });
      }
      if (tokenState.state !== 'valid') {
        clearRefreshCookie(res);
        return res.status(401).json({ message: 'Refresh token révoqué ou invalide', code: 'REFRESH_REVOKED' });
      }

      // Récupérer les données fraîches de l'utilisateur en DB
      const result = await getPool().query(
        'SELECT id, name, email, role_id, token_version FROM users WHERE id = $1',
        [decoded.id]
      );
      if (result.rows.length === 0) {
        clearRefreshCookie(res);
        await revokeRefreshToken(decoded.jti);
        return res.status(401).json({ message: 'Utilisateur introuvable', code: 'USER_NOT_FOUND' });
      }

      // Rotation atomique (BEGIN/COMMIT) : révocation ancienne + insertion
      // nouvelle dans la même transaction. Protège contre :
      //   - Crash entre les 2 étapes (session orpheline ou double-active)
      //   - Race condition 2 requêtes concurrentes de /refresh avec le même JTI
      const user = result.rows[0];
      const newAccessToken = generateAccessToken(user);
      const { token: newRefreshToken, jti: newJti } = generateRefreshToken(user);

      try {
        await rotateRefreshToken(decoded.jti, newJti, user.id);
      } catch (rotationError) {
        // Replay détecté : un attaquant tente de réutiliser un ancien token.
        // Défense en profondeur : on révoque TOUTES les sessions de l'user.
        if (rotationError.code === 'REFRESH_REPLAY') {
          logger.warn('Replay refresh token détecté — révocation totale', {
            userId: user.id, jti: decoded.jti, route: 'POST /refresh',
          });
          await revokeAllUserRefreshTokens(user.id).catch(() => {});
          clearRefreshCookie(res);
          return res.status(401).json({ message: 'Session compromise', code: 'REFRESH_REPLAY' });
        }
        throw rotationError;
      }

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
        const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET, JWT_VERIFY_OPTIONS);
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

  // POST /api/auth/verify-email { token, password } — Activer le compte.
  // Le titulaire de la boîte choisit ici le mot de passe actif : un mot de passe
  // saisi à l'inscription par quelqu'un d'autre (pré-inscription de l'adresse
  // d'autrui) n'est donc jamais activé par la vérification.
  router.post('/auth/verify-email', resetPasswordLimiter, asyncHandler(async (req, res) => {
    const { token, password } = req.body;
    if (!token || typeof token !== 'string' || !/^[a-f0-9]{64}$/.test(token)) {
      return res.status(400).json({ message: 'Token invalide' });
    }
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    const userId = await withTransaction(getPool(), async (client) => {
      const consumed = await consumeEmailToken(client, token, 'verify');
      if (!consumed) return null;
      await client.query(
        `UPDATE users
         SET password = $1, email_verified = TRUE, failed_login_count = 0, locked_until = NULL,
             token_version = token_version + 1
         WHERE id = $2`,
        [hashedPassword, consumed.user_id]
      );
      await client.query(
        "UPDATE email_tokens SET used_at = NOW() WHERE user_id = $1 AND type = 'verify' AND used_at IS NULL",
        [consumed.user_id]
      );
      await client.query(
        'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
        [consumed.user_id]
      );
      return consumed.user_id;
    });
    if (!userId) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    // Envoi de l'email de bienvenue (non bloquant)
    try {
      const userResult = await getPool().query('SELECT name, email FROM users WHERE id = $1', [userId]);
      if (userResult.rows.length > 0) {
        const { name, email } = userResult.rows[0];
        mailer.sendWelcomeEmail(email, name).catch(err =>
          logger.warn('Échec envoi email bienvenue', { error: err.message, userId })
        );
      }
    } catch { /* non bloquant */ }

    res.json({ message: 'Email vérifié avec succès. Vous pouvez maintenant vous connecter.' });
  }));

  // POST /api/auth/confirm-email-change { token } — Appliquer un changement
  // d'adresse demandé depuis les paramètres. Le lien n'est envoyé qu'à la
  // nouvelle adresse : l'appliquer prouve qu'on la contrôle.
  router.post('/auth/confirm-email-change', resetPasswordLimiter, async (req, res) => {
    const { token } = req.body;
    if (!token || typeof token !== 'string' || !/^[a-f0-9]{64}$/.test(token)) {
      return res.status(400).json({ message: 'Token invalide' });
    }
    try {
      const changed = await withTransaction(getPool(), async (client) => {
        const consumed = await consumeEmailToken(client, token, 'email');
        if (!consumed || !consumed.new_email) return false;
        await client.query(
          'UPDATE users SET email = $1, email_verified = TRUE, token_version = token_version + 1 WHERE id = $2',
          [consumed.new_email, consumed.user_id]
        );
        await client.query(
          'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
          [consumed.user_id]
        );
        return true;
      });
      if (!changed) {
        return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
      }
      res.json({ message: 'Adresse email modifiée. Reconnectez-vous avec votre nouvelle adresse.' });
    } catch (error) {
      // Adresse prise entre la demande et la confirmation : seul le titulaire de
      // la nouvelle boîte voit ce message.
      if (error.code === '23505') {
        return res.status(409).json({ message: 'Cette adresse est déjà utilisée par un autre compte', code: 'EMAIL_TAKEN' });
      }
      const entry = logger.error('Erreur confirmation changement email', { error: error.message, route: 'POST /auth/confirm-email-change' });
      res.status(500).json({ message: 'Erreur interne du serveur', errorId: entry.errorId });
    }
  });

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

      const verifyToken = await issueEmailToken(user.id, 'verify', VERIFY_TOKEN_TTL_MS);
      await mailer.sendVerificationEmail(email, user.name, verifyToken);
    } catch (err) {
      logger.error('Erreur resend-verification', { error: err.message, route: 'POST /resend-verification' });
    }
  });

  // POST /api/auth/forgot-password — Demander une réinitialisation
  // try/catch manuel : même pattern que resend-verification
  router.post('/auth/forgot-password', emailLimiter, verifyHcaptcha, async (req, res) => {
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

      const resetToken = await issueEmailToken(user.id, 'reset', RESET_TOKEN_TTL_MS);
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
    const hashedPassword = await bcrypt.hash(password, 12);

    // Transaction : consommer le token (une seule fois), changer le mot de passe,
    // révoquer les sessions et invalider les access tokens déjà émis.
    const applied = await withTransaction(getPool(), async (client) => {
      const used = await client.query(
        'UPDATE email_tokens SET used_at = NOW() WHERE id = $1 AND used_at IS NULL',
        [tokenId]
      );
      if (used.rowCount === 0) return false;
      await client.query(
        'UPDATE users SET password = $1, failed_login_count = 0, locked_until = NULL, token_version = token_version + 1 WHERE id = $2',
        [hashedPassword, userId]
      );
      await client.query(
        'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
        [userId]
      );
      return true;
    });
    if (!applied) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    res.json({ message: 'Mot de passe réinitialisé avec succès. Vous pouvez maintenant vous connecter.' });
  }));

  return router;
};
