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
  // ARIA tablist controls (pattern WAI-ARIA APG)
  const tabLogin = document.getElementById('tab-login');
  const tabRegister = document.getElementById('tab-register');

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
    } catch {
      // Fallback statique si l'API n'est pas joignable
      // Stats API indisponible — utilisation des valeurs par défaut
      elAirplanes.textContent = '45+';
      elYears.textContent = '1950';
      elYearsLabel.textContent = i18n.t('login.years_label');
      elCountries.textContent = '12';
    }
  }

  // animateNumber, setupPasswordToggle → utils.js

  // ========== Form Switching (tabs ARIA + slide transition) ==========
  function setupFormSwitching() {
    // Boutons CTA dans le footer de chaque panneau — délèguent à la tab correspondante
    switchToRegister?.addEventListener("click", (e) => {
      e.preventDefault();
      activateTab(tabRegister, { focusInput: true });
    });
    switchToLogin?.addEventListener("click", (e) => {
      e.preventDefault();
      activateTab(tabLogin, { focusInput: true });
    });

    // Clic sur les tabs de la tablist
    tabLogin?.addEventListener('click', () => activateTab(tabLogin, { focusInput: true }));
    tabRegister?.addEventListener('click', () => activateTab(tabRegister, { focusInput: true }));

    // Navigation clavier dans la tablist (ArrowLeft/ArrowRight, Home/End).
    // Activation automatique : la tab focalisée devient active immédiatement.
    const tabs = [tabLogin, tabRegister].filter(Boolean);
    tabs.forEach(tab => tab.addEventListener('keydown', (e) => onTabKeydown(e, tabs)));
  }

  function onTabKeydown(e, tabs) {
    const idx = tabs.indexOf(e.currentTarget);
    if (idx < 0) return;
    let next = -1;
    if (e.key === 'ArrowRight') next = (idx + 1) % tabs.length;
    else if (e.key === 'ArrowLeft') next = (idx - 1 + tabs.length) % tabs.length;
    else if (e.key === 'Home') next = 0;
    else if (e.key === 'End') next = tabs.length - 1;
    if (next < 0) return;
    e.preventDefault();
    tabs[next].focus();
    activateTab(tabs[next], { focusInput: false });
  }

  function activateTab(tab, { focusInput } = { focusInput: false }) {
    if (!tab) return;
    const panelId = tab.getAttribute('aria-controls');
    const panel = document.getElementById(panelId);
    if (!panel) return;

    // Désactive toutes les tabs du même tablist
    const tabs = tab.parentElement.querySelectorAll('[role="tab"]');
    tabs.forEach(t => {
      t.setAttribute('aria-selected', 'false');
      t.setAttribute('tabindex', '-1');
      t.classList.remove('active');
    });
    tab.setAttribute('aria-selected', 'true');
    tab.setAttribute('tabindex', '0');
    tab.classList.add('active');

    // Affiche le panneau correspondant (les autres sont masqués via CSS .active).
    // `inert` remplace le couple aria-hidden + tabindex : une seule propriété
    // exclut le sous-arbre du tab order ET des AT, évitant l'antipattern
    // « aria-hidden sur conteneur focusable » (WCAG 4.1.2).
    [loginSlide, registerSlide].forEach(p => {
      if (!p) return;
      if (p === panel) {
        p.classList.add('active');
        p.inert = false;
      } else {
        p.classList.remove('active');
        p.inert = true;
      }
    });

    resetForms();

    if (focusInput) {
      const firstInput = panel.querySelector('input:not([type="hidden"])');
      firstInput?.focus({ preventScroll: true });
    }
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
      // Pas de redirection automatique : l'utilisateur peut vouloir se
      // reconnecter avec un autre compte depuis cette page.
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
    notice.className = 'ev-notice';

    const escapedEmail = escapeHtml(email);
    notice.innerHTML = `
      <i class="fas fa-envelope ev-notice-icon"></i>
      <div class="ev-notice-body">
        <p class="ev-notice-title">${escapeHtml(i18n.t('login.email_not_verified_title'))}</p>
        <p class="ev-notice-desc">${escapeHtml(i18n.t('login.email_not_verified_desc'))}</p>
        <button id="resend-verify-btn" class="ev-resend-btn">
          <i class="fas fa-redo ev-btn-icon"></i>${escapeHtml(i18n.t('login.resend_email'))}
        </button>
      </div>
    `;

    loginForm.insertAdjacentElement('afterend', notice);

    document.getElementById('resend-verify-btn').addEventListener('click', async function() {
      this.disabled = true;
      this.innerHTML = `<i class="fas fa-circle-notch fa-spin ev-btn-icon"></i>${escapeHtml(i18n.t('login.resending'))}`;
      try {
        await auth.fetchWithTimeout('/api/auth/resend-verification', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: escapedEmail }),
        });
        this.innerHTML = `<i class="fas fa-check ev-btn-icon"></i>${escapeHtml(i18n.t('login.resent'))}`;
        this.classList.add('ev-resend-success');
        showToast(i18n.t('login.resent'), 'success');
      } catch {
        this.disabled = false;
        this.innerHTML = `<i class="fas fa-redo ev-btn-icon"></i>${escapeHtml(i18n.t('login.resend_email'))}`;
        showToast(i18n.t('login.server_error'), 'error');
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

    clearFieldError(document.getElementById("login-email"));
    clearFieldError(loginPassword);

    if (!isValidEmail(email)) {
      setFieldError(document.getElementById("login-email"), i18n.t('login.invalid_email'));
      return;
    }
    if (!password) {
      setFieldError(loginPassword, i18n.t('login.missing_password'));
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
    } catch {
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

    clearFieldError(document.getElementById("register-name"));
    clearFieldError(document.getElementById("register-email"));
    clearFieldError(registerPassword);

    if (name.length < 2) {
      setFieldError(document.getElementById("register-name"), i18n.t('login.name_too_short'));
      return;
    }
    if (!isValidEmail(email)) {
      setFieldError(document.getElementById("register-email"), i18n.t('login.invalid_email'));
      return;
    }
    if (!validatePassword(password)) {
      setFieldError(registerPassword, i18n.t('login.password_requirements'));
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
        showToast(i18n.t('login.register_success'), 'success');
        window.location.href = '/check-email?email=' + encodeURIComponent(email);
      } else if (response.status === 429) {
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
        setButtonLoading(submitBtn, false);
      } else {
        showToast(data.message || i18n.t('login.account_creation_failed'), 'error');
        setButtonLoading(submitBtn, false);
      }
    } catch {
      // Erreur gérée via toast
      showToast(i18n.t('login.server_error'), 'error');
      setButtonLoading(submitBtn, false);
    }
  });

  // Logout, ESC handler → nav.js
});