/* Accueil — helpers partagés par les widgets du hero (« Ce jour-là » et
 * « Devine l'avion »). Fonctions pures ou presque, testables sous Jest. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  /** Module de tirage du jour (home/hero-daily.js), ou null s'il manque. */
  function daily() {
    return (root.VH && root.VH.home && root.VH.home.heroDaily) || null;
  }

  function getHeroLang() {
    if (typeof i18n !== 'undefined' && i18n.getLang) return i18n.getLang() === 'en' ? 'en' : 'fr';
    return document.documentElement.lang === 'en' ? 'en' : 'fr';
  }

  function shuffleArr(arr) {
    const a = arr.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }

  // "F-15 Eagle" → "f-15+eagle" (recherche du hangar, plein texte)
  function nameToSearchSlug(name) {
    return String(name || '')
      .toLowerCase()
      .trim()
      .replace(/\s+/g, '+');
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

  /** Lien d'un appareil : sa fiche si l'id est connu, sinon une recherche du hangar. */
  function airplaneHref(id, name) {
    return id
      ? '/details?id=' + encodeURIComponent(id)
      : '/hangar?search=' + encodeURIComponent(nameToSearchSlug(name));
  }

  VH.home.heroHelpers = { daily, getHeroLang, shuffleArr, nameToSearchSlug, tHero, airplaneHref };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroHelpers;
  }
})();
