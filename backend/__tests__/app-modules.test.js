/**
 * Modules extraits de app.js (ARCH-002) : purges périodiques et documentation
 * de l'API. Le reste (en-têtes, limiteurs, fichiers statiques, pages) est
 * couvert par les tests de bout en bout de l'application (api.test.js…).
 */
process.env.NODE_ENV = 'test';

const express = require('express');
const request = require('supertest');

jest.mock('../logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn(), debug: jest.fn(),
}));
const logger = require('../logger');
const { startCleanupJobs, runTokenCleanup, runUnverifiedUsersCleanup } = require('../jobs/cleanup');
const { createApiDocsRouter } = require('../routes/api-docs');

describe('jobs/cleanup', () => {
  beforeEach(() => jest.clearAllMocks());

  test('runTokenCleanup journalise un échec sans le propager', async () => {
    await runTokenCleanup(jest.fn().mockRejectedValue(new Error('base coupée')));
    expect(logger.error).toHaveBeenCalledWith('Erreur nettoyage refresh tokens', { error: 'base coupée' });
  });

  test('runUnverifiedUsersCleanup journalise le nombre de comptes purgés', async () => {
    await runUnverifiedUsersCleanup(jest.fn().mockResolvedValue(3));
    expect(logger.info).toHaveBeenCalledWith('Comptes non vérifiés purgés', { count: 3 });
  });

  test('runUnverifiedUsersCleanup reste silencieux sans compte purgé', async () => {
    await runUnverifiedUsersCleanup(jest.fn().mockResolvedValue(0));
    expect(logger.info).not.toHaveBeenCalled();
  });

  test('runUnverifiedUsersCleanup journalise un échec sans le propager', async () => {
    await runUnverifiedUsersCleanup(jest.fn().mockRejectedValue(new Error('timeout')));
    expect(logger.error).toHaveBeenCalledWith('Erreur purge comptes non vérifiés', { error: 'timeout' });
  });

  test('startCleanupJobs lance les purges à leur cadence et s\'arrête', async () => {
    jest.useFakeTimers();
    const cleanupExpiredTokens = jest.fn().mockResolvedValue(undefined);
    const cleanupUnverifiedUsers = jest.fn().mockResolvedValue(0);
    const stop = startCleanupJobs({ cleanupExpiredTokens, cleanupUnverifiedUsers });

    jest.advanceTimersByTime(60 * 60 * 1000);
    expect(cleanupExpiredTokens).toHaveBeenCalledTimes(1);
    expect(cleanupUnverifiedUsers).not.toHaveBeenCalled();

    jest.advanceTimersByTime(23 * 60 * 60 * 1000);
    expect(cleanupUnverifiedUsers).toHaveBeenCalledTimes(1);

    stop();
    jest.advanceTimersByTime(48 * 60 * 60 * 1000);
    expect(cleanupExpiredTokens).toHaveBeenCalledTimes(24);
    jest.useRealTimers();
  });
});

describe('routes/api-docs', () => {
  test('en production, /api/docs sert la page 404 du site', async () => {
    const sendCachedHtml = jest.fn((res) => res.send('<h1>404</h1>'));
    const app = express();
    app.use('/api/docs', createApiDocsRouter({ env: { NODE_ENV: 'production' }, sendCachedHtml, frontendRoot: '/f' }));
    const res = await request(app).get('/api/docs');
    expect(res.status).toBe(404);
    expect(sendCachedHtml).toHaveBeenCalledWith(expect.anything(), expect.stringMatching(/404\.html$/));
  });

  test('hors production, la CSP de la page de doc revient à script-src \'self\'', async () => {
    const app = express();
    app.use((req, res, next) => {
      res.setHeader('Content-Security-Policy', "default-src 'self'; script-src 'nonce-x' 'strict-dynamic'; object-src 'none'");
      next();
    });
    app.use('/api/docs', createApiDocsRouter({ env: { NODE_ENV: 'development' }, sendCachedHtml: jest.fn(), frontendRoot: '/f' }));
    const res = await request(app).get('/api/docs/');
    expect(res.headers['content-security-policy']).toContain("script-src 'self';");
    expect(res.headers['content-security-policy']).not.toContain('strict-dynamic');
  });
});
