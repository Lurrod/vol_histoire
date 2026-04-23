/* Formulaire admin : populate selects + modal + submit create. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function populateFormSelects(state) {
    const countrySelect = document.getElementById('aircraft-country');
    const manufacturerSelect = document.getElementById('aircraft-manufacturer');
    const generationSelect = document.getElementById('aircraft-generation');
    const typeSelect = document.getElementById('aircraft-type');
    const placeholder = `<option value="">${i18n.t('hangar.select')}</option>`;

    if (countrySelect) {
      countrySelect.innerHTML = placeholder +
        state.countries.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');
    }
    if (manufacturerSelect) {
      manufacturerSelect.innerHTML = placeholder +
        state.manufacturers.map(m => `<option value="${m.id}">${escapeHtml(m.name)}${m.country_name ? ` (${escapeHtml(m.country_name)})` : ''}</option>`).join('');
    }
    if (generationSelect) {
      generationSelect.innerHTML = placeholder +
        state.generations.map(g => `<option value="${escapeHtml(String(g))}">${escapeHtml(String(g))}e Génération</option>`).join('');
    }
    if (typeSelect) {
      typeSelect.innerHTML = placeholder +
        state.types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
    }
  }

  // Charge la liste complète d'avions pour les selects predecessor / successor / rival.
  async function populateRelationSelects() {
    const ids = ['aircraft-predecessor-id', 'aircraft-successor-id', 'aircraft-rival-id'];
    if (!ids.some(id => document.getElementById(id))) return;
    try {
      const res = await auth.fetchWithTimeout('/api/airplanes?limit=500');
      if (!res.ok) return;
      const payload = await res.json();
      const list = Array.isArray(payload) ? payload : (payload.data || []);
      const options = ['<option value="">—</option>'].concat(
        list
          .sort((a, b) => (a.name || '').localeCompare(b.name || ''))
          .map(ap => `<option value="${ap.id}">${escapeHtml(ap.name || '')}</option>`)
      ).join('');
      ids.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.innerHTML = options;
      });
    } catch { /* silencieux */ }
  }

  function setupAdminModal(state) {
    const modal = document.getElementById('aircraft-modal');
    const modalForm = document.getElementById('aircraft-form');
    const addBtn = document.getElementById('add-airplane-btn');
    const cancelBtn = document.getElementById('cancel-btn');
    const modalClose = document.querySelector('.modal-close');

    let _focusTrap = null;
    let _previousFocus = null;
    function openModal() {
      _previousFocus = document.activeElement;
      modal?.classList.add('show');
      document.body.style.overflow = 'hidden';
      _focusTrap = trapFocus(modal, { onEscape: closeModal });
      populateRelationSelects();
    }
    function closeModal() {
      _focusTrap?.destroy();
      _focusTrap = null;
      modal?.classList.remove('show');
      document.body.style.overflow = '';
      modalForm?.reset();
      _previousFocus?.focus();
    }

    addBtn?.addEventListener('click', openModal);
    [cancelBtn, modalClose].forEach(btn => btn?.addEventListener('click', closeModal));
    modal?.addEventListener('click', (e) => {
      if (e.target === modal || e.target.classList.contains('modal-backdrop')) closeModal();
    });

    modalForm?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const payload = auth.getPayload();
      if (!payload) { showToast(i18n.t('common.unauthorized'), 'error'); return; }
      const userRole = Number(payload.role);
      if (userRole !== 1 && userRole !== 2) { showToast(i18n.t('common.unauthorized'), 'error'); return; }

      const num = (id) => {
        const el = document.getElementById(id);
        if (!el) return null;
        const v = el.value;
        if (v === '' || v == null) return null;
        const n = Number(v);
        return isNaN(n) ? null : n;
      };
      const intOrNull = (id) => {
        const el = document.getElementById(id);
        if (!el) return null;
        const v = el.value;
        if (v === '' || v == null) return null;
        const n = parseInt(v, 10);
        return isNaN(n) ? null : n;
      };
      const str = (id) => {
        const el = document.getElementById(id);
        if (!el) return null;
        const v = el.value;
        return v === '' ? null : v;
      };

      const formData = {
        // base
        name: str('aircraft-name') || '',
        complete_name: str('aircraft-complete-name'),
        little_description: str('aircraft-little-description'),
        image_url: str('aircraft-image-url'),
        description: str('aircraft-description'),
        country_id: intOrNull('aircraft-country'),
        id_manufacturer: intOrNull('aircraft-manufacturer'),
        id_generation: intOrNull('aircraft-generation'),
        type: intOrNull('aircraft-type'),
        status: str('aircraft-status'),
        date_concept: str('aircraft-date-concept'),
        date_first_fly: str('aircraft-date-first-fly'),
        date_operationel: str('aircraft-date-operational'),
        max_speed: num('aircraft-max-speed'),
        max_range: num('aircraft-max-range'),
        weight: num('aircraft-weight'),
        // strate 1
        length: num('aircraft-length'),
        wingspan: num('aircraft-wingspan'),
        height: num('aircraft-height'),
        wing_area: num('aircraft-wing-area'),
        empty_weight: num('aircraft-empty-weight'),
        mtow: num('aircraft-mtow'),
        service_ceiling: intOrNull('aircraft-service-ceiling'),
        climb_rate: num('aircraft-climb-rate'),
        g_limit_pos: num('aircraft-g-limit-pos'),
        g_limit_neg: num('aircraft-g-limit-neg'),
        combat_radius: num('aircraft-combat-radius'),
        crew: intOrNull('aircraft-crew'),
        // strate 2
        engine_name: str('aircraft-engine-name'),
        engine_count: intOrNull('aircraft-engine-count'),
        engine_type: str('aircraft-engine-type'),
        thrust_dry: num('aircraft-thrust-dry'),
        thrust_wet: num('aircraft-thrust-wet'),
        // strate 3
        production_start: intOrNull('aircraft-production-start'),
        production_end: intOrNull('aircraft-production-end'),
        units_built: intOrNull('aircraft-units-built'),
        unit_cost_usd: intOrNull('aircraft-unit-cost-usd'),
        unit_cost_year: intOrNull('aircraft-unit-cost-year'),
        operators_count: intOrNull('aircraft-operators-count'),
        variants: str('aircraft-variants'),
        // strate 4
        stealth_level: str('aircraft-stealth-level'),
        nickname: str('aircraft-nickname'),
        predecessor_id: intOrNull('aircraft-predecessor-id'),
        successor_id: intOrNull('aircraft-successor-id'),
        rival_id: intOrNull('aircraft-rival-id'),
        // strate 6
        wikipedia_fr: str('aircraft-wikipedia-fr'),
        wikipedia_en: str('aircraft-wikipedia-en'),
        youtube_showcase: str('aircraft-youtube-showcase'),
        manufacturer_page: str('aircraft-manufacturer-page'),
      };

      try {
        const response = await auth.authFetch('/api/airplanes', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(formData)
        });
        if (!response.ok) throw new Error(i18n.t('common.create_error'));
        showToast(i18n.t('common.added'), 'success');
        closeModal();
        VH.hangar.data.loadAircraft(state);
      } catch (error) {
        showToast(error.message || i18n.t('common.create_error'), 'error');
      }
    });

    VH.hangar.admin.closeModal = closeModal;
  }

  VH.hangar.admin = { populateFormSelects, setupAdminModal, closeModal: () => {} };
})();
