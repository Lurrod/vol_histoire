/* Frise — rendu : chapitres par décennie (title card + narratif + événements
 * + grille d'appareils), cartes, minimap et messages d'état.
 * Chaque chapitre porte data-decade : timeline.css en tire --era-color. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  function util() { return VH.timeline.util; }

  /* =========================================================================
     CARTES D'APPAREIL
     ========================================================================= */

  function renderAircraftCard(a) {
    const year = a.date_operationel ? new Date(a.date_operationel).getFullYear() : '—';
    const lang = util().currentLang();
    const name = (lang === 'en' && a.name_en) ? a.name_en : a.name;
    const country = (lang === 'en' && a.country_name_en)
      ? a.country_name_en
      : (a.country_name || '');
    const img = a.image_url || '';
    const gen = a.generation ? `G${a.generation}` : '';
    return `
      <a class="tl-plane-card" href="${VH.shared.buildDetailsPath(a.id, a.name)}">
        <div class="tl-plane-img">
          ${img ? VH.shared.picture.pictureHtml(img, { alt: a.name, loading: 'lazy', width: '400', height: '300' }) : ''}
          <span class="tl-plane-year">${year}</span>
          ${gen ? `<span class="tl-plane-gen">${gen}</span>` : ''}
        </div>
        <div class="tl-plane-body">
          <h4 class="tl-plane-name">${escapeHtml(name)}</h4>
          <div class="tl-plane-country">${escapeHtml(country)}</div>
        </div>
      </a>
    `;
  }

  /* =========================================================================
     ÉVÉNEMENTS ÉDITORIAUX
     ========================================================================= */

  function renderEventPlane(airplane) {
    if (!airplane) return '';
    return `
      <a class="tl-event-plane" href="${VH.shared.buildDetailsPath(airplane.id, airplane.name)}">
        <div class="tl-event-plane-img">
          ${airplane.image_url ? VH.shared.picture.pictureHtml(airplane.image_url, { alt: airplane.name, loading: 'lazy', width: '320', height: '180' }) : ''}
        </div>
        <div class="tl-event-plane-body">
          <span class="tl-event-plane-name">${escapeHtml(airplane.name)}</span>
          <span class="tl-event-plane-cta">${i18n.t('timeline.event_read_more')} <i class="fas fa-arrow-right"></i></span>
        </div>
      </a>
    `;
  }

  function renderEventCard(ev, idx) {
    const u = util();
    const kindLabel = i18n.t(`timeline.kind_${ev.kind || 'milestone'}`);
    const title = u.localized(ev, 'title');
    const body = u.localized(ev, 'body');
    const author = u.localized(ev, 'quote_author');
    const dateStr = u.fmtDate(ev.event_date);
    const year = ev.event_date ? new Date(ev.event_date).getFullYear() : '';

    return `
      <article class="tl-event tl-event-kind-${u.escapeAttr(ev.kind || 'milestone')}" data-idx="${idx}">
        <div class="tl-event-rail">
          <span class="tl-event-year">${escapeHtml(String(year))}</span>
          <span class="tl-event-kind">${escapeHtml(kindLabel)}</span>
          <span class="tl-event-date">${escapeHtml(dateStr)}</span>
        </div>
        <div class="tl-event-body">
          <h3 class="tl-event-title">${escapeHtml(title)}</h3>
          <p class="tl-event-text">${escapeHtml(body)}</p>
          ${author ? `<cite class="tl-event-author">— ${escapeHtml(author)}</cite>` : ''}
          ${renderEventPlane(ev.airplane)}
        </div>
      </article>
    `;
  }

  /* =========================================================================
     CHAPITRES PAR DÉCENNIE
     ========================================================================= */

  function renderTitleCard(dec, chapterNum, era) {
    return `
          <header class="tl-title-card">
            <div class="tl-title-card-inner">
              <div class="tl-title-meta">
                <span class="tl-title-chapter">${escapeHtml(i18n.t('timeline.chapter_label'))} · ${chapterNum}</span>
                <span class="tl-title-span">${dec}–${dec + 9}</span>
              </div>
              <div class="tl-title-decade">
                <span class="tl-title-decade-num">${dec}</span>
                <span class="tl-title-decade-suffix">s</span>
              </div>
              <span class="tl-title-label">${escapeHtml(era.label)}</span>
              <h2 class="tl-title-era">${escapeHtml(era.title)}</h2>
            </div>
          </header>`;
  }

  function renderEventsBlock(events) {
    if (events.length === 0) return '';
    return `
            <div class="tl-events">
              <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_events_label'))} · <strong>${events.length}</strong></span>
              <div class="tl-events-list">
                ${events.map(renderEventCard).join('')}
              </div>
            </div>
          `;
  }

  function renderAircraftBlock(aircraft) {
    if (aircraft.length === 0) return '';
    return `
            <div class="tl-aircraft-section">
              <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_aircraft_label'))} · <strong>${aircraft.length}</strong></span>
              <div class="tl-aircraft-grid">
                ${aircraft.map(renderAircraftCard).join('')}
              </div>
            </div>
          `;
  }

  function renderChapter(bucket, idx) {
    const dec = bucket.decade;
    const era = VH.timeline.era.getEra(dec);
    const chapterNum = String(idx + 1).padStart(2, '0');
    return `
        <section class="tl-chapter" id="ch-${dec}" data-decade="${dec}">
          <div class="tl-chapter-tint" aria-hidden="true"></div>
${renderTitleCard(dec, chapterNum, era)}

          <div class="tl-narrative">
            <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_narrative_label'))}</span>
            <p class="tl-narrative-text">${escapeHtml(era.narrative)}</p>
          </div>

          ${renderEventsBlock(bucket.events || [])}

          ${renderAircraftBlock(bucket.aircraft || [])}
        </section>
      `;
  }

  function renderChapters(decades) {
    const root = document.getElementById('tl-chapters');
    if (!root) return;
    root.innerHTML = decades.map(renderChapter).join('');
  }

  /* Message d'état (frise vide, erreur de chargement) à la place des chapitres. */
  function renderMessage(text) {
    const root = document.getElementById('tl-chapters');
    if (root) root.innerHTML = `<p class="tl-empty-msg">${escapeHtml(text)}</p>`;
  }

  /* =========================================================================
     MINIMAP
     ========================================================================= */

  function onMinimapClick(mm, btn) {
    const target = document.getElementById(btn.dataset.target);
    if (!target) return;
    mm.querySelectorAll('.tl-mm-btn').forEach(b => b.classList.toggle('active', b === btn));
    VH.timeline.era.showActiveEra(target);
    util().scrollToElement(target);
  }

  function renderMinimap(decades) {
    const mm = document.getElementById('tl-minimap');
    if (!mm) return;
    mm.innerHTML = decades.map(b => `
      <button class="tl-mm-btn" data-target="ch-${b.decade}" aria-label="${b.decade}s">
        <span class="tl-mm-label">${b.decade}s</span>
        <span class="tl-mm-tick"></span>
      </button>
    `).join('');
    mm.querySelectorAll('.tl-mm-btn').forEach(btn => {
      btn.addEventListener('click', () => onMinimapClick(mm, btn));
    });
  }

  const api = {
    renderAircraftCard,
    renderEventCard,
    renderChapter,
    renderChapters,
    renderMessage,
    renderMinimap,
  };
  window.VH.timeline.render = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
