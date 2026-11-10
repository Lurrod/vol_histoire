/* Accueil — données des widgets du hero : un seul appel à
 * /api/hero/discoveries, avec des données de repli quand l'API ne répond
 * pas (PWA hors ligne, panne). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

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

  /** Réponse de l'API → données des widgets, avec repli champ par champ. */
  function normalizeDiscoveries(data, fallbackDay) {
    const facts    = Array.isArray(data.facts)    && data.facts.length    ? data.facts    : FALLBACK_FACTS;
    const aircraft = Array.isArray(data.aircraft) && data.aircraft.length ? data.aircraft : FALLBACK_AIRCRAFT;
    const ephemeris = Array.isArray(data.ephemeris) ? data.ephemeris : [];
    // La date vient du serveur (Europe/Paris) : c'est elle qui garantit que
    // tout le monde voit le même appareil du jour, quel que soit son fuseau.
    const day = typeof data.day === 'string' && data.day ? data.day : fallbackDay;
    return { facts, aircraft, ephemeris, day };
  }

  async function fetchHeroDiscoveries() {
    const daily = VH.home.heroHelpers.daily();
    const fallbackDay = daily ? daily.localDayKey() : '';
    try {
      const res = await auth.fetchWithTimeout('/api/hero/discoveries');
      if (!res.ok) throw new Error('hero API error');
      return normalizeDiscoveries(await res.json(), fallbackDay);
    } catch {
      return { facts: FALLBACK_FACTS, aircraft: FALLBACK_AIRCRAFT, ephemeris: [], day: fallbackDay };
    }
  }

  VH.home.heroData = { FALLBACK_FACTS, FALLBACK_AIRCRAFT, normalizeDiscoveries, fetchHeroDiscoveries };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroData;
  }
})();
