'use strict';
const { rateLimit, ipKeyGenerator } = require('express-rate-limit');

// -----------------------------------------------------------------------------
// Rate-limiter (express-rate-limit)
// -----------------------------------------------------------------------------
// Store mémoire par défaut (instance unique). Si REDIS_URL est défini,
// app.initRedis() (appelé depuis server.js avant listen) remplace les stores
// par des RedisStore pour le scaling horizontal (useRedis ci-dessous).
// -----------------------------------------------------------------------------
const LIMITER_DEFS = [
  { key: 'register',      max: 10,  msg: "Trop de tentatives d'inscription, réessayez dans 15 minutes." },
  { key: 'login',         max: 20,  msg: 'Trop de tentatives de connexion, réessayez dans 15 minutes.' },
  { key: 'global',        max: 200, msg: 'Trop de requêtes, réessayez plus tard.' },
  { key: 'refresh',       max: 30,  msg: 'Trop de tentatives de rafraîchissement, réessayez dans 15 minutes.' },
  // Saisie d'un code reçu par email (vérification, activation, nouveau mot de
  // passe, changement d'adresse) : un parcours réussi en consomme deux, une
  // faute de frappe un de plus. Chaque code a en outre son propre plafond
  // d'essais (repositories/email-tokens.js).
  { key: 'code',          max: 15,  msg: 'Trop de tentatives, réessayez dans 15 minutes.' },
  { key: 'email',         max: 3,   msg: 'Trop de demandes, réessayez dans 15 minutes.' },
  { key: 'contact',       max: 5,   msg: 'Trop de messages envoyés, réessayez dans 15 minutes.' },
  // Une page en défaut peut envoyer plusieurs rapports CSP par chargement.
  { key: 'cspReport',     max: 60,  msg: 'Trop de rapports, réessayez plus tard.' },
  // Export des données personnelles (LEGAL-011) : requête rare et coûteuse.
  { key: 'dataExport',    max: 10,  msg: "Trop de demandes d'export, réessayez dans 15 minutes." },
  // « Se déconnecter de tous les appareils » : action rare, qui écrit en base.
  { key: 'sessions',      max: 10,  msg: 'Trop de demandes, réessayez dans 15 minutes.' },
  // Vérification du mot de passe actuel (changement d'adresse ou de mot de
  // passe, suppression du compte, SEC-005) : seuls les échecs comptent, par
  // compte connecté (le limiteur est monté après authorize).
  { key: 'currentPassword', max: 10, msg: 'Trop de tentatives, réessayez dans 15 minutes.', perUser: true, failuresOnly: true },
];

function buildLimiter({ max, msg, perUser = false, failuresOnly = false }, store) {
  return rateLimit({
    windowMs: 15 * 60 * 1000,
    // v8 a renommé `max` → `limit` ; on garde un alias pour la lisibilité.
    limit: max,
    message: { message: msg },
    standardHeaders: true,
    legacyHeaders: false,
    // ipKeyGenerator normalise les IPv6 (sinon v8 bloque au boot : ERR_ERL_KEY_GEN_IPV6).
    keyGenerator: (req) => (perUser && req.user && req.user.id != null
      ? `user:${req.user.id}`
      : ipKeyGenerator(req.ip)),
    // failuresOnly : seul un refus du mot de passe actuel (403) compte ; une
    // erreur de validation (400), un conflit (409) ou un 404 ne doivent pas
    // bloquer les modifications de profil.
    ...(failuresOnly ? { skipSuccessfulRequests: true, requestWasSuccessful: (req, res) => res.statusCode !== 403 } : {}),
    skip: () => process.env.NODE_ENV === 'test',
    ...(store ? { store } : {}),
  });
}

/**
 * Crée les limiteurs de l'application. Chaque limiteur exposé est un wrapper
 * stable qui délègue à l'implémentation courante : useRedis() peut ainsi
 * remplacer le store après le montage des routes.
 * @returns {{ limiters: Object<string, Function>, useRedis: (client: object) => number }}
 */
function createRateLimiters() {
  const impl = {};
  LIMITER_DEFS.forEach((d) => { impl[d.key] = buildLimiter(d); });
  const limiters = {};
  LIMITER_DEFS.forEach((d) => {
    limiters[d.key] = (req, res, next) => impl[d.key](req, res, next);
  });

  function useRedis(client) {
    const { RedisStore } = require('rate-limit-redis');
    LIMITER_DEFS.forEach((d) => {
      impl[d.key] = buildLimiter(d, new RedisStore({
        sendCommand: (...args) => client.call(...args),
        prefix: `vdh:rl:${d.key}:`,
      }));
    });
    return LIMITER_DEFS.length;
  }

  return { limiters, useRedis };
}

module.exports = { createRateLimiters, LIMITER_DEFS };
