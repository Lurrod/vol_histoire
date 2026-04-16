// Google Tag Manager — chargement conditionné au consentement (conformité CNIL).
//
// 1. On enregistre immédiatement les Consent Defaults v2 sur 'denied' (requis
//    par Google Consent Mode v2 AVANT tout appel à gtm.js).
// 2. Le script externe https://www.googletagmanager.com/gtm.js N'EST PAS CHARGÉ
//    automatiquement. Il ne se charge que si l'utilisateur a explicitement
//    accordé le consentement 'analytics' via la bannière cookies (cookies.js
//    appelle window.__loadGTM() dans applyConsent()).
//
// Jurisprudence CNIL (délib. 2020-091 + décision 10/02/2022 sur Google
// Analytics) : charger gtm.js transmet IP + URL à Google → doit avoir
// consentement préalable, même en mode "cookieless ping".
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('consent', 'default', {
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  analytics_storage: 'denied',
  functionality_storage: 'denied',
  personalization_storage: 'denied',
  security_storage: 'granted',
  wait_for_update: 500
});

// Exposé à cookies.js — idempotent, ne charge qu'une fois.
window.__loadGTM = (function () {
  var GTM_ID = 'GTM-KB3P52VK';
  var loaded = false;
  return function loadGtm() {
    if (loaded) return;
    loaded = true;
    window.dataLayer.push({ 'gtm.start': new Date().getTime(), event: 'gtm.js' });
    var f = document.getElementsByTagName('script')[0];
    var j = document.createElement('script');
    j.async = true;
    j.src = 'https://www.googletagmanager.com/gtm.js?id=' + GTM_ID;
    f.parentNode.insertBefore(j, f);
  };
})();
