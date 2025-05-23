document.addEventListener("DOMContentLoaded", () => {
  const loginForm = document.getElementById("login-form");
  const registerForm = document.getElementById("register-form");
  const switchToRegister = document.getElementById("switch-to-register");
  const switchToLogin = document.getElementById("switch-to-login");
  const formInner = document.querySelector('.form-inner');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');

  if (!loginForm || !registerForm || !switchToRegister || !switchToLogin || !formInner || !hamburger || !navLinks) {
    console.error("Un ou plusieurs éléments sont introuvables.");
    return;
  }

  function showError(message) {
    const toast = document.createElement('div');
    toast.className = 'toast-error';
    toast.textContent = message;
    document.body.appendChild(toast);

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
    const password = document.getElementById("login-password").value;

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
      showError("Erreur : " + data.message);
    }
  });

  registerForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    const name = document.getElementById("register-name").value;
    const email = document.getElementById("register-email").value;
    const password = document.getElementById("register-password").value;

    const response = await fetch("/api/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, email, password })
    });

    const data = await response.json();
    if (response.ok) {
      alert("Inscription réussie ! Connectez-vous.");
      formInner.classList.remove('flipped');
    } else {
      showError("Erreur : " + data.message);
    }
  });
});