/* ======================================================================
   VOL D'HISTOIRE — SETTINGS : ADMIN PANEL
   Gestion des utilisateurs (liste, édition, suppression).
   Dépend de window.settings (currentUser, API_BASE, setButtonLoading).
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const ctx = () => window.settings;
  const API_BASE = '/api';

  // State de pagination + recherche côté serveur
  const state = {
    page: 1,
    limit: 20,
    total: 0,
    totalPages: 1,
    search: '',
    users: [],
  };

  const userFilter = document.getElementById('user-filter');
  const userList = document.getElementById('user-list');
  const userPagination = document.getElementById('user-pagination');

  // -------------------------------------------------------------------
  // Load & display users
  // -------------------------------------------------------------------
  async function loadUsers() {
    try {
      const params = new URLSearchParams({
        page: String(state.page),
        limit: String(state.limit),
      });
      if (state.search) params.set('search', state.search);

      const response = await auth.authFetch(`${API_BASE}/users?${params}`);

      if (response.ok) {
        const body = await response.json();
        state.users = Array.isArray(body.data) ? body.data : [];
        const meta = body.meta || {};
        state.total = Number.isFinite(meta.total) ? meta.total : state.users.length;
        state.totalPages = Math.max(1, meta.totalPages || Math.ceil(state.total / state.limit));

        // Si la page demandée dépasse le total (après suppression ou recherche),
        // reculer à la dernière page valide et refetch une seule fois.
        if (state.page > state.totalPages) {
          state.page = state.totalPages;
          return loadUsers();
        }

        displayUsers(state.users);
        renderUserPagination();
        updateUserStats();
      } else if (response.status === 401 || response.status === 403) {
        auth.clearSession();
        showToast(i18n.t('settings.toast_session_expired'), 'error');
        setTimeout(() => { window.location.href = '/login'; }, 1500);
      } else {
        if (userList) {
          userList.innerHTML = `<p class="admin-empty-msg">${i18n.t('settings.admin_api_unavailable')}</p>`;
        }
      }
    } catch (err) {
      if (userList) {
        userList.innerHTML = `<p class="admin-empty-msg">${i18n.t('settings.toast_users_error')}</p>`;
      }
    }
  }

  function displayUsers(users) {
    if (!userList) return;

    // safeSetHTML : double couche escapeHtml + DOMPurify sanitization
    // (défense en profondeur — la liste users vient d'utilisateurs externes,
    // c'est le seul endroit où des données user-controlled sont affichées
    // à un autre user)
    const html = users.map(user => {
      const roleLabel = user.role_id === 1 ? 'Admin' : user.role_id === 2 ? 'Éditeur' : 'Membre';
      const roleBadgeClass = user.role_id === 1 ? 'badge-admin' : user.role_id === 2 ? 'badge-editor' : 'badge-member';
      const initial = escapeHtml(String(user.name || '?').charAt(0).toUpperCase());
      return `
        <div class="user-card" data-user-id="${Number(user.id)}">
          <div class="user-avatar-img">${initial}</div>
          <div class="user-info">
            <div class="user-info-name">${escapeHtml(user.name)}<span class="role-badge ${roleBadgeClass}">${roleLabel}</span></div>
            <div class="user-info-email">${escapeHtml(user.email)}</div>
          </div>
          <div class="user-actions">
            <button class="btn-edit" data-user-id="${Number(user.id)}" title="Modifier"><i class="fas fa-pen"></i></button>
            ${user.id !== ctx()?.currentUser?.id ? `<button class="btn-delete" data-user-id="${Number(user.id)}" title="Supprimer"><i class="fas fa-trash"></i></button>` : ''}
          </div>
        </div>
      `;
    }).join('');
    safeSetHTML(userList, html);

    document.querySelectorAll('.btn-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        const user = state.users.find(u => u.id === parseInt(btn.dataset.userId));
        if (user) openEditUserModal(user);
      });
    });
    document.querySelectorAll('.btn-delete').forEach(btn => {
      btn.addEventListener('click', () => deleteUser(btn.dataset.userId));
    });
  }

  function renderUserPagination() {
    if (!userPagination) return;
    if (state.total === 0) { userPagination.innerHTML = ''; return; }

    userPagination.innerHTML = `
      <button class="prev-page-btn" ${state.page <= 1 ? 'disabled' : ''}>
        <i class="fas fa-chevron-left"></i> ${i18n.t('hangar.prev_page')}
      </button>
      <span class="page-info">${i18n.t('hangar.page_info', { current: state.page, total: state.totalPages })}</span>
      <button class="next-page-btn" ${state.page >= state.totalPages ? 'disabled' : ''}>
        ${i18n.t('hangar.next_page')} <i class="fas fa-chevron-right"></i>
      </button>
    `;
    userPagination.querySelector('.prev-page-btn')?.addEventListener('click', () => {
      if (state.page > 1) { state.page--; loadUsers(); }
    });
    userPagination.querySelector('.next-page-btn')?.addEventListener('click', () => {
      if (state.page < state.totalPages) { state.page++; loadUsers(); }
    });
  }

  function updateUserStats() {
    const totalUsersEl = document.getElementById('total-users');
    if (totalUsersEl) totalUsersEl.textContent = state.total;
  }

  async function deleteUser(userId) {
    if (!confirm(i18n.t('settings.confirm_delete_user'))) return;

    try {
      const response = await auth.authFetch(`${API_BASE}/users/${userId}`, { method: 'DELETE' });

      if (response.ok) {
        showToast(i18n.t('settings.toast_user_deleted'), 'success');
        // Recharger la page courante depuis le serveur (avec auto-rewind
        // si la suppression a vidé la page).
        await loadUsers();
      } else {
        const data = await response.json();
        showToast(data.message || 'Erreur lors de la suppression', 'error');
      }
    } catch (err) {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    }
  }

  // -------------------------------------------------------------------
  // Edit user modal
  // -------------------------------------------------------------------
  let editingUserId = null;
  const editUserModal = document.getElementById('edit-user-modal');
  const editUserName = document.getElementById('edit-user-name');
  const editUserEmail = document.getElementById('edit-user-email');
  const editUserRole = document.getElementById('edit-user-role');
  const editUserCancel = document.getElementById('edit-user-cancel');
  const editUserSave = document.getElementById('edit-user-save');

  function openEditUserModal(user) {
    editingUserId = user.id;
    editUserName.value = user.name;
    editUserEmail.value = user.email;
    editUserRole.value = user.role_id;
    document.getElementById('edit-user-modal-title').textContent = i18n.t('settings.edit_user_title', { name: user.name });
    editUserModal.classList.remove('hidden');
    setTimeout(() => editUserModal.classList.add('show'), 10);
  }

  function closeEditUserModal() {
    editUserModal.classList.remove('show');
    setTimeout(() => editUserModal.classList.add('hidden'), 300);
  }

  editUserCancel?.addEventListener('click', closeEditUserModal);
  editUserModal?.querySelector('.logout-modal-backdrop')?.addEventListener('click', closeEditUserModal);

  editUserName?.addEventListener('input', () => clearFieldError(editUserName));
  editUserEmail?.addEventListener('input', () => clearFieldError(editUserEmail));

  editUserSave?.addEventListener('click', async () => {
    const name = editUserName.value.trim();
    const email = editUserEmail.value.trim();
    const role_id = parseInt(editUserRole.value);

    clearFieldError(editUserName);
    clearFieldError(editUserEmail);

    if (name.length < 2) {
      setFieldError(editUserName, i18n.t('settings.toast_name_min') || 'Nom invalide (minimum 2 caractères)');
      editUserName.focus();
      return;
    }
    if (!isValidEmail(email)) {
      setFieldError(editUserEmail, i18n.t('settings.toast_email_invalid') || 'Adresse email invalide');
      editUserEmail.focus();
      return;
    }

    try {
      ctx()?.setButtonLoading(editUserSave, true);
      const response = await auth.authFetch(`${API_BASE}/admin/users/${editingUserId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, role_id })
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
    } catch (err) {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    } finally {
      ctx()?.setButtonLoading(editUserSave, false);
    }
  });

  // User search/filter — côté serveur, debounced
  if (userFilter) {
    let searchDebounceTimer = null;
    userFilter.addEventListener('input', (e) => {
      state.search = e.target.value.trim();
      state.page = 1;
      clearTimeout(searchDebounceTimer);
      searchDebounceTimer = setTimeout(() => loadUsers(), 300);
    });
  }

  // Expose loadUsers for settings.js to call after auth check
  window.settingsAdmin = { loadUsers };
});
