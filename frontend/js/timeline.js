document.addEventListener('DOMContentLoaded', () => {
    const timelineEvents = document.getElementById('timeline-events');
    const timelineMarkers = document.getElementById('timeline-markers');
    const countryFilter = document.getElementById('country-filter');
    const typeFilter = document.getElementById('type-filter');
    const generationFilter = document.getElementById('generation-filter');
    const startDateSpan = document.getElementById('start-date');
    const endDateSpan = document.getElementById('end-date');

    let airplanes = [];
    let minDate, maxDate;

    // Fonction pour formater les dates
    function formatDate(dateString) {
        if (!dateString) return 'Date inconnue';
        const date = new Date(dateString);
        return isNaN(date) ? 'Date invalide' : date.toLocaleDateString('fr-FR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
    }

    // Fonction pour créer les marqueurs de l'axe temporel
    function createTimelineMarkers(start, end) {
        timelineMarkers.innerHTML = '';
        
        const startYear = new Date(start).getFullYear();
        const endYear = new Date(end).getFullYear();
        const yearSpan = endYear - startYear;
        
        if (yearSpan === 0) return; // Pas de marqueurs si une seule année
        
        const markerCount = Math.min(10, yearSpan);
        const yearInterval = Math.ceil(yearSpan / markerCount);

        for (let i = 0; i <= markerCount; i++) {
            const year = startYear + (i * yearInterval);
            const marker = document.createElement('div');
            marker.className = 'timeline-marker';
            marker.setAttribute('data-year', year);
            marker.style.left = `${(i / markerCount) * 100}%`;
            timelineMarkers.appendChild(marker);
        }
    }

    // Fonction pour calculer la position horizontale d'un événement
    function calculatePosition(date, minDate, maxDate) {
        const timeMin = minDate.getTime();
        const timeMax = maxDate.getTime();
        if (timeMax === timeMin) return '50%'; // Cas où toutes les dates sont identiques
        
        const position = (new Date(date).getTime() - timeMin) / (timeMax - timeMin);
        return `${Math.max(0, Math.min(position, 1)) * 100}%`;
    }

    // Fonction pour créer un événement sur la frise
    function createTimelineEvent(airplane, template) {
        const event = template.content.cloneNode(true);
        const eventElement = event.querySelector('.timeline-event');
        const dot = event.querySelector('.event-dot');
        const card = event.querySelector('.event-card');
        const img = event.querySelector('img');
        const title = event.querySelector('h3');
        const countryBadge = event.querySelector('.country-badge');
        const typeBadge = event.querySelector('.type-badge');
        const generationBadge = event.querySelector('.generation-badge');
        const description = event.querySelector('.event-description');
        const date = event.querySelector('.event-date');

        // Positionnement horizontal
        dot.style.left = calculatePosition(airplane.date_operationel, minDate, maxDate);
        
        // Contenu
        img.src = airplane.image_url;
        img.alt = airplane.name;
        title.textContent = airplane.name;
        countryBadge.textContent = airplane.country_name;
        typeBadge.textContent = airplane.type_name;
        generationBadge.textContent = `Génération ${airplane.generation}`;
        description.textContent = airplane.little_description;
        date.textContent = `Mise en service : ${formatDate(airplane.date_operationel)}`;

        // Gestion du clic sur le point
        dot.addEventListener('click', (e) => {
            e.stopPropagation(); // Empêcher la propagation du clic
            const isActive = card.classList.contains('active');
            
            // Fermer toutes les cartes
            document.querySelectorAll('.event-card.active').forEach(activeCard => {
                activeCard.classList.remove('active');
            });
            
            // Ouvrir la carte si elle n'était pas active
            if (!isActive) {
                card.classList.add('active');
            }
        });

        // Fermer la carte quand on clique ailleurs
        document.addEventListener('click', (e) => {
            if (!card.contains(e.target)) {
                card.classList.remove('active');
            }
        });

        // Ajout d'un lien vers la page de détails
        eventElement.addEventListener('click', () => {
            window.location.href = `details.html?id=${airplane.id}`;
        });

        return event;
    }

    // Fonction pour mettre à jour les filtres
    function updateFilters(airplanes) {
        // Réinitialiser les filtres
        countryFilter.innerHTML = '<option value="all">Tous les pays</option>';
        typeFilter.innerHTML = '<option value="all">Tous les types</option>';
        generationFilter.innerHTML = '<option value="all">Toutes les générations</option>';

        // Remplir les nouvelles options
        const countries = [...new Set(airplanes.map(a => a.country_name))];
        const types = [...new Set(airplanes.map(a => a.type_name))];
        const generations = [...new Set(airplanes.map(a => a.generation))].sort((a, b) => a - b);

        countries.forEach(country => {
            const option = document.createElement('option');
            option.value = country;
            option.textContent = country;
            countryFilter.appendChild(option);
        });

        types.forEach(type => {
            const option = document.createElement('option');
            option.value = type;
            option.textContent = type;
            typeFilter.appendChild(option);
        });

        generations.forEach(gen => {
            const option = document.createElement('option');
            option.value = gen;
            option.textContent = `Génération ${gen}`;
            generationFilter.appendChild(option);
        });
    }

    // Fonction pour afficher les avions filtrés
    function displayFilteredAirplanes() {
        const country = countryFilter.value;
        const type = typeFilter.value;
        const generationValue = generationFilter.value;
        const generationNumber = generationValue === 'all' ? null : parseInt(generationValue.replace('Génération ', ''));

        const filteredAirplanes = airplanes.filter(airplane => {
            return (country === 'all' || airplane.country_name === country) &&
                   (type === 'all' || airplane.type_name === type) &&
                   (generationValue === 'all' || airplane.generation === generationNumber);
        });

        // Gestion des dates
        let newMinDate = minDate;
        let newMaxDate = maxDate;
        
        if (filteredAirplanes.length > 0) {
            const dates = filteredAirplanes.map(a => new Date(a.date_operationel).getTime());
            newMinDate = new Date(Math.min(...dates));
            newMaxDate = new Date(Math.max(...dates));
        }

        startDateSpan.textContent = formatDate(newMinDate);
        endDateSpan.textContent = formatDate(newMaxDate);

        // Recréer les marqueurs de timeline
        createTimelineMarkers(newMinDate, newMaxDate);

        // Vider les événements existants
        timelineEvents.innerHTML = '';
        
        // Recréer les événements filtrés
        const template = document.getElementById('event-template');
        filteredAirplanes.forEach(airplane => {
            const event = createTimelineEvent(airplane, template);
            timelineEvents.appendChild(event);
        });
    }

    // Ajouter les écouteurs d'événements pour les filtres
    countryFilter.addEventListener('change', displayFilteredAirplanes);
    typeFilter.addEventListener('change', displayFilteredAirplanes);
    generationFilter.addEventListener('change', displayFilteredAirplanes);

    // Chargement initial des données
    fetch('http://localhost:3000/api/airplanes')
        .then(response => {
            if (!response.ok) throw new Error('Erreur réseau');
            return response.json();
        })
        .then(data => {
            if (!data || !data.length) throw new Error('Aucune donnée disponible');
            
            airplanes = data.filter(a => a.date_operationel); // Filtrer les entrées sans date
            const dates = airplanes.map(a => new Date(a.date_operationel).getTime());
            
            if (dates.length === 0) throw new Error('Aucune date valide');
            
            minDate = new Date(Math.min(...dates));
            maxDate = new Date(Math.max(...dates));

            startDateSpan.textContent = formatDate(minDate);
            endDateSpan.textContent = formatDate(maxDate);

            createTimelineMarkers(minDate, maxDate);
            updateFilters(airplanes);
            displayFilteredAirplanes();
        })
        .catch(error => {
            console.error('Erreur:', error);
            timelineEvents.innerHTML = `<p class="error">${error.message}</p>`;
        });
});