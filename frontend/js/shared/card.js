/* Template carte avion — source de vérité unique.
 * Utilisée par hangar, favorites, et potentiellement index.
 * Ne gère PAS le click handler (laissé à l'appelant pour flexibilité).
 */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  /* options:
   *   - removeBtn: true  → affiche un bouton "retirer des favoris" (page favorites)
   *   - footerHtml: string → HTML injecté en bas de la carte (ex: date de favori)
   *   - showDescription: bool (default true) → masque la description courte
   */
  function renderAircraftCard(aircraft, options = {}) {
    const esc = window.escapeHtml;
    const alpha = VH.shared.ALPHA3_TO_ALPHA2;
    const noDesc = (window.i18n && i18n.t('details.no_desc_available')) || '';
    const removeBtn = options.removeBtn
      ? `<button class="favorite-remove" data-airplane-id="${aircraft.id}" title="${window.i18n ? i18n.t('details.remove_favorite') : 'Retirer'}"><i class="fas fa-heart-broken"></i></button>`
      : '';
    const footer = options.footerHtml || '';
    const description = options.showDescription === false
      ? ''
      : `<p class="aircraft-description">${esc(aircraft.little_description) || noDesc}</p>`;
    const yearLine = aircraft.date_operationel
      ? `<div class="spec-item"><i class="fas fa-calendar"></i><span>${new Date(aircraft.date_operationel).getFullYear()}</span></div>`
      : '';
    const speedLine = aircraft.max_speed
      ? `<div class="spec-item"><i class="fas fa-gauge-high"></i><span>${esc(aircraft.max_speed)} km/h</span></div>`
      : '';
    const flag = (aircraft.country_code && alpha[aircraft.country_code])
      ? `<img class="country-flag" src="https://flagcdn.com/w40/${alpha[aircraft.country_code]}.png" alt="${esc(aircraft.country_name)}" width="24" height="18">`
      : '';
    const genBadge = aircraft.generation
      ? `<span class="aircraft-badge generation">${esc(aircraft.generation)}e Gén</span>` : '';
    const typeBadge = aircraft.type_name
      ? `<span class="aircraft-badge type">${esc(aircraft.type_name)}</span>` : '';

    return `
      <article class="aircraft-card" data-id="${aircraft.id}" tabindex="0" role="link" aria-label="${esc(aircraft.name)}">
        ${removeBtn}
        <div class="aircraft-image">
          <img src="${esc(aircraft.image_url) || 'https://via.placeholder.com/400x300?text=No+Image'}"
               alt="${esc(aircraft.name)}"
               loading="lazy" width="400" height="300">
          <div class="aircraft-overlay">
            <div class="aircraft-badges">${genBadge}${typeBadge}</div>
          </div>
        </div>
        <div class="aircraft-content">
          <div class="aircraft-header">
            <div class="aircraft-title">
              <div class="aircraft-name-row">
                <h3>${esc(aircraft.name)}</h3>
                ${flag}
              </div>
            </div>
          </div>
          ${description}
          <div class="aircraft-specs">${speedLine}${yearLine}</div>
          ${footer}
        </div>
      </article>
    `;
  }

  /* Attache les handlers click + keyboard (Enter) pour naviguer vers /details.
   * À appeler après avoir injecté le HTML. */
  function bindCardNavigation(container) {
    container.querySelectorAll('.aircraft-card').forEach(card => {
      const name = card.querySelector('h3')?.textContent || '';
      const go = () => { window.location.href = buildDetailsPath(card.dataset.id, name); };
      card.addEventListener('click', go);
      card.addEventListener('keydown', (e) => { if (e.key === 'Enter') go(); });
    });
  }

  function cardSlugify(text) {
    return String(text || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  function buildDetailsPath(id, name) {
    const slug = cardSlugify(name);
    return slug ? `/details/${slug}-${id}` : `/details/${id}`;
  }

  VH.shared.renderAircraftCard = renderAircraftCard;
  VH.shared.bindCardNavigation = bindCardNavigation;
  VH.shared.buildDetailsPath = buildDetailsPath;
})();
