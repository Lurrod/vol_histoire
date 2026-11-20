/* Paramètres — petits utilitaires partagés par les modules VH.settings.*. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const API_BASE = '/api';

  /** Libellé traduit, ou repli français tant que la clé n'existe pas. */
  function tr(key, fallback) {
    const value = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key) : null;
    return value && value !== key ? value : fallback;
  }

  /* Attente puis succès sur place (VH.busyButton) : le bouton garde sa
   * largeur, le libellé cède la place à l'anneau, puis — si opts.done — à
   * une coche tracée avec opts.label avant de revenir. */
  function setButtonLoading(button, loading, opts) {
    if (!button) return;
    if (loading) VH.busyButton.start(button);
    else if (opts && opts.done) VH.busyButton.succeed(button, { label: opts.label });
    else VH.busyButton.stop(button);
  }

  /** Défilement doux, sauf si l'utilisateur demande moins d'animations
   * (système ou réglage du site, VH.motion). */
  function scrollBehavior() {
    const motion = window.VH && window.VH.motion;
    const reduce = motion && typeof motion.prefersReducedMotion === 'function'
      ? motion.prefersReducedMotion()
      : Boolean(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
    return reduce ? 'auto' : 'smooth';
  }

  /** Clé au singulier (_one) ou au pluriel (_many) selon `count`. */
  function plural(base, count) {
    return `${base}_${Number(count) === 1 ? 'one' : 'many'}`;
  }

  /** Traduction avec paramètres et repli ({nom} remplacés dans les deux cas). */
  function trf(key, fallback, params) {
    const raw = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key, params) : null;
    if (raw && raw !== key) return raw;
    return Object.keys(params || {}).reduce((out, k) => out.split(`{${k}}`).join(String(params[k])), fallback);
  }

  VH.settings.ui = { API_BASE, tr, trf, plural, setButtonLoading, scrollBehavior };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.ui;
  }
})();
