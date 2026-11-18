/* Aides de test pour VH.motion : jsdom ne charge aucune feuille de style, donc
 * aucune durée de sortie n'est calculée et exit() rappelle aussitôt. On
 * injecte une feuille minimale pour que la sortie dure vraiment 200 ms, ce
 * que les tests font avancer avec les minuteries factices. */
const EXIT_MS = 200;

let motionApi = null;
let rollingApi = null;
let confirmApi = null;

/** Branche le vrai module sur window.VH (à rappeler si un test remplace
 *  window.VH) et déclare des durées de sortie pour `selectors`. */
function loadMotion(selectors = []) {
  window.VH = window.VH || {};
  if (!motionApi) {
    require('../../js/shared/motion');
    motionApi = window.VH.motion;
  }
  window.VH.motion = motionApi;
  // Compteurs « odomètre » des stats (hangar, favoris) : même principe.
  if (!rollingApi) {
    require('../../js/shared/rolling-number');
    rollingApi = window.VH.rollingNumber;
  }
  window.VH.rollingNumber = rollingApi;
  // Confirmation sur place (favoris, admin, comparateur) : même principe.
  if (!confirmApi) {
    require('../../js/shared/confirm-action');
    confirmApi = window.VH.confirmAction;
  }
  window.VH.confirmAction = confirmApi;
  const rules = selectors.map(s => `${s}{transition-duration:${EXIT_MS}ms}`).join('');
  let style = document.getElementById('test-motion-css');
  if (!style) {
    style = document.createElement('style');
    style.id = 'test-motion-css';
    document.head.appendChild(style);
  }
  style.textContent = rules;
}

module.exports = { loadMotion, EXIT_MS };
