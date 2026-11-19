/* Connexion / inscription — compteurs du panneau visuel, état de chargement
 * des boutons, avis « compte non activé » avec envoi d'un code. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

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

      // Compteurs animés (VH.rollingNumber, odomètre)
      VH.rollingNumber.set(elAirplanes, data.airplanes);
      VH.rollingNumber.set(elCountries, data.countries);

      if (data.earliest_year && data.latest_year) {
        VH.rollingNumber.set(elYears, data.latest_year - data.earliest_year);
        elYearsLabel.textContent = i18n.t('login.years_label');
      }
    } catch {
      // Repli statique si l'API n'est pas joignable
      elAirplanes.textContent = '45+';
      elYears.textContent = '1950';
      elYearsLabel.textContent = i18n.t('login.years_label');
      elCountries.textContent = '12';
    }
  }

  // ========== Loading State ==========
  // Partagé avec les Paramètres : VH.busyButton (largeur figée, anneau à
  // la place du libellé, libellé toujours lu par les lecteurs d'écran).
  function setButtonLoading(button, loading) {
    if (!button) return;
    button.classList.toggle('is-loading', !!loading);
    if (loading) VH.busyButton.start(button);
    else VH.busyButton.stop(button);
  }

  // ========== Email non vérifié ==========
  function resendButtonHtml(icon, labelKey) {
    return `<i class="fas ${icon} ev-btn-icon" aria-hidden="true"></i>${escapeHtml(i18n.t(labelKey))}`;
  }

  async function resendVerification(button, email, ctx) {
    button.disabled = true;
    button.setAttribute('aria-busy', 'true');
    button.innerHTML = resendButtonHtml('fa-circle-notch fa-spin', 'login.resending');
    try {
      await auth.fetchWithTimeout('/api/auth/resend-verification', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      });
      button.removeAttribute('aria-busy');
      button.innerHTML = resendButtonHtml('fa-check', 'login.resent');
      button.classList.add('ev-resend-success');
      // Réponse du serveur identique que le compte existe ou non : message
      // au conditionnel, puis l'étape « code » sur la même page.
      showToast(i18n.t('login.resent_notice'), 'success');
      if (ctx && VH.login.flow) {
        document.getElementById('email-not-verified-notice')?.remove();
        VH.login.flow.startCode(ctx, 'verify', email);
      }
    } catch {
      button.disabled = false;
      button.removeAttribute('aria-busy');
      button.innerHTML = resendButtonHtml('fa-redo', 'login.resend_email');
      showToast(i18n.t('login.server_error'), 'error');
    }
  }

  function showEmailNotVerifiedNotice(ctx, email) {
    // Supprimer une notice existante
    document.getElementById('email-not-verified-notice')?.remove();

    const notice = document.createElement('div');
    notice.id = 'email-not-verified-notice';
    notice.className = 'ev-notice';

    // L'adresse n'est pas insérée dans le HTML : elle part telle quelle dans
    // le corps JSON (l'ancienne version l'échappait pour le HTML d'abord,
    // donc o'brien@… ou a&b@… arrivaient faussées au serveur).
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

    ctx.els.loginForm.insertAdjacentElement('afterend', notice);

    const button = document.getElementById('resend-verify-btn');
    button.addEventListener('click', () => resendVerification(button, email, ctx));
  }

  VH.login.ui = { fetchStats, setButtonLoading, showEmailNotVerifiedNotice, resendVerification };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.ui;
  }
})();
