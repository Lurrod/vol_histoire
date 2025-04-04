document.addEventListener("DOMContentLoaded", async () => {
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
      });
  
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
  
    // Redirection vers les paramètres
    document.getElementById("settings-icon")?.addEventListener("click", (e) => {
      e.preventDefault();
      window.location.href = "settings.html";
    });
  
    // Initialisation
    updateAuthUI();
  
    // Vérifier la présence du token
    const token = localStorage.getItem("token");
    if (!token) {
      alert("Vous devez être connecté pour accéder aux paramètres.");
      window.location.href = "login.html";
      return;
    }
  
    // Décoder le token pour récupérer l'ID de l'utilisateur
    let userId;
    try {
      const payload = JSON.parse(atob(token.split(".")[1]));
      userId = payload.id;
    } catch (error) {
      console.error("Erreur lors du décodage du token :", error);
      alert("Session invalide, veuillez vous reconnecter.");
      localStorage.removeItem("token");
      window.location.href = "login.html";
      return;
    }
  
    // Récupérer les informations de l'utilisateur via une requête GET
    try {
      const response = await fetch(`/api/users/${userId}`, {
        headers: {
          "Authorization": `Bearer ${token}`
        }
      });
      if (!response.ok) {
        throw new Error("Impossible de charger les informations utilisateur.");
      }
      const userData = await response.json();
      document.getElementById("name").value = userData.name;
      document.getElementById("email").value = userData.email;
    } catch (error) {
      console.error("Erreur :", error);
      alert("Erreur lors du chargement des informations.");
    }
  
    // Gestion de la soumission du formulaire de mise à jour
    document.getElementById("settings-form").addEventListener("submit", async (e) => {
      e.preventDefault();
  
      const name = document.getElementById("name").value;
      const email = document.getElementById("email").value;
      const password = document.getElementById("password").value;
  
      // Préparer les données à mettre à jour (le mot de passe est envoyé seulement s'il est renseigné)
      const updatedData = { name, email };
      if (password) updatedData.password = password;
  
      try {
        const response = await fetch(`/api/users/${userId}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
          },
          body: JSON.stringify(updatedData)
        });
  
        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.message || "Erreur lors de la mise à jour.");
        }
  
        alert("Modifications enregistrées avec succès !");
        window.location.reload();
      } catch (error) {
        console.error("Erreur :", error);
        alert(error.message);
      }
    });
  
    // Gestion de la suppression du compte
    document.getElementById("delete-account-btn").addEventListener("click", async () => {
      if (confirm("Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible.")) {
        try {
          const response = await fetch(`/api/users/${userId}`, {
            method: "DELETE",
            headers: {
              "Authorization": `Bearer ${token}`
            }
          });
  
          if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.message || "Erreur lors de la suppression.");
          }
  
          alert("Votre compte a été supprimé avec succès.");
          localStorage.removeItem("token");
          window.location.href = "index.html";
        } catch (error) {
          console.error("Erreur :", error);
          alert(error.message);
        }
      }
    });
  
    // Vérifier si l'utilisateur est admin
    if (token) {
      try {
        const payload = JSON.parse(atob(token.split(".")[1]));
        if (payload.role === 1) {
          document.getElementById("admin-section").classList.remove("hidden");
          await loadUsers();
        }
      } catch (error) {
        console.error("Erreur lors du décodage du token :", error);
      }
    }
  
    // Fonction pour charger la liste des utilisateurs
    async function loadUsers() {
      try {
        const response = await fetch("/api/users", {
          headers: {
            "Authorization": `Bearer ${token}`
          }
        });
        if (!response.ok) {
          throw new Error("Impossible de charger la liste des utilisateurs.");
        }
        const users = await response.json();
        displayUsers(users);
      } catch (error) {
        console.error("Erreur :", error);
        alert("Erreur lors du chargement des utilisateurs.");
      }
    }
  
    // Fonction pour afficher la liste des utilisateurs
    function displayUsers(users) {
      const userList = document.getElementById("user-list");
      userList.innerHTML = "";
      users.forEach(user => {
        const userDiv = document.createElement("div");
        userDiv.classList.add("user-item");
        userDiv.innerHTML = `
          <h3>${user.name} (${user.email})</h3>
          <form class="update-user-form" data-id="${user.id}">
            <div class="form-group">
              <label for="name-${user.id}">Nom :</label>
              <input type="text" id="name-${user.id}" value="${user.name}" required>
            </div>
            <div class="form-group">
              <label for="role-${user.id}">Rôle :</label>
              <select id="role-${user.id}" required>
                <option value="1" ${user.role_id === 1 ? "selected" : ""}>Administrateur</option>
                <option value="2" ${user.role_id === 2 ? "selected" : ""}>Éditeur</option>
                <option value="3" ${user.role_id === 3 ? "selected" : ""}>Membre</option>
              </select>
            </div>
            <button type="submit" class="btn">Modifier</button>
          </form>
        `;
        userList.appendChild(userDiv);
      });
  
      // Ajouter des écouteurs d'événements pour les formulaires de modification
      document.querySelectorAll(".update-user-form").forEach(form => {
        form.addEventListener("submit", async (e) => {
          e.preventDefault();
          const userId = form.dataset.id;
          const name = document.getElementById(`name-${userId}`).value;
          const role_id = document.getElementById(`role-${userId}`).value;
  
          try {
            const response = await fetch(`/api/users/${userId}`, {
              method: "PUT",
              headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
              },
              body: JSON.stringify({ name, role_id })
            });
  
            if (!response.ok) {
              const errorData = await response.json();
              throw new Error(errorData.message || "Erreur lors de la mise à jour.");
            }
  
            alert("Utilisateur mis à jour avec succès !");
            await loadUsers();
          } catch (error) {
            console.error("Erreur :", error);
            alert(error.message);
          }
        });
      });
    }
  });