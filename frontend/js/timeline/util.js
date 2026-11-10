/* Frise — utilitaires : langue, dates, échappement d'attribut, défilement.
 * Aucune dépendance aux autres modules VH.timeline. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Décalage sous l'en-tête fixe quand on saute à un chapitre.
  const SCROLL_OFFSET = 80;

  function prefersReducedMotion() {
    return Boolean(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  // Défilement doux, sauf si l'utilisateur demande moins d'animations.
  function scrollBehavior() {
    return prefersReducedMotion() ? 'auto' : 'smooth';
  }

  function scrollToElement(el) {
    const y = el.getBoundingClientRect().top + window.pageYOffset - SCROLL_OFFSET;
    window.scrollTo({ top: y, behavior: scrollBehavior() });
  }

  /* Appelle fn au plus une fois par image pendant le défilement. */
  function onScrollFrame(fn) {
    let ticking = false;
    window.addEventListener('scroll', () => {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(() => { fn(); ticking = false; });
    }, { passive: true });
  }

  function currentLang() {
    return (window.i18n && window.i18n.currentLang) || 'fr';
  }

  function localized(obj, field) {
    const lang = currentLang();
    return obj[`${field}_${lang}`] || obj[`${field}_fr`] || obj[field] || '';
  }

  function fmtDate(dateStr) {
    if (!dateStr) return '';
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return '';
    const lang = currentLang();
    try {
      return d.toLocaleDateString(lang === 'en' ? 'en-US' : 'fr-FR',
        { day: 'numeric', month: 'long', year: 'numeric' });
    } catch {
      return d.toISOString().slice(0, 10);
    }
  }

  function escapeAttr(s) {
    return String(s || '').replace(/['"<>&]/g, c => ({
      "'": '&#39;', '"': '&quot;', '<': '&lt;', '>': '&gt;', '&': '&amp;'
    }[c]));
  }

  const api = {
    SCROLL_OFFSET,
    prefersReducedMotion,
    scrollBehavior,
    scrollToElement,
    onScrollFrame,
    currentLang,
    localized,
    fmtDate,
    escapeAttr,
  };
  window.VH.timeline.util = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
