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

  // Barre d'enregistrement d'abord : profil et cookies s'y inscrivent.
  S.saveBar.setup();
  S.admin.init(state);
  S.identity.init();
  S.collection.init();
  S.cookies.init();
  S.preferences.setup();

  await authReady;

  S.tabs.setup();
  S.profile.setup(state);
  S.security.setup(state);
  S.sessions.setup();
  S.dangerZone.setup(state);
  S.dataExport.setup();

  S.account.checkAuth(state).then((ok) => {
    if (!ok) return;
    S.identity.render(state.currentUser);
    S.collection.load();
    if (Number(state.currentUser?.role) === 1) {
      S.admin.loadUsers();
      // #admin n'est ouvrable qu'une fois l'onglet révélé.
      if (window.location.hash === '#admin') S.tabs.openFromHash();
    }
  });
});
