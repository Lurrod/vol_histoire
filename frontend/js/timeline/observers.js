/* Frise — observateurs : année courante pendant le défilement (règle,
 * teinte), entrée des chapitres, révélation échelonnée des cartes et du récit.
 * Le suivi du défilement est posé une seule fois ; les observateurs de
 * révélation sont remplacés à chaque nouveau rendu (filtre, langue). */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Ancre verticale à 35 % de la hauteur d'écran : robuste sur grands chapitres.
  const ANCHOR_RATIO = 0.35;
  // Décalage d'animation : 80 ms par rang, cycle de 6 cartes.
  const STAGGER_MS = 80;
  const STAGGER_CYCLE = 6;

  let tracking = false;
  let revealObservers = [];
  let activeDecade = null;

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

  /* Part du chapitre déjà passée sous l'ancre (0 → 1). */
  function chapterFraction(section, anchor) {
    const rect = section.getBoundingClientRect();
    if (rect.height <= 0) return 0;
    return Math.max(0, Math.min(1, (anchor - rect.top) / rect.height));
  }

  function staggerDelay(card) {
    const siblings = Array.from(card.parentElement.children);
    return (siblings.indexOf(card) % STAGGER_CYCLE) * STAGGER_MS;
  }

  /* Année et décennie sous l'ancre ; avant le premier chapitre : 1945. */
  function update() {
    const T = VH.timeline;
    const anchor = window.innerHeight * ANCHOR_RATIO;
    const sections = document.querySelectorAll('.tl-chapter');
    const dominant = findDominant(sections, anchor);
    const end = T.util.currentYear();
    if (!dominant) {
      const first = sections[0];
      if (first && first.getBoundingClientRect().top > anchor) {
        if (activeDecade !== null) T.era.clearActiveEra();
        activeDecade = null;
        T.ruler.setYear(T.util.START_YEAR, null);
      }
      return;
    }
    dominant.classList.add('in-view');
    const decade = Number(dominant.dataset.decade);
    if (decade !== activeDecade) {
      activeDecade = decade;
      T.era.showActiveEra(dominant);
    }
    T.ruler.setYear(T.ruler.yearInChapter(decade, chapterFraction(dominant, anchor), end), decade);
  }

  function trackActiveChapter() {
    activeDecade = null;
    if (!tracking) {
      tracking = true;
      VH.timeline.util.onScrollFrame(update);
    }
    update();
  }

  function observe(selector, options, onEnter) {
    const io = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        onEnter(entry.target);
        io.unobserve(entry.target);
      });
    }, options);
    document.querySelectorAll(selector).forEach(el => io.observe(el));
    revealObservers.push(io);
  }

  function observeReveals() {
    revealObservers.forEach(io => io.disconnect());
    revealObservers = [];
    observe('.tl-chapter', { threshold: 0.05 }, el => el.classList.add('in-view'));
    observe('.tl-plane-card, .tl-event', { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }, card => {
      card.style.animationDelay = `${staggerDelay(card)}ms`;
      card.classList.add('reveal');
    });
    observe('.tl-narrative, .tl-title-card', { threshold: 0.25 }, el => el.classList.add('reveal'));
  }

  function observeChapters() {
    trackActiveChapter();
    observeReveals();
  }

  function _reset() {
    tracking = false;
    activeDecade = null;
    revealObservers.forEach(io => io.disconnect());
    revealObservers = [];
  }

  const api = { ANCHOR_RATIO, findDominant, chapterFraction, staggerDelay, update, observeChapters, _reset };
  window.VH.timeline.observers = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
