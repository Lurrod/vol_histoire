/* ======================================================================
   HANGAR — LA CARTE COMME VUE DU FILTRE PAYS
   Le bouton « Carte » déplie un planisphère à la largeur de la barre d'outils.
   Un clic sur un pays pose `state.filters.country` sur place : la carte se
   combine donc avec la génération, le type et la recherche, et les compteurs
   de facettes se recalculent comme pour n'importe quel filtre.

   Différence avec l'accueil, où le même module est monté en mode navigation :
   ici on ne quitte pas la page. Et la liste déroulante du filtre pays reste à
   côté — c'est elle qui sert de contrôle équivalent pour les nations trop
   petites pour être cliquées (Taïwan, Israël, Suisse).
   ====================================================================== */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    const btn = document.getElementById('map-filter-btn');
    const panel = document.getElementById('nations-map-panel');
    if (!btn || !panel || !VH.nationsMap) return;

    function isOpen() { return !panel.classList.contains('hidden'); }

    /* Reflète le filtre courant sur la carte : le pays sélectionné garde une
     * teinte pleine, quel que soit le chemin par lequel il a été choisi. */
    function syncSelection() {
      panel.querySelectorAll('.wm-nation-active').forEach(path => {
        path.classList.toggle('is-selected', path.dataset.nameFr === state.filters.country);
      });
    }

    function select(nation) {
      // Recliquer le pays déjà filtré le retire — même règle que la liste.
      state.filters.country = state.filters.country === nation.nameFr ? null : nation.nameFr;
      state.currentPage = 1;
      VH.hangar.filters.saveFiltersToSession(state);
      VH.hangar.filters.updateActiveFilters(state);
      VH.hangar.data.loadAircraft(state);
      syncSelection();
      close();
      btn.focus();
    }

    function open() {
      VH.hangar.filters.closeAllDropdowns();
      panel.classList.remove('hidden');
      btn.setAttribute('aria-expanded', 'true');
      btn.classList.add('active');
      // Premier dépliage : c'est seulement là qu'on télécharge les 76 Ko.
      VH.nationsMap.mount(panel, { onSelect: select }).then(ok => {
        if (ok) syncSelection();
      });
    }

    function close() {
      panel.classList.add('hidden');
      btn.setAttribute('aria-expanded', 'false');
      btn.classList.remove('active');
    }

    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      if (isOpen()) close(); else open();
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && isOpen()) { close(); btn.focus(); }
    });

    // `#active-filters` est re-rendu à chaque changement de filtre, d'où qu'il
    // vienne : c'est le signal le plus sûr pour rafraîchir la sélection.
    const active = document.getElementById('active-filters');
    if (active && typeof MutationObserver !== 'undefined') {
      new MutationObserver(syncSelection).observe(active, { childList: true });
    }
  }

  VH.hangar.nationsMapFilter = { init };
})();
