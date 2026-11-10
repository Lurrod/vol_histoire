/* Formulaire admin du hangar : modale de création d'un appareil.
 * Le formulaire lui-même (champs, listes, lecture) est VH.shared.airplaneForm,
 * commun avec l'édition sur la fiche (ARCH-007). */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  // Référentiels déjà chargés par hangar/data.js pour les filtres : la modale
  // les réutilise au lieu de refaire la requête.
  let _referentials = null;
  let _form = null;

  /* Appelé par hangar/data.js une fois /api/referentials chargé. En cas
   * d'échec de ce chargement, il n'est pas appelé : la modale relancera la
   * requête elle-même à l'ouverture. */
  function populateFormSelects(state) {
    const refs = {
      countries: state.countries,
      manufacturers: state.manufacturers,
      generations: state.generations,
      types: state.types,
    };
    if (!VH.shared.airplaneForm.isReferentials(refs)) return;
    _referentials = refs;
    _form?.setReferentials(refs);
  }

  function setupAdminModal(state) {
    const modal = document.getElementById('aircraft-modal');
    const modalForm = document.getElementById('aircraft-form');
    const fieldsRoot = document.getElementById('aircraft-form-fields');
    const addBtn = document.getElementById('add-airplane-btn');
    const cancelBtn = document.getElementById('cancel-btn');
    const modalClose = document.querySelector('.modal-close');

    const submitBtn = document.getElementById('submit-btn');
    // Doit couvrir la durée de l'animation de sortie (--modal-close-dur, 150 ms).
    const CLOSE_MS = 180;

    let _focusTrap = null;
    let _previousFocus = null;
    let _closeTimer = null;
    let _submitting = false;
    // Vrai quand les référentiels et la liste des appareils sont chargés.
    let _ready = false;
    let _openTicket = 0;

    function syncSubmit() {
      if (submitBtn) submitBtn.disabled = _submitting || !_ready;
    }

    function setReady(ready) {
      _ready = ready;
      syncSubmit();
    }

    /* Bouton d'envoi : désactivé pendant la requête (pas de double création),
     * icône remplacée par un indicateur. icons.js ne convertit que les <i>
     * nouvellement insérés : on remplace l'icône, on ne touche pas ses classes. */
    function setSubmitting(on) {
      if (_submitting === on) return;
      _submitting = on;
      syncSubmit();
      if (!submitBtn) return;
      submitBtn.classList.toggle('is-loading', on);
      submitBtn.setAttribute('aria-busy', on ? 'true' : 'false');
      const icon = document.createElement('i');
      icon.className = on ? 'fas fa-circle-notch fa-spin' : 'fas fa-save';
      icon.setAttribute('aria-hidden', 'true');
      const current = submitBtn.querySelector('.icon, i');
      if (current) current.replaceWith(icon); else submitBtn.prepend(icon);
    }

    function ensureForm() {
      if (!_form) {
        _form = VH.shared.airplaneForm.mount(fieldsRoot, { prefix: 'aircraft' });
        if (_referentials) _form.setReferentials(_referentials);
      }
      return _form;
    }

    /* Référentiels et liste complète des appareils (filiations). Tant que
     * l'un manque, « Enregistrer » reste désactivé et un toast le dit : des
     * listes vides enverraient leurs clés à NULL sans prévenir (JS-001). */
    async function prepareForm(form, ticket) {
      try {
        const [refs, airplanes] = await Promise.all([
          _referentials ? Promise.resolve(_referentials) : VH.shared.airplaneForm.loadReferentials(),
          VH.shared.airplaneOptions.fetchAll(),
        ]);
        if (ticket !== _openTicket) return;
        _referentials = refs;
        form.setReferentials(refs);
        form.setAirplanes(airplanes);
        setReady(true);
      } catch {
        if (ticket !== _openTicket) return;
        setReady(false);
        showToast(i18n.t('common.loading_error'), 'error');
      }
    }

    function isOpen() { return !!modal && modal.classList.contains('show'); }

    // Fin de fermeture : retrait du DOM visuel, puis remise à zéro du formulaire
    // (après l'animation, pour ne pas voir les champs se vider en sortant).
    function finishClose() {
      clearTimeout(_closeTimer);
      _closeTimer = null;
      modal?.classList.remove('is-closing');
      modalForm?.reset();
    }

    function openModal() {
      if (!modal) return;
      if (_closeTimer) finishClose();
      const form = ensureForm();
      setReady(false);
      prepareForm(form, ++_openTicket);
      _previousFocus = document.activeElement;
      modal.classList.add('show');
      document.body.classList.add('modal-open');
      _focusTrap = trapFocus(modal, { onEscape: closeModal });
    }
    function closeModal() {
      // Échap est relayé par hangar.js même modale fermée : ne rien animer.
      if (!isOpen()) return;
      _focusTrap?.destroy();
      _focusTrap = null;
      modal.classList.remove('show');
      document.body.classList.remove('modal-open');
      _previousFocus?.focus();
      const reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (reduce) { finishClose(); return; }
      modal.classList.add('is-closing');
      _closeTimer = setTimeout(finishClose, CLOSE_MS);
    }

    addBtn?.addEventListener('click', openModal);
    [cancelBtn, modalClose].forEach(btn => btn?.addEventListener('click', closeModal));
    modal?.addEventListener('click', (e) => {
      if (e.target === modal || e.target.classList.contains('modal-backdrop')) closeModal();
    });

    modalForm?.addEventListener('submit', async (e) => {
      e.preventDefault();
      // Requête déjà partie (double clic, Entrée répétée) ou listes non
      // chargées : on ignore.
      if (_submitting || !_ready || !_form) return;
      const payload = auth.getPayload();
      if (!payload) { showToast(i18n.t('common.unauthorized'), 'error'); return; }
      const userRole = Number(payload.role);
      if (userRole !== 1 && userRole !== 2) { showToast(i18n.t('common.unauthorized'), 'error'); return; }

      const formData = _form.read();

      setSubmitting(true);
      try {
        const response = await auth.authFetch('/api/airplanes', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(formData)
        });
        if (!response.ok) throw new Error(i18n.t('common.create_error'));
        showToast(i18n.t('common.added'), 'success');
        // La nouvelle fiche doit figurer dans les listes de la prochaine ouverture.
        VH.shared.airplaneOptions.invalidate();
        closeModal();
        VH.hangar.data.loadAircraft(state);
      } catch (error) {
        showToast(error.message || i18n.t('common.create_error'), 'error');
      } finally {
        setSubmitting(false);
      }
    });

    VH.hangar.admin.closeModal = closeModal;
  }

  VH.hangar.admin = { populateFormSelects, setupAdminModal, closeModal: () => {} };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.hangar.admin;
  }
})();
