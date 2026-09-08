/**
 * Jour courant dans le fuseau de référence du site.
 *
 * L'éphémérie « Ce jour-là » et l'appareil du jour doivent basculer au même
 * moment pour tout le monde, quel que soit le fuseau du visiteur ou celui du
 * serveur. On fixe donc Europe/Paris comme horloge de référence : le serveur
 * calcule le jour, le client s'y aligne (le payload transporte la date).
 *
 * Sans ça, un serveur en UTC ferait changer l'éphéméride à 2 h du matin heure
 * française, et deux visiteurs de fuseaux différents ne verraient pas le même
 * appareil du jour — ce qui retire tout intérêt au partage.
 */
const REFERENCE_TZ = 'Europe/Paris';

// 'en-CA' formate en YYYY-MM-DD, le seul format que Postgres accepte tel quel.
const FORMATTER = new Intl.DateTimeFormat('en-CA', {
  timeZone: REFERENCE_TZ,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
});

/** @returns {string} date du jour au format YYYY-MM-DD (Europe/Paris) */
function todayInParis(now = new Date()) {
  return FORMATTER.format(now);
}

module.exports = { todayInParis, REFERENCE_TZ };
