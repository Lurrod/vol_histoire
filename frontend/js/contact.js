// Soumission du formulaire contact via API backend
document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('contact-form');
  if (!form) return;

  const submitBtn = form.querySelector('.btn-send');
  const successMsg = document.getElementById('contact-success');
  // Avion du bouton (contact.css) : data-state idle → sending → done.
  const sendLabel = submitBtn?.querySelector('span');
  let sendResetTimer = null;
  const SEND_DONE_MS = 1800;

  const emailEl = document.getElementById('contact-email');
  const messageEl = document.getElementById('contact-message');

  // Nettoyage de l'erreur au fur et à mesure que l'utilisateur corrige.
  emailEl?.addEventListener('input', () => clearFieldError(emailEl));
  messageEl?.addEventListener('input', () => clearFieldError(messageEl));

  // Le message de succès concerne l'envoi précédent : il s'efface en fondu
  // dès que l'utilisateur reprend la saisie (VH.motion.exit attend la durée
  // réelle de la transition définie dans contact.css).
  let cancelHide = null;

  function showSuccess() {
    if (cancelHide) { cancelHide(); cancelHide = null; }
    successMsg.classList.remove('is-hiding');
    successMsg.classList.add('visible');
  }

  function hideSuccess() {
    if (!successMsg?.classList.contains('visible') || successMsg.classList.contains('is-hiding')) return;
    cancelHide = window.VH.motion.exit(successMsg, () => {
      successMsg.classList.remove('visible');
      successMsg.querySelector('.t-success-check')?.setAttribute('data-state', 'out');
      cancelHide = null;
    }, { className: 'is-hiding' });
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
    // L'avion décolle (CSS) ; le libellé passe à « Envoi… » le temps de la requête.
    const labelText = sendLabel ? sendLabel.textContent : '';
    const labelKey = sendLabel ? sendLabel.getAttribute('data-i18n') : null;
    clearTimeout(sendResetTimer);
    let sent = false;
    submitBtn.disabled = true;
    submitBtn.setAttribute('aria-busy', 'true');
    submitBtn.dataset.state = 'sending';
    if (sendLabel) {
      sendLabel.removeAttribute('data-i18n');
      sendLabel.textContent = i18n.t('contact.form_sending');
    }

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
        sent = true;
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
      submitBtn.removeAttribute('aria-busy');
      if (sendLabel) {
        if (labelKey) sendLabel.setAttribute('data-i18n', labelKey);
        // Relu dans la langue courante (elle a pu changer pendant la
        // requête) ; traduction absente → texte d'origine, jamais la clé.
        const translated = labelKey ? i18n.t(labelKey) : '';
        sendLabel.textContent = translated && translated !== labelKey ? translated : labelText;
      }
      // Succès : la coche se trace puis l'avion se repose — le bouton reste
      // désactivé pendant la coche (pas de second envoi sur un bouton qui
      // affiche « envoyé ») ; échec : l'avion revient se poser aussitôt.
      submitBtn.dataset.state = sent ? 'done' : 'idle';
      if (sent) {
        sendResetTimer = setTimeout(() => {
          submitBtn.dataset.state = 'idle';
          submitBtn.disabled = false;
        }, SEND_DONE_MS);
      } else {
        submitBtn.disabled = false;
      }
    }
  });
});
