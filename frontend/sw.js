/* Vol d'Histoire — service worker minimal.
 *
 * Stratégie :
 *   - Shell pré-caché à l'install : core CSS, polices, logo, manifest, page d'accueil.
 *   - HTML : network-first avec fallback cache (les visiteurs revenants gardent un
 *     contenu utilisable hors ligne).
 *   - Assets statiques same-origin (/css, /js, /fonts, /assets) : stale-while-revalidate.
 *   - /api/* : passthrough strict (jamais caché — données authentifiées, CORS, CSRF).
 *   - Flèche de secours hors ligne : fallback vers "/" (page d'accueil cached).
 *
 * Versioning : bumper CACHE_VERSION à chaque déploiement pour purger les vieux caches.
 */

const CACHE_VERSION = 'v4.3.2';
const SHELL_CACHE = `vh-shell-${CACHE_VERSION}`;
const RUNTIME_CACHE = `vh-runtime-${CACHE_VERSION}`;

const SHELL_ASSETS = [
  '/',
  '/manifest.webmanifest',
  '/favicon.svg',
  '/assets/logo/favicon.svg',
  '/assets/logo/icon-192.png',
  '/assets/logo/icon-512.png',
  '/css/core.min.css',
  '/css/home.min.css',
  '/fonts/DMSans.woff2',
  '/fonts/BarlowCondensed-400.woff2',
  '/fonts/BarlowCondensed-600.woff2',
];

// -----------------------------------------------------------------------------
// Install : pré-cache du shell. `catch` sur chaque add pour tolérer un asset 404
// (un déploiement partiel ne doit pas bloquer l'activation du SW).
// -----------------------------------------------------------------------------
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(SHELL_CACHE).then(async (cache) => {
      await Promise.all(
        SHELL_ASSETS.map((url) =>
          cache.add(new Request(url, { cache: 'reload' })).catch(() => {
            /* asset absent ou 404 — on continue */
          })
        )
      );
      self.skipWaiting();
    })
  );
});

// -----------------------------------------------------------------------------
// Activate : purge des caches des versions précédentes + claim des clients.
// -----------------------------------------------------------------------------
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((k) => k !== SHELL_CACHE && k !== RUNTIME_CACHE)
          .map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

// -----------------------------------------------------------------------------
// Fetch : routage par type de requête.
// -----------------------------------------------------------------------------
self.addEventListener('fetch', (event) => {
  const request = event.request;

  // Jamais intercepter les non-GET, cross-origin, ni les WebSocket.
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  // Passthrough strict pour l'API (auth-sensible, cookies, pas d'intérêt à cacher).
  if (url.pathname.startsWith('/api/')) return;

  // Ne jamais cacher le service worker lui-même ni /sw.js.
  if (url.pathname === '/sw.js') return;

  // Navigation HTML : network-first, fallback cache, fallback "/".
  if (request.mode === 'navigate' || request.destination === 'document') {
    event.respondWith(networkFirst(request));
    return;
  }

  // Assets statiques : stale-while-revalidate.
  if (isStaticAsset(url.pathname)) {
    event.respondWith(staleWhileRevalidate(request));
    return;
  }

  // Tout le reste : passthrough.
});

function isStaticAsset(pathname) {
  return (
    pathname.startsWith('/css/') ||
    pathname.startsWith('/js/') ||
    pathname.startsWith('/fonts/') ||
    pathname.startsWith('/assets/') ||
    pathname.endsWith('.css') ||
    pathname.endsWith('.js') ||
    pathname.endsWith('.woff2') ||
    pathname.endsWith('.svg') ||
    pathname.endsWith('.png') ||
    pathname.endsWith('.webp') ||
    pathname.endsWith('.avif')
  );
}

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response && response.ok) {
      const cache = await caches.open(RUNTIME_CACHE);
      cache.put(request, response.clone()).catch(() => {});
    }
    return response;
  } catch {
    const cached = await caches.match(request);
    if (cached) return cached;
    const shell = await caches.match('/');
    if (shell) return shell;
    return new Response('Hors ligne — aucune version en cache.', {
      status: 503,
      headers: { 'Content-Type': 'text/plain; charset=utf-8' },
    });
  }
}

async function staleWhileRevalidate(request) {
  const cache = await caches.open(RUNTIME_CACHE);
  const cached = await cache.match(request);
  const fetchPromise = fetch(request)
    .then((response) => {
      if (response && response.ok) {
        cache.put(request, response.clone()).catch(() => {});
      }
      return response;
    })
    .catch(() => cached);
  return cached || fetchPromise;
}
