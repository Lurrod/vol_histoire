/* Connexion — panneau gauche : une grande photo en vol, tirée au hasard
 * dans une courte sélection de clichés du domaine public choisis à l'œil
 * (appareil en vol, cadrage qui supporte un recadrage portrait). Légende :
 * nom et pays, lien vers la fiche, crédit (VH.shared.photoCredit).
 * La fiche est retrouvée par son nom exact — les identifiants diffèrent
 * d'une base à l'autre. Sans réseau ou sans fiche : fond seul, sans erreur. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  const SHOWCASE = [
    'F/A-18E Super Hornet',
    'F-15 Eagle',
    'F-117 Nighthawk',
    'B-21 Raider',
    'X-47B',
  ];

  function choose(rand = Math.random) {
    return SHOWCASE[Math.min(SHOWCASE.length - 1, Math.floor(rand() * SHOWCASE.length))];
  }

  // auth.fetchWithTimeout ajoute ?lang= (pays traduit en anglais).
  function defaultFetch(url) {
    return typeof auth !== 'undefined' && typeof auth.fetchWithTimeout === 'function'
      ? auth.fetchWithTimeout(url)
      : window.fetch(url);
  }

  async function getJson(fetchImpl, url) {
    const res = await fetchImpl(url);
    if (!res || !res.ok) return null;
    return res.json();
  }

  function render(panel, a) {
    const media = panel.querySelector('.auth-photo-media');
    if (media) {
      const picture = root.VH.shared && root.VH.shared.picture;
      media.innerHTML = picture
        ? picture.pictureHtml(a.image_url, { alt: '', decoding: 'async' })
        : '';
      const img = media.querySelector('img');
      const reveal = () => media.classList.add('is-loaded');
      if (img) {
        if (img.complete && img.naturalWidth > 0) reveal();
        else img.addEventListener('load', reveal, { once: true });
      }
    }
    const caption = panel.querySelector('.auth-photo-caption');
    if (caption) {
      const set = (sel, text) => { const el = caption.querySelector(sel); if (el) el.textContent = text || ''; };
      set('.auth-photo-name', a.name);
      set('.auth-photo-country', a.country_name);
      const link = caption.querySelector('.auth-photo-link');
      if (link) link.setAttribute('href', `/details?id=${encodeURIComponent(a.id)}`);
      const credit = caption.querySelector('.auth-photo-credit');
      const pc = root.VH.shared && root.VH.shared.photoCredit;
      if (credit && pc) pc.fillCredit(credit, { author: a.image_credit, licence: a.image_licence }, (k) => i18n.t(k));
      caption.hidden = false;
    }
    panel.classList.add('has-photo');
  }

  async function load(panel, fetchImpl = defaultFetch, rand = Math.random) {
    if (!panel) return;
    try {
      const name = choose(rand);
      const list = await getJson(fetchImpl, `/api/airplanes?search=${encodeURIComponent(name)}&limit=10`);
      const hit = list && Array.isArray(list.data) && list.data.find(a => a && a.name === name);
      if (!hit) return;
      const body = await getJson(fetchImpl, `/api/airplanes/${encodeURIComponent(hit.id)}`);
      const a = body && (body.data || body);
      if (!a || !a.image_url) return;
      render(panel, a);
    } catch {
      /* décoratif : le fond seul suffit */
    }
  }

  const api = { SHOWCASE, choose, load };
  root.VH.login.visual = api;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
