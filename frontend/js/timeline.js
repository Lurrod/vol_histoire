document.addEventListener('DOMContentLoaded', async () => {
    const loginIcon = document.getElementById("login-icon");
    const userToggle = document.querySelector(".user-toggle");
    const userDropdown = document.getElementById("user-info-container");

    // Vérifier si un token JWT est stocké
    const token = localStorage.getItem("token");

    const updateAuthUI = () => {
        const token = localStorage.getItem("token");
    
        // Redirige vers login si non authentifié lors du clic sur l'icône
        loginIcon.addEventListener("click", (e) => {
          if (!token) {
            e.preventDefault();
            window.location.href = "login.html";
          }
        });
        
        if (token) {
          try {
            const payload = JSON.parse(atob(token.split(".")[1]));
            // Met à jour le nom et le rôle de l'utilisateur dans le dropdown
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
    
      // Permet d'ouvrir/fermer le dropdown lors du clic sur le conteneur utilisateur
      userToggle.addEventListener("click", (e) => {
        e.preventDefault();
        userDropdown.classList.toggle("show");
      });
    
      // Ferme le dropdown si l'utilisateur clique en dehors
      document.addEventListener("click", (e) => {
        if (!userToggle.contains(e.target)) {
          userDropdown.classList.remove("show");
        }
      });

      document.getElementById("settings-icon")?.addEventListener("click", (e) => {
        e.preventDefault();
        window.location.href = "settings.html";
      });
      
      // Gestion de la déconnexion
      document.getElementById("logout-icon").addEventListener("click", (e) => {
        e.preventDefault();
        localStorage.removeItem("token");
        window.location.href = "hangar.html";
      });
    
      updateAuthUI();

    try {
      // Récupérer la première page pour obtenir le nombre total de pages
      const page1Response = await fetch('/api/airplanes?sort=service-date&page=1');
      const page1Data = await page1Response.json();
      let airplanes = page1Data.data;
      const totalPages = page1Data.pagination.totalPages;
  
      // Si plus d'une page, récupérer les pages restantes en parallèle
      if (totalPages > 1) {
        const fetchPromises = [];
        for (let i = 2; i <= totalPages; i++) {
          fetchPromises.push(fetch(`/api/airplanes?sort=service-date&page=${i}`));
        }
        const responses = await Promise.all(fetchPromises);
        const pagesData = await Promise.all(responses.map(res => res.json()));
        pagesData.forEach(pageData => {
          airplanes = airplanes.concat(pageData.data);
        });
      }
  
      // Trier les avions par date d'entrée en service (du plus ancien au plus récent)
      airplanes.sort((a, b) => new Date(a.date_operationel) - new Date(b.date_operationel));
  
      const timelineContainer = document.getElementById('timeline-container');
  
      // Création des événements de la timeline en alternant la position (gauche/droite)
      airplanes.forEach((airplane, index) => {
        const eventDiv = document.createElement('div');
        eventDiv.classList.add('timeline-event');
        eventDiv.classList.add(index % 2 === 0 ? 'left' : 'right');
  
        // Création du contenu de l'événement
        const contentDiv = document.createElement('div');
        contentDiv.classList.add('timeline-content');
  
        const dateElem = document.createElement('p');
        dateElem.classList.add('timeline-date');
        dateElem.textContent = new Date(airplane.date_operationel).toLocaleDateString();
  
        const titleElem = document.createElement('h3');
        titleElem.textContent = airplane.name;
  
        const descElem = document.createElement('p');
        descElem.textContent = airplane.little_description || "";
  
        // Assemblage du contenu
        contentDiv.appendChild(dateElem);
        contentDiv.appendChild(titleElem);
        contentDiv.appendChild(descElem);
  
        // Redirection vers la page de détails lors du clic sur l'événement
        contentDiv.addEventListener('click', () => {
          window.location.href = `details.html?id=${airplane.id}`;
        });
  
        eventDiv.appendChild(contentDiv);
        timelineContainer.appendChild(eventDiv);
      });
    } catch (error) {
      console.error("Erreur lors du chargement de la timeline :", error);
      document.getElementById('timeline-container').innerHTML = "<p>Erreur lors du chargement des données.</p>";
    }
  });
  