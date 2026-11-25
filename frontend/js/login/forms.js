/* Connexion / inscription — validation et envoi des deux formulaires.
 *
 * Les erreurs de champ passent par setFieldError / clearFieldError
 * (utils.js). L'inscription ne demande que le nom et l'adresse : un code
 * part par email, puis le mot de passe se choisit dans les étapes suivantes
 * (js/login/flow.js).
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

      // hCaptcha invisible : aucun défi pour la plupart des visiteurs, exigé
      // par le serveur dès que sa clé secrète est posée.
      const captchaToken = window.getHcaptchaToken ? await window.getHcaptchaToken('login') : null;
      // « Se souvenir de moi » décoché : session limitée au navigateur ouvert (CONT-002).
      const remember = document.getElementById('remember-me');
      const payload = { email, password, remember: Boolean(remember && remember.checked) };
      if (captchaToken) payload['h-captcha-response'] = captchaToken;

      const response = await auth.fetchWithTimeout('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify(payload),
      });
      const data = await readJson(response);

      if (response.ok) {
        storeSession(data, email);
        showToast(i18n.t('login.login_success'), 'success');
        setTimeout(() => VH.login.forms.navigate('/'), REDIRECT_AFTER_LOGIN_MS);
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else if (response.status === 400 && data.code !== 'CAPTCHA_FAILED') {
        // Échec générique : le serveur ne dit pas si le compte attend son
        // activation (anti-énumération). L'aide au renvoi du lien suit donc
        // tout échec, formulée au conditionnel.
        showToast(data.message || i18n.t('login.invalid_credentials'), 'error');
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
  function validateRegister(ctx, { name, email, acceptTerms }) {
    const nameInput = document.getElementById('register-name');
    const emailInput = document.getElementById('register-email');
    clearFieldError(nameInput);
    clearFieldError(emailInput);

    if (name.length < 2) {
      setFieldError(nameInput, i18n.t('login.name_too_short'));
      return false;
    }
    if (!isValidEmail(email)) {
      setFieldError(emailInput, i18n.t('login.invalid_email'));
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
      acceptTerms: document.getElementById('accept-terms').checked,
    };
    const submitBtn = ctx.els.registerForm.querySelector('button[type="submit"]');

    if (!validateRegister(ctx, fields)) return;
    const { name, email } = fields;

    try {
      setButtonLoading(submitBtn, true);

      const captchaToken = window.getHcaptchaToken ? await window.getHcaptchaToken('register') : null;
      const payload = { name, email };
      if (captchaToken) payload['h-captcha-response'] = captchaToken;

      const response = await auth.fetchWithTimeout('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      const data = await readJson(response);

      if (response.ok) {
        setButtonLoading(submitBtn, false);
        showToast(i18n.t('login.register_success'), 'success');
        VH.login.flow.startCode(ctx, 'verify', email);
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
