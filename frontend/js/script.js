document.addEventListener("DOMContentLoaded", () => {
  // Exemple d'effet simple : ajuster l'opacité de la section hero lors du défilement
  const heroContent = document.querySelector(".hero-content");
  window.addEventListener("scroll", () => {
    const scrollPos = window.scrollY;
    heroContent.style.opacity = 1 - scrollPos / 300;
  });
});
