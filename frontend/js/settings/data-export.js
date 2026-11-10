/* Paramètres — export des données du compte (droit d'accès et droit à la
 * portabilité, LEGAL-011). Récupère GET /api/users/me/export (JSON : profil et
 * favoris) avec le jeton de session, puis le propose en téléchargement via un
 * Blob et un lien temporaire — aucun gestionnaire en ligne (CSP).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const DEFAULT_FILENAME = 'vol-histoire-donnees.json';
  // Délai avant de libérer l'URL du Blob : le navigateur doit avoir lancé
  // le téléchargement (certains le font de façon asynchrone après le clic).
  const REVOKE_DELAY_MS = 1000;

  /**
   * Nom de fichier tiré de l'en-tête Content-Disposition, réduit à des
   * caractères sûrs ; null s'il est absent ou inexploitable.
   * @param {string|null} header
   * @returns {string|null}
   */
  function filenameFromDisposition(header) {
    if (!header) return null;
    const match = /filename\*?=(?:UTF-8'')?"?([^";]+)"?/i.exec(header);
    if (!match) return null;
    let name;
    try { name = decodeURIComponent(match[1].trim()); } catch { name = match[1].trim(); }
    const safe = name.replace(/[^\w.-]/g, '_').replace(/^\.+/, '');
    return safe ? safe : null;
  }

  /** Propose `blob` en téléchargement sous `filename`. */
  function triggerDownload(blob, filename) {
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    link.hidden = true;
    document.body.appendChild(link);
    link.click();
    link.remove();
    setTimeout(() => URL.revokeObjectURL(url), REVOKE_DELAY_MS);
  }

  async function exportData(button) {
    const { API_BASE, tr, setButtonLoading } = VH.settings.ui;
    if (button && button.getAttribute('aria-busy') === 'true') return;
    setButtonLoading(button, true);

    try {
      const response = await auth.authFetch(`${API_BASE}/users/me/export`);
      if (!response.ok) {
        let message = null;
        try { message = (await response.json()).message; } catch { /* corps non JSON */ }
        showToast(message || tr('settings.export_error', 'Impossible de préparer l\'export de vos données.'), 'error');
        return;
      }
      const blob = await response.blob();
      const filename = filenameFromDisposition(response.headers.get('Content-Disposition')) || DEFAULT_FILENAME;
      triggerDownload(blob, filename);
      showToast(tr('settings.export_success', 'Vos données ont été téléchargées.'), 'success');
    } catch {
      showToast(i18n.t('settings.toast_network_error'), 'error');
    } finally {
      setButtonLoading(button, false);
    }
  }

  function setup() {
    const button = document.getElementById('export-data-btn');
    button?.addEventListener('click', () => exportData(button));
  }

  VH.settings.dataExport = { filenameFromDisposition, triggerDownload, exportData, setup };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.dataExport;
  }
})();
