/* ======================================================================
   VOL D'HISTOIRE — SETTINGS : COOKIE PREFERENCES
   Gestion des préférences cookies (toggles analytics/preference,
   save, ouverture de la modale, synchronisation avec window.cookieConsent).
   Dépend de : window.cookieConsent, i18n, showToast.
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  // Load current cookie preferences
  function loadCookiePreferences() {
    const consent = localStorage.getItem('voldhistoire_cookie_consent');
    if (!consent) return;
    let data;
    try { data = JSON.parse(consent); } catch { return; }
    const prefs = data.preferences;

    const analyticsToggle = document.getElementById('pref-analytics');
    const preferenceToggle = document.getElementById('pref-preference');

    if (analyticsToggle) {
      analyticsToggle.checked = prefs.analytics || false;
      updateToggleStatus('analytics', prefs.analytics);
    }

    if (preferenceToggle) {
      preferenceToggle.checked = prefs.preference || false;
      updateToggleStatus('preference', prefs.preference);
    }

    const consentDate = document.getElementById('consent-date');
    if (consentDate && data.timestamp) {
      const date = new Date(data.timestamp);
      consentDate.textContent = date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      });
    }
  }

  function updateToggleStatus(type, isEnabled) {
    const statusElement = document.getElementById(`${type}-status`);
    if (!statusElement) return;
    statusElement.textContent = isEnabled ? i18n.t('settings.enabled') : i18n.t('settings.disabled');
    statusElement.style.color = isEnabled ? 'var(--success)' : 'var(--text-secondary)';
  }

  function saveCookiePreferences() {
    const analyticsToggle = document.getElementById('pref-analytics');
    const preferenceToggle = document.getElementById('pref-preference');

    const preferences = {
      essential: true,
      analytics: analyticsToggle ? analyticsToggle.checked : false,
      preference: preferenceToggle ? preferenceToggle.checked : false,
      marketing: false,
    };

    const consentData = {
      preferences,
      timestamp: new Date().toISOString(),
      version: '1.0',
    };

    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify(consentData));

    // Cookie miroir pour lecture backend éventuelle
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 365);
    document.cookie = `voldhistoire_cookie_consent=true; expires=${expiryDate.toUTCString()}; path=/; SameSite=Lax`;

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

  // ── Event listeners ───────────────────────────────────────────────
  const savePrefsBtn = document.getElementById('save-cookie-preferences');
  const openModalBtn = document.getElementById('open-cookie-modal');
  const analyticsToggle = document.getElementById('pref-analytics');
  const preferenceToggle = document.getElementById('pref-preference');

  savePrefsBtn?.addEventListener('click', saveCookiePreferences);

  openModalBtn?.addEventListener('click', () => {
    if (window.cookieConsent) {
      window.cookieConsent.openModal();
    } else {
      showToast('Le système de cookies n\'est pas disponible', 'error');
    }
  });

  analyticsToggle?.addEventListener('change', (e) => {
    updateToggleStatus('analytics', e.target.checked);
  });

  preferenceToggle?.addEventListener('change', (e) => {
    updateToggleStatus('preference', e.target.checked);
  });

  document.addEventListener('cookieConsent', (e) => {
    const relevant = ['analytics_enabled', 'analytics_disabled', 'preferences_enabled', 'preferences_disabled'];
    if (relevant.includes(e.detail.event)) {
      loadCookiePreferences();
    }
  });

  // Charge l'état initial au chargement
  loadCookiePreferences();
});
