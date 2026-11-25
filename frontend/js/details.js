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

  // « Signaler une erreur » : le formulaire de contact s'ouvre avec la fiche.
  const reportLink = document.getElementById('report-link');
  if (reportLink) reportLink.href = `/contact?sujet=bug&fiche=${aircraftId}`;

  const state = {
    aircraftId,
    aircraftData: null,
    isFavorite: false,
    userRole: null,
  };

  const payload = auth.getPayload();
  if (payload) state.userRole = Number(payload.role);

  // Setup des listeners (handlers attachés une seule fois)
  VH.details.favorites.setup(state);
  VH.details.compare.setup(state);

  // Administration (admin/éditeur) : boutons Modifier / Supprimer et modale,
  // code chargé à la demande (JS-002).
  if (VH.shared.adminLoader.isEditor(payload)) {
    try {
      await VH.shared.adminLoader.load('details');
      VH.details.admin.setup(state);
      document.getElementById('edit-btn')?.classList.remove('hidden');
      document.getElementById('delete-btn')?.classList.remove('hidden');
    } catch {
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }
  VH.details.ui.setupShareBar(state);
  VH.details.ui.setupScrollProgress();
  VH.details.ui.setupPdfExport();
  VH.details.ui.setupMiniBarVisibility();
  VH.details.photoZoom.setup();

  // "Retour au listing" : restaure la pagination et les filtres depuis
  // sessionStorage.hangar_filters sur tous les liens /hangar de la page
  // (breadcrumb + header + footer). Si l'utilisateur n'a pas de session
  // (accès direct depuis Google), les liens restent sur /hangar sans params.
  restoreHangarLinks();

  // Chargement initial
  await VH.details.data.loadAircraftDetails(state);
  VH.details.ui.setupSectionAnimations();
  VH.details.ui.syncMiniBar(state);

  // Re-sync mini-bar au changement de langue
  window.addEventListener('langChanged', () => VH.details.ui.syncMiniBar(state));

  // Raccourci Escape → ferme modale édition
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') VH.details.admin?.closeEditModal();
  });

  // Re-render sur changement de langue
  window.addEventListener('langChanged', () => {
    if (state.aircraftData) {
      VH.details.render.renderAircraftDetails(state);
      VH.details.data.loadRelatedData(state);
      VH.details.lineage.load(state);
      VH.details.favorites.updateFavoriteButton(state);
    }
  });

  // Helper local : restaure les liens /hangar avec les filtres/page courants
  function restoreHangarLinks() {
    let saved;
    try {
      saved = JSON.parse(sessionStorage.getItem('hangar_filters') || 'null');
    } catch { return; }
    if (!saved) return;

    const p = new URLSearchParams();
    if (saved.filters?.country)    p.set('country', saved.filters.country);
    if (saved.filters?.generation) p.set('gen', String(saved.filters.generation));
    if (saved.filters?.type)       p.set('type', saved.filters.type);
    if (saved.filters?.search)     p.set('q', saved.filters.search);
    if (saved.sort && saved.sort !== 'default') p.set('sort', saved.sort);
    if (saved.currentPage && saved.currentPage > 1) p.set('page', String(saved.currentPage));

    const qs = p.toString();
    if (!qs) return; // rien à restaurer

    const target = `/hangar?${qs}`;
    document.querySelectorAll('a[href="/hangar"], a[href^="/hangar?"]').forEach(a => {
      a.setAttribute('href', target);
    });
  }
});
