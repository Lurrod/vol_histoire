/* Paramètres — petits utilitaires partagés par les modules VH.settings.*. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const API_BASE = '/api';

  /** Libellé traduit, ou repli français tant que la clé n'existe pas. */
  function tr(key, fallback) {
    const value = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key) : null;
    return value && value !== key ? value : fallback;
  }

  // Le libellé reste lu par les lecteurs d'écran pendant le chargement
  // (texte masqué visuellement) et aria-busy signale l'action en cours.
  function setButtonLoading(button, loading) {
    if (!button) return;

    if (loading) {
      const label = button.textContent.trim();
      button.disabled = true;
      button.setAttribute('aria-busy', 'true');
      button.dataset.originalHtml = button.innerHTML;
      button.innerHTML = `<span class="spinner" aria-hidden="true"></span><span class="sr-only">${escapeHtml(label)}</span>`;
    } else {
      button.disabled = false;
      button.removeAttribute('aria-busy');
      button.innerHTML = button.dataset.originalHtml;
    }
  }

  /** Défilement doux, sauf si l'utilisateur demande moins d'animations. */
  function scrollBehavior() {
    const reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    return reduce ? 'auto' : 'smooth';
  }

  VH.settings.ui = { API_BASE, tr, setButtonLoading, scrollBehavior };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.ui;
  }
})();
