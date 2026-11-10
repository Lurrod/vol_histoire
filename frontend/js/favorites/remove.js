/* Favoris — retrait optimiste avec annulation : la carte disparaît tout de
 * suite, un toast propose « Annuler » pendant 5 s, et le DELETE ne part
 * qu'à l'expiration de ce délai. */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const UNDO_DELAY_MS = 5000;
  const TOAST_EXIT_MS = 300;

  function dismissToast(toast) {
    toast.classList.add('fade-out');
    setTimeout(() => toast.remove(), TOAST_EXIT_MS);
  }

  function showUndoToast(message, onUndo) {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast toast-info';
    toast.setAttribute('role', 'status');
    toast.innerHTML = `
      <i class="fas fa-heart-broken" aria-hidden="true"></i>
      <span class="toast-msg">${escapeHtml(message)}</span>
      <button class="toast-undo-btn">${escapeHtml(i18n.t('favorites.undo'))}</button>
    `;

    let undone = false;
    toast.querySelector('.toast-undo-btn').addEventListener('click', () => {
      undone = true;
      onUndo();
      dismissToast(toast);
    });

    container.appendChild(toast);

    const timer = setTimeout(() => dismissToast(toast), UNDO_DELAY_MS);

    return { cancel: () => { clearTimeout(timer); if (!undone) dismissToast(toast); } };
  }

  /* On ne réinsère que CET appareil : restaurer un instantané complet
   * ressusciterait aussi un autre favori retiré entre-temps, dont le DELETE
   * partirait quand même. */
  function restoreFavorite(state, removed) {
    if (!state.favorites.some(a => a.id === removed.id)) {
      state.favorites = state.favorites.concat(removed);
    }
    VH.favorites.render.applyFiltersAndRender(state);
    VH.favorites.toolbar.decorateFacetCounts(state);
    VH.favorites.data.updateStats(state);
  }

  async function commitRemoval(state, airplaneId, restore) {
    try {
      const response = await VH.favorites.data.deleteFavorite(airplaneId);
      if (!response.ok) throw new Error();
      VH.favorites.data.updateStats(state);
    } catch {
      restore();
      showToast(i18n.t('common.error'), 'error');
    }
  }

  function removeWithUndo(state, btn) {
    // Retrait déjà en attente : pas de second toast ni de second DELETE.
    if (btn.disabled) return;
    const airplaneId = parseInt(btn.dataset.airplaneId, 10);
    const removed = state.favorites.find(a => a.id === airplaneId);
    if (!removed) return;
    // Relevé AVANT disabled : le navigateur retire aussitôt le focus d'un
    // bouton désactivé, et le report vers la carte voisine n'aurait plus lieu.
    const card = btn.closest('.aircraft-card');
    const hadFocus = Boolean(card && card.contains(document.activeElement));
    btn.disabled = true;

    // Retrait optimiste de l'état, du compteur et de la carte
    state.favorites = state.favorites.filter(a => a.id !== airplaneId);
    state.filtered = state.filtered.filter(a => a.id !== airplaneId);
    VH.favorites.render.updateResultsCount(state);
    VH.favorites.toolbar.decorateFacetCounts(state);
    VH.favorites.render.collapseCard(state, card, hadFocus);

    const restore = () => restoreFavorite(state, removed);
    let undone = false;
    showUndoToast(i18n.t('favorites.removed'), () => {
      undone = true;
      restore();
    });

    // API call après le délai undo
    setTimeout(() => {
      if (!undone) commitRemoval(state, airplaneId, restore);
    }, UNDO_DELAY_MS);
  }

  const api = { UNDO_DELAY_MS, showUndoToast, removeWithUndo };
  window.VH.favorites.remove = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
