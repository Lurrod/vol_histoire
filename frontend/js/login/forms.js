/* Connexion / inscription — validation et envoi des deux formulaires.
 *
 * Les erreurs de champ passent par setFieldError / clearFieldError
 * (utils.js), qui gèrent un aria-describedby à plusieurs identifiants : le
 * mot de passe d'inscription garde son aide permanente
 * (#register-password-hint, WCAG 3.3.2) et y ajoute
 * #register-password-error le temps d'une erreur.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  const REDIRECT_AFTER_LOGIN_MS = 1500;

  /** Redirection (remplaçable dans les tests : jsdom ne navigue pas). */
  function navigate(url) {
    window.location.href = url;
  }

  async function readJson(response) {
    try { return await response.json(); } catch { return {}; /* réponse non-JSON */ }
  }

  function storeSession(data, email) {
    auth.setToken(data.token);
    const payload = auth.getPayload();
    if (payload) {
      auth.setUserInfo({
        id: payload.id,
        email: payload.email || email,
        name: payload.name || email.split('@')[0],
        role: Number(payload.role),
      });
    }
  }

  // ========== Connexion ==========
  function validateLogin(ctx, email, password) {
    const emailInput = document.getElementById('login-email');
    clearFieldError(emailInput);
    clearFieldError(ctx.els.loginPassword);

    if (!isValidEmail(email)) {
      setFieldError(emailInput, i18n.t('login.invalid_email'));
      return false;
    }
    if (!password) {
      setFieldError(ctx.els.loginPassword, i18n.t('login.missing_password'));
      return false;
    }
    return true;
  }

  async function onLoginSubmit(ctx, event) {
    event.preventDefault();
    const { setButtonLoading, showEmailNotVerifiedNotice } = VH.login.ui;

    const email = document.getElementById('login-email').value.trim();
    const password = ctx.els.loginPassword.value;
    const submitBtn = ctx.els.loginForm.querySelector('button[type="submit"]');

    if (!validateLogin(ctx, email, password)) return;

    try {
      setButtonLoading(submitBtn, true);

      const response = await auth.fetchWithTimeout('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ email, password }),
      });
      const data = await readJson(response);

      if (response.ok) {
        storeSession(data, email);
        showToast(i18n.t('login.login_success'), 'success');
        setTimeout(() => VH.login.forms.navigate('/'), REDIRECT_AFTER_LOGIN_MS);
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else if (data.code === 'EMAIL_NOT_VERIFIED') {
        setButtonLoading(submitBtn, false);
        showEmailNotVerifiedNotice(ctx, email);
      } else {
        showToast(data.message || i18n.t('login.invalid_credentials'), 'error');
        setButtonLoading(submitBtn, false);
      }
    } catch {
      showToast(i18n.t('login.server_error'), 'error');
      setButtonLoading(submitBtn, false);
    }
  }

  // ========== Inscription ==========
  function validateRegister(ctx, { name, email, password, acceptTerms }) {
    const nameInput = document.getElementById('register-name');
    const emailInput = document.getElementById('register-email');
    clearFieldError(nameInput);
    clearFieldError(emailInput);
    clearFieldError(ctx.els.registerPassword);

    if (name.length < 2) {
      setFieldError(nameInput, i18n.t('login.name_too_short'));
      return false;
    }
    if (!isValidEmail(email)) {
      setFieldError(emailInput, i18n.t('login.invalid_email'));
      return false;
    }
    if (!VH.login.strength.validatePassword(password)) {
      setFieldError(ctx.els.registerPassword, i18n.t('login.password_requirements'));
      return false;
    }
    if (!acceptTerms) {
      showToast(i18n.t('login.accept_terms_error'), 'error');
      return false;
    }
    return true;
  }

  async function onRegisterSubmit(ctx, event) {
    event.preventDefault();
    const { setButtonLoading } = VH.login.ui;

    const fields = {
      name: document.getElementById('register-name').value.trim(),
      email: document.getElementById('register-email').value.trim(),
      password: ctx.els.registerPassword.value,
      acceptTerms: document.getElementById('accept-terms').checked,
    };
    const submitBtn = ctx.els.registerForm.querySelector('button[type="submit"]');

    if (!validateRegister(ctx, fields)) return;
    const { name, email, password } = fields;

    try {
      setButtonLoading(submitBtn, true);

      const captchaToken = window.getHcaptchaToken ? await window.getHcaptchaToken('register') : null;
      const payload = { name, email, password };
      if (captchaToken) payload['h-captcha-response'] = captchaToken;

      const response = await auth.fetchWithTimeout('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      const data = await readJson(response);

      if (response.ok) {
        showToast(i18n.t('login.register_success'), 'success');
        VH.login.forms.navigate('/check-email?email=' + encodeURIComponent(email));
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else {
        showToast(data.message || i18n.t('login.account_creation_failed'), 'error');
        setButtonLoading(submitBtn, false);
      }
    } catch {
      showToast(i18n.t('login.server_error'), 'error');
      setButtonLoading(submitBtn, false);
    }
  }

  function bindForms(ctx) {
    ctx.els.loginForm.addEventListener('submit', (event) => onLoginSubmit(ctx, event));
    ctx.els.registerForm.addEventListener('submit', (event) => onRegisterSubmit(ctx, event));
  }

  VH.login.forms = { navigate, validateLogin, validateRegister, onLoginSubmit, onRegisterSubmit, bindForms };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.forms;
  }
})();
