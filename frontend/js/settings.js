document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  // ========================================================================
  // INITIALIZATION & UTILITIES
  // ========================================================================
  
  const API_BASE = "/api";
  let currentUser = null;

  /* showToast → utils.js | navigation → nav.js */

  // Logout handler - Modal (overrides nav.js simple logout)
  const logoutIcon = document.getElementById('logout-icon');
  const logoutModal = document.getElementById('logout-modal');
  const logoutCancel = document.getElementById('logout-cancel');
  const logoutConfirm = document.getElementById('logout-confirm');

  let _logoutTrap = null;
  let _logoutPrevFocus = null;
  function openLogoutModal() {
    _logoutPrevFocus = document.activeElement;
    logoutModal?.classList.remove('hidden');
    requestAnimationFrame(() => {
      logoutModal?.classList.add('show');
      _logoutTrap = trapFocus(logoutModal);
    });
  }

  function closeLogoutModal() {
    _logoutTrap?.destroy();
    _logoutTrap = null;
    logoutModal?.classList.remove('show');
    setTimeout(() => {
      logoutModal?.classList.add('hidden');
    }, 300);
    _logoutPrevFocus?.focus();
  }

  if (logoutIcon) {
    logoutIcon.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopImmediatePropagation();
      openLogoutModal();
    });
  }

  logoutCancel?.addEventListener('click', closeLogoutModal);

  logoutModal?.querySelector('.logout-modal-backdrop')?.addEventListener('click', closeLogoutModal);

  logoutConfirm?.addEventListener('click', async () => {
    await auth.logout();
    closeLogoutModal();
    showToast(i18n.t('common.logout_success'), 'success');
    
    setTimeout(() => {
      window.location.href = '/login';
    }, 1500);
  });

  // Keyboard navigation - ESC to close logout modal (nav handled by nav.js)
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      if (logoutModal?.classList.contains('show')) {
        closeLogoutModal();
      }
    }
  });

  /* touch gestures → nav.js */

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
    const payload = auth.getPayload();
    
    if (!payload) {
      // Try a refresh before giving up
      try {
        await auth.authFetch('/api/stats'); // lightweight call to trigger refresh
      } catch {
        // ignore
      }
      if (!auth.getPayload()) {
        window.location.href = '/login';
        return false;
      }
    }

    // Récupère d'abord les infos utilisateur en mémoire (auth module)
    const cachedUser = auth.getUserInfo();
    if (cachedUser) {
      currentUser = cachedUser;
      updateUserDisplay();

      document.getElementById('name').value = currentUser.name || '';
      document.getElementById('email').value = currentUser.email || '';

      if (Number(currentUser.role) === 1) {
        document.getElementById('admin-nav-link').classList.remove('hidden');
        document.getElementById('admin')?.classList.remove('hidden');
      }

      return true;
    }

    // Sinon, fallback sur l'API
    try {
      const response = await auth.authFetch(`${API_BASE}/users/${auth.getPayload().id}`);

      if (response.ok) {
        currentUser = await response.json();
        auth.setUserInfo(currentUser);
        updateUserDisplay();
        
        document.getElementById('name').value = currentUser.name || '';
        document.getElementById('email').value = currentUser.email || '';
        
        if (Number(currentUser.role) === 1) {
          document.getElementById('admin-nav-link').classList.remove('hidden');
          document.getElementById('admin')?.classList.remove('hidden');
          // loadUsers déplacé dans l'init (via settingsAdmin)
        }
        
        return true;
      } else {
        // API failed, decode JWT for user info
        // API indisponible — authentification par token uniquement
        const p = auth.getPayload();
        currentUser = p ? { id: p.id, name: p.name || 'Utilisateur', email: p.email || '', role: Number(p.role) } : { name: 'Utilisateur', email: '' };
        updateUserDisplay();
        if (Number(currentUser.role) === 1) {
          document.getElementById('admin-nav-link').classList.remove('hidden');
          document.getElementById('admin')?.classList.remove('hidden');
          // loadUsers déplacé dans l'init (via settingsAdmin)
        }
        return true;
      }
    } catch (err) {
      // Erreur réseau — authentification par token uniquement
      const p = auth.getPayload();
      currentUser = p ? { id: p.id, name: p.name || 'Utilisateur', email: p.email || '', role: Number(p.role) } : { name: 'Utilisateur', email: '' };
      updateUserDisplay();
      if (Number(currentUser.role) === 1) {
        document.getElementById('admin-nav-link').classList.remove('hidden');
        document.getElementById('admin')?.classList.remove('hidden');
        // loadUsers déplacé dans l'init (via settingsAdmin)
      }
      return true;
    }
  }

  function updateUserDisplay() {
    const userNameElements = document.querySelectorAll('#user-name');
    userNameElements.forEach(el => {
      el.textContent = currentUser?.name || i18n.t('nav.user_default');
    });
    
    // Update role display in user menu dropdown
    const userRoleEl = document.querySelector('.user-role');
    if (userRoleEl && currentUser) {
      const role = Number(currentUser.role);
      userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') :
                               role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
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
      clearFieldError(document.getElementById('name'));
      clearFieldError(document.getElementById('email'));

      if (name.length < 2) {
        setFieldError(document.getElementById('name'), i18n.t('settings.toast_name_min'));
        return;
      }

      if (!isValidEmail(email)) {
        setFieldError(document.getElementById('email'), i18n.t('settings.toast_email_invalid') || 'Adresse email invalide');
        return;
      }

      const submitBtn = profileForm.querySelector('button[type="submit"]');
      setButtonLoading(submitBtn, true);

      try {
        const response = await auth.authFetch(`${API_BASE}/users/${currentUser.id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, email })
        });

        const data = await response.json();

        if (response.ok) {
          currentUser = { ...currentUser, name, email };
          auth.setUserInfo(currentUser);
          updateUserDisplay();
          showToast(i18n.t('settings.toast_profile_updated'), 'success');
        } else {
          showToast(data.message || i18n.t('settings.toast_profile_error'), 'error');
        }
      } catch (err) {
        // Erreur gérée via toast
        showToast(i18n.t('settings.toast_network_error'), 'error');
      } finally {
        setButtonLoading(submitBtn, false);
      }
    });
  }

  if (resetProfileBtn) {
    resetProfileBtn.addEventListener('click', () => {
      document.getElementById('name').value = currentUser?.name || '';
      document.getElementById('email').value = currentUser?.email || '';
      showToast(i18n.t('settings.toast_form_reset'), 'info');
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
      strengthText.textContent = i18n.t('settings.password_strength');
      strengthText.style.color = 'var(--text-secondary)';
    } else if (strength < 40) {
      strengthText.textContent = i18n.t('settings.strength_weak');
      strengthText.style.color = 'var(--accent)';
    } else if (strength < 70) {
      strengthText.textContent = i18n.t('settings.strength_medium');
      strengthText.style.color = 'var(--warning)';
    } else {
      strengthText.textContent = i18n.t('settings.strength_strong');
      strengthText.style.color = 'var(--success)';
    }
  }

  // calculatePasswordStrength → utils.js

  function updatePasswordRequirements(password) {
    const requirements = {
      'req-length': password.length >= 8,
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
      
      clearFieldError(passwordInput);

      if (!password) {
        setFieldError(passwordInput, 'Veuillez entrer un nouveau mot de passe');
        return;
      }

      if (password.length < 8 || !/[a-z]/.test(password) || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
        setFieldError(passwordInput, i18n.t('settings.toast_password_min'));
        return;
      }

      const submitBtn = securityForm.querySelector('button[type="submit"]');
      setButtonLoading(submitBtn, true);

      try {
        const response = await auth.authFetch(`${API_BASE}/users/${currentUser.id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ password })
        });

        const data = await response.json();

        if (response.ok) {
          showToast(i18n.t('settings.toast_password_updated'), 'success');
          securityForm.reset();
          updatePasswordStrength('');
          updatePasswordRequirements('');
        } else {
          showToast(data.message || i18n.t('settings.toast_profile_error'), 'error');
        }
      } catch (err) {
        // Erreur gérée via toast
        showToast('API non disponible. Connectez votre backend pour changer le mot de passe.', 'error');
      } finally {
        setButtonLoading(submitBtn, false);
      }
    });
  }

  /* ADMIN SECTION → settings-admin.js */

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
          const response = await auth.authFetch(`${API_BASE}/users/${currentUser.id}`, {
            method: 'DELETE',
          });

          if (response.ok) {
            showToast(i18n.t('settings.toast_account_deleted'), 'success');
            await auth.logout();
            
            setTimeout(() => {
              window.location.href = '/';
            }, 2000);
          } else {
            const data = await response.json();
            showToast(data.message || 'Erreur lors de la suppression', 'error');
            setButtonLoading(deleteAccountBtn, false);
          }
        } catch (err) {
          // Erreur gérée via toast
          showToast(i18n.t('settings.toast_network_error'), 'error');
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
  
  // validateEmail → isValidEmail() dans utils.js (même regex que le backend)

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

  /* escapeHtml → utils.js | keyboard shortcuts → nav.js */

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
          consentDate.textContent = date.toLocaleDateString(i18n.currentLang === 'en' ? 'en-GB' : 'fr-FR', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
          });
        }
      } catch (e) {
        // Erreur silencieuse — préférences cookies
      }
    }
  }
  
  // Update toggle status label
  function updateToggleStatus(type, isEnabled) {
    const statusElement = document.getElementById(`${type}-status`);
    if (statusElement) {
      statusElement.textContent = isEnabled ? i18n.t('settings.enabled') : i18n.t('settings.disabled');
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
    
    showToast(i18n.t('settings.toast_cookies_saved'), 'success');
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

  /* DASHBOARD → settings-dashboard.js */

  // ========================================================================
  // INITIALIZATION
  // ========================================================================

  // Exposer le contexte partagé pour les sous-modules
  window.settings = {
    get currentUser() { return currentUser; },
    setButtonLoading,
  };

  checkAuth().then(() => {
    // Charger admin si rôle admin
    if (Number(currentUser?.role) === 1) {
      window.settingsAdmin?.loadUsers();
    }
    window.settingsDashboard?.loadDashboard();
  });

  // Load cookie preferences on page load
  loadCookiePreferences();

});