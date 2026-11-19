/* Toggle grille/liste. Persiste dans localStorage + URL. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

    const toolbar = document.querySelector('.toolbar-right');
    const sortSel = document.getElementById('sort-select');
    if (toolbar && sortSel && !document.getElementById('view-toggle')) {
      const wrap = document.createElement('div');
      wrap.id = 'view-toggle';
      wrap.className = 'view-toggle';
      wrap.setAttribute('role', 'group');
      wrap.setAttribute('aria-label', 'Vue');
      wrap.innerHTML =
        '<button id="view-grid" class="view-btn" aria-pressed="true" aria-label="Vue grille"><i class="fas fa-th"></i></button>' +
        '<button id="view-list" class="view-btn" aria-pressed="false" aria-label="Vue liste"><i class="fas fa-list"></i></button>';
      // Le tri amélioré vit dans son enveloppe .cselect (shared/custom-select.js).
      const anchor = sortSel.closest('.cselect') || sortSel;
      anchor.parentNode.insertBefore(wrap, anchor);
    }

    function applyView() {
      container.classList.toggle('aircraft-list', state.view === 'list');
      container.classList.toggle('aircraft-grid', state.view === 'grid');
      const g = document.getElementById('view-grid');
      const l = document.getElementById('view-list');
      if (g) g.setAttribute('aria-pressed', String(state.view === 'grid'));
      if (l) l.setAttribute('aria-pressed', String(state.view === 'list'));
    }
    applyView();

    /* Bascule : chaque carte visible glisse de sa tuile à sa ligne (et
     * inversement) — VH.viewMorph, sinon d'un coup. */
    function switchTo(view) {
      if (state.view === view) return;
      state.view = view;
      localStorage.setItem('vh_hangar_view', view);
      if (VH.viewMorph) VH.viewMorph.swap({ root: container, update: applyView });
      else applyView();
      VH.hangar.filters.saveFiltersToSession(state);
    }
    document.getElementById('view-grid')?.addEventListener('click', () => switchTo('grid'));
    document.getElementById('view-list')?.addEventListener('click', () => switchTo('list'));
  }

  VH.hangar.viewToggle = { init };
})();
