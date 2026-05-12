document.addEventListener("DOMContentLoaded", async () => {
  /* =========================================================================
     AUTH INITIALIZATION
     ========================================================================= */
  await auth.init();

  /* Provided by nav.js — header, hamburger, dropdown, logout, updateAuthUI */

  /* =========================================================================
     STATS API — Dynamic hero stats from /api/stats
     ========================================================================= */

  async function fetchHeroStats() {
    const elAirplanes   = document.getElementById('hero-split-stat-airplanes');
    const elCountries   = document.getElementById('hero-split-stat-countries');
    const elGenerations = document.getElementById('hero-split-stat-generations');

    if (!elAirplanes && !elCountries && !elGenerations) return;

    try {
      const res = await auth.fetchWithTimeout('/api/stats');
      if (!res.ok) throw new Error('API stats error');
      const data = await res.json();

      if (elAirplanes   && Number.isFinite(data.airplanes))   animateNumber(elAirplanes,   data.airplanes);
      if (elCountries   && Number.isFinite(data.countries))   animateNumber(elCountries,   data.countries);
      if (elGenerations && Number.isFinite(data.generations)) animateNumber(elGenerations, data.generations);
    } catch {
      // Stats API indisponible — on conserve les valeurs hardcodées du HTML SSR.
    }
  }

  /* Provided by utils.js — animateNumber */

  /* =========================================================================
     SCROLL ANIMATIONS (AOS-like)
     ========================================================================= */

  const animateOnScroll = () => {
    const elements = document.querySelectorAll('[data-aos]');

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const delay = entry.target.dataset.aosDelay || 0;
          setTimeout(() => {
            entry.target.classList.add('aos-animate');
          }, delay);
          observer.unobserve(entry.target);
        }
      });
    }, {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    });

    elements.forEach(el => observer.observe(el));
  };

  animateOnScroll();

  /* =========================================================================
     SMOOTH SCROLL FOR ANCHOR LINKS
     ========================================================================= */

  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      // Le href peut avoir été muté vers un chemin après le parse (widgets
      // hero qui passent de href="#" à "/hangar?..." une fois l'API résolue).
      if (!href || !href.startsWith('#') || href.length <= 1) return;
      e.preventDefault();
      const target = document.querySelector(href);
      if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  /* Provided by utils.js — escapeHtml, showToast */

  /* =========================================================================
     FEATURED CARDS HOVER EFFECT
     ========================================================================= */

  const aircraftCards = document.querySelectorAll('.aircraft-card');
  aircraftCards.forEach(card => {
    card.addEventListener('mouseenter', function() { this.style.zIndex = '10'; });
    card.addEventListener('mouseleave', function() { this.style.zIndex = '1'; });
  });

  /* =========================================================================
     LOADING ANIMATION FOR IMAGES
     ========================================================================= */

  const images = document.querySelectorAll('img');
  images.forEach(img => {
    img.addEventListener('load', function() {
      this.style.opacity = '0';
      this.style.transition = 'opacity 0.5s ease';
      setTimeout(() => { this.style.opacity = '1'; }, 10);
    });
  });

  /* =========================================================================
     SCROLL INDICATOR
     ========================================================================= */

  const scrollIndicator = document.querySelector('.scroll-indicator');

  if (scrollIndicator) {
    scrollIndicator.addEventListener('click', () => {
      const featuresSection = document.querySelector('.features');
      if (featuresSection) {
        featuresSection.scrollIntoView({ behavior: 'smooth' });
      }
    });

    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 100) {
        scrollIndicator.style.opacity = '0';
        scrollIndicator.style.pointerEvents = 'none';
      } else {
        scrollIndicator.style.opacity = '1';
        scrollIndicator.style.pointerEvents = 'all';
      }
    });
  }

  /* =========================================================================
     PRELOAD CRITICAL RESOURCES
     ========================================================================= */

  const preloadImages = [
    '/assets/airplanes/f16-fighting-falcon.jpg',
    '/assets/airplanes/mig21.jpg',
    '/assets/airplanes/su27.jpg'
  ];

  preloadImages.forEach(src => {
    const link = document.createElement('link');
    link.rel = 'preload';
    link.as = 'image';
    link.href = src;
    document.head.appendChild(link);
  });

  /* =========================================================================
     FEATURE CARDS STAGGER ANIMATION
     ========================================================================= */

  const featureCards = document.querySelectorAll('.feature-card');

  const featureObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry, index) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, index * 100);
        featureObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  featureCards.forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(40px)';
    card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
    featureObserver.observe(card);
  });

  /* =========================================================================
     TIMELINE CARDS ANIMATION
     ========================================================================= */

  const timelineCards = document.querySelectorAll('.timeline-card');

  const timelineObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry, index) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateX(0)';
        }, index * 150);
        timelineObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.2 });

  timelineCards.forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateX(-40px)';
    card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
    timelineObserver.observe(card);
  });

  /* Provided by nav.js — ESC keyboard handler */

  /* =========================================================================
     PERFORMANCE OPTIMIZATION
     ========================================================================= */

  let scrollTimeout;
  window.addEventListener('scroll', () => {
    if (scrollTimeout) window.cancelAnimationFrame(scrollTimeout);
    scrollTimeout = window.requestAnimationFrame(() => {});
  }, { passive: true });

  // Add CSS animation keyframes dynamically
  const style = document.createElement('style');
  style.textContent = `
    @keyframes slideInRight {
      from { transform: translateX(400px); opacity: 0; }
      to   { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOutRight {
      from { transform: translateX(0); opacity: 1; }
      to   { transform: translateX(400px); opacity: 0; }
    }
  `;
  document.head.appendChild(style);

  /* =========================================================================
     HERO STATS — Trigger animation on visibility
     ========================================================================= */

  const heroStats = document.querySelector('.hero-split-meta');
  let statsLoaded = false;

  if (heroStats) {
    const statsObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !statsLoaded) {
          statsLoaded = true;
          fetchHeroStats();
          statsObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.5 });

    statsObserver.observe(heroStats);
  }

  /* =========================================================================
     FEATURED AIRCRAFT — Load 3 real aircraft from the API
     ========================================================================= */

  /* =========================================================================
     HERO SPLIT — Widgets aside (Saviez-vous ? + Devine l'avion)
     ========================================================================= */

  function getHeroLang() {
    if (typeof i18n !== 'undefined' && i18n.getLang) return i18n.getLang() === 'en' ? 'en' : 'fr';
    return document.documentElement.lang === 'en' ? 'en' : 'fr';
  }

  /* ----- Helpers partagés Fact / Quiz ----- */
  function shuffleArr(arr) {
    const a = arr.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }

  // "F-15 Eagle" → "f-15+eagle" (search hangar via FTS)
  function nameToSearchSlug(name) {
    return String(name || '')
      .toLowerCase()
      .trim()
      .replace(/\s+/g, '+');
  }

  /* ----- Fallbacks (PWA offline / API down) ----- */
  const FALLBACK_FACTS = [
    { year: 1961, airplane_name: 'Mirage III', title_fr: 'Premier avion européen de série à dépasser Mach 2 en vol horizontal.',          title_en: 'First European production aircraft to exceed Mach 2 in level flight.' },
    { year: 1976, airplane_name: 'F-15 Eagle', title_fr: '104 victoires aériennes pour aucune perte en combat depuis sa mise en service.', title_en: '104 air-to-air victories with zero combat losses since entering service.' },
    { year: 1986, airplane_name: 'Rafale',     title_fr: 'Premier vol du démonstrateur depuis Istres, base de la doctrine omnirôle française.', title_en: 'Demonstrator first flight from Istres, foundation of the French omnirole doctrine.' },
    { year: 1964, airplane_name: 'SR-71 Blackbird', title_fr: 'Mise en service ; record de Mach 3.32 toujours invaincu plus de 60 ans après.', title_en: 'Enters service; Mach 3.32 record still stands more than 60 years later.' },
  ];
  const FALLBACK_AIRCRAFT = [
    { name: 'F-15 Eagle',        image_url: '/assets/airplanes/f15-eagle.jpg',       generation: 4 },
    { name: 'MiG-29',            image_url: '/assets/airplanes/mig29.jpg',           generation: 4 },
    { name: 'Rafale',            image_url: '/assets/airplanes/rafale.jpg',          generation: 4 },
    { name: 'F-22 Raptor',       image_url: '/assets/airplanes/f22-raptor.jpg',      generation: 5 },
    { name: 'Mirage 2000',       image_url: '/assets/airplanes/mirage2000.jpg',      generation: 4 },
    { name: 'Su-57',             image_url: '/assets/airplanes/su57.jpg',            generation: 5 },
    { name: 'F-35 Lightning II', image_url: '/assets/airplanes/f35-lightning-2.jpg', generation: 5 },
    { name: 'Mirage III',        image_url: '/assets/airplanes/mirage3.jpg',         generation: 2 },
  ];

  /* ----- Fetch unique des données dynamiques ----- */
  async function fetchHeroDiscoveries() {
    try {
      const res = await auth.fetchWithTimeout('/api/hero/discoveries');
      if (!res.ok) throw new Error('hero API error');
      const data = await res.json();
      const facts    = Array.isArray(data.facts)    && data.facts.length    ? data.facts    : FALLBACK_FACTS;
      const aircraft = Array.isArray(data.aircraft) && data.aircraft.length ? data.aircraft : FALLBACK_AIRCRAFT;
      return { facts, aircraft };
    } catch {
      return { facts: FALLBACK_FACTS, aircraft: FALLBACK_AIRCRAFT };
    }
  }

  /* ----- Widget 1 : Saviez-vous ? ----- */
  function initHeroFact(facts) {
    const body = document.getElementById('hero-fact-body');
    const link = document.getElementById('hero-fact-link');
    const reroll = document.getElementById('hero-fact-reroll');
    if (!body || !facts.length) return;

    function renderFact(f) {
      const lang = getHeroLang();
      const title = (lang === 'en' ? f.title_en : f.title_fr) || f.title_fr || '';
      const name  = (lang === 'en' ? f.airplane_name_en : f.airplane_name) || f.airplane_name || '';
      // On échappe puis on remet l'éventuel nom d'avion en <strong> pour
      // garder le ton "highlight" du widget. innerHTML est sûr car le seul
      // markup vient de nos balises <strong>/<span> construites ici.
      const safeTitle = escapeHtml(title);
      const safeName = escapeHtml(name);
      const boldedTitle = safeName
        ? safeTitle.replace(safeName, `<strong>${safeName}</strong>`)
        : safeTitle;
      body.style.animation = 'none';
      void body.offsetWidth; // force reflow pour rejouer l'animation
      body.style.animation = '';
      body.innerHTML = `<span class="hero-fact-year">${escapeHtml(String(f.year || ''))}</span>${boldedTitle}`;
      if (link) {
        // Lien direct sur la fiche si l'API expose l'airplane_id ; fallback
        // sur la recherche /hangar pour les facts servis depuis FALLBACK_FACTS
        // (PWA offline / API down) où l'ID DB est inconnu.
        const href = f.airplane_id
          ? '/details?id=' + encodeURIComponent(f.airplane_id)
          : (name ? '/hangar?search=' + encodeURIComponent(nameToSearchSlug(name)) : '#');
        link.setAttribute('href', href);
      }
    }

    function pick() {
      renderFact(facts[Math.floor(Math.random() * facts.length)]);
    }
    if (reroll) reroll.addEventListener('click', pick);
    pick();
  }

  /* ----- Widget 2 : Devine l'avion ----- */
  function initHeroQuiz(aircraft) {
    const card    = document.getElementById('hero-quiz-card');
    const image   = document.getElementById('hero-quiz-image');
    const options = document.getElementById('hero-quiz-options');
    const link    = document.getElementById('hero-quiz-link');
    const lblLabel = document.getElementById('hero-quiz-link-label');
    const reroll  = document.getElementById('hero-quiz-reroll');
    if (!card || !image || !options || aircraft.length < 3) return;

    let current = null;

    function pickDecoys(target) {
      // Priorité aux mêmes génération pour des leurres crédibles.
      const sameGen = aircraft.filter(a => a.generation === target.generation && a.name !== target.name);
      const pool = sameGen.length >= 2 ? sameGen : aircraft.filter(a => a.name !== target.name);
      return shuffleArr(pool).slice(0, 2).map(a => a.name);
    }

    function load() {
      current = aircraft[Math.floor(Math.random() * aircraft.length)];
      image.src = current.image_url;
      card.classList.remove('is-revealed');

      const opts = shuffleArr([current.name, ...pickDecoys(current)]);
      const btns = options.querySelectorAll('.hero-quiz-option');
      btns.forEach((b, i) => {
        b.textContent = opts[i];
        b.disabled = false;
        b.classList.remove('is-correct', 'is-wrong');
        b.dataset.value = opts[i];
      });

      if (link) link.setAttribute('hidden', '');
    }

    function answer(btn) {
      if (!current || btn.disabled) return;
      const chosen = btn.dataset.value;
      const correct = chosen === current.name;
      const btns = options.querySelectorAll('.hero-quiz-option');

      btns.forEach(b => {
        b.disabled = true;
        if (b.dataset.value === current.name) b.classList.add('is-correct');
        else if (b === btn && !correct)       b.classList.add('is-wrong');
      });

      card.classList.add('is-revealed');
      if (link && lblLabel) {
        const lang = getHeroLang();
        if (correct) {
          lblLabel.textContent = lang === 'en'
            ? 'Well done — see the record'
            : 'Bien joué — voir la fiche';
        } else {
          lblLabel.textContent = lang === 'en'
            ? 'It was the ' + current.name + ' — see the record'
            : 'C\'était le ' + current.name + ' — voir la fiche';
        }
        // Lien direct sur la fiche si l'API expose l'id ; fallback sur la
        // recherche /hangar pour les appareils issus de FALLBACK_AIRCRAFT.
        const href = current.id
          ? '/details?id=' + encodeURIComponent(current.id)
          : '/hangar?search=' + encodeURIComponent(nameToSearchSlug(current.name));
        link.setAttribute('href', href);
        link.removeAttribute('hidden');
      }
    }

    options.addEventListener('click', (e) => {
      const btn = e.target.closest('.hero-quiz-option');
      if (btn) answer(btn);
    });
    if (reroll) reroll.addEventListener('click', load);
    load();
  }

  // Fetch unique + init des deux widgets sur le même pool de données.
  (async () => {
    const { facts, aircraft } = await fetchHeroDiscoveries();
    initHeroFact(facts);
    initHeroQuiz(aircraft);
  })();

  // Garde-fou défensif : si le HTML servi depuis un cache SW est dans le
  // mauvais ordre (Quiz avant Fact), on rétablit Fact-en-premier au runtime.
  // Sans effet si l'ordre du DOM est déjà correct.
  (function ensureHeroAsideOrder() {
    const fact = document.getElementById('hero-fact-card');
    const quiz = document.getElementById('hero-quiz-card');
    if (!fact || !quiz) return;
    // compareDocumentPosition retourne DOCUMENT_POSITION_FOLLOWING (4) si
    // l'argument vient APRÈS this. Si quiz vient avant fact, on déplace fact.
    const pos = fact.compareDocumentPosition(quiz);
    if (!(pos & Node.DOCUMENT_POSITION_FOLLOWING)) {
      quiz.parentNode.insertBefore(fact, quiz);
    }
  })();

  /* =========================================================================
     INITIALIZE (updateAuthUI called automatically by nav.js)
     ========================================================================= */

  window.addEventListener('load', () => {
  });

  // Smooth page reveal
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.5s ease';
  setTimeout(() => { document.body.style.opacity = '1'; }, 100);
});