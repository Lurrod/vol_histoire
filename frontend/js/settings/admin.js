/* Paramètres — panneau d'administration : liste paginée des utilisateurs
 * (recherche côté serveur), édition dans une modale, suppression.
 * Visible des seuls administrateurs (rôle 1) ; init() branche les écouteurs,
 * loadUsers() est appelé par le point d'entrée après vérification du rôle.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const SEARCH_DEBOUNCE_MS = 300;

  // Contexte du panneau, créé par init() : état de pagination + recherche
  // côté serveur, éléments du DOM, utilisateur en cours d'édition.
  let ctx = null;

  function roleView(roleId) {
    if (roleId === 1) return { label: 'Admin', badge: 'badge-admin' };
    if (roleId === 2) return { label: 'Éditeur', badge: 'badge-editor' };
    return { label: 'Membre', badge: 'badge-member' };
  }

  /** Carte d'un utilisateur. Toutes les données passent par escapeHtml(). */
  function userCardHtml(user, currentUserId) {
    const { label, badge } = roleView(user.role_id);
    const initial = escapeHtml(String(user.name || '?').charAt(0).toUpperCase());
    return `
        <div class="user-card" data-user-id="${Number(user.id)}">
          <div class="user-avatar-img">${initial}</div>
          <div class="user-info">
            <div class="user-info-name">${escapeHtml(user.name)}<span class="role-badge ${badge}">${label}</span></div>
            <div class="user-info-email">${escapeHtml(user.email)}</div>
          </div>
          <div class="user-actions">
            <button class="btn-edit" data-user-id="${Number(user.id)}" title="Modifier"><i class="fas fa-pen"></i></button>
            ${user.id !== currentUserId ? `<button type="button" class="btn-delete" data-user-id="${Number(user.id)}" title="${escapeHtml(i18n.t('settings.delete_user'))}" aria-label="${escapeHtml(i18n.t('settings.delete_user'))}"></button>` : ''}
          </div>
        </div>
      `;
  }

  function setUserListMessage(key) {
    if (ctx.els.userList) {
      ctx.els.userList.innerHTML = `<p class="admin-empty-msg">${i18n.t(key)}</p>`;
    }
  }

  async function loadUsers() {
    if (!ctx) return;
    try {
      const params = new URLSearchParams({ page: String(ctx.page), limit: String(ctx.limit) });
      if (ctx.search) params.set('search', ctx.search);

      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/users?${params}`);

      if (response.ok) {
        const body = await response.json();
        ctx.users = Array.isArray(body.data) ? body.data : [];
        const meta = body.meta || {};
        ctx.total = Number.isFinite(meta.total) ? meta.total : ctx.users.length;
        ctx.totalPages = Math.max(1, meta.totalPages || Math.ceil(ctx.total / ctx.limit));

        // Si la page demandée dépasse le total (après suppression ou recherche),
        // reculer à la dernière page valide et refetch une seule fois.
        if (ctx.page > ctx.totalPages) {
          ctx.page = ctx.totalPages;
          return loadUsers();
        }

        displayUsers(ctx.users);
        renderUserPagination();
        updateUserStats();
      } else if (response.status === 401 || response.status === 403) {
        auth.clearSession();
        showToast(i18n.t('settings.toast_session_expired'), 'error');
        setTimeout(() => { window.location.href = '/login'; }, 1500);
      } else {
        setUserListMessage('settings.admin_api_unavailable');
      }
    } catch {
      setUserListMessage('settings.toast_users_error');
    }
  }

  function displayUsers(users) {
    const userList = ctx.els.userList;
    if (!userList) return;

    // safeSetHTML : double couche escapeHtml + DOMPurify (défense en
    // profondeur — la liste vient d'utilisateurs externes, c'est le seul
    // endroit où des données saisies par un utilisateur sont montrées à un autre).
    const currentUserId = ctx.settings.currentUser?.id;
    safeSetHTML(userList, users.map(user => userCardHtml(user, currentUserId)).join(''));

    document.querySelectorAll('.btn-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        const user = ctx.users.find(u => u.id === parseInt(btn.dataset.userId));
        if (user) openEditUserModal(user);
      });
    });
    document.querySelectorAll('.btn-delete').forEach(armDeleteButton);
  }

  /* Suppression en deux temps, sur place : la poubelle ouvre « supprimer /
   * garder » à sa gauche ; la requête ne part qu'après la coche tracée. */
  function armDeleteButton(btn) {
    // Poubelle partagée (shared/confirm-action.js) : posée après coup,
    // safeSetHTML retire les balises SVG du fragment.
    btn.replaceChildren(window.VH.confirmAction.binIcon());
    const control = window.VH.confirmAction.arm(btn, {
      side: 'left',
      showText: true,
      className: 'adm-del',
      measure: '.cfm-bin-check',
      labels: {
        group: i18n.t('settings.delete_user_group'),
        confirm: i18n.t('settings.delete_user_confirm'),
        cancel: i18n.t('settings.delete_user_keep'),
      },
      onConfirm: () => deleteUser(btn.dataset.userId, control),
    });
  }

  function scrollToListTop() {
    const target = document.getElementById('admin') || ctx.els.userList;
    if (target && typeof target.scrollIntoView === 'function') {
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }

  function renderUserPagination() {
    const userPagination = ctx.els.userPagination;
    if (!userPagination) return;
    if (ctx.total === 0) { userPagination.innerHTML = ''; return; }

    userPagination.innerHTML = `
      <button class="prev-page-btn" ${ctx.page <= 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>
      <span class="page-info">${i18n.t('hangar.page_info', { current: ctx.page, total: ctx.totalPages })}</span>
      <button class="next-page-btn" ${ctx.page >= ctx.totalPages ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>
    `;
    userPagination.querySelector('.prev-page-btn')?.addEventListener('click', () => {
      if (ctx.page > 1) { ctx.page--; loadUsers(); scrollToListTop(); }
    });
    userPagination.querySelector('.next-page-btn')?.addEventListener('click', () => {
      if (ctx.page < ctx.totalPages) { ctx.page++; loadUsers(); scrollToListTop(); }
    });
  }

  function updateUserStats() {
    const totalUsersEl = document.getElementById('total-users');
    // Odomètre : le total change avec la recherche et la pagination.
    if (totalUsersEl) window.VH.rollingNumber.set(totalUsersEl, Number(ctx.total) || 0);
  }

  /** @param {string|number} userId  @param {{reset: () => void}|null} [control] confirmation à remettre au repos en cas d'échec */
  async function deleteUser(userId, control) {
    let response;
    try {
      response = await auth.authFetch(`${VH.settings.ui.API_BASE}/users/${userId}`, { method: 'DELETE' });
    } catch {
      if (control) control.reset();
      showToast(i18n.t('settings.toast_network_error'), 'error');
      return;
    }
    if (!response.ok) {
      const data = await response.json().catch(() => ({}));
      if (control) control.reset();
      showToast(data.message || 'Erreur lors de la suppression', 'error');
      return;
    }
    showToast(i18n.t('settings.toast_user_deleted'), 'success');
    // Hors du try : la suppression a réussi ; un échec du rechargement ne
    // doit ni annoncer « erreur réseau » ni réactiver une ligne supprimée.
    // Recharge la page courante (avec auto-rewind si elle s'est vidée).
    await loadUsers();
  }

  // ------------------------------------------------------------------
  // Modale d'édition
  // ------------------------------------------------------------------
  let cancelCloseModal = null;

  function openEditUserModal(user) {
    const { editUserModal, editUserName, editUserEmail, editUserRole } = ctx.els;
    ctx.editingUserId = user.id;
    editUserName.value = user.name;
    editUserEmail.value = user.email;
    editUserRole.value = user.role_id;
    document.getElementById('edit-user-modal-title').textContent = i18n.t('settings.edit_user_title', { name: user.name });
    // Réouverture pendant une sortie : on annule la fermeture en cours.
    if (cancelCloseModal) { cancelCloseModal(); cancelCloseModal = null; }
    editUserModal.classList.remove('hidden');
    setTimeout(() => editUserModal.classList.add('show'), 10);
  }

  function closeEditUserModal() {
    const { editUserModal } = ctx.els;
    // Déjà en sortie (double clic, Enregistrer puis Annuler) : rien à relancer.
    if (cancelCloseModal) return;
    // .is-closing garde la modale visible le temps de la sortie (settings.css) ;
    // VH.motion.exit attend la durée réelle puis masque.
    let finished = false;
    const cancel = window.VH.motion.exit(editUserModal, () => {
      finished = true;
      editUserModal.classList.remove('show');
      editUserModal.classList.add('hidden');
      cancelCloseModal = null;
    }, { measure: editUserModal.querySelector('.logout-modal-container') });
    if (!finished) cancelCloseModal = cancel;
  }

  function validateEditUser(name, email) {
    const { editUserName, editUserEmail } = ctx.els;
    clearFieldError(editUserName);
    clearFieldError(editUserEmail);

    if (name.length < 2) {
      setFieldError(editUserName, i18n.t('settings.toast_name_min') || 'Nom invalide (minimum 2 caractères)');
      editUserName.focus();
      return false;
    }
    if (!isValidEmail(email)) {
      setFieldError(editUserEmail, i18n.t('settings.toast_email_invalid') || 'Adresse email invalide');
      editUserEmail.focus();
      return false;
    }
    return true;
  }

  async function saveEditedUser() {
    const { editUserName, editUserEmail, editUserRole, editUserSave } = ctx.els;
    const { setButtonLoading } = VH.settings.ui;
    const name = editUserName.value.trim();
    const email = editUserEmail.value.trim();
    const role_id = parseInt(editUserRole.value);

    if (!validateEditUser(name, email)) return;

    try {
      setButtonLoading(editUserSave, true);
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/admin/users/${ctx.editingUserId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, role_id }),
      });

      if (response.ok) {
        closeEditUserModal();
        showToast('Utilisateur modifié avec succès', 'success');
        // Refetch la page courante pour refléter le changement
        await loadUsers();
      } else {
        const data = await response.json();
        showToast(data.message || 'Erreur lors de la modification', 'error');
      }
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    } finally {
      setButtonLoading(editUserSave, false);
    }
  }

  function bindModal() {
    const { editUserModal, editUserName, editUserEmail, editUserCancel, editUserSave } = ctx.els;
    editUserCancel?.addEventListener('click', closeEditUserModal);
    editUserModal?.querySelector('.logout-modal-backdrop')?.addEventListener('click', closeEditUserModal);
    editUserName?.addEventListener('input', () => clearFieldError(editUserName));
    editUserEmail?.addEventListener('input', () => clearFieldError(editUserEmail));
    editUserSave?.addEventListener('click', saveEditedUser);
  }

  // Recherche côté serveur, temporisée
  function bindSearch() {
    const userFilter = ctx.els.userFilter;
    if (!userFilter) return;
    let searchDebounceTimer = null;
    userFilter.addEventListener('input', (e) => {
      ctx.search = e.target.value.trim();
      ctx.page = 1;
      clearTimeout(searchDebounceTimer);
      searchDebounceTimer = setTimeout(() => loadUsers(), SEARCH_DEBOUNCE_MS);
    });
  }

  /** @param {{ currentUser: object|null }} settingsState état partagé de la page */
  function init(settingsState) {
    const byId = (id) => document.getElementById(id);
    ctx = {
      settings: settingsState,
      page: 1,
      limit: 8,
      total: 0,
      totalPages: 1,
      search: '',
      users: [],
      editingUserId: null,
      els: {
        userFilter: byId('user-filter'),
        userList: byId('user-list'),
        userPagination: byId('user-pagination'),
        editUserModal: byId('edit-user-modal'),
        editUserName: byId('edit-user-name'),
        editUserEmail: byId('edit-user-email'),
        editUserRole: byId('edit-user-role'),
        editUserCancel: byId('edit-user-cancel'),
        editUserSave: byId('edit-user-save'),
      },
    };
    bindModal();
    bindSearch();
    return ctx;
  }

  VH.settings.admin = {
    roleView, userCardHtml, init, loadUsers, displayUsers, renderUserPagination,
    deleteUser, openEditUserModal, closeEditUserModal, saveEditedUser,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.admin;
  }
})();
