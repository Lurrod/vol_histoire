/* Page « Crédits photo » (LEGAL-003).
 *
 * Les photos du catalogue sont réutilisées hors de la fiche (cartes du
 * hangar, de l'accueil, des favoris, vignettes, images de partage) sans
 * légende : cette page regroupe l'attribution de chacune — appareil, auteur,
 * licence avec lien vers son texte, mention des modifications.
 *
 * Données : GET /api/credits → tableau (ou { data: [...] }) de
 *   { id, name, name_en, image_credit, image_licence }.
 * Le rendu passe par textContent / createElement (VH.shared.photoCredit).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const API_URL = '/api/credits';

  function t(key, fallback) {
    const value = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key) : null;
    return value && value !== key ? value : fallback;
  }

  function isEnglish() {
    return typeof i18n !== 'undefined' && i18n.currentLang === 'en';
  }

  /** Nom affiché selon la langue, repli sur le nom français. */
  function displayName(item) {
    return (isEnglish() && item.name_en) ? item.name_en : (item.name || '');
  }

  /** Entrées exploitables (au moins un auteur ou une licence), triées par nom. */
  function normalizeCredits(payload) {
    const list = Array.isArray(payload) ? payload : (payload && Array.isArray(payload.data) ? payload.data : []);
    return list
      .filter((item) => item && item.id != null && (item.image_credit || item.image_licence))
      .slice()
      .sort((a, b) => displayName(a).localeCompare(displayName(b), isEnglish() ? 'en' : 'fr', { sensitivity: 'base' }));
  }

  function detailsPath(item) {
    const build = root.VH.shared && root.VH.shared.buildDetailsPath;
    return build ? build(item.id, item.name) : `/details/${encodeURIComponent(item.id)}`;
  }

  function buildRow(item, tr) {
    const row = document.createElement('tr');

    const nameCell = document.createElement('td');
    const link = document.createElement('a');
    link.href = detailsPath(item);
    link.textContent = displayName(item);
    nameCell.appendChild(link);

    const authorCell = document.createElement('td');
    authorCell.textContent = item.image_credit || tr('credits.author_unknown', 'Non renseigné');

    const licenceCell = document.createElement('td');
    const pc = root.VH.shared.photoCredit;
    const licence = item.image_licence;
    if (licence) {
      const label = pc.isPublicDomain(licence) ? tr('details.licence_public_domain', 'Domaine public') : licence;
      const url = pc.licenceUrl(licence);
      if (url) {
        const a = document.createElement('a');
        a.href = url;
        a.rel = 'license noopener';
        a.textContent = label;
        licenceCell.appendChild(a);
      } else {
        licenceCell.textContent = label;
      }
    } else {
      licenceCell.textContent = tr('credits.licence_unknown', 'Non renseignée');
    }

    const noteCell = document.createElement('td');
    noteCell.textContent = licence && pc.requiresAttribution(licence)
      ? tr('credits.modified', 'Redimensionnée et convertie (WebP, AVIF, vignettes)')
      : '';

    row.append(nameCell, authorCell, licenceCell, noteCell);
    return row;
  }

  function setStatus(message, isError) {
    const status = document.getElementById('credits-status');
    if (!status) return;
    status.textContent = message;
    status.classList.toggle('is-error', Boolean(isError));
    status.hidden = !message;
  }

  function render(items) {
    const body = document.getElementById('credits-body');
    const table = document.getElementById('credits-table-wrap');
    if (!body) return;
    body.textContent = '';
    items.forEach((item) => body.appendChild(buildRow(item, t)));
    if (table) table.hidden = items.length === 0;
    setStatus(items.length === 0 ? t('credits.empty', 'Aucun crédit à afficher.') : '', false);
    const count = document.getElementById('credits-count');
    if (count) count.textContent = String(items.length);
  }

  async function load(fetchImpl) {
    const doFetch = fetchImpl || ((url) => fetch(url, { headers: { Accept: 'application/json' } }));
    setStatus(t('credits.loading', 'Chargement des crédits…'), false);
    try {
      const response = await doFetch(API_URL);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const items = normalizeCredits(await response.json());
      render(items);
      return items;
    } catch {
      setStatus(t('credits.error', 'Les crédits n\'ont pas pu être chargés. Réessayez plus tard.'), true);
      return null;
    }
  }

  VH.credits = { normalizeCredits, buildRow, render, load, displayName };

  if (typeof document !== 'undefined' && typeof module === 'undefined') {
    document.addEventListener('DOMContentLoaded', async () => {
      if (typeof auth !== 'undefined' && typeof auth.init === 'function') await auth.init();
      load();
      // Noms d'appareils selon la langue : re-rendu au changement de langue.
      window.addEventListener('langChanged', () => load());
    });
  }

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.credits;
  }
})();
