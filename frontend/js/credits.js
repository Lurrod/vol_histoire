/* Page « Crédits photo » (LEGAL-003).
 *
 * Les photos du catalogue sont réutilisées hors de la fiche (cartes du
 * hangar, de l'accueil, des favoris, vignettes, images de partage) sans
 * légende : cette page regroupe l'attribution de chacune — appareil, auteur,
 * licence avec lien vers son texte, mention des modifications.
 *
 * Données : GET /api/credits → tableau (ou { data: [...] }) de
 *   { id, name, name_en, image_url, image_credit, image_licence }.
 *
 * Liste groupée par lettre, vignette de chaque photo, recherche (appareil,
 * auteur ou licence) et filtre par famille de licence. Les deux sont
 * reflétés dans l'adresse (?q=…&licence=cc) pour pouvoir partager une vue.
 * Les photos sans provenance documentée sont listées aussi, avec un lien
 * pour signaler l'auteur. Rendu par createElement / textContent
 * (VH.shared.photoCredit) : aucune donnée de la base n'est lue comme du HTML.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const API_URL = '/api/credits';
  const FAMILIES = ['all', 'free', 'cc', 'other', 'none'];
  const CC_RE = /^CC BY/i;
  const CC0_RE = /^CC0( 1\.0)?$/i;

  // Vue courante, gardée d'un rendu à l'autre (changement de langue).
  const state = { q: '', family: 'all' };
  let entries = [];
  let lastPayload = null;

  function t(key, fallback, params) {
    const value = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key, params) : null;
    if (value && value !== key) return value;
    return Object.keys(params || {}).reduce((s, k) => s.split(`{${k}}`).join(String(params[k])), fallback);
  }

  function isEnglish() {
    return typeof i18n !== 'undefined' && i18n.currentLang === 'en';
  }

  function photoCredit() {
    return root.VH.shared && root.VH.shared.photoCredit;
  }

  /** Nom affiché selon la langue, repli sur le nom français. */
  function displayName(item) {
    return (isEnglish() && item.name_en) ? item.name_en : (item.name || '');
  }

  /** Famille de licence : free (domaine public, CC0), cc, other (OGL, KOGL, GFDL), none. */
  function licenceFamily(licence) {
    const value = typeof licence === 'string' ? licence.trim() : '';
    if (!value) return 'none';
    const pc = photoCredit();
    if (CC0_RE.test(value) || (pc && pc.isPublicDomain(value))) return 'free';
    if (CC_RE.test(value)) return 'cc';
    return 'other';
  }

  /** Texte de recherche : minuscules, sans accents ni ponctuation (« f16 » trouve « F-16 »). */
  function fold(text) {
    return String(text || '')
      .normalize('NFD')
      .replace(/[̀-ͯ]/g, '')
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '');
  }

  /** Lettre de regroupement : initiale sans accent, « # » pour un chiffre ou un signe. */
  function letterOf(name) {
    const first = fold(name).charAt(0).toUpperCase();
    return /[A-Z]/.test(first) ? first : '#';
  }

  /** Toutes les fiches (documentées ou non), triées par nom affiché. */
  function normalizeCredits(payload) {
    const list = Array.isArray(payload) ? payload : (payload && Array.isArray(payload.data) ? payload.data : []);
    const locale = isEnglish() ? 'en' : 'fr';
    return list
      .filter((item) => item && item.id != null)
      .slice()
      .sort((a, b) => displayName(a).localeCompare(displayName(b), locale, { sensitivity: 'base' }));
  }

  function detailsPath(item) {
    const build = root.VH.shared && root.VH.shared.buildDetailsPath;
    return build ? build(item.id, item.name) : `/details/${encodeURIComponent(item.id)}`;
  }

  function el(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text != null) node.textContent = text;
    return node;
  }

  /** Vignette 320 px (AVIF / WebP) ; l'<img> garde la photo pleine en repli. */
  function buildThumb(item, href) {
    const link = el('a', 'credit-thumb');
    link.href = href;
    link.tabIndex = -1;
    link.setAttribute('aria-hidden', 'true');
    const pic = root.VH.shared && root.VH.shared.picture;
    const sources = item.image_url && pic ? pic.getThumbSources(item.image_url) : null;
    if (!item.image_url) return link;
    const img = el('img');
    img.alt = '';
    img.width = 96;
    img.height = 64;
    img.setAttribute('loading', 'lazy');
    img.setAttribute('decoding', 'async');
    if (sources) {
      const picture = el('picture');
      [['image/avif', sources.avif], ['image/webp', sources.webp]].forEach(([type, srcset]) => {
        const source = el('source');
        source.type = type;
        source.srcset = srcset;
        picture.appendChild(source);
      });
      img.src = sources.fallback;
      picture.appendChild(img);
      link.appendChild(picture);
    } else {
      img.src = item.image_url;
      link.appendChild(img);
    }
    return link;
  }

  /** Pastille de licence (liée à son texte quand il existe). */
  function buildLicence(licence) {
    const pc = photoCredit();
    const box = el('div', 'credit-licence');
    if (!licence) {
      box.appendChild(el('span', 'credit-badge credit-badge--none', t('credits.licence_unknown', 'Non documentée')));
      return box;
    }
    const label = pc.isPublicDomain(licence) ? t('details.licence_public_domain', 'Domaine public') : licence;
    const url = pc.licenceUrl(licence);
    const free = licenceFamily(licence) === 'free';
    const badge = el(url ? 'a' : 'span', free ? 'credit-badge credit-badge--free' : 'credit-badge', label);
    if (url) {
      badge.href = url;
      badge.rel = 'license noopener';
    }
    box.appendChild(badge);
    if (pc.requiresAttribution(licence)) {
      const note = el('span', 'credit-modified', t('credits.modified_short', 'Modifiée'));
      note.title = t('credits.modified', 'Redimensionnée et convertie (WebP, AVIF, vignettes)');
      box.appendChild(note);
    }
    return box;
  }

  /** Une photo : vignette, appareil, auteur, licence. */
  function buildItem(item) {
    const href = detailsPath(item);
    const li = el('li', 'credit');
    li.dataset.family = licenceFamily(item.image_licence);

    const body = el('div', 'credit-body');
    const name = el('a', 'credit-name', displayName(item));
    name.href = href;
    body.appendChild(name);

    if (item.image_credit) {
      body.appendChild(el('p', 'credit-author', item.image_credit));
    } else if (item.image_licence) {
      body.appendChild(el('p', 'credit-author is-muted', t('credits.author_unknown', 'Auteur non renseigné')));
    } else {
      const line = el('p', 'credit-author is-muted', `${t('credits.undocumented', 'Provenance non documentée')} · `);
      const claim = el('a', 'credit-claim', t('credits.claim', 'C’est votre photo ?'));
      claim.href = `/contact?sujet=bug&fiche=${encodeURIComponent(item.id)}`;
      line.appendChild(claim);
      body.appendChild(line);
    }

    li.append(buildThumb(item, href), body, buildLicence(item.image_licence));
    return li;
  }

  /** Groupes par lettre ; renvoie le fragment et les entrées { item, li, key }. */
  function buildList(items) {
    const fragment = document.createDocumentFragment();
    const built = [];
    let group = null;
    let list = null;
    items.forEach((item) => {
      const letter = letterOf(displayName(item));
      if (!group || group.dataset.letter !== letter) {
        group = el('section', 'credits-group');
        group.dataset.letter = letter;
        const id = `credits-letter-${letter === '#' ? 'num' : letter}`;
        group.setAttribute('aria-labelledby', id);
        const heading = el('h3', 'credits-letter', letter);
        heading.id = id;
        list = el('ul', 'credits-items');
        group.append(heading, list);
        fragment.appendChild(group);
      }
      const li = buildItem(item);
      list.appendChild(li);
      built.push({
        li,
        family: li.dataset.family,
        key: fold([item.name, item.name_en, item.image_credit, item.image_licence].join(' ')),
      });
    });
    return { fragment, entries: built };
  }

  /** Nombre de photos par famille (indépendant de la recherche). */
  function countFamilies(items) {
    const counts = { all: items.length, free: 0, cc: 0, other: 0, none: 0 };
    items.forEach((item) => { counts[licenceFamily(item.image_licence)] += 1; });
    return counts;
  }

  /** Une entrée est visible si elle passe le filtre de famille et la recherche. */
  function matches(entry, view) {
    if (view.family !== 'all' && entry.family !== view.family) return false;
    const q = fold(view.q);
    return !q || entry.key.indexOf(q) !== -1;
  }

  function resultText(shown, total, filtered) {
    const photos = shown === 1 ? t('credits.photo_one', '1 photo') : t('credits.photo_many', '{n} photos', { n: shown });
    return filtered ? t('credits.result_filtered', '{photos} sur {total}', { photos, total }) : photos;
  }

  /** Applique la vue : lignes, groupes, compteur, message « aucun résultat ». */
  function applyView() {
    let shown = 0;
    entries.forEach((entry) => {
      const visible = matches(entry, state);
      entry.li.hidden = !visible;
      if (visible) shown += 1;
    });
    document.querySelectorAll('#credits-list .credits-group').forEach((group) => {
      group.hidden = !group.querySelector('.credit:not([hidden])');
    });
    const filtered = state.family !== 'all' || fold(state.q) !== '';
    const result = document.getElementById('credits-result');
    if (result) {
      result.textContent = resultText(shown, entries.length, filtered);
      result.hidden = entries.length === 0;
    }
    const none = document.getElementById('credits-none');
    if (none) none.hidden = shown > 0 || entries.length === 0;
    document.querySelectorAll('.credits-filter').forEach((button) => {
      button.setAttribute('aria-pressed', String(button.dataset.family === state.family));
    });
    return shown;
  }

  /** Lit ?q= et ?licence= ; une famille inconnue revient à « toutes ». */
  function readUrlState(search) {
    const params = new URLSearchParams(search || '');
    const family = params.get('licence');
    return {
      q: (params.get('q') || '').slice(0, 100),
      family: FAMILIES.indexOf(family) !== -1 ? family : 'all',
    };
  }

  /** Écrit la vue dans l'adresse sans toucher aux autres paramètres (?lang=). */
  function writeUrlState(view) {
    if (typeof history === 'undefined' || !history.replaceState) return;
    const url = new URL(root.location.href);
    if (view.q) url.searchParams.set('q', view.q); else url.searchParams.delete('q');
    if (view.family !== 'all') url.searchParams.set('licence', view.family); else url.searchParams.delete('licence');
    history.replaceState(history.state, '', url.pathname + url.search + url.hash);
  }

  function setStatus(message, isError) {
    const status = document.getElementById('credits-status');
    if (!status) return;
    status.textContent = message;
    status.classList.toggle('is-error', Boolean(isError));
    status.hidden = !message;
  }

  function showList(visible) {
    ['credits-list', 'credits-tools'].forEach((id) => {
      const node = document.getElementById(id);
      if (node) node.hidden = !visible;
    });
    if (!visible) {
      const result = document.getElementById('credits-result');
      if (result) result.hidden = true;
    }
  }

  function render(items) {
    const list = document.getElementById('credits-list');
    if (!list) return;
    const built = buildList(items);
    list.textContent = '';
    list.appendChild(built.fragment);
    entries = built.entries;

    const counts = countFamilies(items);
    document.querySelectorAll('.credits-filter').forEach((button) => {
      const family = button.dataset.family;
      const count = button.querySelector('.credits-filter-count');
      if (count) count.textContent = String(counts[family] || 0);
      // Famille vide (aucune licence « autre », par exemple) : bouton masqué.
      button.hidden = family !== 'all' && !counts[family] && state.family !== family;
    });

    showList(items.length > 0);
    setStatus(items.length === 0 ? t('credits.empty', 'Aucun crédit à afficher.') : '', false);
    applyView();
  }

  async function load(fetchImpl) {
    const doFetch = fetchImpl || ((url) => fetch(url, { headers: { Accept: 'application/json' } }));
    setStatus(t('credits.loading', 'Chargement des crédits…'), false);
    try {
      const response = await doFetch(API_URL);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      lastPayload = await response.json();
      const items = normalizeCredits(lastPayload);
      render(items);
      return items;
    } catch {
      entries = [];
      showList(false);
      const none = document.getElementById('credits-none');
      if (none) none.hidden = true;
      setStatus(t('credits.error', 'Les crédits n\'ont pas pu être chargés. Réessayez plus tard.'), true);
      return null;
    }
  }

  /** Nouveau rendu des données déjà reçues (langue chargée ou changée). */
  function rerender() {
    if (lastPayload) render(normalizeCredits(lastPayload));
  }

  /** Recherche, filtres et remise à zéro ; la vue de départ vient de l'adresse. */
  function bindControls(search) {
    Object.assign(state, readUrlState(search));
    const input = document.getElementById('credits-search');
    if (input) {
      input.value = state.q;
      input.addEventListener('input', () => {
        state.q = input.value.slice(0, 100);
        applyView();
        writeUrlState(state);
      });
    }
    document.querySelectorAll('.credits-filter').forEach((button) => {
      button.addEventListener('click', () => {
        state.family = button.dataset.family;
        applyView();
        writeUrlState(state);
      });
    });
    const reset = document.getElementById('credits-reset');
    if (reset) {
      reset.addEventListener('click', () => {
        state.q = '';
        state.family = 'all';
        if (input) {
          input.value = '';
          input.focus();
        }
        applyView();
        writeUrlState(state);
      });
    }
  }

  VH.credits = {
    normalizeCredits, licenceFamily, fold, letterOf, countFamilies, matches,
    readUrlState, writeUrlState, buildItem, buildList, render, load, bindControls,
    applyView, rerender, displayName, state,
  };

  if (typeof document !== 'undefined' && typeof module === 'undefined') {
    document.addEventListener('DOMContentLoaded', async () => {
      if (typeof auth !== 'undefined' && typeof auth.init === 'function') await auth.init();
      bindControls(window.location.search);
      load();
      // Noms d'appareils et libellés selon la langue : la langue peut arriver
      // après les données, ou changer ensuite.
      window.addEventListener('i18nReady', rerender);
      window.addEventListener('langChanged', rerender);
    });
  }

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.credits;
  }
})();
