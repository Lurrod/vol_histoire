/* Widgets « du jour » de la home — logique pure, testable hors navigateur.
 *
 * Deux mécaniques y sont regroupées :
 *
 *   1. l'éphéméride : parmi les anniversaires renvoyés par l'API (fenêtre de
 *      ±3 jours autour de la date du jour), ne garder que les plus proches ;
 *   2. le tirage du jour : choisir un appareil dans une liste de façon
 *      déterministe, pour que tous les visiteurs voient le même le même jour.
 *
 * Le tirage n'est pas Math.random() : un tirage aléatoire donne un contenu
 * différent à chaque rechargement, donc jamais de contenu « du jour » qu'on
 * puisse commenter ou partager. Le générateur (mulberry32, amorcé par un hash
 * de la date) est reproductible d'un visiteur à l'autre et d'un jour à l'autre.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  /* ---------- Tirage déterministe ---------- */

  /** Hash 32 bits (FNV-1a) d'une chaîne — sert de graine au générateur. */
  function hashSeed(str) {
    let h = 2166136261;
    for (let i = 0; i < String(str).length; i++) {
      h ^= String(str).charCodeAt(i);
      h = Math.imul(h, 16777619);
    }
    return h >>> 0;
  }

  /** PRNG déterministe (mulberry32) : même graine → même suite de tirages. */
  function seededRandom(seed) {
    let a = seed >>> 0;
    return function () {
      a = (a + 0x6D2B79F5) >>> 0;
      let t = a;
      t = Math.imul(t ^ (t >>> 15), t | 1);
      t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }

  /** Index stable dans une liste de `length` éléments pour une clé donnée.
   *  Conservé pour les listes sans identifiant (les faits éditoriaux de repli). */
  function dailyIndex(dayKey, length) {
    if (!length || length < 1) return -1;
    return hashSeed(dayKey) % length;
  }

  /** Identité stable d'un élément : l'id de la fiche si elle en a un. */
  function identite(item, position) {
    if (item && item.id != null) return 'id:' + item.id;
    if (item && item.airplane_id != null) return 'ap:' + item.airplane_id;
    return 'pos:' + position; // repli : listes sans identifiant (FALLBACK_*)
  }

  /** Élément « du jour ».
   *
   *  Le tirage porte sur l'identifiant, pas sur la position : un index modulo la
   *  longueur décale TOUTE la liste dès qu'une fiche est ajoutée, et l'appareil
   *  du jour changeait alors en pleine journée (constaté : 383 → 387 fiches
   *  suffisaient). Ici on retient l'élément dont le hash(id + jour) est le plus
   *  petit — ajouter une fiche ne peut changer le résultat que si la nouvelle
   *  gagne, soit une chance sur N, et jamais pour les autres jours. */
  function pickDaily(list, dayKey) {
    if (!Array.isArray(list) || !list.length) return null;
    let gagnant = null;
    let meilleur = Infinity;
    list.forEach((item, i) => {
      const score = hashSeed(dayKey + '|' + identite(item, i));
      if (score < meilleur) { meilleur = score; gagnant = item; }
    });
    return gagnant;
  }

  /** Mélange de Fisher-Yates alimenté par un générateur fourni (donc
   *  reproductible si le générateur l'est). */
  function shuffleWith(list, random) {
    const a = list.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }

  /* ---------- Éphéméride ---------- */

  /** Ne garde que les anniversaires les plus proches de la date du jour.
   *  `exact` distingue « Ce jour-là » (jour pile) de « Cette semaine-là ». */
  function selectEphemeris(entries) {
    if (!Array.isArray(entries) || !entries.length) return { list: [], exact: false };
    const best = entries.reduce((min, e) => Math.min(min, Number(e.day_gap) || 0), Infinity);
    return {
      list: entries.filter(e => (Number(e.day_gap) || 0) === best),
      exact: best === 0,
    };
  }

  /** « 8 sept. 1968 » / « 8 Sep 1968 ». La date arrive en YYYY-MM-DD : on la
   *  lit en UTC, sinon un visiteur à l'ouest de Greenwich verrait la veille. */
  function formatEventDate(iso, lang) {
    const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(iso || ''));
    if (!match) return '';
    const date = new Date(Date.UTC(+match[1], +match[2] - 1, +match[3]));
    try {
      return new Intl.DateTimeFormat(lang === 'en' ? 'en-GB' : 'fr-FR', {
        day: 'numeric', month: 'short', year: 'numeric', timeZone: 'UTC',
      }).format(date);
    } catch {
      return `${match[3]}/${match[2]}/${match[1]}`;
    }
  }

  /** Date du jour côté client, en repli quand l'API n'a pas répondu (mode
   *  hors ligne). Le fuseau du visiteur remplace alors Europe/Paris : deux
   *  visiteurs peuvent voir deux appareils différents, ce qui est sans
   *  conséquence puisqu'ils sont déjà sur des données de repli. */
  function localDayKey(now = new Date()) {
    const pad = (n) => String(n).padStart(2, '0');
    return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
  }

  VH.home.heroDaily = {
    hashSeed, seededRandom, dailyIndex, identite, pickDaily, shuffleWith,
    selectEphemeris, formatEventDate, localDayKey,
  };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroDaily;
  }
})();
