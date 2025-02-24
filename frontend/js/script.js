document.addEventListener("DOMContentLoaded", () => {
    const introVideo = document.getElementById("intro-video");
    const introContainer = document.getElementById("intro-video-container");
    const skipButton = document.getElementById("skip-button");
    const body = document.body;
    const airplanesContainer = document.getElementById("airplanes-container");
    const sortSelect = document.getElementById("sort-select");
    const customSelect = document.querySelector(".custom-select");
    const countrySelectContainer = document.getElementById("country-select-container");
    const countrySelect = document.getElementById("country-select");

    // Gestion vidéo d'intro
    body.classList.add("video-playing");

    introVideo.addEventListener("ended", () => {
        introContainer.style.display = "none";
        body.classList.remove("video-playing");
    });

    skipButton.addEventListener("click", () => {
        introContainer.style.display = "none";
        body.classList.remove("video-playing");
    });

    introVideo.addEventListener("error", () => {
        introContainer.style.display = "none";
        body.classList.remove("video-playing");
    });

    // Fonction pour récupérer les avions depuis l'API
    async function fetchAirplanes(sort = "default", country = "") {
        try {
            let url = `http://localhost:3000/api/airplanes?sort=${sort}`;
            if (country) {
                url += `&country=${encodeURIComponent(country)}`;
            }
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error("Erreur lors de la récupération des données");
            }

            const airplanes = await response.json();
            return airplanes;
        } catch (error) {
            console.error("Erreur:", error);
            airplanesContainer.innerHTML =
                "<p>Erreur lors du chargement des avions. Veuillez réessayer plus tard.</p>";
            return [];
        }
    }

    // Fonction pour récupérer la liste des pays uniques
    async function fetchCountries() {
        const airplanes = await fetchAirplanes("nation");
        const countries = [...new Set(airplanes.map(airplane => airplane.country_name))].sort();
        populateCountrySelect(countries);
    }

    // Remplir le menu des pays
    function populateCountrySelect(countries) {
        countrySelect.innerHTML = '<option value="">Choisir un pays</option>';
        countries.forEach(country => {
            const option = document.createElement("option");
            option.value = country;
            option.textContent = country;
            countrySelect.appendChild(option);
        });
    }

    // Fonction pour afficher les avions
    function displayAirplanes(airplanes) {
        airplanesContainer.innerHTML = "";

        if (airplanes.length === 0) {
            airplanesContainer.innerHTML =
                "<p>Aucun avion disponible pour le moment.</p>";
            return;
        }

        airplanes.forEach((airplane) => {
            const airplaneCard = document.createElement("div");
            airplaneCard.classList.add("airplane-card");

            const imageContainer = document.createElement("div");
            imageContainer.classList.add("image-container");

            const airplaneImage = document.createElement("img");
            airplaneImage.src = airplane.image_url;
            airplaneImage.alt = airplane.name;
            airplaneImage.loading = "lazy";

            const airplaneContent = document.createElement("div");
            airplaneContent.classList.add("airplane-content");

            const airplaneName = document.createElement("h3");
            airplaneName.textContent = airplane.name;

            const airplaneDescription = document.createElement("p");
            airplaneDescription.textContent = airplane.little_description;

            const airplaneInfo = document.createElement("div");
            airplaneInfo.classList.add("airplane-info");

            const countryBadge = document.createElement("div");
            countryBadge.classList.add("info-badge", "country-badge");
            countryBadge.textContent = airplane.country_name;

            const separator = document.createElement("div");
            separator.classList.add("separator");
            separator.textContent = "•";

            const typeBadge = document.createElement("div");
            typeBadge.classList.add("info-badge", "type-badge");
            typeBadge.textContent = airplane.type_name;

            airplaneInfo.appendChild(countryBadge);
            airplaneInfo.appendChild(separator);
            airplaneInfo.appendChild(typeBadge);

            airplaneCard.addEventListener("click", () => {
                window.location.href = `details.html?id=${airplane.id}`;
            });

            imageContainer.appendChild(airplaneImage);
            airplaneContent.appendChild(airplaneName);
            airplaneContent.appendChild(airplaneDescription);
            airplaneContent.appendChild(airplaneInfo);

            airplaneCard.appendChild(imageContainer);
            airplaneCard.appendChild(airplaneContent);

            airplanesContainer.appendChild(airplaneCard);
        });
    }

    // Gestion du tri principal
    sortSelect.addEventListener("change", async () => {
        const sortValue = sortSelect.value;
        if (sortValue === "nation") {
            countrySelectContainer.style.display = "inline-block";
            await fetchCountries();
            // Ne rien afficher tant qu'un pays n'est pas sélectionné
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un pays.</p>";
        } else {
            countrySelectContainer.style.display = "none";
            const airplanes = await fetchAirplanes(sortValue);
            displayAirplanes(airplanes);
        }
    });

    // Gestion du tri par pays
    countrySelect.addEventListener("change", async () => {
        const country = countrySelect.value;
        if (country) {
            const airplanes = await fetchAirplanes("nation", country);
            displayAirplanes(airplanes);
        } else {
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un pays.</p>";
        }
    });

    // Animation flèche pour sort-select
    sortSelect.addEventListener("click", () => {
        customSelect.classList.toggle("open");
    });

    // Animation flèche pour country-select
    countrySelect.addEventListener("click", () => {
        countrySelectContainer.classList.toggle("open");
    });

    // Fermer les menus quand on clique ailleurs
    document.addEventListener("click", (e) => {
        if (!customSelect.contains(e.target)) {
            customSelect.classList.remove("open");
        }
        if (!countrySelectContainer.contains(e.target)) {
            countrySelectContainer.classList.remove("open");
        }
    });

    // Chargement initial
    fetchAirplanes().then(displayAirplanes);

    // Lecteur de musique
    const audio = document.getElementById("audio");
    const playBtn = document.getElementById("play");
    const prevBtn = document.getElementById("prev");
    const nextBtn = document.getElementById("next");
    const progressBar = document.querySelector(".progress-bar");
    const progress = document.getElementById("progress");
    const currentTimeEl = document.getElementById("current-time");
    const durationEl = document.getElementById("duration");
    const volumeSlider = document.getElementById("volume");
    const volumeIcon = document.getElementById("volume-icon");
    const playerToggle = document.getElementById("player-toggle");
    const musicPlayer = document.getElementById("music-player");

    const playlist = [
        { title: "Trampoline", artist: "SHAED", src: "../frontend/audio/trampoline.mp3" },
        { title: "Right Round", artist: "Flo Rida", src: "../frontend/audio/right_round.mp3" },
        { title: "I Ain’t Worried", artist: "OneRepublic", src: "../frontend/audio/i_ain_t_worried.mp3" },
        { title: "Danger Zone", artist: "Kenny Loggins", src: "../frontend/audio/danger_zone.mp3" }
    ];

    let currentSongIndex = 0;
    let isPlayerVisible = false;

    function loadSong(song) {
        document.getElementById("song-title").textContent = song.title;
        document.getElementById("song-artist").textContent = song.artist;
        audio.src = song.src;
    }

    function togglePlay() {
        if (audio.paused) {
            audio.play();
            playBtn.innerHTML = '<i class="fas fa-pause"></i>';
        } else {
            audio.pause();
            playBtn.innerHTML = '<i class="fas fa-play"></i>';
        }
    }

    function updateProgress(e) {
        const { duration, currentTime } = e.srcElement;
        const progressPercent = (currentTime / duration) * 100;
        progress.style.width = `${progressPercent}%`;
        currentTimeEl.textContent = formatTime(currentTime);
        if (!isNaN(duration)) {
            durationEl.textContent = formatTime(duration);
        }
    }

    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = Math.floor(seconds % 60);
        return `${minutes}:${remainingSeconds.toString().padStart(2, "0")}`;
    }

    function setProgress(e) {
        const width = this.clientWidth;
        const clickX = e.offsetX;
        const duration = audio.duration;
        audio.currentTime = (clickX / width) * duration;
    }

    function nextSong() {
        currentSongIndex++;
        if (currentSongIndex > playlist.length - 1) {
            currentSongIndex = 0;
        }
        loadSong(playlist[currentSongIndex]);
        audio.play();
        playBtn.innerHTML = '<i class="fas fa-pause"></i>';
    }

    function prevSong() {
        currentSongIndex--;
        if (currentSongIndex < 0) {
            currentSongIndex = playlist.length - 1;
        }
        loadSong(playlist[currentSongIndex]);
        audio.play();
        playBtn.innerHTML = '<i class="fas fa-pause"></i>';
    }

    function handleVolume() {
        audio.volume = volumeSlider.value / 100;
        updateVolumeIcon();
    }

    function updateVolumeIcon() {
        if (audio.volume === 0) {
            volumeIcon.className = "fas fa-volume-mute";
        } else if (audio.volume < 0.5) {
            volumeIcon.className = "fas fa-volume-down";
        } else {
            volumeIcon.className = "fas fa-volume-up";
        }
    }

    function togglePlayer() {
        isPlayerVisible = !isPlayerVisible;
        musicPlayer.classList.toggle("visible", isPlayerVisible);
        playerToggle.innerHTML = isPlayerVisible
            ? '<i class="fas fa-times"></i>'
            : '<i class="fas fa-music"></i>';
    }

    playBtn.addEventListener("click", togglePlay);
    prevBtn.addEventListener("click", prevSong);
    nextBtn.addEventListener("click", nextSong);
    audio.addEventListener("timeupdate", updateProgress);
    progressBar.addEventListener("click", setProgress);
    volumeSlider.addEventListener("input", handleVolume);
    audio.addEventListener("ended", nextSong);
    playerToggle.addEventListener("click", togglePlayer);

    loadSong(playlist[0]);
});