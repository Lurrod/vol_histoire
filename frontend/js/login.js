document.addEventListener("DOMContentLoaded", async () => {
  // Elements
  const loginForm = document.getElementById("login-form");
  const registerForm = document.getElementById("register-form");
  const switchToRegister = document.getElementById("switch-to-register");
  const switchToLogin = document.getElementById("switch-to-login");
  const loginSlide = document.getElementById("login-slide");
  const registerSlide = document.getElementById("register-slide");
  const loginPassword = document.getElementById('login-password');
  const registerPassword = document.getElementById('register-password');

  // Check required elements
  if (!loginForm || !registerForm || !switchToRegister || !switchToLogin) {
    // Éléments de formulaire requis absents
    return;
  }

  await init();

  async function init() {
    await auth.init();
    // Password toggles (utils.js)
    setupPasswordToggle(document.getElementById('toggle-login-password'), loginPassword);
    setupPasswordToggle(document.getElementById('toggle-register-password'), registerPassword);
    setupFormSwitching();
    // Navigation gérée par nav.js
    setupPasswordStrength();
    checkAuthStatus();
    fetchStats();
  }

  // ========== Stats dynamiques (panneau visuel) ==========
  async function fetchStats() {
    const elAirplanes = document.getElementById('stat-airplanes');
    const elYears = document.getElementById('stat-years');
    const elYearsLabel = document.getElementById('stat-years-label');
    const elCountries = document.getElementById('stat-countries');

    if (!elAirplanes || !elYears || !elCountries) return;

    try {
      const res = await auth.fetchWithTimeout('/api/stats');
      if (!res.ok) throw new Error('Erreur API');

      const data = await res.json();

      // Animate count-up
      animateNumber(elAirplanes, data.airplanes);
      animateNumber(elCountries, data.countries);

      if (data.earliest_year && data.latest_year) {
        animateNumber(elYears, data.latest_year - data.earliest_year);
        elYearsLabel.textContent = i18n.t('login.years_label');
      }
    } catch (err) {
      // Fallback statique si l'API n'est pas joignable
      // Stats API indisponible — utilisation des valeurs par défaut
      elAirplanes.textContent = '45+';
      elYears.textContent = '1950';
      elYearsLabel.textContent = i18n.t('login.years_label');
      elCountries.textContent = '12';
    }
  }

  // animateNumber, setupPasswordToggle → utils.js

  // ========== Form Switching (Slide) ==========
  function setupFormSwitching() {
    switchToRegister.addEventListener("click", (e) => {
      e.preventDefault();
      showSlide(registerSlide, loginSlide);
      resetForms();
    });

    switchToLogin.addEventListener("click", (e) => {
      e.preventDefault();
      showSlide(loginSlide, registerSlide);
      resetForms();
    });
  }

  function showSlide(toShow, toHide) {
    toHide.classList.remove('active');
    toShow.classList.add('active');
  }

  function resetForms() {
    loginForm.reset();
    registerForm.reset();
    updatePasswordStrength(0);
  }

  // Navigation → nav.js

  // ========== Password Strength ==========
  function setupPasswordStrength() {
    if (registerPassword) {
      registerPassword.addEventListener('input', () => {
        const strength = calculatePasswordStrength(registerPassword.value);
        updatePasswordStrength(strength);
      });
    }
  }

  // calculatePasswordStrength → utils.js

  function updatePasswordStrength(strength) {
    const strengthFill = document.querySelector('.strength-fill');
    const strengthText = document.querySelector('.strength-text');
    
    if (strengthFill && strengthText) {
      strengthFill.style.width = `${strength}%`;
      
      if (strength === 0) {
        strengthText.textContent = i18n.t('login.password_strength');
        strengthText.style.color = 'var(--text-secondary)';
        strengthFill.style.background = 'transparent';
      } else if (strength < 40) {
        strengthText.textContent = i18n.t('login.strength_weak');
        strengthText.style.color = 'var(--accent)';
        strengthFill.style.background = 'var(--accent)';
      } else if (strength < 70) {
        strengthText.textContent = i18n.t('login.strength_medium');
        strengthText.style.color = 'var(--warning)';
        strengthFill.style.background = 'var(--warning)';
      } else {
        strengthText.textContent = i18n.t('login.strength_strong');
        strengthText.style.color = 'var(--success)';
        strengthFill.style.background = 'var(--success)';
      }
    }
  }

  // ========== Auth Status ==========
  function checkAuthStatus() {
    if (auth.getToken()) {
    }
  }

  // Scroll effect, escapeHtml, showToast → utils.js / nav.js

  // ========== Validation ==========
  // validateEmail → isValidEmail() dans utils.js (même regex que le backend)

  function validatePassword(password) {
    return password.length >= 8 && /[a-z]/.test(password) && /[A-Z]/.test(password) && /[0-9]/.test(password);
  }

  // ========== Email non vérifié ==========
  function showEmailNotVerifiedNotice(email) {
    // Supprimer une notice existante
    document.getElementById('email-not-verified-notice')?.remove();

    const notice = document.createElement('div');
    notice.id = 'email-not-verified-notice';
    notice.style.cssText = [
      'background:rgba(243,156,18,0.08)',
      'border:1px solid rgba(243,156,18,0.25)',
      'border-radius:10px',
      'padding:1rem 1.25rem',
      'margin-top:1rem',
      'display:flex',
      'align-items:flex-start',
      'gap:0.75rem',
    ].join(';');

    const escapedEmail = escapeHtml(email);
    notice.innerHTML = `
      <i class="fas fa-envelope" style="color:#f39c12;margin-top:2px;flex-shrink:0"></i>
      <div style="flex:1">
        <p style="margin:0 0 0.4rem;font-weight:600;color:#f39c12;font-size:0.88rem;">${escapeHtml(i18n.t('login.email_not_verified_title'))}</p>
        <p style="margin:0 0 0.75rem;color:rgba(255,255,255,0.5);font-size:0.82rem;line-height:1.5">
          ${escapeHtml(i18n.t('login.email_not_verified_desc'))}
        </p>
        <button id="resend-verify-btn" style="background:rgba(243,156,18,0.12);border:1px solid rgba(243,156,18,0.3);border-radius:7px;padding:0.45rem 0.9rem;color:#f39c12;font-size:0.8rem;font-weight:600;cursor:pointer;font-family:inherit;transition:all 0.2s">
          <i class="fas fa-redo" style="margin-right:0.3rem"></i>${escapeHtml(i18n.t('login.resend_email'))}
        </button>
      </div>
    `;

    loginForm.insertAdjacentElement('afterend', notice);

    document.getElementById('resend-verify-btn').addEventListener('click', async function() {
      this.disabled = true;
      this.innerHTML = `<i class="fas fa-circle-notch fa-spin" style="margin-right:0.3rem"></i>${escapeHtml(i18n.t('login.resending'))}`;
      try {
        await auth.fetchWithTimeout('/api/auth/resend-verification', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: escapedEmail }),
        });
        this.innerHTML = `<i class="fas fa-check" style="margin-right:0.3rem"></i>${escapeHtml(i18n.t('login.resent'))}`;
        this.style.color = '#34d964';
        this.style.borderColor = 'rgba(52,217,100,0.3)';
      } catch {
        this.disabled = false;
        this.innerHTML = `<i class="fas fa-redo" style="margin-right:0.3rem"></i>${escapeHtml(i18n.t('login.resend_email'))}`;
      }
    });
  }

  // ========== Loading State ==========
  function setButtonLoading(button, loading) {
    if (loading) {
      button.disabled = true;
      button.dataset.originalText = button.innerHTML;
      button.innerHTML = '<span class="loading"></span>';
    } else {
      button.disabled = false;
      button.innerHTML = button.dataset.originalText;
    }
  }

  // ========== Login Handler ==========
  loginForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    
    const email = document.getElementById("login-email").value.trim();
    const password = loginPassword.value;
    const submitBtn = loginForm.querySelector('button[type="submit"]');

    if (!isValidEmail(email)) {
      showToast(i18n.t('login.invalid_email'), 'error');
      return;
    }
    if (!password) {
      showToast(i18n.t('login.missing_password'), 'error');
      return;
    }

    try {
      setButtonLoading(submitBtn, true);

      const response = await auth.fetchWithTimeout("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify({ email, password })
      });

      let data = {};
      try { data = await response.json(); } catch { /* réponse non-JSON */ }

      if (response.ok) {
        auth.setToken(data.token);

        const payload = auth.getPayload();
        if (payload) {
          auth.setUserInfo({
            id: payload.id,
            email: payload.email || email,
            name: payload.name || email.split('@')[0],
            role: Number(payload.role)
          });
        }

        showToast(i18n.t('login.login_success'), 'success');
        setTimeout(() => { window.location.href = "/"; }, 1500);
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else if (data.code === 'EMAIL_NOT_VERIFIED') {
        setButtonLoading(submitBtn, false);
        showEmailNotVerifiedNotice(email);
      } else {
        showToast(data.message || i18n.t('login.invalid_credentials'), 'error');
        setButtonLoading(submitBtn, false);
      }
    } catch (err) {
      // Erreur gérée via toast
      showToast(i18n.t('login.server_error'), 'error');
      setButtonLoading(submitBtn, false);
    }
  });

  // ========== Register Handler ==========
  registerForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    
    const name = document.getElementById("register-name").value.trim();
    const email = document.getElementById("register-email").value.trim();
    const password = registerPassword.value;
    const acceptTerms = document.getElementById("accept-terms").checked;
    const submitBtn = registerForm.querySelector('button[type="submit"]');

    if (name.length < 2) {
      showToast(i18n.t('login.name_too_short'), 'error');
      return;
    }
    if (!isValidEmail(email)) {
      showToast(i18n.t('login.invalid_email'), 'error');
      return;
    }
    if (!validatePassword(password)) {
      showToast(i18n.t('login.password_requirements'), 'error');
      return;
    }
    if (!acceptTerms) {
      showToast(i18n.t('login.accept_terms_error'), 'error');
      return;
    }

    try {
      setButtonLoading(submitBtn, true);

      const captchaToken = window.getHcaptchaToken ? await window.getHcaptchaToken('register') : null;
      const payload = { name, email, password };
      if (captchaToken) payload['h-captcha-response'] = captchaToken;

      const response = await auth.fetchWithTimeout("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      });

      let data = {};
      try { data = await response.json(); } catch { /* réponse non-JSON */ }

      if (response.ok) {
        window.location.href = '/check-email?email=' + encodeURIComponent(email);
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else {
        showToast(data.message || i18n.t('login.account_creation_failed'), 'error');
        setButtonLoading(submitBtn, false);
      }
    } catch (err) {
      // Erreur gérée via toast
      showToast(i18n.t('login.server_error'), 'error');
      setButtonLoading(submitBtn, false);
    }
  });

  // Logout, ESC handler → nav.js
});