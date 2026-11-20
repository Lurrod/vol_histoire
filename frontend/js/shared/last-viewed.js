/* VH.lastViewed — dernière fiche consultée (2026-11-20).
 *
 * La fiche (details/data.js) note l'appareil affiché ; les réglages
 * (« Ma collection ») le proposent d'un clic. Stockage local seulement
 * (clé vh-last-viewed, fonctionnelle, listée dans la politique de
 * confidentialité) : rien ne part au serveur. Toute lecture est validée —
 * le contenu du stockage n'est pas une donnée de confiance. */
(function () {
  window.VH = window.VH || {};

  var KEY = 'vh-last-viewed';
  var NAME_MAX = 200;
  // Chemin local d'image (/assets/…) ou URL https : rien d'autre n'est rendu.
  var IMAGE_RE = /^(\/(?!\/)|https:\/\/)[^\s"'<>]*$/;

  function validId(id) {
    var n = Number(id);
    return Number.isInteger(n) && n > 0 && n <= 2147483647 ? n : null;
  }

  /** Entrée nettoyée, ou null si inexploitable. */
  function clean(entry) {
    if (!entry || typeof entry !== 'object') return null;
    var id = validId(entry.id);
    var name = typeof entry.name === 'string' ? entry.name.trim().slice(0, NAME_MAX) : '';
    if (!id || !name) return null;
    var image = typeof entry.image_url === 'string' && IMAGE_RE.test(entry.image_url) ? entry.image_url : null;
    return { id: id, name: name, image_url: image };
  }

  /** @param {{ id: number|string, name: string, image_url?: string|null }} airplane */
  function save(airplane) {
    var entry = clean(airplane);
    if (!entry) return false;
    try {
      window.localStorage.setItem(KEY, JSON.stringify(entry));
      return true;
    } catch {
      return false; // stockage refusé (navigation privée, quota) : sans conséquence
    }
  }

  /** @returns {{ id: number, name: string, image_url: string|null }|null} */
  function read() {
    try {
      return clean(JSON.parse(window.localStorage.getItem(KEY)));
    } catch {
      return null;
    }
  }

  window.VH.lastViewed = { KEY: KEY, save: save, read: read };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.lastViewed;
  }
})();
