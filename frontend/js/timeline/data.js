/* Frise — données : GET /api/timeline, sélection des appareils marquants,
 * regroupement par année, filtres « par nation » et « par type ».
 * Fonctions pures : aucune ne modifie les données reçues. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  // Appareils mis en avant par décennie (deux rangées de quatre cartes) ; les
  // autres passent dans la « piste » compacte, rangés par année.
  const FEATURED_MAX = 8;

  /* Ne garde que les décennies avec événement ou appareil — évite les
   * chapitres vides en milieu de frise. */
  function keepNonEmpty(decades) {
    return decades.filter(d => (d.events && d.events.length > 0) ||
                               (d.aircraft && d.aircraft.length > 0));
  }

  async function loadTimeline() {
    const r = await auth.fetchWithTimeout('/api/timeline');
    if (!r.ok) throw new Error('timeline fetch failed: ' + r.status);
    const payload = await r.json();
    const decades = Array.isArray(payload.decades) ? payload.decades : [];
    const wars = Array.isArray(payload.wars) ? payload.wars : [];
    return { decades: keepNonEmpty(decades), wars };
  }

  /* Totaux affichés sur la couverture. */
  function countTotals(decades, wars = []) {
    return {
      events: decades.reduce((s, b) => s + (b.events?.length || 0), 0),
      aircraft: decades.reduce((s, b) => s + (b.aircraft?.length || 0), 0),
      wars: wars.length,
      decades: decades.length,
    };
  }

  /* Appareils marquants d'une décennie : d'abord ceux qu'un événement raconte,
   * puis les plus produits (le nombre d'exemplaires est le meilleur indice
   * dont dispose la base). Affichés dans l'ordre chronologique. */
  function splitAircraft(bucket, max = FEATURED_MAX) {
    const aircraft = bucket.aircraft || [];
    const byId = new Map(aircraft.map(a => [a.id, a]));
    const chosen = [];
    (bucket.events || []).forEach(ev => {
      const a = ev.airplane && byId.get(ev.airplane.id);
      if (a && !chosen.includes(a) && chosen.length < max) chosen.push(a);
    });
    const byProduction = aircraft
      .filter(a => !chosen.includes(a) && Number.isFinite(a.units_built) && a.units_built > 0)
      .sort((x, y) => y.units_built - x.units_built || x.year - y.year);
    for (const a of byProduction) {
      if (chosen.length >= max) break;
      chosen.push(a);
    }
    const featured = aircraft.filter(a => chosen.includes(a));
    const others = aircraft.filter(a => !chosen.includes(a));
    return { featured, others };
  }

  /* [{ year, aircraft }] par année croissante. */
  function groupByYear(aircraft) {
    const groups = new Map();
    aircraft.forEach(a => {
      if (!groups.has(a.year)) groups.set(a.year, []);
      groups.get(a.year).push(a);
    });
    return Array.from(groups.entries())
      .sort((x, y) => x[0] - y[0])
      .map(([year, list]) => ({ year, aircraft: list }));
  }

  /* Conflits ouverts pendant la décennie (chacun n'apparaît qu'une fois :
   * dans le chapitre de son début). */
  function warsOfDecade(wars, decade) {
    return wars
      .filter(w => w.era_decade === decade)
      .sort((x, y) => x.start_year - y.start_year || String(x.name).localeCompare(String(y.name)));
  }

  /* ------------------------------------------------------------------ */
  /* Filtres                                                             */
  /* ------------------------------------------------------------------ */

  const EMPTY_LENS = Object.freeze({ nation: null, type: null });

  function isLensActive(lens) {
    return Boolean(lens && (lens.nation || lens.type));
  }

  function matchesLens(a, lens) {
    if (!lens) return true;
    if (lens.nation && a.country_name !== lens.nation) return false;
    if (lens.type && a.type_name !== lens.type) return false;
    return true;
  }

  /* Décennies filtrées (événements conservés : ils forment le récit) et
   * conflits où l'un des appareils retenus est engagé. */
  function applyLens(decades, wars, lens) {
    if (!isLensActive(lens)) return { decades, wars };
    const kept = new Set();
    const filtered = decades.map(d => {
      const aircraft = (d.aircraft || []).filter(a => matchesLens(a, lens));
      aircraft.forEach(a => kept.add(a.id));
      return { ...d, aircraft };
    });
    const keptWars = wars
      .map(w => ({ ...w, lens_count: (w.aircraft_ids || []).filter(id => kept.has(id)).length }))
      .filter(w => w.lens_count > 0);
    return { decades: filtered, wars: keptWars };
  }

  /* Valeurs proposées par les deux listes : clé = nom français canonique
   * (comme les filtres du hangar), libellé dans la langue courante. */
  function lensOptions(decades, lang = 'fr') {
    const nations = new Map();
    const types = new Map();
    const add = (map, key, label) => {
      if (!key) return;
      const prev = map.get(key);
      map.set(key, { value: key, label: label || key, count: (prev ? prev.count : 0) + 1 });
    };
    decades.forEach(d => (d.aircraft || []).forEach(a => {
      add(nations, a.country_name, lang === 'en' ? a.country_name_en : a.country_name);
      add(types, a.type_name, lang === 'en' ? a.type_name_en : a.type_name);
    }));
    const sorted = map => Array.from(map.values())
      .sort((x, y) => x.label.localeCompare(y.label, lang));
    return { nations: sorted(nations), types: sorted(types) };
  }

  /* Filtre lu dans l'URL (?nation=…&type=…) ; une valeur inconnue est ignorée. */
  function readLens(search, options) {
    const p = new URLSearchParams(search || '');
    const pick = (key, list) => {
      const v = p.get(key);
      return v && list.some(o => o.value === v) ? v : null;
    };
    return { nation: pick('nation', options.nations), type: pick('type', options.types) };
  }

  /* Chaîne de requête du filtre (sans « ? »). */
  function lensQuery(lens) {
    const p = new URLSearchParams();
    if (lens && lens.nation) p.set('nation', lens.nation);
    if (lens && lens.type) p.set('type', lens.type);
    return p.toString();
  }

  /* Lien vers le hangar filtré sur la décennie (et le filtre courant). */
  function hangarUrl(decade, lens) {
    const p = new URLSearchParams({ decade: String(decade) });
    if (lens && lens.nation) p.set('country', lens.nation);
    if (lens && lens.type) p.set('type', lens.type);
    return `/hangar?${p.toString()}`;
  }

  const api = {
    FEATURED_MAX,
    EMPTY_LENS,
    keepNonEmpty,
    loadTimeline,
    countTotals,
    splitAircraft,
    groupByYear,
    warsOfDecade,
    isLensActive,
    matchesLens,
    applyLens,
    lensOptions,
    readLens,
    lensQuery,
    hangarUrl,
  };
  window.VH.timeline.data = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
