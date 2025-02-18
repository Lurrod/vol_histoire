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
        }
    }

    function displayAirplanes(airplanes) {
        airplanesContainer.innerHTML = '';
        airplanes.forEach(airplane => {
            const airplaneCard = document.createElement('div');
            airplaneCard.classList.add('airplane-card');

            airplaneCard.addEventListener('click', () => {
                window.location.href = `details.html?id=${airplane.id}`;
            });

            const airplaneImage = document.createElement('img');
            airplaneImage.src = airplane.image_url;
            airplaneImage.alt = airplane.name;

            const airplaneName = document.createElement('h3');
            airplaneName.textContent = airplane.name;

            const airplaneDescription = document.createElement('p');
            airplaneDescription.textContent = airplane.little_description;

            airplaneCard.appendChild(airplaneImage);
            airplaneCard.appendChild(airplaneName);
            airplaneCard.appendChild(airplaneDescription);

            airplanesContainer.appendChild(airplaneCard);
        });
    }

    fetchAirplanes();
});