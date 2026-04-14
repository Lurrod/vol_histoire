const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { withTransaction } = require('../db');

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injecté depuis app.js via setPool)
// -----------------------------------------------------------------------------
let pool;
function setPool(p) { pool = p; }

// -----------------------------------------------------------------------------
// Auth: helpers JWT
// -----------------------------------------------------------------------------
const ACCESS_TOKEN_EXPIRY = '15m';
const REFRESH_TOKEN_EXPIRY = '7d';
const REFRESH_COOKIE_NAME = 'refreshToken';
const REFRESH_COOKIE_MAX_AGE = 7 * 24 * 60 * 60 * 1000; // 7 jours en ms

function generateAccessToken(user) {
  return jwt.sign(
    { id: user.id, name: user.name, role: user.role_id ?? user.role, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: ACCESS_TOKEN_EXPIRY }
  );
}

/**
 * Génère un refresh token avec un identifiant unique (jti) pour la révocation.
 * Retourne un objet { token, jti } — le jti doit être stocké en base.
 */
function generateRefreshToken(user) {
  const jti = crypto.randomUUID();
  const token = jwt.sign(
    { id: user.id, role: user.role_id ?? user.role, jti },
    process.env.REFRESH_SECRET,
    { expiresIn: REFRESH_TOKEN_EXPIRY }
  );
  return { token, jti };
}

// -----------------------------------------------------------------------------
// Refresh tokens : gestion en base de données (table refresh_tokens)
// -----------------------------------------------------------------------------

/**
 * Stocke un refresh token en base pour pouvoir le révoquer plus tard.
 */
async function storeRefreshToken(jti, userId) {
  const expiresAt = new Date(Date.now() + REFRESH_COOKIE_MAX_AGE);
  await pool.query(
    'INSERT INTO refresh_tokens (jti, user_id, expires_at) VALUES ($1, $2, $3)',
    [jti, userId, expiresAt]
  );
}

/**
 * Vérifie qu'un refresh token est valide en base (existe, non révoqué, non expiré).
 */
async function isRefreshTokenValid(jti) {
  const result = await pool.query(
    'SELECT 1 FROM refresh_tokens WHERE jti = $1 AND revoked = FALSE AND expires_at > NOW()',
    [jti]
  );
  return result.rows.length > 0;
}

/**
 * Révoque un refresh token spécifique (logout).
 */
async function revokeRefreshToken(jti) {
  await pool.query(
    'UPDATE refresh_tokens SET revoked = TRUE WHERE jti = $1',
    [jti]
  );
}

/**
 * Rotation atomique : révoque l'ancien refresh token ET insère le nouveau dans
 * une même transaction Postgres (BEGIN/COMMIT). Garantit qu'un crash ou une
 * erreur entre les deux étapes laisse la base dans un état cohérent (pas de
 * double session active, pas de session orpheline).
 *
 * Bonus sécurité : si le UPDATE révoque 0 ligne (token déjà révoqué ou absent),
 * on assume un replay attack et on throw `REFRESH_REPLAY`. Le caller doit
 * alors révoquer toutes les sessions de l'utilisateur (défense en profondeur).
 *
 * @throws {Error & { code: 'REFRESH_REPLAY' }} si l'ancien jti était déjà révoqué
 */
async function rotateRefreshToken(oldJti, newJti, userId) {
  const expiresAt = new Date(Date.now() + REFRESH_COOKIE_MAX_AGE);
  return withTransaction(pool, async (client) => {
    const revokeResult = await client.query(
      'UPDATE refresh_tokens SET revoked = TRUE WHERE jti = $1 AND revoked = FALSE',
      [oldJti]
    );
    if (revokeResult.rowCount === 0) {
      const err = new Error('Refresh token déjà rotaté (replay détecté)');
      err.code = 'REFRESH_REPLAY';
      throw err;
    }
    await client.query(
      'INSERT INTO refresh_tokens (jti, user_id, expires_at) VALUES ($1, $2, $3)',
      [newJti, userId, expiresAt]
    );
  });
}

/**
 * Révoque TOUS les refresh tokens d'un utilisateur
 * (changement de mot de passe, suppression de compte, etc.).
 */
async function revokeAllUserRefreshTokens(userId) {
  await pool.query(
    'UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND revoked = FALSE',
    [userId]
  );
}

/**
 * Supprime les tokens expirés de la base (nettoyage périodique).
 */
async function cleanupExpiredTokens() {
  await pool.query(
    'DELETE FROM refresh_tokens WHERE expires_at < NOW() OR revoked = TRUE'
  );
}

/**
 * Supprime les comptes utilisateurs non vérifiés depuis plus de 7 jours.
 * Les email_tokens associés sont supprimés en cascade via la FK ON DELETE CASCADE.
 * Retourne le nombre de comptes supprimés.
 */
async function cleanupUnverifiedUsers() {
  const result = await pool.query(
    `DELETE FROM users
     WHERE email_verified = FALSE
       AND created_at < NOW() - INTERVAL '7 days'`
  );
  return result.rowCount || 0;
}

function setRefreshCookie(res, token) {
  res.cookie(REFRESH_COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: REFRESH_COOKIE_MAX_AGE,
    path: '/api',
  });
}

function clearRefreshCookie(res) {
  res.clearCookie(REFRESH_COOKIE_NAME, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    path: '/api',
  });
}

// -----------------------------------------------------------------------------
// Auth: middleware d'autorisation
// -----------------------------------------------------------------------------
const authorize = (roles) => {
  return (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(403).json({ message: 'Accès interdit' });

    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const coercedRole = Number(decoded.role);
      if (!roles.includes(coercedRole)) {
        return res.status(403).json({ message: 'Accès non autorisé' });
      }
      req.user = { ...decoded, role: coercedRole };
      next();
    } catch (error) {
      // Distinguer token expiré vs token invalide
      if (error.name === 'TokenExpiredError') {
        return res.status(401).json({ message: 'Token expiré', code: 'TOKEN_EXPIRED' });
      }
      return res.status(401).json({ message: 'Token invalide', code: 'TOKEN_INVALID' });
    }
  };
};

/**
 * Middleware : autorise uniquement le propriétaire de la ressource ou un admin (role 1).
 * À placer APRÈS authorize([...]) pour que req.user soit déjà défini.
 * @param {string} paramName - nom du paramètre d'URL contenant l'ID utilisateur (défaut 'id')
 */
const isOwnerOrAdmin = (paramName = 'id') => (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: 'Non authentifié' });
  }
  const targetId = Number(req.params[paramName]);
  const requesterId = Number(req.user.id);
  const requesterRole = Number(req.user.role);
  if (requesterId !== targetId && requesterRole !== 1) {
    return res.status(403).json({ message: 'Accès non autorisé' });
  }
  next();
};

module.exports = {
  setPool,
  REFRESH_COOKIE_NAME,
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  isRefreshTokenValid,
  revokeRefreshToken,
  rotateRefreshToken,
  revokeAllUserRefreshTokens,
  cleanupExpiredTokens,
  cleanupUnverifiedUsers,
  setRefreshCookie,
  clearRefreshCookie,
  authorize,
  isOwnerOrAdmin,
};
