/* ======================================================================
   VOL D'HISTOIRE — COMPARATEUR D'AVIONS (v2)
   Cases à cocher, barre flottante, modale avec barres visuelles,
   armement, technologies, et verdict.
   ====================================================================== */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

    // ── Checkboxes sur les cartes ────────────────────────────────────
    function addCheckboxes() {
      container.querySelectorAll('.aircraft-card').forEach(card => {
        if (card.querySelector('.compare-check')) return;
        const id = Number(card.dataset.id);
        const label = document.createElement('label');
        label.className = 'compare-check';
        label.innerHTML =
          '<input type="checkbox" data-compare-id="' + id + '"' +
          (state.compareIds.includes(id) ? ' checked' : '') + '>' +
          '<span>' + escapeHtml(i18n.t('hangar.compare_label')) + '</span>';
        label.addEventListener('click', e => e.stopPropagation());
        card.appendChild(label);
      });
    }

    new MutationObserver(addCheckboxes).observe(container, { childList: true });
    addCheckboxes();

    container.addEventListener('change', e => {
      const cb = e.target.closest('[data-compare-id]');
      if (!cb) return;
      const id = Number(cb.dataset.compareId);
      if (cb.checked) {
        if (state.compareIds.length >= 3) {
          cb.checked = false;
          if (typeof showToast === 'function') showToast(i18n.t('hangar.compare_max'), 'warning');
          return;
        }
        state.compareIds.push(id);
      } else {
        state.compareIds = state.compareIds.filter(x => x !== id);
      }
      localStorage.setItem('vh_compare_ids', JSON.stringify(state.compareIds));
      renderCompareBar();
    });

    // ── Barre flottante ──────────────────────────────────────────────
    let bar = document.getElementById('compare-bar');
    if (!bar) {
      bar = document.createElement('div');
      bar.id = 'compare-bar';
      bar.className = 'compare-bar hidden';
      bar.style.display = 'none';
      bar.innerHTML =
        '<span id="compare-count"></span>' +
        '<button id="compare-clear" class="btn btn-secondary btn-sm">' + escapeHtml(i18n.t('hangar.compare_clear')) + '</button>' +
        '<button id="compare-view" class="btn btn-primary btn-sm">' + escapeHtml(i18n.t('hangar.compare_view')) + '</button>';
      document.body.appendChild(bar);

      const dlg = document.createElement('dialog');
      dlg.id = 'compare-modal';
      dlg.className = 'compare-modal';
      dlg.setAttribute('aria-labelledby', 'compare-modal-title');
      dlg.innerHTML =
        '<div class="compare-modal-header">' +
          '<h2 id="compare-modal-title"><i class="fas fa-crosshairs"></i><span>' + escapeHtml(i18n.t('hangar.compare_title', 'Comparaison')) + '</span></h2>' +
          '<button class="compare-modal-close" aria-label="' + escapeHtml(i18n.t('common.close', 'Fermer')) + '"><i class="fas fa-times"></i></button>' +
        '</div>' +
        '<div id="compare-modal-body"></div>';
      document.body.appendChild(dlg);
    }

    function renderCompareBar() {
      const n = state.compareIds.length;
      bar.classList.toggle('hidden', n === 0);
      bar.style.display = n === 0 ? 'none' : 'flex';
      const cnt = document.getElementById('compare-count');
      if (cnt) {
        const key = n > 1 ? 'hangar.compare_selected_many' : 'hangar.compare_selected_one';
        cnt.textContent = i18n.t(key, { n });
      }
    }
    window.renderCompareBar = renderCompareBar;

    document.getElementById('compare-clear').addEventListener('click', () => {
      state.compareIds = [];
      localStorage.setItem('vh_compare_ids', '[]');
      container.querySelectorAll('[data-compare-id]').forEach(cb => { cb.checked = false; });
      renderCompareBar();
    });

    function removeFromCompare(id) {
      state.compareIds = state.compareIds.filter(x => x !== id);
      localStorage.setItem('vh_compare_ids', JSON.stringify(state.compareIds));
      container.querySelectorAll('[data-compare-id="' + id + '"]').forEach(cb => { cb.checked = false; });
      renderCompareBar();
      if (state.compareIds.length === 0) {
        document.getElementById('compare-modal').close();
      } else {
        document.getElementById('compare-view').click();
      }
    }
    window.__vhRemoveCompare = removeFromCompare;

    // ── Helpers ──────────────────────────────────────────────────────
    function fmt(v, suffix) {
      if (v == null || v === '') return '<span class="cmp-dash">\u2014</span>';
      return escapeHtml(String(v)) + (suffix ? '<span class="cmp-unit"> ' + suffix + '</span>' : '');
    }

    function yearFrom(dateStr) {
      if (!dateStr) return null;
      var y = new Date(dateStr).getFullYear();
      return isNaN(y) ? null : y;
    }

    function findMax(items, key) {
      var max = -Infinity;
      for (var i = 0; i < items.length; i++) {
        var v = Number(items[i][key]);
        if (!isNaN(v) && v > max) max = v;
      }
      return max > -Infinity ? max : null;
    }

    function findMin(items, key) {
      var min = Infinity;
      for (var i = 0; i < items.length; i++) {
        var v = Number(items[i][key]);
        if (!isNaN(v) && v < min) min = v;
      }
      return min < Infinity ? min : null;
    }

    function bestClass(items, item, key, higherIsBetter) {
      var v = Number(item[key]);
      if (isNaN(v)) return '';
      var target = higherIsBetter ? findMax(items, key) : findMin(items, key);
      if (target == null) return '';
      return v === target ? ' cmp-best' : '';
    }

    // Barre de progression visuelle.
    // data-* encodent les dimensions dynamiques ; elles sont converties en
    // custom properties CSS via applyCompareCssVars() après insertion DOM
    // (évite l'attribut style="..." bloqué par la CSP).
    function bar_html(value, max, color) {
      if (value == null || isNaN(value) || max == null || max === 0) return '';
      var pct = Math.min(Math.round((value / max) * 100), 100);
      return '<div class="cmp-bar-track"><div class="cmp-bar-fill" data-pct="' + pct + '" data-bg="' + escapeHtml(color || 'var(--hud-cyan)') + '"></div></div>';
    }

    function applyCompareCssVars(root) {
      root.querySelectorAll('.cmp-bar-fill[data-pct]').forEach(function (el) {
        el.style.width = el.dataset.pct + '%';
        el.style.background = el.dataset.bg || 'var(--hud-cyan)';
      });
      root.querySelectorAll('[data-cmp-cols]').forEach(function (el) {
        el.style.setProperty('--cmp-cols', el.dataset.cmpCols);
      });
    }

    // ── Modale ───────────────────────────────────────────────────────
    document.getElementById('compare-view').addEventListener('click', async () => {
      if (state.compareIds.length === 0) return;
      var body = document.getElementById('compare-modal-body');
      body.innerHTML = '<div class="cmp-loading"><i class="fas fa-circle-notch fa-spin"></i> ' + escapeHtml(i18n.t('common.loading')) + '</div>';
      document.getElementById('compare-modal').showModal();

      try {
        // Charger données + armement + tech en parallèle
        var allData = await Promise.all(state.compareIds.map(function (id) {
          return Promise.all([
            fetch('/api/airplanes/' + id).then(function (r) { return r.json(); }),
            fetch('/api/airplanes/' + id + '/armament').then(function (r) { return r.json(); }).catch(function () { return []; }),
            fetch('/api/airplanes/' + id + '/tech').then(function (r) { return r.json(); }).catch(function () { return []; }),
          ]);
        }));

        var items = allData.map(function (d) {
          return Object.assign({}, d[0], { armament: d[1], tech: d[2] });
        });

        var maxSpeed = findMax(items, 'max_speed') || 1;
        var maxRange = findMax(items, 'max_range') || 1;
        var maxWeight = findMax(items, 'weight') || 1;
        var n = items.length;

        // ── Headers ──────────────────────────────────────────────
        var headers = items.map(function (a) {
          return '<div class="cmp-col-head">' +
            '<button class="cmp-remove" data-remove="' + a.id + '" aria-label="Retirer"><i class="fas fa-times"></i></button>' +
            '<div class="cmp-img-wrap">' +
              (a.image_url
                ? VH.shared.picture.pictureHtml(a.image_url, { alt: a.name || '', loading: 'lazy', width: '300', height: '200' })
                : '<div class="cmp-img-placeholder"><i class="fas fa-plane"></i></div>') +
            '</div>' +
            '<div class="cmp-col-title">' +
              '<h3>' + escapeHtml(a.name || '\u2014') + '</h3>' +
              (a.complete_name ? '<p>' + escapeHtml(a.complete_name) + '</p>' : '') +
            '</div>' +
            '<div class="cmp-col-meta">' +
              (a.country_name ? '<span class="cmp-chip"><i class="fas fa-globe"></i> ' + escapeHtml(a.country_name) + '</span>' : '') +
              (a.generation ? '<span class="cmp-chip cmp-chip-accent">Gen ' + escapeHtml(String(a.generation)) + '</span>' : '') +
              (a.type_name ? '<span class="cmp-chip"><i class="fas fa-tags"></i> ' + escapeHtml(a.type_name) + '</span>' : '') +
            '</div>' +
          '</div>';
        }).join('');

        // ── Performance rows avec barres ─────────────────────────
        function perfRow(label, key, unit, max, higherIsBetter) {
          var cells = items.map(function (a) {
            var v = Number(a[key]);
            var cls = bestClass(items, a, key, higherIsBetter);
            var valStr = isNaN(v) ? '<span class="cmp-dash">\u2014</span>' : fmt(a[key], unit);
            var barStr = isNaN(v) ? '' : bar_html(v, max, cls ? 'var(--hud-cyan)' : 'rgba(255,255,255,0.12)');
            return '<div class="cmp-cell cmp-cell-perf' + cls + '">' + valStr + barStr + '</div>';
          }).join('');
          return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
        }

        function textRow(label, fn) {
          var cells = items.map(function (a) {
            return '<div class="cmp-cell">' + fn(a) + '</div>';
          }).join('');
          return '<div class="cmp-row" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
        }

        function tagRow(label, key) {
          var cells = items.map(function (a) {
            var list = a[key] || [];
            if (list.length === 0) return '<div class="cmp-cell"><span class="cmp-dash">\u2014</span></div>';
            var tags = list.map(function (t) {
              return '<span class="cmp-tag">' + escapeHtml(t.name || '') + '</span>';
            }).join('');
            return '<div class="cmp-cell cmp-cell-tags">' + tags + '</div>';
          }).join('');
          return '<div class="cmp-row cmp-row-tags" data-cmp-cols="' + n + '"><div class="cmp-row-label">' + label + '</div>' + cells + '</div>';
        }

        // ── Assemble ─────────────────────────────────────────────
        var groupClass = function (title, icon, rowsHtml) {
          return '<div class="cmp-group">' +
            '<div class="cmp-group-header"><i class="fas ' + icon + '"></i><span>' + title + '</span></div>' +
            rowsHtml +
          '</div>';
        };

        var classificationHtml = groupClass(i18n.t('hangar.compare_classification', 'Classification'), 'fa-tags',
          textRow(i18n.t('hangar.compare_manufacturer', 'Constructeur'), function (a) { return fmt(a.manufacturer_name); }) +
          textRow(i18n.t('hangar.compare_type', 'Type'), function (a) { return fmt(a.type_name); }) +
          textRow(i18n.t('hangar.compare_status', 'Statut'), function (a) { return fmt(a.status); })
        );

        var chronoHtml = groupClass(i18n.t('hangar.compare_timeline', 'Chronologie'), 'fa-calendar',
          textRow(i18n.t('hangar.compare_concept', 'Conception'), function (a) { return fmt(yearFrom(a.date_concept)); }) +
          textRow(i18n.t('hangar.compare_first_flight', 'Premier vol'), function (a) { return fmt(yearFrom(a.date_first_fly)); }) +
          textRow(i18n.t('hangar.compare_service', 'Mise en service'), function (a) { return fmt(yearFrom(a.date_operationel || a.date_operational)); })
        );

        var perfHtml = groupClass(i18n.t('hangar.compare_performance', 'Performances'), 'fa-gauge-high',
          perfRow(i18n.t('hangar.compare_speed', 'Vitesse max'), 'max_speed', 'km/h', maxSpeed, true) +
          perfRow(i18n.t('hangar.compare_range', 'Portée max'), 'max_range', 'km', maxRange, true) +
          perfRow(i18n.t('hangar.compare_weight', 'Poids'), 'weight', 'kg', maxWeight, false)
        );

        var armamentHtml = groupClass(i18n.t('hangar.compare_armament', 'Armement'), 'fa-burst',
          tagRow(i18n.t('hangar.compare_weapons', 'Systèmes'), 'armament')
        );

        var techHtml = groupClass(i18n.t('hangar.compare_tech', 'Technologies'), 'fa-microchip',
          tagRow(i18n.t('hangar.compare_systems', 'Systèmes'), 'tech')
        );

        body.innerHTML =
          '<div class="cmp-summary">' +
            '<span class="cmp-eyebrow"><i class="fas fa-crosshairs"></i> ' + escapeHtml(i18n.t('hangar.compare_eyebrow', 'Analyse comparée')) + '</span>' +
            '<span class="cmp-summary-count">' + n + ' ' + escapeHtml(n > 1 ? i18n.t('hangar.compare_aircraft_plural', 'appareils') : i18n.t('hangar.compare_aircraft_single', 'appareil')) + '</span>' +
          '</div>' +
          '<div class="cmp-cols" data-cmp-cols="' + n + '">' + headers + '</div>' +
          '<div class="cmp-body">' + classificationHtml + chronoHtml + perfHtml + armamentHtml + techHtml + '</div>';

        // Met à jour le titre du header avec le compteur
        var headerTitle = document.querySelector('#compare-modal-title span');
        if (headerTitle) {
          headerTitle.textContent = i18n.t('hangar.compare_title', 'Comparaison') + ' — ' + n;
        }

        // Applique width/background/--cmp-cols via DOM API après insertion (CSP-safe)
        applyCompareCssVars(body);

        // Bind remove buttons
        body.querySelectorAll('.cmp-remove').forEach(function (btn) {
          btn.addEventListener('click', function () { removeFromCompare(Number(btn.dataset.remove)); });
        });

      } catch {
        body.innerHTML = '<div class="cmp-loading cmp-error"><i class="fas fa-triangle-exclamation"></i> ' + escapeHtml(i18n.t('common.loading_error')) + '</div>';
      }
    });

    document.querySelectorAll('#compare-modal .compare-modal-close').forEach(function (btn) {
      btn.addEventListener('click', function () {
        document.getElementById('compare-modal').close();
      });
    });

    // Purge ids orphelins
    if (state.compareIds.length > 0 && state.aircraft.length > 0) {
      var validIds = new Set(state.aircraft.map(function (a) { return Number(a.id); }));
      var cleaned = state.compareIds.filter(function (id) { return validIds.has(Number(id)); });
      if (cleaned.length !== state.compareIds.length) {
        state.compareIds = cleaned;
        localStorage.setItem('vh_compare_ids', JSON.stringify(cleaned));
      }
    }
    renderCompareBar();
  }

  VH.hangar.compare = { init };
})();
