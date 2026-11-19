/* Connexion / inscription — bascule entre les deux panneaux.
 *
 * Onglets ARIA (flèches, Début / Fin, activation automatique) et boutons
 * « Créer un compte » / « Se connecter » des pieds de panneau. Le panneau
 * sortant glisse (slideOut, login.css) avant d'être masqué ; VH.motion.exit
 * attend la durée réelle de l'animation (aucune durée recopiée ici) et
 * enchaîne aussitôt si le visiteur demande moins d'animations.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  function resetForms(ctx) {
    ctx.els.loginForm.reset();
    ctx.els.registerForm.reset();
  }

  /** Tous les panneaux : les deux onglets et les étapes par code. */
  function allSlides(ctx) {
    const { loginSlide, registerSlide, forgotSlide, codeSlide, passwordSlide } = ctx.els;
    return [loginSlide, registerSlide, forgotSlide, codeSlide, passwordSlide].filter(Boolean);
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
  function showPanel(ctx, panel, focusInput, { reset = true, after = null } = {}) {
    ctx.state.pendingSwap = null;
    // Étapes par code : les onglets s'effacent (aucun des deux n'est actif).
    ctx.els.container?.classList.toggle('is-flow', panel.classList.contains('form-flow'));
    allSlides(ctx).forEach(p => {
      p.classList.remove('is-leaving');
      if (p === panel) {
        p.classList.add('active');
        p.inert = false;
      } else {
        p.classList.remove('active');
        p.inert = true;
      }
    });

    if (reset) resetForms(ctx);

    if (focusInput) {
      const firstInput = panel.querySelector('input:not([type="hidden"])');
      firstInput?.focus({ preventScroll: true });
    }
    // Panneau affiché et atteignable : préremplissage, focus ciblé…
    if (after) after(panel);
  }

  function activateTab(ctx, tab, { focusInput = false, reset = true, after = null } = {}) {
    if (!tab) return;
    const panel = document.getElementById(tab.getAttribute('aria-controls'));
    if (!panel) return;
    selectTab(tab);
    swapTo(ctx, panel, { focusInput, reset, after });
  }

  /**
   * Bascule animée vers un panneau : sortie (slideOut) du panneau visible,
   * puis entrée du nouveau (slideIn). Les étapes par code gardent les
   * formulaires des onglets (reset: false) : l'adresse saisie reste.
   * « after » s'exécute une fois le nouveau panneau affiché (la sortie animée
   * diffère la bascule : un préremplissage fait avant serait effacé).
   */
  function swapTo(ctx, panel, { focusInput = false, reset = true, after = null } = {}) {
    // Une bascule encore en cours se termine immédiatement.
    if (ctx.state.pendingSwap) ctx.state.pendingSwap();
    const outgoing = allSlides(ctx).find(p => p !== panel && p.classList.contains('active'));
    const swap = () => showPanel(ctx, panel, focusInput, { reset, after });

    if (!outgoing) {
      swap();
      return;
    }

    // Sortie animée (slideOut) puis entrée du nouveau panneau (slideIn).
    // exit() peut rappeler aussitôt (mouvements réduits) : dans ce cas la
    // bascule est déjà faite et il ne reste rien à annuler.
    let swapped = false;
    outgoing.inert = true;
    const cancel = VH.motion.exit(outgoing, () => { swapped = true; swap(); }, { className: 'is-leaving' });
    if (!swapped) ctx.state.pendingSwap = () => { cancel(); swap(); };
  }

  /** Étape par code (mot de passe oublié, code, mot de passe). */
  function showSlide(ctx, panel, { focusInput = false, after = null } = {}) {
    if (!panel) return;
    swapTo(ctx, panel, { focusInput, reset: false, after });
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

  VH.login.tabs = { resetForms, activateTab, showSlide, onTabKeydown, setupFormSwitching };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.tabs;
  }
})();
