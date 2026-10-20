/* Accueil v4.10.0 — blocs alimentés par l'API sous le hero.
 *
 *   - compteurs des cinq tuiles de génération (/api/airplanes/facets) ;
 *   - types de mission rangés en trois familles, nom traduit lu dans
 *     /api/referentials (facets ne donne que le nom français, qui est aussi
 *     la valeur du filtre ?type= du hangar) ;
 *   - fin de page : invitation à créer un compte, ou les derniers favoris
 *     si une session existe ;
 *   - branchement des suggestions de recherche du hero.
 *
 * groupTypes() est pure ; elle et les fonctions de rendu sont exportées pour
 * Jest (jsdom). Dans le navigateur, init() part au DOMContentLoaded.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  /* Familles, par nom canonique (français) des types en base. Un type absent
   * de ces listes — ajout futur au référentiel — tombe dans « Autres » plutôt
   * que de disparaître de la page. */
  const FAMILIES = [
    { key: 'family_combat', types: ['Chasseur', 'Multirôle', 'Intercepteur', 'Appui aérien', 'Bombardier'] },
    { key: 'family_support', types: ['Transport', 'Ravitailleur', 'Reconnaissance', 'Guerre électronique'] },
    { key: 'family_training', types: ['Entraîneur', 'Recherche', 'Drone de combat'] },
  ];
  const OTHER_FAMILY = 'family_other';

  /** { Chasseur: 63, … } → [{ key, total, items: [[type, n], …] }], familles
   *  vides retirées, types triés par effectif décroissant. */
  function groupTypes(counts) {
    const known = new Set(FAMILIES.flatMap((f) => f.types));
    const groups = FAMILIES.map((f) => ({
      key: f.key,
      items: f.types.filter((type) => counts[type]).map((type) => [type, counts[type]]),
    }));
    const others = Object.entries(counts).filter(([type, n]) => n && !known.has(type));
    if (others.length) groups.push({ key: OTHER_FAMILY, items: others });
    return groups
      .filter((g) => g.items.length)
      .map((g) => ({
        key: g.key,
        total: g.items.reduce((sum, [, n]) => sum + n, 0),
        items: [...g.items].sort((a, b) => b[1] - a[1]),
      }));
  }

  /* ---------- Générations et missions ---------- */

  function renderGenerations(generations) {
    const { trn } = VH.home.text;
    document.querySelectorAll('[data-gen-count]').forEach((el) => {
      const n = generations[el.dataset.genCount];
      el.textContent = n ? trn('count', n) : '';
    });
  }

  function renderMissions(container, counts, labels) {
    const { tr, trn } = VH.home.text;
    container.innerHTML = groupTypes(counts).map((g) => `
      <section class="mission-family">
        <h3 class="mission-family-title">${escapeHtml(tr(g.key))} <span>${escapeHtml(trn('count', g.total))}</span></h3>
        <ul class="mission-family-list">${g.items.map(([type, n]) => `
          <li><a class="mission-type" href="/hangar?type=${encodeURIComponent(type)}">
            <span class="mission-type-name">${escapeHtml(labels[type] || type)}</span>
            <span class="mission-type-count">${n}</span>
          </a></li>`).join('')}
        </ul>
      </section>`).join('');
  }

  /** nom français → nom dans la langue courante ; {} si le référentiel échoue
   *  (les noms français restent alors affichés, ce qui vaut mieux que rien). */
  async function loadTypeLabels() {
    try {
      const res = await auth.fetchWithTimeout('/api/referentials');
      if (!res.ok) return {};
      const { types } = await res.json();
      return (Array.isArray(types) ? types : []).reduce((acc, t) => {
        if (t.name_fr) acc[t.name_fr] = t.name;
        return acc;
      }, {});
    } catch {
      return {};
    }
  }

  async function loadFacets() {
    const container = document.getElementById('mission-families');
    const status = document.getElementById('missions-status');
    try {
      const [res, labels] = await Promise.all([
        auth.fetchWithTimeout('/api/airplanes/facets'),
        loadTypeLabels(),
        VH.home.text.whenReady(),
      ]);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();
      renderGenerations(data.generations || {});
      if (container) renderMissions(container, data.types || {}, labels);
    } catch {
      if (status) status.textContent = VH.home.text.tr('types_error');
    }
  }

  /* ---------- Fin de page selon la session ---------- */

  function renderSignedIn(user, favorites) {
    const title = document.getElementById('home-end-title');
    const text = document.getElementById('home-end-text');
    const favs = document.getElementById('home-end-favs');
    const actions = document.getElementById('home-end-actions');
    if (!title || !text || !favs || !actions) return;

    const { tr, trn } = VH.home.text;
    const first = String(user.name || '').trim().split(/\s+/)[0];
    const hangarLink = (variant) => `<a href="/hangar" class="btn ${variant} btn-large">`
      + `<i class="fas fa-plane-departure" aria-hidden="true"></i><span>${escapeHtml(tr('end_hangar'))}</span></a>`;

    // Le titre statique porte data-i18n-html : on retire l'attribut, sinon un
    // applyToDOM() ultérieur remettrait l'invitation à créer un compte.
    [title, text].forEach((el) => {
      el.removeAttribute('data-i18n');
      el.removeAttribute('data-i18n-html');
    });
    title.textContent = first ? tr('end_welcome', { name: first }) : tr('end_welcome_anon');

    if (!favorites.length) {
      text.textContent = tr('end_empty');
      actions.innerHTML = hangarLink('btn-primary');
      return;
    }

    text.textContent = trn('end_count', favorites.length);
    favs.innerHTML = favorites.slice(0, 4).map((a) => `
      <a class="home-end-fav" href="${escapeHtml(VH.shared.buildDetailsPath(a.id, a.name))}">
        <span class="home-end-fav-img">${VH.shared.picture.thumbHtml(a.image_url, { alt: '', width: '160', height: '107', loading: 'lazy' })}</span>
        <span class="home-end-fav-name">${escapeHtml(a.name)}</span>
      </a>`).join('');
    favs.hidden = false;
    actions.innerHTML = '<a href="/favorites" class="btn btn-primary btn-large">'
      + `<i class="fas fa-heart" aria-hidden="true"></i><span>${escapeHtml(trn('end_favs', favorites.length))}</span></a>`
      + hangarLink('btn-ghost');
  }

  async function personalizeEnd() {
    try {
      const payload = await auth.init(); // promesse partagée avec script.js
      if (!payload) return; // visiteur anonyme : la version statique reste
      const [res] = await Promise.all([auth.authFetch('/api/favorites'), VH.home.text.whenReady()]);
      if (!res.ok) return;
      const favorites = await res.json();
      renderSignedIn(auth.getUserInfo() || {}, Array.isArray(favorites) ? favorites : []);
    } catch {
      // Échec : l'invitation à créer un compte reste en place, rien de cassé.
    }
  }

  function init() {
    loadFacets();
    personalizeEnd();
    const form = document.getElementById('hero-search');
    if (form) VH.home.searchSuggest.mount(form);
  }

  VH.home.landing = { groupTypes, FAMILIES, renderMissions, renderSignedIn, loadFacets, personalizeEnd, init };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.landing;
  } else {
    document.addEventListener('DOMContentLoaded', init);
  }
})();
