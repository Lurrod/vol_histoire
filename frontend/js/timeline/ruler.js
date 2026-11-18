/* Frise — règle des années : barre fixe sous l'en-tête, de 1945 à l'année
 * en cours. Elle remplace le repère de décennie, la mini-carte et la barre
 * de progression, qui disaient trois fois la même chose : l'année réelle
 * (odomètre), un curseur sur l'axe, un bouton par décennie, et les conflits
 * en bandes de durée (décoratives : chaque conflit a son lien dans le
 * chapitre de son début). */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Pistes de bandes de conflits sous l'axe ; au-delà, une bande est omise
  // (la liste du chapitre reste complète).
  const MAX_LANES = 3;
  // L'axe part de 1940 : chaque décennie y a la même largeur et les
  // étiquettes ne se chevauchent pas (1945 et 1950 seraient collées).
  const AXIS_START = 1940;

  let lastYear = null;
  let lastDecade = null;

  function util() { return VH.timeline.util; }

  function bounds() {
    return { start: AXIS_START, end: util().currentYear() };
  }

  /* Position d'une année sur l'axe, en pourcentage borné à [0, 100]. */
  function percent(year, start, end) {
    if (end <= start) return 0;
    return Math.max(0, Math.min(100, ((year - start) / (end - start)) * 100));
  }

  /* Année affichée pour une décennie : 1945 pour le chapitre « 1940 ». */
  function tickYear(decade) {
    return Math.max(decade, util().START_YEAR);
  }

  /* Année atteinte quand on a parcouru `fraction` (0 → 1) d'un chapitre. */
  function yearInChapter(decade, fraction, end) {
    const from = tickYear(decade);
    const to = Math.min(decade + 10, end + 1);
    const f = Math.max(0, Math.min(1, fraction || 0));
    return Math.min(end, Math.max(from, Math.floor(from + f * (to - from))));
  }

  /* Range les conflits en pistes sans chevauchement (premier arrivé, premier
   * servi, par date de début). Un conflit en cours s'étend jusqu'à `end`. */
  function packLanes(wars, end, maxLanes = MAX_LANES) {
    const laneEnds = [];
    const placed = [];
    wars
      .filter(w => Number.isFinite(w.start_year))
      .slice()
      .sort((x, y) => x.start_year - y.start_year)
      .forEach(w => {
        const from = w.start_year;
        const to = Number.isFinite(w.end_year) ? w.end_year : end;
        let lane = laneEnds.findIndex(e => e < from);
        if (lane === -1) {
          if (laneEnds.length >= maxLanes) return;
          lane = laneEnds.length;
          laneEnds.push(to);
        } else {
          laneEnds[lane] = to;
        }
        placed.push({ war: w, lane, from, to });
      });
    return placed;
  }

  function tickLabel(decade) {
    return util().t('timeline.ruler_jump', `Aller aux années ${decade}`, { decade: String(decade) });
  }

  function renderTicks(decades) {
    return decades.map(d => {
      const y = d.decade;
      return `
        <li class="tl-tick-item" data-year="${y}">
          <button type="button" class="tl-tick" data-target="ch-${d.decade}" data-decade="${d.decade}"
                  aria-label="${util().escapeAttr(tickLabel(d.decade))}">
            <span class="tl-tick-full">${y}</span><span class="tl-tick-short" aria-hidden="true">’${String(y).slice(2)}</span>
          </button>
        </li>`;
    }).join('');
  }

  function renderLanes(placed) {
    return placed.map(p => `
        <span class="tl-ruler-war" data-lane="${p.lane}" data-from="${p.from}" data-to="${p.to}"></span>`).join('');
  }

  /* Positions posées par le CSSOM (la CSP interdit les attributs style). */
  function place(root, start, end) {
    root.querySelectorAll('.tl-tick-item').forEach(li => {
      li.style.setProperty('--x', percent(Number(li.dataset.year), start, end) + '%');
    });
    root.querySelectorAll('.tl-ruler-war').forEach(el => {
      const from = Number(el.dataset.from);
      const to = Number(el.dataset.to);
      el.style.setProperty('--x', percent(from, start, end) + '%');
      el.style.setProperty('--w', Math.max(0.6, percent(to + 1, start, end) - percent(from, start, end)) + '%');
    });
  }

  function onTickClick(btn) {
    const target = document.getElementById(btn.dataset.target);
    if (!target) return;
    util().scrollToElement(target);
  }

  /* Construit la règle. `wars` = conflits affichés (filtre compris). */
  function render(decades, wars) {
    const root = document.getElementById('tl-ruler');
    if (!root) return;
    const { start, end } = bounds();
    root.innerHTML = `
      <div class="tl-ruler-track" aria-hidden="true">
        <div class="tl-ruler-lanes">${renderLanes(packLanes(wars || [], end))}</div>
        <span class="tl-ruler-cursor" id="tl-ruler-cursor"></span>
      </div>
      <ol class="tl-ruler-ticks">${renderTicks(decades)}</ol>`;
    place(root, start, end);
    root.querySelectorAll('.tl-tick').forEach(btn => {
      btn.addEventListener('click', () => onTickClick(btn));
    });
    const year = lastYear;
    const decade = lastDecade;
    lastYear = null;
    if (year !== null) setYear(year, decade);
  }

  /* Reporte l'année courante : odomètre, curseur, décennie active. */
  function setYear(year, decade) {
    if (year === lastYear && decade === lastDecade) return;
    lastYear = year;
    lastDecade = decade;
    const { start, end } = bounds();
    const num = document.getElementById('tl-bar-year');
    if (num) {
      if (window.VH.rollingNumber) VH.rollingNumber.setText(num, String(year));
      else num.textContent = String(year);
    }
    const cursor = document.getElementById('tl-ruler-cursor');
    if (cursor) cursor.style.setProperty('--x', percent(year, start, end) + '%');
    document.querySelectorAll('.tl-tick').forEach(btn => {
      const active = Number(btn.dataset.decade) === decade;
      btn.classList.toggle('active', active);
      if (active) btn.setAttribute('aria-current', 'true');
      else btn.removeAttribute('aria-current');
    });
  }

  /* Hauteur réelle de l'en-tête (il se resserre au défilement) : la règle se
   * colle juste dessous. */
  function syncBarTop() {
    const bar = document.getElementById('tl-bar');
    const header = document.querySelector('body > header');
    if (!bar || !header) return;
    const apply = () => bar.style.setProperty('--tl-bar-top', header.getBoundingClientRect().height + 'px');
    apply();
    // border-box : l'en-tête se resserre par son padding, que la boîte de
    // contenu (observée par défaut) ne voit pas.
    if (typeof ResizeObserver === 'function') new ResizeObserver(apply).observe(header, { box: 'border-box' });
  }

  /* Lien direct : /timeline#1962 (ou #ch-1960) ouvre le bon chapitre. */
  function decadeFromHash(hash) {
    const m = /^#(?:ch-)?(\d{4})$/.exec(hash || '');
    return m ? Math.floor(Number(m[1]) / 10) * 10 : null;
  }

  function jumpToHash(hash) {
    const decade = decadeFromHash(hash);
    if (decade === null) return false;
    const target = document.getElementById('ch-' + decade);
    if (!target) return false;
    const y = target.getBoundingClientRect().top + window.pageYOffset - util().scrollOffset();
    window.scrollTo({ top: y, behavior: 'auto' });
    return true;
  }

  function _reset() { lastYear = null; lastDecade = null; }

  const api = {
    MAX_LANES,
    AXIS_START,
    percent,
    tickYear,
    yearInChapter,
    packLanes,
    render,
    setYear,
    syncBarTop,
    decadeFromHash,
    jumpToHash,
    _reset,
  };
  window.VH.timeline.ruler = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
