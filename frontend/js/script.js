document.addEventListener('DOMContentLoaded', () => {
    const airplanesContainer = document.getElementById('airplanes-container');
    const sortSelect = document.getElementById('sort-select');
    const customSelect = document.querySelector('.custom-select');

    // Fonction pour récupérer les avions depuis l'API
    async function fetchAirplanes() {
        try {
            const sortValue = sortSelect.value;
            const response = await fetch(`http://localhost:3000/api/airplanes?sort=${sortValue}`);
            
            if (!response.ok) {
                throw new Error('Erreur lors de la récupération des données');
            }
            
            const airplanes = await response.json();
            displayAirplanes(airplanes);
        } catch (error) {
            console.error('Erreur:', error);
            airplanesContainer.innerHTML = '<p>Erreur lors du chargement des avions. Veuillez réessayer plus tard.</p>';
        }
    }

    // Fonction pour afficher les avions
    function displayAirplanes(airplanes) {
        airplanesContainer.innerHTML = '';
        
        if (airplanes.length === 0) {
            airplanesContainer.innerHTML = '<p>Aucun avion disponible pour le moment.</p>';
            return;
        }

        airplanes.forEach(airplane => {
            const airplaneCard = document.createElement('div');
            airplaneCard.classList.add('airplane-card');

            // Conteneur d'image
            const imageContainer = document.createElement('div');
            imageContainer.classList.add('image-container');

            // Image de l'avion
            const airplaneImage = document.createElement('img');
            airplaneImage.src = airplane.image_url;
            airplaneImage.alt = airplane.name;
            airplaneImage.loading = 'lazy';

            // Informations texte
            const airplaneContent = document.createElement('div');
            airplaneContent.classList.add('airplane-content');

            const airplaneName = document.createElement('h3');
            airplaneName.textContent = airplane.name;

            const airplaneDescription = document.createElement('p');
            airplaneDescription.textContent = airplane.little_description;

            // Badges d'information
            const airplaneInfo = document.createElement('div');
            airplaneInfo.classList.add('airplane-info');
            
            // Badge Pays
            const countryBadge = document.createElement('div');
            countryBadge.classList.add('info-badge', 'country-badge');
            countryBadge.textContent = airplane.country_name;
            
            // Séparateur
            const separator = document.createElement('div');
            separator.classList.add('separator');
            separator.textContent = '•';

            // Badge Type
            const typeBadge = document.createElement('div');
            typeBadge.classList.add('info-badge', 'type-badge');
            typeBadge.textContent = airplane.type_name;

            // Ajout des éléments
            airplaneInfo.appendChild(countryBadge);
            airplaneInfo.appendChild(separator);
            airplaneInfo.appendChild(typeBadge);

            // Gestion du clic
            airplaneCard.addEventListener('click', () => {
                window.location.href = `details.html?id=${airplane.id}`;
            });

            // Construction de la carte
            imageContainer.appendChild(airplaneImage);
            airplaneContent.appendChild(airplaneName);
            airplaneContent.appendChild(airplaneDescription);
            airplaneContent.appendChild(airplaneInfo);
            
            airplaneCard.appendChild(imageContainer);
            airplaneCard.appendChild(airplaneContent);

            airplanesContainer.appendChild(airplaneCard);
        });
    }

    // Gestion du tri
    sortSelect.addEventListener('change', fetchAirplanes);

    // Animation flèche
    sortSelect.addEventListener('click', () => {
        customSelect.classList.toggle('open');
    });

    // Fermer le menu quand on clique ailleurs
    document.addEventListener('click', (e) => {
        if (!customSelect.contains(e.target)) {
            customSelect.classList.remove('open');
        }
    });

    // Chargement initial
    fetchAirplanes();

});