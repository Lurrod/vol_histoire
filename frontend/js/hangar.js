document.addEventListener("DOMContentLoaded", () => {
    const body = document.body;
    const airplanesContainer = document.getElementById("airplanes-container");
    const sortSelect = document.getElementById("sort-select");
    const customSelect = document.querySelector(".custom-select");
    const countrySelectContainer = document.getElementById("country-select-container");
    const countrySelect = document.getElementById("country-select");
    const generationSelectContainer = document.getElementById("generation-select-container");
    const generationSelect = document.getElementById("generation-select");
    const typeSelectContainer = document.getElementById("type-select-container");
    const typeSelect = document.getElementById("type-select");
    const addModal = document.getElementById("add-modal");
    const addButton = document.getElementById("add-airplane-btn");
    const closeAddModal = addModal.querySelector(".close-btn");
    const loginIcon = document.getElementById("login-icon");
    const userToggle = document.querySelector(".user-toggle");
    const userDropdown = document.getElementById("user-info-container");

    // Vérifier si un token JWT est stocké
    const token = localStorage.getItem("token");

    const updateAuthUI = () => {
        const token = localStorage.getItem("token");
    
        // Redirige vers login si non authentifié lors du clic sur l'icône
        loginIcon.addEventListener("click", (e) => {
          if (!token) {
            e.preventDefault();
            window.location.href = "login.html";
          }
        });
        
        if (token) {
          try {
            const payload = JSON.parse(atob(token.split(".")[1]));
            // Met à jour le nom et le rôle de l'utilisateur dans le dropdown
            document.getElementById("user-name").textContent = payload.name;
            document.querySelector(".user-role").textContent =
              payload.role === 1 ? "Administrateur" :
              payload.role === 2 ? "Éditeur" : "Membre";
            if (payload.role === 1 || payload.role === 2) {
                addButton.classList.remove("hidden");
            } else {
                addButton.classList.add("hidden");
            }
            userDropdown.classList.remove("hidden");
          } catch (error) {
            console.error("Token error:", error);
            localStorage.removeItem("token");
          }
        }
      };
    
      // Permet d'ouvrir/fermer le dropdown lors du clic sur le conteneur utilisateur
      userToggle.addEventListener("click", (e) => {
        e.preventDefault();
        userDropdown.classList.toggle("show");
      });
    
      // Ferme le dropdown si l'utilisateur clique en dehors
      document.addEventListener("click", (e) => {
        if (!userToggle.contains(e.target)) {
          userDropdown.classList.remove("show");
        }
      });

      document.getElementById("settings-icon")?.addEventListener("click", (e) => {
        e.preventDefault();
        window.location.href = "settings.html";
      });
    
      // Gestion de la déconnexion
      document.getElementById("logout-icon").addEventListener("click", (e) => {
        e.preventDefault();
        localStorage.removeItem("token");
        window.location.href = "hangar.html";
      });

    
      updateAuthUI();
    

        addButton.addEventListener("click", async () => {
        addModal.classList.add("show");
        addModal.classList.remove("hidden");
        
        // Vider les menus déroulants précédents pour éviter les doublons
        document.getElementById("add-country-id").innerHTML = '<option value="">Choisir un pays</option>';
        document.getElementById("add-manufacturer-id").innerHTML = '<option value="">Choisir un fabricant</option>';
        document.getElementById("add-generation-id").innerHTML = '<option value="">Choisir une génération</option>';
        document.getElementById("add-type").innerHTML = '<option value="">Choisir un type</option>';
        
        // Remplir les menus déroulants
        await Promise.all([
            populateCountriesSelect(),
            populateManufacturersSelect(),
            populateGenerationsSelect(),
            populateTypesSelect()
        ]);
    });
    
    closeAddModal.addEventListener("click", () => {
        addModal.classList.remove("show");
        addModal.classList.add("hidden");
    });

    async function populateCountriesSelect() {
        const select = document.getElementById("add-country-id");
        try {
            const response = await fetch("/api/countries");
            const countries = await response.json();
            countries.forEach(country => {
                const option = document.createElement("option");
                option.value = country.id;
                option.textContent = country.name;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des pays:", error);
        }
    }
    
    // Fonction pour remplir le menu des fabricants
    async function populateManufacturersSelect() {
        const select = document.getElementById("add-manufacturer-id");
        try {
            const response = await fetch("/api/manufacturers");
            const manufacturers = await response.json();
            manufacturers.forEach(manufacturer => {
                const option = document.createElement("option");
                option.value = manufacturer.id;
                option.textContent = manufacturer.name;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des fabricants:", error);
        }
    }
    
    // Fonction pour remplir le menu des générations
    async function populateGenerationsSelect() {
        const select = document.getElementById("add-generation-id");
        try {
            const response = await fetch("/api/generations");
            const generations = await response.json();
            generations.forEach(generation => {
                const option = document.createElement("option");
                option.value = generation; // L'API renvoie directement la génération comme valeur
                option.textContent = `Génération ${generation}`;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des générations:", error);
        }
    }
    
    // Fonction pour remplir le menu des types
    async function populateTypesSelect() {
        const select = document.getElementById("add-type");
        try {
            const response = await fetch("/api/types");
            const types = await response.json();
            types.forEach(type => {
                const option = document.createElement("option");
                option.value = type.id;
                option.textContent = type.name;
                select.appendChild(option);
            });
        } catch (error) {
            console.error("Erreur lors du chargement des types:", error);
        }
    }

    // Gestion de la soumission du formulaire
document.getElementById("add-form").addEventListener("submit", async (e) => {
    e.preventDefault();

    const newAirplane = {
        name: document.getElementById("add-name").value,
        complete_name: document.getElementById("add-complete-name").value,
        little_description: document.getElementById("add-little-description").value,
        image_url: document.getElementById("add-image-url").value,
        description: document.getElementById("add-description").value,
        date_concept: document.getElementById("add-date-concept").value || null,
        date_first_fly: document.getElementById("add-date-first-fly").value || null,
        date_operationel: document.getElementById("add-date-operationel").value || null,
        max_speed: parseFloat(document.getElementById("add-max-speed").value) || null,
        max_range: parseFloat(document.getElementById("add-max-range").value) || null,
        weight: parseFloat(document.getElementById("add-weight").value) || null,
        status: document.getElementById("add-status").value,
        country_id: parseInt(document.getElementById("add-country-id").value) || null,
        id_manufacturer: parseInt(document.getElementById("add-manufacturer-id").value) || null,
        id_generation: parseInt(document.getElementById("add-generation-id").value) || null,
        type: parseInt(document.getElementById("add-type").value) || null
    };

    try {
        const response = await fetch("/api/airplanes", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(newAirplane)
        });

        if (response.ok) {
            alert("Avion créé avec succès !");
            addModal.classList.remove("show");
            addModal.classList.add("hidden");
            const response = await fetchAirplanes(sortSelect.value);
            displayAirplanes(response);
        } else {
            const error = await response.json();
            alert(`Erreur: ${error.message || "Création impossible"}`);
        }
    } catch (error) {
        console.error("Erreur:", error);
        alert("Erreur réseau - Impossible de créer l'avion");
    }

    try {
        const response = await fetch("/api/airplanes", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(newAirplane)
        });

        if (response.ok) {
            alert("Avion créé avec succès !");
            addModal.classList.remove("show");
            // Recharger la liste
            const response = await fetchAirplanes(sortSelect.value);
            displayAirplanes(response);
        } else {
            const error = await response.json();
            alert(`Erreur: ${error.message || "Création impossible"}`);
        }
        } catch (error) {
            console.error("Erreur:", error);
            alert("Erreur réseau - Impossible de créer l'avion");
        }
    });

    // Fonction pour récupérer les avions depuis l'API
    async function fetchAirplanes(sort = "default", filterValue = "", page = 1) {
        try {
            let url = `/api/airplanes?sort=${sort}&page=${page}`;
            if (filterValue) {
                if (sort === "nation") {
                    url += `&country=${encodeURIComponent(filterValue)}`;
                } else if (sort === "generation") {
                    url += `&generation=${encodeURIComponent(filterValue)}`;
                } else if (sort === "type") {
                    url += `&type=${encodeURIComponent(filterValue)}`;
                }
            }
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error("Erreur lors de la récupération des données");
            }

            const responseData = await response.json();
            return responseData;
        } catch (error) {
            console.error("Erreur:", error);
            airplanesContainer.innerHTML =
                "<p>Erreur lors du chargement des avions. Veuillez réessayer plus tard.</p>";
            return { data: [], pagination: null };
        }
    }

    // Fonction pour récupérer la liste des pays uniques
    function populateCountrySelect(countries) {
        countrySelect.innerHTML = '<option value="">Choisir un pays</option>';
        countries.forEach(country => {
            const option = document.createElement("option");
            option.value = country;
            option.textContent = country;
            countrySelect.appendChild(option);
        });
    }    

    // Fonction pour récupérer la liste des générations disponibles
    async function fetchGenerations() {
        try {
            const response = await fetch('/api/generations');
            if (!response.ok) throw new Error("Erreur lors de la récupération des générations");
            const generations = await response.json();
            populateGenerationSelect(generations);
        } catch (error) {
            console.error("Erreur:", error);
        }
    }

    // Fonction pour récupérer la liste des types disponibles
    async function fetchTypes() {
        try {
            const response = await fetch('/api/types');
            if (!response.ok) throw new Error("Erreur lors de la récupération des types");
            const types = await response.json();
            populateTypeSelect(types);
        } catch (error) {
            console.error("Erreur:", error);
        }
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

    // Remplir le menu des générations
    function populateGenerationSelect(generations) {
        generationSelect.innerHTML = '<option value="">Choisir une génération</option>';
        generations.forEach(generation => {
            const option = document.createElement("option");
            option.value = generation;
            option.textContent = `Génération ${generation}`;
            generationSelect.appendChild(option);
        });
    }

    async function fetchCountries() {
        try {
            const response = await fetch("/api/countries");
            if (!response.ok) throw new Error("Erreur lors de la récupération des pays");
            const countriesData = await response.json();
            const countries = countriesData.map(c => c.name).sort();
            populateCountrySelect(countries);
        } catch (error) {
            console.error("Erreur:", error);
        }
    }

    // Remplir le menu des types
    function populateTypeSelect(types) {
        typeSelect.innerHTML = '<option value="">Choisir un type</option>';
        types.forEach(type => {
            const option = document.createElement("option");
            option.value = type.name;
            option.textContent = type.name;
            typeSelect.appendChild(option);
        });
    }

    // Fonction pour afficher les avions
    function displayAirplanes(response) {
        const { data: airplanes, pagination } = response;
        airplanesContainer.innerHTML = "";

        if (airplanes.length === 0) {
            airplanesContainer.innerHTML = "<p>Aucun avion disponible pour le moment.</p>";
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

        updatePaginationControls(pagination);
    }

    // Ajouter les contrôles de pagination
    function updatePaginationControls(pagination) {
        const existingPagination = document.getElementById('pagination-controls');
        if (existingPagination) existingPagination.remove();

        if (!pagination) return;

        const paginationContainer = document.createElement('div');
        paginationContainer.id = 'pagination-controls';
        paginationContainer.className = 'pagination';

        const prevButton = document.createElement('button');
        prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
        prevButton.disabled = pagination.currentPage === 1;
        prevButton.onclick = () => handlePageChange(pagination.currentPage - 1);

        const nextButton = document.createElement('button');
        nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
        nextButton.disabled = pagination.currentPage === pagination.totalPages;
        nextButton.onclick = () => handlePageChange(pagination.currentPage + 1);

        const pageInfo = document.createElement('span');
        pageInfo.textContent = `Page ${pagination.currentPage} / ${pagination.totalPages}`;

        paginationContainer.append(prevButton, pageInfo, nextButton);
        document.querySelector('main').appendChild(paginationContainer);
    }

    // Gestion du changement de page
    async function handlePageChange(newPage) {
        const sortValue = sortSelect.value;
        let filterValue = "";
        if (sortValue === "nation") {
            filterValue = countrySelect.value;
        } else if (sortValue === "generation") {
            filterValue = generationSelect.value;
        } else if (sortValue === "type") {
            filterValue = typeSelect.value;
        }
        const response = await fetchAirplanes(sortValue, filterValue, newPage);
        displayAirplanes(response);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Gestion du tri principal
    sortSelect.addEventListener("change", async () => {
        const sortValue = sortSelect.value;
        if (sortValue === "nation") {
            countrySelectContainer.style.display = "inline-block";
            generationSelectContainer.style.display = "none";
            typeSelectContainer.style.display = "none";
            await fetchCountries();
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un pays.</p>";
        } else if (sortValue === "generation") {
            generationSelectContainer.style.display = "inline-block";
            countrySelectContainer.style.display = "none";
            typeSelectContainer.style.display = "none";
            await fetchGenerations();
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner une génération.</p>";
        } else if (sortValue === "type") {
            typeSelectContainer.style.display = "inline-block";
            countrySelectContainer.style.display = "none";
            generationSelectContainer.style.display = "none";
            await fetchTypes();
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un type.</p>";
        } else {
            countrySelectContainer.style.display = "none";
            generationSelectContainer.style.display = "none";
            typeSelectContainer.style.display = "none";
            const response = await fetchAirplanes(sortValue);
            displayAirplanes(response);
        }
    });

    // Gestion du tri par pays
    countrySelect.addEventListener("change", async () => {
        const country = countrySelect.value;
        if (country) {
            const response = await fetchAirplanes("nation", country);
            displayAirplanes(response);
        } else {
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un pays.</p>";
        }
    });

    // Gestion du tri par génération
    generationSelect.addEventListener("change", async () => {
        const generation = generationSelect.value;
        if (generation) {
            const response = await fetchAirplanes("generation", generation);
            displayAirplanes(response);
        } else {
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner une génération.</p>";
        }
    });

    // Gestion du tri par type
    typeSelect.addEventListener("change", async () => {
        const type = typeSelect.value;
        if (type) {
            const response = await fetchAirplanes("type", type);
            displayAirplanes(response);
        } else {
            airplanesContainer.innerHTML = "<p>Veuillez sélectionner un type.</p>";
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

    // Animation flèche pour generation-select
    generationSelect.addEventListener("click", () => {
        generationSelectContainer.classList.toggle("open");
    });

    // Animation flèche pour type-select
    typeSelect.addEventListener("click", () => {
        typeSelectContainer.classList.toggle("open");
    });

    // Fermer les menus quand on clique ailleurs
    document.addEventListener("click", (e) => {
        if (!customSelect.contains(e.target)) {
            customSelect.classList.remove("open");
        }
        if (!countrySelectContainer.contains(e.target)) {
            countrySelectContainer.classList.remove("open");
        }
        if (!generationSelectContainer.contains(e.target)) {
            generationSelectContainer.classList.remove("open");
        }
        if (!typeSelectContainer.contains(e.target)) {
            typeSelectContainer.classList.remove("open");
        }
    });

    // Chargement initial
    fetchAirplanes().then(displayAirplanes);
    fetchTypes();
});