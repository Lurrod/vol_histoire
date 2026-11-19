/* Vol d'Histoire — Frise « Le Journal de Bord »
   Récit par décennie : couverture → règle des années (fixe) → chapitres
   (title card, récit, événements, conflits ouverts, appareils marquants puis
   piste année par année) → générique.
   Données : GET /api/timeline (backend — cache Redis 30 min). Le serveur rend
   déjà récits, événements, conflits et appareils (SEO) ; ce script les
   remplace par la version interactive.

   Orchestrateur : les modules VH.timeline.* (util, era, data, ruler, render,
   lens, observers, keyboard) sont concaténés avant ce fichier dans
   timeline.min.js (scripts/build-js.js).
*/
document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  const T = VH.timeline;
  const hideLoading = () => document.getElementById('tl-loading')?.classList.add('gone');

  function setCounter(id, value) {
    const el = document.getElementById(id);
    if (el && window.VH.rollingNumber) VH.rollingNumber.set(el, value);
    else if (el) el.textContent = String(value);
  }

  document.body.classList.add('tl-has-cinematic');
  T.ruler.syncBarTop();

  try {
    // La frise ne se rend pas avant la langue : sinon i18n.t renvoie les
    // clés (« timeline.chapter_label · 01 »).
    const [{ decades, wars }] = await Promise.all([T.data.loadTimeline(), T.util.whenI18nReady()]);

    if (!decades.length) {
      T.render.renderMessage(T.util.t('timeline.no_aircraft', '—'));
      hideLoading();
      return;
    }

    const options = T.data.lensOptions(decades, T.util.currentLang());
    let lens = T.data.readLens(window.location.search, options);

    const draw = () => {
      const view = T.data.applyLens(decades, wars, lens);
      T.render.renderChapters(view.decades, view.wars, lens);
      T.ruler.render(decades, view.wars);
      T.observers.observeChapters();
      T.lens.announce(lens, T.data.countTotals(view.decades).aircraft);
    };

    // Changement de filtre : les appareils restés visibles glissent vers
    // leur nouvelle place, les autres s'effacent (VH.viewMorph).
    lens = T.lens.init(options, lens, next => {
      lens = next;
      if (VH.viewMorph) VH.viewMorph.swap({ root: document.getElementById('tl-chapters'), update: draw });
      else draw();
    });
    draw();

    const totals = T.data.countTotals(decades, wars);
    setCounter('tl-stat-events', totals.events);
    setCounter('tl-stat-aircraft', totals.aircraft);
    setCounter('tl-stat-wars', totals.wars);

    T.keyboard.initKeyboard(decades);

    // Re-rendu sur changement de langue — textes d'ère et d'événements
    // proviennent d'i18n.
    window.addEventListener('langChanged', draw);

    requestAnimationFrame(() => {
      T.ruler.jumpToHash(window.location.hash);
      hideLoading();
    });

  } catch {
    hideLoading();
    // Le serveur a déjà écrit les chapitres : on les garde, le toast suffit.
    if (!document.querySelector('#tl-chapters .tl-chapter--ssr')) {
      T.render.renderMessage(T.util.t('common.loading_error', 'Erreur de chargement.'));
    }
    if (typeof showToast === 'function') {
      showToast(T.util.t('common.loading_error', 'Erreur de chargement.'), 'error');
    }
  }
});
