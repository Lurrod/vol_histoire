document.addEventListener("DOMContentLoaded", () => {
  // Elements
  const loginForm = document.getElementById("login-form");
  const registerForm = document.getElementById("register-form");
  const switchToRegister = document.getElementById("switch-to-register");
  const switchToLogin = document.getElementById("switch-to-login");
  const loginSlide = document.getElementById("login-slide");
  const registerSlide = document.getElementById("register-slide");
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userDropdown = document.getElementById('user-info-container');
  
  // Password toggle elements
  const toggleLoginPassword = document.getElementById('toggle-login-password');
  const toggleRegisterPassword = document.getElementById('toggle-register-password');
  const loginPassword = document.getElementById('login-password');
  const registerPassword = document.getElementById('register-password');

  // Check required elements
  if (!loginForm || !registerForm || !switchToRegister || !switchToLogin) {
    console.error("Required form elements not found");
    return;
  }

  init();

  function init() {
    setupPasswordToggles();
    setupFormSwitching();
    setupNavigation();
    setupPasswordStrength();
    checkAuthStatus();
    addScrollEffect();
    fetchStats();
  }

  // ========== Stats dynamiques (panneau visuel) ==========
  async function fetchStats() {
    const elAirplanes = document.getElementById('stat-airplanes');
    const elYears = document.getElementById('stat-years');
    const elYearsLabel = document.getElementById('stat-years-label');
    const elCountries = document.getElementById('stat-countries');

    if (!elAirplanes || !elYears || !elCountries) return;

    try {
      const res = await fetch('/api/stats');
      if (!res.ok) throw new Error('Erreur API');

      const data = await res.json();

      // Animate count-up
      animateNumber(elAirplanes, data.airplanes);
      animateNumber(elCountries, data.countries);

      if (data.earliest_year && data.latest_year) {
        elYears.textContent = data.earliest_year;
        elYearsLabel.textContent = 'À nos jours';
      }
    } catch (err) {
      // Fallback statique si l'API n'est pas joignable
      console.warn('Stats API indisponible, utilisation des valeurs par défaut.');
      elAirplanes.textContent = '45+';
      elYears.textContent = '1950';
      elYearsLabel.textContent = 'À nos jours';
      elCountries.textContent = '12';
    }
  }

  function animateNumber(el, target) {
    const duration = 1200;
    const start = performance.now();

    function step(now) {
      const progress = Math.min((now - start) / duration, 1);
      // Ease-out cubic
      const eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.round(eased * target);
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  // ========== Password Toggles ==========
  function setupPasswordToggles() {
    if (toggleLoginPassword && loginPassword) {
      toggleLoginPassword.addEventListener('click', () => {
        togglePasswordVisibility(loginPassword, toggleLoginPassword);
      });
    }
    if (toggleRegisterPassword && registerPassword) {
      toggleRegisterPassword.addEventListener('click', () => {
        togglePasswordVisibility(registerPassword, toggleRegisterPassword);
      });
    }
  }

  function togglePasswordVisibility(input, button) {
    const icon = button.querySelector('i');
    if (input.type === "password") {
      input.type = "text";
      icon.classList.remove("fa-eye-slash");
      icon.classList.add("fa-eye");
    } else {
      input.type = "password";
      icon.classList.remove("fa-eye");
      icon.classList.add("fa-eye-slash");
    }
  }

  // ========== Form Switching (Slide) ==========
  function setupFormSwitching() {
    switchToRegister.addEventListener("click", (e) => {
      e.preventDefault();
      showSlide(registerSlide, loginSlide);
      resetForms();
    });

    switchToLogin.addEventListener("click", (e) => {
      e.preventDefault();
      showSlide(loginSlide, registerSlide);
      resetForms();
    });
  }

  function showSlide(toShow, toHide) {
    toHide.classList.remove('active');
    toShow.classList.add('active');
  }

  function resetForms() {
    loginForm.reset();
    registerForm.reset();
    updatePasswordStrength(0);
  }

  // ========== Navigation ==========
  function setupNavigation() {
    const header = document.querySelector('header');
    const userToggle = document.querySelector('.user-toggle');

    // Scroll effect
    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 100) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }
    }, { passive: true });

    // Mobile menu
    if (hamburger && navLinks) {
      hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        navLinks.classList.toggle('show');
        document.body.style.overflow = navLinks.classList.contains('show') ? 'hidden' : '';
      });

      document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
          navLinks.classList.remove('show');
          hamburger.classList.remove('active');
          document.body.style.overflow = '';
        });
      });

      let resizeTimeout;
      window.addEventListener('resize', () => {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(() => {
          if (window.innerWidth > 992) {
            navLinks.classList.remove('show');
            hamburger.classList.remove('active');
            document.body.style.overflow = '';
          }
        }, 250);
      });

      // Touch gesture
      let touchStartY = 0;
      navLinks.addEventListener('touchstart', (e) => {
        touchStartY = e.touches[0].clientY;
      }, { passive: true });

      navLinks.addEventListener('touchend', (e) => {
        const swipeDistance = touchStartY - e.changedTouches[0].clientY;
        if (swipeDistance > 100) {
          navLinks.classList.remove('show');
          hamburger.classList.remove('active');
          document.body.style.overflow = '';
        }
      }, { passive: true });

      document.addEventListener('click', (e) => {
        if (!hamburger.contains(e.target) && !navLinks.contains(e.target)) {
          hamburger.classList.remove('active');
          navLinks.classList.remove('show');
          document.body.style.overflow = '';
        }
      });
    }

    // User dropdown
    const userToggleElement = userToggle || loginIcon;
    if (userToggleElement && userDropdown) {
      userToggleElement.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        if (userDropdown.classList.contains('show')) {
          userDropdown.classList.remove('show');
          setTimeout(() => userDropdown.classList.add('hidden'), 300);
        } else {
          userDropdown.classList.remove('hidden');
          setTimeout(() => userDropdown.classList.add('show'), 10);
        }
      });

      document.addEventListener('click', (e) => {
        if (!userToggleElement.contains(e.target) && !userDropdown.contains(e.target)) {
          userDropdown.classList.remove('show');
          userDropdown.classList.add('hidden');
        }
      });
    }
  }

  // ========== Password Strength ==========
  function setupPasswordStrength() {
    if (registerPassword) {
      registerPassword.addEventListener('input', () => {
        const strength = calculatePasswordStrength(registerPassword.value);
        updatePasswordStrength(strength);
      });
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

  function updatePasswordStrength(strength) {
    const strengthFill = document.querySelector('.strength-fill');
    const strengthText = document.querySelector('.strength-text');
    
    if (strengthFill && strengthText) {
      strengthFill.style.width = `${strength}%`;
      
      if (strength === 0) {
        strengthText.textContent = 'Force du mot de passe';
        strengthText.style.color = 'var(--text-secondary)';
        strengthFill.style.background = 'transparent';
      } else if (strength < 40) {
        strengthText.textContent = 'Faible';
        strengthText.style.color = 'var(--accent)';
        strengthFill.style.background = 'var(--accent)';
      } else if (strength < 70) {
        strengthText.textContent = 'Moyen';
        strengthText.style.color = 'var(--warning)';
        strengthFill.style.background = 'var(--warning)';
      } else {
        strengthText.textContent = 'Fort';
        strengthText.style.color = 'var(--success)';
        strengthFill.style.background = 'var(--success)';
      }
    }
  }

  // ========== Auth Status ==========
  function checkAuthStatus() {
    const token = localStorage.getItem('token');
    if (token) {
      console.log('User is authenticated');
    }
  }

  // ========== Scroll Effect ==========
  function addScrollEffect() {
    const header = document.querySelector('header');
    if (!header) return;

    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 100) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }
    }, { passive: true });
  }

  // ========== Toast ==========
  function showToast(message, type = 'success', description = '') {
    // Remove existing toasts
    document.querySelectorAll('.toast').forEach(t => t.remove());

    const toast = document.createElement('div');
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
    toast.className = `toast toast-${type}`;
    
    toast.innerHTML = `
      <div class="toast-icon">
        <i class="fas ${icon}"></i>
      </div>
      <div class="toast-content">
        <div class="toast-message">${message}</div>
        ${description ? `<div class="toast-description">${description}</div>` : ''}
      </div>
    `;

    document.body.appendChild(toast);
    setTimeout(() => toast.classList.add('show'), 100);
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 4000);
  }

  // ========== Validation ==========
  function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  function validatePassword(password) {
    return password.length >= 4;
  }

  // ========== Loading State ==========
  function setButtonLoading(button, loading) {
    if (loading) {
      button.disabled = true;
      button.dataset.originalText = button.innerHTML;
      button.innerHTML = '<span class="loading"></span>';
    } else {
      button.disabled = false;
      button.innerHTML = button.dataset.originalText;
    }
  }

  // ========== Login Handler ==========
  loginForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    
    const email = document.getElementById("login-email").value.trim();
    const password = loginPassword.value;
    const submitBtn = loginForm.querySelector('button[type="submit"]');

    if (!validateEmail(email)) {
      showToast('Email invalide', 'error', 'Veuillez entrer une adresse email valide.');
      return;
    }
    if (!validatePassword(password)) {
      showToast('Mot de passe invalide', 'error', 'Le mot de passe doit contenir au moins 4 caractères.');
      return;
    }

    try {
      setButtonLoading(submitBtn, true);

      const response = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password })
      });

      const data = await response.json();

      if (response.ok) {
        localStorage.setItem("token", data.token);
        
        if (data.user) {
          localStorage.setItem("user", JSON.stringify(data.user));
        } else {
          try {
            const payload = JSON.parse(atob(data.token.split('.')[1]));
            const userFromToken = {
              id: payload.id,
              email: payload.email || email,
              name: payload.name || email.split('@')[0],
              role: Number(payload.role)
            };
            localStorage.setItem("user", JSON.stringify(userFromToken));
          } catch (e) {
            const minimalUser = {
              email: email,
              name: email.split('@')[0],
              role: 3
            };
            localStorage.setItem("user", JSON.stringify(minimalUser));
          }
        }
        
        showToast('Connexion réussie', 'success', 'Redirection en cours...');
        setTimeout(() => { window.location.href = "index.html"; }, 1500);
      } else {
        showToast('Erreur de connexion', 'error', data.message || 'Identifiants incorrects.');
        setButtonLoading(submitBtn, false);
      }
    } catch (err) {
      console.error('Login error:', err);
      showToast('Erreur réseau', 'error', 'Impossible de se connecter au serveur.');
      setButtonLoading(submitBtn, false);
    }
  });

  // ========== Register Handler ==========
  registerForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    
    const name = document.getElementById("register-name").value.trim();
    const email = document.getElementById("register-email").value.trim();
    const password = registerPassword.value;
    const acceptTerms = document.getElementById("accept-terms").checked;
    const submitBtn = registerForm.querySelector('button[type="submit"]');

    if (name.length < 2) {
      showToast('Nom invalide', 'error', 'Le nom doit contenir au moins 2 caractères.');
      return;
    }
    if (!validateEmail(email)) {
      showToast('Email invalide', 'error', 'Veuillez entrer une adresse email valide.');
      return;
    }
    if (!validatePassword(password)) {
      showToast('Mot de passe faible', 'error', 'Le mot de passe doit contenir au moins 4 caractères.');
      return;
    }
    if (!acceptTerms) {
      showToast('Conditions requises', 'error', 'Vous devez accepter les conditions d\'utilisation.');
      return;
    }

    try {
      setButtonLoading(submitBtn, true);

      const response = await fetch("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, email, password })
      });

      const data = await response.json();

      if (response.ok) {
        showToast('Compte créé !', 'success', 'Vous pouvez maintenant vous connecter.');
        
        setTimeout(() => {
          showSlide(loginSlide, registerSlide);
          registerForm.reset();
          updatePasswordStrength(0);
          document.getElementById("login-email").value = email;
        }, 1500);
      } else {
        showToast('Erreur d\'inscription', 'error', data.message || 'Impossible de créer le compte.');
        setButtonLoading(submitBtn, false);
      }
    } catch (err) {
      console.error('Register error:', err);
      showToast('Erreur réseau', 'error', 'Impossible de se connecter au serveur.');
      setButtonLoading(submitBtn, false);
    }
  });

  // ========== Logout ==========
  const logoutIcon = document.getElementById('logout-icon');
  if (logoutIcon) {
    logoutIcon.addEventListener('click', (e) => {
      e.preventDefault();
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      showToast('Déconnexion', 'success', 'À bientôt !');
      setTimeout(() => { window.location.reload(); }, 1500);
    });
  }

  // ========== Keyboard Shortcuts ==========
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      if (userDropdown) {
        userDropdown.classList.remove('show');
        userDropdown.classList.add('hidden');
      }
      if (navLinks) {
        navLinks.classList.remove('show');
        hamburger.classList.remove('active');
        document.body.style.overflow = '';
      }
    }
  });

  // Console greeting
  console.log('%c✈ Vol d\'Histoire', 'font-size: 20px; font-weight: bold; color: #00e5ff;');
  console.log('%cBienvenue sur notre plateforme !', 'font-size: 14px; color: #7f8c8d;');
});