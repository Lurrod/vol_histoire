/* Frise — données : GET /api/timeline (backend — cache Redis 30 min). */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

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
    return keepNonEmpty(decades);
  }

  /* Totaux affichés sur la couverture. */
  function countTotals(decades) {
    return {
      events: decades.reduce((s, b) => s + (b.events?.length || 0), 0),
      aircraft: decades.reduce((s, b) => s + (b.aircraft?.length || 0), 0),
      decades: decades.length,
    };
  }

  const api = { keepNonEmpty, loadTimeline, countTotals };
  window.VH.timeline.data = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
