/* Paramètres — consentement aux cookies : interrupteur de la mesure d'audience
 * (seule finalité réglable depuis le retrait de la catégorie « préférence »,
 * LEGAL-006), enregistrement, ouverture de la modale de consentement,
 * synchronisation avec window.cookieConsent (cookies.js).
 *
 * Lecture et écriture passent par window.VH.consent (cookies.js, chargé avant
 * dans app.min.js) : lui seul connaît la clé, la forme stockée et la durée de
 * conservation du choix (6 mois, LEGAL-004).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  function consentApi() {
    return (root.VH && root.VH.consent) || null;
  }

  function updateToggleStatus(type, isEnabled) {
    const statusElement = document.getElementById(`${type}-status`);
    if (!statusElement) return;
    statusElement.textContent = isEnabled ? i18n.t('settings.enabled') : i18n.t('settings.disabled');
    // Classe plutôt qu'element.style (CSP) : couleur portée par settings.css.
    statusElement.classList.toggle('is-enabled', Boolean(isEnabled));
  }

  function formatConsentDate(timestamp) {
    return new Date(timestamp).toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  }

  function loadCookiePreferences() {
    const api = consentApi();
    const record = api ? api.record() : null;
    if (!record) return;
    const prefs = record.preferences;

    const analyticsToggle = document.getElementById('pref-analytics');
    if (analyticsToggle) {
      analyticsToggle.checked = prefs.analytics === true;
      updateToggleStatus('analytics', prefs.analytics === true);
    }

    const consentDate = document.getElementById('consent-date');
    if (consentDate && record.timestamp) {
      // Date rendue en JS : sans data-i18n, sinon un changement de langue la
      // remplacerait par « Jamais » (settings.never).
      consentDate.removeAttribute('data-i18n');
      consentDate.textContent = formatConsentDate(record.timestamp);
    }
  }

  function saveCookiePreferences() {
    const api = consentApi();
    if (!api) {
      showToast(i18n.t('settings.toast_cookies_unavailable'), 'error');
      return;
    }
    const analyticsToggle = document.getElementById('pref-analytics');
    const { preferences } = api.save({ analytics: analyticsToggle ? analyticsToggle.checked : false });

    if (window.cookieConsent) {
      window.cookieConsent.preferences = preferences;
      window.cookieConsent.applyConsent();
    }

    document.dispatchEvent(new CustomEvent('cookieConsent', {
      detail: { event: 'preferences_saved', preferences },
    }));

    loadCookiePreferences();
    showToast(i18n.t('settings.toast_cookies_saved'), 'success');
  }

  const RELOAD_EVENTS = ['analytics_enabled', 'analytics_disabled'];

  function init() {
    document.getElementById('save-cookie-preferences')?.addEventListener('click', saveCookiePreferences);

    document.getElementById('open-cookie-modal')?.addEventListener('click', () => {
      if (window.cookieConsent) {
        window.cookieConsent.openModal();
      } else {
        showToast(i18n.t('settings.toast_cookies_unavailable'), 'error');
      }
    });

    document.getElementById('pref-analytics')?.addEventListener('change', (e) => {
      updateToggleStatus('analytics', e.target.checked);
    });

    document.addEventListener('cookieConsent', (e) => {
      if (RELOAD_EVENTS.includes(e.detail.event)) loadCookiePreferences();
    });

    // État initial
    loadCookiePreferences();
  }

  VH.settings.cookies = { loadCookiePreferences, saveCookiePreferences, updateToggleStatus, init };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.cookies;
  }
})();
