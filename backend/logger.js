'use strict';
const crypto = require('crypto');

// -----------------------------------------------------------------------------
// Logger structuré — remplace les console.error/log éparpillés
// Chaque erreur reçoit un ID unique pour faciliter le support.
//
// Intégration Sentry OPTIONNELLE :
//   1. npm install @sentry/node
//   2. Variable d'environnement : SENTRY_DSN=https://xxx@sentry.io/yyy
//      (et optionnellement SENTRY_ENVIRONMENT, SENTRY_RELEASE)
//   3. Le module est chargé dynamiquement : si @sentry/node n'est pas installé
//      ou si SENTRY_DSN est absent, le logger fonctionne normalement sans Sentry.
// -----------------------------------------------------------------------------

const LEVELS = { error: 0, warn: 1, info: 2, debug: 3 };
const currentLevel = LEVELS[process.env.LOG_LEVEL] ?? LEVELS.info;

// Init Sentry conditionnel (silencieux si module ou DSN absent)
let Sentry = null;
if (process.env.SENTRY_DSN && process.env.NODE_ENV !== 'test') {
  try {
    Sentry = require('@sentry/node');
    Sentry.init({
      dsn: process.env.SENTRY_DSN,
      environment: process.env.SENTRY_ENVIRONMENT || process.env.NODE_ENV || 'production',
      release: process.env.SENTRY_RELEASE,
      tracesSampleRate: Number(process.env.SENTRY_TRACES_SAMPLE_RATE) || 0.1,
      // Filtre les erreurs de validation client (4xx) pour ne capturer que les vraies erreurs serveur
      beforeSend(event, hint) {
        const err = hint && hint.originalException;
        if (err && err.status && err.status >= 400 && err.status < 500) {
          return null;
        }
        return event;
      },
    });

    console.log(JSON.stringify({ level: 'info', message: 'Sentry activé', env: process.env.SENTRY_ENVIRONMENT }));
  } catch {
    // @sentry/node non installé — on continue sans

    console.warn(JSON.stringify({ level: 'warn', message: 'SENTRY_DSN défini mais @sentry/node non installé', hint: 'npm install @sentry/node' }));
  }
}

function formatEntry(level, message, meta = {}) {
  const entry = {
    timestamp: new Date().toISOString(),
    level,
    message,
    ...meta,
  };
  if (level === 'error') {
    entry.errorId = crypto.randomBytes(4).toString('hex');
  }
  return entry;
}

// Scrubbing PII/secrets dans les meta avant log (défense en profondeur)
let scrub;
try { scrub = require('./middleware/sanitize-logs').scrub; } catch { scrub = null; }

function log(level, message, meta) {
  if (LEVELS[level] > currentLevel) return;
  const safeMeta = (meta && scrub) ? scrub(meta) : meta;
  const entry = formatEntry(level, message, safeMeta);
  const output = JSON.stringify(entry);
  if (level === 'error' || level === 'warn') {
    console.error(output);
  } else {
    console.log(output);
  }

  // Forward vers Sentry si activé (errors only par défaut, +warn si configuré)
  if (Sentry && (level === 'error' || (level === 'warn' && process.env.SENTRY_CAPTURE_WARN === 'true'))) {
    Sentry.withScope((scope) => {
      scope.setLevel(level === 'error' ? 'error' : 'warning');
      if (entry.errorId) scope.setTag('errorId', entry.errorId);
      if (meta) {
        Object.entries(meta).forEach(([k, v]) => {
          if (k !== 'error') scope.setExtra(k, v);
        });
      }
      if (meta && meta.error instanceof Error) {
        Sentry.captureException(meta.error);
      } else {
        Sentry.captureMessage(message);
      }
    });
  }

  return entry;
}

module.exports = {
  error: (message, meta) => log('error', message, meta),
  warn:  (message, meta) => log('warn',  message, meta),
  info:  (message, meta) => log('info',  message, meta),
  debug: (message, meta) => log('debug', message, meta),
  // Exposé pour les tests + flush graceful shutdown
  isSentryEnabled: () => Sentry !== null,
  flushSentry: (timeoutMs = 2000) => (Sentry ? Sentry.close(timeoutMs) : Promise.resolve()),
};
