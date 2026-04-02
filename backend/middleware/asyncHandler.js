'use strict';

// Enveloppe un handler async Express pour que les erreurs remontent
// automatiquement au gestionnaire d'erreurs global (app.js).
// Évite de répéter try/catch + res.status(500) dans chaque route.
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

module.exports = asyncHandler;
