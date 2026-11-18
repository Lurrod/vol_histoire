/* Favoris sans session — panneau de gauche : un aperçu de collection.
 * Trois vraies fiches du catalogue (API publique), tirées au hasard parmi
 * celles qui ont une photo, posées en éventail dans des cadres marqués d'un
 * cœur (favorites.css, « AUTH GATE »). Décoratif : le conteneur est
 * aria-hidden, le texte de droite porte le message. En cas d'échec réseau,
 * les cadres restent vides (cœur seul). */
(function () {
  window.VH = window.VH || {};
  window.VH.favorites = window.VH.favorites || {};

  // Tirage dans une page de 100 fiches prise au hasard (le catalogue est
  // trié par nom : la première page ne montrerait que des « A… »). Une page
  // trop loin ou trop pauvre en photos retombe sur la première.
  const POOL = 100;
  const PAGES = 6; // ⌈554 / 100⌉

  /** Au plus n fiches avec photo, sans doublon, dans un ordre aléatoire. */
  function pick(list, n, rand) {
    const pool = (Array.isArray(list) ? list : []).filter(a => a && a.image_url);
    for (let i = pool.length - 1; i > 0; i--) {
      const j = Math.floor(rand() * (i + 1));
      [pool[i], pool[j]] = [pool[j], pool[i]];
    }
    return pool.slice(0, n);
  }

  function cardInner(a) {
    const photo = window.VH.shared && window.VH.shared.picture
      ? window.VH.shared.picture.thumbHtml(a.image_url, { alt: '', loading: 'lazy', width: '320', height: '200' })
      : `<img src="${escapeHtml(a.image_url)}" alt="" loading="lazy">`;
    return `<span class="gate-card-photo">${photo}</span>`
      + '<span class="gate-card-body">'
      + `<span class="gate-card-name">${escapeHtml(a.name)}</span>`
      + `<span class="gate-card-meta">${escapeHtml(a.country_name || '')}</span>`
      + '</span>';
  }

  function render(root, planes) {
    if (!root) return;
    const frames = root.querySelectorAll('.gate-card');
    frames.forEach((frame, i) => {
      const a = planes[i];
      if (!a) return;
      frame.insertAdjacentHTML('afterbegin', cardInner(a));
      frame.classList.add('is-filled');
    });
  }

  // auth.fetchWithTimeout ajoute ?lang= : en anglais, les pays arrivent
  // traduits (« United States », pas « États-Unis »).
  function defaultFetch(url) {
    // `auth` est un const global (auth.js), pas une propriété de window.
    return typeof auth !== 'undefined' && typeof auth.fetchWithTimeout === 'function'
      ? auth.fetchWithTimeout(url)
      : window.fetch(url);
  }

  async function load(root, fetchImpl = defaultFetch, rand = Math.random) {
    if (!root) return;
    const frames = root.querySelectorAll('.gate-card').length;
    const fetchPage = async (page) => {
      const res = await fetchImpl(`/api/airplanes?limit=${POOL}&page=${page}`);
      if (!res || !res.ok) return [];
      const body = await res.json();
      return pick(body && body.data, frames, rand);
    };
    try {
      const page = 1 + Math.floor(rand() * PAGES);
      let planes = await fetchPage(page);
      if (planes.length < frames && page !== 1) planes = await fetchPage(1);
      render(root, planes);
    } catch {
      /* aperçu décoratif : les cadres vides suffisent */
    } finally {
      root.classList.add('is-ready');
    }
  }

  const api = { pick, render, load };
  window.VH.favorites.gate = api;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
