/* ======================================================================
   VOL D'HISTOIRE — SETTINGS : ADMIN PANEL
   Gestion des utilisateurs (liste, édition, suppression).
   Dépend de window.settings (currentUser, API_BASE, setButtonLoading).
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const ctx = () => window.settings;
  const API_BASE = '/api';
  let allUsers = [];

  const userFilter = document.getElementById('user-filter');
  const userList = document.getElementById('user-list');

  // -------------------------------------------------------------------
  // Load & display users
  // -------------------------------------------------------------------
  async function loadUsers() {
    try {
      const response = await auth.authFetch(`${API_BASE}/users?limit=100`);

      if (response.ok) {
        const body = await response.json();
        allUsers = Array.isArray(body) ? body : body.data || [];
        displayUsers(allUsers);
        updateUserStats();
      } else if (response.status === 401 || response.status === 403) {
        auth.clearSession();
        showToast(i18n.t('settings.toast_session_expired'), 'error');
        setTimeout(() => { window.location.href = '/login'; }, 1500);
      } else {
        if (userList) {
          userList.innerHTML = `<p style="text-align: center; padding: 2rem; color: var(--text-secondary);">${i18n.t('settings.admin_api_unavailable')}</p>`;
        }
      }
    } catch (err) {
      if (userList) {
        userList.innerHTML = `<p style="text-align: center; padding: 2rem; color: var(--text-secondary);">${i18n.t('settings.toast_users_error')}</p>`;
      }
    }
  }

  function displayUsers(users) {
    if (!userList) return;

    userList.innerHTML = users.map(user => {
      const roleLabel = user.role_id === 1 ? 'Admin' : user.role_id === 2 ? 'Éditeur' : 'Membre';
      const roleBadgeClass = user.role_id === 1 ? 'badge-admin' : user.role_id === 2 ? 'badge-editor' : 'badge-member';
      return `
        <div class="user-card" data-user-id="${user.id}">
          <div class="user-avatar-img">${user.name.charAt(0).toUpperCase()}</div>
          <div class="user-info">
            <div class="user-info-name">${escapeHtml(user.name)}<span class="role-badge ${roleBadgeClass}">${roleLabel}</span></div>
            <div class="user-info-email">${escapeHtml(user.email)}</div>
          </div>
          <div class="user-actions">
            <button class="btn-edit" data-user-id="${user.id}" title="Modifier"><i class="fas fa-pen"></i></button>
            ${user.id !== ctx()?.currentUser?.id ? `<button class="btn-delete" data-user-id="${user.id}" title="Supprimer"><i class="fas fa-trash"></i></button>` : ''}
          </div>
        </div>
      `;
    }).join('');

    document.querySelectorAll('.btn-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        const user = allUsers.find(u => u.id === parseInt(btn.dataset.userId));
        if (user) openEditUserModal(user);
      });
    });
    document.querySelectorAll('.btn-delete').forEach(btn => {
      btn.addEventListener('click', () => deleteUser(btn.dataset.userId));
    });
  }

  function updateUserStats() {
    const totalUsersEl = document.getElementById('total-users');
    if (totalUsersEl) totalUsersEl.textContent = allUsers.length;
  }

  async function deleteUser(userId) {
    if (!confirm(i18n.t('settings.confirm_delete_user'))) return;

    try {
      const response = await auth.authFetch(`${API_BASE}/users/${userId}`, { method: 'DELETE' });

      if (response.ok) {
        showToast(i18n.t('settings.toast_user_deleted'), 'success');
        allUsers = allUsers.filter(u => u.id !== parseInt(userId));
        displayUsers(allUsers);
        updateUserStats();
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

  editUserSave?.addEventListener('click', async () => {
    const name = editUserName.value.trim();
    const email = editUserEmail.value.trim();
    const role_id = parseInt(editUserRole.value);

    if (name.length < 2) {
      showToast('Nom invalide (minimum 2 caractères)', 'error');
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showToast('Adresse email invalide', 'error');
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
        const updated = await response.json();
        allUsers = allUsers.map(u => u.id === editingUserId ? updated : u);
        displayUsers(allUsers);
        closeEditUserModal();
        showToast('Utilisateur modifié avec succès', 'success');
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

  // User search/filter
  if (userFilter) {
    userFilter.addEventListener('input', (e) => {
      const query = e.target.value.toLowerCase();
      const filtered = allUsers.filter(user =>
        user.name.toLowerCase().includes(query) ||
        user.email.toLowerCase().includes(query)
      );
      displayUsers(filtered);
    });
  }

  // Expose loadUsers for settings.js to call after auth check
  window.settingsAdmin = { loadUsers };
});
