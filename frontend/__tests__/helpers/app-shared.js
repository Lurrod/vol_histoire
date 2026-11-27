/* Mise en place commune des tests (jest.config.json, setupFiles).
 *
 * En production, app.min.js charge VH.calendarDate (shared/calendar-date.js)
 * sur toutes les pages, avant les modules qui l'utilisent. Beaucoup de tests
 * remplacent window.VH par un objet neuf : on y raccroche le module à chaque
 * affectation, comme si app.min.js l'avait déjà posé. */
// Environnement node (sw.test.js) : pas de window, rien à poser.
if (typeof window !== 'undefined') {
  const calendarDate = require('../../js/shared/calendar-date');
  let vh = window.VH;
  Object.defineProperty(window, 'VH', {
    configurable: true,
    enumerable: true,
    get: () => vh,
    set: (value) => {
      vh = value;
      if (value && typeof value === 'object' && !value.calendarDate) value.calendarDate = calendarDate;
    },
  });
  window.VH = vh || {};
}
