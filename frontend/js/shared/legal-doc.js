/* VH.legalDoc — en-tête des documents légaux (2026-11-21).
 *
 * Pages CGU, confidentialité, mentions légales, crédits photo : en-tête de
 * document (.doc-head) avec version, date de mise à jour et temps de lecture.
 *  - le temps de lecture est calculé sur le texte affiché (.legal-container),
 *    recalculé au changement de langue : 230 mots par minute, au moins 1 ;
 *  - le bouton [data-print] ouvre l'impression (« Enregistrer en PDF » du
 *    navigateur) ; la mise en page d'impression est dans legal.css.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const WORDS_PER_MINUTE = 230;

  /** @param {string} text @returns {number} minutes de lecture (≥ 1) */
  function readingMinutes(text) {
    const words = String(text || '').trim().split(/\s+/).filter(Boolean).length;
    return Math.max(1, Math.round(words / WORDS_PER_MINUTE));
  }

  function updateReadingTime(doc) {
    const d = doc || document;
    const out = d.querySelector('[data-reading-time]');
    const body = d.querySelector('.legal-container');
    if (!out || !body) return null;
    const minutes = readingMinutes(body.textContent);
    out.textContent = minutes + ' min';
    return minutes;
  }

  function init(doc) {
    const d = doc || document;
    const head = d.querySelector('.doc-head');
    if (!head) return false;
    const btn = head.querySelector('[data-print]');
    if (btn) btn.addEventListener('click', () => root.print());
    updateReadingTime(d);
    // Le texte traduit arrive après le chargement de la langue
    root.addEventListener('i18nReady', () => updateReadingTime(d));
    root.addEventListener('langChanged', () => updateReadingTime(d));
    return true;
  }

  root.VH.legalDoc = { init, readingMinutes, updateReadingTime };

  if (typeof document !== 'undefined') {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => init());
    else init();
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = root.VH.legalDoc;
})();
