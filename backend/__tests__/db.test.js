/**
 * backend/db.js : transactions et surveillance des erreurs du pool (JS-003).
 */
const { EventEmitter } = require('events');
const { withTransaction, watchPoolErrors } = require('../db');

describe('watchPoolErrors', () => {
  test('une connexion inactive perdue est journalisée, sans exception non capturée', () => {
    const pool = new EventEmitter();
    const logger = { error: jest.fn() };
    watchPoolErrors(pool, logger);
    const err = new Error('terminating connection due to administrator command');
    // Sans écouteur, emit('error') lèverait : c'est ce qui arrêtait le processus.
    expect(() => pool.emit('error', err)).not.toThrow();
    expect(logger.error).toHaveBeenCalledWith('PostgreSQL : connexion inactive perdue', { error: err });
  });
});

describe('withTransaction', () => {
  function fakePool() {
    const client = { query: jest.fn().mockResolvedValue({}), release: jest.fn() };
    return { client, pool: { connect: jest.fn().mockResolvedValue(client) } };
  }

  test('COMMIT si la fonction réussit', async () => {
    const { client, pool } = fakePool();
    await expect(withTransaction(pool, async () => 42)).resolves.toBe(42);
    expect(client.query.mock.calls.map((c) => c[0])).toEqual(['BEGIN', 'COMMIT']);
    expect(client.release).toHaveBeenCalled();
  });

  test('ROLLBACK et erreur propagée si la fonction échoue', async () => {
    const { client, pool } = fakePool();
    await expect(withTransaction(pool, async () => { throw new Error('boom'); })).rejects.toThrow('boom');
    expect(client.query.mock.calls.map((c) => c[0])).toEqual(['BEGIN', 'ROLLBACK']);
    expect(client.release).toHaveBeenCalled();
  });
});
