document.addEventListener('DOMContentLoaded', () => {
    const airplaneInfo = document.getElementById('airplane-info');
    const armementList = document.getElementById('armement-list');
    const guerresList = document.getElementById('guerres-list');

    // Récupérer l'ID de l'avion depuis l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const airplaneId = urlParams.get('id');

    async function fetchAirplaneDetails() {
        if (!airplaneId) {
            airplaneInfo.innerHTML = '<p>Aucun avion sélectionné.</p>';
            return;
        }

        try {
            const [airplane, armament, wars] = await Promise.all([
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/armament`).then(res => res.json()),
                fetch(`http://localhost:3000/api/airplanes/${airplaneId}/wars`).then(res => res.json())
            ]);

            displayAirplaneDetails(airplane, armament, wars);
        } catch (error) {
            console.error('Erreur:', error);
            airplaneInfo.innerHTML = '<p>Erreur lors du chargement des détails de l\'avion.</p>';
        }
    }

    function displayAirplaneDetails(airplane, armament, wars) {
        // Afficher les informations de base de l'avion
        airplaneInfo.innerHTML = `
            <h2>${airplane.complete_name}</h2>
            <img src="${airplane.image_url}" alt="${airplane.name}" class="hero-image">
            <p><strong>Description : </strong> ${airplane.description}</p>
            <p><strong>Pays d'origine : </strong> ${airplane.country_name}</p>
            <p><strong>Constructeur : </strong> ${airplane.manufacturer_name}</p>
            <p><strong>Génération : </strong> ${airplane.generation}</p>
            <p><strong>Type : </strong> ${airplane.type_name}</p>
            <p><strong>Date de conception : </strong> ${airplane.date_concept}</p>
            <p><strong>Premier vol : </strong> ${airplane.date_first_fly}</p>
            <p><strong>Date de mise en service : </strong> ${airplane.date_operationel}</p>
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

        // Afficher les guerres auxquelles l'avion a participé
        wars.forEach(war => {
            guerresList.innerHTML += `
                <div class="war-event">
                    <h4>${war.name}</h4>
                    <p>${war.date_start} → ${war.date_end}</p>
                    <p>${war.description}</p>
                </div>
            `;
        });
    }

    fetchAirplaneDetails();
});