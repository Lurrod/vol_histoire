document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("login-form");
    const registerForm = document.getElementById("register-form");
    const switchToRegister = document.getElementById("switch-to-register");
    const switchToLogin = document.getElementById("switch-to-login");

    if (!loginForm || !registerForm || !switchToRegister || !switchToLogin) {
        console.error("Un ou plusieurs éléments du formulaire sont introuvables.");
        return;
    }

    // Basculer entre connexion et inscription
    switchToRegister.addEventListener("click", () => {
        loginForm.classList.add("hidden");
        registerForm.classList.remove("hidden");
    });

    switchToLogin.addEventListener("click", () => {
        registerForm.classList.add("hidden");
        loginForm.classList.remove("hidden");
    });

    // Gestion de la connexion
    loginForm.addEventListener("submit", async (event) => {
        event.preventDefault();
        const email = document.getElementById("login-email").value;
        const password = document.getElementById("login-password").value;

        const response = await fetch("http://localhost:3000/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();
        if (response.ok) {
            alert("Connexion réussie !");
            localStorage.setItem("token", data.token);
            window.location.href = "index.html"; 
        } else {
            alert("Erreur : " + data.message);
        }
    });

    // Gestion de l'inscription
    registerForm.addEventListener("submit", async (event) => {
        event.preventDefault();
        const name = document.getElementById("register-name").value;
        const email = document.getElementById("register-email").value;
        const password = document.getElementById("register-password").value;
    
        const response = await fetch("http://localhost:3000/api/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ name, email, password })
        });
    
        const data = await response.json();
        if (response.ok) {
            alert("Inscription réussie ! Connectez-vous.");
            switchToLogin.click();
        } else {
            alert("Erreur : " + data.message);
        }    
    });
});
