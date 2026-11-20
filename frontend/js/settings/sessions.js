/* Paramètres — « Se déconnecter de tous les appareils » (2026-11-20).
 *
 * Confirmation sur place (VH.confirmAction), puis POST /api/auth/logout-all :
 * le serveur révoque tous les refresh tokens du compte et invalide les
 * access tokens déjà émis (token_version), celui de cet onglet compris, et
 * efface le cookie de session. On nettoie alors la session locale (et les
 * autres onglets, par auth.logout), puis on revient à /login, où un toast
 * confirme la fermeture (utils.js, queueToast). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  /** Navigation (remplaçable dans les tests : jsdom ne navigue pas). */
  function navigate(url) {
    window.location.href = url;
  }

  /** @param {{ reset: () => void }|null} control confirmation à remettre au repos en cas d'échec */
  async function logoutAll(control) {
    const { API_BASE, tr } = VH.settings.ui;
    let response;
    try {
      response = await auth.authFetch(`${API_BASE}/auth/logout-all`, { method: 'POST' });
    } catch {
      control?.reset();
      showToast(i18n.t('settings.toast_network_error'), 'error');
      return false;
    }
    if (!response.ok) {
      control?.reset();
      showToast(tr('settings.sessions_error', 'Impossible de fermer les sessions. Réessayez.'), 'error');
      return false;
    }
    // Sessions déjà fermées côté serveur : le nettoyage local suit, même
    // s'il échoue (l'appel /api/logout ne peut plus rien révoquer).
    try { await auth.logout(); } catch { auth.clearSession?.(); }
    const message = tr('settings.sessions_done', 'Toutes vos sessions ont été fermées.');
    if (typeof queueToast !== 'function' || !queueToast(message, 'success')) showToast(message, 'success');
    VH.settings.sessions.navigate('/login');
    return true;
  }

  function setup() {
    const button = document.getElementById('logout-all-btn');
    if (!button || !window.VH.confirmAction) return null;
    const { tr } = VH.settings.ui;
    const control = window.VH.confirmAction.arm(button, {
      side: 'right',
      showText: true,
      className: 'ses-out',
      labels: {
        group: () => tr('settings.sessions_confirm_group', 'Fermer toutes les sessions ?'),
        confirm: () => tr('settings.sessions_confirm', 'Tout fermer'),
        cancel: () => tr('settings.sessions_keep', 'Annuler'),
      },
      onConfirm: () => logoutAll(control),
    });
    return control;
  }

  VH.settings.sessions = { logoutAll, setup, navigate };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.sessions;
  }
})();
