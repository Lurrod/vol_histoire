/* ======================================================================
   VOL D'HISTOIRE — NAVIGATION PARTAGÉE
   Header, hamburger, user dropdown, logout, scroll effect, ESC, resize.
   S'auto-initialise au DOMContentLoaded.
   Chargé après auth.js et i18n.js, avant le script de page.
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.querySelector('.user-dropdown')
    || document.getElementById('user-info-container');

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

  function closeMenu() {
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

  // Déclencheur focusable du menu compte (le conteneur .user-toggle est une div).
  function setUserExpanded(open) {
    if (!loginIcon) return;
    loginIcon.classList.toggle('is-open', open);
    if (open || loginIcon.hasAttribute('aria-expanded')) {
      loginIcon.setAttribute('aria-expanded', String(open));
    }
  }

  // .hidden est posé après l'animation de fermeture ; une réouverture dans
  // l'intervalle doit annuler ce masquage différé.
  // Inversement, une fermeture juste après l'ouverture annule le .show différé.
  let hideDropdownTimer = null;
  let showDropdownTimer = null;

  function openDropdown() {
    if (!userDropdown) return;
    clearTimeout(hideDropdownTimer);
    userDropdown.classList.remove('hidden');
    showDropdownTimer = setTimeout(() => userDropdown.classList.add('show'), 10);
    setUserExpanded(true);
  }

  function closeDropdown() {
    if (!userDropdown) return;
    clearTimeout(showDropdownTimer);
    userDropdown.classList.remove('show');
    setUserExpanded(false);
    clearTimeout(hideDropdownTimer);
    hideDropdownTimer = setTimeout(() => userDropdown.classList.add('hidden'), 300);
  }

  function updateAuthUI() {
    const payload = auth.getPayload();
    if (!payload) return;

    // Connecté : l'icône ouvre un menu au lieu de mener à /login.
    if (loginIcon && !loginIcon.hasAttribute('aria-expanded')) {
      loginIcon.setAttribute('aria-haspopup', 'true');
      loginIcon.setAttribute('aria-expanded', String(!!userDropdown?.classList.contains('show')));
    }

    const userNameEl = document.getElementById('user-name');
    const userRoleEl = document.querySelector('.user-role');

    if (userNameEl) {
      userNameEl.textContent = payload.name || i18n.t('nav.user_default');
    }
    if (userRoleEl) {
      const role = Number(payload.role);
      userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') :
                               role === 2 ? i18n.t('common.role_editor') :
                               i18n.t('nav.user_role');
    }
  }

  // Exposer sur window pour les scripts de page
  window.nav = { closeMenu, closeDropdown, updateAuthUI };

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
  // Hamburger / mobile menu
  // -------------------------------------------------------------------
  if (hamburger) hamburger.setAttribute('aria-expanded', 'false');
  hamburger?.addEventListener('click', () => {
    const nowOpen = !navLinks?.classList.contains('show');
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    hamburger.setAttribute('aria-expanded', String(nowOpen));
    scrim?.classList.toggle('show', nowOpen);
    setScrollLock(!!navLinks?.classList.contains('show'));
    // Un seul élément ouvert à la fois : menu, langue ou compte.
    if (nowOpen) { closeDropdown(); closeLang(); }
  });

  scrim?.addEventListener('click', closeMenu);
  // Ouvrir la liste des langues referme le panneau de navigation et le menu
  // compte (l'ouverture elle-même est gérée par i18n.js).
  document.getElementById('lang-toggle')?.addEventListener('click', () => {
    closeMenu();
    closeDropdown();
  });

  // Fermer le menu mobile au clic sur un lien
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
      // Même seuil que le CSS (shared-responsive.css) : au-delà, plus de burger.
      if (window.matchMedia('(min-width: 64em)').matches) {
        closeMenu();
        closeDropdown();
      }
    }, 250);
  });

  // -------------------------------------------------------------------
  // User dropdown toggle
  // -------------------------------------------------------------------
  const toggleElement = userToggle || loginIcon;

  toggleElement?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();

    // Rediriger vers /login si non connecté
    if (!auth.getToken()) {
      window.location.href = '/login';
      return;
    }

    if (userDropdown?.classList.contains('show')) {
      closeDropdown();
    } else {
      // stopPropagation empêche i18n.js de voir ce clic : on referme
      // nous-mêmes la liste des langues.
      closeMenu();
      closeLang();
      openDropdown();
    }
  });

  // Fermer le dropdown au clic extérieur
  document.addEventListener('click', (e) => {
    if (!toggleElement?.contains(e.target) && !userDropdown?.contains(e.target)) {
      closeDropdown();
    }
  });

  // -------------------------------------------------------------------
  // Settings navigation
  // -------------------------------------------------------------------
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = '/settings';
  });

  // -------------------------------------------------------------------
  // Logout (version simple — settings.js a sa propre modale)
  // -------------------------------------------------------------------
  const logoutButtons = document.querySelectorAll('#logout-icon, #logout-btn');
  logoutButtons.forEach(btn => {
    btn?.addEventListener('click', async (e) => {
      e.preventDefault();
      await auth.logout();
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => { window.location.href = '/'; }, 1000);
    });
  });

  // -------------------------------------------------------------------
  // Navigation clavier dans les dropdowns (↑↓ Enter Escape)
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

  // Fleches dans le dropdown langue
  setupDropdownKeyboard(document.getElementById('lang-dropdown'), '.lang-option');
  // Fleches dans le dropdown utilisateur
  setupDropdownKeyboard(userDropdown, '[role="menuitem"]');

  // -------------------------------------------------------------------
  // ESC pour tout fermer
  // -------------------------------------------------------------------
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    // Le focus revient au déclencheur du menu qu'on referme.
    const active = document.activeElement;
    const langSwitch = document.querySelector('.lang-switch');
    if (langSwitch?.classList.contains('open') && langSwitch.contains(active)) {
      document.getElementById('lang-toggle')?.focus();
    } else if (userDropdown?.classList.contains('show') && userDropdown.contains(active)) {
      loginIcon?.focus();
    }
    closeMenu();
    closeDropdown();
    closeLang();
  });

  // -------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------
  updateAuthUI();

  // Re-appeler updateAuthUI quand auth.init() termine (après refresh token)
  // Les scripts de page appellent auth.init() dans leur propre DOMContentLoaded,
  // qui s'exécute après celui de nav.js. On écoute l'événement storage et
  // on re-vérifie périodiquement au cas où.
  const authReady = setInterval(() => {
    if (typeof auth !== 'undefined' && auth.getPayload()) {
      updateAuthUI();
      clearInterval(authReady);
    }
  }, 100);
  // Arrêter après 5s max
  setTimeout(() => clearInterval(authReady), 5000);
});
