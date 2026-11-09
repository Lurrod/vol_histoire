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
// Algorithme imposé à la vérification : un jeton signé autrement (HS512, none,
// RS256 si une clé asymétrique apparaissait un jour) est refusé d'office.
const JWT_ALGORITHM = 'HS256';
const JWT_VERIFY_OPTIONS = Object.freeze({ algorithms: [JWT_ALGORITHM] });
const REFRESH_TOKEN_EXPIRY = '7d';
const REFRESH_COOKIE_NAME = 'refreshToken';
const REFRESH_COOKIE_MAX_AGE = 7 * 24 * 60 * 60 * 1000; // 7 jours en ms

// Le claim `tv` (token_version) lie le jeton à l'état du compte : chaque
// changement de rôle, d'email ou de mot de passe incrémente users.token_version,
// et authorize() refuse tout jeton émis avant (voir bumpTokenVersion).
function generateAccessToken(user) {
  return jwt.sign(
    { id: user.id, name: user.name, role: user.role_id ?? user.role, email: user.email, tv: Number(user.token_version) || 0 },
    process.env.JWT_SECRET,
    { algorithm: JWT_ALGORITHM, expiresIn: ACCESS_TOKEN_EXPIRY }
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
    { algorithm: JWT_ALGORITHM, expiresIn: REFRESH_TOKEN_EXPIRY }
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
 * État d'un refresh token en base :
 *   - 'valid'   : existe, non révoqué, non expiré
 *   - 'reused'  : déjà remplacé par rotation — un jeton rotaté qui revient est
 *                 un rejeu (vol probable), le caller doit révoquer toute la session
 *   - 'revoked' : révoqué hors rotation (déconnexion, changement de mot de
 *                 passe, action admin) — refus simple, sans révocation en cascade
 *   - 'expired' : existe, non révoqué, expiré
 *   - 'unknown' : absent (purgé après expiration, ou jamais émis)
 * @returns {Promise<{ state: 'valid'|'reused'|'revoked'|'expired'|'unknown', userId?: number }>}
 */
async function getRefreshTokenState(jti) {
  const result = await pool.query(
    'SELECT user_id, revoked, rotated_at, expires_at > NOW() AS live FROM refresh_tokens WHERE jti = $1',
    [jti]
  );
  if (result.rows.length === 0) return { state: 'unknown' };
  const row = result.rows[0];
  if (row.revoked) return { state: row.rotated_at ? 'reused' : 'revoked', userId: row.user_id };
  return { state: row.live ? 'valid' : 'expired', userId: row.user_id };
}

/**
 * Vérifie qu'un refresh token est valide en base (existe, non révoqué, non expiré).
 */
async function isRefreshTokenValid(jti) {
  return (await getRefreshTokenState(jti)).state === 'valid';
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
      'UPDATE refresh_tokens SET revoked = TRUE, rotated_at = NOW() WHERE jti = $1 AND revoked = FALSE',
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
 * Incrémente users.token_version : tous les access tokens déjà émis pour ce
 * compte cessent d'être acceptés par authorize(). À appeler dans la même
 * transaction que la révocation des refresh tokens.
 * @param {{ query: Function }} client - client de transaction (ou pool)
 */
async function bumpTokenVersion(client, userId) {
  const result = await client.query(
    'UPDATE users SET token_version = token_version + 1 WHERE id = $1 RETURNING token_version',
    [userId]
  );
  return result.rows[0] ? Number(result.rows[0].token_version) : null;
}

/**
 * Supprime les tokens expirés de la base (nettoyage périodique).
 * Les tokens révoqués mais non expirés sont CONSERVÉS : c'est leur présence
 * qui permet de reconnaître un rejeu (getRefreshTokenState → 'reused').
 */
async function cleanupExpiredTokens() {
  await pool.query(
    'DELETE FROM refresh_tokens WHERE expires_at < NOW()'
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

// Témoin de session lisible par le JS. Le refresh token reste httpOnly — donc
// invisible au script — ce qui obligeait le front à tenter un /api/refresh à
// l'aveugle sur chaque page : pour un visiteur anonyme, cela produisait un 401
// journalisé en console à chaque chargement. Ce cookie ne porte aucune donnée
// exploitable : il dit seulement « une session existe », et permet au front de
// ne demander le rafraîchissement que lorsqu'il a une chance d'aboutir.
const SESSION_HINT_COOKIE = 'vh_session';

function setRefreshCookie(res, token) {
  res.cookie(REFRESH_COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: REFRESH_COOKIE_MAX_AGE,
    path: '/api',
  });
  res.cookie(SESSION_HINT_COOKIE, '1', {
    httpOnly: false, // lu par frontend/js/auth.js — volontaire
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: REFRESH_COOKIE_MAX_AGE,
    path: '/',
  });
}

function clearRefreshCookie(res) {
  res.clearCookie(REFRESH_COOKIE_NAME, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    path: '/api',
  });
  res.clearCookie(SESSION_HINT_COOKIE, {
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    path: '/',
  });
}

// -----------------------------------------------------------------------------
// Auth: middleware d'autorisation
// -----------------------------------------------------------------------------
// État courant du compte (rôle + version de jeton), relu à chaque requête
// authentifiée : un jeton émis avant une rétrogradation, un changement de mot
// de passe ou une suppression ne doit plus rien autoriser. Remplaçable pour les
// tests (setAuthStateLoader) ; passer null rétablit la lecture en base.
async function defaultAuthStateLoader(userId) {
  const result = await pool.query('SELECT role_id, token_version FROM users WHERE id = $1', [userId]);
  return result.rows[0] || null;
}
let loadAuthState = defaultAuthStateLoader;
function setAuthStateLoader(fn) { loadAuthState = fn || defaultAuthStateLoader; }

const authorize = (roles) => {
  return async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(403).json({ message: 'Accès interdit' });

    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET, JWT_VERIFY_OPTIONS);
    } catch (error) {
      // Distinguer token expiré vs token invalide
      if (error.name === 'TokenExpiredError') {
        return res.status(401).json({ message: 'Token expiré', code: 'TOKEN_EXPIRED' });
      }
      return res.status(401).json({ message: 'Token invalide', code: 'TOKEN_INVALID' });
    }

    try {
      const state = await loadAuthState(decoded.id);
      if (!state || Number(state.token_version) !== (Number(decoded.tv) || 0)) {
        return res.status(401).json({ message: 'Session révoquée', code: 'TOKEN_REVOKED' });
      }
      // Le rôle fait foi en base, pas dans le jeton.
      const currentRole = Number(state.role_id);
      if (!roles.includes(currentRole)) {
        return res.status(403).json({ message: 'Accès non autorisé' });
      }
      req.user = { ...decoded, role: currentRole };
      next();
    } catch (err) {
      next(err);
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
  JWT_VERIFY_OPTIONS,
  generateAccessToken,
  generateRefreshToken,
  storeRefreshToken,
  getRefreshTokenState,
  isRefreshTokenValid,
  bumpTokenVersion,
  setAuthStateLoader,
  revokeRefreshToken,
  rotateRefreshToken,
  revokeAllUserRefreshTokens,
  cleanupExpiredTokens,
  cleanupUnverifiedUsers,
  setRefreshCookie,
  clearRefreshCookie,
  SESSION_HINT_COOKIE,
  authorize,
  isOwnerOrAdmin,
};
