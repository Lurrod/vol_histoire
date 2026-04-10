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
      toolbar.insertBefore(wrap, sortSel);
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

    document.getElementById('view-grid')?.addEventListener('click', () => {
      state.view = 'grid';
      localStorage.setItem('vh_hangar_view', 'grid');
      applyView();
      VH.hangar.filters.saveFiltersToSession(state);
    });
    document.getElementById('view-list')?.addEventListener('click', () => {
      state.view = 'list';
      localStorage.setItem('vh_hangar_view', 'list');
      applyView();
      VH.hangar.filters.saveFiltersToSession(state);
    });
  }

  VH.hangar.viewToggle = { init };
})();
