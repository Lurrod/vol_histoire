/* Dates clés d'un conflit : un carrousel de cartes (date, titre, photo de
 * l'appareil lié) qui glissent sous une tête de lecture (2026-11-26,
 * conflicts/date-carousel.js) et, dessous, un panneau qui raconte la date
 * centrée (date en toutes lettres, titre, récit, lien de l'appareil lié).
 *
 * Accessibilité : motif « onglets » de l'APG (role tablist / tab / tabpanel,
 * tabindex itinérant, flèches gauche/droite, Début/Fin) ; chaque carte est un
 * onglet. Les boutons du panneau (précédente / suivante) changent la date
 * sans déplacer le focus. Au doigt, un glissement horizontal sur le panneau
 * fait de même ; sur le carrousel, la piste suit le doigt.
 *
 * Données : war.events[{ date (AAAA-MM-JJ), precision (day|month|year),
 * title, body, airplane { id, name } }] ; la photo vient de war.airplanes
 * (même id). Tout est échappé ; *italique* rendu par VH.conflicts.detail.inline.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.conflicts = root.VH.conflicts || {};

  const esc = (s) => (typeof escapeHtml === 'function' ? escapeHtml(s) : String(s == null ? '' : s));
  const SWIPE_MIN = 50;

  function lang() {
    return root.i18n && root.i18n.currentLang === 'en' ? 'en' : 'fr';
  }

  function inline(text) {
    const detail = root.VH.conflicts.detail;
    return detail && detail.inline ? detail.inline(text) : esc(text);
  }

  function parseIso(iso) {
    const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(iso || ''));
    return m ? { y: m[1], m: m[2], d: m[3], date: new Date(Date.UTC(+m[1], +m[2] - 1, +m[3])) } : null;
  }

  function intl(date, opts, language, fallback) {
    try {
      return new Intl.DateTimeFormat(language === 'en' ? 'en-GB' : 'fr-FR', { ...opts, timeZone: 'UTC' }).format(date);
    } catch {
      return fallback;
    }
  }

  /**
   * Date lisible selon la précision connue : « 17 janv. 1991 » (ou, en
   * toutes lettres, « 17 janvier 1991 »), « janvier 1991 », « 1991 ».
   */
  function formatEventDate(iso, precision, language, long) {
    const p = parseIso(iso);
    if (!p) return '';
    if (precision === 'year') return p.y;
    if (precision === 'month') return intl(p.date, { month: 'long', year: 'numeric' }, language, `${p.m}/${p.y}`);
    return intl(p.date, { day: 'numeric', month: long ? 'long' : 'short', year: 'numeric' }, language, `${p.d}/${p.m}/${p.y}`);
  }

  /** En-tête d'une date (« 17 janv. », « août », rien) et son année. */
  function dateParts(iso, precision, language) {
    const p = parseIso(iso);
    if (!p) return { lead: '', year: '' };
    if (precision === 'year') return { lead: '', year: p.y };
    const lead = precision === 'month'
      ? intl(p.date, { month: 'long' }, language, p.m)
      : intl(p.date, { day: 'numeric', month: 'short' }, language, `${p.d}/${p.m}`);
    return { lead, year: p.y };
  }

  function detailsPath(id, name) {
    const build = root.VH.shared && root.VH.shared.buildDetailsPath;
    return build ? build(id, name) : `/details/${encodeURIComponent(id)}`;
  }

  function planeOf(e, airplanes) {
    const ref = e && e.airplane;
    return ref ? (airplanes || []).find((a) => a.id === ref.id) || null : null;
  }

  /** Média d'une carte : photo de l'appareil lié, sinon l'année en grand. */
  function mediaHtml(plane, year) {
    if (!plane || !plane.image_url) return `<span class="conflict-tl-placeholder">${esc(year)}</span>`;
    const pic = root.VH.shared && root.VH.shared.picture;
    const attrs = { alt: '', width: 480, height: 300, loading: 'lazy', decoding: 'async', draggable: 'false', sizes: '20rem' };
    return pic
      ? pic.pictureHtml(plane.image_url, attrs)
      : `<img src="${esc(plane.image_url)}" alt="" width="480" height="300" loading="lazy" decoding="async" draggable="false">`;
  }

  /** Cartes : un onglet par date ; seul l'onglet choisi est dans l'ordre de tabulation. */
  function cardsHtml(events, selected, airplanes) {
    const language = lang();
    return (events || []).map((e, i) => {
      const on = i === selected;
      const { year } = dateParts(e.date, e.precision, language);
      const meta = e.airplane
        ? `<span class="conflict-tl-meta"><i class="fas fa-plane" aria-hidden="true"></i> ${esc(e.airplane.name)}</span>`
        : '';
      return `<button type="button" class="conflict-tl-card" role="tab" id="conflict-date-tab-${i}"`
        + ` aria-controls="conflict-event-panel" aria-selected="${on}" tabindex="${on ? 0 : -1}" data-index="${i}">`
        + `<time class="conflict-tl-date" datetime="${esc(e.date)}">${esc(formatEventDate(e.date, e.precision, language, false))}</time>`
        + `<span class="conflict-tl-title">${inline(e.title)}</span>`
        + `<span class="conflict-tl-media">${mediaHtml(planeOf(e, airplanes), year)}</span>`
        + meta
        + '</button>';
    }).join('');
  }

  /**
   * Année de la carte centrée, en grand au-dessus de la piste : une seule,
   * dont les chiffres défilent (VH.rollingNumber, comme les autres compteurs).
   */
  function showYear(el, e) {
    if (!el) return;
    const p = parseIso(e && e.date);
    const year = p ? p.y : '';
    const roll = root.VH.rollingNumber;
    if (roll && roll.setText) roll.setText(el, year);
    else el.textContent = year;
  }

  /** Contenu du panneau pour une date (la photo est sur la carte). */
  function panelHtml(e) {
    if (!e) return '';
    const language = lang();
    const ref = e.airplane;
    const link = ref
      ? `<a class="conflict-event-plane" href="${esc(detailsPath(ref.id, ref.name))}"><i class="fas fa-plane" aria-hidden="true"></i> ${esc(ref.name)}</a>`
      : '';
    return `<div class="conflict-date-text">
        <time class="conflict-date-full" datetime="${esc(e.date)}">${esc(formatEventDate(e.date, e.precision, language, true))}</time>
        <h3 class="conflict-date-title">${inline(e.title)}</h3>
        ${e.body ? `<p class="conflict-date-body">${inline(e.body)}</p>` : ''}
        ${link}
      </div>`;
  }

  /**
   * Rend les cartes et le panneau, branche le carrousel, puis (une seule
   * fois) clavier, clics et glissements sur le panneau. Un nouveau rendu (changement de langue) garde la
   * date choisie.
   */
  function render(war, doc) {
    const d = doc || document;
    const section = d.getElementById('dates-cles');
    const strip = d.getElementById('conflict-events');
    const panel = d.getElementById('conflict-event-panel');
    const content = d.getElementById('conflict-event-content');
    if (!section || !strip || !panel || !content) return false;
    if (strip._vhCarousel) {
      strip._vhCarousel.destroy();
      strip._vhCarousel = null;
    }
    const events = (war && war.events) || [];
    section.classList.toggle('hidden', !events.length);
    if (!events.length) {
      strip.innerHTML = '';
      content.innerHTML = '';
      return false;
    }

    const count = d.getElementById('conflict-event-count');
    const pager = Array.from(panel.querySelectorAll('[data-dir]'));
    const state = { events, airplanes: war.airplanes || [] };
    const previous = Number(strip.dataset.index);
    let current = Number.isInteger(previous) && previous < events.length ? previous : 0;

    function select(index, { focus = false, animate = true } = {}) {
      const next = Math.max(0, Math.min(state.events.length - 1, index));
      const changed = next !== current;
      current = next;
      strip.dataset.index = String(next);
      const tabs = Array.from(strip.querySelectorAll('[role="tab"]'));
      tabs.forEach((tab, i) => {
        tab.setAttribute('aria-selected', String(i === next));
        tab.tabIndex = i === next ? 0 : -1;
      });
      panel.setAttribute('aria-labelledby', `conflict-date-tab-${next}`);
      content.innerHTML = panelHtml(state.events[next]);
      if (count) count.textContent = `${next + 1} / ${state.events.length}`;
      pager.forEach((b) => {
        b.disabled = Number(b.dataset.dir) < 0 ? next === 0 : next === state.events.length - 1;
      });
      if (changed && animate) {
        content.classList.remove('is-entering');
        void content.offsetWidth; // relance l'animation d'entrée
        content.classList.add('is-entering');
      }
      if (strip._vhCarousel) strip._vhCarousel.goTo(next, { animate });
      if (focus && tabs[next]) tabs[next].focus({ preventScroll: true });
    }

    strip.innerHTML = cardsHtml(events, current, state.airplanes);
    strip._vhDates = { select: (i, o) => select(i, o), get current() { return current; }, get length() { return state.events.length; } };
    const carousel = root.VH.conflicts.carousel;
    const stage = d.getElementById('conflict-tl');
    const yearEl = d.getElementById('conflict-tl-year');
    if (carousel && stage) {
      strip._vhCarousel = carousel.create({
        stage,
        track: strip,
        ruler: d.getElementById('conflict-tl-ruler'),
        cables: d.getElementById('conflict-tl-cables'),
        anchor: yearEl,
        count: events.length,
        start: current,
        onSelect: (i) => strip._vhDates.select(i),
        onCenter: (i) => showYear(yearEl, state.events[i]),
      });
    } else {
      showYear(yearEl, events[current]);
    }
    select(current, { animate: false });

    if (strip.dataset.bound !== '1') {
      strip.dataset.bound = '1';
      const api = () => strip._vhDates;
      strip.addEventListener('click', (ev) => {
        const tab = ev.target.closest('[role="tab"]');
        if (tab) api().select(Number(tab.dataset.index));
      });
      strip.addEventListener('keydown', (ev) => {
        const keys = { ArrowRight: 1, ArrowLeft: -1 };
        const { current: cur, length } = api();
        let target = null;
        if (ev.key in keys) target = cur + keys[ev.key];
        else if (ev.key === 'Home') target = 0;
        else if (ev.key === 'End') target = length - 1;
        if (target === null) return;
        ev.preventDefault();
        api().select(target, { focus: true });
      });
      pager.forEach((b) => b.addEventListener('click', () => {
        api().select(api().current + Number(b.dataset.dir));
      }));
      let start = null;
      panel.addEventListener('touchstart', (ev) => {
        const p = ev.touches && ev.touches[0];
        start = p ? { x: p.clientX, y: p.clientY } : null;
      }, { passive: true });
      panel.addEventListener('touchend', (ev) => {
        const p = ev.changedTouches && ev.changedTouches[0];
        if (!start || !p) return;
        const dx = p.clientX - start.x;
        const dy = p.clientY - start.y;
        start = null;
        if (Math.abs(dx) >= SWIPE_MIN && Math.abs(dx) > Math.abs(dy) * 1.5) {
          api().select(api().current + (dx < 0 ? 1 : -1));
        }
      }, { passive: true });
    }
    return true;
  }

  root.VH.conflicts.dates = { formatEventDate, dateParts, cardsHtml, panelHtml, render };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = root.VH.conflicts.dates;
  }
})();
