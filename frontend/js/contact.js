// Soumission du formulaire contact via API backend
document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('contact-form');
  if (!form) return;

  const submitBtn = form.querySelector('.btn-send');
  const successMsg = document.getElementById('contact-success');

  const emailEl = document.getElementById('contact-email');
  const messageEl = document.getElementById('contact-message');

  // Nettoyage de l'erreur au fur et à mesure que l'utilisateur corrige.
  emailEl?.addEventListener('input', () => clearFieldError(emailEl));
  messageEl?.addEventListener('input', () => clearFieldError(messageEl));

  // Le message de succès concerne l'envoi précédent : il s'efface en fondu
  // dès que l'utilisateur reprend la saisie (durée alignée sur contact.css).
  const SUCCESS_FADE_MS = 200;
  let successHideTimer = null;

  function showSuccess() {
    clearTimeout(successHideTimer);
    successMsg.classList.remove('is-hiding');
    successMsg.classList.add('visible');
  }

  function hideSuccess() {
    if (!successMsg?.classList.contains('visible') || successMsg.classList.contains('is-hiding')) return;
    successMsg.classList.add('is-hiding');
    successHideTimer = setTimeout(() => {
      successMsg.classList.remove('visible', 'is-hiding');
      successMsg.querySelector('.t-success-check')?.setAttribute('data-state', 'out');
    }, SUCCESS_FADE_MS);
  }

  form.addEventListener('input', hideSuccess);
  form.addEventListener('change', hideSuccess);

  form.addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = emailEl.value.trim();
    const message = messageEl.value.trim();

    clearFieldError(emailEl);
    clearFieldError(messageEl);

    if (!email || !isValidEmail(email)) {
      setFieldError(emailEl, i18n.t('contact.form_error_email'));
      emailEl.focus();
      return;
    }
    if (!message) {
      setFieldError(messageEl, i18n.t('contact.form_error_message'));
      messageEl.focus();
      return;
    }

    const payload = {
      firstname: document.getElementById('contact-firstname').value.trim(),
      lastname: document.getElementById('contact-lastname').value.trim(),
      email,
      subject: document.getElementById('contact-subject').value,
      message,
    };

    // Loading state
    const originalHTML = submitBtn.innerHTML;
    submitBtn.disabled = true;
    submitBtn.setAttribute('aria-busy', 'true');
    submitBtn.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i> <span>' + i18n.t('contact.form_sending') + '</span>';

    try {
      // Token hCaptcha (invisible). Null si HCAPTCHA_SITEKEY non configuré
      // côté backend → le middleware skippe aussi la vérification.
      const captchaToken = window.getHcaptchaToken ? await window.getHcaptchaToken('contact') : null;
      if (captchaToken) payload['h-captcha-response'] = captchaToken;

      const response = await fetch('/api/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        // form.reset() ne déclenche ni input ni change : le message reste
        // affiché jusqu'à la prochaine saisie.
        form.reset();
        showSuccess();
        // transitions-dev (success check) : rejoue le stroke-draw via
        // data-state. La longueur du tracé (≈ 31) tient dans le repli CSS
        // de 32 : plus d'écriture dans element.style, interdite par la CSP.
        const successCheck = successMsg.querySelector('.t-success-check');
        if (successCheck) {
          successCheck.setAttribute('data-state', 'out');
          void successCheck.offsetWidth; // reflow → rejoue le tracé
          successCheck.setAttribute('data-state', 'in');
        }
        showToast(i18n.t('contact.form_success'), 'success');
      } else if (response.status === 429) {
        const data = await response.json().catch(() => ({}));
        showToast(data.message || i18n.t('login.too_many_attempts'), 'error');
      } else {
        showToast(i18n.t('contact.form_error_send'), 'error');
      }
    } catch {
      showToast(i18n.t('contact.form_error_send'), 'error');
    } finally {
      submitBtn.disabled = false;
      submitBtn.removeAttribute('aria-busy');
      submitBtn.innerHTML = originalHTML;
    }
  });
});
