'use strict';
const crypto = require('crypto');

// -----------------------------------------------------------------------------
// Sécurité : en-têtes HTTP et CSP à nonce
// -----------------------------------------------------------------------------
// Nonce CSP : généré par requête, injecté dans chaque <style> servi par
// sendCachedHtml + dans le header style-src-elem. Les vieux navigateurs
// (sans support style-src-elem) tombent sur style-src, également nonce-based
// depuis v4.1.1 — plus d'unsafe-inline. Les modernes (~99%) passent par
// style-src-elem et bloquent toute injection de <style> XSS.
function cspNonce(req, res, next) {
  res.locals.cspNonce = crypto.randomBytes(16).toString('base64');
  next();
}

// Remontée des violations CSP (SEC-006) : `report-to` pour les navigateurs qui
// implémentent la Reporting API, `report-uri` pour les autres (Firefox). Les
// deux visent la même route, qui accepte les deux formats.
const CSP_REPORT_PATH = '/api/csp-report';
const CSP_REPORT_GROUP = 'csp-endpoint';
const STYLE_HOSTS = 'https://hcaptcha.com https://*.hcaptcha.com';

function buildCsp(nonce) {
  return [
    "default-src 'self'",
    // Scripts : nonce + 'strict-dynamic' (SEC-006). Chaque <script src> local
    // reçoit le nonce de la requête (injectCspNonce) ; un script ainsi approuvé
    // peut en charger d'autres par createElement — gtm.js après consentement,
    // puis les balises du conteneur GTM, l'API hCaptcha, le SDK Sentry local.
    // Un <script> injecté dans le HTML, lui, n'a pas le nonce : il est bloqué,
    // même s'il vise googletagmanager.com (contournement connu d'une liste
    // d'hôtes, que le chemin /gtm.js ne fermait pas : l'identifiant du
    // conteneur passe en paramètre). Les navigateurs qui comprennent
    // 'strict-dynamic' ignorent 'self' et les hôtes ; ceux-ci ne servent qu'aux
    // très anciens navigateurs. Le CDN Sentry a disparu : le SDK est servi en
    // local (js/vendor/sentry.min.js).
    `script-src 'nonce-${nonce}' 'strict-dynamic' 'self' https://www.googletagmanager.com https://www.google-analytics.com https://hcaptcha.com https://*.hcaptcha.com`,
    // CSP L3 : nonce sur <style>, pas d'inline style="" autorisé.
    // Tous les styles dynamiques injectés via innerHTML passent par des
    // classes CSS ou element.style.setProperty() post-insertion (non bloqués
    // car c'est une API DOM, pas un attribut parsé).
    `style-src-elem 'self' 'nonce-${nonce}' ${STYLE_HOSTS}`,
    "style-src-attr 'none'",
    // Fallback pour navigateurs ignorant style-src-elem (< 1% du trafic).
    // Tous les <style> inline sont nonce-és au runtime via injectCspNonce(),
    // donc 'unsafe-inline' n'est plus nécessaire — CSP strictement nonce-based.
    `style-src 'self' 'nonce-${nonce}' ${STYLE_HOSTS}`,
    "font-src 'self'",
    "img-src 'self' https://www.googletagmanager.com data:",
    // Hôtes Sentry retirés (SEC-006) : aucun DSN front n'est configuré. Si l'on
    // active Sentry navigateur un jour, rajouter ici l'hôte d'ingestion du DSN.
    "connect-src 'self' https://www.google-analytics.com https://*.google-analytics.com https://www.googletagmanager.com https://hcaptcha.com https://*.hcaptcha.com",
    'frame-src https://hcaptcha.com https://*.hcaptcha.com',
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "worker-src 'self'",
    "manifest-src 'self'",
    `report-uri ${CSP_REPORT_PATH}`,
    `report-to ${CSP_REPORT_GROUP}`,
  ].join('; ');
}

function securityHeaders(req, res, next) {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  // Isolation cross-origin (protection Spectre, tabnabbing, xsleaks).
  // same-origin sur COOP = isolation stricte de la fenêtre (empêche window.opener cross-origin).
  // same-site sur CORP = permet les assets cross-sous-domaine tout en bloquant l'embed hostile.
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Resource-Policy', 'same-site');
  res.setHeader('Reporting-Endpoints', `${CSP_REPORT_GROUP}="${CSP_REPORT_PATH}"`);
  res.setHeader('Content-Security-Policy', buildCsp(res.locals.cspNonce));
  res.removeHeader('X-Powered-By');
  next();
}

// Un <script src> est nonçé seulement s'il vise un fichier du site (chemin
// relatif ou absolu, jamais « // » ni un schéma) : même si une donnée mal
// échappée glissait un <script src="https://…"> dans un rendu SSR, il ne
// recevrait pas le nonce et resterait bloqué. Les <script> sans src (JSON-LD)
// ne s'exécutent pas : inutile de les nonçer.
const LOCAL_SCRIPT_SRC = /\bsrc\s*=\s*"(?!\/\/|[a-z][a-z0-9+.-]*:)[^"]+"/i;

// Injecte le nonce CSP sur chaque balise <style> et sur chaque <script src>
// local (sans attribut nonce existant). Coût : O(n) sur la taille du HTML
// (~sub-ms pour 50 Ko), acceptable en runtime.
function injectCspNonce(html, nonce) {
  if (!nonce) return html;
  return html
    .replace(/<style(\s+[^>]*)?>/gi, (match, attrs) => {
      if (attrs && /\bnonce\s*=/.test(attrs)) return match; // déjà nonçé
      return `<style${attrs || ''} nonce="${nonce}">`;
    })
    .replace(/<script(\s+[^>]*)>/gi, (match, attrs) => {
      if (/\bnonce\s*=/.test(attrs) || !LOCAL_SCRIPT_SRC.test(attrs)) return match;
      return `<script${attrs} nonce="${nonce}">`;
    });
}

module.exports = { cspNonce, securityHeaders, injectCspNonce, buildCsp, CSP_REPORT_PATH };
