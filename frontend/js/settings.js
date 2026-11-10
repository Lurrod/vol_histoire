/* Paramètres — point d'entrée.
 * Les modules VH.settings.* (js/settings/) sont concaténés avant ce fichier
 * dans settings.min.js (scripts/build-js.js). Navigation, déconnexion et
 * raccourcis clavier globaux → nav.js.
 */
document.addEventListener('DOMContentLoaded', async () => {
  const S = VH.settings;
  // Utilisateur courant, renseigné par S.account.checkAuth().
  const state = { currentUser: null };

  const authReady = auth.init();

  // Administration, tableau de bord et cookies se branchent sans attendre la
  // session (même ordre qu'avant le découpage, où ils avaient chacun leur
  // propre écouteur DOMContentLoaded).
  S.admin.init(state);
  S.dashboard.init(state);
  S.cookies.init();

  await authReady;

  S.tabs.setup();
  S.profile.setup(state);
  S.security.setup(state);
  S.dangerZone.setup(state);
  S.dataExport.setup();

  S.account.checkAuth(state).then(() => {
    if (Number(state.currentUser?.role) === 1) S.admin.loadUsers();
    S.dashboard.loadDashboard(state);
  });
});
