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
    } catch { /* silencieux */ }
  }

  function updateFavoriteButton(state) {
    const btn = document.getElementById('favorite-btn');
    if (!btn) return;
    // transitions-dev (icon swap) : les deux cœurs (plein / contour) restent
    // empilés dans le DOM ; on bascule data-state pour le cross-fade au lieu
    // de reconstruire l'innerHTML (ce qui tuerait la transition).
    let swap = btn.querySelector('.t-icon-swap');
    let label = btn.querySelector('.fav-label');
    if (!swap) {
      btn.innerHTML = '<span class="t-icon-swap" data-state="b" aria-hidden="true">'
        + '<i class="t-icon fas fa-heart" data-icon="a"></i>'
        + '<i class="t-icon far fa-heart" data-icon="b"></i>'
        + '</span><span class="fav-label"></span>';
      swap = btn.querySelector('.t-icon-swap');
      label = btn.querySelector('.fav-label');
    }
    if (state.isFavorite) {
      btn.classList.add('favorited');
      swap.setAttribute('data-state', 'a');
      label.textContent = i18n.t('details.remove_favorite');
    } else {
      btn.classList.remove('favorited');
      swap.setAttribute('data-state', 'b');
      label.textContent = i18n.t('details.add_favorite');
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
