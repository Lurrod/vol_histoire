/* Connexion / inscription — bascule entre les panneaux.
 *
 * Onglets ARIA (flèches, Début / Fin, activation automatique) et boutons
 * « Créer un compte » / « Se connecter » des pieds de panneau.
 *
 * Bascule par morphing (VH.viewMorph.run, API View Transitions) : le cadre
 * prend la hauteur du nouveau panneau, l'icône, le titre, le bouton d'envoi
 * et le pied glissent de leur ancienne place à la nouvelle, le reste sort
 * d'un côté et entre de l'autre (sens selon l'ordre des panneaux : un
 * retour joue la transition à l'envers). CSS : bloc MORPHING DES ÉTAPES de
 * login.css.
 *
 * Sans l'API (Firefox) ou en mouvement réduit, comme avant : le panneau
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

  // Classe posée sur <html> pendant un morphing : sens de la transition.
  const MORPH_FORWARD = 'vh-login-fwd';
  const MORPH_BACK = 'vh-login-back';

  /** Le morphing est-il jouable ? Sinon : sortie animée puis bascule. */
  function canMorph() {
    return !!(root.VH.viewMorph
      && typeof document.startViewTransition === 'function'
      && !VH.motion.prefersReducedMotion()
      && !document.hidden);
  }

  /** Un morphing de la page est-il encore en cours (noms posés) ? */
  function morphInProgress() {
    const cls = document.documentElement.classList;
    return cls.contains(MORPH_FORWARD) || cls.contains(MORPH_BACK);
  }

  /**
   * Éléments nommés du panneau visible, relus avant et après la bascule.
   * Un seul panneau est affiché à la fois : chaque nom reste unique (les
   * panneaux masqués ne sont pas capturés, même s'ils gardent leur nom
   * jusqu'à la fin de la transition). Les onglets ne sont nommés que s'ils
   * sont visibles (pas pendant les étapes par code).
   * @returns {Array<[Element, string]>}
   */
  function morphNames(ctx) {
    const { container } = ctx.els;
    const slide = allSlides(ctx).find(p => p.classList.contains('active'));
    const tabs = container && !container.classList.contains('is-flow')
      ? container.querySelector('[role="tablist"]')
      : null;
    const inSlide = (selector) => (slide ? slide.querySelector(selector) : null);
    return [
      [container, 'vh-login-frame'],
      [tabs, 'vh-login-tabs'],
      [inSlide('.form-icon'), 'vh-login-icon'],
      [inSlide('.form-header h1, .form-header h2'), 'vh-login-title'],
      [inSlide('.btn-submit'), 'vh-login-submit'],
      [inSlide('.form-footer'), 'vh-login-footer'],
    ].filter(pair => pair[0]);
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
  function showPanel(ctx, panel, focusInput, { reset = true, after = null, morph = false } = {}) {
    ctx.state.pendingSwap = null;
    // Étapes par code : les onglets s'effacent (aucun des deux n'est actif).
    ctx.els.container?.classList.toggle('is-flow', panel.classList.contains('form-flow'));
    allSlides(ctx).forEach(p => {
      p.classList.remove('is-leaving');
      if (p === panel) {
        // Morphing : le panneau entre par la transition, pas par slideIn
        // (.no-enter). Un panneau déjà affiché garde ses classes : retirer
        // .no-enter rejouerait slideIn.
        if (!p.classList.contains('active')) p.classList.toggle('no-enter', morph);
        p.classList.add('active');
        p.inert = false;
      } else {
        p.classList.remove('active', 'no-enter');
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
   * Morphing vers `panel` (VH.viewMorph.run). La bascule se fait dans la
   * transition, après la capture de l'état de départ : elle reste en
   * attente (pendingSwap) jusque-là, et ne se joue qu'une fois.
   */
  function morphTo(ctx, panel, outgoing, swap) {
    let done = false;
    const update = () => {
      if (done) return;
      done = true;
      swap(true);
    };
    const slides = allSlides(ctx);
    const back = slides.indexOf(panel) < slides.indexOf(outgoing);
    outgoing.inert = true;
    ctx.state.pendingSwap = update;
    VH.viewMorph.run({
      update,
      name: () => morphNames(ctx),
      className: 'vh-login',
      rootClass: back ? MORPH_BACK : MORPH_FORWARD,
    });
  }

  /**
   * Bascule animée vers un panneau : morphing si possible, sinon sortie
   * (slideOut) du panneau visible puis entrée du nouveau (slideIn). Les
   * étapes par code gardent les formulaires des onglets (reset: false) :
   * l'adresse saisie reste. « after » s'exécute une fois le nouveau panneau
   * affiché (la bascule est différée : un préremplissage fait avant serait
   * effacé).
   */
  function swapTo(ctx, panel, { focusInput = false, reset = true, after = null } = {}) {
    // Une bascule encore en cours se termine immédiatement.
    if (ctx.state.pendingSwap) ctx.state.pendingSwap();
    const outgoing = allSlides(ctx).find(p => p !== panel && p.classList.contains('active'));
    const swap = (morph = false) => showPanel(ctx, panel, focusInput, { reset, after, morph });

    // Morphing précédent pas encore fini (clics rapprochés, flèches de la
    // tablist) : bascule immédiate, sans en lancer un second par-dessus.
    if (!outgoing || morphInProgress()) {
      swap();
      return;
    }

    if (canMorph()) {
      morphTo(ctx, panel, outgoing, swap);
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

  VH.login.tabs = { resetForms, activateTab, showSlide, onTabKeydown, setupFormSwitching, canMorph, morphNames };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.tabs;
  }
})();
