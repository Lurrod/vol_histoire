/* Attribution des photographies (LEGAL-003).
 *
 * Les licences Creative Commons BY / BY-SA exigent l'auteur, un lien vers le
 * texte de la licence et, en version 4.0, l'indication des modifications. Nos
 * photos sont toutes retouchées (redimensionnées à 1 600 px, converties en
 * WebP / AVIF, déclinées en vignettes) : la mention « modifiée » s'affiche dès
 * que la licence demande une attribution. Domaine public et CC0 n'imposent
 * rien, la licence reste néanmoins indiquée.
 *
 * Utilisé par la légende du hero de la fiche (details/render.js) et par la
 * page Crédits photo (credits.js). Construction DOM uniquement (textContent,
 * createElement) : aucune donnée de la base n'est interprétée comme du HTML.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.shared = root.VH.shared || {};

  // Libellés de domaine public tels qu'ils figurent en base (image_licence).
  const PUBLIC_DOMAIN = new Set(['public domain', 'pdm-owner', 'pd']);
  const CC_RE = /^CC (BY(?:-NC)?(?:-SA|-ND)?) (\d\.\d)(?: ([a-z]{2}))?$/i;
  const CC0_URL = 'https://creativecommons.org/publicdomain/zero/1.0/';
  const KOGL1_URL = 'https://www.kogl.or.kr/info/licenseType1.do';
  // Open Government Licence (Royaume-Uni) : photos de la Couronne (MOD, RAF).
  const OGL1_URL = 'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/1/';
  const OGL1_RE = /^OGL v?1(.0)?$/i;

  function normalize(licence) {
    return typeof licence === 'string' ? licence.trim() : '';
  }

  function isPublicDomain(licence) {
    return PUBLIC_DOMAIN.has(normalize(licence).toLowerCase());
  }

  /**
   * URL canonique du texte de la licence, ou null si inconnue / domaine public.
   * « CC BY-SA 3.0 au » → https://creativecommons.org/licenses/by-sa/3.0/au/
   * @param {string|null} licence
   * @returns {string|null}
   */
  function licenceUrl(licence) {
    const value = normalize(licence);
    if (!value) return null;
    if (/^CC0( 1\.0)?$/i.test(value)) return CC0_URL;
    if (/^KOGL Type 1$/i.test(value)) return KOGL1_URL;
    if (OGL1_RE.test(value)) return OGL1_URL;
    const m = CC_RE.exec(value);
    if (!m) return null;
    const port = m[3] ? `${m[3].toLowerCase()}/` : '';
    return `https://creativecommons.org/licenses/${m[1].toLowerCase()}/${m[2]}/${port}`;
  }

  /** true si la licence impose l'attribution (donc la mention des modifications). */
  function requiresAttribution(licence) {
    const value = normalize(licence);
    return CC_RE.test(value) || /^KOGL Type 1$/i.test(value) || OGL1_RE.test(value);
  }

  /**
   * Remplit `el` avec « Photo : auteur — licence (lien) — modifiée ».
   * @param {Element} el conteneur (vidé au préalable)
   * @param {{author?: string|null, licence?: string|null}} credit
   * @param {(key: string) => string} t traduction (i18n.t)
   * @returns {boolean} false si rien à afficher (ni auteur ni licence)
   */
  function fillCredit(el, credit, t) {
    const author = normalize(credit && credit.author);
    const licence = normalize(credit && credit.licence);
    el.textContent = '';
    if (!author && !licence) return false;

    const parts = [];
    if (author) parts.push(document.createTextNode(author));
    if (licence) {
      const label = isPublicDomain(licence) ? t('details.licence_public_domain') : licence;
      const url = licenceUrl(licence);
      if (url) {
        const link = document.createElement('a');
        link.href = url;
        link.rel = 'license noopener';
        link.textContent = label;
        parts.push(link);
      } else {
        parts.push(document.createTextNode(label));
      }
      if (requiresAttribution(licence)) parts.push(document.createTextNode(t('details.photo_modified')));
    }

    el.appendChild(document.createTextNode(`${t('details.photo')} : `));
    parts.forEach((node, i) => {
      if (i > 0) el.appendChild(document.createTextNode(' — '));
      el.appendChild(node);
    });
    return true;
  }

  VH.shared.photoCredit = { licenceUrl, requiresAttribution, isPublicDomain, fillCredit };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.photoCredit;
  }
})();
