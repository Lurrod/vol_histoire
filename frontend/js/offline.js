/* Page hors ligne (offline.html) — « lecture d'abord ».
 *
 * Servie par le service worker à la place d'une page jamais consultée, sous
 * l'URL demandée. L'état du réseau tient dans un bandeau ; la page montre ce
 * qui reste lisible sans connexion :
 *  - les fiches en cartes, avec leur photo quand le SW l'a gardée
 *    (caches `vh-images-*`, vignette de préférence) ;
 *  - les conflits et les autres pages en listes de liens.
 * Pages lues dans les caches `vh-pages-*` du SW. « Réessayer » interroge
 * vraiment le serveur (/api/live, sans cache) avant de recharger ; la page se
 * recharge d'elle-même au retour du réseau.
 */
/* global DOMParser */
(function () {
  'use strict';

  var PAGES_PREFIX = 'vh-pages-';
  var IMAGES_PREFIX = 'vh-images-';
  var SITE_SUFFIX = /\s*[|—–-]\s*Vol d'Histoire\s*$/;
  var PHOTO_RE = /^\/assets\/airplanes\/(thumbs\/)?([^/]+)\.(avif|webp|jpe?g|png)$/i;
  var PROBE_URL = '/api/live';
  var PROBE_TIMEOUT_MS = 4000;

  // Listes de liens sous les cartes des fiches : clé i18n, repli, icône.
  var LIST_GROUPS = [
    { kind: 'conflicts', key: 'offline.group_conflicts', fallback: 'Conflits', icon: 'fa-flag' },
    { kind: 'pages', key: 'offline.group_pages', fallback: 'Pages', icon: 'fa-file-lines' }
  ];

  function t(key, fallback) {
    var value = (typeof i18n !== 'undefined' && i18n && typeof i18n.t === 'function') ? i18n.t(key) : null;
    return value && value !== key ? value : fallback;
  }

  function decode(text) {
    // DOMParser décode les entités (&#39;, &amp;…) sans rien exécuter.
    return new DOMParser().parseFromString('<title>' + text + '</title>', 'text/html').title;
  }

  /** Titre lisible d'une page HTML en cache (sans le suffixe du site). */
  function titleOf(html) {
    var m = /<title[^>]*>([\s\S]*?)<\/title>/i.exec(html || '');
    if (!m) return '';
    return decode(m[1]).replace(SITE_SUFFIX, '').trim();
  }

  /** Nom de la photo d'une fiche (og:image → « rafale »), ou ''. */
  function imageOf(html) {
    var m = /<meta[^>]+property="og:image"[^>]+content="([^"]+)"/i.exec(html || '');
    if (!m) return '';
    try {
      var photo = PHOTO_RE.exec(new URL(m[1], 'http://x').pathname);
      return photo ? photo[2] : '';
    } catch {
      return '';
    }
  }

  /** « Rafale — chasseur, France (1986) » → { name, meta }. */
  function splitTitle(title) {
    var parts = String(title || '').split(' — ');
    return { name: parts[0], meta: parts.slice(1).join(' — ') };
  }

  /** Famille d'une page d'après son chemin. */
  function kindOf(href) {
    var path = String(href || '').split('?')[0];
    if (path.indexOf('/details/') === 0) return 'aircraft';
    if (path === '/conflits' || path.indexOf('/conflits/') === 0) return 'conflicts';
    return 'pages';
  }

  async function cachesWithPrefix(cacheStorage, prefix) {
    return (await cacheStorage.keys()).filter(function (n) { return n.indexOf(prefix) === 0; });
  }

  /** Pages en cache, même origine, hors page hors ligne elle-même. */
  async function listCachedPages(cacheStorage, origin) {
    var names = await cachesWithPrefix(cacheStorage, PAGES_PREFIX);
    var seen = {};
    var pages = [];
    for (var i = 0; i < names.length; i++) {
      var cache = await cacheStorage.open(names[i]);
      var requests = await cache.keys();
      for (var j = 0; j < requests.length; j++) {
        var url = new URL(requests[j].url);
        var href = url.pathname + url.search;
        if (url.origin !== origin || url.pathname === '/offline' || seen[href]) continue;
        seen[href] = true;
        var response = await cache.match(requests[j]);
        var html = response ? await response.text() : '';
        pages.push({ href: href, title: titleOf(html) || href, image: imageOf(html) });
      }
    }
    return pages;
  }

  /** Photos gardées par le SW : { nom: url }, la vignette l'emporte sur la photo pleine. */
  async function listCachedImages(cacheStorage, origin) {
    var names = await cachesWithPrefix(cacheStorage, IMAGES_PREFIX);
    var found = {};
    for (var i = 0; i < names.length; i++) {
      var requests = await (await cacheStorage.open(names[i])).keys();
      for (var j = 0; j < requests.length; j++) {
        var url = new URL(requests[j].url);
        var m = url.origin === origin ? PHOTO_RE.exec(url.pathname) : null;
        if (!m) continue;
        var isThumb = Boolean(m[1]);
        var current = found[m[2]];
        if (!current || (isThumb && !current.thumb)) found[m[2]] = { url: url.pathname + url.search, thumb: isThumb };
      }
    }
    var out = {};
    Object.keys(found).forEach(function (k) { out[k] = found[k].url; });
    return out;
  }

  function byTitle(a, b) {
    return a.title.localeCompare(b.title, undefined, { sensitivity: 'base' });
  }

  /** { aircraft: [...], conflicts: [...], pages: [...] }, chaque liste triée. */
  function groupPages(pages) {
    var groups = { aircraft: [], conflicts: [], pages: [] };
    pages.forEach(function (page) { groups[kindOf(page.href)].push(page); });
    Object.keys(groups).forEach(function (k) { groups[k].sort(byTitle); });
    return groups;
  }

  function el(doc, tag, className, text) {
    var node = doc.createElement(tag);
    if (className) node.className = className;
    if (text != null) node.textContent = text;
    return node;
  }

  function icon(doc, name) {
    var i = el(doc, 'i', 'fas ' + name);
    i.setAttribute('aria-hidden', 'true');
    return i;
  }

  /** Carte d'une fiche : photo en cache (sinon pictogramme), nom, type et pays. */
  function buildCard(doc, page, images) {
    var li = el(doc, 'li');
    var a = el(doc, 'a', 'offline-card');
    a.href = page.href;
    var media = el(doc, 'span', 'offline-card-media');
    var src = page.image && images[page.image];
    if (src) {
      var img = el(doc, 'img');
      img.src = src;
      img.alt = '';
      img.setAttribute('decoding', 'async');
      media.appendChild(img);
    } else {
      media.classList.add('is-empty');
      media.appendChild(icon(doc, 'fa-plane'));
    }
    var parts = splitTitle(page.title);
    var body = el(doc, 'span', 'offline-card-body');
    body.appendChild(el(doc, 'span', 'offline-card-name', parts.name));
    if (parts.meta) body.appendChild(el(doc, 'span', 'offline-card-meta', parts.meta));
    a.append(media, body);
    li.appendChild(a);
    return li;
  }

  function groupHeading(doc, label, iconName, count) {
    var h2 = el(doc, 'h2', 'offline-group-title');
    h2.append(icon(doc, iconName), el(doc, 'span', null, label), el(doc, 'span', 'offline-group-count', String(count)));
    return h2;
  }

  /** Remplit la page (textContent uniquement) et bascule l'état vide. */
  function render(doc, pages, images) {
    var box = doc.getElementById('offline-groups');
    var empty = doc.getElementById('offline-empty');
    var count = doc.getElementById('offline-count');
    if (!box || !empty) return;
    var groups = groupPages(pages);
    box.textContent = '';

    if (groups.aircraft.length) {
      var section = el(doc, 'section', 'offline-group offline-group--aircraft');
      section.appendChild(groupHeading(doc, t('offline.group_aircraft', 'Fiches'), 'fa-plane', groups.aircraft.length));
      var cards = el(doc, 'ul', 'offline-cards');
      groups.aircraft.forEach(function (page) { cards.appendChild(buildCard(doc, page, images || {})); });
      section.appendChild(cards);
      box.appendChild(section);
    }

    var listGroups = LIST_GROUPS.filter(function (group) { return groups[group.kind].length > 0; });
    var lists = listGroups.length ? el(doc, 'div', 'offline-lists') : null;
    listGroups.forEach(function (group) {
      var items = groups[group.kind];
      var section = el(doc, 'section', 'offline-group');
      section.appendChild(groupHeading(doc, t(group.key, group.fallback), group.icon, items.length));
      var ul = el(doc, 'ul', 'offline-links');
      items.forEach(function (page) {
        var li = el(doc, 'li');
        var a = el(doc, 'a', null, page.title);
        a.href = page.href;
        li.appendChild(a);
        ul.appendChild(li);
      });
      section.appendChild(ul);
      lists.appendChild(section);
    });
    if (lists) box.appendChild(lists);

    box.hidden = pages.length === 0;
    empty.hidden = pages.length > 0;
    if (count) {
      count.textContent = String(pages.length);
      count.hidden = pages.length === 0;
    }
  }

  /** Pastille d'état : 'offline', 'online' (rechargement) ou 'still' (essai manqué). */
  function setState(doc, mode) {
    var box = doc.getElementById('offline-state');
    var text = doc.getElementById('offline-state-text');
    if (!box || !text) return;
    var labels = {
      offline: t('offline.state_offline', 'Hors ligne'),
      online: t('offline.state_online', 'Connexion rétablie, chargement…'),
      still: t('offline.state_still', 'Toujours hors ligne')
    };
    text.removeAttribute('data-i18n');
    text.textContent = labels[mode] || labels.offline;
    box.classList.toggle('is-online', mode === 'online');
    box.classList.toggle('is-still', mode === 'still');
  }

  /** true si le serveur répond (requête sans cache, abandonnée après un délai). */
  async function probe(fetchImpl, timeoutMs) {
    var controller = typeof AbortController === 'function' ? new AbortController() : null;
    var timer = controller ? setTimeout(function () { controller.abort(); }, timeoutMs || PROBE_TIMEOUT_MS) : null;
    try {
      var response = await fetchImpl(PROBE_URL, { cache: 'no-store', signal: controller ? controller.signal : undefined });
      return Boolean(response && response.ok);
    } catch {
      return false;
    } finally {
      if (timer) clearTimeout(timer);
    }
  }

  /** « Réessayer » : bouton occupé, essai réseau, puis rechargement ou message. */
  async function retry(ctx, button) {
    var busy = ctx.window.VH && ctx.window.VH.busyButton;
    if (button && busy) busy.start(button);
    var ok = await probe(ctx.fetch, ctx.timeoutMs);
    if (ok) {
      setState(ctx.document, 'online');
      ctx.location.reload();
      return true;
    }
    if (button && busy) busy.stop(button);
    setState(ctx.document, 'still');
    return false;
  }

  function init(ctx) {
    var doc = ctx.document;
    var button = doc.getElementById('offline-retry');
    var running = false;
    if (button) {
      button.addEventListener('click', function () {
        if (running) return;
        running = true;
        retry(ctx, button).then(function () { running = false; });
      });
    }
    // Le réseau revient : la page demandée peut maintenant être chargée.
    ctx.window.addEventListener('online', function () {
      setState(doc, 'online');
      ctx.location.reload();
    }, { once: true });
    ctx.window.addEventListener('offline', function () { setState(doc, 'offline'); });
    if (!ctx.caches) {
      render(doc, [], {});
      return Promise.resolve([]);
    }
    var images = {};
    return Promise.all([
      listCachedPages(ctx.caches, ctx.location.origin),
      listCachedImages(ctx.caches, ctx.location.origin).catch(function () { return {}; })
    ])
      .then(function (found) {
        images = found[1];
        return found[0];
      })
      .catch(function () { return []; })
      .then(function (pages) {
        render(doc, pages, images);
        // Libellés des groupes posés avant le chargement de la langue :
        // réécrits quand elle arrive (sinon « Fiches » sur une page anglaise).
        ctx.window.addEventListener('i18nReady', function () { render(doc, pages, images); }, { once: true });
        return pages;
      });
  }

  /** Démarrage dans la page, une fois le DOM prêt. */
  function boot(win, doc) {
    var start = function () {
      init({
        window: win,
        document: doc,
        location: win.location,
        caches: win.caches,
        fetch: function (url, opts) { return win.fetch(url, opts); }
      });
    };
    if (doc.readyState === 'loading') {
      doc.addEventListener('DOMContentLoaded', start, { once: true });
    } else {
      start();
    }
  }

  var api = {
    titleOf: titleOf, imageOf: imageOf, splitTitle: splitTitle, kindOf: kindOf,
    listCachedPages: listCachedPages, listCachedImages: listCachedImages, groupPages: groupPages,
    render: render, setState: setState, probe: probe, retry: retry, init: init, boot: boot
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  } else {
    boot(window, document);
  }
})();
