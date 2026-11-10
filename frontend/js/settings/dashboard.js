/* Paramètres — tableau de bord : carte de profil et statistiques des favoris
 * (compteurs, répartitions par pays, génération et type). Re-rendu au
 * changement de langue une fois l'utilisateur connu. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  function roleBadge(role) {
    if (role === 1) return { key: 'common.role_admin', cls: 'role-admin' };
    if (role === 2) return { key: 'common.role_editor', cls: 'role-editor' };
    return { key: 'nav.user_role', cls: 'role-member' };
  }

  function renderProfileCard(currentUser) {
    const dbAvatar = document.getElementById('db-avatar');
    if (dbAvatar) dbAvatar.textContent = (currentUser?.name || 'U').charAt(0).toUpperCase();

    const dbName = document.getElementById('db-name');
    if (dbName) dbName.textContent = currentUser?.name || 'Utilisateur';

    const dbRoleBadge = document.getElementById('db-role-badge');
    if (dbRoleBadge) {
      const badge = roleBadge(Number(currentUser?.role));
      dbRoleBadge.textContent = i18n.t(badge.key);
      dbRoleBadge.className = `db-role-badge ${badge.cls}`;
    }

    const dbEmail = document.getElementById('db-email');
    if (dbEmail) dbEmail.textContent = currentUser?.email || '';
  }

  async function loadDashboard(state) {
    renderProfileCard(state.currentUser);

    try {
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/favorites`);
      if (!response.ok) return;
      const favorites = await response.json();
      renderDashboardStats(favorites);
    } catch {
      // Tableau de bord non critique : échec silencieux
    }
  }

  function groupByFn(arr, fn) {
    return arr.reduce((acc, item) => {
      const val = fn(item);
      if (val != null) acc[val] = (acc[val] || 0) + 1;
      return acc;
    }, {});
  }

  /** Libellé de génération : « Gen 4 » en français, « 4th Gen » en anglais. */
  function generationLabel(gen, lang) {
    return lang === 'en'
      ? `${gen}${['st', 'nd', 'rd'][Number(gen) - 1] || 'th'} Gen`
      : `Gen ${gen}`;
  }

  /** Répartitions pures (testables) : comptes par pays, génération, type. */
  function computeStats(favorites, lang) {
    const isEn = lang === 'en';
    const countryKey = isEn ? 'country_name_en' : 'country_name';
    const typeKey    = isEn ? 'type_name_en'    : 'type_name';
    const pickCountry = f => f[countryKey] || f.country_name;
    const pickType    = f => f[typeKey]    || f.type_name;

    const genRaw = groupByFn(favorites, f => f.generation);
    const byGeneration = Object.entries(genRaw)
      .sort(([a], [b]) => Number(a) - Number(b))
      .reduce((acc, [k, v]) => {
        acc[generationLabel(k, lang)] = v;
        return acc;
      }, {});

    return {
      total: favorites.length,
      countries: new Set(favorites.map(pickCountry).filter(Boolean)).size,
      generations: new Set(favorites.map(f => f.generation).filter(Boolean)).size,
      types: new Set(favorites.map(pickType).filter(Boolean)).size,
      byCountry: groupByFn(favorites, pickCountry),
      byGeneration,
      byType: groupByFn(favorites, pickType),
    };
  }

  function renderDashboardStats(favorites) {
    if (favorites.length === 0) {
      document.getElementById('db-kpis')?.classList.add('hidden');
      document.getElementById('db-charts')?.classList.add('hidden');
      document.getElementById('db-type-block')?.classList.add('hidden');
      document.getElementById('db-empty')?.classList.remove('hidden');
      return;
    }

    const stats = computeStats(favorites, i18n.currentLang);

    animateCounter('db-total-fav',       stats.total);
    animateCounter('db-total-countries', stats.countries);
    animateCounter('db-total-gen',       stats.generations);
    animateCounter('db-total-types',     stats.types);

    renderBars('db-country-bars', stats.byCountry, 6);        // top 6
    renderBars('db-gen-bars', stats.byGeneration, 5, false); // ordre des générations
    renderBars('db-type-bars', stats.byType, 6);              // top 6
  }

  function renderBars(containerId, data, maxItems, sort = true) {
    const container = document.getElementById(containerId);
    if (!container) return;

    let entries = Object.entries(data);
    if (sort) entries.sort(([, a], [, b]) => b - a);
    entries = entries.slice(0, maxItems);

    const max = entries[0]?.[1] || 1;

    container.innerHTML = entries.map(([label, count]) => `
      <div class="db-bar-row">
        <span class="db-bar-label" title="${escapeHtml(String(label))}">${escapeHtml(String(label))}</span>
        <div class="db-bar-track">
          <div class="db-bar-fill" data-w="${(count / max * 100).toFixed(1)}"></div>
        </div>
        <span class="db-bar-count">${count}</span>
      </div>
    `).join('');

    requestAnimationFrame(() => requestAnimationFrame(() => {
      container.querySelectorAll('.db-bar-fill').forEach(bar => {
        bar.style.width = bar.dataset.w + '%';
      });
    }));
  }

  function animateCounter(id, target) {
    const el = document.getElementById(id);
    if (!el || target === 0) { if (el) el.textContent = 0; return; }
    let current = 0;
    const step = Math.max(1, Math.ceil(target / 30));
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current;
      if (current >= target) clearInterval(timer);
    }, 24);
  }

  function init(state) {
    // Re-rendu au changement de langue (nom, badge de rôle, libellés des graphiques)
    window.addEventListener('langChanged', () => {
      if (state.currentUser) loadDashboard(state);
    });
  }

  VH.settings.dashboard = { computeStats, generationLabel, renderDashboardStats, renderBars, loadDashboard, init };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.dashboard;
  }
})();
