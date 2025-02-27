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

    // Récupérer l'ID de l'avion depuis l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const airplaneId = urlParams.get('id');

    const token = localStorage.getItem("token");

    if (token) {
        try {
            const payload = JSON.parse(atob(token.split(".")[1]));
            const userRole = payload.role;

            if (userRole === 1 || userRole === 2) {
                // Afficher les boutons Modifier et Supprimer
                editButton.classList.remove("hidden");
                editButton.style.display = "block";
                deleteButton.classList.remove("hidden");
                deleteButton.style.display = "block";

                // Ouvrir la modale
                editButton.addEventListener("click", async () => {
                    modal.classList.add("show");

                    // Charger les données de l'avion et pré-remplir le formulaire
                    const response = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}`);
                    const airplane = await response.json();

                    document.getElementById("edit-name").value = airplane.name;
                    document.getElementById("edit-complete-name").value = airplane.complete_name;
                    document.getElementById("edit-little-description").value = airplane.little_description;
                    document.getElementById("edit-image-url").value = airplane.image_url;
                    document.getElementById("edit-description").value = airplane.description;
                    document.getElementById("edit-date-concept").value = airplane.date_concept;
                    document.getElementById("edit-date-first-fly").value = airplane.date_first_fly;
                    document.getElementById("edit-date-operationel").value = airplane.date_operationel;
                    document.getElementById("edit-max-speed").value = airplane.max_speed;
                    document.getElementById("edit-max-range").value = airplane.max_range;
                    document.getElementById("edit-weight").value = airplane.weight;
                    document.getElementById("edit-status").value = airplane.status;
                });

                // Fermer la modale
                closeModal.addEventListener("click", () => {
                    modal.classList.remove("show");
                });

                // Envoyer les modifications
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
                        status: document.getElementById("edit-status").value
                    };

                    try {
                        const response = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}`, {
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
                            alert("Erreur lors de la mise à jour.");
                        }
                    } catch (error) {
                        console.error("Erreur lors de la mise à jour :", error);
                        alert("Impossible d'enregistrer les modifications.");
                    }
                });

                // Suppression de l'avion
                deleteButton.addEventListener("click", async () => {
                    console.log("Bouton supprimer cliqué"); // Vérification
                    console.log("ID avion :", airplaneId);

                    if (!airplaneId) {
                        alert("Erreur : ID de l'avion introuvable.");
                        return;
                    }

                    if (confirm("Voulez-vous vraiment supprimer cet avion ? Cette action est irréversible.")) {
                        try {
                            const response = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}`, {
                                method: "DELETE",
                                headers: {
                                    "Authorization": `Bearer ${token}`
                                }
                            });

                            if (!response.ok) {
                                throw new Error("Erreur lors de la suppression.");
                            }

                            alert("Avion supprimé avec succès.");
                            window.location.href = "index.html";

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


    // Fonction pour formater les dates au format dd/mm/aaaa
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
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/armament`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/wars`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/tech`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/missions`).then(res => res.json())
            ]);

            displayAirplaneDetails(airplane, armament, wars, tech, missions);
        } catch (error) {
            console.error('Erreur:', error);
            airplaneInfo.innerHTML = '<p>Erreur lors du chargement des détails de l\'avion.</p>';
        }
    }

    function displayAirplaneDetails(airplane, armament, wars, tech, missions) {
        // Afficher les informations de base de l'avion
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

        // Afficher l'armement de l'avion
        armament.forEach(weapon => {
            armementList.innerHTML += `
                <li>
                    <strong>${weapon.name}</strong>
                    <p>${weapon.description}</p>
                </li>
            `;
        });

        // Afficher les technologies de l'avion
        tech.forEach(technology => {
            techList.innerHTML += `
                <li>
                    <strong>${technology.name}</strong>
                    <p>${technology.description}</p>
                </li>
            `;
        });

        // Afficher les guerres auxquelles l'avion a participé
        wars.forEach(war => {
            guerresList.innerHTML += `
                <div class="war-event">
                    <h4>${war.name}</h4>
                    <p>${formatDate(war.date_start)} <i class="fas fa-arrow-right"></i> ${formatDate(war.date_end)}</p>
                    <p>${war.description}</p>
                </div>
            `;
        });

        // Afficher les missions de l'avion
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