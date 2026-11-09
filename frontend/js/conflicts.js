/* Page des conflits : /conflits (liste) et /conflits/<slug> (un conflit).
 * Données : GET /api/wars et GET /api/wars/:slug. Les balises <head> et le
 * titre de chaque conflit sont déjà posés côté serveur (conflicts-ssr.js) ;
 * ce script remplit le contenu. */
(function () {
  window.VH = window.VH || {};

  const $ = (id) => document.getElementById(id);

  // Attend que les traductions soient chargées : i18n.t() renverrait la clé.
  function whenI18nReady(timeoutMs = 3000) {
    const start = Date.now();
    return new Promise((resolve) => {
      (function poll() {
        if (!window.i18n || i18n.isLoaded || Date.now() - start >= timeoutMs) return resolve();
        setTimeout(poll, 30);
      })();
    });
  }

  const year = (d) => (d ? new Date(d).getFullYear() : null);

  // « 1955 – 1975 », « depuis 2022 » (en cours), « 1982 » (même année).
  function period(w) {
    const a = year(w.date_start);
    const b = year(w.date_end);
    if (!a) return '';
    if (!b) return i18n.t('conflicts.since', { year: a });
    return a === b ? String(a) : `${a} – ${b}`;
  }

  // Remplit un élément traduit au chargement : on retire data-i18n, sinon un
  // changement de langue le ramènerait au texte d'attente.
  function setText(el, text) {
    if (!el) return;
    el.removeAttribute('data-i18n');
    el.removeAttribute('data-i18n-html');
    el.textContent = text;
  }

  function showError() {
    $('conflicts-error')?.classList.remove('hidden');
  }

  function slugFromPath() {
    const parts = location.pathname.split('/').filter(Boolean);
    return parts[0] === 'conflits' && parts[1] ? decodeURIComponent(parts[1]) : null;
  }

  // ── Liste ──────────────────────────────────────────────────────────────
  function renderList(wars) {
    const list = $('conflicts-list');
    if (!list) return;
    const total = wars.reduce((n, w) => n + (w.count || 0), 0);
    setText($('stat-a'), String(wars.length));
    setText($('stat-b'), String(total));

    list.innerHTML = wars.map((w) => `
      <a class="conflict-card" href="/conflits/${encodeURIComponent(w.slug)}">
        <span class="conflict-period">${escapeHtml(period(w))}</span>
        <h2 class="conflict-name">${escapeHtml(w.name)}</h2>
        ${w.description ? `<p class="conflict-desc">${escapeHtml(w.description)}</p>` : ''}
        <span class="conflict-count"><i class="fas fa-plane" aria-hidden="true"></i>
          ${escapeHtml(i18n.t(w.count > 1 ? 'conflicts.aircraft_many' : 'conflicts.aircraft_one', { count: w.count }))}</span>
      </a>`).join('');
    list.classList.remove('hidden');
  }

  // ── Un conflit ─────────────────────────────────────────────────────────
  function renderWar(war) {
    const h1 = $('page-hero-heading');
    setText(h1, war.name);
    setText($('hero-eyebrow'), `${i18n.t('conflicts.eyebrow_war')} · ${period(war)}`);
    setText($('hero-desc'), war.description || '');

    const nations = new Set((war.airplanes || []).map((a) => a.country_code).filter(Boolean));
    setText($('stat-a'), String(war.count));
    setText($('stat-a-label'), i18n.t('conflicts.stat_aircraft_engaged'));
    setText($('stat-b'), String(nations.size));
    setText($('stat-b-label'), i18n.t('conflicts.stat_nations'));

    const crumb = $('crumb-current');
    setText($('crumb-current-name'), war.name);
    crumb?.classList.remove('hidden');

    // Le hangar filtre sur le nom FR canonique, quelle que soit la langue.
    const hangarLink = $('conflict-hangar-link');
    if (hangarLink) hangarLink.href = `/hangar?war=${encodeURIComponent(war.name_fr)}`;

    const grid = $('conflict-aircraft');
    if (grid) {
      grid.innerHTML = (war.airplanes || [])
        .map((a) => VH.shared.renderAircraftCard(a))
        .join('');
      VH.shared.bindCardNavigation(grid);
    }
    $('conflict-detail')?.classList.remove('hidden');
  }

  // Retire les silhouettes de chargement dès qu'une vue s'affiche.
  function hideLoading() {
    $('conflicts-loading')?.remove();
    document.querySelector('.conflicts-section')?.removeAttribute('aria-busy');
  }

  async function init() {
    document.querySelector('.conflicts-section')?.setAttribute('aria-busy', 'true');
    await auth.init();
    await whenI18nReady();
    if (window.nav && typeof nav.updateAuthUI === 'function') nav.updateAuthUI();

    const slug = slugFromPath();
    try {
      const res = await auth.fetchWithTimeout(slug ? `/api/wars/${encodeURIComponent(slug)}` : '/api/wars');
      if (!res.ok) { hideLoading(); return showError(); }
      const data = await res.json();
      hideLoading();
      if (slug) renderWar(data);
      else renderList(Array.isArray(data) ? data : []);
    } catch {
      hideLoading();
      showError();
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }

  VH.conflicts = { period, slugFromPath };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.conflicts;
  } else {
    document.addEventListener('DOMContentLoaded', init);
  }
})();
