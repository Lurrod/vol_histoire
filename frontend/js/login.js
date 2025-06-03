document.addEventListener("DOMContentLoaded", () => {
  const loginForm = document.getElementById("login-form");
  const registerForm = document.getElementById("register-form");
  const switchToRegister = document.getElementById("switch-to-register");
  const switchToLogin = document.getElementById("switch-to-login");
  const formInner = document.querySelector('.form-inner');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');

  // Nouveaux éléments pour les mots de passe
  const toggleLoginPassword = document.getElementById('toggle-login-password');
  const toggleRegisterPassword = document.getElementById('toggle-register-password');
  const loginPassword = document.getElementById('login-password');
  const registerPassword = document.getElementById('register-password');

  if (
    !loginForm || !registerForm || !switchToRegister || !switchToLogin ||
    !formInner || !hamburger || !navLinks || !toggleLoginPassword ||
    !toggleRegisterPassword || !loginPassword || !registerPassword
  ) {
    console.error("Un ou plusieurs éléments sont introuvables.");
    return;
  }

  // Fonction pour basculer la visibilité du mot de passe
  function togglePasswordVisibility(input, icon) {
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

  // Écouteurs pour les icônes d’œil
  toggleLoginPassword.addEventListener('click', () => {
    togglePasswordVisibility(loginPassword, toggleLoginPassword);
  });

  toggleRegisterPassword.addEventListener('click', () => {
    togglePasswordVisibility(registerPassword, toggleRegisterPassword);
  });

  // Affiche un toast d'erreur (rouge)
  function showError(message) {
    const toast = document.createElement('div');
    toast.className = 'toast-error';
    toast.textContent = message;
    document.body.appendChild(toast);

    // Force repaint pour déclencher la transition
    window.getComputedStyle(toast).opacity;
    toast.classList.add('visible');

    setTimeout(() => {
      toast.classList.remove('visible');
      setTimeout(() => {
        document.body.removeChild(toast);
      }, 500);
    }, 3000);
  }

  // Affiche un toast de succès (vert)
  function showSuccess(message) {
    const toast = document.createElement('div');
    toast.className = 'toast-success';
    toast.textContent = message;
    document.body.appendChild(toast);

    // Force repaint pour déclencher la transition
    window.getComputedStyle(toast).opacity;
    toast.classList.add('visible');

    setTimeout(() => {
      toast.classList.remove('visible');
      setTimeout(() => {
        document.body.removeChild(toast);
      }, 500);
    }, 3000);
  }

  registerForm.classList.remove('hidden');

  switchToRegister.addEventListener("click", () => {
    formInner.classList.add('flipped');
  });
  switchToLogin.addEventListener("click", () => {
    formInner.classList.remove('flipped');
  });

  hamburger.addEventListener('click', () => {
    navLinks.classList.toggle('show');
  });

  loginForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    const email = document.getElementById("login-email").value;
    const password = loginPassword.value;

    try {
      const response = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password })
      });

      const data = await response.json();
      if (response.ok) {
        localStorage.setItem("token", data.token);
        window.location.href = "index.html";
      } else {
        // En cas d'erreur → toast rouge
        showError("Erreur : " + data.message);
      }
    } catch (err) {
      showError("Erreur réseau : impossible de se connecter.");
    }
  });

  registerForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    const name = document.getElementById("register-name").value;
    const email = document.getElementById("register-email").value;
    const password = registerPassword.value;

    try {
      const response = await fetch("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, email, password })
      });

      const data = await response.json();
      if (response.ok) {
        // Remplace alert par toast vert
        showSuccess("Inscription réussie ! Connectez-vous.");
        formInner.classList.remove('flipped');
      } else {
        // Erreur → toast rouge
        showError("Erreur : " + data.message);
      }
    } catch (err) {
      showError("Erreur réseau : impossible de s’inscrire.");
    }
  });
});
