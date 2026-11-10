/* Paramètres — formulaire de profil (nom, adresse email).
 *
 * Changer d'adresse exige le mot de passe actuel (vérifié côté serveur) ; le
 * champ correspondant n'apparaît que si l'adresse saisie diffère de
 * l'actuelle. La nouvelle adresse ne s'applique qu'après le clic sur le lien
 * envoyé à celle-ci.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const CURRENT_PASSWORD_ERRORS = ['CURRENT_PASSWORD_INVALID', 'CURRENT_PASSWORD_REQUIRED'];

  function emailDiffers(email, currentUser) {
    return email.trim().toLowerCase() !== (currentUser?.email || '').toLowerCase();
  }

  // Le champ « mot de passe actuel » n'apparaît que si l'adresse change
  function toggleProfileCurrentPassword(state) {
    const group = document.getElementById('profile-current-password-group');
    const emailInput = document.getElementById('email');
    if (!group || !emailInput) return;
    group.hidden = !emailDiffers(emailInput.value, state.currentUser);
  }

  function validateProfile({ name, email, emailChanged, currentPwInput }) {
    clearFieldError(document.getElementById('name'));
    clearFieldError(document.getElementById('email'));
    if (currentPwInput) clearFieldError(currentPwInput);

    if (name.length < 2) {
      setFieldError(document.getElementById('name'), i18n.t('settings.toast_name_min'));
      return false;
    }
    if (!isValidEmail(email)) {
      setFieldError(document.getElementById('email'), i18n.t('settings.toast_email_invalid') || 'Adresse email invalide');
      return false;
    }
    if (emailChanged && !currentPwInput?.value) {
      setFieldError(currentPwInput, i18n.t('settings.toast_current_password_required'));
      return false;
    }
    return true;
  }

  function onProfileSaved(state, name, data, currentPwInput) {
    // Le nouvel email n'est appliqué qu'après le clic sur le lien envoyé
    // à cette adresse : on conserve l'actuel en attendant.
    state.currentUser = { ...state.currentUser, name };
    auth.setUserInfo(state.currentUser);
    VH.settings.account.updateUserDisplay(state);
    if (currentPwInput) currentPwInput.value = '';
    if (data.emailChangePending) {
      document.getElementById('email').value = state.currentUser.email || '';
      toggleProfileCurrentPassword(state);
      showToast(i18n.t('settings.toast_email_change_pending'), 'info');
    } else {
      showToast(i18n.t('settings.toast_profile_updated'), 'success');
    }
  }

  async function onProfileSubmit(state, form, e) {
    e.preventDefault();
    const { API_BASE, setButtonLoading } = VH.settings.ui;

    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const currentPwInput = document.getElementById('profile-current-password');
    const emailChanged = emailDiffers(email, state.currentUser);

    if (!validateProfile({ name, email, emailChanged, currentPwInput })) return;

    const submitBtn = form.querySelector('button[type="submit"]');
    setButtonLoading(submitBtn, true);

    try {
      const payload = emailChanged
        ? { name, email, currentPassword: currentPwInput.value }
        : { name };
      const response = await auth.authFetch(`${API_BASE}/users/${state.currentUser.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      const data = await response.json();

      if (response.ok) {
        onProfileSaved(state, name, data, currentPwInput);
      } else if (CURRENT_PASSWORD_ERRORS.includes(data.code)) {
        setFieldError(currentPwInput, i18n.t('settings.toast_current_password_invalid'));
      } else {
        showToast(data.message || i18n.t('settings.toast_profile_error'), 'error');
      }
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    } finally {
      setButtonLoading(submitBtn, false);
    }
  }

  function setup(state) {
    const profileForm = document.getElementById('profile-form');
    if (profileForm) {
      profileForm.addEventListener('submit', (e) => onProfileSubmit(state, profileForm, e));
    }

    document.getElementById('email')?.addEventListener('input', () => toggleProfileCurrentPassword(state));

    document.getElementById('reset-profile-btn')?.addEventListener('click', () => {
      document.getElementById('name').value = state.currentUser?.name || '';
      document.getElementById('email').value = state.currentUser?.email || '';
      toggleProfileCurrentPassword(state);
      showToast(i18n.t('settings.toast_form_reset'), 'info');
    });
  }

  VH.settings.profile = { CURRENT_PASSWORD_ERRORS, emailDiffers, toggleProfileCurrentPassword, validateProfile, onProfileSubmit, setup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.profile;
  }
})();
