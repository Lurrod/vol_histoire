document.addEventListener('DOMContentLoaded', () => {
    const airplaneInfo = document.getElementById('airplane-info');

    // Récupérer l'ID de l'avion depuis l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const airplaneId = urlParams.get('id');

    // Fonction pour récupérer les détails de l'avion depuis l'API
    async function fetchAirplaneDetails() {
        if (!airplaneId) {
            airplaneInfo.innerHTML = '<p>Aucun avion sélectionné.</p>';
            return;
        }

        try {
            // Récupérer les détails de base de l'avion
            const response = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}`);
            if (!response.ok) {
                throw new Error('Erreur lors de la récupération des détails de l\'avion');
            }
            const airplane = await response.json();

            // Récupérer l'armement de l'avion
            const armamentResponse = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}/armament`);
            const armament = await armamentResponse.json();

            // Récupérer les technologies de l'avion
            const techResponse = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}/tech`);
            const tech = await techResponse.json();

            // Récupérer les guerres auxquelles l'avion a participé
            const warsResponse = await fetch(`http://localhost:3000/api/airplanes/${airplaneId}/wars`);
            const wars = await warsResponse.json();

            // Afficher les détails de l'avion
            displayAirplaneDetails(airplane, armament, tech, wars);
        } catch (error) {
            console.error('Erreur:', error);
            airplaneInfo.innerHTML = '<p>Erreur lors du chargement des détails de l\'avion.</p>';
        }
    }

    // Fonction pour afficher les détails de l'avion
    function displayAirplaneDetails(airplane, armament, tech, wars) {
        // Afficher les informations de base de l'avion
        airplaneInfo.innerHTML = `
            <h2>${airplane.complete_name}</h2>
            <img src="${airplane.image_url}" alt="${airplane.name}" style="max-width: 100%; height: auto;">
            <p><strong>Description:</strong> ${airplane.description}</p>
            <p><strong>Pays d'origine:</strong> ${airplane.country_name}</p>
            <p><strong>Constructeur:</strong> ${airplane.manufacturer_name}</p>
            <p><strong>Génération:</strong> ${airplane.generation}</p>
            <p><strong>Type:</strong> ${airplane.type_name}</p>
            <p><strong>Date de conception:</strong> ${airplane.date_concept}</p>
            <p><strong>Premier vol:</strong> ${airplane.date_first_fly}</p>
            <p><strong>Date de mise en service:</strong> ${airplane.date_operationel}</p>
            <p><strong>Vitesse maximale:</strong> ${airplane.max_speed} km/h</p>
            <p><strong>Portée maximale:</strong> ${airplane.max_range} km</p>
            <p><strong>Statut:</strong> ${airplane.status}</p>
            <p><strong>Poids:</strong> ${airplane.weight} kg</p>
        `;

        // Afficher l'armement de l'avion
        if (armament.length > 0) {
            airplaneInfo.innerHTML += `<h3>Armement</h3>`;
            armament.forEach(weapon => {
                airplaneInfo.innerHTML += `
                    <p><strong>${weapon.name}:</strong> ${weapon.description}</p>
                `;
            });
        } else {
            airplaneInfo.innerHTML += `<p><strong>Armement:</strong> Aucun armement enregistré.</p>`;
        }

        // Afficher les technologies de l'avion
        if (tech.length > 0) {
            airplaneInfo.innerHTML += `<h3>Technologies</h3>`;
            tech.forEach(technology => {
                airplaneInfo.innerHTML += `
                    <p><strong>${technology.name}:</strong> ${technology.description}</p>
                `;
            });
        } else {
            airplaneInfo.innerHTML += `<p><strong>Technologies:</strong> Aucune technologie enregistrée.</p>`;
        }

        // Afficher les guerres auxquelles l'avion a participé
        if (wars.length > 0) {
            airplaneInfo.innerHTML += `<h3>Guerres</h3>`;
            wars.forEach(war => {
                airplaneInfo.innerHTML += `
                    <p><strong>${war.name}:</strong> ${war.description} (${war.date_start} - ${war.date_end})</p>
                `;
            });
        } else {
            airplaneInfo.innerHTML += `<p><strong>Guerres:</strong> Aucune guerre enregistrée.</p>`;
        }
    }

    // Appel de la fonction pour récupérer les détails de l'avion
    fetchAirplaneDetails();
});