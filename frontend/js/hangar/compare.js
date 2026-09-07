/* ======================================================================
   HANGAR — cases à cocher du comparateur.
   L'état, la barre flottante et la modale vivent dans js/shared/compare.js
   (partagés avec la fiche) ; ce module ne fait que poser les cases sur les
   cartes et les garder synchronisées avec le magasin.
   ====================================================================== */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    const container = document.getElementById('airplanes-container');
    if (!container) return;
    const store = VH.shared.compare;

    // Le hangar est la page qui reflète la sélection dans l'URL et qui sait
    // ouvrir une comparaison reçue par lien.
    store.init({ urlSync: true });
    state.compareIds = store.getIds();

    function addCheckboxes() {
      container.querySelectorAll('.aircraft-card').forEach(card => {
        const id = Number(card.dataset.id);
        const existing = card.querySelector('.compare-check input');
        if (existing) { existing.checked = store.has(id); return; }
        const label = document.createElement('label');
        label.className = 'compare-check';
        label.innerHTML =
          '<input type="checkbox" data-compare-id="' + id + '"' +
          (store.has(id) ? ' checked' : '') + '>' +
          '<span>' + escapeHtml(i18n.t('hangar.compare_label')) + '</span>';
        label.addEventListener('click', e => e.stopPropagation());
        card.appendChild(label);
      });
    }

    new MutationObserver(addCheckboxes).observe(container, { childList: true });
    addCheckboxes();

    container.addEventListener('change', e => {
      const cb = e.target.closest('[data-compare-id]');
      if (!cb) return;
      const id = Number(cb.dataset.compareId);
      const result = store.toggle(id);
      if (result === 'full') {
        cb.checked = false;
        if (typeof showToast === 'function') showToast(i18n.t('hangar.compare_max'), 'warning');
        return;
      }
      cb.checked = (result === 'added');
    });

    // Une sélection modifiée ailleurs (modale, barre, lien partagé) doit se
    // relire sur les cases visibles.
    store.onChange(ids => {
      state.compareIds = ids;
      container.querySelectorAll('[data-compare-id]').forEach(cb => {
        cb.checked = ids.includes(Number(cb.dataset.compareId));
      });
    });
  }

  VH.hangar.compare = { init };
})();
