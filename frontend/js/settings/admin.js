/* Paramètres — panneau d'administration : liste paginée des utilisateurs
 * (recherche côté serveur), filtre par rôle avec compteurs (meta.roles,
 * facultatif), rôle changé directement dans la liste (un <select> natif par
 * ligne, amélioré par VH.customSelect), nom et email dans une modale,
 * suppression confirmée sur place. Un administrateur ne peut ni changer
 * son propre rôle ni supprimer son compte d'ici.
 * Visible des seuls administrateurs (rôle 1) ; init() branche les écouteurs,
 * loadUsers() est appelé par le point d'entrée après vérification du rôle.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const SEARCH_DEBOUNCE_MS = 300;
  const ROLE_IDS = [1, 2, 3];

  // Contexte du panneau, créé par init() : pagination, recherche et filtre
  // côté serveur, éléments du DOM, utilisateur en cours d'édition.
  let ctx = null;

  /** Libellé traduit et classe d'un rôle. */
  function roleView(roleId) {
    const { tr } = VH.settings.ui;
    if (roleId === 1) return { label: tr('common.role_admin', 'Administrateur'), badge: 'badge-admin' };
    if (roleId === 2) return { label: tr('common.role_editor', 'Éditeur'), badge: 'badge-editor' };
    return { label: tr('nav.user_role', 'Membre'), badge: 'badge-member' };
  }

  /** Carte d'un utilisateur. Toutes les données passent par escapeHtml().
   * Le sélecteur de rôle est construit à part (roleSelect) : safeSetHTML
   * n'autorise pas <select>. */
  function userCardHtml(user, currentUserId) {
    const { tr } = VH.settings.ui;
    const id = Number(user.id);
    const initial = escapeHtml(String(user.name || '?').charAt(0).toUpperCase());
    const editLabel = escapeHtml(tr('settings.admin_edit', 'Modifier'));
    const deleteLabel = escapeHtml(i18n.t('settings.delete_user'));
    const self = user.id === currentUserId;
    return `
        <div class="user-card${self ? ' is-self' : ''}" data-user-id="${id}">
          <div class="user-avatar-img" aria-hidden="true">${initial}</div>
          <div class="user-info">
            <div class="user-info-name">${escapeHtml(user.name)}</div>
            <div class="user-info-email">${escapeHtml(user.email)}</div>
          </div>
          <div class="user-role" data-user-id="${id}"></div>
          <div class="user-actions">
            <button type="button" class="btn-edit" data-user-id="${id}" title="${editLabel}" aria-label="${editLabel}"><i class="fas fa-pen"></i></button>
            ${self ? '' : `<button type="button" class="btn-delete" data-user-id="${id}" title="${deleteLabel}" aria-label="${deleteLabel}"></button>`}
          </div>
        </div>
      `;
  }

  /** Sélecteur de rôle d'une ligne ; désactivé sur sa propre ligne. */
  function roleSelect(user, currentUserId) {
    const { trf, tr } = VH.settings.ui;
    const select = document.createElement('select');
    select.id = `user-role-${Number(user.id)}`;
    select.className = 'user-role-select';
    select.dataset.userId = String(Number(user.id));
    select.setAttribute('aria-label', trf('settings.admin_role_label', 'Rôle de {name}', { name: user.name || user.email || '' }));
    ROLE_IDS.forEach((roleId) => {
      const option = document.createElement('option');
      option.value = String(roleId);
      option.textContent = roleView(roleId).label;
      select.appendChild(option);
    });
    select.value = String(user.role_id);
    if (user.id === currentUserId) {
      select.disabled = true;
      select.title = tr('settings.admin_role_self', 'Vous ne pouvez pas changer votre propre rôle.');
    } else {
      select.addEventListener('change', () => changeRole(select, user));
    }
    return select;
  }

  /** Change le rôle depuis la ligne ; retour à l'ancien rôle en cas d'échec.
   * L'API exige le nom avec le rôle : il est renvoyé tel quel. */
  async function changeRole(select, user) {
    const { API_BASE, tr, trf } = VH.settings.ui;
    const previous = String(user.role_id);
    const roleId = Number(select.value);
    if (String(roleId) === previous) return false;
    const card = select.closest('.user-card');
    select.disabled = true;
    if (card) card.setAttribute('aria-busy', 'true');
    let ok = false;
    try {
      const response = await auth.authFetch(`${API_BASE}/admin/users/${Number(user.id)}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: user.name, role_id: roleId }),
      });
      if (response.ok) {
        ok = true;
        showToast(trf('settings.admin_role_updated', 'Rôle de {name} : {role}', { name: user.name, role: roleView(roleId).label }), 'success');
      } else {
        const data = await response.json().catch(() => ({}));
        showToast(data.message || tr('settings.admin_role_error', 'Le rôle n’a pas pu être changé.'), 'error');
      }
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    }
    if (card) card.removeAttribute('aria-busy');
    select.disabled = false;
    if (!ok) {
      select.value = previous;
      return false;
    }
    // Compteurs des rôles et filtre courant : la ligne peut sortir de la liste.
    await loadUsers();
    return true;
  }

  function setUserListMessage(key) {
    if (ctx.els.userList) {
      ctx.els.userList.innerHTML = `<p class="admin-empty-msg">${escapeHtml(i18n.t(key))}</p>`;
    }
  }

  async function loadUsers() {
    if (!ctx) return;
    try {
      const params = new URLSearchParams({ page: String(ctx.page), limit: String(ctx.limit) });
      if (ctx.search) params.set('search', ctx.search);
      if (ctx.role) params.set('role', ctx.role);

      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/users?${params}`);

      if (response.ok) {
        const body = await response.json();
        ctx.users = Array.isArray(body.data) ? body.data : [];
        const meta = body.meta || {};
        ctx.total = Number.isFinite(meta.total) ? meta.total : ctx.users.length;
        ctx.totalPages = Math.max(1, meta.totalPages || Math.ceil(ctx.total / ctx.limit));

        // Si la page demandée dépasse le total (après suppression, recherche
        // ou filtre), reculer à la dernière page valide et recharger une fois.
        if (ctx.page > ctx.totalPages) {
          ctx.page = ctx.totalPages;
          return loadUsers();
        }

        displayUsers(ctx.users);
        renderUserPagination();
        updateUserStats();
        renderRoleCounts(meta.roles);
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

    if (!users.length) {
      setUserListMessage('settings.admin_empty');
      return;
    }

    // safeSetHTML : double couche escapeHtml + DOMPurify (défense en
    // profondeur — la liste vient d'utilisateurs externes, c'est le seul
    // endroit où des données saisies par un utilisateur sont montrées à un autre).
    const currentUserId = ctx.settings.currentUser?.id;
    safeSetHTML(userList, users.map(user => userCardHtml(user, currentUserId)).join(''));

    users.forEach((user) => {
      const slot = userList.querySelector(`.user-role[data-user-id="${Number(user.id)}"]`);
      if (slot) slot.appendChild(roleSelect(user, currentUserId));
    });
    userList.querySelectorAll('.btn-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        const user = ctx.users.find(u => u.id === parseInt(btn.dataset.userId, 10));
        if (user) openEditUserModal(user);
      });
    });
    userList.querySelectorAll('.btn-delete').forEach(armDeleteButton);
  }

  /** Compteurs des pastilles de rôle (meta.roles ; absents : pastilles sans nombre). */
  function renderRoleCounts(roles) {
    const counts = roles && typeof roles === 'object'
      ? ROLE_IDS.map((id) => Number(roles[id]) || 0)
      : null;
    document.querySelectorAll('.role-chip-count').forEach((el) => {
      if (!counts) { el.textContent = ''; return; }
      const key = el.dataset.countRole;
      el.textContent = String(key === 'all' ? counts.reduce((a, b) => a + b, 0) : counts[Number(key) - 1] || 0);
    });
  }

  /** Pastille de rôle choisie : filtre, première page, rechargement. */
  function selectRole(role) {
    ctx.role = ROLE_IDS.includes(Number(role)) ? String(Number(role)) : '';
    ctx.page = 1;
    document.querySelectorAll('.role-chip').forEach((chip) => {
      chip.setAttribute('aria-pressed', chip.dataset.role === ctx.role ? 'true' : 'false');
    });
    return loadUsers();
  }

  function bindRoleChips() {
    document.querySelectorAll('.role-chip').forEach((chip) => {
      chip.addEventListener('click', () => {
        if (chip.getAttribute('aria-pressed') !== 'true') selectRole(chip.dataset.role);
      });
    });
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
      target.scrollIntoView({ behavior: VH.settings.ui.scrollBehavior(), block: 'start' });
    }
  }

  function renderUserPagination() {
    const userPagination = ctx.els.userPagination;
    if (!userPagination) return;
    if (ctx.total === 0 || ctx.totalPages <= 1) { userPagination.innerHTML = ''; return; }

    userPagination.innerHTML = `
      <button type="button" class="prev-page-btn" ${ctx.page <= 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left" aria-hidden="true"></i> ${escapeHtml(i18n.t('hangar.prev_page'))}
      </button>
      <span class="page-info">${escapeHtml(i18n.t('hangar.page_info', { current: ctx.page, total: ctx.totalPages }))}</span>
      <button type="button" class="next-page-btn" ${ctx.page >= ctx.totalPages ? 'disabled' : ''}>
        ${escapeHtml(i18n.t('hangar.next_page'))} <i class="fas fa-chevron-right" aria-hidden="true"></i>
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
    const { tr, plural } = VH.settings.ui;
    const total = Number(ctx.total) || 0;
    // Odomètre : le total change avec la recherche, le filtre et la pagination.
    const totalUsersEl = document.getElementById('total-users');
    if (totalUsersEl) window.VH.rollingNumber.set(totalUsersEl, total);
    const label = document.getElementById('total-users-label');
    if (label) label.textContent = tr(plural('settings.admin_users', total), total === 1 ? 'utilisateur' : 'utilisateurs');
  }

  /** @param {string|number} userId  @param {{reset: () => void}|null} [control] confirmation à remettre au repos en cas d'échec */
  async function deleteUser(userId, control) {
    const { tr } = VH.settings.ui;
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
      showToast(data.message || tr('settings.toast_delete_error', 'Erreur lors de la suppression'), 'error');
      return;
    }
    showToast(i18n.t('settings.toast_user_deleted'), 'success');
    // Hors du try : la suppression a réussi ; un échec du rechargement ne
    // doit ni annoncer « erreur réseau » ni réactiver une ligne supprimée.
    // Recharge la page courante (avec recul si elle s'est vidée).
    await loadUsers();
  }

  // ------------------------------------------------------------------
  // Modale d'édition (nom, email ; le rôle se change dans la liste)
  // ------------------------------------------------------------------
  let cancelCloseModal = null;

  function openEditUserModal(user) {
    const { editUserModal, editUserName, editUserEmail } = ctx.els;
    ctx.editingUserId = user.id;
    editUserName.value = user.name;
    editUserEmail.value = user.email;
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
    const { editUserName, editUserEmail, editUserSave } = ctx.els;
    const { setButtonLoading, tr } = VH.settings.ui;
    const name = editUserName.value.trim();
    const email = editUserEmail.value.trim();

    if (!validateEditUser(name, email)) return;

    // L'API exige le rôle : celui de la ligne, inchangé.
    const edited = ctx.users.find(u => u.id === ctx.editingUserId);
    const role_id = edited ? Number(edited.role_id) : 3;

    try {
      setButtonLoading(editUserSave, true);
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/admin/users/${ctx.editingUserId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, role_id }),
      });

      if (response.ok) {
        closeEditUserModal();
        showToast(tr('settings.toast_user_updated', 'Utilisateur modifié'), 'success');
        // Recharge la page courante pour refléter le changement
        await loadUsers();
      } else {
        const data = await response.json().catch(() => ({}));
        showToast(data.message || tr('settings.toast_user_update_error', 'Erreur lors de la modification'), 'error');
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
      role: '',
      users: [],
      editingUserId: null,
      els: {
        userFilter: byId('user-filter'),
        userList: byId('user-list'),
        userPagination: byId('user-pagination'),
        editUserModal: byId('edit-user-modal'),
        editUserName: byId('edit-user-name'),
        editUserEmail: byId('edit-user-email'),
        editUserCancel: byId('edit-user-cancel'),
        editUserSave: byId('edit-user-save'),
      },
    };
    bindModal();
    bindSearch();
    bindRoleChips();
    return ctx;
  }

  VH.settings.admin = {
    roleView, userCardHtml, roleSelect, changeRole, renderRoleCounts, selectRole,
    init, loadUsers, displayUsers, renderUserPagination,
    deleteUser, openEditUserModal, closeEditUserModal, saveEditedUser,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.admin;
  }
})();
