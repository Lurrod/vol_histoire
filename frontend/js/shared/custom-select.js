/* VH.customSelect — listes déroulantes personnalisées (v4.17.0).
 *
 * Le <select> natif n'est pas remplacé : il reste dans le DOM, visuellement
 * masqué, et demeure la source de vérité (valeur, envoi du formulaire,
 * validation, événements `change` écoutés par le code des pages). Devant
 * lui, un déclencheur et une liste au motif « select-only combobox » de
 * l'APG (WAI-ARIA Authoring Practices) :
 *   - fermé : Flèches, Entrée, Espace, Début/Fin ouvrent ; une lettre ouvre
 *     et saute à l'option correspondante ;
 *   - ouvert : Flèches, Début/Fin, Page préc./suiv. déplacent l'option
 *     active ; Entrée, Espace, Alt+Flèche haut et Tab choisissent ; Échap
 *     referme sans changer ; pendant une frappe, Espace est un caractère.
 * La liste suit le natif : options traduites ou remplacées, attributs d'état
 * (required, aria-invalid, aria-describedby, disabled — fieldset compris)
 * reflétés sur le déclencheur, `select.value` / `selectedIndex` écrits par le
 * code, `change` émis ailleurs, réinitialisation du formulaire, retour arrière.
 *
 * Tout <select> simple de la page est amélioré au chargement, et ceux ajoutés
 * ensuite (modales d'administration) dès leur insertion — y compris un clone
 * d'un champ déjà amélioré. Un select à garder natif porte `data-native`. */
(function () {
  window.VH = window.VH || {};

  var proto = window.HTMLSelectElement && window.HTMLSelectElement.prototype;
  var VALUE = proto && Object.getOwnPropertyDescriptor(proto, 'value');
  var INDEX = proto && Object.getOwnPropertyDescriptor(proto, 'selectedIndex');
  var TYPEAHEAD_MS = 500;
  var PAGE_STEP = 10;
  var RENDER_ATTRS = ['disabled', 'label', 'selected', 'hidden'];
  var uid = 0;

  // Instances vivantes : resynchronisées au retour arrière et au reset.
  var instances = new Set();
  var enhanced = new WeakSet();

  function normalize(text) {
    return String(text || '').normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
  }

  function findLabel(select) {
    if (select.id) {
      var labels = document.getElementsByTagName('label');
      for (var i = 0; i < labels.length; i++) {
        if (labels[i].htmlFor === select.id) return labels[i];
      }
    }
    return select.closest('label');
  }

  // Texte d'un label qui englobe le select, sans le texte des options.
  function labelText(label) {
    var copy = label.cloneNode(true);
    copy.querySelectorAll('select, .cselect-trigger, .cselect-list').forEach(function (n) { n.remove(); });
    return copy.textContent.replace(/\s+/g, ' ').trim();
  }

  function isDisabled(select) {
    if (select.disabled) return true;
    try { return select.matches(':disabled'); } catch { return false; }
  }

  function createIcon(name, extraClass) {
    var i = document.createElement('i');
    i.className = 'fas fa-' + name + ' ' + extraClass;
    i.setAttribute('aria-hidden', 'true');
    return i;
  }

  // Plus proche ancêtre qui rogne ou défile (modale à overflow:auto…).
  function clipBounds(el) {
    for (var p = el.parentElement; p && p !== document.body; p = p.parentElement) {
      if (/(auto|scroll|hidden|clip)/.test(window.getComputedStyle(p).overflowY)) {
        var r = p.getBoundingClientRect();
        return { top: Math.max(0, r.top), bottom: Math.min(window.innerHeight, r.bottom) };
      }
    }
    return { top: 0, bottom: window.innerHeight };
  }

  function enhance(select) {
    if (!select || !VALUE || select.multiple || select.size > 1) return null;
    if (enhanced.has(select) || select.hasAttribute('data-native')) return null;
    enhanced.add(select);

    var id = 'cselect-' + (++uid);
    var state = { open: false, active: -1, typed: '', typedAt: 0, cancelExit: null, pointer: null };

    // ── Construction ─────────────────────────────────────────────────────
    // Clone d'un champ déjà amélioré (modale régénérée, cloneNode) : on
    // reprend son enveloppe et on jette son déclencheur et sa liste inertes.
    var wrap = select.parentNode;
    if (wrap && wrap.classList && wrap.classList.contains('cselect')) {
      Array.prototype.slice.call(wrap.children).forEach(function (n) {
        if (n !== select) n.remove();
      });
    } else {
      wrap = document.createElement('div');
      wrap.className = 'cselect';
      select.parentNode.insertBefore(wrap, select);
      wrap.appendChild(select);
    }
    select.classList.add('cselect-native');
    select.dataset.cselect = 'on';
    select.tabIndex = -1;
    select.setAttribute('aria-hidden', 'true');

    var trigger = document.createElement('div');
    trigger.className = 'cselect-trigger';
    trigger.id = id + '-trigger';
    trigger.setAttribute('role', 'combobox');
    trigger.setAttribute('aria-haspopup', 'listbox');
    trigger.setAttribute('aria-expanded', 'false');
    trigger.setAttribute('aria-controls', id + '-list');
    var valueEl = document.createElement('span');
    valueEl.className = 'cselect-value';
    trigger.appendChild(valueEl);
    trigger.appendChild(createIcon('chevron-down', 'cselect-chevron'));

    var list = document.createElement('ul');
    list.className = 'cselect-list';
    list.id = id + '-list';
    list.setAttribute('role', 'listbox');
    list.tabIndex = -1;
    list.hidden = true;

    wrap.appendChild(trigger);
    wrap.appendChild(list);

    // ── Nom accessible ───────────────────────────────────────────────────
    function setName(attr, value) {
      ['aria-labelledby', 'aria-label'].forEach(function (a) {
        if (a === attr && value) { trigger.setAttribute(a, value); list.setAttribute(a, value); }
        else { trigger.removeAttribute(a); list.removeAttribute(a); }
      });
    }

    function applyName() {
      var label = findLabel(select);
      if (select.getAttribute('aria-labelledby')) {
        setName('aria-labelledby', select.getAttribute('aria-labelledby'));
      } else if (label && !label.contains(select)) {
        if (!label.id) label.id = id + '-label';
        setName('aria-labelledby', label.id);
      } else if (label) {
        setName('aria-label', labelText(label));
      } else {
        setName('aria-label', select.getAttribute('aria-label') || select.getAttribute('title') || '');
      }
    }

    // ── Rendu ────────────────────────────────────────────────────────────
    function optionEl(i) { return list.querySelector('[data-index="' + i + '"]'); }

    function isEnabled(i) {
      var o = select.options[i];
      return !!o && !o.disabled && !o.hidden && !(o.parentElement && o.parentElement.disabled);
    }

    function render() {
      list.textContent = '';
      for (var i = 0; i < select.options.length; i++) {
        var o = select.options[i];
        if (o.hidden) continue; // « Choisir… » : invisible, comme en natif
        var li = document.createElement('li');
        li.className = 'cselect-option';
        li.id = id + '-opt-' + i;
        li.setAttribute('role', 'option');
        li.dataset.index = String(i);
        if (!isEnabled(i)) li.setAttribute('aria-disabled', 'true');
        var text = document.createElement('span');
        text.className = 'cselect-option-text';
        text.textContent = o.textContent;
        li.appendChild(text);
        li.appendChild(createIcon('check', 'cselect-check'));
        list.appendChild(li);
      }
      sync();
      // Options réécrites liste ouverte (i18n) : l'option active reste.
      if (state.open) {
        var keep = state.active;
        state.active = -1;
        setActive(isEnabled(keep) ? keep : firstEnabled());
      }
    }

    function mirror(attr, value) {
      if (value === null || value === undefined || value === false) trigger.removeAttribute(attr);
      else trigger.setAttribute(attr, value);
    }

    function sync() {
      var idx = INDEX.get.call(select);
      var o = select.options[idx];
      valueEl.textContent = o ? o.textContent : '';
      Array.prototype.forEach.call(list.children, function (li) {
        li.setAttribute('aria-selected', Number(li.dataset.index) === idx ? 'true' : 'false');
      });
      var disabled = isDisabled(select);
      trigger.tabIndex = disabled ? -1 : 0;
      mirror('aria-disabled', disabled ? 'true' : null);
      wrap.classList.toggle('is-disabled', disabled);
      // État du champ porté par le natif (validation, setFieldError) : le
      // lecteur d'écran l'entend sur le déclencheur, seul élément exposé.
      mirror('aria-required', select.required ? 'true' : null);
      mirror('aria-invalid', select.getAttribute('aria-invalid'));
      mirror('aria-describedby', select.getAttribute('aria-describedby'));
      applyName();
      if (disabled && state.open) close(false);
    }

    function setActive(i) {
      var prev = state.active >= 0 ? optionEl(state.active) : null;
      if (prev) prev.classList.remove('is-active');
      state.active = i;
      var el = i >= 0 ? optionEl(i) : null;
      if (!el) { trigger.removeAttribute('aria-activedescendant'); return; }
      el.classList.add('is-active');
      trigger.setAttribute('aria-activedescendant', el.id);
      // Garder l'option active visible sans faire défiler la page.
      var top = el.offsetTop;
      var bottom = top + el.offsetHeight;
      if (top < list.scrollTop) list.scrollTop = top;
      else if (bottom > list.scrollTop + list.clientHeight) list.scrollTop = bottom - list.clientHeight;
    }

    function step(from, dir, count) {
      var i = from;
      var last = from;
      var n = select.options.length;
      for (var moved = 0; moved < count;) {
        i += dir;
        if (i < 0 || i >= n) break;
        if (isEnabled(i)) { last = i; moved++; }
      }
      return last;
    }

    function firstEnabled() { return step(-1, 1, 1); }
    function lastEnabled() { return step(select.options.length, -1, 1); }

    // ── Ouverture / fermeture ────────────────────────────────────────────
    function place() {
      wrap.classList.remove('is-above');
      var r = trigger.getBoundingClientRect();
      var bounds = clipBounds(wrap);
      var h = list.offsetHeight;
      var below = bounds.bottom - r.bottom;
      var above = r.top - bounds.top;
      if (h > below && above > below) wrap.classList.add('is-above');
    }

    function open() {
      if (state.open || isDisabled(select)) return;
      if (state.cancelExit) { state.cancelExit(); state.cancelExit = null; }
      sync(); // une écriture passée inaperçue (option.selected…) se rattrape ici
      state.open = true;
      state.pointer = null;
      list.hidden = false;
      place();
      list.classList.add('is-open');
      wrap.classList.add('is-open');
      trigger.setAttribute('aria-expanded', 'true');
      var idx = INDEX.get.call(select);
      setActive(isEnabled(idx) ? idx : firstEnabled());
      document.addEventListener('pointerdown', onOutside, true);
    }

    function close(refocus) {
      if (!state.open) return;
      state.open = false;
      state.typed = '';
      document.removeEventListener('pointerdown', onOutside, true);
      trigger.setAttribute('aria-expanded', 'false');
      setActive(-1);
      list.classList.remove('is-open');
      wrap.classList.remove('is-open');
      var finished = false;
      var cancel = window.VH.motion.exit(list, function () {
        finished = true;
        state.cancelExit = null;
        list.hidden = true;
      }, { className: 'is-closing' });
      if (!finished) state.cancelExit = cancel;
      if (refocus) trigger.focus();
    }

    function choose(i) {
      if (i < 0 || !isEnabled(i)) return;
      if (i !== INDEX.get.call(select)) {
        INDEX.set.call(select, i);
        sync();
        select.dispatchEvent(new Event('input', { bubbles: true }));
        select.dispatchEvent(new Event('change', { bubbles: true }));
      }
    }

    function onOutside(e) {
      if (!wrap.contains(e.target)) close(false);
    }

    // ── Recherche par frappe ─────────────────────────────────────────────
    function typing() { return state.typed && Date.now() - state.typedAt <= TYPEAHEAD_MS; }

    function typeahead(ch) {
      var now = Date.now();
      state.typed = (now - state.typedAt > TYPEAHEAD_MS) ? ch : state.typed + ch;
      state.typedAt = now;
      var needle = normalize(state.typed);
      var n = select.options.length;
      var start = state.active >= 0 ? state.active : -1;
      // Une même lettre répétée fait défiler les options qui la partagent.
      var repeated = needle.length > 1 && needle.split('').every(function (c) { return c === needle[0]; });
      var query = repeated ? needle[0] : needle;
      var offset = (repeated || needle.length === 1) ? 1 : 0;
      for (var k = 0; k < n; k++) {
        var i = (start + offset + k + n) % n;
        if (isEnabled(i) && normalize(select.options[i].textContent).trim().indexOf(query) === 0) {
          setActive(i);
          return;
        }
      }
    }

    // ── Événements ───────────────────────────────────────────────────────
    trigger.addEventListener('click', function () {
      if (state.open) close(true);
      else { open(); trigger.focus(); }
    });

    trigger.addEventListener('blur', function () { close(false); });

    function printable(e) { return e.key.length === 1 && !e.ctrlKey && !e.metaKey && !e.altKey; }

    trigger.addEventListener('keydown', function (e) {
      if (isDisabled(select)) return;
      var k = e.key;
      if (!state.open) {
        if (k === 'ArrowDown' || k === 'ArrowUp' || k === 'Enter' || k === ' ') {
          e.preventDefault();
          open();
        } else if (k === 'Home' || k === 'End') {
          e.preventDefault();
          open();
          setActive(k === 'Home' ? firstEnabled() : lastEnabled());
        } else if (printable(e)) {
          open();
          typeahead(k);
        }
        return;
      }
      if (k === ' ' && typing()) { e.preventDefault(); typeahead(k); return; }
      switch (k) {
        case 'ArrowDown': e.preventDefault(); setActive(step(state.active, 1, 1)); break;
        case 'ArrowUp':
          e.preventDefault();
          if (e.altKey) { choose(state.active); close(true); } else setActive(step(state.active, -1, 1));
          break;
        case 'Home': e.preventDefault(); setActive(firstEnabled()); break;
        case 'End': e.preventDefault(); setActive(lastEnabled()); break;
        case 'PageDown': e.preventDefault(); setActive(step(state.active, 1, PAGE_STEP)); break;
        case 'PageUp': e.preventDefault(); setActive(step(state.active, -1, PAGE_STEP)); break;
        case 'Enter':
        case ' ':
          e.preventDefault(); choose(state.active); close(true); break;
        case 'Tab': choose(state.active); close(false); break;
        case 'Escape':
          // La liste ouverte consomme Échap : la page (modale, filtres)
          // ne doit pas se fermer en même temps.
          e.preventDefault(); e.stopPropagation(); close(true); break;
        default:
          if (printable(e)) typeahead(k);
      }
    });

    // Le clic dans la liste ne doit pas retirer le focus du déclencheur.
    list.addEventListener('mousedown', function (e) { e.preventDefault(); });
    list.addEventListener('pointerdown', function (e) { e.preventDefault(); });
    list.addEventListener('click', function (e) {
      var li = e.target.closest('.cselect-option');
      if (!li) return;
      var i = Number(li.dataset.index);
      if (!isEnabled(i)) return;
      choose(i);
      close(true);
    });
    // Survol : seul un vrai déplacement du pointeur change l'option active
    // (une liste qui défile sous un pointeur immobile émet aussi mousemove).
    list.addEventListener('mousemove', function (e) {
      var p = state.pointer;
      state.pointer = { x: e.clientX, y: e.clientY };
      if (p && p.x === e.clientX && p.y === e.clientY) return;
      var li = e.target.closest('.cselect-option');
      if (li && !li.hasAttribute('aria-disabled')) {
        var i = Number(li.dataset.index);
        if (i !== state.active) setActive(i);
      }
    });

    // Label cliqué, validation du formulaire : le focus revient au déclencheur.
    select.addEventListener('focus', function () { trigger.focus(); });
    select.addEventListener('change', sync);

    // Options traduites ou remplies plus tard → nouvelle liste ; attributs
    // d'état seulement (aria-invalid posé par setFieldError…) → reflet.
    new MutationObserver(function (records) {
      var full = records.some(function (r) {
        return r.type !== 'attributes' || RENDER_ATTRS.indexOf(r.attributeName) !== -1;
      });
      if (full) render(); else sync();
    }).observe(select, {
      childList: true, subtree: true, characterData: true, attributes: true,
      attributeFilter: RENDER_ATTRS.concat(['required', 'aria-invalid', 'aria-describedby',
        'aria-label', 'aria-labelledby', 'title'])
    });

    // Le code des pages écrit select.value / selectedIndex : l'affichage suit.
    Object.defineProperty(select, 'value', {
      configurable: true,
      get: function () { return VALUE.get.call(this); },
      set: function (v) { VALUE.set.call(this, v); sync(); }
    });
    Object.defineProperty(select, 'selectedIndex', {
      configurable: true,
      get: function () { return INDEX.get.call(this); },
      set: function (v) { INDEX.set.call(this, v); sync(); }
    });

    var instance = { select: select, sync: sync, open: open, close: close, refresh: render };
    instances.add(instance);
    render();
    return instance;
  }

  // Instances dont le select a quitté le document : oubliées au passage.
  function eachLive(fn) {
    instances.forEach(function (inst) {
      if (!inst.select.isConnected) { instances.delete(inst); return; }
      fn(inst);
    });
  }

  // Réinitialisation d'un formulaire : un seul écouteur pour toute la page.
  document.addEventListener('reset', function (e) {
    var form = e.target;
    setTimeout(function () {
      eachLive(function (inst) { if (form.contains(inst.select)) inst.sync(); });
    }, 0);
  }, true);

  // Retour arrière / restauration du formulaire par le navigateur.
  window.addEventListener('pageshow', function () { eachLive(function (inst) { inst.sync(); }); });

  // ── Amélioration automatique ─────────────────────────────────────────
  var observer = null;

  function enhanceIn(node) {
    if (node.nodeType !== 1) return;
    if (node.tagName === 'SELECT') { enhance(node); return; }
    var found = node.querySelectorAll ? node.querySelectorAll('select') : [];
    for (var i = 0; i < found.length; i++) enhance(found[i]);
  }

  function enhanceAll(root) {
    enhanceIn(root && root.nodeType === 9 ? root.documentElement : (root || document.documentElement));
    if (!observer && typeof MutationObserver === 'function') {
      observer = new MutationObserver(function (records) {
        for (var r = 0; r < records.length; r++) {
          var added = records[r].addedNodes;
          for (var a = 0; a < added.length; a++) enhanceIn(added[a]);
        }
      });
      observer.observe(document.documentElement, { childList: true, subtree: true });
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () { enhanceAll(document); });
  } else {
    enhanceAll(document);
  }

  window.VH.customSelect = { enhance: enhance, enhanceAll: enhanceAll };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.VH.customSelect;
  }
})();
