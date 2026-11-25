/* Paramètres — zone danger : suppression définitive du compte, confirmée par
 * le mot de passe actuel (exigé par le serveur, SEC-005) puis par la saisie
 * d'un mot (traduit, « SUPPRIMER » en français). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const REDIRECT_AFTER_DELETE_MS = 2000;

  /** Demande le mot de confirmation. Renvoie 'confirmed', 'mismatch' ou 'cancelled'. */
  function askConfirmation() {
    const { tr } = VH.settings.ui;
    const confirmText = tr('settings.delete_confirm_word', 'SUPPRIMER');
    const userInput = prompt(
      tr('settings.delete_confirm_prompt',
        'Cette action est irréversible. Toutes vos données seront définitivement supprimées.\n\nPour confirmer, tapez « {word} » (en majuscules) :'
      ).replace('{word}', confirmText)
    );
    if (userInput === null) return 'cancelled';
    return userInput.trim() === confirmText ? 'confirmed' : 'mismatch';
  }

  const passwordInput = () => document.getElementById('delete-current-password');

  async function deleteAccount(state, button) {
    const { API_BASE, tr, setButtonLoading } = VH.settings.ui;
    const input = passwordInput();
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
      } else {
        const data = await response.json();
        if (input && VH.settings.profile?.CURRENT_PASSWORD_ERRORS?.includes(data.code)) {
          setFieldError(input, i18n.t('settings.toast_current_password_invalid'));
          input.focus();
        } else {
          showToast(data.message || tr('settings.toast_delete_error', 'Erreur lors de la suppression'), 'error');
        }
        setButtonLoading(button, false);
      }
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
      setButtonLoading(button, false);
    }
  }

  async function onDeleteClick(state, button) {
    const input = passwordInput();
    if (input) {
      clearFieldError(input);
      if (!input.value) {
        setFieldError(input, i18n.t('settings.toast_current_password_required'));
        input.focus();
        return;
      }
    }
    const answer = askConfirmation();
    if (answer === 'confirmed') {
      await deleteAccount(state, button);
    } else if (answer === 'mismatch') {
      showToast(VH.settings.ui.tr('settings.toast_delete_confirm_mismatch', 'Confirmation incorrecte'), 'error');
    }
  }

  function setup(state) {
    const button = document.getElementById('delete-account-btn');
    button?.addEventListener('click', () => onDeleteClick(state, button));
    // Entrée dans le champ du mot de passe : même parcours que le bouton.
    document.getElementById('delete-account-form')?.addEventListener('submit', (e) => {
      e.preventDefault();
      onDeleteClick(state, button);
    });
  }

  VH.settings.dangerZone = { askConfirmation, deleteAccount, onDeleteClick, setup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.dangerZone;
  }
})();
