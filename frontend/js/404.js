/* ======================================================================
   VOL D'HISTOIRE — 404 PAGE
   Affiche la route demandée dans le panneau télémétrie.
   Le hamburger et le user-dropdown sont gérés par nav.js (app.min.js).
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const pathEl = document.getElementById('requested-path');
  if (pathEl) {
    pathEl.textContent = window.location.pathname || '/unknown';
  }
});
