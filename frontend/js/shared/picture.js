/* Helper pour émettre des <picture> avec sources AVIF + WebP.
 * La source (.jpg/.png) reste la fallback pour vieux navigateurs + crawlers sociaux.
 * Si l'URL n'est pas un asset local convertible, on retombe sur un simple <img>.
 *
 * Les URL produites portent ?v=<version> : le serveur sert alors les photos en
 * cache immuable d'un an (backend/app.js). Une photo remplacée sous le même nom
 * l'est lors d'une release, qui change la version, donc l'URL. */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  var LOCAL_IMG_RE = /^\/assets\/airplanes\/[^/?#]+\.(jpe?g|png)(\?.*)?$/i;
  var EXT_RE = /\.(jpe?g|png)(\?.*)?$/i;

  /* Version servie, lue sur le ?v= que le serveur pose sur le <script> qui
   * charge ce module (bundle js/dist/*.min.js) : c'est la version réellement
   * déployée. window.APP_VERSION (app-version.js, figé au moment du build)
   * n'est qu'un repli. */
  var SCRIPT_VERSION = (function () {
    try {
      var src = document.currentScript && document.currentScript.src;
      var m = src && /[?&]v=([^&#]+)/.exec(src);
      return m ? decodeURIComponent(m[1]) : '';
    } catch {
      return '';
    }
  })();

  function assetVersion() {
    return SCRIPT_VERSION || (typeof window.APP_VERSION === 'string' ? window.APP_VERSION : '');
  }

  /* Ajoute ?v=<version> à une URL d'asset local qui n'a pas déjà de paramètres. */
  function withVersion(url) {
    var v = assetVersion();
    if (!v || !url || url.indexOf('?') !== -1) return url;
    return url + '?v=' + encodeURIComponent(v);
  }

  function stripQuery(url) {
    return String(url || '').split('?')[0];
  }

  function esc(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }

  /* Retourne { avif, webp, fallback } si l'URL est un asset local convertible,
   * sinon null. */
  function getSources(url) {
    if (!url || typeof url !== 'string') return null;
    if (!LOCAL_IMG_RE.test(url)) return null;
    var base = url.replace(EXT_RE, '');
    return {
      avif: withVersion(base + '.avif'),
      webp: withVersion(base + '.webp'),
      fallback: withVersion(url)
    };
  }

  /* Génère le HTML d'un <picture> (ou <img> si URL non convertible).
   *
   * attrs : { alt, width, height, loading, class, id, fetchpriority, ... }
   * L'attribut `class` est posé sur l'élément <img> final (pas sur <picture>),
   * pour conserver le styling existant qui cible `.aircraft-image img`.
   * Les gestionnaires `on*` sont ignorés : la CSP bloque tout gestionnaire en
   * ligne (le repli d'image passe par un écouteur `error` délégué). */
  function pictureHtml(url, attrs) {
    return renderPicture(url, getSources(url), attrs);
  }

  function renderPicture(url, sources, attrs) {
    attrs = attrs || {};
    var alt = attrs.alt != null ? attrs.alt : '';
    var attrStr = Object.keys(attrs)
      .filter(function (k) {
        return k !== 'alt' && !/^on/i.test(k) && attrs[k] != null && attrs[k] !== false;
      })
      .map(function (k) { return k + '="' + esc(attrs[k]) + '"'; })
      .join(' ');

    if (!sources) {
      return '<img src="' + esc(url || '') + '" alt="' + esc(alt) + '"' +
             (attrStr ? ' ' + attrStr : '') + '>';
    }

    return '<picture>' +
      '<source type="image/avif" srcset="' + esc(sources.avif) + '">' +
      '<source type="image/webp" srcset="' + esc(sources.webp) + '">' +
      '<img src="' + esc(sources.fallback) + '" alt="' + esc(alt) + '"' +
      (attrStr ? ' ' + attrStr : '') + '>' +
      '</picture>';
  }

  /* Met à jour les srcset d'un <picture> existant autour d'une <img id="...">.
   * Utilisé pour la fiche détails (hero) et l'image du quiz de l'accueil, où
   * l'image est manipulée via DOM, pas via template string.
   *
   * Si le <picture> montre déjà la même photo (posée par le rendu serveur de
   * la fiche, éventuellement sous une autre version), on n'y touche pas :
   * changer le srcset relancerait le téléchargement de l'image LCP. */
  function applySourcesTo(imgEl, url) {
    if (!imgEl) return;
    var pic = imgEl.parentElement;
    var sources = getSources(url);
    var avifEl = pic && pic.querySelector && pic.querySelector('source[type="image/avif"]');
    var webpEl = pic && pic.querySelector && pic.querySelector('source[type="image/webp"]');

    if (sources) {
      var current = avifEl && avifEl.getAttribute('srcset');
      if (current && stripQuery(current) === stripQuery(sources.avif)) return;
      if (avifEl) avifEl.setAttribute('srcset', sources.avif);
      if (webpEl) webpEl.setAttribute('srcset', sources.webp);
      imgEl.src = sources.fallback;
    } else {
      if (avifEl) avifEl.removeAttribute('srcset');
      if (webpEl) webpEl.removeAttribute('srcset');
      imgEl.src = url || '';
    }
  }

  /* Vignette 320 px (scripts/convert-images.js → assets/airplanes/thumbs/) :
   * ~4 Ko au lieu de ~60 Ko, pour les listes à petite image. Seules les
   * sources AVIF / WebP pointent sur la vignette ; l'<img> garde la photo
   * pleine pour les navigateurs qui ne lisent aucun des deux formats.
   * Retourne null si l'URL n'est pas un asset local convertible. */
  function getThumbSources(url) {
    var sources = getSources(url);
    if (!sources) return null;
    var name = url.replace(/^\/assets\/airplanes\//, '').replace(EXT_RE, '');
    var base = '/assets/airplanes/thumbs/' + name;
    return { avif: withVersion(base + '.avif'), webp: withVersion(base + '.webp'), fallback: sources.fallback };
  }

  function thumbHtml(url, attrs) {
    return renderPicture(url, getThumbSources(url), attrs);
  }

  window.VH.shared.picture = {
    pictureHtml: pictureHtml,
    thumbHtml: thumbHtml,
    getSources: getSources,
    getThumbSources: getThumbSources,
    applySourcesTo: applySourcesTo,
    withVersion: withVersion
  };
})();
