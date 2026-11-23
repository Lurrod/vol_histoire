/* Dates clés d'un conflit (2026-11-23) : un bandeau de dates qui servent
 * d'onglets et, dessous, un grand panneau qui raconte la date choisie
 * (date en toutes lettres, titre, récit, photo et lien de l'appareil lié).
 *
 * Accessibilité : motif « onglets » de l'APG (role tablist / tab / tabpanel,
 * tabindex itinérant, flèches gauche/droite, Début/Fin). Les boutons du
 * panneau (précédente / suivante) changent la date sans déplacer le focus.
 * Au doigt, un glissement horizontal sur le panneau fait de même.
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

  /** Date d'un onglet : l'en-tête (« 17 janv. », « août », rien) et l'année. */
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

  /** Bandeau : un onglet par date ; seul l'onglet choisi est dans l'ordre de tabulation. */
  function tabsHtml(events, selected) {
    const language = lang();
    return (events || []).map((e, i) => {
      const { lead, year } = dateParts(e.date, e.precision, language);
      const on = i === selected;
      return `<button type="button" class="conflict-date-tab" role="tab" id="conflict-date-tab-${i}"`
        + ` aria-controls="conflict-event-panel" aria-selected="${on}" tabindex="${on ? 0 : -1}" data-index="${i}">`
        + (lead ? `<span class="conflict-date-lead">${esc(lead)}</span> ` : '')
        + `<span class="conflict-date-year">${esc(year)}</span>`
        + `<span class="sr-only"> : ${esc(e.title)}</span></button>`;
    }).join('');
  }

  function photoHtml(plane, href) {
    const pic = root.VH.shared && root.VH.shared.picture;
    if (!plane || !plane.image_url) return '';
    const img = pic
      ? pic.pictureHtml(plane.image_url, { alt: '', width: 480, height: 320, loading: 'lazy', decoding: 'async' })
      : `<img src="${esc(plane.image_url)}" alt="" width="480" height="320" loading="lazy" decoding="async">`;
    return `<a class="conflict-date-photo" href="${href}" tabindex="-1" aria-hidden="true">${img}</a>`;
  }

  /** Contenu du panneau pour une date ; la photo vient de la fiche liée au conflit. */
  function panelHtml(e, airplanes) {
    if (!e) return '';
    const language = lang();
    const ref = e.airplane;
    const plane = ref ? (airplanes || []).find((a) => a.id === ref.id) : null;
    const href = ref ? esc(detailsPath(ref.id, ref.name)) : '';
    const link = ref
      ? `<a class="conflict-event-plane" href="${href}"><i class="fas fa-plane" aria-hidden="true"></i> ${esc(ref.name)}</a>`
      : '';
    const photo = photoHtml(plane, href);
    return `<div class="conflict-date-text">
        <time class="conflict-date-full" datetime="${esc(e.date)}">${esc(formatEventDate(e.date, e.precision, language, true))}</time>
        <h3 class="conflict-date-title">${inline(e.title)}</h3>
        ${e.body ? `<p class="conflict-date-body">${inline(e.body)}</p>` : ''}
        ${link}
      </div>${photo}`;
  }

  function prefersReducedMotion(win) {
    return Boolean(win.matchMedia && win.matchMedia('(prefers-reduced-motion: reduce)').matches);
  }

  /** Amène l'onglet choisi au centre du bandeau, sans faire défiler la page. */
  function revealTab(strip, tab, win) {
    if (!tab) return;
    const left = tab.offsetLeft - (strip.clientWidth - tab.offsetWidth) / 2;
    if (typeof strip.scrollTo === 'function') {
      strip.scrollTo({ left: Math.max(0, left), behavior: prefersReducedMotion(win) ? 'auto' : 'smooth' });
    } else {
      strip.scrollLeft = Math.max(0, left);
    }
  }

  /**
   * Rend le bandeau et le panneau, puis branche (une seule fois) clavier,
   * clics et glissements. Un nouveau rendu (changement de langue) garde la
   * date choisie.
   */
  function render(war, doc) {
    const d = doc || document;
    const section = d.getElementById('dates-cles');
    const strip = d.getElementById('conflict-events');
    const panel = d.getElementById('conflict-event-panel');
    const content = d.getElementById('conflict-event-content');
    if (!section || !strip || !panel || !content) return false;
    const events = (war && war.events) || [];
    section.classList.toggle('hidden', !events.length);
    if (!events.length) {
      strip.innerHTML = '';
      content.innerHTML = '';
      return false;
    }

    const win = d.defaultView || root;
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
      content.innerHTML = panelHtml(state.events[next], state.airplanes);
      if (count) count.textContent = `${next + 1} / ${state.events.length}`;
      pager.forEach((b) => {
        b.disabled = Number(b.dataset.dir) < 0 ? next === 0 : next === state.events.length - 1;
      });
      if (changed && animate) {
        content.classList.remove('is-entering');
        void content.offsetWidth; // relance l'animation d'entrée
        content.classList.add('is-entering');
      }
      revealTab(strip, tabs[next], win);
      if (focus && tabs[next]) tabs[next].focus({ preventScroll: true });
    }

    strip.innerHTML = tabsHtml(events, current);
    strip._vhDates = { select: (i, o) => select(i, o), get current() { return current; }, get length() { return state.events.length; } };
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

  root.VH.conflicts.dates = { formatEventDate, dateParts, tabsHtml, panelHtml, render };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = root.VH.conflicts.dates;
  }
})();
