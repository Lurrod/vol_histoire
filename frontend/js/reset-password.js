(function() {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token');

  // Vérifier la présence du token
  if (!token) {
    document.getElementById('rp-form-section').classList.add('hidden');
    document.getElementById('rp-invalid').classList.remove('hidden');
    return;
  }

  const form = document.getElementById('rp-form');
  const submitBtn = document.getElementById('rp-submit-btn');
  const errorEl = document.getElementById('rp-error');
  const pwInput = document.getElementById('rp-password');
  const pwConfirmInput = document.getElementById('rp-password-confirm');
  const strengthFill = document.getElementById('strength-fill');
  const strengthHint = document.getElementById('strength-hint');

  // Afficher/masquer les mots de passe
  function setupToggle(btnId, inputEl) {
    document.getElementById(btnId).addEventListener('click', () => {
      const icon = document.querySelector('#' + btnId + ' i');
      if (inputEl.type === 'password') {
        inputEl.type = 'text';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
      } else {
        inputEl.type = 'password';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
      }
    });
  }
  setupToggle('toggle-rp-pw', pwInput);
  setupToggle('toggle-rp-pw-confirm', pwConfirmInput);

  // Indicateur de force
  pwInput.addEventListener('input', () => {
    const pw = pwInput.value;
    let strength = 0;
    if (pw.length >= 8) strength += 25;
    if (/[a-z]/.test(pw)) strength += 20;
    if (/[A-Z]/.test(pw)) strength += 25;
    if (/[0-9]/.test(pw)) strength += 20;
    if (pw.length >= 12) strength += 10;
    strength = Math.min(strength, 100);
    strengthFill.style.width = strength + '%';
    if (strength < 40) {
      strengthFill.style.background = '#e74c3c';
      strengthHint.textContent = 'Mot de passe trop faible';
    } else if (strength < 70) {
      strengthFill.style.background = '#f39c12';
      strengthHint.textContent = 'Mot de passe moyen';
    } else {
      strengthFill.style.background = '#34d964';
      strengthHint.textContent = 'Mot de passe fort';
    }
  });

  function showError(msg) {
    errorEl.textContent = msg;
    errorEl.style.display = 'block';
    pwInput.setAttribute('aria-invalid', 'true');
  }
  function hideError() {
    errorEl.style.display = 'none';
    pwInput.removeAttribute('aria-invalid');
    pwConfirmInput.removeAttribute('aria-invalid');
  }

  function setLoading(loading) {
    if (loading) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<div class="loading-spinner"></div>';
    } else {
      submitBtn.disabled = false;
      submitBtn.innerHTML = '<i class="fas fa-lock"></i> Enregistrer le mot de passe';
    }
  }

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideError();

    const password = pwInput.value;
    const confirm = pwConfirmInput.value;

    if (password !== confirm) {
      showError('Les mots de passe ne correspondent pas.');
      return;
    }
    if (password.length < 8 || !/[a-z]/.test(password) || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
      showError('Mot de passe invalide : 8 caractères min, 1 majuscule, 1 minuscule, 1 chiffre.');
      return;
    }

    setLoading(true);
    try {
      const res = await auth.fetchWithTimeout('/api/auth/reset-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token, password }),
      });
      const data = await res.json();

      if (res.ok) {
        document.getElementById('rp-form-section').innerHTML =
          '<div style="text-align:center;padding:1rem 0">' +
          '<i class="fas fa-check-circle" style="font-size:2.5rem;color:#34d964;display:block;margin-bottom:1rem"></i>' +
          '<h2 style="color:#fff;margin:0 0 0.5rem">Mot de passe modifié !</h2>' +
          '<p style="color:rgba(255,255,255,0.45);margin:0 0 1.5rem">Redirection vers la connexion...</p>' +
          '</div>';
        setTimeout(() => { window.location.href = '/login'; }, 2000);
      } else {
        if (data.code === 'TOKEN_INVALID') {
          document.getElementById('rp-form-section').style.display = 'none';
          document.getElementById('rp-invalid').style.display = 'block';
        } else {
          showError(data.message || 'Une erreur est survenue.');
          setLoading(false);
        }
      }
    } catch {
      showError('Impossible de contacter le serveur. Réessayez plus tard.');
      setLoading(false);
    }
  });
})();
