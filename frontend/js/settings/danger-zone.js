/* Paramètres — zone danger : suppression définitive du compte. Trois verrous,
 * sans boîte de dialogue du navigateur :
 *   1. le mot de passe actuel (exigé par le serveur, SEC-005) ;
 *   2. la saisie d'un mot (traduit, « SUPPRIMER » en français) ;
 *   3. la confirmation sur place (VH.confirmAction, comme partout ailleurs).
 * Tant que le formulaire est incomplet, le bouton ne s'ouvre pas : l'envoi
 * signale le premier champ fautif. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const REDIRECT_AFTER_DELETE_MS = 2000;

  const passwordInput = () => document.getElementById('delete-current-password');
  const wordInput = () => document.getElementById('delete-confirm-word');
  const expectedWord = () => VH.settings.ui.tr('settings.delete_confirm_word', 'SUPPRIMER');

  /** Le mot saisi est-il le mot attendu (espaces autour ignorés) ? */
  function wordMatches() {
    const input = wordInput();
    return Boolean(input) && input.value.trim() === expectedWord();
  }

  /** Mot de passe saisi et mot exact. Sans effet de bord (sert d'option when). */
  function isReady() {
    const input = passwordInput();
    return Boolean(input && input.value) && wordMatches();
  }

  /** Signale le premier champ fautif : erreur sous le champ et focus. */
  function showErrors() {
    const password = passwordInput();
    const word = wordInput();
    clearFieldError(password);
    clearFieldError(word);
    if (password && !password.value) {
      setFieldError(password, i18n.t('settings.toast_current_password_required'));
      password.focus();
      return;
    }
    if (word && !wordMatches()) {
      setFieldError(word, VH.settings.ui.tr('settings.toast_delete_confirm_mismatch', 'Confirmation incorrecte'));
      word.focus();
    }
  }

  /** Requête de suppression. En cas d'échec, la confirmation revient au repos. */
  async function deleteAccount(state, button, control) {
    const { API_BASE, tr, setButtonLoading } = VH.settings.ui;
    const input = passwordInput();
    const fail = () => {
      setButtonLoading(button, false);
      if (control) control.reset();
    };
    setButtonLoading(button, true);

    try {
      const response = await auth.authFetch(`${API_BASE}/users/${state.currentUser.id}`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ currentPassword: input ? input.value : '' }),
      });

      if (response.ok) {
        showToast(i18n.t('settings.toast_account_deleted'), 'success');
        await auth.logout();
        setTimeout(() => { window.location.href = '/'; }, REDIRECT_AFTER_DELETE_MS);
        return;
      }
      const data = await response.json();
      fail();
      if (input && VH.settings.profile?.CURRENT_PASSWORD_ERRORS?.includes(data.code)) {
        setFieldError(input, i18n.t('settings.toast_current_password_invalid'));
        input.focus();
      } else {
        showToast(data.message || tr('settings.toast_delete_error', 'Erreur lors de la suppression'), 'error');
      }
    } catch {
      fail();
      showToast(i18n.t('settings.toast_network_error'), 'error');
    }
  }

  function setup(state) {
    const button = document.getElementById('delete-account-btn');
    const form = document.getElementById('delete-account-form');
    if (!button || !form || !window.VH.confirmAction) return null;
    const { tr } = VH.settings.ui;

    // Poubelle partagée à la place de l'icône Font Awesome.
    const icon = button.querySelector('svg.icon, i');
    const bin = window.VH.confirmAction.binIcon();
    if (icon) icon.replaceWith(bin); else button.prepend(bin);

    const control = window.VH.confirmAction.arm(button, {
      // Formulaire incomplet : le clic n'est pas intercepté, l'envoi suit.
      when: isReady,
      side: 'right',
      className: 'del-acc',
      measure: '.cfm-bin-check',
      labels: {
        group: () => tr('settings.delete_account_group', 'Supprimer définitivement votre compte\u202f?'),
        confirm: () => tr('settings.delete_account_confirm', 'Supprimer mon compte'),
        cancel: () => tr('settings.delete_account_keep', 'Garder'),
      },
      onConfirm: () => deleteAccount(state, button, control),
    });

    // Le bouton est le bouton d'envoi : un clic comme Entrée dans un champ
    // arrivent ici seulement si le formulaire est incomplet (sinon la
    // confirmation a intercepté le clic).
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      showErrors();
    });
    // Saisie corrigée : l'erreur du champ s'efface.
    [passwordInput(), wordInput()].forEach((input) => {
      if (input) input.addEventListener('input', () => clearFieldError(input));
    });
    return control;
  }

  VH.settings.dangerZone = { isReady, showErrors, deleteAccount, setup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.dangerZone;
  }
})();
