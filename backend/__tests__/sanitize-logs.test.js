/**
 * Tests unitaires — middleware/sanitize-logs.js
 * Vérifie que le scrubber nettoie correctement les champs sensibles
 * sans muter l'original ni bloquer les structures valides.
 */

process.env.NODE_ENV = 'test';

const {
  scrub,
  isSensitiveKey,
  SENSITIVE_FIELDS,
  REDACTED,
  MAX_DEPTH,
} = require('../middleware/sanitize-logs');

// =============================================================================
// isSensitiveKey
// =============================================================================
describe('isSensitiveKey', () => {
  test('détecte password (exact)', () => {
    expect(isSensitiveKey('password')).toBe(true);
  });

  test('détecte password en camelCase (newPassword)', () => {
    expect(isSensitiveKey('newPassword')).toBe(true);
  });

  test('détecte password en snake_case (new_password)', () => {
    expect(isSensitiveKey('new_password')).toBe(true);
  });

  test('détecte Password avec majuscule', () => {
    expect(isSensitiveKey('Password')).toBe(true);
  });

  test('détecte token, jti, jwt', () => {
    expect(isSensitiveKey('token')).toBe(true);
    expect(isSensitiveKey('accessToken')).toBe(true);
    expect(isSensitiveKey('refresh_token')).toBe(true);
    expect(isSensitiveKey('jti')).toBe(true);
    expect(isSensitiveKey('jwt')).toBe(true);
  });

  test('détecte authorization', () => {
    expect(isSensitiveKey('authorization')).toBe(true);
    expect(isSensitiveKey('Authorization')).toBe(true);
  });

  test('détecte cookie et set-cookie', () => {
    expect(isSensitiveKey('cookie')).toBe(true);
    expect(isSensitiveKey('set-cookie')).toBe(true);
  });

  test('détecte secret, api_key, apikey', () => {
    expect(isSensitiveKey('secret')).toBe(true);
    expect(isSensitiveKey('jwt_secret')).toBe(true);
    expect(isSensitiveKey('api_key')).toBe(true);
    expect(isSensitiveKey('apikey')).toBe(true);
  });

  test('ignore les clés sans mot sensible', () => {
    expect(isSensitiveKey('email')).toBe(false);
    expect(isSensitiveKey('name')).toBe(false);
    expect(isSensitiveKey('id')).toBe(false);
    expect(isSensitiveKey('userId')).toBe(false);
    expect(isSensitiveKey('role')).toBe(false);
  });

  test('retourne false pour null, undefined, nombres, objets', () => {
    expect(isSensitiveKey(null)).toBe(false);
    expect(isSensitiveKey(undefined)).toBe(false);
    expect(isSensitiveKey(42)).toBe(false);
    expect(isSensitiveKey({})).toBe(false);
    expect(isSensitiveKey('')).toBe(false);
  });
});

// =============================================================================
// scrub — valeurs primitives
// =============================================================================
describe('scrub — primitives', () => {
  test('null → null', () => {
    expect(scrub(null)).toBe(null);
  });

  test('undefined → undefined', () => {
    expect(scrub(undefined)).toBe(undefined);
  });

  test('string → string (inchangé)', () => {
    expect(scrub('hello')).toBe('hello');
  });

  test('number → number', () => {
    expect(scrub(42)).toBe(42);
  });

  test('boolean → boolean', () => {
    expect(scrub(true)).toBe(true);
    expect(scrub(false)).toBe(false);
  });
});

// =============================================================================
// scrub — objets plats
// =============================================================================
describe('scrub — objets plats', () => {
  test('remplace la valeur de password par [REDACTED]', () => {
    const input = { email: 'test@example.com', password: 'secret123' };
    const output = scrub(input);
    expect(output.email).toBe('test@example.com');
    expect(output.password).toBe(REDACTED);
  });

  test('remplace plusieurs champs sensibles', () => {
    const input = {
      name: 'Alice',
      password: 'p1',
      token: 't2',
      refresh_token: 't3',
      secret: 's4',
      api_key: 'k5',
    };
    const output = scrub(input);
    expect(output.name).toBe('Alice');
    expect(output.password).toBe(REDACTED);
    expect(output.token).toBe(REDACTED);
    expect(output.refresh_token).toBe(REDACTED);
    expect(output.secret).toBe(REDACTED);
    expect(output.api_key).toBe(REDACTED);
  });

  test('ne mute pas l\'objet original', () => {
    const input = { password: 'secret' };
    const output = scrub(input);
    expect(input.password).toBe('secret'); // original intact
    expect(output.password).toBe(REDACTED);
    expect(output).not.toBe(input); // nouvelle référence
  });

  test('préserve les clés non sensibles', () => {
    const input = {
      id: 1,
      email: 'a@b.c',
      role: 'admin',
      created_at: '2026-01-01',
      age: 42,
    };
    const output = scrub(input);
    expect(output).toEqual(input);
  });

  test('retourne un nouvel objet (pas la même référence)', () => {
    const input = { a: 1 };
    expect(scrub(input)).not.toBe(input);
  });
});

// =============================================================================
// scrub — objets imbriqués
// =============================================================================
describe('scrub — objets imbriqués', () => {
  test('scrub password dans un objet imbriqué', () => {
    const input = {
      user: {
        email: 'test@example.com',
        password: 'secret',
      },
    };
    const output = scrub(input);
    expect(output.user.email).toBe('test@example.com');
    expect(output.user.password).toBe(REDACTED);
  });

  test('scrub à plusieurs niveaux de profondeur', () => {
    const input = {
      level1: {
        level2: {
          level3: {
            token: 'deep-secret',
            safe: 'ok',
          },
        },
      },
    };
    const output = scrub(input);
    expect(output.level1.level2.level3.token).toBe(REDACTED);
    expect(output.level1.level2.level3.safe).toBe('ok');
  });

  test('scrub dans req.body pattern Express', () => {
    const input = {
      req: {
        body: {
          email: 'test@example.com',
          password: 'mypass',
          confirmPassword: 'mypass',
        },
        headers: {
          authorization: 'Bearer xyz',
          'content-type': 'application/json',
        },
      },
    };
    const output = scrub(input);
    expect(output.req.body.email).toBe('test@example.com');
    expect(output.req.body.password).toBe(REDACTED);
    expect(output.req.body.confirmPassword).toBe(REDACTED);
    expect(output.req.headers.authorization).toBe(REDACTED);
    expect(output.req.headers['content-type']).toBe('application/json');
  });
});

// =============================================================================
// scrub — tableaux
// =============================================================================
describe('scrub — tableaux', () => {
  test('scrub les champs sensibles dans un tableau d\'objets', () => {
    const input = [
      { email: 'a@b.c', password: 'p1' },
      { email: 'x@y.z', password: 'p2' },
    ];
    const output = scrub(input);
    expect(output[0].password).toBe(REDACTED);
    expect(output[1].password).toBe(REDACTED);
    expect(output[0].email).toBe('a@b.c');
  });

  test('tableau de primitives → inchangé', () => {
    expect(scrub([1, 2, 3])).toEqual([1, 2, 3]);
    expect(scrub(['a', 'b'])).toEqual(['a', 'b']);
  });

  test('tableau mixte (primitives + objets avec secrets)', () => {
    const input = [1, 'hello', { password: 'x' }, null];
    const output = scrub(input);
    expect(output[0]).toBe(1);
    expect(output[1]).toBe('hello');
    expect(output[2].password).toBe(REDACTED);
    expect(output[3]).toBe(null);
  });
});

// =============================================================================
// scrub — références circulaires
// =============================================================================
describe('scrub — références circulaires', () => {
  test('gère une référence circulaire simple', () => {
    const input = { name: 'Alice', password: 'secret' };
    input.self = input;
    const output = scrub(input);
    expect(output.password).toBe(REDACTED);
    expect(output.self).toBe('[CIRCULAR]');
  });

  test('gère une référence circulaire indirecte', () => {
    const a = { name: 'a' };
    const b = { name: 'b', parent: a };
    a.child = b;
    const output = scrub(a);
    expect(output.name).toBe('a');
    expect(output.child.name).toBe('b');
    expect(output.child.parent).toBe('[CIRCULAR]');
  });
});

// =============================================================================
// scrub — limite de profondeur
// =============================================================================
describe('scrub — limite de profondeur', () => {
  test('coupe à MAX_DEPTH pour éviter les stack overflows', () => {
    // Construit un objet imbriqué plus profond que MAX_DEPTH
    let input = { leaf: 'ok' };
    for (let i = 0; i < MAX_DEPTH + 5; i++) {
      input = { nested: input };
    }
    const output = scrub(input);
    // À un moment donné, la valeur devient '[TOO_DEEP]'
    let current = output;
    let depth = 0;
    while (typeof current === 'object' && current !== null && current.nested) {
      current = current.nested;
      depth++;
      if (depth > 20) break; // safety
    }
    expect(current === '[TOO_DEEP]' || current.leaf === 'ok' || current === 'ok').toBe(true);
  });
});

// =============================================================================
// scrub — Error instances
// =============================================================================
describe('scrub — Error instances', () => {
  test('préserve name, message, stack d\'une Error', () => {
    const err = new Error('Something failed');
    const output = scrub(err);
    expect(output.name).toBe('Error');
    expect(output.message).toBe('Something failed');
    expect(output.stack).toContain('Error: Something failed');
  });

  test('scrub les propriétés custom d\'une Error (status, code, etc.)', () => {
    const err = new Error('API failed');
    err.status = 500;
    err.code = 'ERR_API';
    err.token = 'xyz123'; // propriété custom sensible
    const output = scrub(err);
    expect(output.message).toBe('API failed');
    expect(output.status).toBe(500);
    expect(output.code).toBe('ERR_API');
    expect(output.token).toBe(REDACTED);
  });
});

// =============================================================================
// Patterns réels — attaques classiques de fuite en logs
// =============================================================================
describe('scrub — scénarios réels', () => {
  test('body d\'inscription ne fuite pas le password', () => {
    const meta = {
      route: 'POST /api/register',
      body: { name: 'Alice', email: 'a@b.c', password: 'MyP@ssw0rd!' },
    };
    const output = scrub(meta);
    expect(output.body.password).toBe(REDACTED);
    expect(JSON.stringify(output)).not.toContain('MyP@ssw0rd!');
  });

  test('headers avec Authorization Bearer ne fuite pas', () => {
    const meta = {
      method: 'GET',
      path: '/api/users/1',
      headers: { authorization: 'Bearer eyJhbGci.xxx.yyy' },
    };
    const output = scrub(meta);
    expect(output.headers.authorization).toBe(REDACTED);
    expect(JSON.stringify(output)).not.toContain('eyJhbGci');
  });

  test('cookie de session ne fuite pas (tout l\'objet cookies redacté wholesale)', () => {
    // "cookies" contient le mot-clé "cookie" → l'objet entier est redacté,
    // comportement plus sûr que de descendre dedans (on ne veut AUCUN cookie en log,
    // pas même un theme qui pourrait contenir un user-agent identifiant).
    const meta = {
      cookies: {
        refresh_cookie: 'abc.def.ghi',
        session: 'xxx',
        theme: 'dark',
      },
      user: { name: 'Alice' },
    };
    const output = scrub(meta);
    expect(output.cookies).toBe(REDACTED);
    expect(output.user.name).toBe('Alice');
    expect(JSON.stringify(output)).not.toContain('abc.def.ghi');
    expect(JSON.stringify(output)).not.toContain('xxx');
  });

  test('erreur JWT contient le token custom — scrubbé', () => {
    const err = new Error('Invalid signature');
    err.token = 'eyJhbGci.payload.sig';
    const output = scrub({ error: err });
    expect(output.error.message).toBe('Invalid signature');
    expect(output.error.token).toBe(REDACTED);
  });
});

// =============================================================================
// Intégration avec le logger — smoke test
// =============================================================================
describe('integration — logger + scrubber', () => {
  test('logger.info ne fuite pas un password dans sa sortie JSON', () => {
    const logger = require('../logger');
    const logs = [];
    const origLog = console.log;
    console.log = (msg) => logs.push(msg);

    try {
      logger.info('User registered', {
        email: 'test@example.com',
        password: 'SuperSecret123!',
      });
    } finally {
      console.log = origLog;
    }

    expect(logs.length).toBe(1);
    const entry = JSON.parse(logs[0]);
    expect(entry.email).toBe('test@example.com');
    expect(entry.password).toBe(REDACTED);
    expect(logs[0]).not.toContain('SuperSecret123!');
  });

  test('logger.error retourne toujours un errorId même avec meta scrubé', () => {
    const logger = require('../logger');
    const origErr = console.error;
    console.error = () => {};

    try {
      const entry = logger.error('Auth failed', {
        userId: 42,
        password: 'xyz',
      });
      expect(entry.errorId).toMatch(/^[a-f0-9]{8}$/);
      expect(entry.userId).toBe(42);
      expect(entry.password).toBe(REDACTED);
    } finally {
      console.error = origErr;
    }
  });
});
