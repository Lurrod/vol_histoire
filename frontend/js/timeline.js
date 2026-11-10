/* Vol d'Histoire — Timeline cinématographique « Le Journal de Bord »
   Récit scroll-driven : couverture → chapitre par décennie (title card +
   narratif éditorial + événements marquants + grille d'appareils) → générique.
   Données : GET /api/timeline (backend — cache Redis 30 min).

   Orchestrateur : les modules VH.timeline.* (util, era, data, render,
   observers, effects, keyboard) sont concaténés avant ce fichier dans
   timeline.min.js (scripts/build-js.js).
*/
document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  const T = VH.timeline;
  const hideLoading = () => document.getElementById('tl-loading')?.classList.add('gone');

  function renderAll(decades) {
    T.render.renderChapters(decades);
    T.render.renderMinimap(decades);
  }

  function animateTotals(decades) {
    const totals = T.data.countTotals(decades);
    T.effects.animateCounter(document.getElementById('tl-stat-events'), totals.events);
    T.effects.animateCounter(document.getElementById('tl-stat-aircraft'), totals.aircraft);
    T.effects.animateCounter(document.getElementById('tl-stat-decades'), totals.decades);
  }

  document.body.classList.add('tl-has-cinematic');
  T.effects.initParticles();

  try {
    const decades = await T.data.loadTimeline();

    if (!decades.length) {
      T.render.renderMessage(i18n.t('timeline.no_aircraft') || '—');
      hideLoading();
      return;
    }

    renderAll(decades);
    animateTotals(decades);

    T.observers.observeChapters();
    T.effects.initProgress();
    T.keyboard.initKeyboard(decades);

    // Re-render sur changement de langue — textes d'ère/événements proviennent d'i18n
    window.addEventListener('langChanged', () => {
      renderAll(decades);
      T.observers.observeChapters();
    });

    requestAnimationFrame(hideLoading);

  } catch {
    hideLoading();
    T.render.renderMessage(i18n.t('common.loading_error') || 'Erreur de chargement.');
    if (typeof showToast === 'function') {
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }
});
