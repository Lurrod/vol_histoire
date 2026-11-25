/* VH.shared.adminLoader — chargement à la demande du code d'administration
 * (JS-002). Le formulaire d'appareil et les modales de création, d'édition
 * et de suppression ne servent qu'aux rôles admin (1) et éditeur (2) : ils
 * forment les bundles admin-hangar.min.js et admin-details.min.js
 * (scripts/build-js.js), insérés seulement pour ces rôles. Un <script> créé
 * par un script approuvé est admis par la CSP ('strict-dynamic'). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.shared = root.VH.shared || {};

  const pending = {};

  /** @param {{ role?: number|string }|null} payload @returns {boolean} */
  function isEditor(payload) {
    const role = payload ? Number(payload.role) : NaN;
    return role === 1 || role === 2;
  }

  /**
   * Charge js/dist/admin-<name>.min.js une seule fois.
   * @param {'hangar'|'details'} name
   * @returns {Promise<void>}
   */
  function load(name) {
    if (pending[name]) return pending[name];
    pending[name] = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      const version = root.APP_VERSION ? '?v=' + encodeURIComponent(root.APP_VERSION) : '';
      script.src = '/js/dist/admin-' + name + '.min.js' + version;
      script.onload = () => resolve();
      script.onerror = () => {
        delete pending[name];
        reject(new Error('Module d\'administration indisponible : ' + name));
      };
      document.head.appendChild(script);
    });
    return pending[name];
  }

  root.VH.shared.adminLoader = { load, isEditor };
  if (typeof module !== 'undefined' && module.exports) module.exports = root.VH.shared.adminLoader;
})();
