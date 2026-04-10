/* Filtres version mobile : bottom sheet avec onglets pays/génération/type. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    if (document.getElementById('filter-sheet')) return;
    const isMobile = () => window.matchMedia('(max-width: 767px)').matches;

    const dlg = document.createElement('dialog');
    dlg.id = 'filter-sheet';
    dlg.className = 'filter-sheet';
    dlg.innerHTML =
      '<div class="filter-sheet-header"><h3>Filtres</h3><button class="filter-sheet-close" aria-label="Fermer"><i class="fas fa-times"></i></button></div>' +
      '<div class="filter-sheet-tabs">' +
        '<button class="fs-tab active" data-tab="country">Pays</button>' +
        '<button class="fs-tab" data-tab="generation">Génération</button>' +
        '<button class="fs-tab" data-tab="type">Type</button>' +
      '</div>' +
      '<div class="filter-sheet-body"></div>' +
      '<div class="filter-sheet-footer"><button class="btn btn-primary" id="fs-apply">Appliquer</button></div>';
    document.body.appendChild(dlg);

    let currentTab = 'country';

    function renderTab() {
      const body = dlg.querySelector('.filter-sheet-body');
      dlg.querySelectorAll('.fs-tab').forEach(t => t.classList.toggle('active', t.dataset.tab === currentTab));
      let items = [];
      if (currentTab === 'country')    items = state.countries.map(c => ({ k: c.name_fr || c.name, l: c.name }));
      if (currentTab === 'generation') items = state.generations.map(g => ({ k: g, l: g + 'e Génération' }));
      if (currentTab === 'type')       items = state.types.map(t => ({ k: t.name_fr || t.name, l: t.name }));
      body.innerHTML = items.map(it => {
        const active = String(state.filters[currentTab]) === String(it.k);
        return '<button class="fs-item' + (active ? ' active' : '') +
               '" data-key="' + escapeHtml(String(it.k)) + '">' + escapeHtml(it.l) + '</button>';
      }).join('');
      body.querySelectorAll('.fs-item').forEach(btn => {
        btn.addEventListener('click', () => {
          const k = btn.dataset.key;
          state.filters[currentTab] = String(state.filters[currentTab]) === k ? null : (currentTab === 'generation' ? Number(k) : k);
          renderTab();
        });
      });
    }

    dlg.querySelectorAll('.fs-tab').forEach(t => {
      t.addEventListener('click', () => { currentTab = t.dataset.tab; renderTab(); });
    });
    dlg.querySelector('.filter-sheet-close').addEventListener('click', () => dlg.close());
    dlg.querySelector('#fs-apply').addEventListener('click', () => {
      dlg.close();
      state.currentPage = 1;
      VH.hangar.filters.saveFiltersToSession(state);
      VH.hangar.filters.applyFiltersAndRender(state);
      VH.hangar.filters.updateActiveFilters(state);
    });

    ['country-filter-btn', 'generation-filter-btn', 'type-filter-btn'].forEach(id => {
      const btn = document.getElementById(id);
      if (!btn) return;
      btn.addEventListener('click', e => {
        if (isMobile()) {
          e.stopImmediatePropagation();
          e.preventDefault();
          currentTab = id.split('-')[0];
          renderTab();
          try { dlg.showModal(); } catch (_) { dlg.setAttribute('open', ''); }
        }
      }, true);
    });
  }

  VH.hangar.mobileSheet = { init };
})();
