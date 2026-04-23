/* ======================================================================
   VOL D'HISTOIRE — SETTINGS : DASHBOARD
   Statistiques personnelles (favoris, répartitions, KPIs).
   Dépend de window.settings (currentUser).
   ====================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const ctx = () => window.settings;
  const API_BASE = '/api';

  async function loadDashboard() {
    const currentUser = ctx()?.currentUser;

    // Profile card
    const initials = (currentUser?.name || 'U').charAt(0).toUpperCase();
    const dbAvatar = document.getElementById('db-avatar');
    if (dbAvatar) dbAvatar.textContent = initials;

    const dbName = document.getElementById('db-name');
    if (dbName) dbName.textContent = currentUser?.name || 'Utilisateur';

    const dbRoleBadge = document.getElementById('db-role-badge');
    if (dbRoleBadge) {
      const role = Number(currentUser?.role);
      dbRoleBadge.textContent = role === 1 ? i18n.t('common.role_admin') : role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
      dbRoleBadge.className = `db-role-badge ${role === 1 ? 'role-admin' : role === 2 ? 'role-editor' : 'role-member'}`;
    }

    const dbEmail = document.getElementById('db-email');
    if (dbEmail) dbEmail.textContent = currentUser?.email || '';

    // Favoris
    try {
      const response = await auth.authFetch(`${API_BASE}/favorites`);
      if (!response.ok) return;
      const favorites = await response.json();
      renderDashboardStats(favorites);
    } catch {
      // Dashboard non critique — fail silently
    }
  }

  function renderDashboardStats(favorites) {
    if (favorites.length === 0) {
      document.getElementById('db-kpis')?.classList.add('hidden');
      document.getElementById('db-charts')?.classList.add('hidden');
      document.getElementById('db-type-block')?.classList.add('hidden');
      document.getElementById('db-empty')?.classList.remove('hidden');
      return;
    }

    const isEn = i18n.currentLang === 'en';
    const countryKey = isEn ? 'country_name_en' : 'country_name';
    const typeKey    = isEn ? 'type_name_en'    : 'type_name';
    const pickCountry = f => f[countryKey] || f.country_name;
    const pickType    = f => f[typeKey]    || f.type_name;

    const countries   = new Set(favorites.map(pickCountry).filter(Boolean));
    const generations = new Set(favorites.map(f => f.generation).filter(Boolean));
    const types       = new Set(favorites.map(pickType).filter(Boolean));

    dbAnimateCounter('db-total-fav',       favorites.length);
    dbAnimateCounter('db-total-countries', countries.size);
    dbAnimateCounter('db-total-gen',       generations.size);
    dbAnimateCounter('db-total-types',     types.size);

    // Par pays (top 6)
    dbRenderBars('db-country-bars', dbGroupByFn(favorites, pickCountry), 6);

    // Par génération
    const genRaw = dbGroupBy(favorites, 'generation');
    const genLabeled = Object.entries(genRaw)
      .sort(([a], [b]) => Number(a) - Number(b))
      .reduce((acc, [k, v]) => {
        const suffix = i18n.currentLang === 'en'
          ? `${k}${['st','nd','rd'][Number(k)-1] || 'th'} Gen`
          : `Gen ${k}`;
        acc[suffix] = v;
        return acc;
      }, {});
    dbRenderBars('db-gen-bars', genLabeled, 5, false);

    // Par type (top 6)
    dbRenderBars('db-type-bars', dbGroupByFn(favorites, pickType), 6);
  }

  function dbGroupBy(arr, key) {
    return dbGroupByFn(arr, item => item[key]);
  }

  function dbGroupByFn(arr, fn) {
    return arr.reduce((acc, item) => {
      const val = fn(item);
      if (val != null) acc[val] = (acc[val] || 0) + 1;
      return acc;
    }, {});
  }

  function dbRenderBars(containerId, data, maxItems, sort = true) {
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

  function dbAnimateCounter(id, target) {
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

  // Re-render on language change (profile name, role badge, chart labels)
  window.addEventListener('langChanged', () => {
    if (ctx()?.currentUser) loadDashboard();
  });

  // Expose for settings.js
  window.settingsDashboard = { loadDashboard };
});
