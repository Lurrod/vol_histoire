/* Favoris — accès API (/api/favorites) et statistiques du bandeau. */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const LOGIN_REDIRECT_MS = 1500;

  function sessionExpired() {
    showToast(i18n.t('common.session_expired'), 'error');
    auth.clearSession();
    setTimeout(() => { window.location.href = '/login'; }, LOGIN_REDIRECT_MS);
  }

  async function loadFavorites(state) {
    VH.favorites.render.renderSkeletons();
    try {
      const response = await auth.authFetch('/api/favorites');

      if (response.status === 401 || response.status === 403) {
        sessionExpired();
        return;
      }

      if (!response.ok) throw new Error('Erreur serveur');

      const data = await response.json();
      state.favorites = Array.isArray(data) ? data : [];
      VH.favorites.toolbar.populateFilterOptions(state);
      VH.favorites.render.applyFiltersAndRender(state);
      updateStats(state);

    } catch {
      // Erreur gérée via toast
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  function deleteFavorite(airplaneId) {
    return auth.authFetch(`/api/favorites/${airplaneId}`, { method: 'DELETE' });
  }

  /* Compteurs : VH.rollingNumber (shared/rolling-number.js) */
  function updateStats(state) {
    const stats = VH.favorites.filters.computeStats(state.favorites);
    // Compteur « odomètre » : la valeur glisse de l'ancienne à la nouvelle
    // (retrait d'un favori, filtre) au lieu de recompter depuis zéro.
    const roll = VH.rollingNumber.set;
    roll(document.getElementById('total-favorites'), stats.total);
    roll(document.getElementById('total-countries'), stats.countries);
    roll(document.getElementById('total-generations'), stats.generations);
  }

  const api = { loadFavorites, deleteFavorite, updateStats };
  window.VH.favorites.data = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
