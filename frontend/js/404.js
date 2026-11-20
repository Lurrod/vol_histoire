/* ======================================================================
   VOL D'HISTOIRE — PAGE 404
   Lit l'adresse manquante et en tire des mots : ils préremplissent la
   recherche et nomment le vol annulé du tableau des départs (404-board.js).
   L'avion qui écrit « 404 » vit dans 404-sky.js.
   ====================================================================== */
(function () {
  // Mots vides et segments techniques qu'on ne cherche pas.
  const STOP = new Set(['de', 'du', 'des', 'la', 'le', 'les', 'et', 'en', 'au', 'aux', 'un', 'une', 'the', 'of', 'and', 'details', 'html']);
  const MAX_WORDS = 5;

  /** Adresse demandée (la page 404 est servie à l'adresse manquante). */
  function missingPath() {
    return window.location.pathname || '/';
  }

  /** Mots de l'adresse : « /details/mirage-2000-c-14 » → « mirage 2000 c ». Vide pour /404. */
  function queryFromPath(p) {
    let segs;
    try { segs = decodeURIComponent(p).split('/').filter(Boolean); } catch { segs = p.split('/').filter(Boolean); }
    let last = segs[segs.length - 1] || '';
    if (segs[0] === 'details') last = last.replace(/-\d+$/, '');
    last = last.replace(/\.[a-z0-9]+$/i, '');
    const q = last.split(/[-_\s.+]+/).filter((w) => w && !STOP.has(w.toLowerCase())).slice(0, MAX_WORDS).join(' ');
    return /^404\b/.test(q) ? '' : q;
  }

  window.VH = window.VH || {};
  window.VH.e404 = { missingPath, queryFromPath };

  document.addEventListener('DOMContentLoaded', () => {
    const q = queryFromPath(missingPath());
    const input = document.getElementById('e4-q');
    if (input && q) input.value = q;
  });

  if (typeof module !== 'undefined' && module.exports) module.exports = { missingPath, queryFromPath };
})();
