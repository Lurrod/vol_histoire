// Sentry browser — lazy loader.
//
// Stratégie : on charge sentry.min.js (~80 KB) APRÈS le LCP via requestIdleCallback,
// et seulement si le consentement RGPD analytics n'est pas explicitement refusé.
// Les erreurs survenant avant le chargement sont mémorisées dans une queue
// puis rejouées une fois Sentry initialisé.
//
// Gain : -80 KB du critical path, paint plus rapide, INP plus stable.
(function () {
  'use strict';

  var dsn;
  var meta = document.querySelector('meta[name="sentry-dsn"]');
  if (meta && meta.content) dsn = meta.content;
  if (!dsn) dsn = window.SENTRY_DSN;
  if (!dsn) return; // Pas de DSN configuré → ne rien charger

  // Consentement RGPD : si analytics explicitement refusé, on n'init pas
  try {
    var consent = JSON.parse(localStorage.getItem('cookie-consent') || 'null');
    if (consent && consent.analytics === false) return;
  } catch { /* ignore */ }

  // Queue les erreurs survenant AVANT que Sentry soit chargé
  var preloadQueue = [];
  function captureBeforeLoad(event) {
    if (preloadQueue.length < 50) preloadQueue.push(event);
  }
  window.addEventListener('error', captureBeforeLoad);
  window.addEventListener('unhandledrejection', captureBeforeLoad);

  function initSentry() {
    if (typeof window.Sentry === 'undefined') return;

    var env = window.location.hostname === 'vol-histoire.titouan-borde.com'
      ? 'production' : 'development';

    try {
      window.Sentry.init({
        dsn: dsn,
        environment: env,
        release: window.APP_VERSION || undefined,
        tracesSampleRate: 0.1,
        ignoreErrors: [
          'ResizeObserver loop limit exceeded',
          'Non-Error promise rejection captured',
          'Network request failed',
          /chrome-extension:\/\//,
          /moz-extension:\/\//,
        ],
        beforeSend: function (event) {
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

      // Rejoue les erreurs queueées
      preloadQueue.forEach(function (e) {
        try {
          if (e instanceof ErrorEvent && e.error) {
            window.Sentry.captureException(e.error);
          } else if (e instanceof PromiseRejectionEvent) {
            window.Sentry.captureException(e.reason);
          }
        } catch { /* ignore */ }
      });
      preloadQueue = [];

      // On peut maintenant retirer les listeners de queue (Sentry installe les siens)
      window.removeEventListener('error', captureBeforeLoad);
      window.removeEventListener('unhandledrejection', captureBeforeLoad);
    } catch {
      // Init silencieux en cas d'erreur (ne pas casser la page)
    }
  }

  function loadSentryScript() {
    if (window.Sentry) { initSentry(); return; }
    var s = document.createElement('script');
    s.async = true;
    s.src = 'js/vendor/sentry.min.js';
    s.onload = initSentry;
    s.onerror = function () {
      window.removeEventListener('error', captureBeforeLoad);
      window.removeEventListener('unhandledrejection', captureBeforeLoad);
    };
    document.head.appendChild(s);
  }

  // Charge Sentry après le premier idle (timeout 5s pour garantir l'exécution
  // même si le navigateur reste sous charge).
  if ('requestIdleCallback' in window) {
    requestIdleCallback(loadSentryScript, { timeout: 5000 });
  } else {
    setTimeout(loadSentryScript, 3000);
  }
})();
