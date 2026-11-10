/**
 * Tests — frontend/js/auth.js : cycle de vie de la session.
 *
 *   - init() : témoin vh_session, rafraîchissement silencieux, idempotence ;
 *   - authFetch() : jeton absent ou expirant, 401 TOKEN_EXPIRED / TOKEN_INVALID,
 *     401 d'un autre motif, 403, corps non JSON, file d'attente des refresh ;
 *   - fetchWithTimeout() : abandon au délai, signal externe, URL absolue ;
 *   - synchronisation multi-onglets (BroadcastChannel) et logout.
 *
 * auth.js garde son état dans une fermeture : chaque test recharge le module
 * isolé (jest.isolateModules) pour repartir d'une session vierge.
 */

function fakeJwt(payload, expInSeconds = 3600) {
  const header = window.btoa(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
  const body = window.btoa(JSON.stringify({ ...payload, exp: Math.floor(Date.now() / 1000) + expInSeconds }));
  return `${header}.${body}.signature`;
}

/** Réponse fetch minimale (clone() compris, utilisé par authFetch sur 401). */
function response(status, body, { json = true } = {}) {
  const make = () => ({
    ok: status >= 200 && status < 300,
    status,
    json: json ? () => Promise.resolve(body) : () => Promise.reject(new SyntaxError('Unexpected token <')),
  });
  const res = make();
  res.clone = make;
  return res;
}

class FakeChannel {
  constructor(name) {
    this.name = name;
    this.posted = [];
    this.onmessage = null;
    FakeChannel.instances.push(this);
  }
  postMessage(msg) { this.posted.push(msg); }
}
FakeChannel.instances = [];

function loadAuth({ channel = false } = {}) {
  let mod;
  FakeChannel.instances = [];
  global.BroadcastChannel = channel ? FakeChannel : undefined;
  jest.isolateModules(() => {
    mod = require('../js/auth');
  });
  return mod;
}

function setSessionCookie(present) {
  document.cookie = present
    ? 'vh_session=1; path=/'
    : 'vh_session=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/';
}

const refreshCalls = () => global.fetch.mock.calls.filter(([url]) => url === '/api/refresh');
const apiCalls = () => global.fetch.mock.calls.filter(([url]) => url !== '/api/refresh');

beforeEach(() => {
  global.fetch = jest.fn();
  window.localStorage.clear();
  delete window.i18n;
  setSessionCookie(false);
});

afterEach(() => {
  jest.useRealTimers();
  delete global.BroadcastChannel;
});

// =============================================================================
// init() — restauration silencieuse
// =============================================================================
describe('init — témoin vh_session', () => {
  test('visiteur anonyme (pas de témoin) : aucune requête /api/refresh, résout null', async () => {
    const auth = loadAuth();
    await expect(auth.init()).resolves.toBeNull();
    expect(global.fetch).not.toHaveBeenCalled();
    // Idempotent : un second appel ne tente toujours rien.
    await expect(auth.init()).resolves.toBeNull();
    expect(global.fetch).not.toHaveBeenCalled();
  });

  test('témoin présent : rafraîchit via le cookie httpOnly et renvoie le payload', async () => {
    setSessionCookie(true);
    const token = fakeJwt({ id: 7, name: 'Ada', email: 'ada@test.local', role: '2' });
    global.fetch.mockResolvedValueOnce(response(200, { token }));
    const auth = loadAuth();

    const payload = await auth.init();

    expect(global.fetch).toHaveBeenCalledWith('/api/refresh', { method: 'POST', credentials: 'include' });
    expect(payload).toMatchObject({ id: 7, name: 'Ada' });
    expect(auth.getToken()).toBe(token);
    // Rôle converti en nombre : nav.js compare role === 1.
    expect(auth.getUserInfo()).toEqual({ id: 7, email: 'ada@test.local', name: 'Ada', role: 2 });
  });

  test('appels concurrents : une seule requête de rafraîchissement', async () => {
    setSessionCookie(true);
    global.fetch.mockResolvedValueOnce(response(200, { token: fakeJwt({ id: 1 }) }));
    const auth = loadAuth();

    const [a, b] = await Promise.all([auth.init(), auth.init()]);

    expect(refreshCalls()).toHaveLength(1);
    expect(a).toEqual(b);
  });

  test('après une init réussie, init() renvoie le payload courant sans requête', async () => {
    setSessionCookie(true);
    global.fetch.mockResolvedValueOnce(response(200, { token: fakeJwt({ id: 3 }) }));
    const auth = loadAuth();
    await auth.init();
    global.fetch.mockClear();

    await expect(auth.init()).resolves.toMatchObject({ id: 3 });
    expect(global.fetch).not.toHaveBeenCalled();
  });

  test('refresh refusé (401) : résout null, session vide, pas de nouvel essai', async () => {
    setSessionCookie(true);
    global.fetch.mockResolvedValueOnce(response(401, { code: 'REFRESH_INVALID' }));
    const auth = loadAuth();

    await expect(auth.init()).resolves.toBeNull();
    expect(auth.getToken()).toBeNull();
    await auth.init();
    expect(refreshCalls()).toHaveLength(1);
  });

  test('cookie illisible : on tente quand même (mieux vaut un 401 qu’une session perdue)', async () => {
    Object.defineProperty(document, 'cookie', { configurable: true, get() { throw new Error('bloqué'); } });
    try {
      global.fetch.mockResolvedValueOnce(response(200, { token: fakeJwt({ id: 4 }) }));
      const auth = loadAuth();
      await expect(auth.init()).resolves.toMatchObject({ id: 4 });
      expect(refreshCalls()).toHaveLength(1);
    } finally {
      delete document.cookie;
    }
  });

  test('jeton opaque (payload illisible) : pas d’infos utilisateur inventées', async () => {
    setSessionCookie(true);
    global.fetch.mockResolvedValueOnce(response(200, { token: 'opaque' }));
    const auth = loadAuth();
    await expect(auth.init()).resolves.toBeNull();
    expect(auth.getToken()).toBe('opaque');
    expect(auth.getUserInfo()).toBeNull();
  });
});

// =============================================================================
// getUserInfo / setUserInfo
// =============================================================================
describe('getUserInfo / setUserInfo', () => {
  test('dérive les infos du payload, avec chaînes vides par défaut', () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 9, role: 3 }));
    expect(auth.getUserInfo()).toEqual({ id: 9, email: '', name: '', role: 3 });
  });

  test('setUserInfo prime sur le payload et copie l’objet reçu', () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 9, name: 'Jeton' }));
    const info = { id: 9, name: 'Mémoire', email: 'm@test.local', role: 1 };
    auth.setUserInfo(info);
    info.name = 'modifié après coup';
    expect(auth.getUserInfo().name).toBe('Mémoire');
    auth.setUserInfo(null);
    expect(auth.getUserInfo().name).toBe('Jeton');
  });
});

// =============================================================================
// authFetch()
// =============================================================================
describe('authFetch — en-têtes et rafraîchissement préalable', () => {
  test('jeton valide : Bearer, cookies inclus, ?lang= ajouté, pas de refresh', async () => {
    const auth = loadAuth();
    const token = fakeJwt({ id: 1 });
    auth.setToken(token);
    global.fetch.mockResolvedValueOnce(response(200, []));

    const res = await auth.authFetch('/api/favorites', { headers: { 'Content-Type': 'application/json' } });

    expect(res.status).toBe(200);
    expect(refreshCalls()).toHaveLength(0);
    const [url, opts] = global.fetch.mock.calls[0];
    expect(url).toBe('/api/favorites?lang=fr');
    expect(opts.credentials).toBe('include');
    expect(opts.headers).toEqual({ 'Content-Type': 'application/json', Authorization: `Bearer ${token}` });
    expect(opts.signal).toBeInstanceOf(window.AbortSignal);
  });

  test('ne modifie pas l’objet headers fourni par l’appelant', async () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 1 }));
    global.fetch.mockResolvedValueOnce(response(200, {}));
    const headers = { Accept: 'application/json' };
    await auth.authFetch('/api/x', { headers });
    expect(headers).toEqual({ Accept: 'application/json' });
  });

  test('sans jeton : rafraîchit d’abord puis envoie le nouveau jeton', async () => {
    const auth = loadAuth();
    const fresh = fakeJwt({ id: 2 });
    global.fetch
      .mockResolvedValueOnce(response(200, { token: fresh }))
      .mockResolvedValueOnce(response(200, {}));

    await auth.authFetch('/api/users/2');

    expect(global.fetch.mock.calls[0][0]).toBe('/api/refresh');
    expect(apiCalls()[0][1].headers.Authorization).toBe(`Bearer ${fresh}`);
  });

  test('jeton à moins de 30 s de l’expiration : rafraîchi avant l’appel', async () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 2 }, 20));
    const fresh = fakeJwt({ id: 2 }, 900);
    global.fetch
      .mockResolvedValueOnce(response(200, { token: fresh }))
      .mockResolvedValueOnce(response(200, {}));

    await auth.authFetch('/api/x');

    expect(refreshCalls()).toHaveLength(1);
    expect(apiCalls()[0][1].headers.Authorization).toBe(`Bearer ${fresh}`);
  });

  test('refresh impossible : la requête part quand même, sans Authorization', async () => {
    const auth = loadAuth();
    global.fetch
      .mockResolvedValueOnce(response(401, {}))
      .mockResolvedValueOnce(response(200, { public: true }));

    const res = await auth.authFetch('/api/airplanes');

    expect(res.status).toBe(200);
    expect(apiCalls()[0][1].headers).toEqual({});
  });

  test('deux appels simultanés sans jeton : un seul /api/refresh, partagé', async () => {
    const auth = loadAuth();
    const fresh = fakeJwt({ id: 5 });
    global.fetch.mockImplementation((url) => Promise.resolve(
      url === '/api/refresh' ? response(200, { token: fresh }) : response(200, {}),
    ));

    await Promise.all([auth.authFetch('/api/a'), auth.authFetch('/api/b')]);

    expect(refreshCalls()).toHaveLength(1);
    apiCalls().forEach(([, opts]) => expect(opts.headers.Authorization).toBe(`Bearer ${fresh}`));
  });

  test('deux appels simultanés, refresh en échec : les deux partent sans jeton', async () => {
    const auth = loadAuth();
    global.fetch.mockImplementation((url) => Promise.resolve(
      url === '/api/refresh' ? response(401, {}) : response(200, {}),
    ));

    await Promise.all([auth.authFetch('/api/a'), auth.authFetch('/api/b')]);

    expect(refreshCalls()).toHaveLength(1);
    expect(apiCalls()).toHaveLength(2);
    apiCalls().forEach(([, opts]) => expect(opts.headers.Authorization).toBeUndefined());
  });
});

describe('authFetch — réponses 401 / 403', () => {
  test.each(['TOKEN_EXPIRED', 'TOKEN_INVALID'])('401 %s : refresh puis nouvel essai avec le nouveau jeton', async (code) => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 1 }));
    const fresh = fakeJwt({ id: 1, name: 'après rotation' });
    global.fetch
      .mockResolvedValueOnce(response(401, { code }))
      .mockResolvedValueOnce(response(200, { token: fresh }))
      .mockResolvedValueOnce(response(200, { ok: 1 }));

    const res = await auth.authFetch('/api/favorites');

    expect(res.status).toBe(200);
    expect(apiCalls()).toHaveLength(2);
    expect(apiCalls()[1][1].headers.Authorization).toBe(`Bearer ${fresh}`);
    expect(auth.getToken()).toBe(fresh);
  });

  test('401 TOKEN_EXPIRED et refresh refusé : session vidée, 401 rendu à l’appelant', async () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 1 }));
    auth.setUserInfo({ id: 1, name: 'x', email: '', role: 3 });
    global.fetch
      .mockResolvedValueOnce(response(401, { code: 'TOKEN_EXPIRED' }))
      .mockResolvedValueOnce(response(401, {}));

    const res = await auth.authFetch('/api/favorites');

    expect(res.status).toBe(401);
    expect(auth.getToken()).toBeNull();
    expect(auth.getUserInfo()).toBeNull();
  });

  test('401 d’un autre motif : ni refresh ni nouvel essai, session conservée', async () => {
    const auth = loadAuth();
    const token = fakeJwt({ id: 1 });
    auth.setToken(token);
    global.fetch.mockResolvedValueOnce(response(401, { code: 'BAD_CREDENTIALS' }));

    const res = await auth.authFetch('/api/users/1');

    expect(res.status).toBe(401);
    expect(refreshCalls()).toHaveLength(0);
    expect(auth.getToken()).toBe(token);
  });

  test('401 au corps non JSON (page d’erreur du proxy) : réponse rendue, pas de déconnexion', async () => {
    const auth = loadAuth();
    const token = fakeJwt({ id: 1 });
    auth.setToken(token);
    global.fetch.mockResolvedValueOnce(response(401, null, { json: false }));

    const res = await auth.authFetch('/api/x');

    expect(res.status).toBe(401);
    expect(refreshCalls()).toHaveLength(0);
    expect(auth.getToken()).toBe(token);
  });

  test('403 (rôle insuffisant) : rendu tel quel, ni refresh ni déconnexion', async () => {
    const auth = loadAuth();
    const token = fakeJwt({ id: 1, role: 3 });
    auth.setToken(token);
    global.fetch.mockResolvedValueOnce(response(403, { code: 'FORBIDDEN' }));

    const res = await auth.authFetch('/api/airplanes/1', { method: 'DELETE' });

    expect(res.status).toBe(403);
    expect(global.fetch).toHaveBeenCalledTimes(1);
    expect(global.fetch.mock.calls[0][1].method).toBe('DELETE');
    expect(auth.getToken()).toBe(token);
  });
});

// =============================================================================
// fetchWithTimeout()
// =============================================================================
describe('fetchWithTimeout — délai et annulation', () => {
  /** fetch qui ne répond jamais et rejette quand son signal est annulé. */
  function hangingFetch() {
    global.fetch.mockImplementation((url, { signal }) => new Promise((resolve, reject) => {
      signal.addEventListener('abort', () => reject(new window.DOMException('aborted', 'AbortError')));
    }));
  }

  test('annule la requête au bout du délai', async () => {
    jest.useFakeTimers();
    const auth = loadAuth();
    hangingFetch();
    const p = auth.fetchWithTimeout('/api/slow', {}, 1000);
    const signal = global.fetch.mock.calls[0][1].signal;

    jest.advanceTimersByTime(999);
    expect(signal.aborted).toBe(false);
    jest.advanceTimersByTime(1);
    expect(signal.aborted).toBe(true);
    await expect(p).rejects.toMatchObject({ name: 'AbortError' });
  });

  test('délai par défaut : 15 s', async () => {
    jest.useFakeTimers();
    const auth = loadAuth();
    hangingFetch();
    const p = auth.fetchWithTimeout('/api/slow');
    const signal = global.fetch.mock.calls[0][1].signal;
    jest.advanceTimersByTime(14999);
    expect(signal.aborted).toBe(false);
    jest.advanceTimersByTime(1);
    await expect(p).rejects.toMatchObject({ name: 'AbortError' });
  });

  test('un signal fourni par l’appelant annule aussi la requête', async () => {
    const auth = loadAuth();
    hangingFetch();
    const external = new window.AbortController();
    const p = auth.fetchWithTimeout('/api/slow', { signal: external.signal }, 60000);
    external.abort();
    await expect(p).rejects.toMatchObject({ name: 'AbortError' });
    // Le signal transmis à fetch est le sien, pas celui de l'appelant.
    expect(global.fetch.mock.calls[0][1].signal).not.toBe(external.signal);
  });

  test('réponse reçue : le minuteur est libéré', async () => {
    jest.useFakeTimers();
    const auth = loadAuth();
    global.fetch.mockResolvedValueOnce(response(200, {}));
    await auth.fetchWithTimeout('/api/x', {}, 5000);
    expect(jest.getTimerCount()).toBe(0);
  });

  test('URL absolue de même origine vers /api : langue ajoutée', async () => {
    const auth = loadAuth();
    window.localStorage.setItem('vol-histoire-lang', 'en');
    global.fetch.mockResolvedValueOnce(response(200, {}));
    await auth.fetchWithTimeout(`http://${window.location.host}/api/stats`);
    expect(global.fetch.mock.calls[0][0]).toBe(`http://${window.location.host}/api/stats?lang=en`);
  });

  test('URL d’une autre origine et objet Request : laissés intacts', async () => {
    const auth = loadAuth();
    global.fetch.mockResolvedValue(response(200, {}));
    await auth.fetchWithTimeout('https://example.org/api/stats');
    expect(global.fetch.mock.calls[0][0]).toBe('https://example.org/api/stats');
    const req = { url: '/api/stats' };
    await auth.fetchWithTimeout(req);
    expect(global.fetch.mock.calls[1][0]).toBe(req);
  });
});

// =============================================================================
// logout()
// =============================================================================
describe('logout', () => {
  test('POST /api/logout avec cookies, puis session vidée', async () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 1 }));
    global.fetch.mockResolvedValueOnce(response(200, {}));
    await auth.logout();
    expect(global.fetch).toHaveBeenCalledWith('/api/logout', { method: 'POST', credentials: 'include' });
    expect(auth.getToken()).toBeNull();
  });

  test('réseau coupé : la session locale est vidée quand même', async () => {
    const auth = loadAuth();
    auth.setToken(fakeJwt({ id: 1 }));
    global.fetch.mockRejectedValueOnce(new TypeError('Failed to fetch'));
    await expect(auth.logout()).resolves.toBeUndefined();
    expect(auth.getToken()).toBeNull();
  });
});

// =============================================================================
// Synchronisation multi-onglets (BroadcastChannel)
// =============================================================================
describe('multi-onglets — BroadcastChannel « auth_sync »', () => {
  test('un refresh réussi diffuse le nouveau jeton', async () => {
    setSessionCookie(true);
    const token = fakeJwt({ id: 1 });
    global.fetch.mockResolvedValueOnce(response(200, { token }));
    const auth = loadAuth({ channel: true });
    const [chan] = FakeChannel.instances;
    expect(chan.name).toBe('auth_sync');

    await auth.init();

    expect(chan.posted).toEqual([{ type: 'refresh_done', token }]);
  });

  test('refresh refusé ici mais rotation faite par un autre onglet : son jeton est repris', async () => {
    setSessionCookie(true);
    jest.useFakeTimers();
    global.fetch.mockResolvedValueOnce(response(401, {}));
    const auth = loadAuth({ channel: true });
    const [chan] = FakeChannel.instances;
    const shared = fakeJwt({ id: 8, name: 'Autre onglet' });

    const p = auth.init();
    // Laisser refreshAccessToken constater l'échec et se mettre à l'écoute.
    for (let i = 0; i < 5; i++) await Promise.resolve();
    chan.onmessage({ data: { type: 'refresh_done', token: shared } });

    await expect(p).resolves.toMatchObject({ id: 8 });
    expect(auth.getToken()).toBe(shared);
    expect(jest.getTimerCount()).toBe(0); // minuteur d'attente libéré
  });

  test('refresh refusé et aucun onglet ne répond en 2 s : session vidée', async () => {
    setSessionCookie(true);
    jest.useFakeTimers();
    global.fetch.mockResolvedValueOnce(response(401, {}));
    const auth = loadAuth({ channel: true });
    auth.setToken('ancien');

    const p = auth.init();
    for (let i = 0; i < 5; i++) await Promise.resolve();
    jest.advanceTimersByTime(2000);

    await expect(p).resolves.toBeNull();
    expect(auth.getToken()).toBeNull();
  });

  test('un message refresh_done sans attente en cours est ignoré', () => {
    const auth = loadAuth({ channel: true });
    auth.setToken('local');
    FakeChannel.instances[0].onmessage({ data: { type: 'refresh_done', token: 'étranger' } });
    expect(auth.getToken()).toBe('local');
  });

  test('déconnexion dans un autre onglet : session vidée ici', () => {
    const auth = loadAuth({ channel: true });
    auth.setToken(fakeJwt({ id: 1 }));
    FakeChannel.instances[0].onmessage({ data: { type: 'logout' } });
    expect(auth.getToken()).toBeNull();
  });

  test('logout prévient les autres onglets', async () => {
    const auth = loadAuth({ channel: true });
    global.fetch.mockResolvedValueOnce(response(200, {}));
    await auth.logout();
    expect(FakeChannel.instances[0].posted).toEqual([{ type: 'logout' }]);
  });
});
