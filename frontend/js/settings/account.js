/* Paramètres — vérification de la session et utilisateur courant.
 *
 * checkAuth() renseigne state.currentUser : d'abord depuis la mémoire du
 * module auth (ou le jeton), aussitôt affiché ; puis, si la date
 * d'inscription manque (« Membre depuis », en-tête), depuis
 * GET /api/users/:id. Sans session, redirection vers /login.
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

  /** L'API renvoie role_id, le jeton et la mémoire role : un seul champ, numérique. */
  function normalizeUser(user) {
    const role = user.role != null ? user.role : user.role_id;
    return { ...user, role: Number(role) };
  }

  function revealAdminIfNeeded(user) {
    if (Number(user.role) !== 1) return;
    document.getElementById('admin-nav-link')?.classList.remove('hidden');
    document.getElementById('admin')?.classList.remove('hidden');
  }

  /** Remplit le profil ; un champ déjà modifié par l'utilisateur est laissé tel quel. */
  function fillProfileForm(user, previous) {
    [['name', 'name'], ['email', 'email']].forEach(([id, key]) => {
      const input = document.getElementById(id);
      if (!input) return;
      const untouched = !previous || input.value === (previous[key] || '');
      if (untouched) input.value = user[key] || '';
    });
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

  /** Complète l'utilisateur par l'API (date d'inscription). Échec : on garde ce qu'on a. */
  async function enrichFromApi(state) {
    const id = state.currentUser?.id ?? auth.getPayload()?.id;
    if (id == null) return;
    try {
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/users/${id}`);
      if (!response.ok) return;
      const previous = state.currentUser;
      const fresh = normalizeUser(await response.json());
      // Le rôle de l'API (role_id) prime sur celui du jeton ; s'il manque, on garde l'ancien.
      const role = Number.isNaN(fresh.role) ? previous.role : fresh.role;
      state.currentUser = { ...previous, ...fresh, role };
      auth.setUserInfo(state.currentUser);
      fillProfileForm(state.currentUser, previous);
    } catch {
      // Réseau coupé : l'en-tête reste sans date d'inscription.
    }
  }

  async function checkAuth(state) {
    if (!(await ensureSession())) return false;

    const cached = auth.getUserInfo();
    state.currentUser = cached ? normalizeUser(cached) : userFromPayload(auth.getPayload());
    fillProfileForm(state.currentUser, null);
    revealAdminIfNeeded(state.currentUser);

    if (!state.currentUser.created_at) await enrichFromApi(state);
    revealAdminIfNeeded(state.currentUser);
    return true;
  }

  VH.settings.account = { userFromPayload, normalizeUser, fillProfileForm, checkAuth };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.account;
  }
})();
