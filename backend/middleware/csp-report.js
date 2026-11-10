'use strict';

// -----------------------------------------------------------------------------
// Collecte des violations de la Content-Security-Policy (SEC-006).
//
// Deux formats arrivent sur POST /api/csp-report :
//   - `application/csp-report` (directive report-uri, CSP niveau 2) :
//       { "csp-report": { "document-uri", "blocked-uri", "violated-directive", … } }
//   - `application/reports+json` (directive report-to + Reporting-Endpoints) :
//       [ { "type": "csp-violation", "body": { "documentURL", "blockedURL",
//           "effectiveDirective", … } }, … ]
//
// Chaque violation est ramenée à une forme courte et journalisée en `warn`.
// Rien n'est stocké en base, et l'entrée ne porte ni IP ni user-agent. Les URL
// sont réduites à origine + chemin : une page de réinitialisation porte son
// jeton dans la chaîne de requête, il n'a rien à faire dans les journaux.
// -----------------------------------------------------------------------------

const express = require('express');

const CSP_REPORT_TYPES = ['application/csp-report', 'application/reports+json'];
/** Taille maximale d'un envoi (un rapport fait ~1 Ko ; un lot en compte quelques-uns). */
const CSP_REPORT_MAX_BYTES = '16kb';
/** Nombre maximal de violations journalisées par envoi. */
const MAX_REPORTS_PER_BATCH = 10;
/** Longueur maximale d'un champ texte journalisé. */
const MAX_FIELD_LENGTH = 200;

/** Chaîne bornée, ou undefined si la valeur n'est pas une chaîne non vide. */
function shortText(value) {
  if (typeof value !== 'string' || value === '') return undefined;
  return value.length > MAX_FIELD_LENGTH ? `${value.slice(0, MAX_FIELD_LENGTH)}…` : value;
}

/**
 * Réduit une URL à origine + chemin (ni requête, ni fragment, ni identifiants).
 * Les valeurs non-URL du rapport (« inline », « eval », « self »…) passent telles quelles.
 */
function stripUrl(value) {
  if (typeof value !== 'string' || value === '') return undefined;
  try {
    const url = new URL(value);
    if (url.protocol === 'http:' || url.protocol === 'https:') {
      return shortText(`${url.origin}${url.pathname}`);
    }
    return shortText(url.protocol.replace(/:$/, ''));
  } catch {
    return shortText(value);
  }
}

/** Entier positif ou undefined. */
function toInt(value) {
  const n = Number(value);
  return Number.isInteger(n) && n >= 0 ? n : undefined;
}

/** Ramène un rapport (ancien ou nouveau format) à la même forme courte. */
function normalizeReport(raw) {
  if (!raw || typeof raw !== 'object') return null;
  // Ancien format : clés en kebab-case.
  if (raw['document-uri'] !== undefined || raw['violated-directive'] !== undefined) {
    return {
      documentUrl: stripUrl(raw['document-uri']),
      blockedUrl: stripUrl(raw['blocked-uri']),
      directive: shortText(raw['effective-directive'] || raw['violated-directive']),
      disposition: shortText(raw.disposition),
      sourceFile: stripUrl(raw['source-file']),
      line: toInt(raw['line-number']),
      column: toInt(raw['column-number']),
      sample: shortText(raw['script-sample']),
    };
  }
  // Nouveau format (Reporting API) : corps en camelCase.
  return {
    documentUrl: stripUrl(raw.documentURL),
    blockedUrl: stripUrl(raw.blockedURL),
    directive: shortText(raw.effectiveDirective),
    disposition: shortText(raw.disposition),
    sourceFile: stripUrl(raw.sourceFile),
    line: toInt(raw.lineNumber),
    column: toInt(raw.columnNumber),
    sample: shortText(raw.sample),
  };
}

/**
 * Extrait les violations d'un corps déjà analysé, quel que soit son format.
 * @param {unknown} body
 * @returns {object[]} violations normalisées (au plus MAX_REPORTS_PER_BATCH)
 */
function extractReports(body) {
  if (Array.isArray(body)) {
    return body
      .filter((r) => r && typeof r === 'object' && r.type === 'csp-violation')
      .slice(0, MAX_REPORTS_PER_BATCH)
      .map((r) => normalizeReport(r.body))
      .filter(Boolean);
  }
  if (body && typeof body === 'object' && body['csp-report']) {
    const report = normalizeReport(body['csp-report']);
    return report ? [report] : [];
  }
  return [];
}

/**
 * Routeur POST /csp-report. Le limiteur est fourni par app.js (store mémoire
 * ou Redis, comme les autres).
 * @param {{ logger: { warn: Function }, limiter: Function }} deps
 */
function createCspReportRouter({ logger, limiter }) {
  const router = express.Router();
  const parseReport = express.json({ type: CSP_REPORT_TYPES, limit: CSP_REPORT_MAX_BYTES });

  router.post('/csp-report', limiter, parseReport, (req, res) => {
    if (!req.is(CSP_REPORT_TYPES)) {
      return res.status(415).json({ message: 'Type de contenu non pris en charge' });
    }
    for (const violation of extractReports(req.body)) {
      logger.warn('Violation CSP', violation);
    }
    res.status(204).end();
  });

  return router;
}

module.exports = {
  CSP_REPORT_TYPES,
  MAX_REPORTS_PER_BATCH,
  stripUrl,
  normalizeReport,
  extractReports,
  createCspReportRouter,
};
