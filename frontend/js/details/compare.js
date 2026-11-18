/* Fiche — bouton « Comparer ».
 * Ajoute ou retire l'appareil courant du comparateur partagé
 * (js/shared/compare.js). La barre flottante et la modale sont les mêmes
 * qu'au hangar : on peut donc composer une comparaison en naviguant de fiche
 * en fiche, puis l'ouvrir sans repasser par le listing.
 */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  const RETICLE_SVG =
    '<svg class="cmp-reticle" viewBox="0 0 24 24" aria-hidden="true" focusable="false">'
    + '<circle cx="12" cy="12" r="6.5"/>'
    + '<path class="cmp-tick cmp-tick-top" d="M12 1.5V7"/>'
    + '<path class="cmp-tick cmp-tick-bottom" d="M12 17v5.5"/>'
    + '<path class="cmp-tick cmp-tick-left" d="M1.5 12H7"/>'
    + '<path class="cmp-tick cmp-tick-right" d="M17 12h5.5"/>'
    + '<path class="cmp-check" pathLength="20" d="M8.7 12.3l2.3 2.3 4.3-4.6"/>'
    + '</svg>';

  function setup(state) {
    const btn = document.getElementById('compare-btn');
    if (!btn || !VH.shared || !VH.shared.compare) return;
    const store = VH.shared.compare;
    const id = Number(state.aircraftId);

    // Pas de urlSync : l'URL d'une fiche doit rester celle de l'appareil.
    store.init({ urlSync: false });

    // L'état se lit sur le bouton lui-même : libellé et viseur changent avec
    // aria-pressed. Le viseur est un SVG dessiné posé une seule fois : ses
    // graduations se resserrent et la coche se trace (details.css).
    function syncButton() {
      const active = store.has(id);
      btn.classList.toggle('is-active', active);
      btn.setAttribute('aria-pressed', active ? 'true' : 'false');
      // La clé suit l'état (data-i18n) : applyToDOM() la traduit au
      // chargement des traductions puis à chaque changement de langue. Tant
      // qu'elles ne sont pas chargées, le texte du HTML reste — jamais la clé
      // brute (« details.compare_add » s'affichait sur un chargement rapide).
      const label = btn.querySelector('span');
      if (label) {
        const key = active ? 'details.compare_in' : 'details.compare_add';
        label.setAttribute('data-i18n', key);
        if (i18n.isLoaded !== false) label.textContent = i18n.t(key);
      }
      if (!btn.querySelector('.cmp-reticle')) {
        const holder = document.createElement('span');
        holder.innerHTML = RETICLE_SVG;
        const oldIcon = btn.querySelector('svg.icon, i');
        if (oldIcon) oldIcon.replaceWith(holder.firstChild); else btn.prepend(holder.firstChild);
      }
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
