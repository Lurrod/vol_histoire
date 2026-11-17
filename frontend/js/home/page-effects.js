/* Accueil — effets de page : défilement doux des ancres internes, fondu
 * des images au chargement, ordre des widgets du hero. home.min.js est aussi chargé par politique-confidentialite.html :
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

  // Fondu des images encore en cours de chargement. Une image déjà
  // chargée (cache, ou chargée avant ce script) est déjà peinte : la
  // remettre à 0 la ferait clignoter — on n'y touche pas. Le fondu passe
  // par une animation (style-hero.css) et non par `style.transition`,
  // qui écrasait la transition propre de l'image du quiz.
  function fadeInImages() {
    document.querySelectorAll('img').forEach(img => {
      if (img.complete) return;
      img.classList.add('is-loading');
      const done = () => {
        img.classList.remove('is-loading');
        img.classList.add('is-loaded');
      };
      img.addEventListener('load', done, { once: true });
      img.addEventListener('error', () => img.classList.remove('is-loading'), { once: true });
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

  VH.home.pageEffects = { smoothAnchors, fadeInImages, ensureHeroAsideOrder };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.pageEffects;
  }
})();
