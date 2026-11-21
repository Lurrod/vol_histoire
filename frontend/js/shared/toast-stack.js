/* VH.toastStack — notifications empilées (2026-11-21).
 *
 * Motif popularisé par la bibliothèque « Sonner » (écrit d'après son
 * comportement, aucun code repris) : les toasts de #toast-container
 * forment un paquet. Le plus récent est devant ; les précédents, derrière,
 * légèrement plus petits et décalés vers le haut (trois visibles au plus).
 * Au survol ou au focus du paquet, il se déplie : chaque toast reprend sa
 * place, l'un au-dessus de l'autre.
 *
 * Tous les toasts du site passent par #toast-container (utils.showToast,
 * cookies.js, favoris, mise à jour du service worker) : le module observe
 * le conteneur et ne demande rien aux producteurs. Un toast en sortie
 * (.fade-out) quitte aussitôt le paquet : les autres avancent pendant
 * qu'il s'efface.
 *
 * Positions posées en CSSOM (--toast-y, --toast-s, --toast-z, hauteur du
 * conteneur) : la CSP interdit les attributs style, pas le CSSOM.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const VISIBLE = 3;       // toasts visibles repliés
  const PEEK = 14;         // décalage d'un toast caché derrière, en px
  const SHRINK = 0.05;     // réduction par rang
  const GAP = 12;          // écart entre toasts dépliés, en px

  /** Hauteur naturelle : un toast de derrière est ramené à celle du toast de
   * devant (overflow: hidden), scrollHeight donne la sienne. */
  function naturalHeight(toast) {
    return toast.scrollHeight + (toast.offsetHeight - toast.clientHeight);
  }

  function layout(container) {
    const all = Array.from(container.children).filter((el) => el.classList.contains('toast'));
    const live = all.filter((el) => !el.classList.contains('fade-out'));
    const expanded = container.classList.contains('is-expanded');
    // Le plus récent (dernier ajouté) au rang 0
    const ranked = live.slice().reverse();
    let offset = 0;
    const frontH = ranked[0] ? naturalHeight(ranked[0]) : 0;
    container.style.setProperty('--front-h', frontH + 'px');
    ranked.forEach((toast, i) => {
      const h = naturalHeight(toast);
      const y = expanded ? -offset : -i * PEEK;
      const scale = expanded ? 1 : Math.max(0, 1 - i * SHRINK);
      toast.style.setProperty('--toast-y', y + 'px');
      toast.style.setProperty('--toast-s', String(scale));
      toast.style.setProperty('--toast-z', String(ranked.length - i));
      toast.classList.toggle('is-behind', !expanded && i > 0);
      toast.classList.toggle('is-hidden-stack', !expanded && i >= VISIBLE);
      offset += h + GAP;
    });
    const front = ranked[0];
    const height = !front ? 0
      : expanded ? Math.max(0, offset - GAP)
        : frontH + Math.min(ranked.length - 1, VISIBLE - 1) * PEEK;
    container.style.setProperty('--stack-h', height + 'px');
    container.classList.toggle('is-empty', !front);
    if (!front) container.classList.remove('is-expanded');
  }

  function setExpanded(container, on) {
    if (container.classList.contains('is-expanded') === on) return;
    container.classList.toggle('is-expanded', on);
    layout(container);
  }

  function attach(container) {
    if (!container || container.dataset.stack === 'on') return null;
    container.dataset.stack = 'on';
    container.classList.add('toast-stack');
    let frame = 0;
    const schedule = () => {
      if (frame) return;
      frame = root.requestAnimationFrame(() => { frame = 0; layout(container); });
    };
    const mo = new root.MutationObserver(schedule);
    mo.observe(container, { childList: true, subtree: true, attributes: true, attributeFilter: ['class'] });
    container.addEventListener('pointerenter', () => setExpanded(container, true));
    container.addEventListener('pointerleave', () => {
      if (!container.contains(document.activeElement)) setExpanded(container, false);
    });
    container.addEventListener('focusin', () => setExpanded(container, true));
    container.addEventListener('focusout', (e) => {
      if (!container.contains(e.relatedTarget) && !container.matches(':hover')) setExpanded(container, false);
    });
    root.addEventListener('resize', schedule);
    layout(container);
    return { layout: () => layout(container), disconnect: () => mo.disconnect() };
  }

  /** Branche le conteneur de la page, ou celui créé plus tard. */
  function init(doc) {
    const d = doc || document;
    const existing = d.getElementById('toast-container');
    if (existing) return attach(existing);
    // Conteneur créé à la volée (cookies.js, sw-register.js)
    const mo = new root.MutationObserver(() => {
      const c = d.getElementById('toast-container');
      if (c) { mo.disconnect(); attach(c); }
    });
    mo.observe(d.body, { childList: true });
    return null;
  }

  root.VH.toastStack = { init, attach, layout };

  if (typeof document !== 'undefined') {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => init());
    else init();
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = root.VH.toastStack;
})();
