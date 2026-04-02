(function() {
  const form = document.getElementById('fp-form');
  const submitBtn = document.getElementById('fp-submit-btn');
  const errorEl = document.getElementById('fp-error');
  const formSection = document.getElementById('fp-form-section');
  const successEl = document.getElementById('fp-success');

  function showError(msg) {
    errorEl.textContent = msg;
    errorEl.style.display = 'block';
  }

  function hideError() {
    errorEl.style.display = 'none';
  }

  function setLoading(loading) {
    if (loading) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<div class="loading-spinner"></div>';
    } else {
      submitBtn.disabled = false;
      submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Envoyer le lien';
    }
  }

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideError();

    const email = document.getElementById('fp-email').value.trim();
    if (!email) return;

    setLoading(true);
    try {
      const res = await auth.fetchWithTimeout('/api/auth/forgot-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      });

      if (res.ok) {
        formSection.style.display = 'none';
        successEl.style.display = 'block';
      } else {
        const data = await res.json();
        showError(data.message || 'Une erreur est survenue.');
        setLoading(false);
      }
    } catch {
      showError('Impossible de contacter le serveur. Réessayez plus tard.');
      setLoading(false);
    }
  });
})();
