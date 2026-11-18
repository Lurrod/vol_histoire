/* VH.confirmAction — confirmation sur place (v4.17.0).
 *
 * Remplace les window.confirm() et les actions destructrices « en un clic » :
 * le déclencheur ouvre à côté de lui un panneau « confirmer / annuler »
 * (shared-base.css, bloc CONFIRMATION SUR PLACE). Seule la confirmation
 * appelle onConfirm — après l'animation propre au déclencheur (coche tracée
 * à la place de la poubelle…), dont la durée est lue sur le CSS.
 * La croix, un second clic sur le déclencheur, Échap, un clic ailleurs ou le
 * focus qui quitte le contrôle referment sans rien faire. Un seul panneau
 * ouvert à la fois sur la page.
 *
 *   VH.confirmAction.arm(trigger, {
 *     onConfirm,                // appelé après l'animation de l'état « done »
 *     labels: { group, confirm, cancel }, // textes ou fonctions (évaluées à l'ouverture)
 *     showText: false,          // libellés visibles dans les boutons
 *     side: 'right' | 'left',   // côté où le panneau s'ouvre
 *     className: '',            // classe ajoutée à l'enveloppe (style de page)
 *     measure: '.selector',     // élément animé à l'état « done » (dans l'enveloppe)
 *     morph: false,             // le déclencheur se transforme sur place, depuis
 *                               // son centre, en la paire (CSS .cfm-morph)
 *     when: () => true,         // confirmation requise ? faux → le clic n'est pas
 *                               // intercepté (ex. cœur de la fiche : l'ajout se
 *                               // fait d'un clic, seul le retrait se confirme)
 *   })
 */
(function () {
  window.VH = window.VH || {};

  var openControl = null;
  var uid = 0;

  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function button(cls, icon, label, showText) {
    return '<button type="button" class="' + cls + '" aria-label="' + esc(label) + '">' +
      '<i class="fas fa-' + icon + '" aria-hidden="true"></i>' +
      (showText ? '<span class="cfm-text">' + esc(label) + '</span>' : '') +
      '</button>';
  }

  /* Morphing (option morph, CSS .cfm-morph de shared-base) : l'enveloppe
   * passe de la largeur du déclencheur à celle de la paire, et retour. Les
   * deux largeurs ne sont connues qu'à l'exécution (libellés traduits) :
   * mesurées à chaque changement d'état, posées en CSSOM (permis par la
   * CSP), puis rendues à `auto` au repos. */
  function morphWidth(wrap, trigger, panel) {
    function setWidth(from, to) {
      // Même largeur (ex. coche tracée puis retour au repos) : aucune
      // transition, donc aucun transitionend pour rendre la main à `auto`.
      if (Math.round(from) === Math.round(to)) {
        wrap.style.width = wrap.dataset.state === 'idle' ? '' : to + 'px';
        return;
      }
      wrap.style.width = from + 'px';
      void wrap.offsetWidth; // point de départ de la transition
      wrap.style.width = to + 'px';
    }
    var last = wrap.dataset.state;
    new MutationObserver(function () {
      var state = wrap.dataset.state;
      if (state === last) return; // reset() d'un contrôle déjà au repos
      last = state;
      // Contrôle caché (ex. barre du comparateur vide) : rien à mesurer —
      // largeur naturelle, sinon un 0 px resterait figé (pas de transitionend).
      if (!wrap.offsetWidth && !trigger.offsetWidth) { wrap.style.width = ''; return; }
      // « done » : le déclencheur revient (coche tracée à sa place).
      if (state === 'confirm') setWidth(trigger.offsetWidth, panel.scrollWidth);
      else setWidth(wrap.offsetWidth, trigger.offsetWidth);
    }).observe(wrap, { attributes: true, attributeFilter: ['data-state'] });
    wrap.addEventListener('transitionend', function (e) {
      if (e.target === wrap && e.propertyName === 'width' && wrap.dataset.state === 'idle') {
        wrap.style.width = '';
      }
    });
  }

  /**
   * @param {HTMLElement|null} trigger
   * @param {{ onConfirm: () => void, labels: { group: string, confirm: string, cancel: string },
   *           showText?: boolean, side?: 'left'|'right', className?: string, measure?: string,
   *           when?: () => boolean, morph?: boolean }} opts
   */
  function arm(trigger, opts) {
    if (!trigger || !trigger.parentNode || trigger.dataset.cfmArmed) return null;
    trigger.dataset.cfmArmed = '1';
    var o = opts || {};
    var labels = o.labels || {};

    var wrap = document.createElement('span');
    wrap.className = 'cfm' + (o.morph ? ' cfm-morph' : '') + (o.className ? ' ' + o.className : '');
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
        var span = pair[0].querySelector('.cfm-text');
        if (span) span.textContent = text;
      });
    }
    panel.setAttribute('inert', '');
    panel.innerHTML = button('cfm-yes', 'check', '', o.showText) +
      button('cfm-no', 'times', '', o.showText);
    wrap.appendChild(panel);
    trigger.setAttribute('aria-expanded', 'false');
    trigger.setAttribute('aria-controls', panel.id);

    var yes = panel.querySelector('.cfm-yes');
    var no = panel.querySelector('.cfm-no');
    applyLabels();
    if (o.morph) morphWidth(wrap, trigger, panel);
    var state = function () { return wrap.dataset.state; };

    function setState(next) {
      wrap.dataset.state = next;
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
        // Retour au repos D'ABORD : un déclencheur replié (morphing, caché
        // pendant la confirmation) doit redevenir visible pour reprendre le
        // focus. Le panneau devient inerte, puis le focus revient au
        // déclencheur — sans passer par l'annulation de focusout (état idle).
        setState('idle');
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

  window.VH.confirmAction = { arm: arm };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.confirmAction;
  }
})();
