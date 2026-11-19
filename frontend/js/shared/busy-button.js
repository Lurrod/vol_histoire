/* VH.busyButton — bouton d'envoi : attente puis succès, sur place (2026-11-19).
 *
 * Avant : le contenu du bouton était remplacé par un indicateur de
 * chargement — le bouton se resserrait d'un coup à la largeur de
 * l'indicateur, et la réussite n'était dite que par un toast.
 * Désormais (CSS « BOUTON D'ENVOI » de shared-base) :
 *   start(btn)            largeur figée, le libellé monte et s'efface,
 *                         l'anneau de chargement apparaît à sa place ;
 *   succeed(btn, {label}) l'anneau laisse place à une coche tracée et à
 *                         « Enregistré », puis le libellé revient ;
 *   stop(btn)             retour immédiat au repos (échec, abandon).
 * Le libellé reste dans le bouton (lu par les lecteurs d'écran) ; aria-busy
 * signale l'attente. Le retour au repos après la coche est différé d'une
 * durée de lecture (HOLD_MS), pas d'une durée d'animation. */
(function () {
  window.VH = window.VH || {};

  var HOLD_MS = 1600;
  var timers = new WeakMap();

  function ensureParts(btn) {
    if (btn.querySelector(':scope > .bb-label')) return;
    var label = document.createElement('span');
    label.className = 'bb-label';
    while (btn.firstChild) label.appendChild(btn.firstChild);
    btn.appendChild(label);
    var spin = document.createElement('span');
    spin.className = 'bb-spin';
    spin.setAttribute('aria-hidden', 'true');
    btn.appendChild(spin);
    var done = document.createElement('span');
    done.className = 'bb-done';
    done.setAttribute('aria-hidden', 'true');
    done.innerHTML = '<svg class="bb-check" viewBox="0 0 24 24" focusable="false">' +
      '<path pathLength="20" d="M5.5 12.5l4.2 4.2L18.5 7.5"/></svg><span class="bb-done-text"></span>';
    btn.appendChild(done);
    btn.classList.add('bb');
  }

  function clearTimer(btn) {
    var id = timers.get(btn);
    if (id) { clearTimeout(id); timers.delete(btn); }
  }

  /** @param {HTMLButtonElement|null} btn */
  function start(btn) {
    if (!btn) return;
    clearTimer(btn);
    ensureParts(btn);
    // Largeur figée avant tout changement : le bouton ne bouge pas.
    if (!btn.style.width) btn.style.width = btn.getBoundingClientRect().width + 'px';
    btn.disabled = true;
    btn.setAttribute('aria-busy', 'true');
    btn.dataset.bb = 'busy';
  }

  /** @param {HTMLButtonElement|null} btn */
  function stop(btn) {
    if (!btn) return;
    clearTimer(btn);
    btn.disabled = false;
    btn.removeAttribute('aria-busy');
    delete btn.dataset.bb;
    btn.style.width = '';
  }

  /**
   * @param {HTMLButtonElement|null} btn
   * @param {{ label?: string, hold?: number }} [opts]
   * @returns {Promise<void>} résolue au retour au repos
   */
  function succeed(btn, opts) {
    if (!btn) return Promise.resolve();
    var o = opts || {};
    ensureParts(btn);
    clearTimer(btn);
    if (!btn.style.width) btn.style.width = btn.getBoundingClientRect().width + 'px';
    btn.querySelector('.bb-done-text').textContent = o.label || '';
    btn.removeAttribute('aria-busy');
    btn.disabled = true;
    btn.dataset.bb = 'done';
    return new Promise(function (resolve) {
      timers.set(btn, setTimeout(function () {
        timers.delete(btn);
        stop(btn);
        resolve();
      }, o.hold == null ? HOLD_MS : o.hold));
    });
  }

  window.VH.busyButton = { start: start, stop: stop, succeed: succeed, HOLD_MS: HOLD_MS };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.busyButton;
  }
})();
