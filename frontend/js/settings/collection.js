/* Paramètres — « Ma collection » (remplace le tableau de bord, 2026-11-20).
 *
 * Données : GET /api/favorites (plus récents d'abord : id, name, image_url,
 * date_operationel, country_name(_en), country_code…). On montre :
 *   - les derniers ajouts en vignettes (lien vers la fiche, data-morph-id :
 *     la photo vole de la vignette à la fiche, js/shared/view-morph.js) ;
 *   - la répartition par décennie de mise en service (histogramme) ;
 *   - la répartition par pays (drapeau, barre, nombre) ;
 *   - la dernière fiche consultée (VH.lastViewed), même sans favori.
 * Sans favori : invitation vers le hangar. Toutes les données passent par
 * escapeHtml ; les tailles des barres sont posées en CSSOM (CSP). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const STRIP_MAX = 8;
  const COUNTRY_MAX = 6;
  const YEAR_MIN = 1900;
  const YEAR_MAX = 2100;

  let favorites = null;

  const byId = (id) => document.getElementById(id);
  const lang = () => (typeof i18n !== 'undefined' && i18n.currentLang === 'en' ? 'en' : 'fr');

  /** Année de mise en service, ou null. */
  function yearOf(fav) {
    if (!fav || !fav.date_operationel) return null;
    const year = new Date(fav.date_operationel).getFullYear();
    return Number.isInteger(year) && year >= YEAR_MIN && year <= YEAR_MAX ? year : null;
  }

  /** Décennies de la première à la dernière présente (vides comprises). */
  function decadeStats(list) {
    const counts = new Map();
    let undated = 0;
    list.forEach((fav) => {
      const year = yearOf(fav);
      if (year == null) { undated += 1; return; }
      const decade = Math.floor(year / 10) * 10;
      counts.set(decade, (counts.get(decade) || 0) + 1);
    });
    const keys = [...counts.keys()];
    if (!keys.length) return { decades: [], undated, max: 0 };
    const first = Math.min(...keys);
    const last = Math.max(...keys);
    const decades = [];
    for (let d = first; d <= last; d += 10) decades.push({ decade: d, count: counts.get(d) || 0 });
    return { decades, undated, max: Math.max(...decades.map((x) => x.count)) };
  }

  /** Pays triés par nombre décroissant, puis par nom. */
  function countryStats(list, language) {
    const map = new Map();
    list.forEach((fav) => {
      const name = (language === 'en' && fav.country_name_en) || fav.country_name;
      if (!name) return;
      const entry = map.get(name) || { name, code: fav.country_code || null, count: 0 };
      entry.count += 1;
      map.set(name, entry);
    });
    return [...map.values()].sort((a, b) => b.count - a.count || a.name.localeCompare(b.name, language));
  }

  /** Drapeau local d'un code alpha-3, ou null. */
  function flagSrc(code) {
    const table = (root.VH.shared && root.VH.shared.ALPHA3_TO_ALPHA2) || {};
    const a2 = code && Object.prototype.hasOwnProperty.call(table, code) ? table[code] : null;
    return a2 ? `/assets/flags/${a2}.png` : null;
  }

  function detailsPath(fav) {
    const build = root.VH.shared && root.VH.shared.buildDetailsPath;
    return typeof build === 'function' ? build(fav.id, fav.name) : `/details/${Number(fav.id)}`;
  }

  /** Vignette (picture) d'un appareil ; repli sur l'illustration sans photo. */
  function thumb(url, width, height) {
    const src = url || `/assets/logo/placeholder-airplane-${lang()}.svg`;
    const attrs = { alt: '', loading: 'lazy', width: String(width), height: String(height) };
    const picture = root.VH.shared && root.VH.shared.picture;
    return picture ? picture.thumbHtml(src, attrs) : `<img src="${escapeHtml(src)}" alt="" loading="lazy" width="${width}" height="${height}">`;
  }

  function stripItemHtml(fav) {
    const id = Number(fav.id);
    return `<li class="col-item" data-morph-id="${id}">` +
      `<a class="col-item-link" href="${escapeHtml(detailsPath(fav))}">` +
      `<span class="col-item-photo" data-morph="photo">${thumb(fav.image_url, 160, 120)}</span>` +
      `<span class="col-item-name">${escapeHtml(fav.name)}</span></a></li>`;
  }

  function renderStrip(list) {
    const el = byId('col-strip');
    if (el) el.innerHTML = list.slice(0, STRIP_MAX).map(stripItemHtml).join('');
  }

  /** Pose les tailles après le rendu : les barres partent de zéro. */
  function applySizes(container, selector, prop) {
    const run = () => container.querySelectorAll(selector).forEach((bar) => {
      bar.style.setProperty(prop, bar.dataset.size);
    });
    if (typeof requestAnimationFrame === 'function') requestAnimationFrame(() => requestAnimationFrame(run));
    else run();
  }

  function renderDecades(list) {
    const el = byId('col-decades');
    const note = byId('col-undated');
    if (!el) return;
    const { trf, plural } = VH.settings.ui;
    const { decades, undated, max } = decadeStats(list);
    el.innerHTML = decades.map(({ decade, count }) => {
      const sr = trf('settings.collection_decade_sr', 'Années {decade} : {count}', { decade, count });
      return `<li class="col-decade${count ? '' : ' is-empty'}">` +
        `<span class="col-decade-count" aria-hidden="true">${count || ''}</span>` +
        `<span class="col-decade-bar" aria-hidden="true" data-size="${max ? ((count / max) * 100).toFixed(1) : 0}"></span>` +
        `<span class="col-decade-label" aria-hidden="true">${decade}</span>` +
        `<span class="sr-only">${escapeHtml(sr)}</span></li>`;
    }).join('');
    applySizes(el, '.col-decade-bar', '--col-h');
    if (note) {
      note.hidden = undated === 0;
      note.textContent = undated
        ? trf(plural('settings.collection_undated', undated), '{count} sans date de mise en service', { count: undated })
        : '';
    }
  }

  function renderCountries(list) {
    const el = byId('col-countries');
    if (!el) return;
    const { trf, plural } = VH.settings.ui;
    const all = countryStats(list, lang());
    const shown = all.slice(0, COUNTRY_MAX);
    const max = shown.length ? shown[0].count : 1;
    const rows = shown.map((c) => {
      const flag = flagSrc(c.code);
      return '<li class="col-country">' +
        (flag ? `<img class="col-flag" src="${flag}" alt="" width="24" height="18" loading="lazy">` : '<span class="col-flag" aria-hidden="true"></span>') +
        `<span class="col-country-name">${escapeHtml(c.name)}</span>` +
        `<span class="col-country-track" aria-hidden="true"><span class="col-country-fill" data-size="${((c.count / max) * 100).toFixed(1)}%"></span></span>` +
        `<span class="col-country-count">${c.count}</span></li>`;
    });
    const rest = all.length - shown.length;
    if (rest > 0) {
      const text = trf(plural('settings.collection_more_countries', rest), '+ {count} autres pays', { count: rest });
      rows.push(`<li class="col-country-more">${escapeHtml(text)}</li>`);
    }
    el.innerHTML = rows.join('');
    applySizes(el, '.col-country-fill', '--col-w');
  }

  /** Dernière fiche consultée : visible dès qu'elle existe, favori ou non. */
  function renderLastViewed() {
    const box = byId('col-last');
    const body = byId('col-last-body');
    if (!box || !body) return;
    const last = root.VH.lastViewed ? root.VH.lastViewed.read() : null;
    box.hidden = !last;
    if (!last) { body.innerHTML = ''; return; }
    body.innerHTML = `<a class="col-last-link" data-morph-id="${last.id}" href="${escapeHtml(detailsPath(last))}">` +
      `<span class="col-last-photo" data-morph="photo">${thumb(last.image_url, 96, 72)}</span>` +
      `<span class="col-last-name">${escapeHtml(last.name)}</span>` +
      '<i class="fas fa-arrow-right" aria-hidden="true"></i></a>';
  }

  function setStatus(key, fallback) {
    const el = byId('col-status');
    if (!el) return;
    el.textContent = key ? VH.settings.ui.tr(key, fallback) : '';
    el.hidden = !key;
  }

  /** Rendu complet à partir de la liste des favoris. */
  function render(list) {
    const items = Array.isArray(list) ? list : [];
    const content = byId('col-content');
    const empty = byId('col-empty');
    setStatus(null);
    if (content) content.hidden = items.length === 0;
    if (empty) empty.hidden = items.length !== 0;
    if (items.length) {
      renderStrip(items);
      renderDecades(items);
      renderCountries(items);
    }
    renderLastViewed();
  }

  async function load() {
    setStatus('settings.collection_loading', 'Chargement de votre collection…');
    renderLastViewed();
    try {
      const response = await auth.authFetch(`${VH.settings.ui.API_BASE}/favorites`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const body = await response.json();
      favorites = Array.isArray(body) ? body : [];
      render(favorites);
      VH.settings.identity?.setFavoriteCount(favorites.length);
    } catch {
      setStatus('settings.collection_error', 'Impossible de charger votre collection.');
    }
  }

  function init() {
    // Changement de langue : noms de pays et libellés, sans nouvelle requête.
    window.addEventListener('langChanged', () => {
      if (favorites) render(favorites);
    });
  }

  VH.settings.collection = {
    yearOf, decadeStats, countryStats, flagSrc, render, renderLastViewed, load, init,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.collection;
  }
})();
