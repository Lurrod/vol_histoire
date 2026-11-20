/* Paramètres — en-tête d'identité : avatar (initiale), nom, rôle, « Membre
 * depuis <mois année> » (created_at de GET /api/users/:id, absent tant que
 * l'API ne l'a pas donné) et nombre de favoris (odomètre). Re-rendu au
 * changement de langue. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  let lastUser = null;
  let lastCount = null;

  /** Libellé et classe du rôle (1 admin, 2 éditeur, sinon membre). */
  function roleBadge(role) {
    if (role === 1) return { key: 'common.role_admin', fallback: 'Administrateur', cls: 'role-admin' };
    if (role === 2) return { key: 'common.role_editor', fallback: 'Éditeur', cls: 'role-editor' };
    return { key: 'nav.user_role', fallback: 'Membre', cls: 'role-member' };
  }

  /** « mars 2025 » / « March 2025 », ou null si la date est absente ou illisible. */
  function memberSince(createdAt, lang) {
    if (!createdAt) return null;
    const date = new Date(createdAt);
    if (Number.isNaN(date.getTime())) return null;
    return date.toLocaleDateString(lang === 'en' ? 'en-GB' : 'fr-FR', { month: 'long', year: 'numeric' });
  }

  function render(user) {
    const { tr, trf } = VH.settings.ui;
    lastUser = user || null;
    const name = (user && user.name) || tr('settings.user_default', 'Utilisateur');

    const avatar = document.getElementById('id-avatar');
    if (avatar) avatar.textContent = name.charAt(0).toUpperCase();
    const nameEl = document.getElementById('id-name');
    if (nameEl) nameEl.textContent = name;

    const roleEl = document.getElementById('id-role');
    if (roleEl) {
      const badge = roleBadge(Number(user && user.role));
      roleEl.textContent = tr(badge.key, badge.fallback);
      roleEl.className = `role-pill ${badge.cls}`;
    }

    const sinceEl = document.getElementById('id-since');
    if (sinceEl) {
      const lang = typeof i18n !== 'undefined' ? i18n.currentLang : 'fr';
      const date = memberSince(user && user.created_at, lang);
      sinceEl.hidden = !date;
      sinceEl.textContent = date ? trf('settings.member_since', 'Membre depuis {date}', { date }) : '';
    }
  }

  /** Nombre de favoris de l'en-tête, avec son libellé accordé. */
  function setFavoriteCount(count) {
    const { tr, plural } = VH.settings.ui;
    const n = Math.max(0, Number(count) || 0);
    lastCount = n;
    const num = document.getElementById('id-fav-count');
    if (num && window.VH.rollingNumber) window.VH.rollingNumber.set(num, n);
    else if (num) num.textContent = String(n);
    const label = document.getElementById('id-fav-label');
    if (label) label.textContent = tr(plural('settings.id_favorites', n), n === 1 ? 'favori' : 'favoris');
  }

  function init() {
    window.addEventListener('langChanged', () => {
      if (lastUser) render(lastUser);
      if (lastCount != null) setFavoriteCount(lastCount);
    });
  }

  VH.settings.identity = { roleBadge, memberSince, render, setFavoriteCount, init };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.identity;
  }
})();
