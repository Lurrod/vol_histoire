// Soumission du formulaire contact via API backend
document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('contact-form');
  if (!form) return;

  const submitBtn = form.querySelector('.btn-send');
  const successMsg = document.getElementById('contact-success');

  form.addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = document.getElementById('contact-email').value.trim();
    const message = document.getElementById('contact-message').value.trim();

    if (!email || !isValidEmail(email)) {
      showToast(i18n.t('contact.form_error_email'), 'error');
      return;
    }
    if (!message) {
      showToast(i18n.t('contact.form_error_message'), 'error');
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
    submitBtn.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i> <span>' + i18n.t('contact.form_sending') + '</span>';

    try {
      const response = await fetch('/api/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        successMsg.classList.add('visible');
        form.reset();
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
      submitBtn.innerHTML = originalHTML;
    }
  });
});
