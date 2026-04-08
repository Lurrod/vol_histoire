// Sentry browser init — chargé sur toutes les pages.
// Configuration : définir window.SENTRY_DSN dans une page ou via un meta tag.
// Respecte le consentement RGPD : ne s'initialise que si l'utilisateur a accepté.
(function () {
  'use strict';

  if (typeof window === 'undefined' || typeof window.Sentry === 'undefined') return;

  // 1. DSN : meta tag <meta name="sentry-dsn" content="..."> ou window.SENTRY_DSN
  var meta = document.querySelector('meta[name="sentry-dsn"]');
  var dsn = (meta && meta.content) || window.SENTRY_DSN;
  if (!dsn) return;

  // 2. Consentement RGPD : on attend l'accord cookies "analytics" si présent
  var consent;
  try { consent = JSON.parse(localStorage.getItem('cookie-consent') || 'null'); } catch (e) {}
  if (consent && consent.analytics === false) return;

  // 3. Environnement : prod si hostname == vol-histoire.titouan-borde.com
  var env = window.location.hostname === 'vol-histoire.titouan-borde.com' ? 'production' : 'development';

  try {
    window.Sentry.init({
      dsn: dsn,
      environment: env,
      release: window.APP_VERSION || undefined,
      tracesSampleRate: 0.1,
      // Filtre le bruit : extensions navigateur + erreurs réseau bénignes
      ignoreErrors: [
        'ResizeObserver loop limit exceeded',
        'Non-Error promise rejection captured',
        'Network request failed',
        /chrome-extension:\/\//,
        /moz-extension:\/\//,
      ],
      beforeSend: function (event) {
        // Ne pas envoyer les erreurs venant d'extensions
        if (event.exception && event.exception.values) {
          var frames = event.exception.values[0] && event.exception.values[0].stacktrace
            && event.exception.values[0].stacktrace.frames;
          if (frames && frames.some(function (f) {
            return /extension:\/\//.test(f.filename || '');
          })) return null;
        }
        return event;
      },
    });
  } catch (e) {
    // Sentry init silencieux en cas d'erreur (ne pas casser la page)
  }
})();
