/**
 * Tests — backend/utils/origins.js : origines acceptées par CORS.
 * En production, uniquement la liste configurée ; en local, le site ouvert par
 * localhost OU 127.0.0.1 (même port) doit pouvoir appeler l'API.
 */
const { allowedOrigins } = require('../utils/origins');

describe('allowedOrigins', () => {
  test('production : uniquement la liste ALLOWED_ORIGINS', () => {
    expect(allowedOrigins({ NODE_ENV: 'production', ALLOWED_ORIGINS: 'https://a.fr,https://b.fr' }))
      .toEqual(['https://a.fr', 'https://b.fr']);
  });

  test('production sans liste : valeurs par défaut, jamais 127.0.0.1', () => {
    const list = allowedOrigins({ NODE_ENV: 'production' });
    expect(list).toEqual(['http://localhost:3000', 'https://vol-histoire.titouan-borde.com']);
    expect(list.some(o => o.includes('127.0.0.1'))).toBe(false);
  });

  test('développement : localhost et 127.0.0.1 sur le port du serveur, en plus de la liste', () => {
    const list = allowedOrigins({ NODE_ENV: 'development', PORT: '3000' });
    expect(list).toEqual(expect.arrayContaining([
      'http://localhost:3000', 'http://127.0.0.1:3000', 'https://vol-histoire.titouan-borde.com',
    ]));
  });

  test('développement sur un autre port : ce port-là', () => {
    const list = allowedOrigins({ NODE_ENV: 'dev', PORT: '4000', ALLOWED_ORIGINS: 'https://x.fr' });
    expect(list).toEqual(['https://x.fr', 'http://localhost:4000', 'http://127.0.0.1:4000']);
  });

  test('espaces autour des virgules ignorés, pas de doublon', () => {
    const list = allowedOrigins({ NODE_ENV: 'development', PORT: '3000', ALLOWED_ORIGINS: ' http://localhost:3000 , https://y.fr' });
    expect(list).toEqual(['http://localhost:3000', 'https://y.fr', 'http://127.0.0.1:3000']);
  });
});
