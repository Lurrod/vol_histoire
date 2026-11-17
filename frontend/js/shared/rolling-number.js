/* VH.rollingNumber — compteur « odomètre » (v4.17.0).
 *
 * Les stats du hero (hangar, favoris) recomptaient depuis zéro à chaque
 * changement de filtre (animateNumber). Ici chaque chiffre est une colonne
 * portant une bande « vide, 0…9 » ; changer de valeur ne fait que déplacer
 * la bande (data-d, transition CSS de shared-base.css) : 123 → 128 fait
 * glisser la seule colonne des unités, 99 → 100 en fait entrer une à gauche.
 *
 * Aucun style en ligne (CSP) : la position est portée par data-d.
 * Le nombre lisible est dans un .sr-only ; les colonnes sont aria-hidden.
 * Mouvements réduits : le garde-fou global ramène la transition à ~0. */
(function () {
  window.VH = window.VH || {};

  var BLANK = '';

  function currentLang(lang) {
    if (lang) return lang;
    var i18n = window.i18n;
    if (i18n && i18n.currentLang) return i18n.currentLang;
    return document.documentElement.lang || 'fr';
  }

  function format(value, lang) {
    try {
      return new Intl.NumberFormat(lang).format(value);
    } catch {
      return String(value);
    }
  }

  function isDigit(ch) { return ch >= '0' && ch <= '9'; }

  function makeColumn() {
    var col = document.createElement('span');
    col.className = 't-roll-col';
    col.dataset.d = BLANK;
    var strip = document.createElement('span');
    strip.className = 't-roll-strip';
    // Emplacement 0 : vide (colonne qui entre ou qui sort), puis 0 à 9.
    strip.appendChild(document.createElement('span'));
    for (var i = 0; i <= 9; i++) {
      var d = document.createElement('span');
      d.textContent = String(i);
      strip.appendChild(d);
    }
    col.appendChild(strip);
    return col;
  }

  function makeSeparator(ch) {
    var sep = document.createElement('span');
    sep.className = 't-roll-sep';
    sep.textContent = ch;
    return sep;
  }

  function init(el) {
    el.textContent = '';
    el.classList.add('t-roll');
    var sr = document.createElement('span');
    sr.className = 'sr-only';
    var cols = document.createElement('span');
    cols.className = 't-roll-cols';
    cols.setAttribute('aria-hidden', 'true');
    el.appendChild(sr);
    el.appendChild(cols);
  }

  // Une colonne qui sort se vide (sa bande remonte, sa largeur tombe à 0)
  // puis quitte le DOM une fois la transition jouée.
  // .is-leaving (posée par exit) l'écarte des emplacements pendant la sortie.
  function leave(col) {
    col.dataset.d = BLANK;
    window.VH.motion.exit(col, function () { col.remove(); }, {
      className: 'is-leaving',
      measure: col.querySelector('.t-roll-strip')
    });
  }

  /**
   * @param {Element|null} el     élément du nombre (ex. .data-number)
   * @param {number} value
   * @param {string} [lang]       langue de formatage (défaut : celle du site)
   */
  function set(el, value, lang) {
    if (!el || typeof value !== 'number' || !Number.isFinite(value)) return;
    if (!el.classList.contains('t-roll')) init(el);

    var text = format(value, currentLang(lang));
    var sr = el.querySelector('.sr-only');
    if (sr.textContent === text) return;
    sr.textContent = text;

    var box = el.querySelector('.t-roll-cols');
    var slots = Array.prototype.filter.call(box.children, function (n) {
      return !n.classList.contains('is-leaving');
    });
    var chars = text.split('');
    var pending = [];   // colonnes neuves : chiffre posé après un reflow
    var next = [];      // emplacements finaux, de gauche à droite

    // Rapprochement par la droite : les unités restent les unités.
    for (var i = 1; i <= chars.length; i++) {
      var ch = chars[chars.length - i];
      var slot = slots[slots.length - i];
      if (isDigit(ch)) {
        if (slot && slot.classList.contains('t-roll-col')) {
          slot.dataset.d = ch;
          next.unshift(slot);
        } else {
          var col = makeColumn();
          pending.push([col, ch]);
          next.unshift(col);
          if (slot) slot.remove();
        }
      } else if (slot && slot.classList.contains('t-roll-sep') && slot.textContent === ch) {
        next.unshift(slot);
      } else {
        next.unshift(makeSeparator(ch));
        if (slot) slot.remove();
      }
    }

    // Emplacements de tête en trop : les colonnes sortent, le reste part.
    var extra = slots.slice(0, Math.max(0, slots.length - chars.length));
    extra.forEach(function (s) {
      if (s.classList.contains('t-roll-col')) leave(s);
      else s.remove();
    });

    // Seuls les nœuds neufs entrent dans le DOM, de droite à gauche, chacun
    // devant son voisin de droite déjà en place. Une colonne conservée n'est
    // JAMAIS réinsérée : retirée puis remise, elle perdrait son style de
    // départ et sa bande sauterait à la valeur finale au lieu de glisser.
    // Les colonnes qui sortent restent en tête, devant les neuves.
    for (var j = next.length - 1; j >= 0; j--) {
      if (next[j].parentNode === box) continue;
      var right = next[j + 1];
      if (right) box.insertBefore(next[j], right);
      else box.appendChild(next[j]);
    }

    if (pending.length) {
      void box.offsetWidth; // reflow : les colonnes neuves partent du vide
      pending.forEach(function (p) { p[0].dataset.d = p[1]; });
    }
  }

  window.VH.rollingNumber = { set: set };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.rollingNumber;
  }
})();
