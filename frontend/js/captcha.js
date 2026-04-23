/**
 * hCaptcha lazy loader.
 *
 * Charge le widget hCaptcha à la demande SI le backend a une sitekey configurée
 * (lue depuis /api/config). En l'absence de sitekey, expose une fonction
 * `getHcaptchaToken` qui retourne null → le backend skip aussi la vérification.
 *
 * Mode invisible : on génère un token uniquement au moment de la soumission
 * du formulaire (via execute), pas au chargement de la page → 0 friction UX.
 */
(function () {
  'use strict';

  let sitekey = null;
  let scriptLoaded = false;
  let scriptLoading = null;
  const widgetIds = {};

  async function fetchSitekey() {
    if (sitekey !== null) return sitekey;
    try {
      const res = await fetch('/api/config');
      if (!res.ok) return null;
      const data = await res.json();
      sitekey = data.hcaptchaSitekey || null;
      return sitekey;
    } catch {
      return null;
    }
  }

  function loadScript() {
    if (scriptLoaded) return Promise.resolve();
    if (scriptLoading) return scriptLoading;
    scriptLoading = new Promise((resolve, reject) => {
      const s = document.createElement('script');
      s.src = 'https://js.hcaptcha.com/1/api.js?render=explicit';
      s.async = true;
      s.defer = true;
      s.onload = () => { scriptLoaded = true; resolve(); };
      s.onerror = () => reject(new Error('hCaptcha script load error'));
      document.head.appendChild(s);
    });
    return scriptLoading;
  }

  function ensureContainer(scopeName) {
    const id = 'hcaptcha-' + scopeName;
    let el = document.getElementById(id);
    if (!el) {
      el = document.createElement('div');
      el.id = id;
      el.style.position = 'fixed';
      el.style.left = '-9999px';
      document.body.appendChild(el);
    }
    return el;
  }

  /**
   * @param {string} scope - identifiant logique ('register', 'forgot', etc.)
   * @returns {Promise<string|null>} le token, ou null si captcha non configuré
   */
  async function getHcaptchaToken(scope) {
    const key = await fetchSitekey();
    if (!key) return null; // Pas de sitekey → backend skip la vérification

    await loadScript();
    if (typeof hcaptcha === 'undefined') return null;

    let widgetId = widgetIds[scope];
    if (widgetId == null) {
      const container = ensureContainer(scope);
      widgetId = hcaptcha.render(container, {
        sitekey: key,
        size: 'invisible',
      });
      widgetIds[scope] = widgetId;
    } else {
      hcaptcha.reset(widgetId);
    }

    return new Promise((resolve) => {
      hcaptcha.execute(widgetId, { async: true })
        .then((res) => resolve(res && res.response ? res.response : null))
        .catch(() => resolve(null));
    });
  }

  window.getHcaptchaToken = getHcaptchaToken;
})();
