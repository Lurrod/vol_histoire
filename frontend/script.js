document.addEventListener('DOMContentLoaded', () => {
    const airplanesContainer = document.getElementById('airplanes-container');

    // Fonction pour récupérer les avions depuis l'API
    async function fetchAirplanes() {
        try {
            const response = await fetch('http://localhost:3000/airplanes');
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
            airplaneImage.loading = 'lazy'; // Chargement différé

            // Informations texte
            const airplaneContent = document.createElement('div');
            airplaneContent.classList.add('airplane-content');

            const airplaneName = document.createElement('h3');
            airplaneName.textContent = airplane.name;

            const airplaneDescription = document.createElement('p');
            airplaneDescription.textContent = airplane.little_description;

            // Gestion du clic
            airplaneCard.addEventListener('click', () => {
                window.location.href = `details.html?id=${airplane.id}`;
            });

            // Construction de la carte
            imageContainer.appendChild(airplaneImage);
            airplaneContent.appendChild(airplaneName);
            airplaneContent.appendChild(airplaneDescription);
            
            airplaneCard.appendChild(imageContainer);
            airplaneCard.appendChild(airplaneContent);

            airplanesContainer.appendChild(airplaneCard);
        });
    }

    // Chargement initial
    fetchAirplanes();

    // Rafraîchissement périodique (optionnel)
    setInterval(fetchAirplanes, 300000); // Toutes les 5 minutes
});