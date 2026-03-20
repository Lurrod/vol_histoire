/**
 * auth.js — Module d'authentification partagé pour Vol d'Histoire
 *
 * Gère :
 *  - Stockage du access token (localStorage)
 *  - Refresh automatique via cookie HttpOnly quand le token expire
 *  - authFetch() : wrapper de fetch() qui gère le refresh transparent
 *  - Logout propre (API + nettoyage local)
 *  - Détection de session expirée
 *
 * Usage :
 *   const res = await authFetch('/api/favorites');
 *   const data = await res.json();
 */

const auth = (() => {
  const TOKEN_KEY = 'token';
  const USER_KEY = 'user';
  let isRefreshing = false;
  let refreshQueue = [];

  // ========== Token helpers ==========

  function getToken() {
    return localStorage.getItem(TOKEN_KEY);
  }

  function setToken(token) {
    localStorage.setItem(TOKEN_KEY, token);
  }

  function clearSession() {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(USER_KEY);
  }

  function getPayload() {
    const token = getToken();
    if (!token) return null;
    try {
      return JSON.parse(atob(token.split('.')[1]));
    } catch {
      return null;
    }
  }

  function isTokenExpired() {
    const payload = getPayload();
    if (!payload || !payload.exp) return true;
    // Considérer expiré 30s avant la vraie expiration
    return Date.now() >= (payload.exp * 1000) - 30000;
  }

  // ========== Refresh logic ==========

  async function refreshAccessToken() {
    try {
      const response = await fetch('/api/refresh', {
        method: 'POST',
        credentials: 'include', // Envoie le cookie refreshToken
      });

      if (!response.ok) {
        throw new Error('Refresh failed');
      }

      const data = await response.json();
      setToken(data.token);
      return data.token;
    } catch (error) {
      clearSession();
      throw error;
    }
  }

  // Refresh avec file d'attente (évite les appels parallèles)
  function queuedRefresh() {
    if (isRefreshing) {
      return new Promise((resolve, reject) => {
        refreshQueue.push({ resolve, reject });
      });
    }

    isRefreshing = true;

    return refreshAccessToken()
      .then((token) => {
        refreshQueue.forEach(({ resolve }) => resolve(token));
        refreshQueue = [];
        return token;
      })
      .catch((err) => {
        refreshQueue.forEach(({ reject }) => reject(err));
        refreshQueue = [];
        throw err;
      })
      .finally(() => {
        isRefreshing = false;
      });
  }

  // ========== authFetch — le wrapper principal ==========

  async function authFetch(url, options = {}) {
    let token = getToken();

    // Si le token est sur le point d'expirer, refresh proactivement
    if (token && isTokenExpired()) {
      try {
        token = await queuedRefresh();
      } catch {
        // Refresh échoué, on continue sans token (la requête échouera en 401)
        token = null;
      }
    }

    // Construire les headers
    const headers = { ...options.headers };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    // Premier essai
    let response = await fetch(url, { ...options, headers, credentials: 'include' });

    // Si 401 avec TOKEN_EXPIRED, tenter un refresh + retry
    if (response.status === 401) {
      try {
        const errorData = await response.clone().json();
        if (errorData.code === 'TOKEN_EXPIRED' || errorData.code === 'TOKEN_INVALID') {
          const newToken = await queuedRefresh();
          headers['Authorization'] = `Bearer ${newToken}`;
          response = await fetch(url, { ...options, headers, credentials: 'include' });
        }
      } catch {
        // Refresh échoué — session terminée
        clearSession();
      }
    }

    return response;
  }

  // ========== Logout ==========

  async function logout() {
    try {
      await fetch('/api/logout', {
        method: 'POST',
        credentials: 'include',
      });
    } catch {
      // Silencieux — on nettoie quand même
    }
    clearSession();
  }

  // ========== Public API ==========

  return {
    getToken,
    setToken,
    getPayload,
    clearSession,
    isTokenExpired,
    authFetch,
    logout,
  };
})();
