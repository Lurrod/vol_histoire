/* Helper pour émettre des <picture> avec sources AVIF + WebP.
 * La source (.jpg/.png) reste la fallback pour vieux navigateurs + crawlers sociaux.
 * Si l'URL n'est pas un asset local convertible, on retombe sur un simple <img>. */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  var LOCAL_IMG_RE = /^\/assets\/airplanes\/[^/?#]+\.(jpe?g|png)(\?.*)?$/i;
  var EXT_RE = /\.(jpe?g|png)(\?.*)?$/i;

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
      avif: base + '.avif',
      webp: base + '.webp',
      fallback: url
    };
  }

  /* Génère le HTML d'un <picture> (ou <img> si URL non convertible).
   *
   * attrs : { alt, width, height, loading, class, id, onerror, fetchpriority, ... }
   * L'attribut `class` est posé sur l'élément <img> final (pas sur <picture>),
   * pour conserver le styling existant qui cible `.aircraft-image img`. */
  function pictureHtml(url, attrs) {
    attrs = attrs || {};
    var alt = attrs.alt != null ? attrs.alt : '';
    var attrStr = Object.keys(attrs)
      .filter(function (k) { return k !== 'alt' && attrs[k] != null && attrs[k] !== false; })
      .map(function (k) { return k + '="' + esc(attrs[k]) + '"'; })
      .join(' ');

    var sources = getSources(url);
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
   * Utilisé pour la fiche détails où l'image hero est manipulée via DOM,
   * pas via template string. */
  function applySourcesTo(imgEl, url) {
    if (!imgEl) return;
    var pic = imgEl.parentElement;
    var sources = getSources(url);
    var avifEl = pic && pic.querySelector && pic.querySelector('source[type="image/avif"]');
    var webpEl = pic && pic.querySelector && pic.querySelector('source[type="image/webp"]');

    if (sources) {
      if (avifEl) avifEl.setAttribute('srcset', sources.avif);
      if (webpEl) webpEl.setAttribute('srcset', sources.webp);
      imgEl.src = sources.fallback;
    } else {
      if (avifEl) avifEl.removeAttribute('srcset');
      if (webpEl) webpEl.removeAttribute('srcset');
      imgEl.src = url || '';
    }
  }

  window.VH.shared.picture = { pictureHtml: pictureHtml, getSources: getSources, applySourcesTo: applySourcesTo };
})();
