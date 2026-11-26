'use strict';
const fs = require('fs');
const path = require('path');
const express = require('express');

// -----------------------------------------------------------------------------
// Documentation API (Swagger UI)
// -----------------------------------------------------------------------------
// Désactivée en production (404). swagger-ui-express et yaml ne sont chargés
// que dans la branche hors production (DEVOPS-009) : le processus de prod ne
// les requiert jamais, ils vivent en devDependencies (`npm ci --omit=dev`).

// Les <script> de Swagger UI ne portent pas le nonce : la page de doc
// (hors production seulement) garde l'ancienne règle 'self'.
function relaxDocsScriptSrc(req, res, next) {
  const csp = res.getHeader('Content-Security-Policy');
  if (typeof csp === 'string') {
    res.setHeader('Content-Security-Policy', csp.replace(/script-src [^;]+/, "script-src 'self'"));
  }
  next();
}

/**
 * @param {{ env: object, sendCachedHtml: Function, frontendRoot: string }} deps
 * @returns {import('express').Router} routeur à monter sur /api/docs
 */
function createApiDocsRouter({ env, sendCachedHtml, frontendRoot }) {
  const router = express.Router();
  if (env.NODE_ENV === 'production') {
    router.use((req, res) => {
      // Page 404 servie par le cache HTML (nonce CSP posé sur ses scripts).
      res.status(404);
      sendCachedHtml(res, path.join(frontendRoot, '404.html'));
    });
    return router;
  }
  try {
    const swaggerUi = require('swagger-ui-express');
    const YAML = require('yaml');
    const backendRoot = path.join(__dirname, '..');
    const openapiDoc = YAML.parse(fs.readFileSync(path.join(backendRoot, 'openapi.yaml'), 'utf8'));
    const swaggerThemeCss = fs.readFileSync(path.join(backendRoot, 'assets/swagger-theme.css'), 'utf8');
    router.use(relaxDocsScriptSrc, swaggerUi.serve, swaggerUi.setup(openapiDoc, {
      customCss: swaggerThemeCss,
      customSiteTitle: 'Vol d\'Histoire — API Docs',
      customfavIcon: '/favicon.ico',
    }));
  } catch { /* openapi.yaml ou devDependencies absents — Swagger désactivé */ }
  return router;
}

module.exports = { createApiDocsRouter };
