'use strict';

/**
 * Dates de calendrier (premier vol, mise en service, début d'un conflit…) :
 * des colonnes DATE, sans heure ni fuseau.
 *
 * node-postgres les rend en texte « AAAA-MM-JJ » (db.js, useCalendarDates).
 * Ces aides acceptent aussi un objet Date, que renvoyait le pilote par
 * défaut (minuit dans le fuseau du serveur) : on lit alors le jour local,
 * jamais le jour UTC, qui tombait la veille.
 */

const pad = (n) => String(n).padStart(2, '0');

/** @returns {string|null} « AAAA-MM-JJ », ou null si la valeur n'est pas une date */
function isoDay(value) {
  if (value === null || value === undefined || value === '') return null;
  if (value instanceof Date) {
    if (Number.isNaN(value.getTime())) return null;
    return `${value.getFullYear()}-${pad(value.getMonth() + 1)}-${pad(value.getDate())}`;
  }
  const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(value));
  return m ? `${m[1]}-${m[2]}-${m[3]}` : null;
}

/** @returns {number|null} année de la date */
function yearOf(value) {
  const day = isoDay(value);
  return day ? Number(day.slice(0, 4)) : null;
}

module.exports = { isoDay, yearOf };
