const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { isValidEmail, isValidName, isValidPassword } = require('../validators');
const logger = require('../logger');
const { withTransaction } = require('../db');
const { LOCKOUT_MAX_ATTEMPTS, LOCKOUT_DURATION_MIN } = require('../utils/lockout');
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
  setRefreshCookie,
  isPersistentRefresh,
  clearRefreshCookie,
  REFRESH_COOKIE_NAME,
  JWT_VERIFY_OPTIONS,
  authorize,
} = require('../middleware/auth');

const passThrough = (req, res, next) => next();

module.exports = function createAuthRouter(getPool, { registerLimiter, loginLimiter, emailLimiter, refreshLimiter, codeLimiter, sessionsLimiter = passThrough, mailer }) {
  const router = express.Router();

  // Durées de validité des codes envoyés par email (rappelées dans les emails).
  const VERIFY_CODE_TTL_MS = 30 * 60 * 1000;
  const RESET_CODE_TTL_MS = 15 * 60 * 1000;
  const CODE_TYPES = ['verify', 'reset'];
  const INVALID_CODE = { message: 'Code invalide ou expiré', code: 'CODE_INVALID' };
  const PASSWORD_RULE = 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)';

  /**
   * Remplace le code ouvert du même type pour l'utilisateur par un nouveau.
   * @returns {Promise<string>} le code à 6 chiffres (en clair, pour l'email)
   */
  async function issueEmailCode(userId, type, ttlMs) {
    const code = emailTokensRepo.generateCode();
    const expiresAt = new Date(Date.now() + ttlMs);
    await withTransaction(getPool(), (client) =>
      emailTokensRepo.replaceOpen(client, { userId, type, code, expiresAt })
    );
    return code;
  }

  function normalizeEmail(value) {
    return typeof value === 'string' ? value.trim().toLowerCase() : null;
  }

  /**
   * Compte concerné par un code : 'verify' vise un compte pas encore activé,
   * 'reset' un compte activé. null sinon (même réponse qu'un code faux).
   */
  async function findCodeOwner(email, type) {
    if (!email || !isValidEmail(email)) return null;
    const user = await usersRepo.findMailRecipient(getPool(), email);
    if (!user) return null;
    if (type === 'verify' && user.email_verified) return null;
    if (type === 'reset' && !user.email_verified) return null;
    return user;
  }

  /**
   * Révocation de toutes les sessions après un rejeu de refresh token.
   * C'est le moment précis où une compromission est suspectée : un échec ne
   * peut pas passer en silence. Une seconde tentative absorbe un incident
   * passager (connexion perdue, timeout) ; si elle échoue aussi, l'échec est
   * journalisé en erreur (donc remonté à Sentry) avec l'utilisateur concerné.
   * La réponse au client reste 401 REFRESH_REPLAY : son cookie est effacé dans
   * tous les cas, et un code distinct n'apprendrait rien d'utile à un attaquant.
   *
   * Comme « Se déconnecter de tous les appareils » (SEC-002) : révoquer les
   * refresh tokens ne suffit pas, l'access token obtenu par le voleur lors de
   * sa rotation resterait valide jusqu'à expiration. L'incrément de
   * token_version, dans la même transaction, le fait refuser par authorize().
   */
  function revokeAllSessions(userId) {
    return withTransaction(getPool(), async (client) => {
      await refreshTokensRepo.revokeAllForUser(client, userId);
      await usersRepo.bumpTokenVersion(client, userId);
    });
  }

  async function revokeAllAfterReplay(userId, jti) {
    try {
      await revokeAllSessions(userId);
    } catch {
      try {
        await revokeAllSessions(userId);
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
    const { name } = req.body;
    const email = typeof req.body.email === 'string' ? req.body.email.trim().toLowerCase() : req.body.email;

    if (!name || !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }

    // Plus de mot de passe à l'inscription : le titulaire de la boîte le
    // choisit en saisissant son code (POST /auth/verify-email). Le compte
    // reçoit d'ici là un mot de passe aléatoire que personne ne connaît.
    const existing = await usersRepo.findRegistrationState(getPool(), email);
    const hashedPassword = await bcrypt.hash(crypto.randomBytes(32).toString('hex'), 12);

    // Anti-énumération : réponse identique, envoyée AVANT tout travail qui
    // dépend de l'existence du compte (transaction, envoi SMTP). Sinon le délai
    // de l'envoi trahirait les adresses non inscrites.
    res.status(201).json({ message: 'Compte créé. Un code d\'activation vient d\'être envoyé par email.' });

    try {
      // Adresse déjà inscrite et vérifiée : aucun compte ni jeton, mais le
      // titulaire est prévenu (avec son propre nom, pas celui du formulaire).
      if (existing && existing.email_verified) {
        await mailer.sendAccountExistsNotice(email, existing.name);
        return;
      }

      let userId;
      if (existing) {
        // Compte non vérifié déjà présent : on envoie simplement un nouveau
        // code (le précédent est remplacé).
        userId = existing.id;
        await usersRepo.renameUnverified(getPool(), userId, name);
      } else {
        userId = await usersRepo.insert(getPool(), { name, email, passwordHash: hashedPassword, roleId: 3 });
      }

      const verifyCode = await issueEmailCode(userId, 'verify', VERIFY_CODE_TTL_MS);
      try {
        await mailer.sendVerificationEmail(email, verifyCode);
      } catch (mailErr) {
        logger.warn('Premier envoi email échoué, retry...', { error: mailErr.message });
        await mailer.sendVerificationEmail(email, verifyCode);
      }
    } catch (err) {
      logger.error('Erreur inscription (après réponse)', { error: err.message, route: 'POST /register' });
    }
  }));

  // Lockout par compte — défense contre credential-stuffing distribué
  // (rate-limit IP insuffisant si botnet). Constantes volontairement
  // conservatrices : un user qui oublie son mdp a 10 essais avant blocage.

  // Trois barrages : limiteur par IP (20 requêtes / 15 min, posé en premier
  // pour compter aussi les envois sans jeton), hCaptcha invisible (bourrage
  // d'identifiants automatisé, réparti sur de nombreuses IP), puis verrou par
  // compte (LOCKOUT_MAX_ATTEMPTS échecs → LOCKOUT_DURATION_MIN minutes).
  router.post('/login', loginLimiter, verifyHcaptcha, asyncHandler(async (req, res) => {
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

    // Compte inconnu, mot de passe faux ou compte NON ACTIVÉ : même 400
    // générique. Un 403 EMAIL_NOT_VERIFIED, même réservé au bon mot de passe,
    // était un oracle combiné à l'inscription : s'inscrire sur une adresse avec
    // P puis se connecter avec P répondait 403 si l'adresse était libre (le
    // compte venait d'être créé avec P), 400 si elle existait déjà. Le mot de
    // passe actif se choisit de toute façon à l'activation (/auth/verify-email).
    if (!userData || !validPassword || !userData.email_verified) {
      // Incrément du compteur d'échecs si le compte existe et que le mot de
      // passe est faux (atomique en SQL, voir usersRepo.recordFailedLogin).
      // Au seuil : verrouillage du compte pour LOCKOUT_DURATION_MIN minutes.
      if (userData && !validPassword) {
        await usersRepo.recordFailedLogin(getPool(), userData.id, {
          maxAttempts: LOCKOUT_MAX_ATTEMPTS, lockMinutes: LOCKOUT_DURATION_MIN,
        });
      }
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    // Login réussi : reset compteur + lockout
    if (userData.failed_login_count > 0 || userData.locked_until) {
      await usersRepo.resetFailedLogins(getPool(), userData.id);
    }

    const accessToken = generateAccessToken(userData);
    // « Se souvenir de moi » (CONT-002) : absent = persistant (clients de l'API).
    const persistent = req.body.remember !== false;
    const { token: refreshToken, jti } = generateRefreshToken(userData, { persistent });

    // Stocker le refresh token en base pour pouvoir le révoquer
    await storeRefreshToken(jti, userData.id);

    setRefreshCookie(res, refreshToken, { persistent });

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
      // La rotation garde le choix fait à la connexion (cookies de session ou non).
      const persistent = isPersistentRefresh(decoded);
      const { token: newRefreshToken, jti: newJti } = generateRefreshToken(user, { persistent });

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

      setRefreshCookie(res, newRefreshToken, { persistent });
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

  // POST /api/auth/logout-all — « Se déconnecter de tous les appareils ».
  // Dans une transaction : révocation de tous les refresh tokens du compte et
  // incrément de token_version, qui fait refuser par authorize() tout access
  // token déjà émis, y compris celui de cette requête. Le cookie de ce
  // navigateur est effacé : il faut se reconnecter partout.
  router.post('/auth/logout-all', sessionsLimiter, authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const userId = Number(req.user.id);
    await withTransaction(getPool(), async (client) => {
      await refreshTokensRepo.revokeAllForUser(client, userId);
      await usersRepo.bumpTokenVersion(client, userId);
    });
    logger.info('Déconnexion de tous les appareils', { userId, route: 'POST /auth/logout-all' });
    clearRefreshCookie(res);
    res.json({ message: 'Toutes les sessions ont été fermées' });
  }));

  // -----------------------------------------------------------------------------
  // Auth : vérification email + mot de passe oublié
  // -----------------------------------------------------------------------------

  // POST /api/auth/check-code { email, type, code } — Étape « code » de la
  // page de connexion, avant le choix du mot de passe : le code est vérifié
  // sans être consommé. Un code faux compte un essai (plafond par code).
  // Réponse identique pour un compte inconnu, un code expiré ou faux.
  router.post('/auth/check-code', codeLimiter, asyncHandler(async (req, res) => {
    const { type, code } = req.body;
    if (!CODE_TYPES.includes(type)) {
      return res.status(400).json({ message: 'Type de code invalide' });
    }
    const user = await findCodeOwner(normalizeEmail(req.body.email), type);
    const result = user
      ? await withTransaction(getPool(), (client) =>
        emailTokensRepo.checkCode(client, { userId: user.id, type, code }))
      : { ok: false };
    if (!result.ok) return res.status(400).json(INVALID_CODE);
    res.json({ message: 'Code valide' });
  }));

  // POST /api/auth/verify-email { email, code, password } — Activer le compte.
  // Le titulaire de la boîte choisit ici le mot de passe actif : personne
  // d'autre ne le connaît, même si un tiers a inscrit son adresse.
  router.post('/auth/verify-email', codeLimiter, asyncHandler(async (req, res) => {
    const { code, password } = req.body;
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: PASSWORD_RULE });
    }
    // Haché avant de chercher le compte (SEC-001) : sinon une adresse
    // inconnue répondait aussitôt et une adresse inscrite après le bcrypt
    // (plusieurs centaines de ms), ce qui trahissait l'existence du compte.
    const hashedPassword = await bcrypt.hash(password, 12);
    const email = normalizeEmail(req.body.email);
    const user = await findCodeOwner(email, 'verify');
    if (!user) return res.status(400).json(INVALID_CODE);

    const activated = await withTransaction(getPool(), async (client) => {
      const result = await emailTokensRepo.checkCode(client, { userId: user.id, type: 'verify', code, consume: true });
      if (!result.ok) return false;
      await usersRepo.activateWithPassword(client, user.id, hashedPassword);
      await refreshTokensRepo.revokeAllForUser(client, user.id);
      return true;
    });
    if (!activated) return res.status(400).json(INVALID_CODE);

    // Email de bienvenue (non bloquant) : le compte est activé, un échec
    // d'envoi, immédiat ou différé, ne doit pas changer la réponse.
    try {
      mailer.sendWelcomeEmail(email, user.name).catch(err =>
        logger.warn('Échec envoi email bienvenue', { error: err.message, userId: user.id })
      );
    } catch (err) {
      logger.warn('Échec envoi email bienvenue', { error: err.message, userId: user.id });
    }

    res.json({ message: 'Compte activé. Vous pouvez maintenant vous connecter.' });
  }));

  // POST /api/auth/confirm-email-change { code } — Appliquer un changement
  // d'adresse demandé depuis les paramètres. Le code n'est envoyé qu'à la
  // nouvelle adresse : le saisir prouve qu'on la contrôle. Session requise :
  // le code appartient au compte connecté.
  router.post('/auth/confirm-email-change', codeLimiter, authorize([1, 2, 3]), async (req, res) => {
    const userId = req.user.id;
    try {
      const newEmail = await withTransaction(getPool(), async (client) => {
        const result = await emailTokensRepo.checkCode(client, { userId, type: 'email', code: req.body.code, consume: true });
        if (!result.ok || !result.new_email) return null;
        await usersRepo.applyEmailChange(client, userId, result.new_email);
        await refreshTokensRepo.revokeAllForUser(client, userId);
        return result.new_email;
      });
      if (!newEmail) return res.status(400).json(INVALID_CODE);
      res.json({ message: 'Adresse email modifiée. Reconnectez-vous avec votre nouvelle adresse.', email: newEmail });
    } catch (error) {
      // Adresse prise entre la demande et la confirmation : seul le titulaire
      // de la nouvelle boîte (qui a reçu le code) voit ce message.
      if (error.code === '23505') {
        return res.status(409).json({ message: 'Cette adresse est déjà utilisée par un autre compte', code: 'EMAIL_TAKEN' });
      }
      const entry = logger.error('Erreur confirmation changement email', { error: error.message, route: 'POST /auth/confirm-email-change' });
      res.status(500).json({ message: 'Erreur interne du serveur', errorId: entry.errorId });
    }
  });

  // POST /api/auth/resend-verification — Renvoyer un code d'activation
  // try/catch manuel : la réponse est envoyée avant le traitement async (sécurité)
  router.post('/auth/resend-verification', emailLimiter, async (req, res) => {
    const email = normalizeEmail(req.body.email);
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }

    // Réponse identique quelle que soit l'existence du compte (sécurité)
    res.json({ message: 'Si un compte non activé existe, un code vient d\'être envoyé.' });

    try {
      const user = await findCodeOwner(email, 'verify');
      if (!user) return;
      const verifyCode = await issueEmailCode(user.id, 'verify', VERIFY_CODE_TTL_MS);
      await mailer.sendVerificationEmail(email, verifyCode);
    } catch (err) {
      logger.error('Erreur resend-verification', { error: err.message, route: 'POST /resend-verification' });
    }
  });

  // POST /api/auth/forgot-password — Demander un code de réinitialisation
  // try/catch manuel : même pattern que resend-verification
  router.post('/auth/forgot-password', emailLimiter, verifyHcaptcha, async (req, res) => {
    const email = normalizeEmail(req.body.email);
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }

    // Réponse identique quelle que soit l'existence du compte (sécurité)
    res.json({ message: 'Si un compte existe, un code de réinitialisation vient d\'être envoyé.' });

    try {
      const user = await findCodeOwner(email, 'reset');
      if (!user) return;
      const resetCode = await issueEmailCode(user.id, 'reset', RESET_CODE_TTL_MS);
      await mailer.sendPasswordResetEmail(email, user.name, resetCode);
    } catch (err) {
      logger.error('Erreur forgot-password', { error: err.message, route: 'POST /forgot-password' });
    }
  });

  // POST /api/auth/reset-password { email, code, password } — Nouveau mot de
  // passe. Toutes les sessions sont coupées, les access tokens déjà émis
  // refusés (token_version).
  router.post('/auth/reset-password', codeLimiter, asyncHandler(async (req, res) => {
    const { code, password } = req.body;
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: PASSWORD_RULE });
    }
    // Même travail que l'adresse corresponde ou non à un compte (SEC-001).
    const hashedPassword = await bcrypt.hash(password, 12);
    const user = await findCodeOwner(normalizeEmail(req.body.email), 'reset');
    if (!user) return res.status(400).json(INVALID_CODE);

    const applied = await withTransaction(getPool(), async (client) => {
      const result = await emailTokensRepo.checkCode(client, { userId: user.id, type: 'reset', code, consume: true });
      if (!result.ok) return false;
      await usersRepo.resetPassword(client, user.id, hashedPassword);
      await refreshTokensRepo.revokeAllForUser(client, user.id);
      return true;
    });
    if (!applied) return res.status(400).json(INVALID_CODE);

    res.json({ message: 'Mot de passe réinitialisé. Vous pouvez maintenant vous connecter.' });
  }));

  return router;
};
