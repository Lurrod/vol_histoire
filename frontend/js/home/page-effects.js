/* Accueil — effets de page : défilement doux des ancres internes, fondu
 * des images au chargement, ordre des widgets du hero, apparition du corps
 * de page. home.min.js est aussi chargé par politique-confidentialite.html :
 * chaque effet ne fait rien si ses éléments sont absents. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  function smoothAnchors() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        // Le href peut avoir été muté vers un chemin après le parse (widgets
        // hero qui passent de href="#" à "/hangar?..." une fois l'API résolue).
        if (!href || !href.startsWith('#') || href.length <= 1) return;
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          // Défilement doux, sauf si l'utilisateur demande moins d'animations.
          const reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
          target.scrollIntoView({ behavior: reduce ? 'auto' : 'smooth', block: 'start' });
        }
      });
    });
  }

  function fadeInImages() {
    document.querySelectorAll('img').forEach(img => {
      img.addEventListener('load', function () {
        this.style.opacity = '0';
        this.style.transition = 'opacity 0.5s ease';
        setTimeout(() => { this.style.opacity = '1'; }, 10);
      });
    });
  }

  // Garde-fou défensif : si le HTML servi depuis un cache SW est dans le
  // mauvais ordre (Quiz avant Fact), on rétablit Fact-en-premier au runtime.
  // Sans effet si l'ordre du DOM est déjà correct.
  function ensureHeroAsideOrder() {
    const fact = document.getElementById('hero-fact-card');
    const quiz = document.getElementById('hero-quiz-card');
    if (!fact || !quiz) return;
    // compareDocumentPosition retourne DOCUMENT_POSITION_FOLLOWING (4) si
    // l'argument vient APRÈS this. Si quiz vient avant fact, on déplace fact.
    const pos = fact.compareDocumentPosition(quiz);
    if (!(pos & Node.DOCUMENT_POSITION_FOLLOWING)) {
      quiz.parentNode.insertBefore(fact, quiz);
    }
  }

  // Apparition en fondu de la page
  function revealBody() {
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.5s ease';
    setTimeout(() => { document.body.style.opacity = '1'; }, 100);
  }

  VH.home.pageEffects = { smoothAnchors, fadeInImages, ensureHeroAsideOrder, revealBody };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.pageEffects;
  }
})();
