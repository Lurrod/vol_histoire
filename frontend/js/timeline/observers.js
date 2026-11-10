/* Frise — observateurs de défilement : chapitre actif (HUD, minimap, teinte),
 * entrée des chapitres, apparition du HUD après la couverture, révélation
 * échelonnée des cartes et du narratif. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Ancre verticale à 35 % de la hauteur d'écran : robuste sur grands chapitres.
  const ANCHOR_RATIO = 0.35;
  // Décalage d'animation : 80 ms par rang, cycle de 6 cartes.
  const STAGGER_MS = 80;
  const STAGGER_CYCLE = 6;

  /* Chapitre qui chevauche l'ancre et dont le centre en est le plus proche. */
  function findDominant(sections, anchor) {
    let dominant = null;
    let bestDistance = Infinity;
    sections.forEach(section => {
      const rect = section.getBoundingClientRect();
      if (rect.top <= anchor && rect.bottom >= anchor) {
        const distance = Math.abs(rect.top + rect.height / 2 - anchor);
        if (distance < bestDistance) {
          bestDistance = distance;
          dominant = section;
        }
      }
    });
    return dominant;
  }

  function staggerDelay(card) {
    const siblings = Array.from(card.parentElement.children);
    return (siblings.indexOf(card) % STAGGER_CYCLE) * STAGGER_MS;
  }

  function trackActiveChapter() {
    const mmButtons = document.querySelectorAll('.tl-mm-btn');
    function updateActive() {
      const anchor = window.innerHeight * ANCHOR_RATIO;
      const dominant = findDominant(document.querySelectorAll('.tl-chapter'), anchor);
      if (!dominant) return;
      dominant.classList.add('in-view');
      const decade = VH.timeline.era.showActiveEra(dominant);
      mmButtons.forEach(b => b.classList.toggle('active', b.dataset.target === `ch-${decade}`));
    }
    VH.timeline.util.onScrollFrame(updateActive);
    updateActive();
  }

  // Chapter in-view pour animation (backdrop / tint)
  function observeChapterEntry() {
    const io = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) entry.target.classList.add('in-view');
      });
    }, { threshold: 0.05 });
    document.querySelectorAll('.tl-chapter').forEach(c => io.observe(c));
  }

  // Affichage HUD + minimap après la couverture
  function observeIntro() {
    const yearHud = document.getElementById('tl-year-hud');
    const intro = document.getElementById('tl-intro');
    if (!intro || !yearHud) return;
    new IntersectionObserver(entries => {
      const past = !entries[0].isIntersecting;
      yearHud.classList.toggle('visible', past);
      const mm = document.getElementById('tl-minimap');
      if (mm) mm.classList.toggle('visible', past);
      if (!past) VH.timeline.era.clearActiveEra();
    }, { threshold: 0 }).observe(intro);
  }

  // Reveal staggered des cartes + événements
  function observeCardReveal() {
    const cardObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const card = entry.target;
        card.style.animationDelay = `${staggerDelay(card)}ms`;
        card.classList.add('reveal');
        cardObs.unobserve(card);
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
    document.querySelectorAll('.tl-plane-card, .tl-event').forEach(c => cardObs.observe(c));
  }

  // Narrative fade-in
  function observeNarrative() {
    const narrObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('reveal');
        narrObs.unobserve(entry.target);
      });
    }, { threshold: 0.25 });
    document.querySelectorAll('.tl-narrative, .tl-title-card').forEach(el => narrObs.observe(el));
  }

  function observeChapters() {
    trackActiveChapter();
    observeChapterEntry();
    observeIntro();
    observeCardReveal();
    observeNarrative();
  }

  const api = { ANCHOR_RATIO, findDominant, staggerDelay, observeChapters };
  window.VH.timeline.observers = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
