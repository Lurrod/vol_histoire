/* Frise — métadonnées d'ère (textes i18n) et ère active (libellé de la
 * règle + teinte).
 *
 * Les couleurs d'ère ne vivent pas ici : timeline.css les porte en
 * --era-color sur `.tl-chapter[data-decade="…"]`. La teinte ambiante du
 * <body> (--tl-active-era) relit donc la couleur calculée du chapitre, pour
 * que la feuille de style reste l'unique source. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Repli quand aucune règle data-decade ne couvre la décennie.
  const FALLBACK_COLOR = 'var(--gold)';

  function getEra(decade) {
    const t = VH.timeline.util.t;
    return {
      label: t(`timeline.era_${decade}_label2`, ''),
      title: t(`timeline.era_${decade}_title2`, ''),
      narrative: t(`timeline.era_${decade}_narrative`, ''),
    };
  }

  /* Couleur d'ère d'un chapitre, lue dans la cascade CSS. */
  function eraColor(section) {
    if (!section || typeof window.getComputedStyle !== 'function') return FALLBACK_COLOR;
    const value = window.getComputedStyle(section).getPropertyValue('--era-color').trim();
    return value || FALLBACK_COLOR;
  }

  /* Reporte le chapitre sur la règle (libellé d'époque) et la teinte
   * ambiante. Renvoie la décennie du chapitre. */
  function showActiveEra(section) {
    const decade = Number(section.dataset.decade);
    const label = document.getElementById('tl-bar-era');
    if (label) label.textContent = getEra(decade).label || '';
    const color = eraColor(section);
    document.body.style.setProperty('--tl-active-era', color);
    const bar = document.getElementById('tl-bar');
    if (bar) bar.style.setProperty('--era-color', color);
    return decade;
  }

  function clearActiveEra() {
    document.body.style.removeProperty('--tl-active-era');
    const label = document.getElementById('tl-bar-era');
    if (label) label.textContent = '';
    const bar = document.getElementById('tl-bar');
    if (bar) bar.style.removeProperty('--era-color');
  }

  const api = { FALLBACK_COLOR, getEra, eraColor, showActiveEra, clearActiveEra };
  window.VH.timeline.era = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
