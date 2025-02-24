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
// Lecteur de musique
const audio = document.getElementById('audio');
const playBtn = document.getElementById('play');
const prevBtn = document.getElementById('prev');
const nextBtn = document.getElementById('next');
const progressBar = document.querySelector('.progress-bar');
const progress = document.getElementById('progress');
const currentTimeEl = document.getElementById('current-time');
const durationEl = document.getElementById('duration');
const volumeSlider = document.getElementById('volume');
const volumeIcon = document.getElementById('volume-icon');
const playerToggle = document.getElementById('player-toggle');
const musicPlayer = document.getElementById('music-player');

// Liste de lecture
const playlist = [
    {
        title: "Trampoline",
        artist: "SHAED",
        src: "../frontend/audio/trampoline.mp3"
    },
    {
        title: "Right Round",
        artist: "Flo Rida",
        src: "../frontend/audio/right_round.mp3"
    },
    {
        title: "I Ain’t Worried",
        artist: "OneRepublic",
        src: "../frontend/audio/i_ain_t_worried.mp3"
    },
    {
        title: "Danger Zone",
        artist: "Kenny Loggins",
        src: "../frontend/audio/danger_zone.mp3"
    }
];

let currentSongIndex = 0;
let isPlayerVisible = false; // Lecteur caché par défaut

// Charger la chanson
function loadSong(song) {
    document.getElementById('song-title').textContent = song.title;
    document.getElementById('song-artist').textContent = song.artist;
    audio.src = song.src;
}

// Play/Pause
function togglePlay() {
    if (audio.paused) {
        audio.play();
        playBtn.innerHTML = '<i class="fas fa-pause"></i>';
    } else {
        audio.pause();
        playBtn.innerHTML = '<i class="fas fa-play"></i>';
    }
}

// Mettre à jour la progression
function updateProgress(e) {
    const { duration, currentTime } = e.srcElement;
    const progressPercent = (currentTime / duration) * 100;
    progress.style.width = `${progressPercent}%`;
    currentTimeEl.textContent = formatTime(currentTime);
    if (!isNaN(duration)) {
        durationEl.textContent = formatTime(duration);
    }
}

// Formater le temps
function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

// Définir la progression
function setProgress(e) {
    const width = this.clientWidth;
    const clickX = e.offsetX;
    const duration = audio.duration;
    audio.currentTime = (clickX / width) * duration;
}

// Chanson suivante
function nextSong() {
    currentSongIndex++;
    if (currentSongIndex > playlist.length - 1) {
        currentSongIndex = 0;
    }
    loadSong(playlist[currentSongIndex]);
    audio.play();
    playBtn.innerHTML = '<i class="fas fa-pause"></i>';
}

// Chanson précédente
function prevSong() {
    currentSongIndex--;
    if (currentSongIndex < 0) {
        currentSongIndex = playlist.length - 1;
    }
    loadSong(playlist[currentSongIndex]);
    audio.play();
    playBtn.innerHTML = '<i class="fas fa-pause"></i>';
}

// Gérer le volume
function handleVolume() {
    audio.volume = volumeSlider.value / 100;
    updateVolumeIcon();
}

function updateVolumeIcon() {
    if (audio.volume === 0) {
        volumeIcon.className = 'fas fa-volume-mute';
    } else if (audio.volume < 0.5) {
        volumeIcon.className = 'fas fa-volume-down';
    } else {
        volumeIcon.className = 'fas fa-volume-up';
    }
}

// Basculer le lecteur
function togglePlayer() {
    isPlayerVisible = !isPlayerVisible;
    musicPlayer.classList.toggle('visible', isPlayerVisible);
    playerToggle.innerHTML = isPlayerVisible ? '<i class="fas fa-times"></i>' : '<i class="fas fa-music"></i>';
}

// Événements
playBtn.addEventListener('click', togglePlay);
prevBtn.addEventListener('click', prevSong);
nextBtn.addEventListener('click', nextSong);
audio.addEventListener('timeupdate', updateProgress);
progressBar.addEventListener('click', setProgress);
volumeSlider.addEventListener('input', handleVolume);
audio.addEventListener('ended', nextSong);
playerToggle.addEventListener('click', togglePlayer);

// Charger la première chanson
loadSong(playlist[0]);

});