document.addEventListener('DOMContentLoaded', () => {
    const airplaneInfo = document.getElementById('airplane-info');
    const armementList = document.getElementById('armement-list');
    const guerresList = document.getElementById('guerres-list');
    const techList = document.getElementById('tech-list');
    const missionsList = document.getElementById('missions-list');

    // Récupérer l'ID de l'avion depuis l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const airplaneId = urlParams.get('id');

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