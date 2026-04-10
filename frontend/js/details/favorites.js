/* Toggle favori + indicateur sur le bouton. */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  async function checkFavoriteStatus(state) {
    if (!auth.getToken()) return;
    try {
      const response = await auth.authFetch(`/api/airplanes/${state.aircraftId}/favorite`);
      const data = await response.json();
      state.isFavorite = data.isFavorite;
      updateFavoriteButton(state);
    } catch (_) { /* silencieux */ }
  }

  function updateFavoriteButton(state) {
    const btn = document.getElementById('favorite-btn');
    if (!btn) return;
    if (state.isFavorite) {
      btn.classList.add('favorited');
      btn.innerHTML = `<i class="fas fa-heart"></i><span>${i18n.t('details.remove_favorite')}</span>`;
    } else {
      btn.classList.remove('favorited');
      btn.innerHTML = `<i class="far fa-heart"></i><span>${i18n.t('details.add_favorite')}</span>`;
    }
  }

  function setup(state) {
    const btn = document.getElementById('favorite-btn');
    btn?.addEventListener('click', async () => {
      if (!auth.getToken()) {
        showToast(i18n.t('common.login_to_favorite'), 'info');
        setTimeout(() => window.location.href = '/login', 1500);
        return;
      }
      try {
        const method = state.isFavorite ? 'DELETE' : 'POST';
        const response = await auth.authFetch(`/api/favorites/${state.aircraftId}`, { method });
        if (!response.ok) throw new Error(i18n.t('common.favorite_error'));
        state.isFavorite = !state.isFavorite;
        updateFavoriteButton(state);
        showToast(
          state.isFavorite ? i18n.t('common.favorite_added') : i18n.t('common.favorite_removed'),
          'success'
        );
      } catch (error) {
        showToast(error.message, 'error');
      }
    });
  }

  VH.details.favorites = { checkFavoriteStatus, updateFavoriteButton, setup };
})();
