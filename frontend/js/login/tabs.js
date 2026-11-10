/* Connexion / inscription — bascule entre les deux panneaux.
 *
 * Onglets ARIA (flèches, Début / Fin, activation automatique) et boutons
 * « Créer un compte » / « Se connecter » des pieds de panneau. Le panneau
 * sortant glisse (slideOut, login.css) avant d'être masqué, sauf si le
 * visiteur demande moins d'animations.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  // Durée de slideOut (login.css) : le panneau sortant glisse avant d'être masqué.
  const SLIDE_OUT_MS = 250;

  function prefersReducedMotion() {
    return !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  function resetForms(ctx) {
    ctx.els.loginForm.reset();
    ctx.els.registerForm.reset();
    VH.login.strength.updatePasswordStrength(0);
  }

  /** Marque l'onglet choisi comme sélectionné, les autres non. */
  function selectTab(tab) {
    tab.parentElement.querySelectorAll('[role="tab"]').forEach(t => {
      t.setAttribute('aria-selected', 'false');
      t.setAttribute('tabindex', '-1');
      t.classList.remove('active');
    });
    tab.setAttribute('aria-selected', 'true');
    tab.setAttribute('tabindex', '0');
    tab.classList.add('active');
  }

  /* Affiche le panneau demandé (les autres sont masqués via CSS .active).
   * `inert` remplace le couple aria-hidden + tabindex : une seule propriété
   * exclut le sous-arbre du tab order ET des AT, évitant l'antipattern
   * « aria-hidden sur conteneur focusable » (WCAG 4.1.2). */
  function showPanel(ctx, panel, focusInput) {
    ctx.state.pendingSwap = null;
    [ctx.els.loginSlide, ctx.els.registerSlide].forEach(p => {
      if (!p) return;
      p.classList.remove('is-leaving');
      if (p === panel) {
        p.classList.add('active');
        p.inert = false;
      } else {
        p.classList.remove('active');
        p.inert = true;
      }
    });

    resetForms(ctx);

    if (focusInput) {
      const firstInput = panel.querySelector('input:not([type="hidden"])');
      firstInput?.focus({ preventScroll: true });
    }
  }

  function activateTab(ctx, tab, { focusInput } = { focusInput: false }) {
    if (!tab) return;
    const panel = document.getElementById(tab.getAttribute('aria-controls'));
    if (!panel) return;

    // Une bascule encore en cours se termine immédiatement.
    if (ctx.state.pendingSwap) ctx.state.pendingSwap();

    selectTab(tab);

    const { loginSlide, registerSlide } = ctx.els;
    const outgoing = [loginSlide, registerSlide].find(p => p && p !== panel && p.classList.contains('active'));
    const swap = () => showPanel(ctx, panel, focusInput);

    if (!outgoing || prefersReducedMotion()) {
      swap();
      return;
    }

    // Sortie animée (slideOut) puis entrée du nouveau panneau (slideIn).
    outgoing.inert = true;
    outgoing.classList.add('is-leaving');
    const timer = setTimeout(swap, SLIDE_OUT_MS);
    ctx.state.pendingSwap = () => { clearTimeout(timer); swap(); };
  }

  // Navigation clavier dans la tablist (ArrowLeft/ArrowRight, Home/End).
  // Activation automatique : la tab focalisée devient active immédiatement.
  function onTabKeydown(ctx, e, tabs) {
    const idx = tabs.indexOf(e.currentTarget);
    if (idx < 0) return;
    let next = -1;
    if (e.key === 'ArrowRight') next = (idx + 1) % tabs.length;
    else if (e.key === 'ArrowLeft') next = (idx - 1 + tabs.length) % tabs.length;
    else if (e.key === 'Home') next = 0;
    else if (e.key === 'End') next = tabs.length - 1;
    if (next < 0) return;
    e.preventDefault();
    tabs[next].focus();
    activateTab(ctx, tabs[next], { focusInput: false });
  }

  function setupFormSwitching(ctx) {
    const { switchToRegister, switchToLogin, tabLogin, tabRegister } = ctx.els;

    // Boutons CTA dans le footer de chaque panneau — délèguent à la tab correspondante
    switchToRegister?.addEventListener('click', (e) => {
      e.preventDefault();
      activateTab(ctx, tabRegister, { focusInput: true });
    });
    switchToLogin?.addEventListener('click', (e) => {
      e.preventDefault();
      activateTab(ctx, tabLogin, { focusInput: true });
    });

    // Clic sur les tabs de la tablist
    tabLogin?.addEventListener('click', () => activateTab(ctx, tabLogin, { focusInput: true }));
    tabRegister?.addEventListener('click', () => activateTab(ctx, tabRegister, { focusInput: true }));

    const tabs = [tabLogin, tabRegister].filter(Boolean);
    tabs.forEach(tab => tab.addEventListener('keydown', (e) => onTabKeydown(ctx, e, tabs)));
  }

  VH.login.tabs = { SLIDE_OUT_MS, prefersReducedMotion, resetForms, activateTab, onTabKeydown, setupFormSwitching };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.tabs;
  }
})();
