/* Textes dynamiques de l'accueil (home.landing.* dans locales/*.json).
 *
 * Deux pièges couverts ici, communs aux modules de la page :
 *
 *   1. i18n.js charge le fichier de langue en asynchrone. Un module qui rend
 *      dès que son appel API répond peut passer avant lui : i18n.t() renvoie
 *      alors la clé brute — ou, avec un repli, le français sur une page en
 *      anglais. whenReady() attend que la traduction soit chargée.
 *   2. Si le fichier de langue ne charge pas du tout (hors ligne sans cache),
 *      i18n.t() renvoie la clé : on retombe sur le texte français ci-dessous
 *      plutôt que d'afficher « home.landing.count_other » au visiteur.
 *
 * Le texte statique de la page n'est pas concerné : il porte data-i18n et le
 * français écrit dans le HTML sert déjà de repli.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  const PREFIX = 'home.landing.';

  const FALLBACK_FR = {
    search_all: 'Rechercher « {q} » dans le hangar',
    search_empty: 'Aucun appareil ne correspond.',
    search_status_one: '{n} suggestion. Flèches pour parcourir.',
    search_status_other: '{n} suggestions. Flèches pour parcourir.',
    search_status_none: 'Aucune suggestion.',
    count_one: '{n} fiche',
    count_other: '{n} fiches',
    gen_short_1: '1re gén.',
    gen_short_other: '{n}e gén.',
    types_error: 'Les catégories n\'ont pas pu être chargées.',
    family_combat: 'Combat',
    family_support: 'Soutien',
    family_training: 'Formation et essais',
    family_other: 'Autres',
    end_hangar: 'Explorer le hangar',
    end_welcome: 'Bon retour, {name}',
    end_welcome_anon: 'Bon retour',
    end_empty: 'Votre collection est encore vide. Ajoutez un appareil depuis sa fiche avec le cœur, il vous attendra ici.',
    end_count_one: '{n} appareil en favoris. Le dernier ajouté :',
    end_count_other: '{n} appareils en favoris. Les derniers ajoutés :',
    end_favs_one: 'Voir mon favori',
    end_favs_other: 'Voir mes {n} favoris',
  };

  function interpolate(text, params) {
    return String(text).replace(/\{(\w+)\}/g, (m, k) => (k in params ? String(params[k]) : m));
  }

  /** Traduit home.landing.<name>, avec repli français si la clé manque. */
  function tr(name, params = {}) {
    const key = PREFIX + name;
    const i18n = root.i18n;
    if (i18n && typeof i18n.t === 'function') {
      const translated = i18n.t(key, params);
      if (translated !== key) return translated;
    }
    return interpolate(FALLBACK_FR[name] !== undefined ? FALLBACK_FR[name] : key, params);
  }

  /** Accord au nombre : <name>_one pour 1, <name>_other sinon. {n} est fourni. */
  function trn(name, n, params = {}) {
    return tr(`${name}_${n === 1 ? 'one' : 'other'}`, { ...params, n });
  }

  /** Résout quand i18n.js a chargé sa langue, ou au bout de `timeoutMs`. */
  function whenReady(timeoutMs = 3000) {
    return new Promise((resolve) => {
      const start = Date.now();
      (function check() {
        const i18n = root.i18n;
        if (!i18n || i18n.isLoaded || Date.now() - start >= timeoutMs) return resolve();
        setTimeout(check, 25);
      })();
    });
  }

  function currentLang() {
    const i18n = root.i18n;
    return (i18n && i18n.currentLang) || 'fr';
  }

  VH.home.text = { tr, trn, whenReady, currentLang, FALLBACK_FR };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.text;
  }
})();
