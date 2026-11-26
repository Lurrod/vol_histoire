/**
 * utils/fatal.js (JS-004) : la file Sentry est vidée avant la sortie.
 */
const { exitAfterFlush } = require('../utils/fatal');

test('vide Sentry puis quitte avec le code 1', async () => {
  const order = [];
  const logger = { flushSentry: jest.fn(async () => { order.push('flush'); }) };
  await exitAfterFlush(logger, { exit: (code) => order.push(`exit ${code}`) });
  expect(order).toEqual(['flush', 'exit 1']);
  expect(logger.flushSentry).toHaveBeenCalledWith(2000);
});

test('Sentry en échec : quitte quand même, une seule fois', async () => {
  const exit = jest.fn();
  await exitAfterFlush({ flushSentry: () => Promise.reject(new Error('réseau')) }, { exit });
  expect(exit).toHaveBeenCalledTimes(1);
  expect(exit).toHaveBeenCalledWith(1);
});

test('vidage bloqué : le minuteur de secours force la sortie', () => {
  jest.useFakeTimers();
  const exit = jest.fn();
  exitAfterFlush({ flushSentry: () => new Promise(() => {}) }, { exit, timeoutMs: 100 });
  jest.advanceTimersByTime(700);
  expect(exit).toHaveBeenCalledWith(1);
  jest.useRealTimers();
});
