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

    function openEditModal() {
      if (!state.aircraftData) return;
      const a = state.aircraftData;
      document.getElementById('edit-name').value = a.name || '';
      document.getElementById('edit-complete-name').value = a.complete_name || '';
      document.getElementById('edit-little-description').value = a.little_description || '';
      document.getElementById('edit-image-url').value = a.image_url || '';
      document.getElementById('edit-description').value = a.description || '';
      document.getElementById('edit-status').value = a.status || '';
      document.getElementById('edit-date-concept').value = a.date_concept?.split('T')[0] || '';
      document.getElementById('edit-date-first-fly').value = a.date_first_fly?.split('T')[0] || '';
      document.getElementById('edit-date-operationel').value = a.date_operationel?.split('T')[0] || '';
      document.getElementById('edit-max-speed').value = a.max_speed || '';
      document.getElementById('edit-max-range').value = a.max_range || '';
      document.getElementById('edit-weight').value = a.weight || '';

      loadFormSelects().then(() => {
        document.getElementById('edit-country-id').value = a.country_id || '';
        document.getElementById('edit-manufacturer-id').value = a.id_manufacturer || '';
        document.getElementById('edit-generation-id').value = a.id_generation || '';
        document.getElementById('edit-type').value = a.type || '';
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
        const response = await auth.fetchWithTimeout('/api/referentials');
        if (!response.ok) throw new Error('Erreur chargement référentiels');
        const { countries, manufacturers, types } = await response.json();
        const placeholder = `<option value="">${i18n.t('details.select')}</option>`;

        document.getElementById('edit-country-id').innerHTML = placeholder +
          countries.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');
        document.getElementById('edit-manufacturer-id').innerHTML = placeholder +
          manufacturers.map(m => `<option value="${m.id}">${escapeHtml(m.name)}</option>`).join('');
        document.getElementById('edit-type').innerHTML = placeholder +
          types.map(t => `<option value="${t.id}">${escapeHtml(t.name)}</option>`).join('');
        document.getElementById('edit-generation-id').innerHTML = placeholder +
          [1, 2, 3, 4, 5].map(g => `<option value="${g}">${g}${i18n.currentLang === 'en' ? (['st','nd','rd'][g-1]||'th') + ' Generation' : 'e Génération'}</option>`).join('');
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
      const formData = {
        name: document.getElementById('edit-name').value,
        complete_name: document.getElementById('edit-complete-name').value,
        little_description: document.getElementById('edit-little-description').value,
        image_url: document.getElementById('edit-image-url').value,
        description: document.getElementById('edit-description').value,
        country_id: parseInt(document.getElementById('edit-country-id').value) || null,
        id_manufacturer: parseInt(document.getElementById('edit-manufacturer-id').value) || null,
        id_generation: parseInt(document.getElementById('edit-generation-id').value) || null,
        type: parseInt(document.getElementById('edit-type').value) || null,
        status: document.getElementById('edit-status').value,
        date_concept: document.getElementById('edit-date-concept').value || null,
        date_first_fly: document.getElementById('edit-date-first-fly').value || null,
        date_operationel: document.getElementById('edit-date-operationel').value || null,
        max_speed: parseFloat(document.getElementById('edit-max-speed').value) || null,
        max_range: parseFloat(document.getElementById('edit-max-range').value) || null,
        weight: parseFloat(document.getElementById('edit-weight').value) || null
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
