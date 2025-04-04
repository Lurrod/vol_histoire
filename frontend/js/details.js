document.addEventListener('DOMContentLoaded', () => {
    const airplaneInfo = document.getElementById('airplane-info');
    const armementList = document.getElementById('armement-list');
    const guerresList = document.getElementById('guerres-list');
    const techList = document.getElementById('tech-list');
    const missionsList = document.getElementById('missions-list');
    const editButton = document.getElementById('edit-airplane-btn');
    const deleteButton = document.getElementById('delete-airplane-btn');
    const modal = document.getElementById('edit-modal');
    const closeModal = document.querySelector('.close-btn');
    const editForm = document.getElementById('edit-form');
    const loginIcon = document.getElementById("login-icon");
    const userToggle = document.querySelector(".user-toggle");
    const userDropdown = document.getElementById("user-info-container");

    const urlParams = new URLSearchParams(window.location.search);
    const airplaneId = urlParams.get('id');
    const token = localStorage.getItem("token");

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

    // Fonctions pour remplir les menus déroulants
    async function populateCountriesSelect(currentCountryId) {
        const select = document.getElementById("edit-country-id");
        try {
            const response = await fetch("/api/countries");
            const countries = await response.json();
            countries.forEach(country => {
                const option = document.createElement("option");
                option.value = country.id;
                option.textContent = country.name;
                if (country.id === currentCountryId) option.selected = true;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des pays:", error);
        }
    }

    async function populateManufacturersSelect(currentManufacturerId) {
        const select = document.getElementById("edit-manufacturer-id");
        try {
            const response = await fetch("/api/manufacturers");
            const manufacturers = await response.json();
            manufacturers.forEach(manufacturer => {
                const option = document.createElement("option");
                option.value = manufacturer.id;
                option.textContent = manufacturer.name;
                if (manufacturer.id === currentManufacturerId) option.selected = true;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des fabricants:", error);
        }
    }

    async function populateGenerationsSelect(currentGeneration) {
        const select = document.getElementById("edit-generation-id");
        try {
            const response = await fetch("/api/generations");
            const generations = await response.json();
            generations.forEach(generation => {
                const option = document.createElement("option");
                option.value = generation;
                option.textContent = `Génération ${generation}`;
                if (generation === currentGeneration) option.selected = true;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des générations:", error);
        }
    }

    async function populateTypesSelect(currentTypeId) {
        const select = document.getElementById("edit-type");
        try {
            const response = await fetch("/api/types");
            const types = await response.json();
            types.forEach(type => {
                const option = document.createElement("option");
                option.value = type.id;
                option.textContent = type.name;
                if (type.id === currentTypeId) option.selected = true;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des types:", error);
        }
    }

    if (token) {
        try {
            const payload = JSON.parse(atob(token.split(".")[1]));
            const userRole = payload.role;

            if (userRole === 1 || userRole === 2) {
                editButton.classList.remove("hidden");
                editButton.style.display = "block";
                deleteButton.classList.remove("hidden");
                deleteButton.style.display = "block";

                editButton.addEventListener("click", async () => {
                    modal.classList.remove("hidden");
                    modal.classList.add("show");

                    // Charger les données de l'avion et pré-remplir le formulaire
                    const response = await fetch(`/api/airplanes/${airplaneId}`);
                    const airplane = await response.json();

                    document.getElementById("edit-name").value = airplane.name;
                    document.getElementById("edit-complete-name").value = airplane.complete_name;
                    document.getElementById("edit-little-description").value = airplane.little_description;
                    document.getElementById("edit-image-url").value = airplane.image_url;
                    document.getElementById("edit-description").value = airplane.description;
                    document.getElementById("edit-date-concept").value = airplane.date_concept || '';
                    document.getElementById("edit-date-first-fly").value = airplane.date_first_fly || '';
                    document.getElementById("edit-date-operationel").value = airplane.date_operationel || '';
                    document.getElementById("edit-max-speed").value = airplane.max_speed || '';
                    document.getElementById("edit-max-range").value = airplane.max_range || '';
                    document.getElementById("edit-weight").value = airplane.weight || '';
                    document.getElementById("edit-status").value = airplane.status;

                    // Vider les menus déroulants précédents pour éviter les doublons
                    document.getElementById("edit-country-id").innerHTML = '<option value="">Choisir un pays</option>';
                    document.getElementById("edit-manufacturer-id").innerHTML = '<option value="">Choisir un fabricant</option>';
                    document.getElementById("edit-generation-id").innerHTML = '<option value="">Choisir une génération</option>';
                    document.getElementById("edit-type").innerHTML = '<option value="">Choisir un type</option>';

                    // Remplir les menus déroulants avec les valeurs actuelles sélectionnées
                    await Promise.all([
                        populateCountriesSelect(airplane.country_id),
                        populateManufacturersSelect(airplane.id_manufacturer),
                        populateGenerationsSelect(airplane.generation),
                        populateTypesSelect(airplane.type)
                    ]);
                });

                closeModal.addEventListener("click", () => {
                    modal.classList.remove("show");
                });

                editForm.addEventListener("submit", async (event) => {
                    event.preventDefault();

                    const updatedData = {
                        name: document.getElementById("edit-name").value,
                        complete_name: document.getElementById("edit-complete-name").value,
                        little_description: document.getElementById("edit-little-description").value,
                        image_url: document.getElementById("edit-image-url").value,
                        description: document.getElementById("edit-description").value,
                        date_concept: document.getElementById("edit-date-concept").value || null,
                        date_first_fly: document.getElementById("edit-date-first-fly").value || null,
                        date_operationel: document.getElementById("edit-date-operationel").value || null,
                        max_speed: parseFloat(document.getElementById("edit-max-speed").value) || null,
                        max_range: parseFloat(document.getElementById("edit-max-range").value) || null,
                        weight: parseFloat(document.getElementById("edit-weight").value) || null,
                        status: document.getElementById("edit-status").value,
                        country_id: parseInt(document.getElementById("edit-country-id").value) || null,
                        id_manufacturer: parseInt(document.getElementById("edit-manufacturer-id").value) || null,
                        id_generation: parseInt(document.getElementById("edit-generation-id").value) || null,
                        type: parseInt(document.getElementById("edit-type").value) || null
                    };

                    try {
                        const response = await fetch(`/api/airplanes/${airplaneId}`, {
                            method: "PUT",
                            headers: {
                                "Content-Type": "application/json",
                                "Authorization": `Bearer ${token}`
                            },
                            body: JSON.stringify(updatedData)
                        });

                        if (response.ok) {
                            alert("Modifications enregistrées !");
                            modal.classList.remove("show");
                            location.reload();
                        } else {
                            const error = await response.json();
                            alert(`Erreur lors de la mise à jour : ${error.message || "Erreur inconnue"}`);
                        }
                    } catch (error) {
                        console.error("Erreur lors de la mise à jour :", error);
                        alert("Impossible d'enregistrer les modifications.");
                    }
                });

                deleteButton.addEventListener("click", async () => {
                    if (!airplaneId) {
                        alert("Erreur : ID de l'avion introuvable.");
                        return;
                    }

                    if (confirm("Voulez-vous vraiment supprimer cet avion ? Cette action est irréversible.")) {
                        try {
                            const response = await fetch(`/api/airplanes/${airplaneId}`, {
                                method: "DELETE",
                                headers: {
                                    "Authorization": `Bearer ${token}`
                                }
                            });

                            if (!response.ok) {
                                throw new Error("Erreur lors de la suppression.");
                            }

                            alert("Avion supprimé avec succès.");
                            window.location.href = "hangar.html";
                        } catch (error) {
                            console.error("Erreur:", error);
                            alert("Impossible de supprimer cet avion.");
                        }
                    }
                });
            }
        } catch (error) {
            console.error("Erreur lors de la lecture du token:", error);
        }
    }

    function formatDate(dateString) {
        if (!dateString) return 'Date inconnue';
        const date = new Date(dateString);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
    }

    async function fetchAirplaneDetails() {
        if (!airplaneId) {
            airplaneInfo.innerHTML = '<p>Aucun avion sélectionné.</p>';
            return;
        }

        try {
            const [airplane, armament, wars, tech, missions] = await Promise.all([
                fetch(`/api/airplanes/${airplaneId}`).then(res => res.json()),
                fetch(`/api/airplanes/${airplaneId}/armament`).then(res => res.json()),
                fetch(`/api/airplanes/${airplaneId}/wars`).then(res => res.json()),
                fetch(`/api/airplanes/${airplaneId}/tech`).then(res => res.json()),
                fetch(`/api/airplanes/${airplaneId}/missions`).then(res => res.json())
            ]);

            displayAirplaneDetails(airplane, armament, wars, tech, missions);
        } catch (error) {
            console.error('Erreur:', error);
            airplaneInfo.innerHTML = '<p>Erreur lors du chargement des détails de l\'avion.</p>';
        }
    }

    function displayAirplaneDetails(airplane, armament, wars, tech, missions) {
        airplaneInfo.innerHTML = `
            <h2>${airplane.complete_name}</h2>
            <img src="${airplane.image_url}" alt="${airplane.name}" class="hero-image">
            <p><strong>Description : </strong> ${airplane.description}</p>
            <p><strong>Pays d'origine : </strong> ${airplane.country_name}</p>
            <p><strong>Constructeur : </strong> ${airplane.manufacturer_name}</p>
            <p><strong>Génération : </strong> ${airplane.generation}</p>
            <p><strong>Type : </strong> ${airplane.type_name}</p>
            <p><strong>Date de conception : </strong> ${formatDate(airplane.date_concept)}</p>
            <p><strong>Premier vol : </strong> ${formatDate(airplane.date_first_fly)}</p>
            <p><strong>Date de mise en service : </strong> ${formatDate(airplane.date_operationel)}</p>
            <p><strong>Vitesse maximale : </strong> ${airplane.max_speed} km/h</p>
            <p><strong>Portée maximale : </strong> ${airplane.max_range} km</p>
            <p><strong>Statut : </strong> ${airplane.status}</p>
            <p><strong>Poids : </strong> ${airplane.weight} kg</p>
        `;

        armament.forEach(weapon => {
            armementList.innerHTML += `
                <li>
                    <strong>${weapon.name}</strong>
                    <p>${weapon.description}</p>
                </li>
            `;
        });

        tech.forEach(technology => {
            techList.innerHTML += `
                <li>
                    <strong>${technology.name}</strong>
                    <p>${technology.description}</p>
                </li>
            `;
        });

        wars.forEach(war => {
            guerresList.innerHTML += `
                <div class="war-event">
                    <h4>${war.name}</h4>
                    <p>${formatDate(war.date_start)} <i class="fas fa-arrow-right"></i> ${formatDate(war.date_end)}</p>
                    <p>${war.description}</p>
                </div>
            `;
        });

        missions.forEach(mission => {
            missionsList.innerHTML += `
                <div class="mission-item">
                    <h4>${mission.name}</h4>
                    <p>${mission.description}</p>
                </div>
            `;
        });
    }

    fetchAirplaneDetails();
});