/* Dates clés de la fiche : conception, premier vol, mise en service.
 *
 * La base ne connaît souvent que le mois (date posée au 1er) ou l'année
 * (posée au 1er janvier) — 223 mises en service sur 330 tombent un 1er.
 * La fiche n'affiche donc que la précision réelle (« mai 2001 », « 1982 »),
 * comme l'éphéméride de l'accueil, et chaque jalon dit combien de temps
 * l'a séparé du précédent (« 3 ans et 6 mois plus tard »). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  const MILESTONES = [
    ['date-concept', 'date_concept'],
    ['date-first-fly', 'date_first_fly'],
    ['date-operational', 'date_operationel'],
  ];

  /* Date de calendrier lue chiffre par chiffre (VH.calendarDate) et formatée
   * en UTC : lue dans le fuseau du visiteur, elle reculait d'un jour aux
   * Amériques (« 31 décembre 1977 » pour une date connue à l'année 1978).
   * @returns {{ date: Date, year: number, month: number, day: number,
   *             precision: 'day'|'month'|'year' }|null} mois de 1 à 12 */
  function parse(value) {
    const p = window.VH.calendarDate.parts(value);
    if (!p) return null;
    let precision = 'day';
    if (p.day === 1) precision = p.month === 1 ? 'year' : 'month';
    return { ...p, date: window.VH.calendarDate.toUTCDate(value), precision };
  }

  function format(value, lang) {
    const p = parse(value);
    if (!p) return i18n.t('details.not_specified');
    const locale = lang === 'en' ? 'en-GB' : 'fr-FR';
    if (p.precision === 'year') return String(p.year);
    const opts = p.precision === 'month'
      ? { year: 'numeric', month: 'long', timeZone: 'UTC' }
      : { year: 'numeric', month: 'long', day: 'numeric', timeZone: 'UTC' };
    return p.date.toLocaleDateString(locale, opts);
  }

  /** Écart entre deux jalons, à la précision du moins précis des deux.
   *  @returns {{ years: number, months: number, approx: boolean }|null} */
  function span(fromValue, toValue) {
    const a = parse(fromValue);
    const b = parse(toValue);
    if (!a || !b) return null;
    if (a.precision === 'year' || b.precision === 'year') {
      const years = b.year - a.year;
      return years > 0 ? { years, months: 0, approx: true } : null;
    }
    let months = (b.year - a.year) * 12 + (b.month - a.month);
    // Au jour près seulement si les deux dates le sont.
    if (a.precision === 'day' && b.precision === 'day' && b.day < a.day) months -= 1;
    if (months <= 0) return null;
    return { years: Math.floor(months / 12), months: months % 12, approx: false };
  }

  function unit(n, one, many) {
    return i18n.t(n > 1 ? many : one, { n });
  }

  function spanText(s) {
    const parts = [];
    if (s.years) parts.push(unit(s.years, 'details.span_year', 'details.span_years'));
    if (s.months) parts.push(unit(s.months, 'details.span_month', 'details.span_months'));
    const text = parts.length === 2 ? i18n.t('details.span_and', { a: parts[0], b: parts[1] }) : parts[0];
    return i18n.t(s.approx ? 'details.span_after_approx' : 'details.span_after', { span: text });
  }

  function render(a) {
    const lang = i18n.currentLang;
    let previous = null; // dernier jalon connu
    MILESTONES.forEach(([id, field]) => {
      const item = document.getElementById(id);
      if (!item) return;
      const value = a[field];
      item.querySelector('.timeline-date').textContent = format(value, lang);
      const spanEl = item.querySelector('.milestone-span');
      const s = previous ? span(previous, value) : null;
      if (spanEl) {
        spanEl.textContent = s ? spanText(s) : '';
        spanEl.hidden = !s;
      }
      if (parse(value)) previous = value;
    });
  }

  const api = { parse, format, span, spanText, render };
  window.VH.details.keyDates = api;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
