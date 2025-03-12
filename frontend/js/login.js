document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("login-form");
    const registerForm = document.getElementById("register-form");
    const switchToRegister = document.getElementById("switch-to-register");
    const switchToLogin = document.getElementById("switch-to-login");
    const formInner = document.querySelector('.form-inner');

    if (!loginForm || !registerForm || !switchToRegister || !switchToLogin || !formInner) {
        console.error("Un ou plusieurs éléments sont introuvables.");
        return;
    }

    // Basculer entre connexion et inscription avec animation
    switchToRegister.addEventListener("click", () => {
        formInner.classList.add('flipped');
    });

    switchToLogin.addEventListener("click", () => {
        formInner.classList.remove('flipped');
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
            formInner.classList.remove('flipped');
        } else {
            alert("Erreur : " + data.message);
        }
    });
});