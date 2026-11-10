/* Enregistrement du service worker + annonce des mises à jour.
 *
 * - N'enregistre qu'en HTTPS ou en local (le navigateur l'exige), jamais en
 *   mode « économie de données » (Save-Data). Ne bloque pas le rendu : tout
 *   part après l'événement load.
 * - Le SW est enregistré sous `/sw.js?v=<version>`, la version étant lue sur
 *   le `?v=` que serveHtml ajoute à ce script : le SW pré-cache ainsi les URL
 *   exactes que les pages demandent, et un déploiement change l'URL du SW.
 * - Quand une nouvelle version est installée et attend, un toast propose
 *   « Recharger » : le clic envoie SKIP_WAITING au SW en attente, puis la page
 *   se recharge dès que ce nouveau SW prend la main (controllerchange).
 */
(function () {
  'use strict';

  var LOCAL_HOSTS = ['localhost', '127.0.0.1', '[::1]'];
  var FALLBACK = {
    fr: { message: 'Nouvelle version disponible', reload: 'Recharger', close: 'Fermer' },
    en: { message: 'New version available', reload: 'Reload', close: 'Close' },
  };
  var KEYS = { message: 'pwa.update_available', reload: 'pwa.update_reload', close: 'common.close' };

  /** Version portée par l'URL de ce script (`?v=`), ou null. */
  function scriptVersion(src, base) {
    if (!src) return null;
    try {
      var v = new URL(src, base).searchParams.get('v');
      return v && /^[0-9A-Za-z._-]{1,32}$/.test(v) ? v : null;
    } catch {
      return null;
    }
  }

  /** URL d'enregistrement du service worker. */
  function swUrl(version) {
    return version ? '/sw.js?v=' + encodeURIComponent(version) : '/sw.js';
  }

  /** Le contexte permet-il un service worker ? */
  function canRegister(nav, loc) {
    if (!nav || !('serviceWorker' in nav)) return false;
    if (loc.protocol !== 'https:' && LOCAL_HOSTS.indexOf(loc.hostname) === -1) return false;
    // Respecte Save-Data (ex. Chrome Mobile en mode économie de données).
    return !(nav.connection && nav.connection.saveData);
  }

  /** Libellé traduit ; repli codé en dur si i18n n'est pas (encore) chargé. */
  function label(name, win, doc) {
    var key = KEYS[name];
    var i18n = win && win.i18n;
    if (i18n && typeof i18n.t === 'function') {
      var value = i18n.t(key);
      if (value && value !== key) return value;
    }
    var lang = (doc.documentElement.lang || 'fr').slice(0, 2);
    return (FALLBACK[lang] || FALLBACK.fr)[name];
  }

  /** Conteneur des toasts de la page (créé s'il manque). */
  function toastContainer(doc) {
    var container = doc.getElementById('toast-container');
    if (container) return container;
    container = doc.createElement('div');
    container.id = 'toast-container';
    container.setAttribute('aria-live', 'polite');
    doc.body.appendChild(container);
    return container;
  }

  /**
   * Toast persistant « Nouvelle version disponible — Recharger ».
   * Un seul à la fois ; aucun innerHTML de texte (textContent seulement).
   */
  function showUpdateNotice(worker, ctx) {
    var doc = ctx.document;
    if (doc.querySelector('.sw-update')) return null;

    var toast = doc.createElement('div');
    toast.className = 'toast toast-info sw-update';
    toast.setAttribute('role', 'status');

    var icon = doc.createElement('i');
    icon.className = 'fas fa-info-circle';
    icon.setAttribute('aria-hidden', 'true');

    var message = doc.createElement('span');
    message.className = 'toast-message';
    message.textContent = label('message', ctx.window, doc);

    var reload = doc.createElement('button');
    reload.type = 'button';
    reload.className = 'sw-update-reload';
    reload.textContent = label('reload', ctx.window, doc);
    reload.addEventListener('click', function () {
      ctx.state.reloadRequested = true;
      reload.disabled = true;
      reload.setAttribute('aria-busy', 'true');
      worker.postMessage({ type: 'SKIP_WAITING' });
    });

    var close = doc.createElement('button');
    close.type = 'button';
    close.className = 'toast-close';
    close.setAttribute('aria-label', label('close', ctx.window, doc));
    var closeIcon = doc.createElement('i');
    closeIcon.className = 'fas fa-times';
    closeIcon.setAttribute('aria-hidden', 'true');
    close.appendChild(closeIcon);
    close.addEventListener('click', function () { toast.remove(); });

    toast.appendChild(icon);
    toast.appendChild(message);
    toast.appendChild(reload);
    toast.appendChild(close);
    toastContainer(doc).appendChild(toast);
    return toast;
  }

  /**
   * Surveille une inscription : annonce un SW en attente, présent dès
   * maintenant ou installé plus tard. Pas d'annonce au tout premier
   * enregistrement (aucun contrôleur : il n'y a rien à mettre à jour).
   */
  function watchRegistration(registration, ctx) {
    var sw = ctx.navigator.serviceWorker;
    function notifyIfWaiting(worker) {
      if (worker && sw.controller) showUpdateNotice(worker, ctx);
    }
    notifyIfWaiting(registration.waiting);
    registration.addEventListener('updatefound', function () {
      var installing = registration.installing;
      if (!installing) return;
      installing.addEventListener('statechange', function () {
        if (installing.state === 'installed') notifyIfWaiting(installing);
      });
    });
  }

  /** Point d'entrée ; renvoie la promesse d'enregistrement (ou null). */
  function init(ctx) {
    if (!canRegister(ctx.navigator, ctx.location)) return null;
    ctx.state = ctx.state || { reloadRequested: false };
    var sw = ctx.navigator.serviceWorker;

    // Recharge seulement à la demande de l'utilisateur : la première prise de
    // contrôle (clients.claim) ne doit pas recharger la page.
    sw.addEventListener('controllerchange', function () {
      if (!ctx.state.reloadRequested || ctx.state.reloading) return;
      ctx.state.reloading = true;
      ctx.location.reload();
    });

    var url = swUrl(scriptVersion(ctx.scriptSrc, ctx.location.href));
    return sw.register(url, { scope: '/' })
      .then(function (registration) {
        watchRegistration(registration, ctx);
        return registration;
      })
      .catch(function () {
        /* silencieux : l'échec du SW ne doit pas casser la page */
        return null;
      });
  }

  /** Démarrage dans la page : lit currentScript tout de suite, enregistre après load. */
  function boot(win, doc) {
    // currentScript n'existe que pendant l'exécution du script : on le lit ici.
    var ctx = {
      window: win, document: doc, navigator: win.navigator, location: win.location,
      scriptSrc: doc.currentScript ? doc.currentScript.src : null,
      state: { reloadRequested: false },
    };
    if (doc.readyState === 'complete') {
      init(ctx);
    } else {
      win.addEventListener('load', function () { init(ctx); }, { once: true });
    }
    return ctx;
  }

  var api = {
    scriptVersion: scriptVersion, swUrl: swUrl, canRegister: canRegister,
    label: label, showUpdateNotice: showUpdateNotice,
    watchRegistration: watchRegistration, init: init, boot: boot,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  } else {
    boot(window, document);
  }
})();
