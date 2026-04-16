/* Édition + suppression fiche (admin/editor). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function setup(state) {
    const editBtn = document.getElementById('edit-btn');
    const deleteBtn = document.getElementById('delete-btn');
    const editModal = document.getElementById('edit-modal');
    const editForm = document.getElementById('edit-form');
    const cancelEditBtn = document.getElementById('cancel-edit-btn');
    const modalClose = document.querySelector('.modal-close');

    // Liste des couples (id dom, prop du modèle) pour éviter la duplication
    // texte/nombre : map des champs simples (value attr). Les dates et selects
    // sont gérés séparément.
    const FIELD_MAP = [
      // base
      ['edit-name', 'name'], ['edit-complete-name', 'complete_name'],
      ['edit-little-description', 'little_description'], ['edit-image-url', 'image_url'],
      ['edit-description', 'description'], ['edit-status', 'status'],
      ['edit-max-speed', 'max_speed'], ['edit-max-range', 'max_range'], ['edit-weight', 'weight'],
      // strate 1
      ['edit-length', 'length'], ['edit-wingspan', 'wingspan'], ['edit-height', 'height'],
      ['edit-wing-area', 'wing_area'], ['edit-empty-weight', 'empty_weight'], ['edit-mtow', 'mtow'],
      ['edit-service-ceiling', 'service_ceiling'], ['edit-climb-rate', 'climb_rate'],
      ['edit-g-limit-pos', 'g_limit_pos'], ['edit-g-limit-neg', 'g_limit_neg'],
      ['edit-combat-radius', 'combat_radius'], ['edit-crew', 'crew'],
      // strate 2
      ['edit-engine-name', 'engine_name'], ['edit-engine-count', 'engine_count'],
      ['edit-engine-type', 'engine_type'], ['edit-thrust-dry', 'thrust_dry'], ['edit-thrust-wet', 'thrust_wet'],
      // strate 3
      ['edit-production-start', 'production_start'], ['edit-production-end', 'production_end'],
      ['edit-units-built', 'units_built'], ['edit-unit-cost-usd', 'unit_cost_usd'],
      ['edit-unit-cost-year', 'unit_cost_year'], ['edit-operators-count', 'operators_count'],
      ['edit-variants', 'variants'],
      // strate 4
      ['edit-nickname', 'nickname'],
      // strate 6
      ['edit-wikipedia-fr', 'wikipedia_fr'], ['edit-wikipedia-en', 'wikipedia_en'],
      ['edit-youtube-showcase', 'youtube_showcase'], ['edit-manufacturer-page', 'manufacturer_page'],
    ];

    function openEditModal() {
      if (!state.aircraftData) return;
      const a = state.aircraftData;

      // Champs simples via FIELD_MAP
      for (const [elId, key] of FIELD_MAP) {
        const el = document.getElementById(elId);
        if (el) el.value = a[key] ?? '';
      }
      // Dates (ISO → YYYY-MM-DD)
      document.getElementById('edit-date-concept').value = a.date_concept?.split('T')[0] || '';
      document.getElementById('edit-date-first-fly').value = a.date_first_fly?.split('T')[0] || '';
      document.getElementById('edit-date-operationel').value = a.date_operationel?.split('T')[0] || '';
      // Select enum
      document.getElementById('edit-stealth-level').value = a.stealth_level || '';

      loadFormSelects().then(() => {
        document.getElementById('edit-country-id').value = a.country_id || '';
        document.getElementById('edit-manufacturer-id').value = a.id_manufacturer || '';
        document.getElementById('edit-generation-id').value = a.id_generation || '';
        document.getElementById('edit-type').value = a.type || '';
        document.getElementById('edit-predecessor-id').value = a.predecessor_id || '';
        document.getElementById('edit-successor-id').value = a.successor_id || '';
        document.getElementById('edit-rival-id').value = a.rival_id || '';
      });

      editModal.classList.add('show');
      document.body.style.overflow = 'hidden';
      _focusTrap = trapFocus(editModal, { onEscape: closeEditModal });
    }

    let _focusTrap = null;
    let _previousFocus = null;
    function closeEditModal() {
      _focusTrap?.destroy();
      _focusTrap = null;
      editModal.classList.remove('show');
      document.body.style.overflow = '';
      _previousFocus?.focus();
    }
    VH.details.admin.closeEditModal = closeEditModal;

    async function loadFormSelects() {
      try {
        const [referentialsRes, airplanesRes] = await Promise.all([
          auth.fetchWithTimeout('/api/referentials'),
          auth.fetchWithTimeout('/api/airplanes?limit=500'),
        ]);
        if (!referentialsRes.ok) throw new Error('Erreur chargement référentiels');
        const { countries, manufacturers, types } = await referentialsRes.json();
        const placeholder = `<option value="">${i18n.t('details.select')}</option>`;

        document.getElementById('edit-country-id').innerHTML = placeholder +
          countries.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');
        document.getElementById('edit-manufacturer-id').innerHTML = placeholder +
          manufacturers.map(m => `<option value="${m.id}">${escapeHtml(m.name)}</option>`).join('');
        document.getElementById('edit-type').innerHTML = placeholder +
          types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
        document.getElementById('edit-generation-id').innerHTML = placeholder +
          [1, 2, 3, 4, 5].map(g => `<option value="${g}">${g}${i18n.currentLang === 'en' ? (['st','nd','rd'][g-1]||'th') + ' Generation' : 'e Génération'}</option>`).join('');

        // Liste des avions pour predecessor/successor/rival (exclut l'avion courant)
        if (airplanesRes.ok) {
          const payload = await airplanesRes.json();
          const list = Array.isArray(payload) ? payload : (payload.data || []);
          const options = [`<option value="">—</option>`].concat(
            list.filter(ap => Number(ap.id) !== Number(state.aircraftId))
                .sort((a, b) => (a.name || '').localeCompare(b.name || ''))
                .map(ap => `<option value="${ap.id}">${escapeHtml(ap.name || '')}</option>`)
          ).join('');
          document.getElementById('edit-predecessor-id').innerHTML = options;
          document.getElementById('edit-successor-id').innerHTML = options;
          document.getElementById('edit-rival-id').innerHTML = options;
        }
      } catch (_) { /* silencieux */ }
    }

    editBtn?.addEventListener('click', () => { _previousFocus = document.activeElement; openEditModal(); });
    [cancelEditBtn, modalClose].forEach(btn => btn?.addEventListener('click', closeEditModal));
    editModal?.addEventListener('click', (e) => {
      if (e.target === editModal || e.target.classList.contains('modal-backdrop')) closeEditModal();
    });

    editForm?.addEventListener('submit', async (e) => {
      e.preventDefault();
      if (!auth.getToken() || (state.userRole !== 1 && state.userRole !== 2)) {
        showToast(i18n.t('common.unauthorized'), 'error');
        return;
      }
      const num = (id) => {
        const v = document.getElementById(id).value;
        if (v === '' || v == null) return null;
        const n = Number(v);
        return isNaN(n) ? null : n;
      };
      const str = (id) => {
        const v = document.getElementById(id).value;
        return v === '' ? null : v;
      };
      const intOrNull = (id) => {
        const v = document.getElementById(id).value;
        if (v === '' || v == null) return null;
        const n = parseInt(v, 10);
        return isNaN(n) ? null : n;
      };

      const formData = {
        // base
        name: str('edit-name') || '',
        complete_name: str('edit-complete-name'),
        little_description: str('edit-little-description'),
        image_url: str('edit-image-url'),
        description: str('edit-description'),
        country_id: intOrNull('edit-country-id'),
        id_manufacturer: intOrNull('edit-manufacturer-id'),
        id_generation: intOrNull('edit-generation-id'),
        type: intOrNull('edit-type'),
        status: str('edit-status'),
        date_concept: str('edit-date-concept'),
        date_first_fly: str('edit-date-first-fly'),
        date_operationel: str('edit-date-operationel'),
        max_speed: num('edit-max-speed'),
        max_range: num('edit-max-range'),
        weight: num('edit-weight'),
        // strate 1
        length: num('edit-length'),
        wingspan: num('edit-wingspan'),
        height: num('edit-height'),
        wing_area: num('edit-wing-area'),
        empty_weight: num('edit-empty-weight'),
        mtow: num('edit-mtow'),
        service_ceiling: intOrNull('edit-service-ceiling'),
        climb_rate: num('edit-climb-rate'),
        g_limit_pos: num('edit-g-limit-pos'),
        g_limit_neg: num('edit-g-limit-neg'),
        combat_radius: num('edit-combat-radius'),
        crew: intOrNull('edit-crew'),
        // strate 2
        engine_name: str('edit-engine-name'),
        engine_count: intOrNull('edit-engine-count'),
        engine_type: str('edit-engine-type'),
        thrust_dry: num('edit-thrust-dry'),
        thrust_wet: num('edit-thrust-wet'),
        // strate 3
        production_start: intOrNull('edit-production-start'),
        production_end: intOrNull('edit-production-end'),
        units_built: intOrNull('edit-units-built'),
        unit_cost_usd: intOrNull('edit-unit-cost-usd'),
        unit_cost_year: intOrNull('edit-unit-cost-year'),
        operators_count: intOrNull('edit-operators-count'),
        variants: str('edit-variants'),
        // strate 4
        stealth_level: str('edit-stealth-level'),
        nickname: str('edit-nickname'),
        predecessor_id: intOrNull('edit-predecessor-id'),
        successor_id: intOrNull('edit-successor-id'),
        rival_id: intOrNull('edit-rival-id'),
        // strate 6
        wikipedia_fr: str('edit-wikipedia-fr'),
        wikipedia_en: str('edit-wikipedia-en'),
        youtube_showcase: str('edit-youtube-showcase'),
        manufacturer_page: str('edit-manufacturer-page'),
      };

      try {
        const response = await auth.authFetch(`/api/airplanes/${state.aircraftId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(formData)
        });
        if (!response.ok) throw new Error(i18n.t('common.update_error'));
        showToast(i18n.t('common.saved'), 'success');
        closeEditModal();
        await VH.details.data.loadAircraftDetails(state);
      } catch (error) {
        showToast(error.message || i18n.t('common.update_error'), 'error');
      }
    });

    deleteBtn?.addEventListener('click', async () => {
      if (!confirm(i18n.t('common.confirm_delete') + ` "${state.aircraftData.name}" ?`)) return;
      try {
        const response = await auth.authFetch(`/api/airplanes/${state.aircraftId}`, { method: 'DELETE' });
        if (!response.ok) throw new Error(i18n.t('common.delete_error'));
        showToast(i18n.t('common.deleted'), 'success');
        setTimeout(() => window.location.href = '/hangar', 1500);
      } catch (error) {
        showToast(error.message || i18n.t('common.delete_error'), 'error');
      }
    });
  }

  VH.details.admin = { setup, closeEditModal: () => {} };
})();
