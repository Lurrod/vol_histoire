const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const logger = require('../logger');
const { withTransaction } = require('../db');
const asyncHandler = require('../middleware/asyncHandler');
const verifyHcaptcha = require('../middleware/hcaptcha');
const usersRepo = require('../repositories/users');
const emailTokensRepo = require('../repositories/email-tokens');
const refreshTokensRepo = require('../repositories/refresh-tokens');
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
    await withTransaction(getPool(), (client) =>
      emailTokensRepo.replaceOpen(client, { userId, type, token, expiresAt, newEmail })
    );
    return token;
  }

  /**
   * Révocation de toutes les sessions après un rejeu de refresh token.
   * C'est le moment précis où une compromission est suspectée : un échec ne
   * peut pas passer en silence. Une seconde tentative absorbe un incident
   * passager (connexion perdue, timeout) ; si elle échoue aussi, l'échec est
   * journalisé en erreur (donc remonté à Sentry) avec l'utilisateur concerné.
   * La réponse au client reste 401 REFRESH_REPLAY : son cookie est effacé dans
   * tous les cas, et un code distinct n'apprendrait rien d'utile à un attaquant.
   */
  async function revokeAllAfterReplay(userId, jti) {
    try {
      await revokeAllUserRefreshTokens(userId);
    } catch {
      try {
        await revokeAllUserRefreshTokens(userId);
      } catch (err) {
        logger.error('Échec de la révocation des sessions après rejeu de refresh token', {
          error: err, userId, jti, route: 'POST /refresh',
        });
      }
    }
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

    const existing = await usersRepo.findRegistrationState(getPool(), email);
    const hashedPassword = await bcrypt.hash(password, 12);

    // Anti-énumération : réponse identique, envoyée AVANT tout travail qui
    // dépend de l'existence du compte (transaction, envoi SMTP). Sinon le délai
    // de l'envoi trahirait les adresses non inscrites.
    res.status(201).json({ message: 'Compte créé. Vérifiez votre boîte email pour activer votre compte.' });

    try {
      if (existing && existing.email_verified) return;

      let userId;
      if (existing) {
        // Compte non vérifié déjà présent : le mot de passe actif sera choisi
        // au moment de la vérification par le titulaire de la boîte (voir
        // POST /auth/verify-email) ; on envoie simplement un nouveau lien.
        userId = existing.id;
        await usersRepo.renameUnverified(getPool(), userId, name);
      } else {
        userId = await usersRepo.insert(getPool(), { name, email, passwordHash: hashedPassword, roleId: 3 });
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

    const userData = await usersRepo.findForLogin(getPool(), email);

    // Anti timing-attack : bcrypt.compare est toujours exécuté, même si
    // l'utilisateur n'existe pas, pour garantir un temps de réponse constant.
    const DUMMY_HASH = '$2a$12$mPEeg.GN9eKdtN4Hd23tve9R3aTnsNjlXIz9.tO5hM2ZU1EPP3BvC';
    const storedHash = userData ? userData.password : DUMMY_HASH;
    const validPassword = await bcrypt.compare(password, storedHash);

    // Compte verrouillé : message générique pour ne pas leaker l'existence
    // d'un compte (user enumeration). Même status/message qu'un mdp incorrect
    // côté client, mais on log le blocage côté serveur.
    if (userData && userData.locked_until && new Date(userData.locked_until) > new Date()) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    if (!userData || !validPassword) {
      // Incrément du compteur d'échecs si le compte existe (atomique en SQL,
      // voir usersRepo.recordFailedLogin). Au seuil : verrouillage du compte
      // pour LOCKOUT_DURATION_MIN minutes. On ne révèle pas au client qu'un
      // compte existe : 400 générique dans tous les cas.
      if (userData) {
        await usersRepo.recordFailedLogin(getPool(), userData.id, {
          maxAttempts: LOCKOUT_MAX_ATTEMPTS, lockMinutes: LOCKOUT_DURATION_MIN,
        });
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
      await usersRepo.resetFailedLogins(getPool(), userData.id);
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
        await revokeAllAfterReplay(tokenState.userId, decoded.jti);
        clearRefreshCookie(res);
        return res.status(401).json({ message: 'Session compromise', code: 'REFRESH_REPLAY' });
      }
      if (tokenState.state !== 'valid') {
        clearRefreshCookie(res);
        return res.status(401).json({ message: 'Refresh token révoqué ou invalide', code: 'REFRESH_REVOKED' });
      }

      // Récupérer les données fraîches de l'utilisateur en DB
      const user = await usersRepo.findSessionUser(getPool(), decoded.id);
      if (!user) {
        clearRefreshCookie(res);
        await revokeRefreshToken(decoded.jti);
        return res.status(401).json({ message: 'Utilisateur introuvable', code: 'USER_NOT_FOUND' });
      }

      // Rotation atomique (BEGIN/COMMIT) : révocation ancienne + insertion
      // nouvelle dans la même transaction. Protège contre :
      //   - Crash entre les 2 étapes (session orpheline ou double-active)
      //   - Race condition 2 requêtes concurrentes de /refresh avec le même JTI
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
          await revokeAllAfterReplay(user.id, decoded.jti);
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
      const consumed = await emailTokensRepo.consume(client, token, 'verify');
      if (!consumed) return null;
      await usersRepo.activateWithPassword(client, consumed.user_id, hashedPassword);
      await emailTokensRepo.closeOpen(client, consumed.user_id, 'verify');
      await refreshTokensRepo.revokeAllForUser(client, consumed.user_id);
      return consumed.user_id;
    });
    if (!userId) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    // Envoi de l'email de bienvenue (non bloquant)
    try {
      const contact = await usersRepo.findContact(getPool(), userId);
      if (contact) {
        const { name, email } = contact;
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
        const consumed = await emailTokensRepo.consume(client, token, 'email');
        if (!consumed || !consumed.new_email) return false;
        await usersRepo.applyEmailChange(client, consumed.user_id, consumed.new_email);
        await refreshTokensRepo.revokeAllForUser(client, consumed.user_id);
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
      const user = await usersRepo.findMailRecipient(getPool(), email);
      if (!user || user.email_verified) return;

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
      const user = await usersRepo.findMailRecipient(getPool(), email);
      if (!user || !user.email_verified) return;

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

    const resetToken = await emailTokensRepo.findOpenReset(getPool(), token);
    if (!resetToken) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    const { id: tokenId, user_id: userId } = resetToken;
    const hashedPassword = await bcrypt.hash(password, 12);

    // Transaction : consommer le token (une seule fois), changer le mot de passe,
    // révoquer les sessions et invalider les access tokens déjà émis.
    const applied = await withTransaction(getPool(), async (client) => {
      if (!(await emailTokensRepo.markUsed(client, tokenId))) return false;
      await usersRepo.resetPassword(client, userId, hashedPassword);
      await refreshTokensRepo.revokeAllForUser(client, userId);
      return true;
    });
    if (!applied) {
      return res.status(400).json({ message: 'Token invalide ou expiré', code: 'TOKEN_INVALID' });
    }

    res.json({ message: 'Mot de passe réinitialisé avec succès. Vous pouvez maintenant vous connecter.' });
  }));

  return router;
};
