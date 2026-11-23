/* Frise — rendu : chapitres par décennie (title card, récit, événements,
 * conflits ouverts, appareils marquants puis « piste » année par année),
 * messages d'état.
 * Chaque chapitre porte data-decade : timeline.css en tire --era-color. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  function util() { return VH.timeline.util; }
  function data() { return VH.timeline.data; }
  function t(key, fallback, params) { return util().t(key, fallback, params); }

  /* ========================================================================
     APPAREILS
     ======================================================================== */

  /* Pastille d'un appareil placé à son premier vol : annulé, ou pas encore
   * en service. Rien pour un appareil placé à sa mise en service. */
  function aircraftTag(a) {
    if (a.year_source !== 'first_flight') return '';
    if (a.status === 'Annulé') return t('timeline.tag_cancelled', 'Annulé');
    if (a.status === 'En développement') return t('timeline.tag_in_development', 'En développement');
    return t('timeline.tag_first_flight', '1er vol');
  }

  function renderAircraftCard(a) {
    const name = util().localName(a);
    const country = util().localName(a, 'country_name');
    const img = a.image_url || '';
    const gen = a.generation ? `G${a.generation}` : '';
    const tag = aircraftTag(a);
    const year = Number.isFinite(a.year) ? a.year : '—';
    return `
      <a class="tl-plane-card${tag ? ' is-proto' : ''}" href="${VH.shared.buildDetailsPath(a.id, a.name)}" data-morph-id="${Number(a.id)}">
        <div class="tl-plane-img" data-morph="photo">
          ${img ? VH.shared.picture.pictureHtml(img, { alt: name, loading: 'lazy', width: '400', height: '225' }) : ''}
          <span class="tl-plane-year">${escapeHtml(String(year))}</span>
          ${gen ? `<span class="tl-plane-gen">${gen}</span>` : ''}
        </div>
        <div class="tl-plane-body">
          <h3 class="tl-plane-name">${escapeHtml(name)}</h3>
          <div class="tl-plane-country">${escapeHtml(country)}${tag ? ` · <span class="tl-plane-tag">${escapeHtml(tag)}</span>` : ''}</div>
        </div>
      </a>
    `;
  }

  function renderChip(a) {
    const name = util().localName(a);
    const country = util().localName(a, 'country_name');
    const tag = aircraftTag(a);
    const thumb = a.image_url
      ? VH.shared.picture.thumbHtml(a.image_url, { alt: '', loading: 'lazy', width: '48', height: '32' })
      : '';
    return `
          <li><a class="tl-chip${tag ? ' is-proto' : ''}" href="${VH.shared.buildDetailsPath(a.id, a.name)}" data-morph-id="${Number(a.id)}">
            <span class="tl-chip-img" aria-hidden="true" data-morph="photo">${thumb}</span>
            <span class="tl-chip-text">
              <span class="tl-chip-name">${escapeHtml(name)}</span>
              <span class="tl-chip-meta">${escapeHtml(country)}${tag ? ` · <span class="tl-chip-tag">${escapeHtml(tag)}</span>` : ''}</span>
            </span>
          </a></li>`;
  }

  function renderRunway(others) {
    if (others.length === 0) return '';
    const rows = data().groupByYear(others).map(g => `
        <li class="tl-runway-row" data-year="${g.year}">
          <span class="tl-runway-year">${g.year}</span>
          <ul class="tl-chips">${g.aircraft.map(renderChip).join('')}
          </ul>
        </li>`).join('');
    return `
          <div class="tl-runway">
            <h3 class="tl-sub-label">${escapeHtml(t('timeline.runway_label', 'Année par année'))}</h3>
            <ol class="tl-runway-list">${rows}
            </ol>
          </div>`;
  }

  function lensName(lens) {
    return [lens && lens.nationLabel, lens && lens.typeLabel].filter(Boolean).join(' · ');
  }

  function renderAircraftBlock(bucket, lens) {
    const aircraft = bucket.aircraft || [];
    const filtering = data().isLensActive(lens);
    if (aircraft.length === 0 && !filtering) return '';
    const label = `${escapeHtml(t('timeline.chapter_aircraft_label', 'Appareils'))} · <strong>${aircraft.length}</strong>`;
    if (aircraft.length === 0) {
      return `
            <div class="tl-aircraft-section">
              <span class="tl-section-label">${label}</span>
              <p class="tl-lens-empty">${escapeHtml(t('timeline.lens_empty_decade', 'Aucun appareil pour ce filtre dans cette décennie.', { lens: lensName(lens) }))}</p>
            </div>`;
    }
    const { featured, others } = data().splitAircraft(bucket);
    const more = t('timeline.hangar_link', `Voir ces ${aircraft.length} appareils dans le hangar`,
      { n: String(aircraft.length), decade: String(bucket.decade) });
    return `
            <div class="tl-aircraft-section">
              <span class="tl-section-label">${label}</span>
              <div class="tl-aircraft-grid">
                ${featured.map(renderAircraftCard).join('')}
              </div>
              ${renderRunway(others)}
              <a class="tl-hangar-link" href="${util().escapeAttr(data().hangarUrl(bucket.decade, lens))}">
                <span>${escapeHtml(more)}</span>
                <i class="fas fa-arrow-right" aria-hidden="true"></i>
              </a>
            </div>
          `;
  }

  /* ========================================================================
     CONFLITS
     ======================================================================== */

  function warYears(w) {
    if (!Number.isFinite(w.end_year)) return `${w.start_year}–`;
    if (w.end_year === w.start_year) return String(w.start_year);
    return `${w.start_year}–${w.end_year}`;
  }

  function renderConflict(w) {
    // Sous un filtre (nation, type) : appareils de la vue filtrée.
    const n = Number.isFinite(w.lens_count) ? w.lens_count : (w.aircraft_ids || []).length;
    const count = t(n === 1 ? 'timeline.conflict_aircraft_one' : 'timeline.conflict_aircraft_other',
      `${n} appareil${n === 1 ? '' : 's'}`, { n: String(n) });
    const to = Number.isFinite(w.end_year) ? w.end_year : util().currentYear();
    return `
            <li class="tl-conflict" data-from="${w.start_year}" data-to="${to}">
              <a class="tl-conflict-link" href="/conflits/${encodeURIComponent(w.slug)}">
                <span class="tl-conflict-name">${escapeHtml(util().localName(w))}</span>
                <span class="tl-conflict-meta">${escapeHtml(warYears(w))} · ${escapeHtml(count)}</span>
              </a>
              <span class="tl-conflict-track" aria-hidden="true"><span class="tl-conflict-bar"></span></span>${renderConflictDates(w)}
            </li>`;
  }

  /* Date clé selon sa précision : « 5 juin 1967 », « juin 1967 » ou « 1967 ».
   * Même règle que backend/utils/timeline-ssr.js (keyDate). */
  function keyDate(e) {
    const [y, m, d] = String(e.date || '').split('-').map(Number);
    if (!y) return { iso: '', text: '' };
    if (e.precision === 'year') return { iso: String(y), text: String(y) };
    const date = new Date(Date.UTC(y, (m || 1) - 1, d || 1));
    const locale = util().currentLang() === 'en' ? 'en-GB' : 'fr-FR';
    const opts = e.precision === 'month'
      ? { month: 'long', year: 'numeric', timeZone: 'UTC' }
      : { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' };
    return { iso: e.precision === 'month' ? e.date.slice(0, 7) : e.date, text: date.toLocaleDateString(locale, opts) };
  }

  /* Titres des dates clés : seuls les italiques Markdown des noms d'opération
   * (*Moked*) sont rendus, sur du texte déjà échappé. */
  function italics(html) {
    return html.replace(/\*([^*\n]+)\*/g, '<em>$1</em>');
  }

  /* Dépliant natif des dates clés de la page du conflit, fermé par défaut. */
  function renderConflictDates(w) {
    const events = Array.isArray(w.events) ? w.events : [];
    if (events.length === 0) return '';
    const n = events.length;
    const label = t(n === 1 ? 'timeline.conflict_dates_one' : 'timeline.conflict_dates_other',
      `${n} date${n === 1 ? '' : 's'}`, { n: String(n) });
    const items = events.map(e => {
      const { iso, text } = keyDate(e);
      return `<li><time datetime="${escapeHtml(iso)}">${escapeHtml(text)}</time><span class="tl-conflict-date-title">${italics(escapeHtml(util().localName(e, 'title')))}</span></li>`;
    }).join('');
    return `
              <details class="tl-conflict-dates">
                <summary>${escapeHtml(label)}</summary>
                <ol class="tl-conflict-date-list">${items}</ol>
                <a class="tl-conflict-dates-more" href="/conflits/${encodeURIComponent(w.slug)}">${escapeHtml(t('timeline.conflict_read', 'Lire la page du conflit'))}</a>
              </details>`;
  }

  function renderConflictsBlock(wars) {
    if (wars.length === 0) return '';
    return `
          <div class="tl-conflicts">
            <span class="tl-section-label">${escapeHtml(t('timeline.chapter_conflicts_label', 'Conflits'))} · <strong>${wars.length}</strong></span>
            <ul class="tl-conflict-list">${wars.map(renderConflict).join('')}
            </ul>
          </div>`;
  }

  /* Barres de durée dans la piste de la décennie (CSSOM : la CSP interdit
   * les attributs style). Un conflit qui déborde porte `.continues`. */
  function placeConflictBars(root) {
    root.querySelectorAll('.tl-chapter').forEach(ch => {
      const decade = Number(ch.dataset.decade);
      ch.querySelectorAll('.tl-conflict').forEach(li => {
        const from = Number(li.dataset.from);
        const to = Number(li.dataset.to);
        const last = Math.min(to, decade + 9);
        const left = Math.max(0, (from - decade) * 10);
        const width = Math.max(4, (last - Math.max(from, decade) + 1) * 10);
        li.style.setProperty('--x', left + '%');
        li.style.setProperty('--w', Math.min(100 - left, width) + '%');
        li.classList.toggle('continues', to > decade + 9);
      });
    });
  }

  /* ========================================================================
     ÉVÉNEMENTS ÉDITORIAUX
     ======================================================================== */

  function renderEventPlane(airplane) {
    if (!airplane) return '';
    const name = util().localName(airplane);
    return `
      <a class="tl-event-plane" href="${VH.shared.buildDetailsPath(airplane.id, airplane.name)}">
        <div class="tl-event-plane-img">
          ${airplane.image_url ? VH.shared.picture.pictureHtml(airplane.image_url, { alt: name, loading: 'lazy', width: '320', height: '180' }) : ''}
        </div>
        <div class="tl-event-plane-body">
          <span class="tl-event-plane-name">${escapeHtml(name)}</span>
          <span class="tl-event-plane-cta">${escapeHtml(t('timeline.event_read_more', 'Lire la fiche'))} <i class="fas fa-arrow-right" aria-hidden="true"></i></span>
        </div>
      </a>
    `;
  }

  function renderEventCard(ev, idx) {
    const u = util();
    const kindLabel = t(`timeline.kind_${ev.kind || 'milestone'}`, '');
    const title = u.localized(ev, 'title');
    const body = u.localized(ev, 'body');
    const author = u.localized(ev, 'quote_author');
    const dateStr = u.fmtDate(ev.event_date);
    const year = u.yearOf(ev.event_date) || '';

    return `
      <article class="tl-event tl-event-kind-${u.escapeAttr(ev.kind || 'milestone')}" data-idx="${idx}" data-year="${year}">
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

  function renderEventsBlock(events) {
    if (events.length === 0) return '';
    return `
            <div class="tl-events">
              <span class="tl-section-label">${escapeHtml(t('timeline.chapter_events_label', 'Événements marquants'))} · <strong>${events.length}</strong></span>
              <div class="tl-events-list">
                ${events.map(renderEventCard).join('')}
              </div>
            </div>
          `;
  }

  /* ========================================================================
     CHAPITRES PAR DÉCENNIE
     ======================================================================== */

  function renderTitleCard(dec, chapterNum, era) {
    return `
          <header class="tl-title-card">
            <div class="tl-title-card-inner">
              <div class="tl-title-meta">
                <span class="tl-title-chapter">${escapeHtml(t('timeline.chapter_label', 'Chapitre'))} · ${chapterNum}</span>
                <span class="tl-title-span">${Math.max(dec, util().START_YEAR)}–${dec + 9}</span>
              </div>
              <div class="tl-title-decade" aria-hidden="true">
                <span class="tl-title-decade-num">${dec}</span>
                <span class="tl-title-decade-suffix">s</span>
              </div>
              <span class="tl-title-label">${escapeHtml(era.label)}</span>
              <h2 class="tl-title-era" id="ch-${dec}-title">${escapeHtml(era.title)}</h2>
            </div>
          </header>`;
  }

  function renderChapter(bucket, idx, wars, lens) {
    const dec = bucket.decade;
    const era = VH.timeline.era.getEra(dec);
    const chapterNum = String(idx + 1).padStart(2, '0');
    return `
        <section class="tl-chapter" id="ch-${dec}" data-decade="${dec}" aria-labelledby="ch-${dec}-title">
          <div class="tl-chapter-tint" aria-hidden="true"></div>
${renderTitleCard(dec, chapterNum, era)}

          <div class="tl-narrative">
            <span class="tl-section-label">${escapeHtml(t('timeline.chapter_narrative_label', 'Le récit'))}</span>
            <p class="tl-narrative-text">${escapeHtml(era.narrative)}</p>
          </div>

          ${renderEventsBlock(bucket.events || [])}

          ${renderConflictsBlock(data().warsOfDecade(wars || [], dec))}

          ${renderAircraftBlock(bucket, lens)}
        </section>
      `;
  }

  /**
   * @param {object[]} decades - décennies (filtrées)
   * @param {object[]} [wars] - conflits (filtrés)
   * @param {object} [lens] - filtre courant { nation, type, nationLabel, typeLabel }
   */
  function renderChapters(decades, wars = [], lens = null) {
    const root = document.getElementById('tl-chapters');
    if (!root) return;
    root.innerHTML = decades.map((b, i) => renderChapter(b, i, wars, lens)).join('');
    placeConflictBars(root);
  }

  /* Message d'état (frise vide, erreur de chargement) à la place des chapitres. */
  function renderMessage(text) {
    const root = document.getElementById('tl-chapters');
    if (root) root.innerHTML = `<p class="tl-empty-msg">${escapeHtml(text)}</p>`;
  }

  const api = {
    aircraftTag,
    renderAircraftCard,
    renderChip,
    renderEventCard,
    renderConflict,
    warYears,
    placeConflictBars,
    renderChapter,
    renderChapters,
    renderMessage,
  };
  window.VH.timeline.render = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
