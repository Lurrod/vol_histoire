/**
 * auth.js — Module d'authentification partagé pour Vol d'Histoire
 *
 * Gère :
 *  - Stockage du access token EN MÉMOIRE uniquement (pas de localStorage)
 *  - init() : restauration silencieuse de la session via le cookie HttpOnly
 *  - authFetch() : wrapper de fetch() qui gère le refresh transparent
 *  - Logout propre (API + nettoyage local)
 *
 * Usage :
 *   await auth.init();                         // Au chargement de la page
 *   const payload = auth.getPayload();          // Infos utilisateur
 *   const res = await auth.authFetch('/api/x'); // Requête authentifiée
 */

const auth = (() => {
  let accessToken = null; // Mémoire uniquement — jamais persisté
  let userInfo = null;    // Infos utilisateur en mémoire uniquement (pas localStorage)
  let isRefreshing = false;
  let refreshQueue = [];
  let _initialized = false;
  let _initPromise = null;

  // ========== Synchronisation multi-onglets ==========
  // BroadcastChannel permet de partager le nouveau token entre onglets du même
  // domaine quand l'un d'eux effectue la rotation (évite les refreshs en double).
  const _channel = typeof BroadcastChannel !== 'undefined'
    ? new BroadcastChannel('auth_sync')
    : null;

  // Résolveur en attente d'un token diffusé par un autre onglet
  let _broadcastWaiter = null;

  if (_channel) {
    _channel.onmessage = ({ data }) => {
      if (data.type === 'refresh_done' && _broadcastWaiter) {
        _broadcastWaiter.resolve(data.token);
        _broadcastWaiter = null;
      } else if (data.type === 'logout') {
        clearSession();
      }
    };
  }

  // Attend qu'un autre onglet diffuse un token, avec timeout
  function waitForBroadcastToken(timeoutMs = 2000) {
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        _broadcastWaiter = null;
        reject(new Error('Broadcast timeout'));
      }, timeoutMs);
      _broadcastWaiter = {
        resolve: (token) => {
          clearTimeout(timer);
          resolve(token);
        },
      };
    });
  }

  // ========== Token helpers ==========

  function getToken() {
    return accessToken;
  }

  function setToken(token) {
    accessToken = token;
  }

  function clearSession() {
    accessToken = null;
    userInfo = null;
    // Nettoyage rétrocompatibilité (anciennes versions stockaient en localStorage)
    try { localStorage.removeItem('user'); } catch { /* ignore */ }
  }

  function getUserInfo() {
    if (userInfo) return userInfo;
    const payload = getPayload();
    if (!payload) return null;
    return {
      id: payload.id,
      email: payload.email || '',
      name: payload.name || '',
      role: Number(payload.role),
    };
  }

  function setUserInfo(info) {
    userInfo = info ? { ...info } : null;
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

      // Mettre à jour les infos utilisateur en mémoire (jamais persisté)
      const payload = getPayload();
      if (payload) {
        userInfo = {
          id: payload.id,
          email: payload.email || '',
          name: payload.name || '',
          role: Number(payload.role),
        };
      }

      // Notifier les autres onglets du nouveau token
      if (_channel) {
        _channel.postMessage({ type: 'refresh_done', token: data.token });
      }

      return data.token;
    } catch (error) {
      // Un autre onglet a peut-être déjà effectué la rotation du refresh token.
      // On attend brièvement qu'il diffuse le nouveau token avant d'abandonner.
      if (_channel) {
        try {
          const token = await waitForBroadcastToken(2000);
          setToken(token);
          return token;
        } catch {
          // Aucun autre onglet n'a répondu dans les 2s
        }
      }
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

  // ========== init — restauration silencieuse au chargement ==========

  /**
   * À appeler au chargement de chaque page.
   * Tente un refresh silencieux via le cookie HttpOnly pour récupérer
   * un access token en mémoire. Idempotent et sans erreur visible.
   * @returns {Promise<object|null>} Le payload utilisateur ou null
   */
  function init() {
    if (_initialized) {
      return Promise.resolve(getPayload());
    }

    if (_initPromise) {
      return _initPromise;
    }

    _initPromise = queuedRefresh()
      .then(() => {
        _initialized = true;
        return getPayload();
      })
      .catch(() => {
        _initialized = true;
        return null;
      })
      .finally(() => {
        _initPromise = null;
      });

    return _initPromise;
  }

  // ========== fetchWithTimeout — fetch avec timeout via AbortController ==========

  function fetchWithTimeout(url, options = {}, timeoutMs = 15000) {
    const controller = new AbortController();
    const existing = options.signal;
    if (existing) {
      existing.addEventListener('abort', () => controller.abort());
    }
    const timer = setTimeout(() => controller.abort(), timeoutMs);
    return fetch(url, { ...options, signal: controller.signal })
      .finally(() => clearTimeout(timer));
  }

  // ========== authFetch — le wrapper principal ==========

  async function authFetch(url, options = {}) {
    let token = getToken();

    // Si pas de token ou sur le point d'expirer, tenter un refresh
    if (!token || isTokenExpired()) {
      try {
        token = await queuedRefresh();
      } catch {
        token = null;
      }
    }

    // Construire les headers
    const headers = { ...options.headers };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    // Premier essai
    let response = await fetchWithTimeout(url, { ...options, headers, credentials: 'include' });

    // Si 401, tenter un refresh + retry
    if (response.status === 401) {
      try {
        const errorData = await response.clone().json();
        if (errorData.code === 'TOKEN_EXPIRED' || errorData.code === 'TOKEN_INVALID') {
          try {
            const newToken = await queuedRefresh();
            headers['Authorization'] = `Bearer ${newToken}`;
            response = await fetchWithTimeout(url, { ...options, headers, credentials: 'include' });
          } catch {
            clearSession();
          }
        }
      } catch {
        // Corps non-JSON : on ne déconnecte pas, on retourne la réponse telle quelle
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
    // Déconnecter aussi les autres onglets ouverts
    if (_channel) {
      _channel.postMessage({ type: 'logout' });
    }
    clearSession();
  }

  // ========== Public API ==========

  const publicApi = {
    getToken,
    setToken,
    getPayload,
    getUserInfo,
    setUserInfo,
    clearSession,
    isTokenExpired,
    authFetch,
    fetchWithTimeout,
    logout,
    init,
  };

  // Export conditionnel pour les tests unitaires (Node.js)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = publicApi;
  }

  return publicApi;
})();
