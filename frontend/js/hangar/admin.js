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
        state.generations.map(g => `<option value="${g}">${g}e Génération</option>`).join('');
    }
    if (typeSelect) {
      typeSelect.innerHTML = placeholder +
        state.types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
    }
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

      const formData = {
        name: document.getElementById('aircraft-name').value,
        complete_name: document.getElementById('aircraft-complete-name').value,
        little_description: document.getElementById('aircraft-little-description').value,
        image_url: document.getElementById('aircraft-image-url').value,
        description: document.getElementById('aircraft-description').value,
        country_id: parseInt(document.getElementById('aircraft-country').value),
        id_manufacturer: parseInt(document.getElementById('aircraft-manufacturer').value) || null,
        id_generation: parseInt(document.getElementById('aircraft-generation').value),
        type: parseInt(document.getElementById('aircraft-type').value),
        status: document.getElementById('aircraft-status').value,
        date_concept: document.getElementById('aircraft-date-concept').value || null,
        date_first_fly: document.getElementById('aircraft-date-first-fly').value || null,
        date_operationel: document.getElementById('aircraft-date-operational').value || null,
        max_speed: parseFloat(document.getElementById('aircraft-max-speed').value) || null,
        max_range: parseFloat(document.getElementById('aircraft-max-range').value) || null,
        weight: parseFloat(document.getElementById('aircraft-weight').value) || null
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
