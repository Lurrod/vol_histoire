/* Details — orchestrateur.
 * Crée le state, délègue aux modules VH.details.*. */
document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  // Support deux formats d'URL : /details?id=14 ou /details/f-22-raptor-14
  const urlParams = new URLSearchParams(window.location.search);
  let aircraftId = urlParams.get('id');
  if (!aircraftId) {
    const pathSegment = window.location.pathname.split('/').filter(Boolean).pop();
    if (pathSegment) {
      const match = pathSegment.match(/-(\d+)$/);
      if (match) aircraftId = match[1];
    }
  }
  if (!aircraftId || !/^\d+$/.test(aircraftId)) {
    window.location.href = '/404';
    return;
  }

  const state = {
    aircraftId,
    aircraftData: null,
    isFavorite: false,
    userRole: null,
  };

  // UI utilisateur (nom, rôle, boutons admin)
  const payload = auth.getPayload();
  if (payload) {
    state.userRole = Number(payload.role);
    const userNameEl = document.getElementById('user-name');
    if (userNameEl) userNameEl.textContent = payload.name;
    document.querySelector('.user-role').textContent =
      state.userRole === 1 ? i18n.t('common.role_admin') :
      state.userRole === 2 ? i18n.t('common.role_editor') :
      i18n.t('nav.user_role');
    document.querySelector('.user-dropdown')?.classList.remove('hidden');
    if (state.userRole === 1 || state.userRole === 2) {
      document.getElementById('edit-btn')?.classList.remove('hidden');
      document.getElementById('delete-btn')?.classList.remove('hidden');
    }
  }

  // Setup des listeners (handlers attachés une seule fois)
  VH.details.favorites.setup(state);
  VH.details.admin.setup(state);
  VH.details.ui.setupShareBar(state);
  VH.details.ui.setupScrollProgress();
  VH.details.ui.setupPdfExport();
  VH.details.ui.setupMiniBarVisibility();

  // Chargement initial
  await VH.details.data.loadAircraftDetails(state);
  VH.details.ui.setupSectionAnimations();
  VH.details.ui.syncMiniBar(state);

  // Re-sync mini-bar au changement de langue
  window.addEventListener('langChanged', () => VH.details.ui.syncMiniBar(state));

  // Raccourci Escape → ferme modale édition
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') VH.details.admin.closeEditModal();
  });

  // Re-render sur changement de langue
  window.addEventListener('langChanged', () => {
    if (state.aircraftData) {
      VH.details.render.renderAircraftDetails(state);
      VH.details.data.loadRelatedData(state);
      VH.details.favorites.updateFavoriteButton(state);
    }
  });
});
