/* Favoris — rendu : squelettes, grille de cartes (template partagé
 * VH.shared.renderAircraftCard), compteur de résultats, sortie animée
 * d'une carte retirée. */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  const DAY_MS = 1000 * 60 * 60 * 24;
  // Durée de la transition .is-removing (favorites.css).
  const CARD_EXIT_MS = 300;

  function formatRelativeDate(dateString, now = new Date()) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const diffDays = Math.floor((now - date) / DAY_MS);

    if (diffDays === 0) return i18n.t('favorites.added_today');
    if (diffDays === 1) return i18n.t('favorites.added_yesterday');
    if (diffDays < 30) return i18n.t('favorites.added_days_ago', { days: diffDays });
    const diffMonths = Math.floor(diffDays / 30);
    if (diffMonths === 1) return i18n.t('favorites.added_month_ago');
    if (diffMonths < 12) return i18n.t('favorites.added_months_ago', { months: diffMonths });
    return i18n.t('favorites.added_on', { date: date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR') });
  }

  function renderSkeletons() {
    const container = document.getElementById('favorites-container');
    if (!container) return;
    container.classList.remove('hidden');
    container.innerHTML = Array.from({ length: 6 }).map(() => `
      <div class="skeleton-card">
        <div class="skeleton-image"></div>
        <div class="skeleton-content">
          <div class="skeleton-line medium"></div>
          <div class="skeleton-line short"></div>
          <div class="skeleton-line"></div>
          <div class="skeleton-line short"></div>
        </div>
      </div>
    `).join('');
  }

  function updateResultsCount(state) {
    const count = state.filtered.length;
    const text = count === 0 ? i18n.t('favorites.results_none') :
                 count === 1 ? i18n.t('favorites.results_one') :
                 i18n.t('favorites.results', { count });
    document.getElementById('results-count').textContent = text;
  }

  function cardHtml(aircraft) {
    const footer = `<div class="favorited-date"><i class="fas fa-heart"></i><span>${formatRelativeDate(aircraft.favorited_at)}</span></div>`;
    return VH.shared.renderAircraftCard(aircraft, {
      removeBtn: true,
      showDescription: false,
      footerHtml: footer,
    });
  }

  /* La navigation vers la fiche passe par le lien du titre
   * (.aircraft-card-link, étendu à toute la carte en CSS) : seul le bouton de
   * retrait demande un gestionnaire. */
  function bindCards(container, state) {
    container.querySelectorAll('.favorite-remove').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        VH.favorites.remove.removeWithUndo(state, btn);
      });
    });
  }

  function renderFavorites(state) {
    const container = document.getElementById('favorites-container');
    const emptyState = document.getElementById('empty-state');

    // Aucun favori : état vide de la page
    if (state.favorites.length === 0) {
      container.classList.add('hidden');
      emptyState?.classList.remove('hidden');
      return;
    }

    container.classList.remove('hidden');
    emptyState?.classList.add('hidden');

    if (state.filtered.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-search"></i>
          <h3>Aucun résultat</h3>
          <p>Aucun favori ne correspond à votre recherche</p>
        </div>
      `;
      return;
    }

    container.innerHTML = state.filtered.map(cardHtml).join('');
    bindCards(container, state);
  }

  function applyFiltersAndRender(state) {
    state.filtered = VH.favorites.filters.selectFavorites(state);
    renderFavorites(state);
    updateResultsCount(state);
  }

  /* La carte retirée s'efface (classe .is-removing : plus de clic possible),
   * puis sort du flux (.is-removed) une fois la transition jouée. Si c'était
   * la dernière carte affichée, un nouveau rendu affiche l'état vide.
   * `inert` retire aussi son lien et son bouton du parcours clavier.
   * `hadFocus` : la carte avait-elle le focus avant le retrait (à relever par
   * l'appelant avant toute désactivation) ; par défaut, l'état courant. */
  function collapseCard(state, card, hadFocus = Boolean(card && card.contains(document.activeElement))) {
    if (!card) return;
    const neighbour = card.nextElementSibling || card.previousElementSibling;
    card.classList.add('is-removing');
    card.setAttribute('aria-hidden', 'true');
    card.inert = true;
    setTimeout(() => {
      if (!card.isConnected) return; // déjà remplacée par un nouveau rendu
      if (state.filtered.length === 0) { renderFavorites(state); return; }
      card.classList.add('is-removed');
      // Au clavier, le focus ne doit pas rester sur un élément disparu : il
      // passe au lien de la carte voisine (l'article n'est pas focalisable).
      if (hadFocus && neighbour?.classList.contains('aircraft-card') &&
          !neighbour.classList.contains('is-removing')) {
        neighbour.querySelector('.aircraft-card-link')?.focus();
      }
    }, CARD_EXIT_MS);
  }

  const api = {
    CARD_EXIT_MS,
    formatRelativeDate,
    renderSkeletons,
    updateResultsCount,
    renderFavorites,
    applyFiltersAndRender,
    collapseCard,
  };
  window.VH.favorites.render = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
