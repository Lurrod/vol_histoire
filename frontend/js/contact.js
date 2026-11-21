// Page contact : sujet en pastilles, fiche concernée (?fiche=<id>), compteur
// du message, adresse à copier, envoi via l'API (POST /api/contact).
document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('contact-form');
  if (!form) return;

  const MESSAGE_MAX = 5000;
  const SEND_DONE_MS = 1800;
  const COPIED_MS = 1600;
  // Sujet → ligne des délais de réponse (partenariat et autre : aucune).
  const DELAY_TOPIC = { general: 'general', bug: 'bug', contrib: 'contrib' };

  const submitBtn = form.querySelector('.btn-send');
  const successMsg = document.getElementById('contact-success');
  // Avion du bouton (contact.css) : data-state idle → sending → done.
  const sendLabel = submitBtn?.querySelector('span');
  let sendResetTimer = null;

  const nameEl = document.getElementById('contact-name');
  const emailEl = document.getElementById('contact-email');
  const messageEl = document.getElementById('contact-message');
  const countEl = document.getElementById('contact-count');

  // Traduction avec repli : tant que les locales ne sont pas chargées,
  // i18n.t() renvoie la clé.
  function tr(key, fallback, params) {
    const value = i18n.t(key, params);
    return value && value !== key ? value : fallback;
  }

  // ── Sujet ────────────────────────────────────────────────────────────
  function selectedSubject() {
    const checked = form.querySelector('input[name="subject"]:checked');
    return checked ? checked.value : 'general';
  }

  function selectSubject(value) {
    // Valeur lue dans l'adresse : comparée aux pastilles, jamais injectée
    // dans un sélecteur.
    const radio = Array.from(form.querySelectorAll('input[name="subject"]')).find((r) => r.value === value);
    if (radio) radio.checked = true;
    syncDelays();
  }

  // La ligne des délais qui correspond au sujet choisi est mise en avant.
  function syncDelays() {
    const topic = DELAY_TOPIC[selectedSubject()];
    document.querySelectorAll('.contact-delays [data-topic]').forEach((row) => {
      row.classList.toggle('is-active', row.dataset.topic === topic);
    });
  }

  form.addEventListener('change', (e) => {
    if (e.target.name === 'subject') syncDelays();
  });

  // ── Compteur du message ──────────────────────────────────────────────
  function formatCount(n) {
    const locale = i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR';
    return n.toLocaleString(locale);
  }

  function syncCount() {
    if (!countEl || !messageEl) return;
    const length = messageEl.value.length;
    const params = { n: formatCount(length), max: formatCount(MESSAGE_MAX) };
    countEl.textContent = tr('contact.form_count', `${params.n} / ${params.max}`, params);
    countEl.classList.toggle('is-near', length >= MESSAGE_MAX * 0.9);
  }

  messageEl?.addEventListener('input', syncCount);
  window.addEventListener('langChanged', syncCount);

  // ── Fiche concernée ──────────────────────────────────────────────────
  const aircraftBox = document.getElementById('contact-aircraft');
  const aircraftLink = document.getElementById('contact-aircraft-link');
  let aircraftId = null;

  function clearAircraft() {
    aircraftId = null;
    if (aircraftBox) aircraftBox.hidden = true;
    // L'adresse ne garde plus la fiche (un rechargement ne la remettrait pas).
    const url = new URL(window.location.href);
    if (url.searchParams.has('fiche')) {
      url.searchParams.delete('fiche');
      window.history.replaceState(window.history.state, '', url.pathname + url.search + url.hash);
    }
  }

  async function loadAircraft(id) {
    try {
      const res = await fetch(`/api/airplanes/${id}`);
      if (!res.ok) return;
      const data = await res.json();
      const aircraft = data && (data.data || data);
      if (!aircraft || !aircraft.name) return;
      aircraftId = Number(id);
      aircraftLink.textContent = aircraft.name;
      aircraftLink.href = window.VH?.shared?.buildDetailsPath
        ? window.VH.shared.buildDetailsPath(aircraftId, aircraft.name)
        : `/details?id=${aircraftId}`;
      aircraftBox.hidden = false;
    } catch {
      // Fiche illisible : le formulaire reste utilisable sans elle.
    }
  }

  document.getElementById('contact-aircraft-remove')?.addEventListener('click', () => {
    clearAircraft();
    messageEl?.focus();
  });

  // ?sujet=bug&fiche=30 (lien « Signaler une erreur » des fiches).
  const params = new URLSearchParams(window.location.search);
  const subjectParam = params.get('sujet');
  if (subjectParam) selectSubject(subjectParam);
  const ficheParam = params.get('fiche');
  if (ficheParam && /^\d{1,9}$/.test(ficheParam) && aircraftBox && aircraftLink) {
    loadAircraft(ficheParam);
  }

  // ── Adresse à copier ─────────────────────────────────────────────────
  const copyBtn = document.getElementById('contact-copy');
  let copiedTimer = null;
  copyBtn?.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(copyBtn.dataset.copy);
      copyBtn.classList.add('is-copied');
      clearTimeout(copiedTimer);
      copiedTimer = setTimeout(() => copyBtn.classList.remove('is-copied'), COPIED_MS);
      showToast(tr('contact.copied', 'Adresse copiée'), 'success');
    } catch {
      showToast(tr('contact.copy_failed', 'Copie impossible : sélectionnez l’adresse à la main.'), 'error');
    }
  });

  // ── Erreurs et message de succès ─────────────────────────────────────
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

  function validate(email, message) {
    clearFieldError(emailEl);
    clearFieldError(messageEl);
    if (!email || !isValidEmail(email)) {
      setFieldError(emailEl, i18n.t('contact.form_error_email'));
      emailEl.focus();
      return false;
    }
    if (!message) {
      setFieldError(messageEl, i18n.t('contact.form_error_message'));
      messageEl.focus();
      return false;
    }
    return true;
  }

  function onSent() {
    // form.reset() ne déclenche ni input ni change : le message reste
    // affiché jusqu'à la prochaine saisie. La fiche concernée ne vaut que
    // pour ce message.
    form.reset();
    clearAircraft();
    syncDelays();
    syncCount();
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
  }

  form.addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = emailEl.value.trim();
    const message = messageEl.value.trim();
    if (!validate(email, message)) return;

    const payload = {
      name: nameEl ? nameEl.value.trim() : '',
      email,
      subject: selectedSubject(),
      message,
    };
    if (aircraftId) payload.aircraft_id = aircraftId;

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
        onSent();
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

  syncDelays();
  syncCount();
});
