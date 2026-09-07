/* Code pays ISO 3166-1 alpha-3 → alpha-2 (pour flagcdn.com)
 *
 * Doit couvrir tous les codes de la table `countries` : une entrée manquante
 * ne casse rien, elle fait juste disparaître le drapeau de la carte sans le
 * moindre signal. Les vingt nations ouvertes depuis la v4.4.6 étaient dans ce
 * cas. Après tout ajout de pays dans db.sql, compléter cette table.
 *
 * Deux entités disparues n'ont pas de drapeau chez flagcdn : la Tchécoslovaquie
 * prend celui de la Tchéquie (identique), la Yougoslavie celui de la Serbie.
 */
window.VH = window.VH || {};
window.VH.shared = window.VH.shared || {};
window.VH.shared.ALPHA3_TO_ALPHA2 = {
  AFG: 'af', ARG: 'ar', AUS: 'au', BRA: 'br', CAN: 'ca',
  CHE: 'ch', CHL: 'cl', CHN: 'cn', CSK: 'cz', DEU: 'de',
  DZA: 'dz', EGY: 'eg', ESP: 'es', FIN: 'fi', FLK: 'fk',
  FRA: 'fr', GBR: 'gb', IDN: 'id', IND: 'in', IRN: 'ir',
  IRQ: 'iq', ISR: 'il', ITA: 'it', JPN: 'jp', KOR: 'kr',
  LBN: 'lb', LBY: 'ly', NLD: 'nl', PAK: 'pk', POL: 'pl',
  ROK: 'kr', ROU: 'ro', RUS: 'ru', SWE: 'se', SYR: 'sy',
  TUR: 'tr', TWN: 'tw', UKR: 'ua', USA: 'us', VNM: 'vn',
  YUG: 'rs', ZAF: 'za',
};
