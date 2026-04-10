(function() {
  const params = new URLSearchParams(window.location.search);
  const email = params.get('email');

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
