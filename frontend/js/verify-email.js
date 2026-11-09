// Page d'atterrissage des liens envoyés par email :
//   - /verify-email?token=…            activation du compte : le titulaire de la
//     boîte choisit ici son mot de passe (celui saisi à l'inscription n'est pas
//     activé, pour qu'une pré-inscription de son adresse par un tiers échoue) ;
//   - /verify-email?type=email&token=… confirmation d'un changement d'adresse.
document.addEventListener('DOMContentLoaded', async () => {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token');
  const isEmailChange = params.get('type') === 'email';

  const show = (id) => {
    ['state-loading', 'state-form', 'state-success', 'state-error'].forEach(s => {
      document.getElementById(s)?.classList.add('hidden');
    });
    document.getElementById(id)?.classList.remove('hidden');
  };

  const showError = (message) => {
    document.getElementById('error-message').textContent = message;
    show('state-error');
  };

  const errorFor = (data) => (data.code === 'TOKEN_INVALID'
    ? i18n.t('verify_email.error_expired')
    : (data.message || i18n.t('common.error')));

  if (!token) {
    showError(i18n.t('verify_email.error_missing_token'));
    return;
  }

  if (isEmailChange) {
    try {
      const res = await auth.fetchWithTimeout('/api/auth/confirm-email-change', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token }),
      });
      const data = await res.json();
      if (!res.ok) {
        showError(data.code === 'EMAIL_TAKEN' ? i18n.t('verify_email.error_email_taken') : errorFor(data));
        return;
      }
      // L'ancienne session ne vaut plus rien côté serveur : on la purge ici aussi.
      auth.clearSession?.();
      const msg = document.getElementById('success-message');
      msg.removeAttribute('data-i18n-html');
      msg.textContent = i18n.t('verify_email.email_changed_desc');
      show('state-success');
    } catch {
      showError(i18n.t('verify_email.error_network'));
    }
    return;
  }

  // Activation : formulaire de choix du mot de passe
  show('state-form');
  const form = document.getElementById('verify-form');
  const pwInput = document.getElementById('verify-password');
  const confirmInput = document.getElementById('verify-password-confirm');
  const errorEl = document.getElementById('verify-error');
  const submitBtn = document.getElementById('verify-submit-btn');

  document.getElementById('toggle-verify-pw').addEventListener('click', () => {
    const icon = document.querySelector('#toggle-verify-pw i');
    const visible = pwInput.type === 'password';
    pwInput.type = visible ? 'text' : 'password';
    confirmInput.type = pwInput.type;
    icon.classList.replace(visible ? 'fa-eye-slash' : 'fa-eye', visible ? 'fa-eye' : 'fa-eye-slash');
  });

  const setFormError = (message) => {
    errorEl.textContent = message;
    errorEl.classList.toggle('is-visible', Boolean(message));
    pwInput.toggleAttribute('aria-invalid', Boolean(message));
  };

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const password = pwInput.value;
    if (password.length < 8 || password.length > 128 || !/[a-z]/.test(password) || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
      setFormError(i18n.t('verify_email.error_password_weak'));
      return;
    }
    if (password !== confirmInput.value) {
      setFormError(i18n.t('verify_email.error_password_mismatch'));
      return;
    }
    setFormError('');
    submitBtn.disabled = true;
    try {
      const res = await auth.fetchWithTimeout('/api/auth/verify-email', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token, password }),
      });
      const data = await res.json();
      if (res.ok) {
        show('state-success');
      } else if (data.code === 'TOKEN_INVALID') {
        showError(errorFor(data));
      } else {
        setFormError(data.message || i18n.t('common.error'));
      }
    } catch {
      setFormError(i18n.t('verify_email.error_network'));
    } finally {
      submitBtn.disabled = false;
    }
  });
});
