/**
 * Tests unitaires — frontend/js/auth.js
 * Token helpers, payload parsing, expiration check
 */

// Mock BroadcastChannel (absent en Node)
global.BroadcastChannel = undefined;

// Mock fetch (utilisé par refreshAccessToken)
global.fetch = jest.fn();

// Mock localStorage
const store = {};
global.localStorage = {
  getItem: (k) => store[k] || null,
  setItem: (k, v) => { store[k] = v; },
  removeItem: (k) => { delete store[k]; },
};

const auth = require('../js/auth');

beforeEach(() => {
  auth.clearSession();
  Object.keys(store).forEach(k => delete store[k]);
});

// Helper : créer un faux JWT avec payload
function fakeJwt(payload, expInSeconds = 3600) {
  const header = btoa(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
  const body = btoa(JSON.stringify({ ...payload, exp: Math.floor(Date.now() / 1000) + expInSeconds }));
  return `${header}.${body}.fakesignature`;
}

// =============================================================================
// getToken / setToken
// =============================================================================
describe('getToken / setToken', () => {
  test('getToken retourne null par défaut', () => {
    expect(auth.getToken()).toBeNull();
  });

  test('setToken stocke le token en mémoire', () => {
    auth.setToken('abc123');
    expect(auth.getToken()).toBe('abc123');
  });

  test('clearSession remet le token à null', () => {
    auth.setToken('abc123');
    auth.clearSession();
    expect(auth.getToken()).toBeNull();
  });
});

// =============================================================================
// getPayload
// =============================================================================
describe('getPayload', () => {
  test('retourne null si pas de token', () => {
    expect(auth.getPayload()).toBeNull();
  });

  test('retourne le payload décodé d\'un JWT valide', () => {
    const token = fakeJwt({ id: 1, name: 'Test', role: 3, email: 'test@test.com' });
    auth.setToken(token);

    const payload = auth.getPayload();
    expect(payload.id).toBe(1);
    expect(payload.name).toBe('Test');
    expect(payload.role).toBe(3);
    expect(payload.email).toBe('test@test.com');
    expect(payload.exp).toBeDefined();
  });

  test('retourne null si le token est corrompu', () => {
    auth.setToken('not.a.valid.jwt');
    expect(auth.getPayload()).toBeNull();
  });

  test('retourne null si le payload n\'est pas du JSON', () => {
    const header = btoa('{}');
    auth.setToken(`${header}.notbase64json.sig`);
    expect(auth.getPayload()).toBeNull();
  });
});

// =============================================================================
// isTokenExpired
// =============================================================================
describe('isTokenExpired', () => {
  test('retourne true si pas de token', () => {
    expect(auth.isTokenExpired()).toBe(true);
  });

  test('retourne false si le token expire dans 1h', () => {
    auth.setToken(fakeJwt({ id: 1 }, 3600));
    expect(auth.isTokenExpired()).toBe(false);
  });

  test('retourne true si le token expire dans 20s (marge de 30s)', () => {
    auth.setToken(fakeJwt({ id: 1 }, 20));
    expect(auth.isTokenExpired()).toBe(true);
  });

  test('retourne true si le token est déjà expiré', () => {
    auth.setToken(fakeJwt({ id: 1 }, -60));
    expect(auth.isTokenExpired()).toBe(true);
  });
});

// =============================================================================
// clearSession
// =============================================================================
describe('clearSession', () => {
  test('supprime le token et les infos utilisateur en mémoire', () => {
    auth.setToken('token');
    auth.setUserInfo({ id: 1, name: 'Test', email: 't@t.fr', role: 3 });

    auth.clearSession();

    expect(auth.getToken()).toBeNull();
    expect(auth.getUserInfo()).toBeNull();
    // Nettoyage rétrocompatibilité localStorage
    expect(localStorage.getItem('user')).toBeNull();
  });
});
