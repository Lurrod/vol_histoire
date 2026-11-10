/* Paramètres — changement de mot de passe : jauge de force, liste des
 * exigences cochées au fil de la saisie, envoi avec le mot de passe actuel. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  /** Exigences de isValidPassword() (backend/validators.js), par id d'élément. */
  function passwordRequirements(password) {
    return {
      'req-length': password.length >= 8,
      'req-upper': /[A-Z]/.test(password),
      'req-lower': /[a-z]/.test(password),
      'req-number': /[0-9]/.test(password),
    };
  }

  function meetsRequirements(password) {
    return Object.values(passwordRequirements(password)).every(Boolean);
  }

  /** Libellé et couleur de la jauge pour un mot de passe et son score. */
  function strengthLabel(password, strength) {
    if (password.length === 0) return { key: 'settings.password_strength', color: 'var(--text-secondary)' };
    if (strength < 40) return { key: 'settings.strength_weak', color: 'var(--accent)' };
    if (strength < 70) return { key: 'settings.strength_medium', color: 'var(--warning)' };
    return { key: 'settings.strength_strong', color: 'var(--success)' };
  }

  function updatePasswordStrength(password) {
    const bars = document.querySelectorAll('.strength-bar');
    const strengthText = document.getElementById('strength-text');
    if (!bars.length || !strengthText) return;

    const strength = calculatePasswordStrength(password);
    const activeCount = Math.ceil((strength / 100) * 4);

    bars.forEach((bar, index) => {
      bar.classList.remove('active', 'weak', 'medium');
      if (index < activeCount) {
        bar.classList.add('active');
        if (strength < 40) bar.classList.add('weak');
        else if (strength < 70) bar.classList.add('medium');
      }
    });

    const label = strengthLabel(password, strength);
    strengthText.textContent = i18n.t(label.key);
    strengthText.style.color = label.color;
  }

  function updatePasswordRequirements(password) {
    Object.entries(passwordRequirements(password)).forEach(([id, valid]) => {
      document.getElementById(id)?.classList.toggle('valid', valid);
    });
  }

  function validateSecurity(passwordInput, currentInput) {
    const password = passwordInput.value;
    clearFieldError(passwordInput);
    if (currentInput) clearFieldError(currentInput);

    if (currentInput && !currentInput.value) {
      setFieldError(currentInput, i18n.t('settings.toast_current_password_required'));
      return false;
    }
    if (!password) {
      setFieldError(passwordInput, 'Veuillez entrer un nouveau mot de passe');
      return false;
    }
    if (!meetsRequirements(password)) {
      setFieldError(passwordInput, i18n.t('settings.toast_password_min'));
      return false;
    }
    return true;
  }

  async function onSecuritySubmit(state, form, passwordInput, e) {
    e.preventDefault();
    const { API_BASE, setButtonLoading } = VH.settings.ui;
    const currentInput = document.getElementById('current-password');

    if (!validateSecurity(passwordInput, currentInput)) return;

    const submitBtn = form.querySelector('button[type="submit"]');
    setButtonLoading(submitBtn, true);

    try {
      const response = await auth.authFetch(`${API_BASE}/users/${state.currentUser.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: passwordInput.value, currentPassword: currentInput?.value }),
      });
      const data = await response.json();

      if (response.ok) {
        // Toutes les sessions viennent d'être coupées côté serveur ; il renvoie
        // un jeton neuf pour cet onglet (le cookie de refresh est déjà posé).
        if (data.token) auth.setToken(data.token);
        showToast(i18n.t('settings.toast_password_updated'), 'success');
        form.reset();
        updatePasswordStrength('');
        updatePasswordRequirements('');
      } else if (VH.settings.profile.CURRENT_PASSWORD_ERRORS.includes(data.code)) {
        setFieldError(currentInput, i18n.t('settings.toast_current_password_invalid'));
      } else {
        showToast(data.message || i18n.t('settings.toast_profile_error'), 'error');
      }
    } catch {
      showToast('API non disponible. Connectez votre backend pour changer le mot de passe.', 'error');
    } finally {
      setButtonLoading(submitBtn, false);
    }
  }

  function setup(state) {
    const securityForm = document.getElementById('security-form');
    const passwordInput = document.getElementById('password');

    // Afficher / masquer le mot de passe (utils.js)
    setupPasswordToggle(document.getElementById('toggle-password'), passwordInput);

    passwordInput?.addEventListener('input', () => {
      updatePasswordStrength(passwordInput.value);
      updatePasswordRequirements(passwordInput.value);
    });

    if (securityForm) {
      securityForm.addEventListener('submit', (e) => onSecuritySubmit(state, securityForm, passwordInput, e));
    }
  }

  VH.settings.security = {
    passwordRequirements, meetsRequirements, strengthLabel,
    updatePasswordStrength, updatePasswordRequirements, validateSecurity, onSecuritySubmit, setup,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.security;
  }
})();
