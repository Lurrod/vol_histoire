document.addEventListener('DOMContentLoaded', async () => {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token');

  const show = (id) => {
    document.getElementById('state-loading').style.display = 'none';
    document.getElementById('state-success').style.display = 'none';
    document.getElementById('state-error').style.display = 'none';
    document.getElementById(id).style.display = 'block';
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
