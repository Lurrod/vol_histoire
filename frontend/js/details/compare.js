/* Fiche — bouton « Comparer ».
 * Ajoute ou retire l'appareil courant du comparateur partagé
 * (js/shared/compare.js). La barre flottante et la modale sont les mêmes
 * qu'au hangar : on peut donc composer une comparaison en naviguant de fiche
 * en fiche, puis l'ouvrir sans repasser par le listing.
 */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function setup(state) {
    const btn = document.getElementById('compare-btn');
    if (!btn || !VH.shared || !VH.shared.compare) return;
    const store = VH.shared.compare;
    const id = Number(state.aircraftId);

    // Pas de urlSync : l'URL d'une fiche doit rester celle de l'appareil.
    store.init({ urlSync: false });

    // L'état se lit sur le bouton lui-même : libellé et icône changent avec
    // aria-pressed. L'icône est remplacée par un nouvel <i> (icons.js ne
    // réagit pas à un changement de classe, seulement à une insertion).
    function syncButton() {
      const active = store.has(id);
      btn.classList.toggle('is-active', active);
      btn.setAttribute('aria-pressed', active ? 'true' : 'false');
      const label = btn.querySelector('span');
      if (label) {
        label.removeAttribute('data-i18n');
        label.textContent = i18n.t(active ? 'details.compare_in' : 'details.compare_add');
      }
      const oldIcon = btn.querySelector('svg.icon, i');
      const icon = document.createElement('i');
      icon.className = 'fas ' + (active ? 'fa-check' : 'fa-crosshairs');
      icon.setAttribute('aria-hidden', 'true');
      if (oldIcon) oldIcon.replaceWith(icon); else btn.prepend(icon);
    }

    btn.addEventListener('click', () => {
      const result = store.toggle(id);
      if (result === 'full') {
        if (typeof showToast === 'function') showToast(i18n.t('hangar.compare_max'), 'warning');
        return;
      }
      if (typeof showToast === 'function') {
        showToast(
          i18n.t(result === 'added' ? 'details.compare_added' : 'details.compare_removed'),
          result === 'added' ? 'success' : 'info'
        );
      }
    });

    store.onChange(syncButton);
    syncButton();
  }

  VH.details.compare = { setup };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.details.compare;
  }
})();
