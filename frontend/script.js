document.addEventListener("DOMContentLoaded", async function() {
    const listContainer = document.getElementById("airplanes-list");

    try {
        const response = await fetch("http://localhost:3000/airplanes");
        const airplanes = await response.json();

        airplanes.forEach(airplane => {
            const card = document.createElement("div");
            card.classList.add("card");

            card.innerHTML = `
                <img src="${airplane.image_url || 'placeholder.jpg'}" alt="${airplane.name}">
                <h2>${airplane.name}</h2>
                <p>${airplane.little_description}</p>
            `;

            listContainer.appendChild(card);
        });
    } catch (error) {
        console.error("Erreur lors de la récupération des avions :", error);
        listContainer.innerHTML = "<p>Impossible de charger les avions.</p>";
    }
});
