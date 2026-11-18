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
    // Étai : un « 0 » invisible et sans largeur, premier élément du flux.
    // Les colonnes rognent leur contenu, et une boîte qui rogne expose son
    // bord inférieur comme ligne de base : sans étai, le nombre s'alignait
    // sur le libellé voisin (.data-row, align-items: baseline) par ce bord
    // et remontait de la hauteur des jambages. L'étai fournit la vraie ligne
    // de base du texte au conteneur.
    var strut = document.createElement('span');
    strut.className = 't-roll-strut';
    strut.setAttribute('aria-hidden', 'true');
    strut.textContent = '0';
    var cols = document.createElement('span');
    cols.className = 't-roll-cols';
    cols.setAttribute('aria-hidden', 'true');
    el.appendChild(sr);
    el.appendChild(strut);
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
    render(el, format(value, currentLang(lang)));
  }

  /**
   * Texte libre : seuls les chiffres défilent, les autres caractères sont
   * posés tels quels (« 1950s », « Page 2 / 10 », « 2 sélectionnés »).
   * @param {Element|null} el @param {string} text
   */
  function setText(el, text) {
    if (!el || typeof text !== 'string') return;
    render(el, text);
  }

  // Largeur réelle de chaque chiffre, dans la police et l'espacement du
  // compteur (DM Sans au hangar, Barlow Condensed espacé à la frise…), posée
  // en --roll-w0…9 (CSSOM, autorisé par la CSP). Les largeurs codées en dur
  // ne valaient que pour une police : ailleurs les chiffres s'écartaient.
  // Remesuré à chaque mise à jour : la police peut arriver après le premier
  // affichage. Mesure nulle (police absente, jsdom) → repli CSS.
  function measureDigits(el) {
    var probe = document.createElement('span');
    probe.className = 't-roll-probe';
    probe.setAttribute('aria-hidden', 'true');
    var spans = [];
    for (var i = 0; i <= 9; i++) {
      var s = document.createElement('span');
      s.textContent = String(i);
      probe.appendChild(s);
      spans.push(s);
    }
    el.appendChild(probe);
    spans.forEach(function (span, d) {
      var w = span.getBoundingClientRect().width;
      if (w > 0) el.style.setProperty('--roll-w' + d, (Math.round(w * 100) / 100) + 'px');
    });
    probe.remove();
  }

  function render(el, text) {
    if (!el.classList.contains('t-roll')) init(el);
    measureDigits(el);
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

  window.VH.rollingNumber = { set: set, setText: setText };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.rollingNumber;
  }
})();
