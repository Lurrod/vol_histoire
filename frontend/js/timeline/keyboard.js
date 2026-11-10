/* Frise — clavier : navigation chapitre par chapitre
 * (↓ / PageDown / Espace, ↑ / PageUp, Début, Fin). */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  const KEY_ACTIONS = {
    ArrowDown: 'next', PageDown: 'next', ' ': 'next',
    ArrowUp: 'prev', PageUp: 'prev',
    Home: 'home', End: 'end',
  };

  function keyAction(key) {
    return Object.prototype.hasOwnProperty.call(KEY_ACTIONS, key) ? KEY_ACTIONS[key] : null;
  }

  /* Index du dernier chapitre dont le haut est passé sous scrollY. */
  function chapterIndexAt(ids, scrollY) {
    for (let i = ids.length - 1; i >= 0; i--) {
      const el = document.getElementById('ch-' + ids[i]);
      if (el && el.offsetTop <= scrollY) return i;
    }
    return 0;
  }

  function jumpTo(ids, idx) {
    const i = Math.max(0, Math.min(ids.length - 1, idx));
    const el = document.getElementById('ch-' + ids[i]);
    if (!el) return;
    VH.timeline.util.scrollToElement(el);
  }

  function initKeyboard(decades) {
    const ids = decades.map(c => c.decade);
    const currentIdx = () => chapterIndexAt(ids, window.pageYOffset + window.innerHeight / 2);
    window.addEventListener('keydown', e => {
      if (e.target.matches('input, textarea, [contenteditable]')) return;
      const action = keyAction(e.key);
      if (!action) return;
      e.preventDefault();
      if (action === 'next') jumpTo(ids, currentIdx() + 1);
      else if (action === 'prev') jumpTo(ids, currentIdx() - 1);
      else if (action === 'home') window.scrollTo({ top: 0, behavior: VH.timeline.util.scrollBehavior() });
      else jumpTo(ids, ids.length - 1);
    });
  }

  const api = { keyAction, chapterIndexAt, jumpTo, initKeyboard };
  window.VH.timeline.keyboard = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
