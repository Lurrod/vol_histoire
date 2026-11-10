'use strict';

/**
 * logger.js — niveaux, format, nettoyage des métadonnées, relais Sentry.
 * Sentry est simulé : aucun événement ne sort de la machine.
 */

const ENV_KEYS = ['LOG_LEVEL', 'SENTRY_DSN', 'NODE_ENV', 'SENTRY_CAPTURE_WARN', 'SENTRY_ENVIRONMENT', 'SENTRY_RELEASE'];
let savedEnv;
let out;
let err;
let warnOut;

beforeEach(() => {
  savedEnv = Object.fromEntries(ENV_KEYS.map((k) => [k, process.env[k]]));
  jest.resetModules();
  out = jest.spyOn(console, 'log').mockImplementation(() => {});
  err = jest.spyOn(console, 'error').mockImplementation(() => {});
  warnOut = jest.spyOn(console, 'warn').mockImplementation(() => {});
});

afterEach(() => {
  for (const [k, v] of Object.entries(savedEnv)) {
    if (v === undefined) delete process.env[k];
    else process.env[k] = v;
  }
  jest.restoreAllMocks();
});

function loadLogger(env = {}, sentryFactory = null) {
  for (const k of ENV_KEYS) delete process.env[k];
  Object.assign(process.env, { NODE_ENV: 'test' }, env);
  if (sentryFactory) jest.doMock('@sentry/node', sentryFactory);
  return require('../logger');
}

function fakeSentry() {
  const scope = { setLevel: jest.fn(), setTag: jest.fn(), setExtra: jest.fn() };
  return {
    scope,
    init: jest.fn(),
    withScope: jest.fn((cb) => cb(scope)),
    captureException: jest.fn(),
    captureMessage: jest.fn(),
    close: jest.fn().mockResolvedValue(true),
  };
}

describe('sans Sentry', () => {
  test('info → console.log en JSON, error → console.error avec errorId', () => {
    const logger = loadLogger();
    logger.info('bonjour', { a: 1 });
    const info = JSON.parse(out.mock.calls[0][0]);
    expect(info).toEqual(expect.objectContaining({ level: 'info', message: 'bonjour', a: 1, timestamp: expect.any(String) }));
    expect(info.errorId).toBeUndefined();

    const entry = logger.error('panne');
    expect(entry.errorId).toMatch(/^[a-f0-9]{8}$/);
    expect(JSON.parse(err.mock.calls[0][0]).errorId).toBe(entry.errorId);
    logger.warn('attention');
    expect(JSON.parse(err.mock.calls[1][0]).level).toBe('warn');
  });

  test('LOG_LEVEL filtre les niveaux inférieurs', () => {
    const logger = loadLogger({ LOG_LEVEL: 'warn' });
    expect(logger.info('ignoré')).toBeUndefined();
    expect(logger.debug('ignoré')).toBeUndefined();
    logger.warn('gardé');
    expect(out).not.toHaveBeenCalled();
    expect(err).toHaveBeenCalledTimes(1);
  });

  test('debug visible au niveau debug', () => {
    const logger = loadLogger({ LOG_LEVEL: 'debug' });
    logger.debug('détail');
    expect(JSON.parse(out.mock.calls[0][0]).level).toBe('debug');
  });

  test('les métadonnées sensibles sont masquées', () => {
    const logger = loadLogger();
    logger.info('connexion', { password: 'Secret123', email: 'jean@example.com' });
    const line = out.mock.calls[0][0];
    expect(line).not.toContain('Secret123');
  });

  test('Sentry inactif : flushSentry résout, isSentryEnabled faux', async () => {
    const logger = loadLogger({ SENTRY_DSN: 'https://k@sentry.example/1' }); // NODE_ENV=test → jamais activé
    expect(logger.isSentryEnabled()).toBe(false);
    await expect(logger.flushSentry()).resolves.toBeUndefined();
  });
});

describe('avec Sentry', () => {
  const ENV = { NODE_ENV: 'production', SENTRY_DSN: 'https://k@sentry.example/1', SENTRY_ENVIRONMENT: 'prod' };

  test('initialisation et filtre des erreurs 4xx', () => {
    const sentry = fakeSentry();
    const logger = loadLogger(ENV, () => sentry);
    expect(logger.isSentryEnabled()).toBe(true);
    const opts = sentry.init.mock.calls[0][0];
    expect(opts).toEqual(expect.objectContaining({ dsn: ENV.SENTRY_DSN, environment: 'prod', tracesSampleRate: 0.1 }));
    const event = { id: 1 };
    expect(opts.beforeSend(event, { originalException: { status: 404 } })).toBeNull();
    expect(opts.beforeSend(event, { originalException: { status: 500 } })).toBe(event);
    expect(opts.beforeSend(event, undefined)).toBe(event);
  });

  test('error avec Error → captureException, extras sans la clé error', () => {
    const sentry = fakeSentry();
    const logger = loadLogger(ENV, () => sentry);
    const boom = new Error('boom');
    const entry = logger.error('échec', { error: boom, userId: 7 });
    expect(sentry.captureException).toHaveBeenCalledTimes(1);
    const sent = sentry.captureException.mock.calls[0][0];
    expect(sent).toBeInstanceOf(Error);
    expect(sent.message).toBe('boom');
    expect(sent.stack).toBe(boom.stack);
    expect(sentry.captureMessage).not.toHaveBeenCalled();
    expect(sentry.scope.setLevel).toHaveBeenCalledWith('error');
    expect(sentry.scope.setTag).toHaveBeenCalledWith('errorId', entry.errorId);
    expect(sentry.scope.setExtra).toHaveBeenCalledWith('userId', 7);
    expect(sentry.scope.setExtra).not.toHaveBeenCalledWith('error', expect.anything());
  });

  test('error sans Error → captureMessage ; warn relayé seulement si SENTRY_CAPTURE_WARN', () => {
    const sentry = fakeSentry();
    const logger = loadLogger(ENV, () => sentry);
    logger.error('message seul');
    expect(sentry.captureMessage).toHaveBeenCalledWith('message seul');
    logger.warn('avertissement');
    expect(sentry.withScope).toHaveBeenCalledTimes(1);

    jest.resetModules();
    const sentry2 = fakeSentry();
    const logger2 = loadLogger({ ...ENV, SENTRY_CAPTURE_WARN: 'true' }, () => sentry2);
    logger2.warn('avertissement');
    expect(sentry2.scope.setLevel).toHaveBeenCalledWith('warning');
    expect(sentry2.captureMessage).toHaveBeenCalledWith('avertissement');
  });

  test('flushSentry ferme le client', async () => {
    const sentry = fakeSentry();
    const logger = loadLogger(ENV, () => sentry);
    await logger.flushSentry(500);
    expect(sentry.close).toHaveBeenCalledWith(500);
  });

  test('module @sentry/node absent : avertissement, logger fonctionnel', () => {
    const logger = loadLogger(ENV, () => { throw new Error('Cannot find module'); });
    expect(logger.isSentryEnabled()).toBe(false);
    expect(warnOut).toHaveBeenCalledWith(expect.stringContaining('@sentry/node non installé'));
    logger.info('toujours là');
    expect(out).toHaveBeenCalled();
  });
});
