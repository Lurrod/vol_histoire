/**
 * Tests unitaires — exposition réseau
 * Le backend ne doit être joignable que via Apache (127.0.0.1), et seul un
 * proxy local peut dicter req.ip via X-Forwarded-For. Sinon, un client qui
 * contacte le port Node en direct forge son IP et contourne le rate limiting.
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const { resolveListenHost } = require('../utils/network');
const app = require('../app');

describe('resolveListenHost', () => {
  test('par défaut → loopback uniquement', () => {
    expect(resolveListenHost({})).toBe('127.0.0.1');
  });

  test('HOST vide → loopback', () => {
    expect(resolveListenHost({ HOST: '' })).toBe('127.0.0.1');
  });

  test('HOST explicite → respecté', () => {
    expect(resolveListenHost({ HOST: '0.0.0.0' })).toBe('0.0.0.0');
  });
});

describe('trust proxy', () => {
  const trust = app.get('trust proxy fn');

  test.each(['127.0.0.1', '::1', '::ffff:127.0.0.1'])('fait confiance à %s', (addr) => {
    expect(trust(addr, 0)).toBe(true);
  });

  test.each(['51.68.234.84', '10.0.0.5', '192.168.1.254', '2001:db8::1'])(
    'ignore X-Forwarded-For venant de %s',
    (addr) => {
      expect(trust(addr, 0)).toBe(false);
    }
  );
});
