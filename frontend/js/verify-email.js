(async function() {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token');

  const show = (id) => {
    document.getElementById('state-loading').style.display = 'none';
    document.getElementById('state-success').style.display = 'none';
    document.getElementById('state-error').style.display = 'none';
    document.getElementById(id).style.display = 'block';
  };

  if (!token) {
    document.getElementById('error-message').textContent = 'Aucun token de vérification trouvé dans l\'URL.';
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
          ? 'Ce lien est invalide ou a expiré. Reconnectez-vous pour renvoyer un email.'
          : (data.message || 'Une erreur est survenue.');
      show('state-error');
    }
  } catch {
    document.getElementById('error-message').textContent = 'Impossible de contacter le serveur. Réessayez plus tard.';
    show('state-error');
  }
})();
