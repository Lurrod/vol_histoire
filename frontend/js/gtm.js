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
// CSP 'strict-dynamic' : le <script> GTM créé plus bas doit porter le nonce de
// la page, sinon le conteneur et ses balises personnalisées sont bloqués.
// document.currentScript n'existe que pendant l'exécution initiale de ce
// fichier : le nonce est donc capturé ici, au niveau supérieur. La propriété
// .nonce reste lisible alors que le navigateur masque l'attribut.
var gtmNonce = (function () {
  var cs = document.currentScript;
  if (!cs) return '';
  return cs.nonce || cs.getAttribute('nonce') || '';
})();

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

// Cookies GA bornés à l'hôte du site (et non au domaine parent partagé avec
// d'autres applications) et à 13 mois (33 696 000 s) au lieu des 400 jours
// par défaut. Ces réglages doivent AUSSI figurer dans la balise Google du
// conteneur GTM : c'est elle qui fait foi si les deux divergent.
gtag('set', {
  cookie_domain: window.location.hostname,
  cookie_expires: 33696000
});

// Identifiant de mesure GA4 du conteneur : cookies.js pose
// window['ga-disable-<ID>'] = true au retrait du consentement (LEGAL-005).
// Les identifiants révélés par les cookies _ga_<ID> sont ajoutés à la volée.
window.__VH_GA_IDS = ['G-V9QY0YW5E0'];

// Exposé à cookies.js — idempotent, ne charge qu'une fois.
var gtmState = { loaded: false };
window.__isGTMLoaded = function () { return gtmState.loaded; };
window.__loadGTM = (function () {
  var GTM_ID = 'GTM-KB3P52VK';
  return function loadGtm() {
    if (gtmState.loaded) return;
    gtmState.loaded = true;
    window.dataLayer.push({ 'gtm.start': new Date().getTime(), event: 'gtm.js' });
    var f = document.getElementsByTagName('script')[0];
    var j = document.createElement('script');
    j.async = true;
    if (gtmNonce) j.nonce = gtmNonce;
    j.src = 'https://www.googletagmanager.com/gtm.js?id=' + GTM_ID;
    f.parentNode.insertBefore(j, f);
  };
})();
