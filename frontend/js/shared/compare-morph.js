/* ======================================================================
   COMPARATEUR — morphings (API View Transitions, via VH.viewMorph.run).

   1. Carte ↔ barre : la photo de la carte cochée (ou du hero de la fiche)
      vole jusqu'à sa vignette dans la barre ; décochée, la vignette revient
      à la photo si elle est à l'écran, sinon elle s'efface. Les autres
      vignettes glissent à leur nouvelle place.
   2. Barre ↔ modale : la barre s'agrandit en modale, la modale se replie
      dans la barre à la fermeture.
   3. Retrait d'une colonne de la modale : les colonnes restantes glissent
      à leur nouvelle place au lieu de sauter.

   Sans l'API (Firefox), en mouvement réduit ou onglet caché, VH.viewMorph
   fait la mise à jour d'un coup. Styles des pseudo-éléments : compare.css
   (bloc MORPHINGS DU COMPARATEUR).
   ====================================================================== */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  const PANEL = 'vh-cmp-panel';
  // Vignette d'arrivée : on attend son décodage au plus ce délai avant de
  // lancer la transition (au-delà, la photo de départ la couvre de toute façon).
  const DECODE_WAIT_MS = 120;

  function viewMorph() { return window.VH.viewMorph || null; }

  function reduced() {
    const m = window.VH.motion;
    return !!(m && typeof m.prefersReducedMotion === 'function' && m.prefersReducedMotion());
  }

  /** Le navigateur jouera-t-il vraiment une transition ? */
  function canMorph() {
    return !!viewMorph() && typeof document.startViewTransition === 'function' &&
      !document.hidden && !reduced();
  }

  function run(opts) {
    const vm = viewMorph();
    if (vm && typeof vm.run === 'function') return vm.run(opts);
    opts.update();
    return Promise.resolve();
  }

  function ident(id) { return String(id).replace(/[^\w-]/g, ''); }
  function thumbName(id) { return 'vh-cmp-' + ident(id); }

  function inViewport(el) {
    const r = el.getBoundingClientRect();
    const h = window.innerHeight || document.documentElement.clientHeight;
    const w = window.innerWidth || document.documentElement.clientWidth;
    return r.width > 0 && r.height > 0 && r.bottom > 0 && r.top < h && r.right > 0 && r.left < w;
  }

  /** Photo de l'appareil visible à l'écran (carte, hero de la fiche), ou null. */
  function photoOnScreen(id) {
    const vm = viewMorph();
    const el = vm && typeof vm.photoFor === 'function' ? vm.photoFor(String(id)) : null;
    return el && inViewport(el) ? el : null;
  }

  function thumbsOf(bar) {
    return Array.from(bar.querySelectorAll('[data-cmp-thumb]'));
  }

  /** Décode l'image `src` (déjà en cache : celle de la carte) avant la
   * capture ; jamais plus de DECODE_WAIT_MS. */
  function decoded(src) {
    if (!src || typeof Image !== 'function') return Promise.resolve();
    const probe = new Image();
    probe.src = src;
    if (typeof probe.decode !== 'function') return Promise.resolve();
    return Promise.race([
      probe.decode().catch(() => {}),
      new Promise((resolve) => { setTimeout(resolve, DECODE_WAIT_MS); }),
    ]);
  }

  /**
   * Carte ↔ barre. `update` redessine la barre (vignettes comprises).
   * Ajout : la photo porte le nom de la vignette AVANT la mise à jour, puis
   * « none » (elle reste en place pendant que sa copie vole). Retrait : la
   * vignette porte son nom avant, la photo (« none » avant) le reprend après.
   * @param {{ bar: Element, id: number, dir: 'add'|'remove', update: () => void,
   *           preload?: string|null }} opts
   * @returns {Promise<void>}
   */
  function bar(opts) {
    if (!canMorph()) {
      opts.update();
      return Promise.resolve();
    }
    const adding = opts.dir === 'add';
    const own = thumbName(opts.id);
    const start = () => {
      const photo = photoOnScreen(opts.id);
      let after = false;
      return run({
        update: opts.update,
        className: 'vh-cmp-thumb',
        rootClass: adding ? 'vh-cmp-adding' : 'vh-cmp-removing',
        name() {
          const pairs = thumbsOf(opts.bar).map((el) => [el, thumbName(el.getAttribute('data-cmp-thumb'))]);
          // « none » de l'autre côté : sur une fiche, le cadre du hero porte
          // vh-photo en CSS ; présent d'un seul côté, il ferait un groupe
          // orphelin (shared-morph.css) qui masquerait la vignette.
          if (photo) pairs.push([photo, adding === after ? 'none' : own]);
          after = true;
          return pairs;
        },
      });
    };
    return adding && opts.preload ? decoded(opts.preload).then(start) : start();
  }

  /**
   * Barre ↔ modale : `from` porte le nom avant la mise à jour, `to` après
   * (et `from` passe à « none » : deux éléments du même nom annuleraient
   * la transition).
   * @param {{ from: Element, to: Element, update: () => void }} opts
   * @returns {Promise<void>}
   */
  function panel(opts) {
    let after = false;
    return run({
      update: opts.update,
      name() {
        const pairs = after ? [[opts.from, 'none'], [opts.to, PANEL]] : [[opts.from, PANEL]];
        after = true;
        return pairs;
      },
    });
  }

  function within(r, box) {
    return r.width > 0 && r.top >= box.top - 1 && r.bottom <= box.bottom + 1 &&
      r.left >= box.left - 1 && r.right <= box.right + 1;
  }

  /* En-tête et cellules d'une colonne, nommés « vh-cmp-col-<id>-<rang> ».
   * Seuls les éléments entièrement visibles dans le corps défilant de la
   * modale sont nommés : un élément nommé échappe au rognage de son
   * conteneur et volerait par-dessus le voile. Le rang est compté sur tous
   * les éléments, pour qu'une même cellule garde son nom après le rendu. */
  function columnNames(body, all) {
    const box = body.getBoundingClientRect();
    const rank = Object.create(null);
    const out = [];
    body.querySelectorAll('[data-cmp-id]').forEach((el) => {
      const id = ident(el.getAttribute('data-cmp-id'));
      rank[id] = (rank[id] || 0) + 1;
      if (all || within(el.getBoundingClientRect(), box)) out.push([el, 'vh-cmp-col-' + id + '-' + rank[id]]);
    });
    return out;
  }

  /* Groupes imbriqués (view-transition-group) : les cellules nommées restent
   * rognées au corps de la modale, nommé lui aussi. On peut alors nommer
   * toutes les cellules, même à demi visibles — sinon une colonne élargie,
   * trop haute pour tenir dans le corps, n'était pas nommée après le retrait
   * et apparaissait d'un coup sous les anciennes cellules. */
  function nestedGroups() {
    const css = window.CSS;
    return !!(css && typeof css.supports === 'function' && css.supports('view-transition-group', 'nearest'));
  }

  /**
   * Retrait d'une colonne : la colonne retirée s'efface, les autres glissent.
   * @param {{ body: Element, update: () => void }} opts
   * @returns {Promise<void>}
   */
  function columns(opts) {
    const nested = nestedGroups();
    return run({
      update: opts.update,
      className: 'vh-cmp-col',
      // vh-cmp-nest : les cellules se rattachent au groupe du corps (compare.css).
      rootClass: nested ? 'vh-cmp-nest' : '',
      name: () => (nested
        ? [[opts.body, 'vh-cmp-body']].concat(columnNames(opts.body, true))
        : columnNames(opts.body)),
    });
  }

  VH.shared.compareMorph = { canMorph, bar, panel, columns, columnNames, nestedGroups, photoOnScreen };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.compareMorph;
  }
})();
