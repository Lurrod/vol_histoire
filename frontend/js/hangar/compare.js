/* Mode comparaison : cases à cocher sur les cartes, barre flottante, modale. */
(function () {
  window.VH = window.VH || {};
  window.VH.hangar = window.VH.hangar || {};

  function init(state) {
    const container = document.getElementById('airplanes-container');
    if (!container) return;

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
      dlg.innerHTML =
        '<button class="compare-modal-close" aria-label="Fermer"><i class="fas fa-times"></i></button>' +
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

    function fmt(v, suffix) {
      if (v == null || v === '') return '<span class="cmp-dash">—</span>';
      return escapeHtml(String(v)) + (suffix ? '<span class="cmp-unit"> ' + suffix + '</span>' : '');
    }
    function findMax(items, key) {
      let max = -Infinity;
      for (const a of items) {
        const v = Number(a[key]);
        if (!isNaN(v) && v > max) max = v;
      }
      return max > -Infinity ? max : null;
    }
    function bestClass(items, item, key, higherIsBetter) {
      const v = Number(item[key]);
      if (isNaN(v)) return '';
      const max = findMax(items, key);
      if (max == null) return '';
      return (higherIsBetter && v === max) ? ' cmp-best' : '';
    }
    function yearFrom(dateStr) {
      if (!dateStr) return null;
      const y = new Date(dateStr).getFullYear();
      return isNaN(y) ? null : y;
    }

    document.getElementById('compare-view').addEventListener('click', async () => {
      if (state.compareIds.length === 0) return;
      try {
        const items = await Promise.all(
          state.compareIds.map(id => fetch('/api/airplanes/' + id).then(r => r.json()))
        );

        const headers = items.map(a => `
          <div class="cmp-col-head">
            <button class="cmp-remove" data-remove="${a.id}" aria-label="Retirer"><i class="fas fa-times"></i></button>
            <div class="cmp-img-wrap">
              ${a.image_url
                ? '<img src="' + escapeHtml(a.image_url) + '" alt="' + escapeHtml(a.name || '') + '" loading="lazy">'
                : '<div class="cmp-img-placeholder"><i class="fas fa-plane"></i></div>'}
            </div>
            <div class="cmp-col-title">
              <h3>${escapeHtml(a.name || '—')}</h3>
              ${a.complete_name ? '<p>' + escapeHtml(a.complete_name) + '</p>' : ''}
            </div>
            <div class="cmp-col-meta">
              ${a.country_name ? '<span class="cmp-chip"><i class="fas fa-globe"></i> ' + escapeHtml(a.country_name) + '</span>' : ''}
              ${a.generation ? '<span class="cmp-chip cmp-chip-accent">Gen ' + escapeHtml(String(a.generation)) + '</span>' : ''}
            </div>
          </div>
        `).join('');

        const groups = [
          { title: 'Classification', icon: 'fa-tags', rows: [
            { label: 'Constructeur', fn: a => fmt(a.manufacturer_name) },
            { label: 'Type',         fn: a => fmt(a.type_name) },
            { label: 'Statut',       fn: a => fmt(a.status) },
          ]},
          { title: 'Chronologie', icon: 'fa-calendar', rows: [
            { label: 'Conception',      fn: a => fmt(yearFrom(a.date_concept)) },
            { label: 'Premier vol',     fn: a => fmt(yearFrom(a.date_first_fly)) },
            { label: 'Mise en service', fn: a => fmt(yearFrom(a.date_operationel || a.date_operational)) },
          ]},
          { title: 'Performances', icon: 'fa-gauge-high', rows: [
            { label: 'Vitesse max', key: 'max_speed', unit: 'km/h', better: true },
            { label: 'Portée max',  key: 'max_range', unit: 'km',   better: true },
            { label: 'Poids',       key: 'weight',    unit: 'kg',   better: false },
          ]},
        ];

        const groupsHtml = groups.map(g => `
          <div class="cmp-group">
            <div class="cmp-group-header"><i class="fas ${g.icon}"></i><span>${g.title}</span></div>
            ${g.rows.map(r => {
              const cells = items.map(a => {
                if (r.fn) return '<div class="cmp-cell">' + r.fn(a) + '</div>';
                const cls = bestClass(items, a, r.key, r.better);
                return '<div class="cmp-cell' + cls + '">' + fmt(a[r.key], r.unit) + '</div>';
              }).join('');
              return `<div class="cmp-row" style="--cmp-cols:${items.length}">
                <div class="cmp-row-label">${r.label}</div>${cells}
              </div>`;
            }).join('')}
          </div>
        `).join('');

        document.getElementById('compare-modal-body').innerHTML = `
          <div class="cmp-head">
            <div>
              <span class="cmp-eyebrow">Analyse comparée</span>
              <h2>Comparaison de ${items.length} appareil${items.length > 1 ? 's' : ''}</h2>
            </div>
          </div>
          <div class="cmp-cols" style="--cmp-cols:${items.length}">${headers}</div>
          <div class="cmp-body">${groupsHtml}</div>
        `;

        document.querySelectorAll('#compare-modal-body .cmp-remove').forEach(btn => {
          btn.addEventListener('click', () => removeFromCompare(Number(btn.dataset.remove)));
        });

        document.getElementById('compare-modal').showModal();
      } catch (_) { /* ignore */ }
    });

    document.querySelector('#compare-modal .compare-modal-close').addEventListener('click', () => {
      document.getElementById('compare-modal').close();
    });

    // Purge des ids orphelins avant l'affichage
    if (state.compareIds.length > 0 && state.aircraft.length > 0) {
      const validIds = new Set(state.aircraft.map(a => Number(a.id)));
      const cleaned = state.compareIds.filter(id => validIds.has(Number(id)));
      if (cleaned.length !== state.compareIds.length) {
        state.compareIds = cleaned;
        localStorage.setItem('vh_compare_ids', JSON.stringify(cleaned));
      }
    }
    renderCompareBar();
  }

  VH.hangar.compare = { init };
})();
