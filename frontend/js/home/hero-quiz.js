/* Accueil — widget « Devine l'avion ».
 *
 * Premier chargement : l'appareil du jour, tiré d'une graine sur la date —
 * mêmes propositions dans le même ordre pour tout le monde, ce qui rend la
 * question commentable. Le bouton de tirage repasse en aléatoire.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  function shuffleWith(list, random) {
    const { daily, shuffleArr } = VH.home.heroHelpers;
    const dailyApi = daily();
    return dailyApi ? dailyApi.shuffleWith(list, random) : shuffleArr(list);
  }

  /** Deux leurres, de la même génération en priorité (plus crédibles). */
  function pickDecoys(aircraft, target, random) {
    const sameGen = aircraft.filter(a => a.generation === target.generation && a.name !== target.name);
    const pool = sameGen.length >= 2 ? sameGen : aircraft.filter(a => a.name !== target.name);
    return shuffleWith(pool, random).slice(0, 2).map(a => a.name);
  }

  function init(aircraft, dayKey) {
    const card    = document.getElementById('hero-quiz-card');
    const image   = document.getElementById('hero-quiz-image');
    const options = document.getElementById('hero-quiz-options');
    const link    = document.getElementById('hero-quiz-link');
    const lblLabel = document.getElementById('hero-quiz-link-label');
    const reroll  = document.getElementById('hero-quiz-reroll');
    const dailyTag = document.getElementById('hero-quiz-daily-tag');
    if (!card || !image || !options || aircraft.length < 3) return;

    const { daily, tHero, airplaneHref } = VH.home.heroHelpers;
    const dailyApi = daily();
    let current = null;

    function load(useDaily) {
      const isDaily = Boolean(useDaily && dailyApi);
      const random = isDaily
        ? dailyApi.seededRandom(dailyApi.hashSeed(dayKey + ':quiz'))
        : Math.random;

      current = isDaily
        ? dailyApi.pickDaily(aircraft, dayKey)
        : aircraft[Math.floor(Math.random() * aircraft.length)];

      // L'image du quiz est l'élément LCP de l'accueil : elle passe par le même
      // helper <picture> que le reste du site pour être servie en AVIF/WebP
      // plutôt qu'en JPEG (≈124 Ko contre ≈19 Ko sur une fiche typique).
      if (VH.shared && VH.shared.picture) {
        VH.shared.picture.applySourcesTo(image, current.image_url);
      } else {
        image.src = current.image_url;
      }
      card.classList.remove('is-revealed');
      if (dailyTag) dailyTag.toggleAttribute('hidden', !isDaily);

      const opts = shuffleWith([current.name, ...pickDecoys(aircraft, current, random)], random);
      options.querySelectorAll('.hero-quiz-option').forEach((b, i) => {
        b.textContent = opts[i];
        b.disabled = false;
        b.classList.remove('is-correct', 'is-wrong');
        b.dataset.value = opts[i];
      });

      if (link) link.setAttribute('hidden', '');
    }

    function answer(btn) {
      if (!current || btn.disabled) return;
      const correct = btn.dataset.value === current.name;

      options.querySelectorAll('.hero-quiz-option').forEach(b => {
        b.disabled = true;
        if (b.dataset.value === current.name) b.classList.add('is-correct');
        else if (b === btn && !correct)       b.classList.add('is-wrong');
      });

      card.classList.add('is-revealed');
      if (link && lblLabel) {
        lblLabel.textContent = correct
          ? tHero('home.hero_quiz_link_correct', {}, 'Bien joué — voir la fiche', 'Well done — see the record')
          : tHero('home.hero_quiz_link_wrong', { name: current.name },
            'C’était le {name} — voir la fiche', 'It was the {name} — see the record');
        // Lien direct sur la fiche si l'API expose l'id ; repli sur la
        // recherche /hangar pour les appareils de repli (FALLBACK_AIRCRAFT).
        link.setAttribute('href', airplaneHref(current.id, current.name));
        link.removeAttribute('hidden');
      }
    }

    options.addEventListener('click', (e) => {
      const btn = e.target.closest('.hero-quiz-option');
      if (btn) answer(btn);
    });
    if (reroll) reroll.addEventListener('click', () => load(false));
    load(true);
  }

  VH.home.heroQuiz = { pickDecoys, init };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroQuiz;
  }
})();
