'use strict';

/**
 * utils/cache.js — Redis si branché, mémoire sinon, repli silencieux en cas de
 * panne Redis. Le client Redis est un faux (aucune connexion).
 */

const cache = require('../utils/cache');

function fakeRedis() {
  const store = new Map();
  return {
    store,
    get: jest.fn(async (k) => (store.has(k) ? store.get(k) : null)),
    setex: jest.fn(async (k, ttl, v) => { store.set(k, v); return 'OK'; }),
    del: jest.fn(async (k) => { store.delete(k); return 1; }),
  };
}

beforeEach(() => cache._resetForTests());
afterEach(() => jest.useRealTimers());

describe('mémoire seule', () => {
  test('set / get / del', async () => {
    await cache.set('k', 'v', 60);
    expect(await cache.get('k')).toBe('v');
    await cache.del('k');
    expect(await cache.get('k')).toBeNull();
  });

  test('clé absente → null', async () => {
    expect(await cache.get('absente')).toBeNull();
  });

  test('expiration après le TTL (TTL invalide ramené à 1 s)', async () => {
    jest.useFakeTimers({ now: new Date('2026-01-01T00:00:00Z') });
    await cache.set('court', 'v', 'pas-un-nombre');
    expect(await cache.get('court')).toBe('v');
    jest.setSystemTime(new Date('2026-01-01T00:00:02Z'));
    expect(await cache.get('court')).toBeNull();
  });
});

describe('avec Redis', () => {
  test('écrit et lit dans Redis avec SETEX', async () => {
    const redis = fakeRedis();
    cache.setRedisClient(redis);
    await cache.set('k', 'v', 30);
    expect(redis.setex).toHaveBeenCalledWith('k', 30, 'v');
    expect(await cache.get('k')).toBe('v');
    await cache.del('k');
    expect(redis.del).toHaveBeenCalledWith('k');
    expect(await cache.get('k')).toBeNull();
  });

  test('Redis vide → repli sur la mémoire', async () => {
    await cache.set('k', 'mémoire', 30); // posé avant le branchement de Redis
    cache.setRedisClient(fakeRedis());
    expect(await cache.get('k')).toBe('mémoire');
  });

  test('Redis en panne : get, set et del retombent sur la mémoire sans lever', async () => {
    const broken = {
      get: jest.fn().mockRejectedValue(new Error('ECONNREFUSED')),
      setex: jest.fn().mockRejectedValue(new Error('ECONNREFUSED')),
      del: jest.fn().mockRejectedValue(new Error('ECONNREFUSED')),
    };
    cache.setRedisClient(broken);
    await expect(cache.set('k', 'v', 30)).resolves.toBeUndefined();
    expect(await cache.get('k')).toBe('v');
    await expect(cache.del('k')).resolves.toBeUndefined();
    expect(await cache.get('k')).toBeNull();
  });
});
