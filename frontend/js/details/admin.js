/* Édition + suppression fiche (admin/editor).
 * Le formulaire lui-même (champs, listes, remplissage, lecture) est
 * VH.shared.airplaneForm, commun avec la création au hangar (ARCH-007). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function setup(state) {
    const editBtn = document.getElementById('edit-btn');
    const deleteBtn = document.getElementById('delete-btn');
    const editModal = document.getElementById('edit-modal');
    const editForm = document.getElementById('edit-form');
    const fieldsRoot = document.getElementById('edit-form-fields');
    const cancelEditBtn = document.getElementById('cancel-edit-btn');
    const modalClose = document.querySelector('.modal-close');
    let _focusTrap = null;
    let _previousFocus = null;
    // Construit à la première ouverture : i18n est alors chargé.
    let _form = null;

    const submitBtn = editForm?.querySelector('[type="submit"]') || document.querySelector('button[form="edit-form"]');
    // Vrai seulement quand la fiche ET toutes les listes sont chargées : tant
    // qu'une liste est incomplète, enregistrer réécrirait ses clés à NULL.
    let _formReady = false;
    // Une réouverture rapide ne doit pas être remplie par un chargement ancien.
    let _openTicket = 0;

    function setFormReady(ready) {
      _formReady = ready;
      if (submitBtn) submitBtn.disabled = !ready;
    }

    function ensureForm() {
      if (!_form) _form = VH.shared.airplaneForm.mount(fieldsRoot, { prefix: 'edit' });
      return _form;
    }

    /* Fiche dans une langue donnée. Le formulaire se remplit avec la fiche
     * française : l'API traduit `name`, `description`, `status`… quand
     * l'interface est en anglais, et renvoyer ces valeurs écrirait de
     * l'anglais (ou « Translation needed ») dans les colonnes françaises.
     * La fiche anglaise fournit les colonnes `_en` (engine_type_en,
     * variants_en), que la réponse française ne contient pas. */
    async function loadRecord(lang) {
      if ((i18n.currentLang || 'fr') === lang) return state.aircraftData;
      const res = await auth.fetchWithTimeout(`/api/airplanes/${state.aircraftId}?lang=${lang}`);
      if (!res.ok) throw new Error(`Chargement de la fiche impossible (HTTP ${res.status})`);
      return res.json();
    }

    async function prepareForm(form, ticket) {
      try {
        const [record, recordEn, referentials, airplanes] = await Promise.all([
          loadRecord('fr'),
          loadRecord('en'),
          VH.shared.airplaneForm.loadReferentials(),
          VH.shared.airplaneOptions.fetchAll(),
        ]);
        if (ticket !== _openTicket) return;
        form.setReferentials(referentials);
        // Prédécesseur / successeur / rival : tout le catalogue, sauf l'avion courant.
        form.setAirplanes(airplanes, state.aircraftId);
        form.fill(record, recordEn);
        setFormReady(true);
      } catch {
        if (ticket !== _openTicket) return;
        setFormReady(false);
        showToast(i18n.t('common.loading_error'), 'error');
      }
    }

    function openEditModal() {
      if (!state.aircraftData) return;
      const form = ensureForm();
      setFormReady(false);
      prepareForm(form, ++_openTicket);

      _previousFocus = document.activeElement;
      editModal.classList.add('show');
      document.body.style.overflow = 'hidden';
      _focusTrap = trapFocus(editModal, { onEscape: closeEditModal });

      // Déplace le focus dans la modale pour annonce AT (WCAG 2.4.3).
      // Premier champ de formulaire, repli sur le bouton fermer.
      requestAnimationFrame(() => {
        const initial = editForm?.querySelector('input:not([type="hidden"]), select, textarea') || modalClose;
        initial?.focus();
      });
    }

    function closeEditModal() {
      if (!editModal.classList.contains('show') || editModal.classList.contains('is-closing')) return;
      _focusTrap?.destroy();
      _focusTrap = null;
      // Animation de sortie, puis masquage (repli par minuterie si
      // animationend ne se déclenche pas).
      editModal.classList.add('is-closing');
      let done = false;
      const finish = () => {
        if (done) return;
        done = true;
        editModal.classList.remove('show', 'is-closing');
        document.body.style.overflow = '';
      };
      editModal.addEventListener('animationend', finish, { once: true });
      setTimeout(finish, 320);
      _previousFocus?.focus();
    }
    VH.details.admin.closeEditModal = closeEditModal;

    editBtn?.addEventListener('click', openEditModal);
    [cancelEditBtn, modalClose].forEach(btn => btn?.addEventListener('click', closeEditModal));
    editModal?.addEventListener('click', (e) => {
      if (e.target === editModal || e.target.classList.contains('modal-backdrop')) closeEditModal();
    });

    editForm?.addEventListener('submit', async (e) => {
      e.preventDefault();
      // Listes ou fiche non chargées : enregistrer effacerait des relations.
      if (!_formReady || !_form) return;
      if (!auth.getToken() || (state.userRole !== 1 && state.userRole !== 2)) {
        showToast(i18n.t('common.unauthorized'), 'error');
        return;
      }
      // Tous les champs du formulaire ; un champ absent du corps serait
      // laissé inchangé par le PUT, un champ vide (null) est effacé.
      const formData = _form.read();

      // Enregistrement en cours : bouton bloqué, pas de double envoi.
      if (submitBtn?.getAttribute('aria-busy') === 'true') return;
      submitBtn?.setAttribute('aria-busy', 'true');
      if (submitBtn) submitBtn.disabled = true;
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
      } finally {
        submitBtn?.removeAttribute('aria-busy');
        if (submitBtn) submitBtn.disabled = !_formReady;
      }
    });

    deleteBtn?.addEventListener('click', async () => {
      if (!confirm(i18n.t('common.confirm_delete') + ` "${state.aircraftData.name}" ?`)) return;
      deleteBtn.disabled = true;
      deleteBtn.setAttribute('aria-busy', 'true');
      try {
        const response = await auth.authFetch(`/api/airplanes/${state.aircraftId}`, { method: 'DELETE' });
        if (!response.ok) throw new Error(i18n.t('common.delete_error'));
        showToast(i18n.t('common.deleted'), 'success');
        setTimeout(() => window.location.href = '/hangar', 1500);
      } catch (error) {
        showToast(error.message || i18n.t('common.delete_error'), 'error');
        deleteBtn.disabled = false;
        deleteBtn.removeAttribute('aria-busy');
      }
    });
  }

  VH.details.admin = { setup, closeEditModal: () => {} };
  if (typeof module !== 'undefined' && module.exports) module.exports = VH.details.admin;
})();
