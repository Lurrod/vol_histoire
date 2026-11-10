/* Liste complète des appareils pour les listes prédécesseur / successeur /
 * rival des formulaires d'administration (création au hangar, édition sur la
 * fiche).
 *
 * L'API plafonne `limit` à 100 : demander `?limit=500` ne renvoyait que les
 * 100 premiers identifiants. Sur la fiche, un successeur absent de la liste
 * retombait sur « — » et l'enregistrement effaçait la filiation en silence
 * (JS-001). On lit donc `total` sur la première page et on charge les
 * suivantes en parallèle, comme home/search-suggest.js. */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  const PAGE_SIZE = 100;
  // Garde-fou : 20 pages = 2 000 appareils. Au-delà, `total` est suspect.
  const MAX_PAGES = 20;

  let listPromise = null;

  async function fetchPage(page) {
    const res = await auth.fetchWithTimeout(`/api/airplanes?limit=${PAGE_SIZE}&page=${page}`);
    if (!res.ok) throw new Error(`Chargement des appareils impossible (HTTP ${res.status})`);
    const payload = await res.json();
    if (!payload || !Array.isArray(payload.data)) {
      throw new Error('Réponse inattendue de /api/airplanes');
    }
    return payload;
  }

  /**
   * Toutes les fiches (id, name…), toutes pages confondues. Le résultat est
   * gardé pour la durée de la page ; un échec n'est pas mis en cache.
   * @returns {Promise<Array<{id: number, name: string}>>}
   */
  function fetchAll() {
    if (listPromise) return listPromise;
    listPromise = fetchPage(1)
      .then(async (first) => {
        const pages = Math.min(MAX_PAGES, Math.ceil((Number(first.total) || 0) / PAGE_SIZE));
        const rest = [];
        for (let p = 2; p <= pages; p++) rest.push(fetchPage(p));
        const more = await Promise.all(rest);
        const all = [first, ...more].flatMap((p) => p.data);
        // OFFSET : une fiche ajoutée entre deux pages peut apparaître deux fois.
        const seen = new Set();
        return all.filter((ap) => !seen.has(ap.id) && seen.add(ap.id));
      })
      .catch((err) => {
        listPromise = null;
        throw err;
      });
    return listPromise;
  }

  /** Oublie la liste (après une création : la nouvelle fiche doit y figurer). */
  function invalidate() {
    listPromise = null;
  }

  /**
   * Options HTML triées par nom, précédées de « — ».
   * @param {Array<{id: number, name: string}>} list
   * @param {number|string} [excludeId] appareil à exclure (celui qu'on édite)
   * @returns {string}
   */
  function optionsHtml(list, excludeId) {
    const exclude = excludeId == null ? null : Number(excludeId);
    const items = list
      .filter((ap) => Number(ap.id) !== exclude)
      .sort((a, b) => (a.name || '').localeCompare(b.name || ''))
      .map((ap) => `<option value="${Number(ap.id)}">${escapeHtml(ap.name || '')}</option>`);
    return ['<option value="">—</option>', ...items].join('');
  }

  /**
   * Sélectionne `value` dans `select`. Si aucune option ne porte cette valeur,
   * on l'ajoute (libellé fourni, sinon « #id ») plutôt que de laisser la liste
   * retomber sur la valeur vide, que l'envoi traduirait par NULL.
   * @param {HTMLSelectElement|null} select
   * @param {number|string|null|undefined} value
   * @param {string} [label]
   */
  function selectValue(select, value, label) {
    if (!select) return;
    const wanted = value == null ? '' : String(value);
    if (wanted && !Array.from(select.options).some((o) => o.value === wanted)) {
      const opt = document.createElement('option');
      opt.value = wanted;
      opt.textContent = label || `#${wanted}`;
      select.appendChild(opt);
    }
    select.value = wanted;
  }

  VH.shared.airplaneOptions = { PAGE_SIZE, fetchAll, invalidate, optionsHtml, selectValue };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.airplaneOptions;
  }
})();
