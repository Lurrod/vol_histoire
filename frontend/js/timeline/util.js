/* Frise — utilitaires : langue, dates, échappement d'attribut, défilement.
 * Aucune dépendance aux autres modules VH.timeline. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Décalage sous l'en-tête et la règle des années quand on saute à un chapitre.
  const SCROLL_OFFSET = 140;
  // Première année de la frise : l'ère couverte commence en 1945.
  const START_YEAR = 1945;

  function prefersReducedMotion() {
    return Boolean(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  // Défilement doux, sauf si l'utilisateur demande moins d'animations.
  function scrollBehavior() {
    return prefersReducedMotion() ? 'auto' : 'smooth';
  }

  /* Hauteur occupée en haut d'écran : en-tête + règle des années collée. */
  function scrollOffset() {
    const bar = document.getElementById('tl-bar');
    const top = bar && window.getComputedStyle ? parseFloat(window.getComputedStyle(bar).top) : NaN;
    const height = bar ? bar.getBoundingClientRect().height : 0;
    return Number.isFinite(top) && height > 0 ? Math.round(top + height + 12) : SCROLL_OFFSET;
  }

  function scrollToElement(el) {
    const y = el.getBoundingClientRect().top + window.pageYOffset - scrollOffset();
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

  /* Traduction ; tant que la langue n'est pas chargée, i18n.t renvoie la clé
   * (« timeline.chapter_label · 01 ») : on rend alors le repli fourni. */
  function t(key, fallback, params) {
    const value = window.i18n && typeof window.i18n.t === 'function' ? window.i18n.t(key, params) : key;
    return value && value !== key ? value : (fallback !== undefined ? fallback : key);
  }

  /* Résout quand i18n.js a chargé sa langue, ou au bout de `timeoutMs`. La
   * frise ne doit pas se rendre avant : ses libellés passent par i18n.t. */
  function whenI18nReady(timeoutMs = 3000) {
    return new Promise(resolve => {
      const start = Date.now();
      (function check() {
        const i18n = window.i18n;
        if (!i18n || i18n.isLoaded || Date.now() - start >= timeoutMs) return resolve();
        setTimeout(check, 25);
      })();
    });
  }

  function localized(obj, field) {
    const lang = currentLang();
    return obj[`${field}_${lang}`] || obj[`${field}_fr`] || obj[field] || '';
  }

  /* Nom propre affiché : variante anglaise si elle existe. */
  function localName(obj, field = 'name') {
    return (currentLang() === 'en' && obj[`${field}_en`]) ? obj[`${field}_en`] : (obj[field] || '');
  }

  /* Date de calendrier (« AAAA-MM-JJ ») formatée en UTC : lue dans le fuseau
   * du visiteur, elle reculait d'un jour aux Amériques. */
  function fmtDate(dateStr) {
    const d = window.VH.calendarDate.toUTCDate(dateStr);
    if (!d) return '';
    const lang = currentLang();
    try {
      return d.toLocaleDateString(lang === 'en' ? 'en-US' : 'fr-FR',
        { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' });
    } catch {
      return d.toISOString().slice(0, 10);
    }
  }

  function yearOf(dateStr) {
    if (!dateStr) return null;
    const y = parseInt(String(dateStr).slice(0, 4), 10);
    return Number.isFinite(y) ? y : null;
  }

  function currentYear() {
    return new Date().getFullYear();
  }

  function escapeAttr(s) {
    return String(s || '').replace(/['"<>&]/g, c => ({
      "'": '&#39;', '"': '&quot;', '<': '&lt;', '>': '&gt;', '&': '&amp;'
    }[c]));
  }

  const api = {
    SCROLL_OFFSET,
    START_YEAR,
    prefersReducedMotion,
    scrollBehavior,
    scrollOffset,
    scrollToElement,
    onScrollFrame,
    currentLang,
    t,
    whenI18nReady,
    localized,
    localName,
    fmtDate,
    yearOf,
    currentYear,
    escapeAttr,
  };
  window.VH.timeline.util = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
