/* Frise — angles de lecture : « par nation » et « par type ».
 * Deux <select> natifs (améliorés par VH.customSelect comme partout), reflétés
 * dans l'URL (?nation=France&type=Chasseur) pour qu'une frise filtrée se
 * partage. Les autres paramètres (?lang=en) et l'ancre sont conservés. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  function util() { return VH.timeline.util; }

  function fillSelect(select, options, value) {
    if (!select) return;
    const first = select.options[0];
    select.innerHTML = '';
    if (first) select.appendChild(first);
    options.forEach(o => {
      const opt = document.createElement('option');
      opt.value = o.value;
      opt.textContent = `${o.label} (${o.count})`;
      select.appendChild(opt);
    });
    select.value = value || '';
  }

  /* Filtre enrichi des libellés affichés (messages « aucun appareil »). */
  function withLabels(lens, options) {
    const label = (list, v) => (list.find(o => o.value === v) || {}).label || null;
    return {
      nation: lens.nation || null,
      type: lens.type || null,
      nationLabel: lens.nation ? label(options.nations, lens.nation) : null,
      typeLabel: lens.type ? label(options.types, lens.type) : null,
    };
  }

  /* URL courante avec le filtre ; ?lang= et l'ancre sont conservés. */
  function urlFor(lens, loc = window.location) {
    const p = new URLSearchParams(loc.search);
    p.delete('nation');
    p.delete('type');
    if (lens.nation) p.set('nation', lens.nation);
    if (lens.type) p.set('type', lens.type);
    const qs = p.toString();
    return loc.pathname + (qs ? `?${qs}` : '') + (loc.hash || '');
  }

  function syncUrl(lens) {
    try { history.replaceState(null, '', urlFor(lens)); } catch { /* ignore */ }
  }

  function syncReset(lens) {
    const reset = document.getElementById('tl-lens-reset');
    if (reset) reset.hidden = !VH.timeline.data.isLensActive(lens);
    const bar = document.getElementById('tl-bar');
    if (bar) bar.classList.toggle('is-filtered', VH.timeline.data.isLensActive(lens));
  }

  function bindToggle() {
    const toggle = document.getElementById('tl-lens-toggle');
    const bar = document.getElementById('tl-bar');
    if (!toggle || !bar || toggle.dataset.bound) return;
    toggle.dataset.bound = '1';
    toggle.addEventListener('click', () => {
      const open = toggle.getAttribute('aria-expanded') !== 'true';
      toggle.setAttribute('aria-expanded', String(open));
      bar.classList.toggle('lens-open', open);
    });
  }

  /**
   * @param {{ nations: object[], types: object[] }} options - data.lensOptions
   * @param {{ nation: string|null, type: string|null }} lens - filtre initial
   * @param {(lens: object) => void} onChange - appelé avec le filtre enrichi
   */
  function init(options, lens, onChange) {
    const nation = document.getElementById('tl-lens-nation');
    const type = document.getElementById('tl-lens-type');
    const reset = document.getElementById('tl-lens-reset');
    fillSelect(nation, options.nations, lens.nation);
    fillSelect(type, options.types, lens.type);
    syncReset(lens);
    bindToggle();

    const emit = () => {
      const next = withLabels({ nation: nation && nation.value, type: type && type.value }, options);
      syncReset(next);
      syncUrl(next);
      onChange(next);
    };
    if (nation) nation.addEventListener('change', emit);
    if (type) type.addEventListener('change', emit);
    if (reset) {
      reset.addEventListener('click', () => {
        if (nation) nation.value = '';
        if (type) type.value = '';
        emit();
        const focus = nation && (nation.closest('.cselect')?.querySelector('[role="combobox"]') || nation);
        if (focus && typeof focus.focus === 'function') focus.focus();
      });
    }
    return withLabels(lens, options);
  }

  /* Résumé lisible du filtre, annoncé aux lecteurs d'écran. */
  function announce(lens, count) {
    const live = document.getElementById('tl-lens-status');
    if (!live) return;
    if (!VH.timeline.data.isLensActive(lens)) {
      live.textContent = '';
      return;
    }
    const what = [lens.nationLabel, lens.typeLabel].filter(Boolean).join(' · ');
    live.textContent = util().t('timeline.lens_status', `${what} : ${count} appareils`,
      { lens: what, n: String(count) });
  }

  const api = { fillSelect, withLabels, urlFor, syncUrl, init, announce };
  window.VH.timeline.lens = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
