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
      '<div class="filter-sheet-tabs" role="tablist" aria-label="Catégorie de filtres">' +
        '<button class="fs-tab active" data-tab="country" role="tab" aria-selected="true" aria-controls="fs-panel-country" id="fs-tab-country" tabindex="0">Pays</button>' +
        '<button class="fs-tab" data-tab="generation" role="tab" aria-selected="false" aria-controls="fs-panel-generation" id="fs-tab-generation" tabindex="-1">Génération</button>' +
        '<button class="fs-tab" data-tab="type" role="tab" aria-selected="false" aria-controls="fs-panel-type" id="fs-tab-type" tabindex="-1">Type</button>' +
      '</div>' +
      '<div class="filter-sheet-body" role="tabpanel" id="fs-panel-country" aria-labelledby="fs-tab-country" tabindex="0"></div>' +
      '<div class="filter-sheet-footer"><button class="btn btn-primary" id="fs-apply">Appliquer</button></div>';
    document.body.appendChild(dlg);

    let currentTab = 'country';

    function renderTab() {
      const body = dlg.querySelector('.filter-sheet-body');
      dlg.querySelectorAll('.fs-tab').forEach(t => {
        const isActive = t.dataset.tab === currentTab;
        t.classList.toggle('active', isActive);
        t.setAttribute('aria-selected', isActive ? 'true' : 'false');
        t.setAttribute('tabindex', isActive ? '0' : '-1');
      });
      body.id = `fs-panel-${currentTab}`;
      body.setAttribute('aria-labelledby', `fs-tab-${currentTab}`);
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

    const tabs = Array.from(dlg.querySelectorAll('.fs-tab'));
    tabs.forEach((t, idx) => {
      t.addEventListener('click', () => { currentTab = t.dataset.tab; renderTab(); });
      t.addEventListener('keydown', (e) => {
        let target = null;
        switch (e.key) {
          case 'ArrowRight': case 'ArrowDown': target = tabs[(idx + 1) % tabs.length]; break;
          case 'ArrowLeft': case 'ArrowUp':   target = tabs[(idx - 1 + tabs.length) % tabs.length]; break;
          case 'Home':                        target = tabs[0]; break;
          case 'End':                         target = tabs[tabs.length - 1]; break;
          default: return;
        }
        e.preventDefault();
        currentTab = target.dataset.tab;
        renderTab();
        target.focus();
      });
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
