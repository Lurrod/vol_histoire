/* Filtres version mobile : bottom sheet avec onglets pays/génération/type/conflit/mission. */
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
        '<button class="fs-tab" data-tab="war" role="tab" aria-selected="false" aria-controls="fs-panel-war" id="fs-tab-war" tabindex="-1">Conflit</button>' +
        '<button class="fs-tab" data-tab="mission" role="tab" aria-selected="false" aria-controls="fs-panel-mission" id="fs-tab-mission" tabindex="-1">Mission</button>' +
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
      if (currentTab === 'war')        items = (state.wars || []).map(w => ({ k: w.name_fr || w.name, l: w.name }));
      if (currentTab === 'mission')    items = (state.missions || []).map(m => ({ k: m.name_fr || m.name, l: m.name }));
      body.innerHTML = items.map(it => {
        const active = String(state.filters[currentTab]) === String(it.k);
        return '<button type="button" class="fs-item' + (active ? ' active' : '') +
               '" aria-pressed="' + active + '" data-key="' + escapeHtml(String(it.k)) + '">' + escapeHtml(it.l) + '</button>';
      }).join('');
      body.querySelectorAll('.fs-item').forEach(btn => {
        btn.addEventListener('click', () => {
          const k = btn.dataset.key;
          const same = String(state.filters[currentTab]) === k;
          state.filters[currentTab] = same ? null : (currentTab === 'generation' ? Number(k) : k);
          // Mise à jour en place plutôt qu'un nouveau rendu : le focus reste
          // sur le bouton touché et la transition de l'état actif est visible.
          body.querySelectorAll('.fs-item').forEach(b => {
            const on = !same && b === btn;
            b.classList.toggle('active', on);
            b.setAttribute('aria-pressed', String(on));
          });
        });
      });
    }

    /* Ouverture et fermeture animées. La fermeture pose d'abord .is-closing
     * (glissement vers le bas, voile qui s'efface) puis ferme réellement le
     * <dialog> une fois l'animation jouée — même principe que les listes
     * déroulantes, masquées après leur transition. */
    const CLOSE_MS = 220;
    let closeTimer = null;
    const reduceMotion = () => !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);

    function finishClose() {
      clearTimeout(closeTimer);
      closeTimer = null;
      dlg.classList.remove('is-closing');
      if (dlg.open) dlg.close();
    }

    function openSheet() {
      if (closeTimer) finishClose();
      if (dlg.open) return;
      try { dlg.showModal(); } catch { dlg.setAttribute('open', ''); }
    }

    function closeSheet() {
      if (!dlg.open || closeTimer) return;
      if (reduceMotion()) { finishClose(); return; }
      dlg.classList.add('is-closing');
      closeTimer = setTimeout(finishClose, CLOSE_MS);
    }

    // Échap : le navigateur fermerait le <dialog> sans animation.
    dlg.addEventListener('cancel', (e) => { e.preventDefault(); closeSheet(); });
    // Toucher le voile (hors du panneau) referme la feuille.
    dlg.addEventListener('click', (e) => { if (e.target === dlg) closeSheet(); });

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
    dlg.querySelector('.filter-sheet-close').addEventListener('click', closeSheet);
    dlg.querySelector('#fs-apply').addEventListener('click', () => {
      closeSheet();
      state.currentPage = 1;
      VH.hangar.filters.saveFiltersToSession(state);
      VH.hangar.filters.applyFiltersAndRender(state);
      VH.hangar.filters.updateActiveFilters(state);
    });

    ['country-filter-btn', 'generation-filter-btn', 'type-filter-btn', 'war-filter-btn', 'mission-filter-btn'].forEach(id => {
      const btn = document.getElementById(id);
      if (!btn) return;
      btn.addEventListener('click', e => {
        if (isMobile()) {
          e.stopImmediatePropagation();
          e.preventDefault();
          currentTab = id.split('-')[0];
          renderTab();
          openSheet();
        }
      }, true);
    });
  }

  VH.hangar.mobileSheet = { init };
})();
