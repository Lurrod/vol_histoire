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

  // -------------------------------------------------------------------
  // Fonctions exposées (utilisables par les scripts de page)
  // -------------------------------------------------------------------
  function closeMenu() {
    navLinks?.classList.remove('show');
    hamburger?.classList.remove('active');
    document.body.style.overflow = '';
  }

  function closeDropdown() {
    if (!userDropdown) return;
    userDropdown.classList.remove('show');
    setTimeout(() => userDropdown.classList.add('hidden'), 300);
  }

  function updateAuthUI() {
    const payload = auth.getPayload();
    if (!payload) return;

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
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Fermer le menu mobile au clic sur un lien (sauf login icon)
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => {
      if (link.id === 'login-icon') return;
      closeMenu();
    });
  });

  // Fermer le menu mobile au resize (debounced)
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      if (window.innerWidth > 992) {
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
      userDropdown?.classList.remove('hidden');
      setTimeout(() => userDropdown?.classList.add('show'), 10);
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
  // ESC pour tout fermer
  // -------------------------------------------------------------------
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeMenu();
      closeDropdown();
    }
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
