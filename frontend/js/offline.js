/* Page hors ligne (offline.html).
 *
 * Servie par le service worker à la place d'une page jamais consultée, sous
 * l'URL demandée. Liste les pages déjà enregistrées pour une lecture sans
 * connexion (caches `vh-pages-*` du SW), propose « Réessayer » et recharge
 * d'elle-même au retour du réseau.
 */
/* global DOMParser */
(function () {
  'use strict';

  var PAGES_PREFIX = 'vh-pages-';
  var SITE_SUFFIX = /\s*[|—–-]\s*Vol d'Histoire\s*$/;

  /** Titre lisible d'une page HTML en cache (sans le suffixe du site). */
  function titleOf(html) {
    var m = /<title[^>]*>([\s\S]*?)<\/title>/i.exec(html || '');
    if (!m) return '';
    // DOMParser décode les entités (&#39;, &amp;…) sans rien exécuter.
    var parsed = new DOMParser().parseFromString('<title>' + m[1] + '</title>', 'text/html');
    return parsed.title.replace(SITE_SUFFIX, '').trim();
  }

  /** Pages en cache, même origine, hors page hors ligne elle-même. */
  async function listCachedPages(cacheStorage, origin) {
    var names = (await cacheStorage.keys()).filter(function (n) { return n.indexOf(PAGES_PREFIX) === 0; });
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
        var title = response ? titleOf(await response.text()) : '';
        pages.push({ href: href, title: title || href });
      }
    }
    return pages;
  }

  /** Remplit la liste (textContent uniquement) et bascule le message vide. */
  function render(doc, pages) {
    var list = doc.getElementById('offline-visited');
    var empty = doc.getElementById('offline-empty');
    if (!list || !empty) return;
    list.textContent = '';
    pages.forEach(function (page) {
      var li = doc.createElement('li');
      var a = doc.createElement('a');
      a.href = page.href;
      a.textContent = page.title;
      li.appendChild(a);
      list.appendChild(li);
    });
    list.hidden = pages.length === 0;
    empty.hidden = pages.length > 0;
  }

  function init(ctx) {
    var doc = ctx.document;
    var retry = doc.getElementById('offline-retry');
    if (retry) retry.addEventListener('click', function () { ctx.location.reload(); });
    // Le réseau revient : la page demandée peut maintenant être chargée.
    ctx.window.addEventListener('online', function () { ctx.location.reload(); }, { once: true });
    if (!ctx.caches) {
      render(doc, []);
      return Promise.resolve([]);
    }
    return listCachedPages(ctx.caches, ctx.location.origin)
      .catch(function () { return []; })
      .then(function (pages) {
        render(doc, pages);
        return pages;
      });
  }

  /** Démarrage dans la page, une fois le DOM prêt. */
  function boot(win, doc) {
    var start = function () {
      init({ window: win, document: doc, location: win.location, caches: win.caches });
    };
    if (doc.readyState === 'loading') {
      doc.addEventListener('DOMContentLoaded', start, { once: true });
    } else {
      start();
    }
  }

  var api = { titleOf: titleOf, listCachedPages: listCachedPages, render: render, init: init, boot: boot };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  } else {
    boot(window, document);
  }
})();
