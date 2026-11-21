/* VH.footerStats — chiffres du catalogue dans le pied de page (2026-11-21).
 *
 * « 733 appareils · 34 nations · 61 conflits » : lus dans /api/stats (cache
 * serveur de 5 min) quand le pied de page approche de l'écran, jamais au
 * chargement. La ligne reste masquée (hidden) tant qu'aucun chiffre n'est
 * arrivé : sans réponse, le pied garde sa seule phrase d'accroche.
 * Les nombres tournent en odomètre (VH.rollingNumber), comme ailleurs. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const KEYS = ['airplanes', 'countries', 'wars'];

  function getJson(url) {
    const auth = root.auth;
    const req = auth && typeof auth.fetchWithTimeout === 'function'
      ? auth.fetchWithTimeout(url)
      : root.fetch(url);
    return req.then((res) => {
      if (!res.ok) throw new Error('stats ' + res.status);
      return res.json();
    });
  }

  /** Pose les chiffres reçus ; true si la ligne a pu être affichée. */
  function fill(line, data) {
    if (!data || !KEYS.every((k) => Number.isFinite(data[k]))) return false;
    line.hidden = false;
    const roll = root.VH.rollingNumber;
    KEYS.forEach((key) => {
      const el = line.querySelector('[data-stat="' + key + '"]');
      if (!el) return;
      if (roll) roll.set(el, data[key]);
      else el.textContent = String(data[key]);
    });
    return true;
  }

  /** Charge une fois ; renvoie la promesse (tests). */
  function load(line) {
    return getJson('/api/stats')
      .then((data) => fill(line, data))
      .catch(() => false); // pied sans chiffres : rien à signaler
  }

  function init(doc) {
    const d = doc || document;
    const line = d.querySelector('.footer-stats');
    if (!line) return null;
    if (typeof root.IntersectionObserver !== 'function') return load(line);
    let started = false; // un rappel déjà en file après disconnect() ne recharge pas
    const io = new root.IntersectionObserver((entries) => {
      if (started || !entries.some((e) => e.isIntersecting)) return;
      started = true;
      io.disconnect();
      load(line);
    }, { rootMargin: '0px 0px 300px 0px' });
    io.observe(line.closest('footer') || line);
    return io;
  }

  root.VH.footerStats = { init, fill, load };

  if (typeof document !== 'undefined') {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => init());
    else init();
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = root.VH.footerStats;
})();
