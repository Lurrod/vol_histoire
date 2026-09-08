/* global setNumberPopIn */
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

      if (elAirplanes   && Number.isFinite(data.airplanes))   setNumberPopIn(elAirplanes,   data.airplanes);
      if (elCountries   && Number.isFinite(data.countries))   setNumberPopIn(elCountries,   data.countries);
      if (elGenerations && Number.isFinite(data.generations)) setNumberPopIn(elGenerations, data.generations);
    } catch {
      // Stats API indisponible — on conserve les valeurs hardcodées du HTML SSR.
    }
  }

  /* Provided by utils.js — setNumberPopIn (number pop-in) / animateNumber */

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
     HERO SPLIT — Widgets aside (Ce jour-là + Devine l'avion du jour)
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
  const daily = (window.VH && VH.home && VH.home.heroDaily) || null;

  async function fetchHeroDiscoveries() {
    const fallbackDay = daily ? daily.localDayKey() : '';
    try {
      const res = await auth.fetchWithTimeout('/api/hero/discoveries');
      if (!res.ok) throw new Error('hero API error');
      const data = await res.json();
      const facts    = Array.isArray(data.facts)    && data.facts.length    ? data.facts    : FALLBACK_FACTS;
      const aircraft = Array.isArray(data.aircraft) && data.aircraft.length ? data.aircraft : FALLBACK_AIRCRAFT;
      const ephemeris = Array.isArray(data.ephemeris) ? data.ephemeris : [];
      // La date vient du serveur (Europe/Paris) : c'est elle qui garantit que
      // tout le monde voit le même appareil du jour, quel que soit son fuseau.
      const day = typeof data.day === 'string' && data.day ? data.day : fallbackDay;
      return { facts, aircraft, ephemeris, day };
    } catch {
      return { facts: FALLBACK_FACTS, aircraft: FALLBACK_AIRCRAFT, ephemeris: [], day: fallbackDay };
    }
  }

  /* Traduction avec repli littéral : les widgets se rendent avant que les
   * locales ne soient forcément chargées (et hors ligne elles peuvent manquer).
   * i18n.t() renvoie la clé quand elle est introuvable — on détecte ce cas
   * pour retomber sur le texte en dur. */
  function tHero(key, params, fallbackFr, fallbackEn) {
    if (typeof i18n !== 'undefined' && i18n.t) {
      const translated = i18n.t(key, params || {});
      if (translated !== key) return translated;
    }
    let out = getHeroLang() === 'en' ? fallbackEn : fallbackFr;
    Object.entries(params || {}).forEach(([k, v]) => {
      out = out.split('{' + k + '}').join(v);
    });
    return out;
  }

  /* ----- Widget 1 : Ce jour-là ----- */
  /* L'ancien widget « Saviez-vous ? » tirait un fait au hasard : jamais deux
   * fois le même, mais aucune raison de revenir demain. Il devient une
   * éphéméride — les anniversaires de la date du jour — et ne retombe sur le
   * fait éditorial que les rares jours sans anniversaire (ou hors ligne). */
  function initHeroToday(ephemeris, facts, dayKey) {
    const body   = document.getElementById('hero-fact-body');
    const link   = document.getElementById('hero-fact-link');
    const label  = document.getElementById('hero-fact-label');
    const reroll = document.getElementById('hero-fact-reroll');
    if (!body) return;

    const selection = daily ? daily.selectEphemeris(ephemeris) : { list: [], exact: false };
    const entries = selection.list;
    let index = 0;
    let fact = null;

    function setLabel(key, fr, en) {
      if (!label) return;
      label.setAttribute('data-i18n', key);
      label.textContent = tHero(key, {}, fr, en);
    }

    function setBody(dateBadge, sentenceHtml) {
      // Le corps porte data-i18n="hero_fact_loading" tant qu'il affiche son
      // texte d'attente. Sans ce retrait, applyToDOM() le remettrait à
      // « Tirage en cours… » au prochain changement de langue.
      body.removeAttribute('data-i18n');
      // Animation rejouée à chaque rendu (reflow forcé). Par classe et non par
      // style inline : la CSP interdit style-src-attr, donc écrire dans
      // body.style est bloqué par le navigateur — silencieusement côté rendu,
      // bruyamment dans la console.
      body.classList.remove('is-fading-in');
      void body.offsetWidth;
      body.classList.add('is-fading-in');
      const badge = dateBadge
        ? `<span class="hero-fact-year hero-fact-date">${escapeHtml(dateBadge)}</span>`
        : '';
      // innerHTML est sûr : le seul markup vient des balises construites ici,
      // les données passent toutes par escapeHtml().
      body.innerHTML = badge + sentenceHtml;
    }

    function renderEntry() {
      const entry = entries[index % entries.length];
      const lang = getHeroLang();
      const name = (lang === 'en' ? entry.airplane_name_en : entry.airplane_name) || entry.airplane_name || '';
      const strong = `<strong>${escapeHtml(name)}</strong>`;

      if (selection.exact) setLabel('home.hero_today_label', 'Ce jour-là', 'On this day');
      else                 setLabel('home.hero_today_label_week', 'Cette semaine-là', 'That week');

      const sentence = entry.kind === 'service'
        ? tHero('home.hero_today_service', { name: strong }, 'Mise en service : {name}', 'Entered service: {name}')
        : tHero('home.hero_today_first_flight', { name: strong }, 'Premier vol : {name}', 'First flight: {name}');

      setBody(daily.formatEventDate(entry.event_date, lang), sentence);

      if (link) {
        link.setAttribute('href', entry.airplane_id
          ? '/details?id=' + encodeURIComponent(entry.airplane_id)
          : '/hangar?search=' + encodeURIComponent(nameToSearchSlug(name)));
      }
    }

    function renderFact() {
      const lang = getHeroLang();
      const title = (lang === 'en' ? fact.title_en : fact.title_fr) || fact.title_fr || '';
      const name  = (lang === 'en' ? fact.airplane_name_en : fact.airplane_name) || fact.airplane_name || '';
      const safeTitle = escapeHtml(title);
      const safeName = escapeHtml(name);
      // On échappe puis on remet l'éventuel nom d'avion en <strong> pour
      // garder le ton "highlight" du widget.
      const bolded = safeName
        ? safeTitle.replace(safeName, `<strong>${safeName}</strong>`)
        : safeTitle;

      setLabel('home.hero_fact_label', 'Saviez-vous ?', 'Did you know?');
      setBody(fact.year ? String(fact.year) : '', bolded);

      if (link) {
        link.setAttribute('href', fact.airplane_id
          ? '/details?id=' + encodeURIComponent(fact.airplane_id)
          : (name ? '/hangar?search=' + encodeURIComponent(nameToSearchSlug(name)) : '#'));
      }
    }

    function render() {
      if (entries.length) renderEntry();
      else if (fact)      renderFact();
    }

    if (!entries.length) {
      if (!facts.length) return;
      // Même logique que l'éphéméride : le fait de repli est celui du jour,
      // identique pour tout le monde, et non un tirage par rechargement.
      fact = daily ? daily.pickDaily(facts, dayKey) : facts[0];
    }

    if (reroll) {
      // Un seul anniversaire ce jour-là : le bouton n'aurait rien à montrer.
      if (entries.length === 1) reroll.setAttribute('hidden', '');
      else reroll.addEventListener('click', () => {
        if (entries.length) index++;
        else fact = facts[Math.floor(Math.random() * facts.length)];
        render();
      });
    }

    // Le contenu est construit en JS : applyToDOM() ne le retraduit pas.
    window.addEventListener('langChanged', render);
    render();
  }

  /* ----- Widget 2 : Devine l'avion ----- */
  function initHeroQuiz(aircraft, dayKey) {
    const card    = document.getElementById('hero-quiz-card');
    const image   = document.getElementById('hero-quiz-image');
    const options = document.getElementById('hero-quiz-options');
    const link    = document.getElementById('hero-quiz-link');
    const lblLabel = document.getElementById('hero-quiz-link-label');
    const reroll  = document.getElementById('hero-quiz-reroll');
    const dailyTag = document.getElementById('hero-quiz-daily-tag');
    if (!card || !image || !options || aircraft.length < 3) return;

    let current = null;

    function shuffleWith(list, random) {
      return daily ? daily.shuffleWith(list, random) : shuffleArr(list);
    }

    function pickDecoys(target, random) {
      // Priorité aux mêmes génération pour des leurres crédibles.
      const sameGen = aircraft.filter(a => a.generation === target.generation && a.name !== target.name);
      const pool = sameGen.length >= 2 ? sameGen : aircraft.filter(a => a.name !== target.name);
      return shuffleWith(pool, random).slice(0, 2).map(a => a.name);
    }

    /* Premier chargement : l'appareil du jour, tiré d'une graine sur la date —
     * mêmes propositions dans le même ordre pour tout le monde, ce qui rend la
     * question commentable. Le bouton reroll repasse en tirage aléatoire. */
    function load(useDaily) {
      const isDaily = Boolean(useDaily && daily);
      const random = isDaily
        ? daily.seededRandom(daily.hashSeed(dayKey + ':quiz'))
        : Math.random;

      current = isDaily
        ? daily.pickDaily(aircraft, dayKey)
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

      const opts = shuffleWith([current.name, ...pickDecoys(current, random)], random);
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
        lblLabel.textContent = correct
          ? tHero('home.hero_quiz_link_correct', {}, 'Bien joué — voir la fiche', 'Well done — see the record')
          : tHero('home.hero_quiz_link_wrong', { name: current.name },
            'C’était le {name} — voir la fiche', 'It was the {name} — see the record');
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
    if (reroll) reroll.addEventListener('click', () => load(false));
    load(true);
  }

  // Fetch unique + init des deux widgets sur le même pool de données.
  (async () => {
    const { facts, aircraft, ephemeris, day } = await fetchHeroDiscoveries();
    initHeroToday(ephemeris, facts, day);
    initHeroQuiz(aircraft, day);
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