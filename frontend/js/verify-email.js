document.addEventListener('DOMContentLoaded', async () => {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token');

  const show = (id) => {
    ['state-loading', 'state-success', 'state-error'].forEach(s => {
      document.getElementById(s)?.classList.add('hidden');
    });
    document.getElementById(id)?.classList.remove('hidden');
  };

  if (!token) {
    document.getElementById('error-message').textContent = i18n.t('verify_email.error_missing_token');
    show('state-error');
    return;
  }

  try {
    const res = await auth.fetchWithTimeout('/api/auth/verify-email?token=' + encodeURIComponent(token));
    const data = await res.json();

    if (res.ok) {
      show('state-success');
    } else {
      document.getElementById('error-message').textContent =
        data.code === 'TOKEN_INVALID'
          ? i18n.t('verify_email.error_expired')
          : (data.message || i18n.t('common.error'));
      show('state-error');
    }
  } catch {
    document.getElementById('error-message').textContent = i18n.t('verify_email.error_network');
    show('state-error');
  }
});
