/* VH.viewMorph — morphings par l'API View Transitions (2026-11-19).
 *
 * Deux usages, un seul balisage :
 *   - un élément qui représente un appareil porte data-morph-id="<id>",
 *     et sa photo data-morph="photo" (cartes du hangar, des favoris, des
 *     conflits, de la frise, filiation de la fiche) ; le hero de la fiche
 *     porte data-morph-self (son id se lit dans l'URL).
 *
 * 1. D'une page à l'autre (navigation) : la photo de la carte cliquée
 *    devient la photo de la fiche, et inversement au retour. La carte
 *    cliquée est mémorisée (sessionStorage) ; chaque page nomme sa photo
 *    au moment de partir (pageswap) ou d'arriver (pagereveal). Si l'une des
 *    deux pages n'a pas cet appareil, la transition est sautée : toute autre
 *    navigation reste instantanée, comme avant.
 *
 * 2. Dans la page : VH.viewMorph.swap({ root, update }) — les éléments
 *    [data-morph-id] visibles glissent de leur ancienne place à la
 *    nouvelle (bascule grille/liste, filtres et pages du hangar, filtres de
 *    la frise, tri des favoris) ; option `slots` : squelettes → cartes.
 *    VH.viewMorph.run({ update, name }) : morphing libre (comparateur,
 *    étapes de connexion, onglets des réglages).
 *
 * Sans l'API (Firefox) ou en mouvement réduit : la mise à jour se fait
 * d'un coup, comme avant. Les noms de transition sont posés en CSSOM
 * (permis par la CSP) puis retirés à la fin. Durées et courbes :
 * bloc MORPHINGS de shared-base.css. */
(function () {
  window.VH = window.VH || {};

  var KEY = 'vh-morph';
  var PHOTO = 'vh-photo';

  function reduced() {
    return !!(window.VH.motion && window.VH.motion.prefersReducedMotion());
  }

  function readId() {
    try { return window.sessionStorage.getItem(KEY); } catch { return null; }
  }

  function writeId(id) {
    try { window.sessionStorage.setItem(KEY, String(id)); } catch { /* stockage bloqué : pas de morphing */ }
  }

  /** Id de la fiche affichée (/details/<slug>-<id> ou ?id=), sinon null. */
  function selfId(loc) {
    var l = loc || window.location;
    var m = /^\/details\/(?:.*-)?(\d+)\/?$/.exec(l.pathname || '');
    if (m) return m[1];
    if (!/^\/details\/?$/.test(l.pathname || '')) return null;
    var q = /[?&]id=(\d+)/.exec(l.search || '');
    return q ? q[1] : null;
  }

  function cssEscape(s) {
    return String(s).replace(/[^\w-]/g, '');
  }

  /** Photo de l'appareil `id` dans la page (carte ou hero de la fiche). */
  function photoFor(id, doc) {
    var d = doc || document;
    if (!id) return null;
    var item = d.querySelector('[data-morph-id="' + cssEscape(id) + '"]');
    if (!item && selfId() === String(id)) item = d.querySelector('[data-morph-self]');
    if (!item) return null;
    var photo = item.matches('[data-morph="photo"]') ? item : item.querySelector('[data-morph="photo"]');
    if (!photo || !photo.getClientRects().length) return null;
    // Sur une carte, seule l'image vole : les pastilles posées dessus
    // (génération, type) ne doivent pas grossir avec elle. Le hero de la
    // fiche, lui, est nommé tel quel (en CSS).
    var img = item.hasAttribute('data-morph-self') ? null : photo.querySelector('img');
    return img && img.getClientRects().length ? img : photo;
  }

  function setName(el, name) {
    el.style.viewTransitionName = name;
  }

  function clearName(el) {
    el.style.viewTransitionName = '';
    el.style.removeProperty('view-transition-class');
  }

  /* ---------- 1. D'une page à l'autre ---------- */

  function onCardClick(e) {
    if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
    var link = e.target.closest && e.target.closest('a[href]');
    if (!link) return;
    var item = link.closest('[data-morph-id]');
    if (item) writeId(item.getAttribute('data-morph-id'));
  }

  /** Nomme la photo de l'appareil mémorisé ; sinon saute la transition.
   * Sur une fiche, le hero porte vh-photo en CSS : si la photo à nommer
   * est une autre (carte de la filiation), le hero est retiré de la
   * transition — deux éléments au même nom l'annuleraient. */
  function nameOrSkip(vt) {
    var photo = reduced() ? null : photoFor(readId());
    if (!photo) {
      vt.skipTransition();
      return;
    }
    var self = document.querySelector('[data-morph-self] [data-morph="photo"]');
    var muted = self && self !== photo ? self : null;
    if (muted) muted.style.viewTransitionName = 'none';
    setName(photo, PHOTO);
    // finished ne rejette pas sur une transition sautée ; le catch évite
    // seulement un rejet non traité si le navigateur l'interrompt.
    vt.finished.catch(function () {}).then(function () {
      clearName(photo);
      if (muted) clearName(muted);
    });
  }

  /* La page de départ décide (elle est entièrement chargée ; celle
   * d'arrivée peut s'afficher avant ses scripts différés) : morphing vers
   * la fiche de la carte cliquée, ou retour arrière / avant dans
   * l'historique ; toute autre navigation reste instantanée. Vers une
   * fiche, la destination doit être l'appareil mémorisé : la photo du hero
   * est nommée en CSS (details.css), sans attendre les scripts. */
  function onPageSwap(e) {
    var vt = e.viewTransition;
    if (!vt) return;
    var id = readId();
    var act = e.activation;
    var destId = null;
    try { destId = act && act.entry && act.entry.url ? selfId(new URL(act.entry.url)) : null; } catch { destId = null; }
    var traverse = !!(act && act.navigationType === 'traverse');
    if (!id || (destId ? destId !== String(id) : !traverse)) {
      vt.skipTransition();
      return;
    }
    nameOrSkip(vt);
  }

  function onPageReveal(e) {
    if (e.viewTransition) nameOrSkip(e.viewTransition);
  }

  /* ---------- 2. Dans la page ---------- */

  function inView(el) {
    var r = el.getBoundingClientRect();
    var h = window.innerHeight || document.documentElement.clientHeight;
    return r.bottom > -h * 0.25 && r.top < h * 1.25 && r.width > 0;
  }

  /**
   * Morphing libre dans la page : `name()` désigne les éléments à nommer,
   * appelée AVANT et APRÈS `update()`. Un même nom des deux côtés = l'élément
   * glisse et se transforme (taille, place) ; un nom d'un seul côté = entrée
   * ou sortie (classe `className`, CSS de shared-morph.css). Deux éléments
   * présents au même nom dans un même état annuleraient la transition.
   * @param {{ update: () => void, name?: () => Array<[Element, string]>,
   *           className?: string, rootClass?: string }} opts
   *   rootClass : classe(s) posée(s) sur <html> pendant la transition (sens, variante),
   *   séparées par des espaces.
   * @returns {Promise<void>} résolue une fois la mise à jour faite
   */
  function run(opts) {
    var update = opts && opts.update;
    if (typeof update !== 'function') return Promise.resolve();
    if (typeof document.startViewTransition !== 'function' || reduced() || document.hidden) {
      update();
      return Promise.resolve();
    }
    var named = [];
    var pick = typeof opts.name === 'function' ? opts.name : function () { return []; };
    var apply = function () {
      pick().forEach(function (pair) {
        var el = pair && pair[0];
        if (!el || !pair[1]) return;
        setName(el, pair[1]);
        if (opts.className) el.style.setProperty('view-transition-class', opts.className);
        named.push(el);
      });
    };
    apply();
    var html = document.documentElement;
    var classes = String(opts.rootClass || '').split(/\s+/).filter(Boolean);
    classes.forEach(function (c) { html.classList.add(c); });
    var vt = document.startViewTransition(function () {
      update();
      apply();
    });
    // Une erreur de update() remonte par updateCallbackDone (renvoyée à
    // l'appelant) ; finished la répète, d'où le catch ici.
    vt.finished.catch(function () {}).then(function () {
      named.forEach(clearName);
      classes.forEach(function (c) { html.classList.remove(c); });
    });
    return vt.updateCallbackDone;
  }

  // Seuls les éléments visibles (à un quart d'écran près) sont nommés :
  // des centaines de noms alourdiraient la capture pour rien.
  function visibleItems(root, selector) {
    var out = [];
    var items = root.querySelectorAll(selector);
    for (var i = 0; i < items.length; i++) if (inView(items[i])) out.push(items[i]);
    return out;
  }

  function idNames(root) {
    var used = Object.create(null);
    return visibleItems(root, '[data-morph-id]').reduce(function (acc, el) {
      var id = el.getAttribute('data-morph-id');
      if (id && !used[id]) {
        used[id] = true;
        acc.push([el, 'vh-m-' + cssEscape(id)]);
      }
      return acc;
    }, []);
  }

  /** Emplacements : le n-ième élément avant devient le n-ième après
   * (squelette de chargement → carte). */
  function slotNames(root, selector) {
    return visibleItems(root, selector).map(function (el, i) { return [el, 'vh-slot-' + i]; });
  }

  /**
   * Les éléments [data-morph-id] visibles de `root` glissent de leur
   * ancienne place à la nouvelle ; ceux qui partent ou arrivent s'effacent
   * ou entrent. Avec `slots` (sélecteur), on apparie par position.
   * @param {{ root: Element|null, update: () => void, slots?: string, rootClass?: string }} opts
   * @returns {Promise<void>}
   */
  function swap(opts) {
    var root = opts && opts.root;
    var update = opts && opts.update;
    if (typeof update !== 'function') return Promise.resolve();
    if (!root) {
      update();
      return Promise.resolve();
    }
    return run({
      update: update,
      className: 'vh-morph',
      rootClass: opts.rootClass,
      name: function () { return opts.slots ? slotNames(root, opts.slots) : idNames(root); },
    });
  }

  document.addEventListener('click', onCardClick, true);
  window.addEventListener('pageswap', onPageSwap);
  window.addEventListener('pagereveal', onPageReveal);

  window.VH.viewMorph = { swap: swap, run: run, selfId: selfId, photoFor: photoFor };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.viewMorph;
  }
})();
