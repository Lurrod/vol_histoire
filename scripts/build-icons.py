#!/usr/bin/env python3
"""
Build a self-hosted SVG icon module from Font Awesome Free.
Downloads each used icon from jsDelivr, extracts viewBox + path,
generates frontend/js/icons.js with a runtime <i> → <svg> swapper.
"""
import urllib.request
import re
import os
import shutil
import sys

# Liste auditée — exclure UUIDs et modifiers
ICONS_RAW = """
fa-arrow-left fa-arrow-right fa-balance-scale fa-bug fa-building fa-bullhorn
fa-bullseye fa-burst fa-calendar fa-calendar-check fa-calendar-days fa-chart-area
fa-chart-bar fa-chart-line fa-chart-pie fa-check fa-check-circle fa-check-double
fa-chevron-down fa-chevron-left fa-chevron-right fa-child fa-circle fa-circle-check
fa-circle-notch fa-clock fa-clock-rotate-left fa-cog fa-cookie-bite fa-copyright
fa-crosshairs fa-crown fa-database fa-download fa-edit fa-envelope
fa-envelope-open-text fa-exclamation fa-exclamation-circle fa-exclamation-triangle
fa-external-link-alt fa-eye fa-eye-slash fa-fighter-jet fa-file-alt fa-file-contract
fa-file-lines fa-file-pdf fa-file-shield fa-filter fa-fingerprint fa-folder
fa-gauge-high fa-gavel fa-globe fa-hand fa-hand-paper fa-handshake fa-heart
fa-heart-broken fa-heart-crack fa-home fa-id-badge fa-image fa-industry fa-info-circle
fa-jet-fighter fa-key fa-language fa-layer-group fa-lightbulb fa-link fa-list fa-lock
fa-magnifying-glass fa-microchip fa-mouse-pointer fa-palette fa-paper-plane fa-pause
fa-pen fa-pen-to-square fa-phone fa-plane fa-plane-departure fa-plane-slash fa-plus
fa-question-circle fa-redo fa-route fa-satellite-dish fa-save fa-search fa-server
fa-share-nodes fa-shield fa-shield-alt fa-shield-halved fa-sign-in-alt fa-sign-out-alt
fa-signature fa-sliders-h fa-sort fa-star fa-sync fa-sync-alt fa-tachometer-alt fa-tags
fa-th fa-timeline fa-times fa-times-circle fa-tower-broadcast fa-trash fa-trash-alt
fa-triangle-exclamation fa-undo fa-user fa-user-astronaut fa-user-check fa-user-circle
fa-user-edit fa-user-lock fa-user-plus fa-user-shield fa-users fa-users-cog fa-virus
fa-weight-hanging fa-jet-fighter-up
fa-ruler-combined fa-ruler-horizontal fa-ruler-vertical fa-arrows-left-right
fa-feather-pointed fa-scale-balanced fa-arrow-trend-up fa-location-crosshairs
fa-arrow-up-wide-short fa-arrow-down-wide-short fa-user-tie fa-gears fa-cogs
fa-bolt fa-rocket fa-fire fa-coins fa-flag fa-quote-right fa-diagram-project
fa-arrow-up-right-from-square
fa-facebook fa-twitter fa-instagram fa-youtube fa-github fa-linkedin fa-reddit
fa-wikipedia-w
"""

# FA6 a renommé / refactoré certaines icônes — alias vers les noms FA6
ALIASES = {
    'fa-edit': 'pen-to-square',
    'fa-trash-alt': 'trash-can',
    'fa-shield-alt': 'shield-halved',
    'fa-tachometer-alt': 'gauge-high',
    'fa-sign-in-alt': 'right-to-bracket',
    'fa-sign-out-alt': 'right-from-bracket',
    'fa-external-link-alt': 'arrow-up-right-from-square',
    'fa-sync-alt': 'arrows-rotate',
    'fa-sync': 'arrows-rotate',
    'fa-undo': 'arrow-rotate-left',
    'fa-redo': 'arrow-rotate-right',
    'fa-search': 'magnifying-glass',
    'fa-fighter-jet': 'jet-fighter',
    'fa-cog': 'gear',
    'fa-file-alt': 'file-lines',
    'fa-info-circle': 'circle-info',
    'fa-question-circle': 'circle-question',
    'fa-check-circle': 'circle-check',
    'fa-exclamation-circle': 'circle-exclamation',
    'fa-exclamation-triangle': 'triangle-exclamation',
    'fa-times-circle': 'circle-xmark',
    'fa-times': 'xmark',
    'fa-th': 'table-cells-large',
    'fa-balance-scale': 'scale-balanced',
    'fa-shield': 'shield-halved',
    'fa-sliders-h': 'sliders',
    'fa-hand-paper': 'hand',
    'fa-heart-broken': 'heart-crack',
    'fa-home': 'house',
    'fa-child': 'child',
    'fa-mouse-pointer': 'arrow-pointer',
    'fa-save': 'floppy-disk',
    'fa-user-circle': 'circle-user',
    'fa-user-edit': 'user-pen',
    'fa-users-cog': 'users-gear',
    'fa-cogs': 'gears',
}

BRANDS = {'fa-facebook', 'fa-twitter', 'fa-instagram', 'fa-youtube', 'fa-github', 'fa-linkedin', 'fa-reddit', 'fa-wikipedia-w'}

def main():
    icons = ICONS_RAW.split()
    cache_dir = 'frontend/.svg-cache'
    os.makedirs(cache_dir, exist_ok=True)

    results = {}
    missing = []

    for full_name in icons:
        short = ALIASES.get(full_name, full_name[3:])
        style = 'brands' if full_name in BRANDS else 'solid'
        cache_file = os.path.join(cache_dir, f'{style}-{short}.svg')

        if os.path.exists(cache_file):
            with open(cache_file, 'r', encoding='utf-8') as f:
                svg = f.read()
        else:
            url = f'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/svgs/{style}/{short}.svg'
            try:
                req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
                with urllib.request.urlopen(req, timeout=15) as r:
                    svg = r.read().decode('utf-8')
                with open(cache_file, 'w', encoding='utf-8') as f:
                    f.write(svg)
            except Exception as e:
                missing.append((full_name, short, style, str(e)[:60]))
                continue

        vb = re.search(r'viewBox="([^"]+)"', svg)
        path = re.search(r'<path d="([^"]+)"', svg)
        if vb and path:
            results[full_name] = (vb.group(1), path.group(1))
        else:
            missing.append((full_name, short, style, 'no viewBox or path'))

    print(f'OK : {len(results)} icons | missing : {len(missing)}')
    for m in missing:
        print('  MISS', m)

    # Génération du module JS
    lines = []
    lines.append('/* Font Awesome subset auto-généré — ' + str(len(results)) + ' icônes */')
    lines.append('/* Build via: python scripts/build-icons.py */')
    lines.append('(function () {')
    lines.append('  "use strict";')
    lines.append('  var ICONS = {')
    for k in sorted(results.keys()):
        name = k[3:]  # strip 'fa-'
        vb, d = results[k]
        d_safe = d.replace('\\', '\\\\').replace('"', '\\"')
        lines.append(f'    "{name}": ["{vb}", "{d_safe}"],')
    lines.append('  };')
    lines.append(JS_RUNTIME)
    lines.append('})();')

    with open('frontend/js/icons.js', 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    size = os.path.getsize('frontend/js/icons.js')
    print(f'frontend/js/icons.js : {size} bytes ({size // 1024} Ko)')

    shutil.rmtree(cache_dir, ignore_errors=True)


JS_RUNTIME = r'''
  function svg(name) {
    var d = ICONS[name];
    if (!d) return null;
    return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="' + d[0] +
      '" fill="currentColor" aria-hidden="true"><path d="' + d[1] + '"/></svg>';
  }

  function pickIconName(el) {
    for (var i = 0; i < el.classList.length; i++) {
      var c = el.classList[i];
      if (c.indexOf('fa-') !== 0) continue;
      // Modifiers / styles à ignorer
      if (c === 'fa-solid' || c === 'fa-regular' || c === 'fa-brands') continue;
      if (c === 'fa-spin' || c === 'fa-pulse' || c === 'fa-fw' || c === 'fa-2x' ||
          c === 'fa-3x' || c === 'fa-lg' || c === 'fa-sm' || c === 'fa-xs') continue;
      return c.slice(3);
    }
    return null;
  }

  // Liste des classes Font Awesome à NE PAS recopier sur le SVG cible
  var FA_PREFIXES = ['fa-', 'fas', 'far', 'fab', 'fa '];
  function isFaClass(c) {
    if (c === 'fas' || c === 'far' || c === 'fab' || c === 'fa') return true;
    return c.indexOf('fa-') === 0;
  }

  function swap(root) {
    if (!root || root.nodeType !== 1) return;
    var nodes;
    try {
      nodes = (root.matches && root.matches('i.fas, i.far, i.fab, i.fa, i[class*="fa-"]'))
        ? [root]
        : root.querySelectorAll('i.fas, i.far, i.fab, i.fa, i[class*="fa-"]');
    } catch (e) { return; }
    for (var i = 0; i < nodes.length; i++) {
      var el = nodes[i];
      if (el.dataset && el.dataset.iconSwapped) continue;
      var name = pickIconName(el);
      if (!name) continue;
      var markup = svg(name);
      if (!markup) continue;
      var wrap = document.createElement('span');
      wrap.innerHTML = markup;
      var node = wrap.firstChild;

      // Classes : 'icon icon-<name>' + toutes les classes non-FA héritées du <i>
      var classes = ['icon', 'icon-' + name];
      for (var k = 0; k < el.classList.length; k++) {
        var c = el.classList[k];
        if (!isFaClass(c)) classes.push(c);
      }
      if (el.classList.contains('fa-spin')) classes.push('icon-spin');
      node.setAttribute('class', classes.join(' '));

      // Style inline : recopier tel quel s'il existe
      var inlineStyle = el.getAttribute('style');
      if (inlineStyle) node.setAttribute('style', inlineStyle);

      // Attributs d'accessibilité
      var label = el.getAttribute('aria-label') || el.getAttribute('title');
      if (label) {
        node.setAttribute('role', 'img');
        node.setAttribute('aria-label', label);
        node.removeAttribute('aria-hidden');
      }
      // Attributs data-* : recopier (utilisé par certains scripts)
      var attrs = el.attributes;
      for (var a = 0; a < attrs.length; a++) {
        if (attrs[a].name.indexOf('data-') === 0) {
          node.setAttribute(attrs[a].name, attrs[a].value);
        }
      }

      if (el.parentNode) el.parentNode.replaceChild(node, el);
    }
  }

  function swapAll() { swap(document.documentElement); }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', swapAll);
  } else {
    swapAll();
  }

  if ('MutationObserver' in window) {
    var mo = new MutationObserver(function (muts) {
      for (var i = 0; i < muts.length; i++) {
        var added = muts[i].addedNodes;
        for (var j = 0; j < added.length; j++) {
          var n = added[j];
          if (n.nodeType === 1) swap(n);
        }
      }
    });
    mo.observe(document.documentElement, { childList: true, subtree: true });
  }

  window.icon = svg;
'''


if __name__ == '__main__':
    main()
