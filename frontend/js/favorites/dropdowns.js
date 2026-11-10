/* Favoris — ouverture / fermeture des listes de filtres (pays, génération,
 * type). Fermeture animée : .show retirée tout de suite, .hidden posée
 * après la transition. */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const FILTER_BUTTONS = {
    'country-filter-btn': 'country-dropdown',
    'generation-filter-btn': 'generation-dropdown',
    'type-filter-btn': 'type-dropdown',
  };
  const OPEN_DELAY_MS = 10;
  const CLOSE_MS = 300;

  // Minuteurs de masquage en attente, par id de liste.
  const dropdownTimeouts = new Map();

  function closeAllDropdowns() {
    document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
      dropdown.classList.remove('show');
      // Synchroniser aria-expanded sur le bouton associé
      const btnId = dropdown.id.replace('-dropdown', '-filter-btn');
      document.getElementById(btnId)?.setAttribute('aria-expanded', 'false');
      const id = dropdown.id;
      if (dropdownTimeouts.has(id)) clearTimeout(dropdownTimeouts.get(id));
      const timeout = setTimeout(() => {
        dropdown.classList.add('hidden');
        dropdownTimeouts.delete(id);
      }, CLOSE_MS);
      dropdownTimeouts.set(id, timeout);
    });
  }

  function openDropdown(btn, dropdown) {
    // Annuler le timeout hidden programmé par closeAllDropdowns
    if (dropdownTimeouts.has(dropdown.id)) {
      clearTimeout(dropdownTimeouts.get(dropdown.id));
      dropdownTimeouts.delete(dropdown.id);
    }
    dropdown.classList.remove('hidden');
    setTimeout(() => dropdown.classList.add('show'), OPEN_DELAY_MS);
    btn?.setAttribute('aria-expanded', 'true');
  }

  function toggleDropdown(btnId, dropdownId) {
    const btn = document.getElementById(btnId);
    const dropdown = document.getElementById(dropdownId);
    const isOpen = dropdown.classList.contains('show');
    closeAllDropdowns();
    if (!isOpen) openDropdown(btn, dropdown);
  }

  function setupDropdowns() {
    Object.entries(FILTER_BUTTONS).forEach(([btnId, dropdownId]) => {
      document.getElementById(btnId)?.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleDropdown(btnId, dropdownId);
      });
    });

    document.querySelectorAll('.close-dropdown').forEach(btn => {
      btn.addEventListener('click', () => closeAllDropdowns());
    });

    document.addEventListener('click', (e) => {
      if (!e.target.closest('.filter-btn') && !e.target.closest('.filter-dropdown')) {
        closeAllDropdowns();
      }
    });
  }

  const api = { closeAllDropdowns, setupDropdowns };
  window.VH.favorites.dropdowns = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
