/* Frise — métadonnées d'ère (textes i18n) et ère active (HUD + teinte).
 *
 * Les couleurs d'ère ne vivent plus ici : timeline.css les porte en
 * --era-color sur `.tl-chapter[data-decade="…"]`. La teinte ambiante du
 * <body> (--tl-active-era) relit donc la couleur calculée du chapitre, pour
 * que la feuille de style reste l'unique source. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Repli quand aucune règle data-decade ne couvre la décennie.
  const FALLBACK_COLOR = 'var(--hud-cyan)';

  function getEra(decade) {
    return {
      label: i18n.t(`timeline.era_${decade}_label2`),
      title: i18n.t(`timeline.era_${decade}_title2`),
      narrative: i18n.t(`timeline.era_${decade}_narrative`),
    };
  }

  /* Couleur d'ère d'un chapitre, lue dans la cascade CSS. */
  function eraColor(section) {
    if (!section || typeof window.getComputedStyle !== 'function') return FALLBACK_COLOR;
    const value = window.getComputedStyle(section).getPropertyValue('--era-color').trim();
    return value || FALLBACK_COLOR;
  }

  /* Reporte le chapitre sur le HUD (décennie + libellé) et la teinte
   * ambiante. Renvoie la décennie affichée. */
  function showActiveEra(section) {
    const decade = Number(section.dataset.decade);
    const era = getEra(decade);
    const yearNum = document.getElementById('tl-year-hud-num');
    const yearLbl = document.getElementById('tl-year-hud-label');
    if (yearNum) yearNum.textContent = decade + 's';
    if (yearLbl) yearLbl.textContent = era.label || '';
    document.body.style.setProperty('--tl-active-era', eraColor(section));
    return decade;
  }

  function clearActiveEra() {
    document.body.style.removeProperty('--tl-active-era');
  }

  const api = { FALLBACK_COLOR, getEra, eraColor, showActiveEra, clearActiveEra };
  window.VH.timeline.era = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
