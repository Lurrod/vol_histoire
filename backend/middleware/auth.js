const jwt = require('jsonwebtoken');
const crypto = require('crypto');

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

module.exports = {
  setPool,
  REFRESH_COOKIE_NAME,
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  isRefreshTokenValid,
  revokeRefreshToken,
  revokeAllUserRefreshTokens,
  cleanupExpiredTokens,
  setRefreshCookie,
  clearRefreshCookie,
  authorize,
};
