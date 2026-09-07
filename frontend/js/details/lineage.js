/* Filiation — chaîne complète prédécesseurs → appareil courant → successeurs.
 *
 * La section « Appareils liés » n'affiche qu'un maillon de chaque côté, parce
 * que c'est tout ce que portent predecessor_id / successor_id. L'API
 * /api/airplanes/:id/lineage remonte la chaîne entière ; on la rend ici en
 * bande horizontale scrollable.
 *
 * Choix de rendu : DOM + CSS plutôt que SVG. Les maillons sont de vrais <a>
 * (navigables au clavier, lisibles par un lecteur d'écran) et les libellés se
 * réajustent tout seuls quand on passe en anglais — deux choses qu'un SVG à
 * coordonnées fixes rendrait pénibles.
 */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  /* Une chaîne d'un seul maillon (l'appareil lui-même) n'apprend rien :
   * la section reste masquée. */
  const MIN_CHAIN_LENGTH = 2;

  function nodeHtml(item, currentId) {
    const isCurrent = Number(item.id) === Number(currentId);
    const year = item.year ? String(item.year) : '';
    const name = escapeHtml(item.name || '');
    const inner =
      (year ? `<span class="lineage-year">${escapeHtml(year)}</span>` : '<span class="lineage-year">—</span>') +
      `<span class="lineage-name">${name}</span>`;

    if (isCurrent) {
      return `<li class="lineage-node is-current">
          <span class="lineage-link" aria-current="true">${inner}</span>
        </li>`;
    }

    const slug = VH.details.data.slugify(item.name || '');
    const href = `/details/${slug}-${item.id}`;
    return `<li class="lineage-node">
        <a class="lineage-link" href="${escapeHtml(href)}">${inner}</a>
      </li>`;
  }

  function render(chain, currentId) {
    const section = document.getElementById('lineage-section');
    const list = document.getElementById('lineage-chain');
    if (!section || !list) return;

    if (!Array.isArray(chain) || chain.length < MIN_CHAIN_LENGTH) {
      section.classList.add('hidden');
      return;
    }

    list.innerHTML = chain.map(item => nodeHtml(item, currentId)).join('');
    section.classList.remove('hidden');

    // Centre l'appareil courant dans la bande si elle déborde (chaînes longues
    // sur mobile). scrollIntoView réglerait aussi le scroll vertical de la page,
    // donc on positionne le conteneur à la main.
    const current = list.querySelector('.is-current');
    if (current && list.scrollWidth > list.clientWidth) {
      list.scrollLeft = current.offsetLeft - (list.clientWidth - current.offsetWidth) / 2;
    }
  }

  async function load(state) {
    const section = document.getElementById('lineage-section');
    if (!section) return;
    try {
      const response = await auth.fetchWithTimeout(`/api/airplanes/${state.aircraftId}/lineage`);
      if (!response.ok) throw new Error('Erreur serveur');
      const { chain } = await response.json();
      render(chain, state.aircraftId);
    } catch {
      section.classList.add('hidden'); // silencieux : la fiche reste lisible sans
    }
  }

  VH.details.lineage = { load, render };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.details.lineage;
  }
})();
