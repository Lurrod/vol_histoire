'use strict';
const logger = require('../logger');
const observability = require('./observability');

// -----------------------------------------------------------------------------
// Gestionnaire d'erreurs global
// -----------------------------------------------------------------------------
// Erreurs de lecture du corps (body-parser) : la faute est côté client. Elles
// répondaient 500 et chacune produisait une ligne « Erreur non gérée » avec sa
// pile (SEC-002). `err.type` est posé par body-parser.
const BODY_ERRORS = {
  'entity.parse.failed': { status: 400, message: 'Corps de requête JSON invalide' },
  'entity.too.large': { status: 413, message: 'Corps de requête trop volumineux (100 Ko maximum)' },
  'encoding.unsupported': { status: 415, message: 'Encodage du corps non pris en charge' },
  'charset.unsupported': { status: 415, message: 'Jeu de caractères non pris en charge' },
  'request.aborted': { status: 400, message: 'Requête interrompue' },
  'request.size.invalid': { status: 400, message: 'Taille de requête incohérente' },
  'stream.encoding.set': { status: 400, message: 'Requête invalide' },
};

function errorHandler(err, req, res, _next) {
  if (err.message === 'Origine non autorisée par CORS') {
    return res.status(403).json({ message: 'Origine non autorisée' });
  }
  const bodyError = BODY_ERRORS[err.type];
  if (bodyError) {
    logger.debug('Corps de requête rejeté', { reqId: req.id, path: req.path, type: err.type });
    return res.status(bodyError.status).json({ message: bodyError.message });
  }
  // Passer l'objet Error complet (pas err.message string) → permet à Sentry
  // de capturer la stack trace via captureException(meta.error).
  observability.errorsTotal.inc({ type: 'unhandled' });
  const entry = logger.error('Erreur non gérée', {
    error: err,
    reqId: req.id,
    path: req.path,
    method: req.method,
    status: err.status || 500,
    userId: req.user?.id,
    userRole: req.user?.role,
  });
  return res.status(500).json({ message: 'Erreur interne du serveur', errorId: entry.errorId });
}

module.exports = { errorHandler };
