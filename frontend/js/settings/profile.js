/* Paramètres — formulaire de profil (nom, adresse email).
 *
 * Changer d'adresse exige le mot de passe actuel (vérifié côté serveur) ; le
 * champ correspondant n'apparaît que si l'adresse saisie diffère de
 * l'actuelle. La nouvelle adresse ne s'applique qu'une fois saisi le code
 * envoyé à celle-ci (champ de code sous le formulaire, VH.otpInput). Le
 * serveur coupe alors toutes les sessions : on se reconnecte avec la
 * nouvelle adresse.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const CURRENT_PASSWORD_ERRORS = ['CURRENT_PASSWORD_INVALID', 'CURRENT_PASSWORD_REQUIRED'];
  // Le succès (contours verts) se lit avant le retour à la connexion.
  const RELOGIN_DELAY_MS = 1500;

  /** Navigation (remplaçable dans les tests : jsdom ne navigue pas). */
  function navigate(url) {
    window.location.href = url;
  }

  // ── Code de confirmation d'un changement d'adresse ────────────────────
  let emailOtp = null;

  function setEmailStatus(key, tone) {
    const el = document.getElementById('email-code-status');
    if (!el) return;
    el.textContent = key ? i18n.t(key) : '';
    el.dataset.tone = tone || '';
  }

  function closeEmailCode() {
    const box = document.getElementById('email-code-box');
    if (box) box.hidden = true;
    emailOtp?.clear();
    setEmailStatus(null);
  }

  async function confirmEmailCode(code) {
    const { API_BASE } = VH.settings.ui;
    emailOtp.setDisabled(true);
    setEmailStatus('settings.email_code_checking');
    try {
      const response = await auth.authFetch(`${API_BASE}/auth/confirm-email-change`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code }),
      });
      let data = {};
      try { data = await response.json(); } catch { /* réponse non JSON */ }
      if (response.ok) {
        emailOtp.setStatus('success');
        setEmailStatus('settings.email_code_done', 'success');
        // Sessions coupées par le serveur : reconnexion avec la nouvelle adresse.
        setTimeout(async () => {
          try { await auth.logout(); } catch { /* session déjà révoquée */ }
          VH.settings.profile.navigate('/login');
        }, RELOGIN_DELAY_MS);
        return;
      }
      emailOtp.setDisabled(false);
      emailOtp.setStatus('error');
      setEmailStatus(data.code === 'EMAIL_TAKEN' ? 'settings.email_code_taken' : 'settings.email_code_invalid', 'error');
      emailOtp.focus();
    } catch {
      emailOtp.setDisabled(false);
      emailOtp.setStatus('error');
      setEmailStatus('settings.toast_network_error', 'error');
    }
  }

  /** Affiche le champ de code sous le formulaire, pour la nouvelle adresse. */
  function openEmailCode(newEmail) {
    const box = document.getElementById('email-code-box');
    const mount = document.getElementById('email-code-otp');
    if (!box || !mount || !VH.otpInput) return;
    document.getElementById('email-code-target').textContent = newEmail;
    if (!emailOtp) {
      const label = i18n.t('settings.email_code_label');
      emailOtp = VH.otpInput.create(mount, {
        label: label === 'settings.email_code_label' ? 'Code à 6 chiffres' : label,
        describedBy: 'email-code-title',
        onComplete: confirmEmailCode,
        onChange: () => setEmailStatus(null),
      });
    }
    emailOtp.clear();
    emailOtp.setDisabled(false);
    setEmailStatus(null);
    box.hidden = false;
    emailOtp.focus();
  }

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

  function onProfileSaved(state, name, data, currentPwInput, newEmail) {
    // Le nouvel email n'est appliqué qu'une fois le code saisi : on conserve
    // l'actuel en attendant.
    state.currentUser = { ...state.currentUser, name };
    auth.setUserInfo(state.currentUser);
    if (currentPwInput) currentPwInput.value = '';
    if (data.emailChangePending) {
      document.getElementById('email').value = state.currentUser.email || '';
      toggleProfileCurrentPassword(state);
      showToast(i18n.t('settings.toast_email_change_pending'), 'info');
      openEmailCode(newEmail);
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
    // Coche « Enregistré » seulement si tout est enregistré : un changement
    // d'adresse attend encore son code.
    let saved = false;

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
        onProfileSaved(state, name, data, currentPwInput, email);
        saved = !emailChanged;
      } else if (CURRENT_PASSWORD_ERRORS.includes(data.code)) {
        setFieldError(currentPwInput, i18n.t('settings.toast_current_password_invalid'));
      } else {
        showToast(data.message || i18n.t('settings.toast_profile_error'), 'error');
      }
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    } finally {
      setButtonLoading(submitBtn, false, { done: saved, label: VH.settings.ui.tr('settings.btn_saved', 'Enregistré') });
    }
  }

  function setup(state) {
    const profileForm = document.getElementById('profile-form');
    if (profileForm) {
      profileForm.addEventListener('submit', (e) => onProfileSubmit(state, profileForm, e));
    }

    document.getElementById('email')?.addEventListener('input', () => toggleProfileCurrentPassword(state));
    document.getElementById('email-code-cancel')?.addEventListener('click', closeEmailCode);

    document.getElementById('reset-profile-btn')?.addEventListener('click', () => {
      document.getElementById('name').value = state.currentUser?.name || '';
      document.getElementById('email').value = state.currentUser?.email || '';
      toggleProfileCurrentPassword(state);
      showToast(i18n.t('settings.toast_form_reset'), 'info');
    });
  }

  VH.settings.profile = {
    CURRENT_PASSWORD_ERRORS, emailDiffers, toggleProfileCurrentPassword, validateProfile, onProfileSubmit, setup,
    navigate, openEmailCode, closeEmailCode, confirmEmailCode,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.profile;
  }
})();
