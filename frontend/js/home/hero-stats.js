/* Accueil — compteurs du hero (appareils, nations, générations) lus dans
 * /api/stats quand le bloc devient visible. Sans réponse, les valeurs du
 * HTML servi restent en place. */
/* global setNumberPopIn */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  async function fetchHeroStats() {
    const elAirplanes   = document.getElementById('hero-split-stat-airplanes');
    const elCountries   = document.getElementById('hero-split-stat-countries');
    const elGenerations = document.getElementById('hero-split-stat-generations');

    if (!elAirplanes && !elCountries && !elGenerations) return;

    try {
      const res = await auth.fetchWithTimeout('/api/stats');
      if (!res.ok) throw new Error('API stats error');
      const data = await res.json();

      // setNumberPopIn (utils.js) : animation d'entrée des chiffres
      if (elAirplanes   && Number.isFinite(data.airplanes))   setNumberPopIn(elAirplanes,   data.airplanes);
      if (elCountries   && Number.isFinite(data.countries))   setNumberPopIn(elCountries,   data.countries);
      if (elGenerations && Number.isFinite(data.generations)) setNumberPopIn(elGenerations, data.generations);
    } catch {
      // Stats API indisponible — on conserve les valeurs du HTML SSR.
    }
  }

  /** Charge les compteurs une seule fois, quand la moitié du bloc est visible. */
  function observe() {
    const heroStats = document.querySelector('.hero-split-meta');
    if (!heroStats) return;

    let statsLoaded = false;
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

  VH.home.heroStats = { fetchHeroStats, observe };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroStats;
  }
})();
