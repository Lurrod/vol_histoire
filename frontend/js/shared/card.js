/* Template carte avion — source de vérité unique.
 * Utilisée par le hangar, les favoris et les pages de conflit.
 *
 * Motif « block link » (A11Y-005) : le seul lien de la carte est son titre,
 * un vrai <a href="/details/<slug>-<id>">, dont le pseudo-élément ::after
 * couvre toute la carte (catalog.css). L'article n'est plus un faux lien
 * (role="link" + tabindex + aria-label qui écrasait tout le contenu) et aucun
 * gestionnaire JS ne navigue : clic, Entrée, clic milieu et « ouvrir dans un
 * nouvel onglet » sont ceux du navigateur, et les robots voient le lien.
 * Les contrôles posés sur la carte (case « Comparer », bouton de retrait des
 * favoris) passent au-dessus du lien par leur z-index.
 */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  /** Traduction, avec repli quand i18n est absent ou que la clé manque. */
  function tr(key, fallback, params) {
    if (!window.i18n || typeof i18n.t !== 'function') return fallback;
    const value = i18n.t(key, params);
    return (typeof value === 'string' && value !== key) ? value : fallback;
  }

  /* Case du comparateur (hangar). Nommée « Comparer <nom> » : six cases
   * « Comparer » indiscernables dans la liste des contrôles d'un lecteur
   * d'écran ne disent pas quel appareil elles ajoutent. Le texte visible
   * (« Comparer ») reste contenu dans le nom accessible (WCAG 2.5.3).
   * hangar/compare.js la trouve déjà posée et se contente de la cocher. */
  function compareCheckHtml(aircraft) {
    const esc = window.escapeHtml;
    const id = Number(aircraft.id);
    const name = aircraft.name || '';
    const label = tr('hangar.compare_label', 'Comparer');
    const named = tr('hangar.compare_label_named', `${label} ${name}`, { name });
    return `<label class="compare-check"><input type="checkbox" data-compare-id="${id}" aria-label="${esc(named)}"><span>${esc(label)}</span></label>`;
  }

  /* options:
   *   - removeBtn: true  → affiche un bouton "retirer des favoris" (page favorites)
   *   - footerHtml: string → HTML injecté en bas de la carte (ex: date de favori)
   *   - showDescription: bool (default true) → masque la description courte
   *   - compare: true → pose la case « Comparer <nom> » (hangar)
   */
  function renderAircraftCard(aircraft, options = {}) {
    const esc = window.escapeHtml;
    const alpha = VH.shared.ALPHA3_TO_ALPHA2;
    const noDesc = tr('details.no_desc_available', '');
    const removeBtn = options.removeBtn
      ? `<button class="favorite-remove" data-airplane-id="${aircraft.id}" title="${esc(tr('details.remove_favorite', 'Retirer'))}"><i class="fas fa-heart-broken"></i></button>`
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
      ? `<img class="country-flag" src="/assets/flags/${alpha[aircraft.country_code]}.png" alt="${esc(aircraft.country_name)}" width="24" height="18" loading="lazy">`
      : '';
    const genBadge = aircraft.generation
      ? `<span class="aircraft-badge generation">${esc(aircraft.generation)}e Gén</span>` : '';
    const typeBadge = aircraft.type_name
      ? `<span class="aircraft-badge type">${esc(aircraft.type_name)}</span>` : '';
    const compare = options.compare ? compareCheckHtml(aircraft) : '';

    const lang = (window.i18n && i18n.currentLang === 'en') ? 'en' : 'fr';
    const imgUrl = aircraft.image_url || `/assets/logo/placeholder-airplane-${lang}.svg`;
    const pic = VH.shared.picture.pictureHtml(imgUrl, {
      alt: aircraft.name || '',
      loading: 'lazy',
      width: '400',
      height: '300',
    });
    const href = buildDetailsPath(aircraft.id, aircraft.name);
    return `
      <article class="aircraft-card" data-id="${Number(aircraft.id)}">
        ${removeBtn}
        <div class="aircraft-image">
          ${pic}
          <div class="aircraft-overlay">
            <div class="aircraft-badges">${genBadge}${typeBadge}</div>
          </div>
        </div>
        <div class="aircraft-content">
          <div class="aircraft-header">
            <div class="aircraft-title">
              <div class="aircraft-name-row">
                <h3><a class="aircraft-card-link" href="${esc(href)}">${esc(aircraft.name)}</a></h3>
                ${flag}
              </div>
            </div>
          </div>
          ${description}
          <div class="aircraft-specs">${speedLine}${yearLine}</div>
          ${footer}
        </div>
        ${compare}
      </article>
    `;
  }

  function cardSlugify(text) {
    return String(text || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[̀-ͯ]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  function buildDetailsPath(id, name) {
    const slug = cardSlugify(name);
    return slug ? `/details/${slug}-${id}` : `/details/${id}`;
  }

  VH.shared.renderAircraftCard = renderAircraftCard;
  VH.shared.buildDetailsPath = buildDetailsPath;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = { renderAircraftCard, buildDetailsPath };
  }
})();
