(function() {
  // L'adresse arrive par sessionStorage (login/forms.js), jamais par l'URL :
  // elle resterait dans l'historique et dans ce que lisent GTM et Sentry.
  // Un ancien lien ?email= reste lu, puis l'adresse est retirée de l'URL.
  const PENDING_KEY = 'vh_pending_email';
  const fromUrl = takeUrlParams(['email']).email;
  let email = fromUrl;
  try {
    if (fromUrl) sessionStorage.setItem(PENDING_KEY, fromUrl);
    else email = sessionStorage.getItem(PENDING_KEY);
  } catch {
    /* stockage indisponible : seule l'adresse de l'URL est connue */
  }

  // Afficher l'email dans la badge (avec protection XSS)
  const emailEl = document.getElementById('ce-email');
  if (email) {
    const div = document.createElement('div');
    div.textContent = email;
    emailEl.textContent = div.textContent;
  }

  const resendBtn = document.getElementById('ce-resend-btn');

  resendBtn.addEventListener('click', async function() {
    if (!email) return;

    this.disabled = true;
    this.innerHTML = '<div class="loading-spinner"></div>';

    try {
      await auth.fetchWithTimeout('/api/auth/resend-verification', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      });
      this.classList.add('sent');
      this.innerHTML = `<i class="fas fa-check"></i> ${i18n.t('check_email.resent')}`;
    } catch {
      this.disabled = false;
      this.innerHTML = `<i class="fas fa-redo"></i> ${i18n.t('check_email.resend')}`;
    }
  });
})();
