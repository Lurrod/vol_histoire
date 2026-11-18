/* Accueil — compteurs du hero (appareils, nations, générations) lus dans
 * /api/stats quand le bloc devient visible. Sans réponse, les valeurs du
 * HTML servi restent en place. */
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

      // Compteur odomètre (VH.rollingNumber) : les chiffres entrent un à un.
      if (elAirplanes   && Number.isFinite(data.airplanes))   VH.rollingNumber.set(elAirplanes,   data.airplanes);
      if (elCountries   && Number.isFinite(data.countries))   VH.rollingNumber.set(elCountries,   data.countries);
      if (elGenerations && Number.isFinite(data.generations)) VH.rollingNumber.set(elGenerations, data.generations);
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
