document.addEventListener("DOMContentLoaded", () => {
  // ========================================================================
  // INITIALIZATION & UTILITIES
  // ========================================================================
  
  const API_BASE = "/api";
  let currentUser = null;
  let allUsers = [];

  // Toast Notification System
  function showToast(message, type = 'info', duration = 4000) {
    // Remove existing toasts
    document.querySelectorAll('.toast').forEach(t => t.remove());

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    const icon = type === 'success' ? 'check-circle' : 
                 type === 'error' ? 'exclamation-circle' : 
                 'info-circle';
    
    toast.innerHTML = `
      <i class="fas fa-${icon}"></i>
      <span>${message}</span>
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }

  // ========================================================================
  // NAVIGATION & HEADER
  // ========================================================================
  
  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.getElementById('user-info-container');
  const logoutIcon = document.getElementById('logout-icon');

  // Header scroll effect with passive listener
  let lastScroll = 0;
  window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }

    lastScroll = currentScroll;
  }, { passive: true });

  // Mobile menu toggle
  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Close mobile menu on link click (except login icon)
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', (e) => {
      // Ne pas fermer le menu si c'est l'icône de login
      if (link.id === 'login-icon') {
        return;
      }
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close mobile menu on window resize with debouncing
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      if (window.innerWidth > 992) {
        navLinks?.classList.remove('show');
        hamburger?.classList.remove('active');
        document.body.style.overflow = '';
      }
    }, 250); // Debounce resize events
  });

  // User dropdown toggle
  const userToggleElement = userToggle || loginIcon;
  userToggleElement?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    // Toggle the dropdown visibility
    if (userDropdown?.classList.contains('show')) {
      userDropdown.classList.remove('show');
      setTimeout(() => {
        userDropdown.classList.add('hidden');
      }, 300); // Wait for animation to complete
    } else {
      userDropdown?.classList.remove('hidden');
      setTimeout(() => {
        userDropdown?.classList.add('show');
      }, 10); // Small delay for smooth animation
    }
  });

  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!userToggleElement?.contains(e.target) && !userDropdown?.contains(e.target)) {
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
    }
  });

  // Login redirect
  loginIcon?.addEventListener('click', (e) => {
    const token = localStorage.getItem('token');
    if (!token) {
      e.preventDefault();
      window.location.href = 'login.html';
    }
  });

  // Settings navigation
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = 'settings.html';
  });

  // Logout handler - Modal
  const logoutModal = document.getElementById('logout-modal');
  const logoutCancel = document.getElementById('logout-cancel');
  const logoutConfirm = document.getElementById('logout-confirm');

  function openLogoutModal() {
    logoutModal?.classList.remove('hidden');
    requestAnimationFrame(() => {
      logoutModal?.classList.add('show');
    });
  }

  function closeLogoutModal() {
    logoutModal?.classList.remove('show');
    setTimeout(() => {
      logoutModal?.classList.add('hidden');
    }, 300);
  }

  if (logoutIcon) {
    logoutIcon.addEventListener('click', (e) => {
      e.preventDefault();
      openLogoutModal();
    });
  }

  logoutCancel?.addEventListener('click', closeLogoutModal);

  logoutModal?.querySelector('.logout-modal-backdrop')?.addEventListener('click', closeLogoutModal);

  logoutConfirm?.addEventListener('click', async () => {
    try {
      await fetch(`${API_BASE}/logout`, { method: 'POST' });
    } catch (err) {
      console.error('Logout error:', err);
    }
    
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    closeLogoutModal();
    showToast('Déconnexion réussie', 'success');
    
    setTimeout(() => {
      window.location.href = 'login.html';
    }, 1500);
  });

  // Keyboard navigation - ESC to close menus
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
      document.body.style.overflow = '';
      if (logoutModal?.classList.contains('show')) {
        closeLogoutModal();
      }
    }
  });

  /* =========================================================================
     TOUCH GESTURES
     ========================================================================= */

  let touchStartY = 0;
  let touchEndY = 0;

  document.addEventListener('touchstart', (e) => {
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  document.addEventListener('touchend', (e) => {
    touchEndY = e.changedTouches[0].screenY;
    handleSwipe();
  }, { passive: true });

  function handleSwipe() {
    const swipeThreshold = 100;
    const diff = touchStartY - touchEndY;

    // Swipe up to close mobile menu
    if (diff > swipeThreshold && navLinks?.classList.contains('show')) {
      navLinks.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  // ========================================================================
  // SECTION NAVIGATION
  // ========================================================================
  
  const sidebarLinks = document.querySelectorAll('.sidebar-link');
  const contentSections = document.querySelectorAll('.content-section');

  sidebarLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      
      const targetSection = link.dataset.section;
      
      // Update active states
      sidebarLinks.forEach(l => l.classList.remove('active'));
      link.classList.add('active');
      
      contentSections.forEach(section => {
        section.classList.remove('active');
        if (section.id === targetSection) {
          section.classList.add('active');
        }
      });

      // Scroll to top
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  });

  // ========================================================================
  // AUTH CHECK & USER DATA
  // ========================================================================
  
  // Token expiration check utility
  function isTokenExpired(token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      if (!payload.exp) return false;
      return Date.now() >= payload.exp * 1000;
    } catch {
      return true;
    }
  }

  async function checkAuth() {
    const token = localStorage.getItem('token');
    
    if (!token) {
      window.location.href = 'login.html';
      return false;
    }

    // Check if token is expired
    if (isTokenExpired(token)) {
      console.warn('Token expiré, redirection vers login');
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      showToast('Session expirée, veuillez vous reconnecter', 'error');
      setTimeout(() => { window.location.href = 'login.html'; }, 1500);
      return false;
    }

    // Try to get user from localStorage first
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      try {
        currentUser = JSON.parse(storedUser);
        updateUserDisplay();
        
        // Load profile data
        document.getElementById('name').value = currentUser.name || '';
        document.getElementById('email').value = currentUser.email || '';
        
        // Show admin section if user is admin
        if (Number(currentUser.role) === 1) {
          document.getElementById('admin-nav-link').classList.remove('hidden');
          document.getElementById('admin')?.classList.remove('hidden');
          loadUsers();
        }
        
        return true;
      } catch (e) {
        console.error('Error parsing stored user:', e);
      }
    }

    // If no stored user, try API (but don't redirect on failure)
    try {
      const response = await fetch(`${API_BASE}/user`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        currentUser = await response.json();
        localStorage.setItem('user', JSON.stringify(currentUser));
        updateUserDisplay();
        
        // Load profile data
        document.getElementById('name').value = currentUser.name || '';
        document.getElementById('email').value = currentUser.email || '';
        
        // Show admin section if user is admin
        if (Number(currentUser.role) === 1) {
          document.getElementById('admin-nav-link').classList.remove('hidden');
          document.getElementById('admin')?.classList.remove('hidden');
          loadUsers();
        }
        
        return true;
      } else {
        // API failed, but we have a token, so decode JWT for user info
        console.warn('API unavailable, using token-only auth');
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          currentUser = { id: payload.id, name: payload.name || 'Utilisateur', email: payload.email || '', role: Number(payload.role) };
        } catch (e) {
          currentUser = { name: 'Utilisateur', email: '' };
        }
        updateUserDisplay();
        if (Number(currentUser.role) === 1) {
          document.getElementById('admin-nav-link').classList.remove('hidden');
          document.getElementById('admin')?.classList.remove('hidden');
          loadUsers();
        }
        return true;
      }
    } catch (err) {
      // Network error - decode JWT for user info
      console.warn('Network error, using token-only auth:', err);
      try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        currentUser = { id: payload.id, name: payload.name || 'Utilisateur', email: payload.email || '', role: Number(payload.role) };
      } catch (e) {
        currentUser = { name: 'Utilisateur', email: '' };
      }
      updateUserDisplay();
      if (Number(currentUser.role) === 1) {
        document.getElementById('admin-nav-link').classList.remove('hidden');
        document.getElementById('admin')?.classList.remove('hidden');
        loadUsers();
      }
      return true;
    }
  }

  function updateUserDisplay() {
    const userNameElements = document.querySelectorAll('#user-name');
    userNameElements.forEach(el => {
      el.textContent = currentUser?.name || 'Utilisateur';
    });
    
    // Update role display in user menu dropdown
    const userRoleEl = document.querySelector('.user-role');
    if (userRoleEl && currentUser) {
      const role = Number(currentUser.role);
      userRoleEl.textContent = role === 1 ? 'Administrateur' :
                               role === 2 ? 'Éditeur' : 'Membre';
    }
  }

  // ========================================================================
  // PROFILE FORM
  // ========================================================================
  
  const profileForm = document.getElementById('profile-form');
  const resetProfileBtn = document.getElementById('reset-profile-btn');

  if (profileForm) {
    profileForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      const name = document.getElementById('name').value.trim();
      const email = document.getElementById('email').value.trim();
      
      // Validation
      if (name.length < 2) {
        showToast('Le nom doit contenir au moins 2 caractères', 'error');
        return;
      }

      if (!validateEmail(email)) {
        showToast('Adresse email invalide', 'error');
        return;
      }

      const submitBtn = profileForm.querySelector('button[type="submit"]');
      setButtonLoading(submitBtn, true);

      try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/user/update`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify({ name, email })
        });

        const data = await response.json();

        if (response.ok) {
          currentUser = { ...currentUser, name, email };
          localStorage.setItem('user', JSON.stringify(currentUser));
          updateUserDisplay();
          showToast('Profil mis à jour avec succès', 'success');
        } else {
          showToast(data.message || 'Erreur lors de la mise à jour', 'error');
        }
      } catch (err) {
        console.error('Profile update error:', err);
        // Update locally even if API fails
        currentUser = { ...currentUser, name, email };
        localStorage.setItem('user', JSON.stringify(currentUser));
        updateUserDisplay();
        showToast('Profil mis à jour localement (API non disponible)', 'info');
      } finally {
        setButtonLoading(submitBtn, false);
      }
    });
  }

  if (resetProfileBtn) {
    resetProfileBtn.addEventListener('click', () => {
      document.getElementById('name').value = currentUser?.name || '';
      document.getElementById('email').value = currentUser?.email || '';
      showToast('Formulaire réinitialisé', 'info');
    });
  }

  // ========================================================================
  // SECURITY FORM & PASSWORD STRENGTH
  // ========================================================================
  
  const securityForm = document.getElementById('security-form');
  const passwordInput = document.getElementById('password');
  const togglePasswordBtn = document.getElementById('toggle-password');

  // Password visibility toggle
  if (togglePasswordBtn && passwordInput) {
    togglePasswordBtn.addEventListener('click', () => {
      const icon = togglePasswordBtn.querySelector('i');
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
      } else {
        passwordInput.type = 'password';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
      }
    });
  }

  // Password strength indicator
  if (passwordInput) {
    passwordInput.addEventListener('input', () => {
      const password = passwordInput.value;
      updatePasswordStrength(password);
      updatePasswordRequirements(password);
    });
  }

  function updatePasswordStrength(password) {
    const bars = document.querySelectorAll('.strength-bar');
    const strengthText = document.getElementById('strength-text');
    
    if (!bars.length || !strengthText) return;

    const strength = calculatePasswordStrength(password);
    const activeCount = Math.ceil((strength / 100) * 4);

    bars.forEach((bar, index) => {
      bar.classList.remove('active', 'weak', 'medium');
      if (index < activeCount) {
        bar.classList.add('active');
        if (strength < 40) {
          bar.classList.add('weak');
        } else if (strength < 70) {
          bar.classList.add('medium');
        }
      }
    });

    if (password.length === 0) {
      strengthText.textContent = 'Force du mot de passe';
      strengthText.style.color = 'var(--text-secondary)';
    } else if (strength < 40) {
      strengthText.textContent = 'Faible';
      strengthText.style.color = 'var(--accent)';
    } else if (strength < 70) {
      strengthText.textContent = 'Moyen';
      strengthText.style.color = 'var(--warning)';
    } else {
      strengthText.textContent = 'Fort';
      strengthText.style.color = 'var(--success)';
    }
  }

  function calculatePasswordStrength(password) {
    let strength = 0;
    if (password.length >= 4) strength += 20;
    if (password.length >= 6) strength += 20;
    if (password.length >= 8) strength += 20;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 20;
    if (/[0-9]/.test(password)) strength += 10;
    if (/[^a-zA-Z0-9]/.test(password)) strength += 10;
    return Math.min(strength, 100);
  }

  function updatePasswordRequirements(password) {
    const requirements = {
      'req-length': password.length >= 4,
      'req-upper': /[A-Z]/.test(password),
      'req-lower': /[a-z]/.test(password),
      'req-number': /[0-9]/.test(password)
    };

    Object.entries(requirements).forEach(([id, valid]) => {
      const element = document.getElementById(id);
      if (element) {
        if (valid) {
          element.classList.add('valid');
        } else {
          element.classList.remove('valid');
        }
      }
    });
  }

  // Security form submission
  if (securityForm) {
    securityForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      const password = passwordInput.value;
      
      if (!password) {
        showToast('Veuillez entrer un nouveau mot de passe', 'error');
        return;
      }

      if (password.length < 4) {
        showToast('Le mot de passe doit contenir au moins 4 caractères', 'error');
        return;
      }

      const submitBtn = securityForm.querySelector('button[type="submit"]');
      setButtonLoading(submitBtn, true);

      try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/user/password`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify({ password })
        });

        const data = await response.json();

        if (response.ok) {
          showToast('Mot de passe mis à jour avec succès', 'success');
          securityForm.reset();
          updatePasswordStrength('');
          updatePasswordRequirements('');
        } else {
          showToast(data.message || 'Erreur lors de la mise à jour', 'error');
        }
      } catch (err) {
        console.error('Password update error:', err);
        showToast('API non disponible. Connectez votre backend pour changer le mot de passe.', 'error');
      } finally {
        setButtonLoading(submitBtn, false);
      }
    });
  }

  // ========================================================================
  // ADMIN SECTION
  // ========================================================================
  
  const userFilter = document.getElementById('user-filter');
  const userList = document.getElementById('user-list');

  async function loadUsers() {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${API_BASE}/users`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        allUsers = await response.json();
        displayUsers(allUsers);
        updateUserStats();
      } else if (response.status === 401 || response.status === 403) {
        console.warn('Token expiré ou accès refusé:', response.status);
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        showToast('Session expirée, veuillez vous reconnecter', 'error');
        setTimeout(() => { window.location.href = 'login.html'; }, 1500);
      } else {
        console.warn('Failed to load users:', response.status);
        if (userList) {
          userList.innerHTML = '<p style="text-align: center; padding: 2rem; color: var(--text-secondary);">API non disponible. Connectez votre backend pour voir les utilisateurs.</p>';
        }
      }
    } catch (err) {
      console.warn('Network error loading users:', err);
      // Show empty state
      if (userList) {
        userList.innerHTML = '<p style="text-align: center; padding: 2rem; color: var(--text-secondary);">Impossible de charger les utilisateurs. Vérifiez votre connexion.</p>';
      }
    }
  }

  function displayUsers(users) {
    if (!userList) return;

    userList.innerHTML = users.map(user => `
      <div class="user-card" data-user-id="${user.id}">
        <div class="user-avatar-img">
          ${user.name.charAt(0).toUpperCase()}
        </div>
        <div class="user-info">
          <div class="user-info-name">${escapeHtml(user.name)}</div>
          <div class="user-info-email">${escapeHtml(user.email)}</div>
        </div>
        <div class="user-actions">
          ${user.id !== currentUser?.id ? `
            <button class="btn-delete" data-user-id="${user.id}">
              <i class="fas fa-trash"></i>
            </button>
          ` : ''}
        </div>
      </div>
    `).join('');

    // Attach delete handlers
    document.querySelectorAll('.btn-delete').forEach(btn => {
      btn.addEventListener('click', () => deleteUser(btn.dataset.userId));
    });
  }

  function updateUserStats() {
    const totalUsersEl = document.getElementById('total-users');
    if (totalUsersEl) {
      totalUsersEl.textContent = allUsers.length;
    }
  }

  async function deleteUser(userId) {
    if (!confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      return;
    }

    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${API_BASE}/users/${userId}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        showToast('Utilisateur supprimé avec succès', 'success');
        allUsers = allUsers.filter(u => u.id !== parseInt(userId));
        displayUsers(allUsers);
        updateUserStats();
      } else {
        const data = await response.json();
        showToast(data.message || 'Erreur lors de la suppression', 'error');
      }
    } catch (err) {
      console.error('Delete user error:', err);
      showToast('Erreur réseau', 'error');
    }
  }

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

  // ========================================================================
  // DANGER ZONE
  // ========================================================================
  
  const deleteAccountBtn = document.getElementById('delete-account-btn');

  if (deleteAccountBtn) {
    deleteAccountBtn.addEventListener('click', async () => {
      const confirmText = 'SUPPRIMER';
      const userInput = prompt(
        `Cette action est irréversible. Toutes vos données seront définitivement supprimées.\n\n` +
        `Pour confirmer, tapez "${confirmText}" (en majuscules) :`
      );

      if (userInput === confirmText) {
        setButtonLoading(deleteAccountBtn, true);

        try {
          const token = localStorage.getItem('token');
          const response = await fetch(`${API_BASE}/user/delete`, {
            method: 'DELETE',
            headers: {
              'Authorization': `Bearer ${token}`
            }
          });

          if (response.ok) {
            showToast('Compte supprimé avec succès', 'success');
            localStorage.clear();
            
            setTimeout(() => {
              window.location.href = 'index.html';
            }, 2000);
          } else {
            const data = await response.json();
            showToast(data.message || 'Erreur lors de la suppression', 'error');
            setButtonLoading(deleteAccountBtn, false);
          }
        } catch (err) {
          console.error('Delete account error:', err);
          showToast('Erreur réseau', 'error');
          setButtonLoading(deleteAccountBtn, false);
        }
      } else if (userInput !== null) {
        showToast('Confirmation incorrecte', 'error');
      }
    });
  }

  // ========================================================================
  // UTILITY FUNCTIONS
  // ========================================================================
  
  function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  function setButtonLoading(button, loading) {
    if (!button) return;
    
    if (loading) {
      button.disabled = true;
      button.dataset.originalHtml = button.innerHTML;
      button.innerHTML = '<span class="spinner"></span>';
    } else {
      button.disabled = false;
      button.innerHTML = button.dataset.originalHtml;
    }
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // ========================================================================
  // KEYBOARD SHORTCUTS
  // ========================================================================
  
  document.addEventListener('keydown', (e) => {
    // ESC to close dropdowns
    if (e.key === 'Escape') {
      if (userDropdown && userDropdown.classList.contains('show')) {
        userDropdown.classList.remove('show');
        setTimeout(() => userDropdown.classList.add('hidden'), 300);
      }
      if (navLinks && navLinks.classList.contains('show')) {
        navLinks.classList.remove('show');
        hamburger?.classList.remove('active');
      }
    }
  });

  // ========================================================================
  // COOKIE PREFERENCES MANAGEMENT
  // ========================================================================
  
  // Load current cookie preferences
  function loadCookiePreferences() {
    const consent = localStorage.getItem('voldhistoire_cookie_consent');
    if (consent) {
      try {
        const data = JSON.parse(consent);
        const prefs = data.preferences;
        
        // Update toggles
        const analyticsToggle = document.getElementById('pref-analytics');
        const preferenceToggle = document.getElementById('pref-preference');
        
        if (analyticsToggle) {
          analyticsToggle.checked = prefs.analytics || false;
          updateToggleStatus('analytics', prefs.analytics);
        }
        
        if (preferenceToggle) {
          preferenceToggle.checked = prefs.preference || false;
          updateToggleStatus('preference', prefs.preference);
        }
        
        // Update consent date
        const consentDate = document.getElementById('consent-date');
        if (consentDate && data.timestamp) {
          const date = new Date(data.timestamp);
          consentDate.textContent = date.toLocaleDateString('fr-FR', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
          });
        }
      } catch (e) {
        console.error('Error loading cookie preferences:', e);
      }
    }
  }
  
  // Update toggle status label
  function updateToggleStatus(type, isEnabled) {
    const statusElement = document.getElementById(`${type}-status`);
    if (statusElement) {
      statusElement.textContent = isEnabled ? 'Activé' : 'Désactivé';
      statusElement.style.color = isEnabled ? 'var(--success)' : 'var(--text-secondary)';
    }
  }
  
  // Save cookie preferences
  function saveCookiePreferences() {
    const analyticsToggle = document.getElementById('pref-analytics');
    const preferenceToggle = document.getElementById('pref-preference');
    
    const preferences = {
      essential: true,
      analytics: analyticsToggle ? analyticsToggle.checked : false,
      preference: preferenceToggle ? preferenceToggle.checked : false,
      marketing: false
    };
    
    const consentData = {
      preferences: preferences,
      timestamp: new Date().toISOString(),
      version: '1.0'
    };
    
    // Save to localStorage
    localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify(consentData));
    
    // Also set a cookie
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 365);
    document.cookie = `voldhistoire_cookie_consent=true; expires=${expiryDate.toUTCString()}; path=/; SameSite=Lax`;
    
    // Apply consent
    if (window.cookieConsent) {
      window.cookieConsent.preferences = preferences;
      window.cookieConsent.applyConsent();
    }
    
    // Fire custom event
    const event = new CustomEvent('cookieConsent', {
      detail: {
        event: 'preferences_saved',
        preferences: preferences
      }
    });
    document.dispatchEvent(event);
    
    // Update UI
    loadCookiePreferences();
    
    showToast('Vos préférences de cookies ont été enregistrées', 'success');
  }
  
  // Cookie preferences event listeners
  const savePrefsBtn = document.getElementById('save-cookie-preferences');
  const openModalBtn = document.getElementById('open-cookie-modal');
  const analyticsToggle = document.getElementById('pref-analytics');
  const preferenceToggle = document.getElementById('pref-preference');
  
  if (savePrefsBtn) {
    savePrefsBtn.addEventListener('click', saveCookiePreferences);
  }
  
  if (openModalBtn) {
    openModalBtn.addEventListener('click', () => {
      if (window.cookieConsent) {
        window.cookieConsent.openModal();
      } else {
        showToast('Le système de cookies n\'est pas disponible', 'error');
      }
    });
  }
  
  // Update status labels when toggles change
  if (analyticsToggle) {
    analyticsToggle.addEventListener('change', (e) => {
      updateToggleStatus('analytics', e.target.checked);
    });
  }
  
  if (preferenceToggle) {
    preferenceToggle.addEventListener('change', (e) => {
      updateToggleStatus('preference', e.target.checked);
    });
  }
  
  // Listen to external cookie consent changes
  document.addEventListener('cookieConsent', (e) => {
    if (e.detail.event === 'analytics_enabled' || 
        e.detail.event === 'analytics_disabled' ||
        e.detail.event === 'preferences_enabled' ||
        e.detail.event === 'preferences_disabled') {
      loadCookiePreferences();
    }
  });

  // ========================================================================
  // INITIALIZATION
  // ========================================================================
  
  checkAuth();

  // Load cookie preferences on page load
  loadCookiePreferences();

  // Console greeting
  console.log('%c🛩️ Vol d\'Histoire - Settings', 'font-size: 18px; font-weight: bold; color: #3498db;');
  console.log('%cGestion de compte', 'font-size: 14px; color: #2c3e50;');
});