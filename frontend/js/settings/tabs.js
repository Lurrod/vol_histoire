/* Paramètres — navigation latérale en onglets (motif WAI-ARIA Authoring
 * Practices : flèches dans les deux axes, Début / Fin, activation
 * automatique). Un onglet masqué (.hidden, ex. Administration) est sauté.
 *
 * Mouvement (2026-11-20) :
 *   - une pastille unique (.sidebar-indicator, décorative) glisse de
 *     l'onglet quitté à l'onglet choisi ; sa place est posée en CSSOM
 *     (--tab-hl-x/y/w/h/o), mesurée en offsetLeft/offsetTop (insensibles
 *     aux transformations), et recalée sans animation quand la mise en page
 *     change (largeur, langue, onglet Administration révélé) ;
 *   - le contenu change par VH.viewMorph.run : le cadre de la carte suit la
 *     hauteur de la nouvelle section, le titre glisse de l'un à l'autre, le
 *     reste sort d'un côté et entre de l'autre selon le sens (classes
 *     vh-set + vh-set-next / vh-set-prev sur <html>, CSS dans settings.css).
 * Sans View Transitions (Firefox) ou en mouvement réduit : la section
 * change d'un coup, avec son entrée CSS habituelle.
 *
 * Onglets (2026-11-20) : Ma collection, Compte, Préférences,
 * Confidentialité, Administration. Les anciennes ancres restent valables
 * (ALIASES) : /.well-known/change-password renvoie vers /settings#security,
 * qui ouvre « Compte » et amène au bloc du mot de passe.
 * Sous 64em, les onglets forment une rangée horizontale qui défile : la
 * colonne (.settings-sidebar) est alors le conteneur de défilement, et
 * l'onglet actif y est ramené en vue. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const INDICATOR = 'sidebar-indicator';
  // Classes posées sur <html> pendant le morphing : commune + sens.
  const MORPH = 'vh-set';
  const DIR_NEXT = 'vh-set-next';
  const DIR_PREV = 'vh-set-prev';
  // Rangée horizontale (même seuil que settings.css).
  const ROW_QUERY = '(max-width: 64em)';

  /** Anciennes ancres → onglet actuel, et bloc à atteindre dans l'onglet. */
  const ALIASES = {
    dashboard: { section: 'collection' },
    profile: { section: 'account' },
    security: { section: 'account', block: 'password-block' },
    danger: { section: 'privacy', block: 'delete-block' },
  };

  /** Onglet et bloc visés par une ancre (sans le #). */
  function resolveHash(id) {
    const alias = Object.prototype.hasOwnProperty.call(ALIASES, id) ? ALIASES[id] : null;
    return alias ? { section: alias.section, block: alias.block || null } : { section: id, block: null };
  }

  /* ---------- Pastille de l'onglet actif ---------- */

  /** Décalage de `el` dans `container` en suivant la chaîne offsetParent ;
   * null si `container` n'en fait pas partie (élément non rendu). */
  function offsetWithin(el, container) {
    let x = 0;
    let y = 0;
    let node = el;
    while (node && node !== container) {
      x += node.offsetLeft;
      y += node.offsetTop;
      node = node.offsetParent;
    }
    return node === container ? { x, y } : null;
  }

  /** Mesure de la pastille pour `link`, ou null si l'onglet n'est pas rendu. */
  function measure(link, container) {
    if (!link || link.classList.contains('hidden')) return null;
    const pos = offsetWithin(link, container);
    const w = link.offsetWidth;
    const h = link.offsetHeight;
    if (!pos || !w || !h) return null;
    return { x: pos.x + 'px', y: pos.y + 'px', w: w + 'px', h: h + 'px' };
  }

  const VARS = { x: '--tab-hl-x', y: '--tab-hl-y', w: '--tab-hl-w', h: '--tab-hl-h' };

  /**
   * Place la pastille sous `link`. Sans changement de mesure : rien (les
   * observateurs peuvent rappeler sans couper un glissement en cours).
   * `instant` : recalage sans animation (premier placement, mise en page).
   * Onglet non mesurable : pastille masquée, l'onglet garde son propre fond.
   */
  function placeIndicator(link, { instant = false } = {}) {
    const ind = document.querySelector('.' + INDICATOR);
    if (!ind) return;
    const container = ind.parentElement;
    const m = measure(link, container);
    if (!m) {
      ind.style.setProperty('--tab-hl-o', '0');
      container.classList.remove('has-indicator');
      return;
    }
    const same = Object.keys(VARS).every(k => ind.style.getPropertyValue(VARS[k]) === m[k])
      && ind.style.getPropertyValue('--tab-hl-o') === '1';
    if (same) return;
    if (instant) ind.classList.remove('is-ready');
    Object.keys(VARS).forEach(k => ind.style.setProperty(VARS[k], m[k]));
    ind.style.setProperty('--tab-hl-o', '1');
    container.classList.add('has-indicator');
    if (instant) {
      // Valeurs appliquées avant de rendre les transitions : sinon la
      // pastille glisserait depuis le coin ou depuis l'ancienne mise en page.
      void ind.offsetWidth;
      ind.classList.add('is-ready');
    }
  }

  function activeLink() {
    return document.querySelector('.sidebar-link.active');
  }

  /** Crée la pastille dans la colonne des onglets et la tient à jour. */
  function setupIndicator(nav) {
    const sidebar = nav && nav.closest('.settings-sidebar');
    if (!sidebar) return;
    let ind = sidebar.querySelector('.' + INDICATOR);
    if (!ind) {
      ind = document.createElement('span');
      ind.className = INDICATOR;
      ind.setAttribute('aria-hidden', 'true');
      sidebar.insertBefore(ind, sidebar.firstChild);
    }
    const replace = () => placeIndicator(activeLink(), { instant: true });
    replace();
    // Largeur de la colonne, retour à la ligne d'un libellé (langue, police
    // chargée) : la taille des onglets change.
    if (typeof ResizeObserver === 'function') {
      const ro = new ResizeObserver(replace);
      ro.observe(nav);
      nav.querySelectorAll('.sidebar-link').forEach(l => ro.observe(l));
    }
    // Onglet Administration révélé : les suivants se décalent sans changer
    // de taille. Les bascules .active d'activateTab repassent ici sans effet
    // (même mesure).
    if (typeof MutationObserver === 'function') {
      new MutationObserver(replace).observe(nav, { subtree: true, attributes: true, attributeFilter: ['class'] });
    }
  }

  /* ---------- Morphing du contenu ---------- */

  /** Noms de transition d'une section : cadre, titre, puis chaque bloc de la
   * carte sous un nom propre à la section (il sort ou il entre). */
  function sectionNames(section) {
    const card = section && section.querySelector('.section-card');
    if (!card) return [];
    const id = String(section.id).replace(/[^\w-]/g, '');
    const pairs = [[card, 'vh-set-frame']];
    const title = card.querySelector('.section-header h2');
    if (title) pairs.push([title, 'vh-set-title']);
    Array.from(card.children).forEach((child, i) => pairs.push([child, `vh-set-${id}-${i}`]));
    return pairs;
  }

  /** Appelée par VH.viewMorph.run avant puis après la mise à jour. La colonne
   * des onglets est nommée pour rester vivante (sa pastille glisse). */
  function morphNames() {
    const sidebar = document.querySelector('.settings-sidebar');
    const pairs = sectionNames(document.querySelector('.content-section.active'));
    return sidebar ? [[sidebar, 'vh-set-nav'], ...pairs] : pairs;
  }

  /** Sens du changement : 1 vers un onglet placé après, -1 avant. */
  function direction(from, to) {
    const links = Array.from(document.querySelectorAll('.sidebar-link'));
    return links.indexOf(to) < links.indexOf(from) ? -1 : 1;
  }

  function morphing() {
    return document.documentElement.classList.contains(MORPH);
  }

  function showSection(targetSection) {
    // Section entrée par le morphing : son entrée CSS (vh-enter) ferait
    // double emploi ; la classe reste jusqu'à ce qu'elle soit masquée
    // (la retirer à l'écran relancerait l'animation).
    // Section déjà affichée (onglet actif recliqué) : marque inchangée.
    const morphed = morphing();
    document.querySelectorAll('.content-section').forEach(section => {
      const isTarget = section.id === targetSection;
      if (!isTarget) section.classList.remove('is-morphed');
      else if (section.hidden) section.classList.toggle('is-morphed', morphed);
      section.classList.toggle('active', isTarget);
      if (isTarget) section.removeAttribute('hidden');
      else section.setAttribute('hidden', '');
    });
  }

  /* ---------- Onglets ---------- */

  function activateTab(link, { focusTab = false, scroll = true, morph = true } = {}) {
    if (!link || link.classList.contains('hidden')) return;
    const targetSection = link.dataset.section;
    const previous = activeLink();

    document.querySelectorAll('.sidebar-link').forEach(l => {
      const isActive = l === link;
      l.classList.toggle('active', isActive);
      l.setAttribute('aria-selected', isActive ? 'true' : 'false');
      l.setAttribute('tabindex', isActive ? '0' : '-1');
    });
    placeIndicator(link);

    const update = () => showSection(targetSection);
    if (morph && previous && previous !== link && VH.viewMorph) {
      VH.viewMorph.run({
        update,
        name: morphNames,
        rootClass: `${MORPH} ${direction(previous, link) < 0 ? DIR_PREV : DIR_NEXT}`,
      });
    } else {
      update();
    }

    if (focusTab) link.focus();
    revealInRow(link);
    if (scroll) scrollToContent();
  }

  /** Rangée horizontale (téléphone, tablette) : l'onglet actif est ramené
   * au centre de la rangée, sans faire défiler la page. */
  function revealInRow(link) {
    const row = link.closest('.settings-sidebar');
    if (!row || row.scrollWidth <= row.clientWidth) return;
    const left = link.offsetLeft - (row.clientWidth - link.offsetWidth) / 2;
    const target = Math.max(0, Math.min(left, row.scrollWidth - row.clientWidth));
    if (typeof row.scrollTo === 'function') row.scrollTo({ left: target, behavior: VH.settings.ui.scrollBehavior() });
    else row.scrollLeft = target;
  }

  /** Haut du contenu remonté en vue s'il est passé sous l'en-tête (page
   * défilée dans une longue section) ; sinon la page ne bouge pas. */
  function scrollToContent() {
    const behavior = VH.settings.ui.scrollBehavior();
    const content = document.querySelector('.settings-content');
    if (!content || typeof content.scrollIntoView !== 'function') {
      window.scrollTo({ top: 0, behavior });
      return;
    }
    if (content.getBoundingClientRect().top < 0) content.scrollIntoView({ behavior, block: 'start' });
  }

  /** Amène un bloc d'onglet en vue et lui donne le focus (ancre d'alias). */
  function focusBlock(id) {
    const block = id ? document.getElementById(id) : null;
    if (!block) return;
    if (typeof block.scrollIntoView === 'function') {
      block.scrollIntoView({ behavior: VH.settings.ui.scrollBehavior(), block: 'start' });
    }
    if (typeof block.focus === 'function') block.focus({ preventScroll: true });
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

  /** Ouvre l'onglet nommé dans l'URL (/settings#account) : lien direct vers
   * une section. Les anciennes ancres passent par ALIASES (#security, cible
   * de /.well-known/change-password, ouvre « Compte » sur le mot de passe).
   * Ancre inconnue ou onglet masqué : onglet par défaut. Au chargement : pas
   * de morphing, la page arrive directement sur l'onglet.
   * @returns {boolean} un onglet a été ouvert */
  function openFromHash(links) {
    const all = links || Array.from(document.querySelectorAll('.sidebar-link'));
    let id = '';
    try { id = decodeURIComponent((window.location.hash || '').slice(1)); } catch { id = ''; }
    if (!id) return false;
    const target = resolveHash(id);
    const link = all.find(l => l.dataset.section === target.section && !l.classList.contains('hidden'));
    if (!link) return false;
    activateTab(link, { scroll: false, morph: false });
    focusBlock(target.block);
    return true;
  }

  /** aria-orientation suit la mise en page : colonne ou rangée. */
  function watchOrientation(nav) {
    if (!nav || typeof window.matchMedia !== 'function') return;
    const mq = window.matchMedia(ROW_QUERY);
    if (!mq) return;
    const apply = () => nav.setAttribute('aria-orientation', mq.matches ? 'horizontal' : 'vertical');
    apply();
    if (typeof mq.addEventListener === 'function') mq.addEventListener('change', apply);
  }

  function setup() {
    const sidebarLinks = Array.from(document.querySelectorAll('.sidebar-link'));
    const nav = document.querySelector('.sidebar-nav');
    watchOrientation(nav);
    openFromHash(sidebarLinks);
    setupIndicator(nav);

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

  VH.settings.tabs = {
    ALIASES, resolveHash, activateTab, targetForKey, setup, openFromHash,
    placeIndicator, morphNames, direction, revealInRow, focusBlock,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.tabs;
  }
})();
