/* VH.confirmAction — confirmation sur place (v4.17.0).
 *
 * Remplace les window.confirm() et les actions destructrices « en un clic » :
 * le déclencheur ouvre à côté de lui un panneau « confirmer / annuler »
 * (shared-widgets.css, bloc CONFIRMATION SUR PLACE) : déclencheur et
 * panneau forment une tuile qui s'élargit, le plateau porte deux boutons
 * ronds à icône (libellés en nom accessible et en info-bulle). Seule la confirmation
 * appelle onConfirm — après l'animation propre au déclencheur (coche tracée
 * à la place de la poubelle…), dont la durée est lue sur le CSS.
 * La croix, un second clic sur le déclencheur, Échap, un clic ailleurs ou le
 * focus qui quitte le contrôle referment sans rien faire (data-settle, posé
 * le temps du repli : la tuile reste, la poubelle se tasse). Un seul panneau
 * ouvert à la fois.
 *
 *   VH.confirmAction.arm(trigger, {
 *     onConfirm,                // appelé après l'animation de l'état « done »
 *     labels: { group, confirm, cancel }, // textes ou fonctions (évaluées à l'ouverture)
 *     side: 'right' | 'left',   // côté où le panneau s'ouvre
 *     className: '',            // classe ajoutée à l'enveloppe (style de page)
 *     measure: '.selector',     // élément animé à l'état « done » (dans l'enveloppe)
 *     when: () => true,         // confirmation requise ? faux → le clic n'est pas
 *                               // intercepté (ex. cœur de la fiche : l'ajout se
 *                               // fait d'un clic, seul le retrait se confirme)
 *   })
 */
(function () {
  window.VH = window.VH || {};

  var openControl = null;
  var uid = 0;

  /* Libellés à rafraîchir quand la langue est prête ou change : armés avant
   * le chargement des traductions, ils porteraient la clé brute — et le
   * panneau, la largeur de celle-ci (sa place est réservée sur la fiche).
   * Un seul écouteur pour tous les contrôles ; ceux sortis du DOM
   * (liste d'utilisateurs re-rendue) sont oubliés au passage. */
  var relabelers = [];
  function relabelAll() {
    relabelers = relabelers.filter(function (r) { return r.wrap.isConnected; });
    relabelers.forEach(function (r) { r.apply(); });
  }
  window.addEventListener('i18nReady', relabelAll);
  window.addEventListener('langChanged', relabelAll);

  function button(cls, icon) {
    return '<button type="button" class="' + cls + '">' +
      '<i class="fas fa-' + icon + '" aria-hidden="true"></i></button>';
  }

  /* Poubelle dessinée (couvercle, cuve, coche : trois tracés animés
   * séparément, CSS « POUBELLE » de shared-widgets). Le couvercle bascule
   * vers le côté où s'ouvre le panneau ; à la confirmation,
   * couvercle et cuve s'effacent et la coche se trace (measure: '.cfm-bin-check').
   * Balisage statique, sans donnée saisie. */
  var BIN_SVG =
    '<svg class="cfm-bin" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
    '<g class="cfm-bin-lid"><path d="M4.5 7h15"/><path d="M9.5 7V5.2c0-.7.5-1.2 1.2-1.2h2.6c.7 0 1.2.5 1.2 1.2V7"/></g>' +
    '<g class="cfm-bin-can"><path d="M6.5 7.5l.9 11.2c.1 1 .9 1.8 1.9 1.8h5.4c1 0 1.8-.8 1.9-1.8l.9-11.2"/><path d="M10.2 11v5.5M13.8 11v5.5"/></g>' +
    '<path class="cfm-bin-check" pathLength="20" d="M6.5 12.5l3.6 3.6 7.4-7.6"/>' +
    '</svg>';

  /**
   * Balisage de la poubelle, pour un gabarit HTML (carte de favori, cœur de
   * la fiche). Seule source du dessin.
   * @param {string} [extraClass] classe fixe ajoutée au <svg>, jamais une donnée
   * @returns {string}
   */
  function binMarkup(extraClass) {
    return extraClass ? BIN_SVG.replace('class="cfm-bin"', 'class="cfm-bin ' + extraClass + '"') : BIN_SVG;
  }

  /** Nœud SVG de la poubelle, à poser dans un déclencheur. */
  function binIcon() {
    var holder = document.createElement('span');
    holder.innerHTML = binMarkup();
    return holder.firstChild;
  }

  /**
   * @param {HTMLElement|null} trigger
   * @param {{ onConfirm: () => void, labels: { group: string, confirm: string, cancel: string },
   *           side?: 'left'|'right', className?: string, measure?: string,
   *           when?: () => boolean }} opts
   */
  function arm(trigger, opts) {
    if (!trigger || !trigger.parentNode || trigger.dataset.cfmArmed) return null;
    trigger.dataset.cfmArmed = '1';
    var o = opts || {};
    var labels = o.labels || {};

    var wrap = document.createElement('span');
    wrap.className = 'cfm' + (o.className ? ' ' + o.className : '');
    wrap.dataset.state = 'idle';
    wrap.dataset.side = o.side === 'left' ? 'left' : 'right';
    trigger.parentNode.insertBefore(wrap, trigger);
    wrap.appendChild(trigger);

    var panel = document.createElement('span');
    panel.className = 'cfm-panel';
    panel.id = 'cfm-' + (++uid);
    panel.setAttribute('role', 'group');
    // labels.group peut être une fonction : évaluée à l'ouverture (ex. le nom
    // d'une fiche chargée après l'armement du bouton).
    // Tous les libellés peuvent être des fonctions, évaluées à l'ouverture :
    // donnée chargée après l'armement, langue pas encore prête, changement
    // de langue sans rechargement.
    function label(key) {
      var v = labels[key];
      return typeof v === 'function' ? v() : (v || '');
    }
    function applyLabels() {
      panel.setAttribute('aria-label', label('group'));
      [[yes, 'confirm'], [no, 'cancel']].forEach(function (pair) {
        var text = label(pair[1]);
        pair[0].setAttribute('aria-label', text);
        pair[0].title = text;
      });
    }
    panel.setAttribute('inert', '');
    // .cfm-clip rogne le plateau pendant que le panneau s'élargit.
    panel.innerHTML = '<span class="cfm-clip"><span class="cfm-tray">' +
      button('cfm-yes', 'check') + button('cfm-no', 'times') + '</span></span>';
    wrap.appendChild(panel);
    trigger.setAttribute('aria-expanded', 'false');
    trigger.setAttribute('aria-controls', panel.id);

    var yes = panel.querySelector('.cfm-yes');
    var no = panel.querySelector('.cfm-no');
    applyLabels();
    relabelers.push({ wrap: wrap, apply: applyLabels });
    var state = function () { return wrap.dataset.state; };
    var settleTimer = null;

    function setState(next) {
      wrap.dataset.state = next;
      clearTimeout(settleTimer);
      delete wrap.dataset.settle;
      trigger.setAttribute('aria-expanded', next === 'confirm' ? 'true' : 'false');
      if (next === 'confirm') panel.removeAttribute('inert');
      else panel.setAttribute('inert', '');
    }

    function onOutside(e) {
      if (!wrap.contains(e.target)) control.cancel(false);
    }

    function release() {
      document.removeEventListener('pointerdown', onOutside, true);
      if (openControl === control) openControl = null;
    }

    var control = {
      wrap: wrap,
      open: function () {
        if (state() !== 'idle') return;
        if (openControl && openControl !== control) openControl.cancel(false);
        applyLabels();
        setState('confirm');
        openControl = control;
        document.addEventListener('pointerdown', onOutside, true);
        // Focus sur l'action la MOINS destructrice (APG) : un appui prolongé
        // sur Entrée ou Espace (répétition) ou une double frappe ne doit pas
        // confirmer à la place de l'utilisateur.
        no.focus();
      },
      cancel: function (refocus) {
        if (state() !== 'confirm') return;
        // Retour au repos D'ABORD : le panneau devient inerte, puis le focus
        // revient au déclencheur — sans passer par l'annulation de focusout
        // (état idle).
        setState('idle');
        // Repli : la tuile garde la teinte du déclencheur jusqu'à ce que le
        // panneau soit refermé (durée lue sur le CSS), puis s'efface.
        wrap.dataset.settle = '';
        var motion = window.VH.motion;
        var ms = motion && !motion.prefersReducedMotion() ? motion.exitDuration(panel) : 0;
        settleTimer = setTimeout(function () { delete wrap.dataset.settle; }, ms + 40);
        release();
        if (refocus) trigger.focus();
      },
      confirm: function () {
        if (state() !== 'confirm') return;
        trigger.focus();
        setState('done');
        release();
        var target = o.measure ? wrap.querySelector(o.measure) : null;
        var ms = target ? window.VH.motion.exitDuration(target) : 0;
        if (ms > 0 && !window.VH.motion.prefersReducedMotion()) setTimeout(o.onConfirm, ms + 40);
        else if (typeof o.onConfirm === 'function') o.onConfirm();
      },
      /** Revenir au repos après une action qui a échoué (le contrôle reste). */
      reset: function () {
        release();
        setState('idle');
      }
    };

    // Le déclencheur peut vivre dans un lien étendu (carte) : rien ne remonte.
    wrap.addEventListener('click', function (e) { e.stopPropagation(); });
    trigger.addEventListener('click', function (e) {
      if (state() === 'idle' && typeof o.when === 'function' && !o.when()) return;
      e.preventDefault();
      if (state() === 'idle') control.open();
      else control.cancel(true);
    });
    yes.addEventListener('click', control.confirm);
    no.addEventListener('click', function () { control.cancel(true); });
    wrap.addEventListener('keydown', function (e) {
      if (e.key !== 'Escape' || state() !== 'confirm') return;
      e.preventDefault();
      e.stopPropagation();
      control.cancel(true);
    });
    wrap.addEventListener('focusout', function (e) {
      if (state() === 'confirm' && e.relatedTarget && !wrap.contains(e.relatedTarget)) control.cancel(false);
    });

    return control;
  }

  window.VH.confirmAction = { arm: arm, binIcon: binIcon, binMarkup: binMarkup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.confirmAction;
  }
})();
