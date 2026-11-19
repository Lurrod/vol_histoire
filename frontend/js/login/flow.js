/* Connexion — étapes par code reçu par email.
 *
 * Tout se passe sur /login, sans lien à cliquer :
 *   inscription (nom, email) ──┐
 *   « renvoyer le code »  ─────┼─→ code (6 chiffres) ─→ mot de passe ─→ connexion
 *   mot de passe oublié (email)┘
 *
 * Le code est d'abord vérifié seul (POST /api/auth/check-code, sans le
 * consommer) : le champ rejoue alors son succès (contours verts) ou son
 * erreur (rouge, secousse). Le mot de passe part ensuite avec le code
 * (verify-email ou reset-password), qui le consomme.
 *
 * Chaque étape porte une ancre (#code, #mot-de-passe, #mot-de-passe-oublie) :
 * le bouton « retour » du navigateur revient à l'étape précédente, et les
 * anciennes pages de liens redirigent ici (app.js).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  const RESEND_COOLDOWN_S = 30;
  // Le succès se lit (contours verts) avant de passer au mot de passe.
  const SUCCESS_FALLBACK_MS = 1200;

  const STEPS = {
    forgot: { hash: '#mot-de-passe-oublie', slide: 'forgotSlide' },
    code: { hash: '#code', slide: 'codeSlide' },
    password: { hash: '#mot-de-passe', slide: 'passwordSlide' },
  };

  // Textes propres à chaque parcours (activation / mot de passe oublié).
  const TEXTS = {
    verify: {
      codeTitle: 'login.code_title_verify',
      codeHint: 'login.code_hint_verify',
      passwordTitle: 'login.password_title_verify',
      passwordDesc: 'login.password_desc_verify',
      submit: 'login.password_submit_verify',
      done: 'login.account_activated',
      endpoint: '/api/auth/verify-email',
    },
    reset: {
      codeTitle: 'login.code_title_reset',
      codeHint: 'login.code_hint_reset',
      passwordTitle: 'login.password_title_reset',
      passwordDesc: 'login.password_desc_reset',
      submit: 'login.password_submit_reset',
      done: 'login.password_reset_done',
      endpoint: '/api/auth/reset-password',
    },
  };

  /** Texte traduit qui reste traduit : applyToDOM relit data-i18n à chaque changement de langue. */
  function setKey(el, key) {
    if (!el) return;
    el.setAttribute('data-i18n', key);
    el.textContent = i18n.t(key);
  }

  async function postJson(url, body) {
    const response = await auth.fetchWithTimeout(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    let data = {};
    try { data = await response.json(); } catch { /* réponse non JSON */ }
    return { response, data };
  }

  function setStatus(ctx, key, tone) {
    const el = ctx.els.codeStatus;
    if (!el) return;
    el.textContent = key ? i18n.t(key) : '';
    el.dataset.tone = tone || '';
  }

  // ── Navigation entre les étapes ────────────────────────────────────────

  /**
   * @param {'login'|'register'|'forgot'|'code'|'password'} name
   * @param {{ fromHistory?: boolean, focus?: boolean, after?: (panel: Element) => void }} [opts]
   *   after : appelé une fois le panneau affiché (préremplissage, focus).
   */
  function go(ctx, name, opts = {}) {
    const { tabs } = VH.login;
    if (name === 'login' || name === 'register') {
      if (!opts.fromHistory && location.hash) {
        history.replaceState(null, '', location.pathname + location.search);
      }
      // Retour depuis une étape : les formulaires gardent ce qui y était saisi.
      const fromFlow = !!ctx.els.container?.classList.contains('is-flow');
      tabs.activateTab(ctx, name === 'login' ? ctx.els.tabLogin : ctx.els.tabRegister, {
        focusInput: opts.focus !== false && !opts.after,
        reset: !fromFlow,
        after: opts.after || null,
      });
      return;
    }
    const step = STEPS[name];
    if (!opts.fromHistory && location.hash !== step.hash) {
      history.pushState({ vhLogin: name }, '', step.hash);
    }
    tabs.showSlide(ctx, ctx.els[step.slide], {
      after: (panel) => {
        if (opts.focus !== false) focusStep(ctx, name);
        if (opts.after) opts.after(panel);
      },
    });
  }

  function focusStep(ctx, name) {
    if (name === 'code') ctx.state.otp?.focus();
    else if (name === 'password') ctx.els.newPassword?.focus({ preventScroll: true });
    else if (name === 'forgot') ctx.els.forgotEmail?.focus({ preventScroll: true });
  }

  /** Ancre courante → étape (retour arrière, arrivée par une ancienne adresse). */
  function fromHash(ctx) {
    const hash = location.hash;
    const flow = ctx.state.flow;
    if (hash === STEPS.forgot.hash) return go(ctx, 'forgot', { fromHistory: true });
    if (hash === STEPS.code.hash && flow) return go(ctx, 'code', { fromHistory: true });
    if (hash === STEPS.password.hash && flow?.code) return go(ctx, 'password', { fromHistory: true });
    return go(ctx, 'login', { fromHistory: true, focus: false });
  }

  // ── Étape « code » ─────────────────────────────────────────────────────

  /** Entre dans l'étape « code » pour un parcours ('verify' ou 'reset'). */
  function startCode(ctx, type, email) {
    const texts = TEXTS[type];
    ctx.state.flow = { type, email, code: null };
    setKey(ctx.els.codeTitle, texts.codeTitle);
    setKey(ctx.els.codeHint, texts.codeHint);
    if (ctx.els.codeEmail) ctx.els.codeEmail.textContent = email;
    ctx.state.otp?.clear();
    ctx.state.otp?.setDisabled(false);
    setStatus(ctx, null);
    go(ctx, 'code');
  }

  /** Attend la fin du tracé vert de la dernière case (ou un délai de repli). */
  function afterSuccess(ctx, done) {
    const rings = ctx.els.codeOtp?.querySelectorAll('.otp-ring rect');
    const last = rings && rings[rings.length - 1];
    if (!last || VH.motion.prefersReducedMotion()) { done(); return; }
    let finished = false;
    const finish = () => { if (finished) return; finished = true; done(); };
    last.addEventListener('transitionend', finish, { once: true });
    setTimeout(finish, SUCCESS_FALLBACK_MS);
  }

  async function onCodeComplete(ctx, code) {
    const flow = ctx.state.flow;
    const otp = ctx.state.otp;
    if (!flow || !otp || ctx.state.checking) return;
    ctx.state.checking = true;
    otp.setDisabled(true);
    setStatus(ctx, 'login.code_checking');
    try {
      const { response, data } = await postJson('/api/auth/check-code', { email: flow.email, type: flow.type, code });
      if (response.ok) {
        flow.code = code;
        otp.setStatus('success');
        setStatus(ctx, 'login.code_valid', 'success');
        afterSuccess(ctx, () => preparePassword(ctx));
        return;
      }
      otp.setDisabled(false);
      otp.setStatus('error');
      if (response.status === 429) {
        ctx.els.codeStatus.textContent = data.message || i18n.t('login.too_many_attempts');
        ctx.els.codeStatus.dataset.tone = 'error';
      } else {
        setStatus(ctx, 'login.code_invalid', 'error');
      }
      otp.focus();
    } catch {
      otp.setDisabled(false);
      otp.setStatus('error');
      setStatus(ctx, 'login.server_error', 'error');
    } finally {
      ctx.state.checking = false;
    }
  }

  async function onResend(ctx) {
    const flow = ctx.state.flow;
    const button = ctx.els.codeResend;
    if (!flow || !button || button.disabled) return;
    button.disabled = true;
    try {
      if (flow.type === 'verify') {
        await postJson('/api/auth/resend-verification', { email: flow.email });
      } else {
        const captcha = window.getHcaptchaToken ? await window.getHcaptchaToken('forgot') : null;
        const body = { email: flow.email };
        if (captcha) body['h-captcha-response'] = captcha;
        await postJson('/api/auth/forgot-password', body);
      }
      // Réponse identique que le compte existe ou non : message au conditionnel.
      showToast(i18n.t('login.code_resent'), 'success');
      ctx.state.otp?.clear();
      setStatus(ctx, null);
      cooldown(button);
    } catch {
      button.disabled = false;
      showToast(i18n.t('login.server_error'), 'error');
    }
  }

  /** Bouton « Renvoyer » indisponible quelques secondes (compte à rebours). */
  function cooldown(button) {
    const label = button.querySelector('span');
    const key = label?.getAttribute('data-i18n') || 'login.code_resend';
    let left = RESEND_COOLDOWN_S;
    const tick = () => {
      if (left <= 0) {
        button.disabled = false;
        if (label) label.textContent = i18n.t(key);
        return;
      }
      if (label) label.textContent = `${i18n.t(key)} (${left})`;
      left -= 1;
      setTimeout(tick, 1000);
    };
    tick();
  }

  function onChangeEmail(ctx) {
    const flow = ctx.state.flow;
    if (!flow) return;
    if (flow.type === 'verify') {
      go(ctx, 'register', {
        after: () => {
          const input = document.getElementById('register-email');
          if (!input) return;
          input.value = flow.email;
          input.focus({ preventScroll: true });
          input.select();
        },
      });
    } else {
      go(ctx, 'forgot', {
        after: () => { if (ctx.els.forgotEmail) ctx.els.forgotEmail.value = flow.email; },
      });
    }
  }

  // ── Étape « mot de passe » ─────────────────────────────────────────────

  function preparePassword(ctx) {
    const texts = TEXTS[ctx.state.flow.type];
    setKey(ctx.els.passwordTitle, texts.passwordTitle);
    setKey(ctx.els.passwordDesc, texts.passwordDesc);
    setKey(ctx.els.passwordSubmitLabel, texts.submit);
    ctx.els.passwordForm?.reset();
    VH.login.strength.updatePasswordStrength(0);
    go(ctx, 'password');
  }

  function validateNewPassword(ctx) {
    const { newPassword, confirmPassword } = ctx.els;
    clearFieldError(newPassword);
    clearFieldError(confirmPassword);
    if (!VH.login.strength.validatePassword(newPassword.value)) {
      setFieldError(newPassword, i18n.t('login.password_requirements'));
      return false;
    }
    if (newPassword.value !== confirmPassword.value) {
      setFieldError(confirmPassword, i18n.t('login.password_mismatch'));
      return false;
    }
    return true;
  }

  async function onPasswordSubmit(ctx, event) {
    event.preventDefault();
    const flow = ctx.state.flow;
    if (!flow?.code || !validateNewPassword(ctx)) return;
    const { setButtonLoading } = VH.login.ui;
    const texts = TEXTS[flow.type];
    const button = ctx.els.passwordForm.querySelector('button[type="submit"]');
    setButtonLoading(button, true);
    try {
      const { response, data } = await postJson(texts.endpoint, {
        email: flow.email, code: flow.code, password: ctx.els.newPassword.value,
      });
      setButtonLoading(button, false);
      if (response.ok) {
        showToast(i18n.t(texts.done), 'success');
        const email = flow.email;
        ctx.state.flow = null;
        go(ctx, 'login', {
          after: () => {
            const loginEmail = document.getElementById('login-email');
            if (loginEmail) loginEmail.value = email;
            ctx.els.loginPassword?.focus({ preventScroll: true });
          },
        });
      } else if (data.code === 'CODE_INVALID') {
        // Code expiré ou consommé entre-temps : on en redemande un.
        showToast(i18n.t('login.code_expired'), 'error');
        startCode(ctx, flow.type, flow.email);
      } else {
        showToast(data.message || i18n.t('login.server_error'), 'error');
      }
    } catch {
      setButtonLoading(button, false);
      showToast(i18n.t('login.server_error'), 'error');
    }
  }

  // ── Mot de passe oublié ────────────────────────────────────────────────

  async function onForgotSubmit(ctx, event) {
    event.preventDefault();
    const input = ctx.els.forgotEmail;
    const email = input.value.trim();
    clearFieldError(input);
    if (!isValidEmail(email)) {
      setFieldError(input, i18n.t('login.invalid_email'));
      return;
    }
    const { setButtonLoading } = VH.login.ui;
    const button = ctx.els.forgotForm.querySelector('button[type="submit"]');
    setButtonLoading(button, true);
    try {
      const captcha = window.getHcaptchaToken ? await window.getHcaptchaToken('forgot') : null;
      const body = { email };
      if (captcha) body['h-captcha-response'] = captcha;
      const { response, data } = await postJson('/api/auth/forgot-password', body);
      setButtonLoading(button, false);
      if (response.ok) {
        startCode(ctx, 'reset', email);
      } else {
        showToast(data.message || i18n.t('login.server_error'), 'error');
      }
    } catch {
      setButtonLoading(button, false);
      showToast(i18n.t('login.server_error'), 'error');
    }
  }

  // ── Branchements ───────────────────────────────────────────────────────

  function setup(ctx) {
    const { els } = ctx;
    if (els.codeOtp && VH.otpInput) {
      ctx.state.otp = VH.otpInput.create(els.codeOtp, {
        // Langue pas encore chargée : i18n.t renvoie la clé, d'où le repli.
        label: i18n.t('login.code_label') === 'login.code_label' ? 'Code à 6 chiffres' : i18n.t('login.code_label'),
        describedBy: 'code-hint',
        onComplete: (code) => onCodeComplete(ctx, code),
        onChange: () => { if (!ctx.state.checking) setStatus(ctx, null); },
      });
    }

    els.openForgot?.addEventListener('click', (e) => {
      e.preventDefault();
      // L'adresse déjà tapée pour se connecter suit dans l'étape.
      const loginEmail = document.getElementById('login-email')?.value.trim();
      if (els.forgotEmail && loginEmail) els.forgotEmail.value = loginEmail;
      go(ctx, 'forgot');
    });
    els.forgotForm?.addEventListener('submit', (e) => onForgotSubmit(ctx, e));
    els.passwordForm?.addEventListener('submit', (e) => onPasswordSubmit(ctx, e));
    els.codeResend?.addEventListener('click', () => onResend(ctx));
    els.codeChangeEmail?.addEventListener('click', () => onChangeEmail(ctx));
    document.querySelectorAll('.flow-back').forEach((button) => {
      button.addEventListener('click', () => go(ctx, button.dataset.back || 'login'));
    });

    window.addEventListener('popstate', () => fromHash(ctx));
    // Arrivée par une ancienne adresse (/forgot-password → /login#mot-de-passe-oublie).
    if (location.hash === STEPS.forgot.hash) go(ctx, 'forgot', { fromHistory: true });
    else if (location.hash) history.replaceState(null, '', location.pathname + location.search);
  }

  VH.login.flow = {
    STEPS, TEXTS, setup, go, fromHash, startCode, onCodeComplete, onResend, onChangeEmail,
    preparePassword, validateNewPassword, onPasswordSubmit, onForgotSubmit, cooldown,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.flow;
  }
})();
