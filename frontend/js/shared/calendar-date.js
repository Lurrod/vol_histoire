/* VH.calendarDate — dates de calendrier (premier vol, mise en service,
 * début d'un conflit…).
 *
 * L'API les envoie en « AAAA-MM-JJ » (backend/db.js, useCalendarDates) : une
 * date sans heure ni fuseau. new Date('1978-01-01') la placerait à minuit
 * UTC, et un visiteur des Amériques lirait la veille — « 31 décembre 1977 »
 * au lieu de 1978. On lit donc les trois nombres, et on formate en UTC.
 *
 * Ancien format, encore servi par un onglet ouvert avant la mise à jour :
 * « 1986-09-30T23:00:00.000Z », minuit heure de Paris converti en UTC. On
 * retrouve alors le jour dans le fuseau du serveur.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const SERVER_TZ = 'Europe/Paris';
  const DAY = /^(\d{4})-(\d{2})-(\d{2})$/;
  let parisDay = null;

  /** @returns {string|null} « AAAA-MM-JJ » */
  function iso(value) {
    if (value === null || value === undefined || value === '') return null;
    const text = String(value);
    if (DAY.test(text)) return text;
    const date = value instanceof Date ? value : new Date(text);
    if (Number.isNaN(date.getTime())) return null;
    try {
      // 'en-CA' formate en AAAA-MM-JJ.
      parisDay = parisDay || new Intl.DateTimeFormat('en-CA', {
        timeZone: SERVER_TZ, year: 'numeric', month: '2-digit', day: '2-digit',
      });
      return parisDay.format(date);
    } catch {
      return date.toISOString().slice(0, 10);
    }
  }

  /** @returns {{ year: number, month: number, day: number }|null} mois de 1 à 12 */
  function parts(value) {
    const day = iso(value);
    if (!day) return null;
    const [year, month, d] = day.split('-').map(Number);
    return { year, month, day: d };
  }

  /** @returns {number|null} */
  function year(value) {
    const p = parts(value);
    return p ? p.year : null;
  }

  /** Date à minuit UTC : à formater avec { timeZone: 'UTC' }. */
  function toUTCDate(value) {
    const p = parts(value);
    return p ? new Date(Date.UTC(p.year, p.month - 1, p.day)) : null;
  }

  const api = { iso, parts, year, toUTCDate };
  root.VH.calendarDate = api;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
