/* ======================================================================
   VOL D'HISTOIRE — NAVIGATION PARTAGÉE
   Header, bouton Menu (menu flottant sous 64em, menu « underlay » au-delà),
   logout, scroll effect, ESC, resize.
   Le compte (Connexion, Paramètres, Déconnexion) vit dans le groupe
   « Votre espace » du menu, à toutes les largeurs.
   S'auto-initialise au DOMContentLoaded.
   Chargé après auth.js et i18n.js, avant le script de page.
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const header = document.querySelector('body > header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');

  // Bureau (≥ 64em) : le bouton Menu ouvre le menu « underlay »
  // (js/shared/underlay-nav.js) ; en dessous, le menu flottant ci-après.
  const underlay = window.VH && window.VH.underlayNav;
  const navPanel = document.querySelector('.nav-panel');
  underlay?.init({
    panel: navPanel,
    trigger: hamburger,
    closeBtn: navPanel?.querySelector('.nav-close'),
  });

  // Voile sous le panneau mobile (masqué par CSS au-delà du palier burger).
  const scrim = hamburger ? document.createElement('div') : null;
  if (scrim) {
    scrim.className = 'nav-scrim';
    scrim.setAttribute('aria-hidden', 'true');
    document.body.appendChild(scrim);
  }

  // -------------------------------------------------------------------
  // Fonctions exposées (utilisables par les scripts de page)
  // -------------------------------------------------------------------
  // Le blocage du défilement passe par une classe : la CSP interdit
  // d'écrire dans element.style (style-src-attr 'none').
  function setScrollLock(locked) {
    document.body.classList.toggle('nav-open', locked);
  }

  // .menu-open sur l'en-tête pilote le menu flottant (shared-responsive.css) :
  // la barre s'élargit, le panneau se déroule, les liens montent en cascade.
  function setMenuOpen(open) {
    header?.classList.toggle('menu-open', open);
  }

  function closeMenu() {
    underlay?.close();
    setMenuOpen(false);
    navLinks?.classList.remove('show');
    hamburger?.classList.remove('active');
    hamburger?.setAttribute('aria-expanded', 'false');
    scrim?.classList.remove('show');
    setScrollLock(false);
  }

  function closeLang() {
    const langSwitch = document.querySelector('.lang-switch');
    if (!langSwitch?.classList.contains('open')) return;
    langSwitch.classList.remove('open');
    const toggle = document.getElementById('lang-toggle');
    toggle?.classList.remove('open');
    toggle?.setAttribute('aria-expanded', 'false');
  }

  // « Votre espace » propose Connexion sans session, Paramètres et
  // Déconnexion avec (.is-auth sur l'en-tête).
  function updateAuthUI() {
    header?.classList.toggle('is-auth', !!auth.getPayload());
  }

  // Exposer sur window pour les scripts de page
  window.nav = { closeMenu, updateAuthUI };

  // -------------------------------------------------------------------
  // Header scroll effect
  // -------------------------------------------------------------------
  window.addEventListener('scroll', () => {
    if (window.pageYOffset > 100) {
      header?.classList.add('scrolled');
    } else {
      header?.classList.remove('scrolled');
    }
  }, { passive: true });

  // -------------------------------------------------------------------
  // Bouton Menu
  // -------------------------------------------------------------------
  if (hamburger) hamburger.setAttribute('aria-expanded', 'false');
  hamburger?.addEventListener('click', () => {
    if (underlay?.enabled()) {
      closeLang();
      underlay.toggle();
      return;
    }
    const nowOpen = !navLinks?.classList.contains('show');
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    hamburger.setAttribute('aria-expanded', String(nowOpen));
    scrim?.classList.toggle('show', nowOpen);
    setMenuOpen(nowOpen);
    setScrollLock(!!navLinks?.classList.contains('show'));
    // Un seul élément ouvert à la fois : menu ou langue.
    if (nowOpen) closeLang();
  });

  scrim?.addEventListener('click', closeMenu);
  // Ouvrir la liste des langues referme le panneau de navigation
  // (l'ouverture elle-même est gérée par i18n.js).
  document.getElementById('lang-toggle')?.addEventListener('click', closeMenu);

  // Fermer le menu au clic sur un lien
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => {
      closeMenu();
    });
  });

  // Fermer le menu mobile au resize (debounced)
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      // Même seuil que le CSS (shared-responsive.css) : au-delà, plus de menu flottant.
      if (window.matchMedia('(min-width: 64em)').matches) closeMenu();
    }, 250);
  });

  // -------------------------------------------------------------------
  // Logout (version simple — settings.js a sa propre modale)
  // -------------------------------------------------------------------
  const logoutButtons = document.querySelectorAll('#logout-btn, .nav-logout');
  logoutButtons.forEach(btn => {
    btn?.addEventListener('click', async (e) => {
      e.preventDefault();
      await auth.logout();
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => { window.location.href = '/'; }, 1000);
    });
  });

  // -------------------------------------------------------------------
  // Flèches dans la liste des langues (↑↓ Home End)
  // -------------------------------------------------------------------
  function setupDropdownKeyboard(container, itemSelector) {
    if (!container) return;
    container.addEventListener('keydown', (e) => {
      const items = Array.from(container.querySelectorAll(itemSelector))
        .filter(el => el.offsetParent !== null);
      if (items.length === 0) return;

      const idx = items.indexOf(document.activeElement);

      if (e.key === 'ArrowDown') {
        e.preventDefault();
        items[(idx + 1) % items.length].focus();
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        items[(idx - 1 + items.length) % items.length].focus();
      } else if (e.key === 'Home') {
        e.preventDefault();
        items[0].focus();
      } else if (e.key === 'End') {
        e.preventDefault();
        items[items.length - 1].focus();
      }
    });
  }

  setupDropdownKeyboard(document.getElementById('lang-dropdown'), '.lang-option');

  // -------------------------------------------------------------------
  // Lien d'évitement (A11Y-004) : il vit dans l'en-tête partagé. Suivre
  // l'ancre ne suffit pas : sous <base href="/"> (fiche, conflits),
  // « #main-content » mènerait à l'accueil, et un simple défilement
  // laisserait le focus dans l'en-tête. On défile et on pose le focus sur
  // le contenu principal.
  // -------------------------------------------------------------------
  document.querySelector('.skip-link')?.addEventListener('click', (e) => {
    const target = document.getElementById('main-content');
    if (!target) return;
    e.preventDefault();
    if (!target.hasAttribute('tabindex')) target.setAttribute('tabindex', '-1');
    target.focus({ preventScroll: true });
    target.scrollIntoView({ block: 'start' });
  });

  // -------------------------------------------------------------------
  // ESC pour tout fermer
  // -------------------------------------------------------------------
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    // Le focus revient au déclencheur du menu qu'on referme.
    const langSwitch = document.querySelector('.lang-switch');
    if (langSwitch?.classList.contains('open') && langSwitch.contains(document.activeElement)) {
      document.getElementById('lang-toggle')?.focus();
    }
    // Menu flottant (mobile) : un focus resté sur un lien du panneau qu'on
    // masque serait perdu ; il revient au bouton Menu (A11Y-009). Le menu
    // underlay (bureau) gère son propre retour (underlay-nav.js).
    const focusInMenu = navLinks?.classList.contains('show') && navLinks.contains(document.activeElement);
    closeMenu();
    if (focusInMenu) hamburger?.focus();
    closeLang();
  });

  // -------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------
  updateAuthUI();

  // Re-appeler updateAuthUI quand auth.init() termine (après refresh token) :
  // les scripts de page l'appellent dans leur propre DOMContentLoaded, après
  // celui-ci. auth émet « vh:auth-ready » une fois l'initialisation finie
  // (JS-008, à la place d'un sondage toutes les 100 ms pendant 5 s).
  if (typeof auth !== 'undefined' && typeof auth.isReady === 'function' && auth.isReady()) {
    updateAuthUI();
  } else {
    document.addEventListener('vh:auth-ready', () => updateAuthUI(), { once: true });
  }
});
