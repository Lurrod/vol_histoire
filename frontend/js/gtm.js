// Google Tag Manager — lazy loader (déféré hors du critical path).
//
// Stratégie : on enregistre les consent defaults immédiatement (Google
// recommande qu'ils soient posés AVANT gtm.js sinon le consent v2 ne marche pas)
// mais on retarde le chargement de gtm.js externe au premier idle ou
// première interaction utilisateur — selon le premier qui arrive.
//
// Gain : -100 à -300 ms de blocking sur le LCP (gtm.js depuis googletagmanager
// fait ~70 Ko et déclenche plusieurs sous-requêtes).
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('consent', 'default', {
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  analytics_storage: 'denied',
  wait_for_update: 500
});

(function () {
  var GTM_ID = 'GTM-KB3P52VK';
  var loaded = false;

  function loadGtm() {
    if (loaded) return;
    loaded = true;
    window.dataLayer.push({ 'gtm.start': new Date().getTime(), event: 'gtm.js' });
    var f = document.getElementsByTagName('script')[0];
    var j = document.createElement('script');
    j.async = true;
    j.src = 'https://www.googletagmanager.com/gtm.js?id=' + GTM_ID;
    f.parentNode.insertBefore(j, f);
  }

  // Premier déclencheur qui arrive : interaction utilisateur OU 4 secondes
  // d'inactivité (= largement après le LCP et le paint initial).
  var FIRST_INTERACTIONS = ['scroll', 'mousemove', 'touchstart', 'keydown', 'click'];
  function onFirstInteraction() {
    FIRST_INTERACTIONS.forEach(function (ev) {
      window.removeEventListener(ev, onFirstInteraction, { passive: true });
    });
    loadGtm();
  }
  FIRST_INTERACTIONS.forEach(function (ev) {
    window.addEventListener(ev, onFirstInteraction, { passive: true, once: true });
  });

  // Fallback timer : si l'utilisateur ne touche à rien, on charge quand même
  // après 4 secondes (laisse le temps au LCP, au TTI et aux animations d'init).
  if ('requestIdleCallback' in window) {
    requestIdleCallback(loadGtm, { timeout: 4000 });
  } else {
    setTimeout(loadGtm, 4000);
  }
})();
