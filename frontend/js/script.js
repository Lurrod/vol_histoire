document.addEventListener("DOMContentLoaded", () => {
  const loginIcon = document.getElementById("login-icon");
  const userToggle = document.querySelector(".user-toggle");
  const userDropdown = document.querySelector(".user-dropdown");

  // Gestion de l'état de connexion
  const updateAuthUI = () => {
  const token = localStorage.getItem("token");

  loginIcon.addEventListener("click", (e) => {
    const token = localStorage.getItem("token");
    
    if (!token) {
      e.preventDefault();
      window.location.href = "login.html";
    }
  })
    
    
    if (token) {
      try {
        const payload = JSON.parse(atob(token.split(".")[1]));
        document.getElementById("user-name").textContent = payload.name;
        document.querySelector(".user-role").textContent = 
          payload.role === 1 ? "Administrateur" : 
          payload.role === 2 ? "Éditeur" : "Membre";  
        userDropdown.classList.remove("hidden");
      } catch (error) {
        console.error("Token error:", error);
        localStorage.removeItem("token");
      }
    }
  };

  // Gestion du dropdown
  userToggle?.addEventListener("click", (e) => {
    e.preventDefault();
    userDropdown.classList.toggle("show");
  });

  // Fermer le dropdown en cliquant ailleurs
  document.addEventListener("click", (e) => {
    if (!userToggle?.contains(e.target)) {
      userDropdown?.classList.remove("show");
    }
  });

  // Gestion déconnexion
  document.getElementById("logout-icon")?.addEventListener("click", (e) => {
    e.preventDefault();
    localStorage.removeItem("token");
    window.location.href = "index.html";
  });

  document.getElementById("settings-icon")?.addEventListener("click", (e) => {
    e.preventDefault();
    window.location.href = "settings.html";
  });

  // Initialisation
  updateAuthUI();
});