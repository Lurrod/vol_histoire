/* Paramètres — navigation latérale en onglets (motif WAI-ARIA Authoring
 * Practices : flèches dans les deux axes, Début / Fin, activation
 * automatique). Un onglet masqué (.hidden, ex. Administration) est sauté. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  function activateTab(link, { focusTab = false, scroll = true } = {}) {
    if (!link || link.classList.contains('hidden')) return;
    const targetSection = link.dataset.section;

    document.querySelectorAll('.sidebar-link').forEach(l => {
      const isActive = l === link;
      l.classList.toggle('active', isActive);
      l.setAttribute('aria-selected', isActive ? 'true' : 'false');
      l.setAttribute('tabindex', isActive ? '0' : '-1');
    });

    document.querySelectorAll('.content-section').forEach(section => {
      const isTarget = section.id === targetSection;
      section.classList.toggle('active', isTarget);
      if (isTarget) section.removeAttribute('hidden');
      else section.setAttribute('hidden', '');
    });

    if (focusTab) link.focus();
    if (scroll) {
      const behavior = VH.settings.ui.scrollBehavior();
      const anchor = document.querySelector('.settings-section');
      if (anchor && typeof anchor.scrollIntoView === 'function') {
        anchor.scrollIntoView({ behavior, block: 'start' });
      } else {
        window.scrollTo({ top: 0, behavior });
      }
    }
  }

  /** Onglet cible d'une touche de navigation, ou null si la touche n'en est pas une. */
  function targetForKey(key, visible, idx) {
    switch (key) {
      case 'ArrowDown':
      case 'ArrowRight':
        return visible[(idx + 1) % visible.length];
      case 'ArrowUp':
      case 'ArrowLeft':
        return visible[(idx - 1 + visible.length) % visible.length];
      case 'Home':
        return visible[0];
      case 'End':
        return visible[visible.length - 1];
      default:
        return null;
    }
  }

  function setup() {
    const sidebarLinks = Array.from(document.querySelectorAll('.sidebar-link'));

    sidebarLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        activateTab(link);
      });

      link.addEventListener('keydown', (e) => {
        const visible = sidebarLinks.filter(l => !l.classList.contains('hidden'));
        const idx = visible.indexOf(link);
        if (idx === -1) return;
        const target = targetForKey(e.key, visible, idx);
        if (!target) return;
        e.preventDefault();
        activateTab(target, { focusTab: true, scroll: false });
      });
    });
  }

  VH.settings.tabs = { activateTab, targetForKey, setup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.tabs;
  }
})();
