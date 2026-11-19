/* Paramètres — vérification de la session et utilisateur courant.
 *
 * checkAuth() renseigne state.currentUser : d'abord depuis la mémoire du
 * module auth, sinon par l'API, et en dernier recours depuis le jeton
 * (API indisponible). Sans session, redirection vers /login.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  /** Utilisateur reconstitué depuis le jeton quand l'API ne répond pas. */
  function userFromPayload(p) {
    return p
      ? { id: p.id, name: p.name || 'Utilisateur', email: p.email || '', role: Number(p.role) }
      : { name: 'Utilisateur', email: '' };
  }

  function revealAdminIfNeeded(user) {
    if (Number(user.role) !== 1) return;
    document.getElementById('admin-nav-link').classList.remove('hidden');
    document.getElementById('admin')?.classList.remove('hidden');
  }

  function fillProfileForm(user) {
    document.getElementById('name').value = user.name || '';
    document.getElementById('email').value = user.email || '';
  }

  /** Session absente : une tentative de rafraîchissement avant de renvoyer vers /login. */
  async function ensureSession() {
    if (auth.getPayload()) return true;
    try {
      await auth.authFetch('/api/stats'); // appel léger qui déclenche le refresh
    } catch {
      // ignoré : on regarde simplement si une session est revenue
    }
    if (auth.getPayload()) return true;
    window.location.href = '/login';
    return false;
  }

  async function checkAuth(state) {
    if (!(await ensureSession())) return false;

    // Infos utilisateur déjà en mémoire (module auth)
    const cachedUser = auth.getUserInfo();
    if (cachedUser) {
      state.currentUser = cachedUser;
      fillProfileForm(state.currentUser);
      revealAdminIfNeeded(state.currentUser);
      return true;
    }

    // Sinon, l'API
    try {
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/users/${auth.getPayload().id}`);
      if (response.ok) {
        state.currentUser = await response.json();
        auth.setUserInfo(state.currentUser);
        fillProfileForm(state.currentUser);
      } else {
        // API indisponible — authentification par jeton uniquement
        state.currentUser = userFromPayload(auth.getPayload());
      }
    } catch {
      // Erreur réseau — authentification par jeton uniquement
      state.currentUser = userFromPayload(auth.getPayload());
    }
    revealAdminIfNeeded(state.currentUser);
    return true;
  }

  VH.settings.account = { userFromPayload, checkAuth };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.account;
  }
})();
