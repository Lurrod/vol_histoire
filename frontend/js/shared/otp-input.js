/* ======================================================================
   VOL D'HISTOIRE — CHAMP DE CODE À USAGE UNIQUE (VH.otpInput)
   Le code reçu par email (activation, mot de passe oublié, changement
   d'adresse) se saisit dans une rangée de cases. Écrit pour le site d'après
   le comportement de l'« OTP input » de Rare UI (aucun code repris) : un
   curseur glisse de case en case, chaque chiffre monte dans sa case, un
   contour vert se trace case après case en cas de succès, la rangée passe
   au rouge et tremble une fois en cas d'erreur.

   Un seul vrai <input> (transparent, posé sur les cases) porte la saisie :
   clavier, collage, remplissage automatique du code reçu par SMS ou email
   (autocomplete="one-time-code") et lecteurs d'écran fonctionnent comme
   pour un champ ordinaire. Les cases ne sont qu'un affichage (aria-hidden).

   VH.otpInput.create(root, { length, label, onChange, onComplete })
     → { value(), setStatus('idle'|'success'|'error'), clear(), focus(),
         setDisabled(bool) }
   ====================================================================== */
(function () {
  'use strict';

  window.VH = window.VH || {};

  var DIGIT = /^[0-9]$/;

  function digitsOf(text) {
    return String(text || '').replace(/\D/g, '');
  }

  /**
   * @param {HTMLElement} root conteneur vide
   * @param {{ length?: number, label?: string, describedBy?: string,
   *   onChange?: (v: string) => void, onComplete?: (v: string) => void }} [opts]
   */
  function create(root, opts) {
    var options = opts || {};
    var length = options.length || 6;
    var chars = new Array(length).fill('');
    var active = 0;
    var status = 'idle';

    root.classList.add('otp');
    root.innerHTML = '';

    var input = document.createElement('input');
    input.className = 'otp-input';
    input.type = 'text';
    input.inputMode = 'numeric';
    input.autocomplete = 'one-time-code';
    input.maxLength = length;
    input.spellcheck = false;
    input.setAttribute('pattern', '[0-9]*');
    input.setAttribute('aria-label', options.label || 'Code');
    if (options.describedBy) input.setAttribute('aria-describedby', options.describedBy);

    var row = document.createElement('div');
    row.className = 'otp-row';
    row.setAttribute('aria-hidden', 'true');

    var slots = [];
    for (var i = 0; i < length; i++) {
      var slot = document.createElement('span');
      slot.className = 'otp-slot';
      slot.style.setProperty('--otp-i', String(i));
      // Masque des chiffres (ils montent de dessous) et contour du succès :
      // un tracé SVG qui se dessine (pathLength = 1), hors du masque pour
      // couvrir toute la bordure.
      slot.innerHTML = '<span class="otp-mask"></span><svg class="otp-ring" aria-hidden="true" focusable="false">' +
        '<rect x="1" y="1" rx="7" ry="7" pathLength="1"></rect></svg>';
      row.appendChild(slot);
      slots.push(slot);
    }

    // Curseur : un seul cadre qui glisse sur la case active.
    var caret = document.createElement('span');
    caret.className = 'otp-caret';
    caret.innerHTML = '<span class="otp-caret-bar"></span>';
    row.appendChild(caret);

    root.appendChild(row);
    root.appendChild(input);

    function value() { return chars.join(''); }

    function placeCaret() {
      var slot = slots[active];
      caret.style.setProperty('--otp-x', slot.offsetLeft + 'px');
      caret.classList.toggle('is-empty', !chars[active]);
    }

    function setChar(index, ch) {
      var slot = slots[index];
      var old = slot.querySelector('.otp-char:not(.is-out)');
      if (old) {
        old.classList.add('is-out');
        // Retrait après l'animation de sortie (durée lue sur le CSS).
        window.VH.motion.exit(old, function () { old.remove(); }, { className: 'is-out' });
      }
      chars[index] = ch;
      slot.classList.toggle('is-filled', !!ch);
      if (ch) {
        var span = document.createElement('span');
        span.className = 'otp-char';
        span.textContent = ch;
        slot.querySelector('.otp-mask').appendChild(span);
      }
    }

    function sync() {
      input.value = value();
      placeCaret();
      if (options.onChange) options.onChange(value());
      if (value().length === length && chars.every(Boolean) && options.onComplete) {
        options.onComplete(value());
      }
    }

    /** Toute modification du code repart de l'état neutre. */
    function touch() {
      if (status !== 'idle') setStatus('idle');
    }

    /** Remplit à partir d'une position (collage, remplissage automatique). */
    function fill(text, from) {
      var digits = digitsOf(text).slice(0, length);
      if (!digits) return;
      touch();
      var start = digits.length === length ? 0 : from;
      for (var k = 0; k < digits.length && start + k < length; k++) setChar(start + k, digits[k]);
      active = Math.min(start + digits.length, length - 1);
      sync();
    }

    function move(to) {
      active = Math.max(0, Math.min(length - 1, to));
      placeCaret();
    }

    input.addEventListener('keydown', function (e) {
      if (input.disabled || e.ctrlKey || e.metaKey || e.altKey) return;
      if (DIGIT.test(e.key)) {
        e.preventDefault();
        touch();
        setChar(active, e.key);
        if (active < length - 1) active += 1;
        sync();
      } else if (e.key === 'Backspace') {
        e.preventDefault();
        touch();
        // La case active est effacée sur place ; vide, on recule d'abord.
        if (!chars[active] && active > 0) active -= 1;
        setChar(active, '');
        sync();
      } else if (e.key === 'Delete') {
        e.preventDefault();
        touch();
        setChar(active, '');
        sync();
      } else if (e.key === 'ArrowLeft') {
        e.preventDefault();
        move(active - 1);
      } else if (e.key === 'ArrowRight') {
        e.preventDefault();
        move(active + 1);
      } else if (e.key === 'Home') {
        e.preventDefault();
        move(0);
      } else if (e.key === 'End') {
        e.preventDefault();
        move(chars.indexOf('') === -1 ? length - 1 : chars.indexOf(''));
      }
    });

    // Claviers virtuels (Android envoie souvent keyCode 229 sans touche) et
    // remplissage automatique : le texte arrive par « input ».
    input.addEventListener('input', function () {
      var typed = digitsOf(input.value);
      if (typed === value()) return;
      if (typed.length > value().length) fill(typed.length >= length ? typed : typed.slice(-1), typed.length >= length ? 0 : active);
      else sync();
    });

    input.addEventListener('paste', function (e) {
      e.preventDefault();
      var text = (e.clipboardData || window.clipboardData).getData('text');
      fill(text, active);
    });

    input.addEventListener('focus', function () {
      root.classList.add('is-focused');
      // Le curseur se pose sur la première case vide.
      var firstEmpty = chars.indexOf('');
      move(firstEmpty === -1 ? length - 1 : firstEmpty);
    });
    input.addEventListener('blur', function () { root.classList.remove('is-focused'); });

    // Un clic sur une case y pose le curseur ; entre deux cases, le focus
    // seul (curseur sur la première case vide).
    row.addEventListener('mousedown', function (e) {
      if (input.disabled) return;
      e.preventDefault();
      input.focus();
      var slot = e.target.closest && e.target.closest('.otp-slot');
      if (slot) move(slots.indexOf(slot));
    });

    /** @param {'idle'|'success'|'error'} next */
    function setStatus(next) {
      status = next;
      root.classList.remove('is-success', 'is-error');
      if (next === 'success') root.classList.add('is-success');
      if (next === 'error') {
        void root.offsetWidth; // rejoue la secousse à chaque erreur
        root.classList.add('is-error');
      }
      input.setAttribute('aria-invalid', String(next === 'error'));
    }

    function clear() {
      for (var j = 0; j < length; j++) if (chars[j]) setChar(j, '');
      active = 0;
      setStatus('idle');
      input.value = '';
      placeCaret();
    }

    function setDisabled(disabled) {
      input.disabled = !!disabled;
      root.classList.toggle('is-disabled', !!disabled);
    }

    placeCaret();

    return {
      value: value,
      setStatus: setStatus,
      clear: clear,
      focus: function () { input.focus({ preventScroll: true }); },
      setDisabled: setDisabled,
      input: input,
    };
  }

  var api = { create: create, digitsOf: digitsOf };
  window.VH.otpInput = api;
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
})();
