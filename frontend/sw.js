/* Vol d'Histoire — service worker.
 *
 * Version : lue dans l'URL d'enregistrement (`/sw.js?v=<version>`, posée par
 * js/sw-register.js d'après le `?v=` que serveHtml ajoute à chaque script).
 * Elle est donc toujours celle des pages servies : les URL pré-cachées
 * (`/css/core.min.css?v=4.13.1`…) sont exactement celles que les pages
 * demandent. CACHE_VERSION n'est que le repli (sw.js chargé sans paramètre) ;
 * un test Jest le garde aligné sur package.json — à bumper à chaque release.
 *
 * Stratégie :
 *   - Install : pré-cache du shell (accueil, page hors ligne, cœur CSS/JS,
 *     locales, polices, logos). Pas de skipWaiting automatique : la nouvelle
 *     version attend que la page propose « Recharger » (message SKIP_WAITING).
 *   - Navigations : network-first ; hors ligne → la page en cache, sinon la
 *     page /offline (servie sous l'URL demandée, d'où ses chemins absolus).
 *   - CSS/JS versionnés (?v=) : cache-first (URL immuable).
 *   - Locales : stale-while-revalidate dans le cache du shell (hors ligne,
 *     les traductions restent disponibles).
 *   - Photos d'appareils : stale-while-revalidate dans un cache plafonné.
 *   - Autres assets statiques : stale-while-revalidate, cache plafonné.
 *   - /api/* : jamais intercepté (données authentifiées, CSRF).
 *   Chaque cache runtime est borné (éviction FIFO : ordre d'insertion).
 */

const CACHE_VERSION = 'v4.14.1';
const CACHE_PREFIX = 'vh-';

const LIMITS = {
  pages: 40,     // pages HTML visitées
  static: 120,   // CSS/JS/polices/logos/drapeaux hors pré-cache
  images: 60,    // photos d'appareils (≈ 30 à 300 Ko chacune)
};

/** Version applicative d'après l'URL du script (`?v=`), sinon le repli. */
function resolveVersion(scriptUrl) {
  const fallback = CACHE_VERSION.replace(/^v/, '');
  try {
    const v = new URL(scriptUrl).searchParams.get('v');
    return v && /^[0-9A-Za-z._-]{1,32}$/.test(v) ? v : fallback;
  } catch {
    return fallback;
  }
}

/** Noms des caches d'une version donnée. */
function cacheNames(version) {
  return {
    shell: `${CACHE_PREFIX}shell-v${version}`,
    pages: `${CACHE_PREFIX}pages-v${version}`,
    static: `${CACHE_PREFIX}static-v${version}`,
    images: `${CACHE_PREFIX}images-v${version}`,
  };
}

/** URL pré-cachées, telles que les pages les demandent réellement. */
function shellAssets(version) {
  const v = `?v=${encodeURIComponent(version)}`;
  return [
    '/',
    '/offline',
    // Cœur CSS/JS : serveHtml ajoute ?v=<version> à chaque css/ et js/.
    `/css/core.min.css${v}`,
    `/css/home.min.css${v}`,
    `/js/dist/app.min.js${v}`,
    `/js/dist/icons.min.js${v}`,
    `/js/dist/home.min.js${v}`,
    `/js/vendor/purify.min.js${v}`,
    `/js/sw-register.js${v}`,
    `/js/offline.js${v}`,
    // Traductions : sans elles, hors ligne, le titre devenait « home.title ».
    '/locales/fr.json',
    '/locales/en.json',
    // Polices : non versionnées (appelées sans paramètre par core.min.css).
    '/fonts/DMSans.woff2',
    '/fonts/BarlowCondensed-400.woff2',
    '/fonts/BarlowCondensed-500.woff2',
    '/fonts/BarlowCondensed-600.woff2',
    '/fonts/BarlowCondensed-700.woff2',
    '/manifest.webmanifest',
    '/favicon.svg',
    '/assets/logo/favicon.svg',
    '/assets/logo/vh-lockup-horizontal-mono-gold.svg',
    '/assets/logo/vh-mark-primary-gold.svg',
    '/assets/logo/icon-192.png',
    '/assets/logo/icon-512.png',
    '/assets/logo/icon-maskable-192.png',
    '/assets/logo/icon-maskable-512.png',
  ];
}

const STATIC_EXT = /\.(?:css|js|mjs|json|webmanifest|woff2?|svg|png|jpe?g|webp|avif|ico)$/i;

/**
 * Stratégie à appliquer à une requête : 'none' (le navigateur s'en charge),
 * 'page', 'immutable', 'locale', 'image' ou 'static'.
 */
function routeFor(request, origin) {
  if (request.method !== 'GET') return 'none';
  const url = new URL(request.url);
  if (url.origin !== origin) return 'none';
  if (url.pathname.startsWith('/api/') || url.pathname === '/sw.js') return 'none';
  if (request.mode === 'navigate' || request.destination === 'document') return 'page';
  if (url.pathname.startsWith('/locales/')) return 'locale';
  if (url.pathname.startsWith('/assets/airplanes/')) return 'image';
  if (url.searchParams.has('v') && /\.(?:css|js)$/i.test(url.pathname)) return 'immutable';
  if (STATIC_EXT.test(url.pathname)) return 'static';
  return 'none';
}

/**
 * Réponse cachable : complète (200), même origine, pas une redirection — une
 * réponse redirigée resservie à une navigation est refusée par le navigateur.
 */
function isCacheable(response) {
  return !!response && response.status === 200 && response.type === 'basic' && !response.redirected;
}

/** Garde au plus `max` entrées dans le cache (les plus anciennes partent). */
async function trimCache(cacheStorage, name, max) {
  const cache = await cacheStorage.open(name);
  const keys = await cache.keys();
  const excess = keys.length - max;
  if (excess <= 0) return 0;
  await Promise.all(keys.slice(0, excess).map((k) => cache.delete(k)));
  return excess;
}

/** Met en cache puis applique le plafond ; n'échoue jamais. */
async function store(cacheStorage, name, request, response, max) {
  try {
    const cache = await cacheStorage.open(name);
    await cache.put(request, response);
    if (max) await trimCache(cacheStorage, name, max);
  } catch {
    /* quota dépassé ou stockage indisponible : la réponse réseau suffit */
  }
}

/**
 * Fabrique les stratégies sur des dépendances injectées (fetch, caches) :
 * c'est ce qui permet de les tester sous Jest sans navigateur.
 * L'écriture en cache n'est jamais attendue avant de répondre (cache.put lit
 * tout le corps : l'attendre retarderait le premier octet d'une photo) ; elle
 * est confiée à `keep`, qui la rattache à event.waitUntil.
 */
function createStrategies({ fetchFn, cacheStorage, names }) {
  function save(keep, name, request, response, max) {
    const p = store(cacheStorage, name, request, response, max);
    if (keep) keep(p);
    return p;
  }

  async function networkFirstPage(request, keep) {
    try {
      const response = await fetchFn(request);
      if (isCacheable(response)) save(keep, names.pages, request, response.clone(), LIMITS.pages);
      return response;
    } catch {
      // Le HTML d'une page ne dépend que de son chemin (les filtres, la
      // langue, ?source=pwa du manifest sont lus par le JS) : à défaut de
      // l'URL exacte, la même page avec une autre requête convient.
      const cached = await cacheStorage.match(request)
        || await cacheStorage.match(request, { ignoreSearch: true });
      if (cached) return cached;
      const offline = await cacheStorage.match('/offline');
      if (offline) return offline;
      return new Response('Hors ligne — aucune version en cache.', {
        status: 503,
        headers: { 'Content-Type': 'text/plain; charset=utf-8' },
      });
    }
  }

  async function cacheFirst(request, cacheName, max, keep) {
    const cached = await cacheStorage.match(request);
    if (cached) return cached;
    const response = await fetchFn(request);
    if (isCacheable(response)) save(keep, cacheName, request, response.clone(), max);
    return response;
  }

  async function staleWhileRevalidate(request, cacheName, max, keep) {
    const cached = await cacheStorage.match(request);
    const network = fetchFn(request)
      .then((response) => {
        if (isCacheable(response)) save(keep, cacheName, request, response.clone(), max);
        return response;
      })
      .catch(() => cached || Response.error());
    if (cached) {
      if (keep) keep(network);
      return cached;
    }
    return network;
  }

  /** Réponse pour une route donnée (voir routeFor). */
  function handle(route, request, keep) {
    if (route === 'page') return networkFirstPage(request, keep);
    if (route === 'immutable') return cacheFirst(request, names.static, LIMITS.static, keep);
    if (route === 'locale') return staleWhileRevalidate(request, names.shell, 0, keep);
    if (route === 'image') return staleWhileRevalidate(request, names.images, LIMITS.images, keep);
    return staleWhileRevalidate(request, names.static, LIMITS.static, keep);
  }

  return { networkFirstPage, cacheFirst, staleWhileRevalidate, handle };
}

/** Pré-cache tolérant : un asset absent (404) ne bloque pas l'installation. */
async function precache(cacheStorage, name, urls, fetchFn) {
  const cache = await cacheStorage.open(name);
  const results = await Promise.allSettled(urls.map(async (url) => {
    const response = await fetchFn(url, { cache: 'reload' });
    if (!isCacheable(response)) throw new Error(`${url} : HTTP ${response && response.status}`);
    await cache.put(url, response);
  }));
  return results.filter((r) => r.status === 'rejected').length;
}

/** Supprime les caches du site qui n'appartiennent pas à la version courante. */
async function purgeOldCaches(cacheStorage, keep) {
  const keys = await cacheStorage.keys();
  const stale = keys.filter((k) => k.startsWith(CACHE_PREFIX) && !keep.includes(k));
  await Promise.all(stale.map((k) => cacheStorage.delete(k)));
  return stale;
}

// -----------------------------------------------------------------------------
// Branchement des événements — uniquement dans un vrai service worker.
// -----------------------------------------------------------------------------
if (typeof ServiceWorkerGlobalScope !== 'undefined' && self instanceof ServiceWorkerGlobalScope) {
  const VERSION = resolveVersion(self.location.href);
  const NAMES = cacheNames(VERSION);
  const strategies = createStrategies({
    fetchFn: (req) => fetch(req),
    cacheStorage: caches,
    names: NAMES,
  });

  self.addEventListener('install', (event) => {
    event.waitUntil(precache(caches, NAMES.shell, shellAssets(VERSION), (url, init) => fetch(url, init)));
  });

  self.addEventListener('activate', (event) => {
    event.waitUntil(
      purgeOldCaches(caches, Object.values(NAMES)).then(() => self.clients.claim())
    );
  });

  // La page propose « Recharger » quand une nouvelle version attend ; le clic
  // envoie SKIP_WAITING, puis la page se recharge sur controllerchange.
  self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting();
  });

  self.addEventListener('fetch', (event) => {
    const route = routeFor(event.request, self.location.origin);
    if (route === 'none') return;
    event.respondWith(strategies.handle(route, event.request, (p) => event.waitUntil(p)));
  });
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    CACHE_VERSION, LIMITS, resolveVersion, cacheNames, shellAssets, routeFor,
    isCacheable, trimCache, store, createStrategies, precache, purgeOldCaches,
  };
}
