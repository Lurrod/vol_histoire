/**
 * Tests — attribution des photographies (LEGAL-003) :
 *   js/shared/photo-credit.js (licence → URL, légende avec liens),
 *   js/details/render.js (légende du hero),
 *   js/credits.js (page « Crédits photo »).
 */
const dict = {
  'details.photo': 'Photo',
  'details.licence_public_domain': 'Domaine public',
  'details.photo_modified': 'image modifiée (redimensionnement, conversion)',
};
global.i18n = { t: (k) => (k in dict ? dict[k] : k), currentLang: 'fr' };
window.i18n = global.i18n;
global.escapeHtml = (s) => String(s == null ? '' : s);

window.VH = {};
const photoCredit = require('../js/shared/photo-credit');
require('../js/shared/card');
const render = require('../js/details/render');
const credits = require('../js/credits');

const t = (k) => global.i18n.t(k);

describe('licenceUrl : texte canonique de chaque licence présente en base', () => {
  test.each([
    ['CC BY-SA 4.0', 'https://creativecommons.org/licenses/by-sa/4.0/'],
    ['CC BY-SA 2.0', 'https://creativecommons.org/licenses/by-sa/2.0/'],
    ['CC BY 2.0', 'https://creativecommons.org/licenses/by/2.0/'],
    ['CC BY-SA 3.0', 'https://creativecommons.org/licenses/by-sa/3.0/'],
    ['CC BY 4.0', 'https://creativecommons.org/licenses/by/4.0/'],
    ['CC BY 3.0', 'https://creativecommons.org/licenses/by/3.0/'],
    ['CC BY 2.5', 'https://creativecommons.org/licenses/by/2.5/'],
    ['CC BY-SA 3.0 au', 'https://creativecommons.org/licenses/by-sa/3.0/au/'],
    ['CC BY 3.0 de', 'https://creativecommons.org/licenses/by/3.0/de/'],
    ['CC0', 'https://creativecommons.org/publicdomain/zero/1.0/'],
    ['KOGL Type 1', 'https://www.kogl.or.kr/info/licenseType1.do'],
    ['OGL v1.0', 'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/1/'],
    ['GFDL 1.2', 'https://www.gnu.org/licenses/old-licenses/fdl-1.2.html'],
  ])('%s → %s', (licence, url) => {
    expect(photoCredit.licenceUrl(licence)).toBe(url);
  });

  test('domaine public, valeur inconnue ou absente : pas de lien', () => {
    expect(photoCredit.licenceUrl('Public domain')).toBeNull();
    expect(photoCredit.licenceUrl('PDM-owner')).toBeNull();
    expect(photoCredit.licenceUrl('Tous droits réservés')).toBeNull();
    expect(photoCredit.licenceUrl(null)).toBeNull();
  });

  test('attribution exigée (donc mention des modifications) pour CC BY* et KOGL, pas pour PD / CC0', () => {
    expect(photoCredit.requiresAttribution('CC BY-SA 3.0 au')).toBe(true);
    expect(photoCredit.requiresAttribution('KOGL Type 1')).toBe(true);
    expect(photoCredit.requiresAttribution('OGL v1.0')).toBe(true);
    expect(photoCredit.requiresAttribution('GFDL 1.2')).toBe(true);
    expect(photoCredit.requiresAttribution('CC0')).toBe(false);
    expect(photoCredit.requiresAttribution('Public domain')).toBe(false);
  });
});

describe('fillCredit : légende construite en DOM, jamais en HTML', () => {
  test('CC BY-SA : auteur, lien de licence (rel=license), mention des modifications', () => {
    const el = document.createElement('p');
    expect(photoCredit.fillCredit(el, { author: 'Rob Schleiffert', licence: 'CC BY-SA 2.0' }, t)).toBe(true);
    expect(el.textContent).toBe('Photo : Rob Schleiffert — CC BY-SA 2.0 — image modifiée (redimensionnement, conversion)');
    const link = el.querySelector('a');
    expect(link.href).toBe('https://creativecommons.org/licenses/by-sa/2.0/');
    expect(link.rel).toBe('license noopener');
  });

  test('domaine public : libellé traduit, sans lien ni mention', () => {
    const el = document.createElement('p');
    photoCredit.fillCredit(el, { author: 'USAF', licence: 'Public domain' }, t);
    expect(el.textContent).toBe('Photo : USAF — Domaine public');
    expect(el.querySelector('a')).toBeNull();
  });

  test('auteur contenant du balisage : rendu comme texte', () => {
    const el = document.createElement('p');
    photoCredit.fillCredit(el, { author: '<img src=x onerror=alert(1)>', licence: null }, t);
    expect(el.querySelector('img')).toBeNull();
    expect(el.textContent).toBe('Photo : <img src=x onerror=alert(1)>');
  });

  test('ni auteur ni licence : vide, false', () => {
    const el = document.createElement('p');
    el.textContent = 'ancien';
    expect(photoCredit.fillCredit(el, { author: '', licence: null }, t)).toBe(false);
    expect(el.textContent).toBe('');
  });
});

describe('renderImageCredit (hero de la fiche) avec le module partagé', () => {
  beforeEach(() => { document.body.innerHTML = '<p id="image-credit" hidden></p>'; });

  test('légende avec lien vers la licence', () => {
    render.renderImageCredit({ image_credit: 'Mike McBey', image_licence: 'CC BY 2.0' });
    const el = document.getElementById('image-credit');
    expect(el.hidden).toBe(false);
    expect(el.querySelector('a').getAttribute('href')).toBe('https://creativecommons.org/licenses/by/2.0/');
    expect(el.textContent).toContain('image modifiée');
  });

  test('rien à afficher : masquée', () => {
    render.renderImageCredit({ image_credit: null, image_licence: null });
    expect(document.getElementById('image-credit').hidden).toBe(true);
  });
});

describe('page Crédits photo (credits.js)', () => {
  const PAGE = `
    <div id="credits-tools" hidden>
      <input type="search" id="credits-search">
      <button class="credits-filter" data-family="all" aria-pressed="true"><span class="credits-filter-count"></span></button>
      <button class="credits-filter" data-family="free" aria-pressed="false"><span class="credits-filter-count"></span></button>
      <button class="credits-filter" data-family="cc" aria-pressed="false"><span class="credits-filter-count"></span></button>
      <button class="credits-filter" data-family="other" aria-pressed="false"><span class="credits-filter-count"></span></button>
      <button class="credits-filter" data-family="none" aria-pressed="false"><span class="credits-filter-count"></span></button>
    </div>
    <p id="credits-status" hidden></p>
    <p id="credits-result" hidden></p>
    <div id="credits-list" hidden></div>
    <div id="credits-none" hidden><button id="credits-reset"></button></div>`;
  const DATA = [
    { id: 30, name: 'Rafale', name_en: 'Rafale', image_url: '/assets/airplanes/rafale.jpg', image_credit: 'Rob Schleiffert', image_licence: 'CC BY-SA 2.0' },
    { id: 12, name: 'F-22 Raptor', name_en: 'F-22 Raptor', image_url: '/assets/airplanes/f22-raptor.jpg', image_credit: 'USAF', image_licence: 'Public domain' },
    { id: 7, name: 'Sans crédit', image_url: null, image_credit: null, image_licence: null },
    { id: 9, name: 'Alizé', name_en: 'Alize', image_url: '/assets/airplanes/alize.jpg', image_credit: null, image_licence: 'CC0' },
  ];
  const ok = (body) => () => Promise.resolve({ ok: true, json: () => Promise.resolve(body) });
  const items = () => Array.from(document.querySelectorAll('#credits-list .credit'));
  const visible = () => items().filter((li) => !li.hidden);
  const filterButton = (family) => document.querySelector(`.credits-filter[data-family="${family}"]`);

  beforeEach(() => {
    document.body.innerHTML = PAGE;
    global.i18n.currentLang = 'fr';
    Object.assign(credits.state, { q: '', family: 'all' });
    window.history.replaceState(null, '', '/credits');
  });

  afterEach(() => {
    delete window.VH.shared.picture;
  });

  test('normalise : garde toutes les fiches, trie par nom, accepte { data }', () => {
    expect(credits.normalizeCredits(DATA).map((c) => c.id)).toEqual([9, 12, 30, 7]);
    expect(credits.normalizeCredits({ data: DATA })).toHaveLength(4);
    expect(credits.normalizeCredits([null, { name: 'sans id' }])).toEqual([]);
    expect(credits.normalizeCredits(null)).toEqual([]);
  });

  test('familles de licence', () => {
    expect(credits.licenceFamily('Public domain')).toBe('free');
    expect(credits.licenceFamily('PDM-owner')).toBe('free');
    expect(credits.licenceFamily('CC0')).toBe('free');
    expect(credits.licenceFamily('CC BY-SA 3.0 au')).toBe('cc');
    expect(credits.licenceFamily('OGL v1.0')).toBe('other');
    expect(credits.licenceFamily('KOGL Type 1')).toBe('other');
    expect(credits.licenceFamily('  ')).toBe('none');
    expect(credits.licenceFamily(null)).toBe('none');
  });

  test('texte de recherche replié et lettre de groupe', () => {
    expect(credits.fold('F-16 Fighting Falcon')).toBe('f16fightingfalcon');
    expect(credits.fold('Alizé')).toBe('alize');
    expect(credits.fold(null)).toBe('');
    expect(credits.letterOf('Étendard IV')).toBe('E');
    expect(credits.letterOf('2000')).toBe('#');
    expect(credits.letterOf('')).toBe('#');
  });

  test('chargement : groupes par lettre, une ligne par photo, liens, licence, modifications', async () => {
    const fetchImpl = jest.fn(ok(DATA));
    await credits.load(fetchImpl);
    expect(fetchImpl).toHaveBeenCalledWith('/api/credits');
    expect(Array.from(document.querySelectorAll('.credits-letter')).map((h) => h.textContent)).toEqual(['A', 'F', 'R', 'S']);
    expect(items()).toHaveLength(4);

    const rafale = items().find((li) => li.textContent.includes('Rafale'));
    expect(rafale.dataset.family).toBe('cc');
    expect(rafale.querySelector('.credit-name').getAttribute('href')).toBe('/details/rafale-30');
    expect(rafale.querySelector('.credit-thumb').getAttribute('aria-hidden')).toBe('true');
    expect(rafale.querySelector('.credit-author').textContent).toBe('Rob Schleiffert');
    const badge = rafale.querySelector('.credit-badge');
    expect(badge.getAttribute('href')).toBe('https://creativecommons.org/licenses/by-sa/2.0/');
    expect(badge.rel).toBe('license noopener');
    expect(rafale.querySelector('.credit-modified')).not.toBeNull();

    const raptor = items().find((li) => li.textContent.includes('F-22'));
    expect(raptor.querySelector('.credit-badge').textContent).toBe('Domaine public');
    expect(raptor.querySelector('.credit-badge').classList.contains('credit-badge--free')).toBe(true);
    expect(raptor.querySelector('.credit-modified')).toBeNull();

    const alize = items().find((li) => li.textContent.includes('Alizé'));
    expect(alize.querySelector('.credit-author').classList.contains('is-muted')).toBe(true);

    const undocumented = items().find((li) => li.textContent.includes('Sans crédit'));
    expect(undocumented.dataset.family).toBe('none');
    expect(undocumented.querySelector('.credit-claim').getAttribute('href')).toBe('/contact?sujet=bug&fiche=7');
    expect(undocumented.querySelector('.credit-thumb img')).toBeNull();
    expect(undocumented.querySelector('.credit-badge--none')).not.toBeNull();

    expect(document.getElementById('credits-list').hidden).toBe(false);
    expect(document.getElementById('credits-tools').hidden).toBe(false);
    expect(document.getElementById('credits-status').hidden).toBe(true);
    expect(document.getElementById('credits-result').textContent).toBe('4 photos');
    expect(filterButton('cc').querySelector('.credits-filter-count').textContent).toBe('1');
    expect(filterButton('free').querySelector('.credits-filter-count').textContent).toBe('2');
    // Aucune licence « autre » : bouton masqué
    expect(filterButton('other').hidden).toBe(true);
  });

  test('vignettes : sources AVIF / WebP de la vignette, photo pleine en repli', async () => {
    window.VH.shared.picture = {
      getThumbSources: (url) => ({ avif: '/thumbs/x.avif', webp: '/thumbs/x.webp', fallback: url }),
    };
    await credits.load(jest.fn(ok(DATA)));
    const rafale = items().find((li) => li.textContent.includes('Rafale'));
    const sources = rafale.querySelectorAll('.credit-thumb source');
    expect(Array.from(sources).map((el) => el.type)).toEqual(['image/avif', 'image/webp']);
    const img = rafale.querySelector('.credit-thumb img');
    expect(img.getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
    expect(img.getAttribute('loading')).toBe('lazy');
    expect(img.alt).toBe('');
  });

  test('sans module d\'images : simple <img> de la photo', async () => {
    await credits.load(jest.fn(ok(DATA)));
    const raptor = items().find((li) => li.textContent.includes('F-22'));
    expect(raptor.querySelector('.credit-thumb picture')).toBeNull();
    expect(raptor.querySelector('.credit-thumb img').getAttribute('src')).toBe('/assets/airplanes/f22-raptor.jpg');
  });

  test('recherche (sans accents ni tirets) et filtre de famille, reflétés dans l\'adresse', async () => {
    credits.bindControls('');
    await credits.load(jest.fn(ok(DATA)));
    const input = document.getElementById('credits-search');

    input.value = 'f22';
    input.dispatchEvent(new window.Event('input'));
    expect(visible().map((li) => li.querySelector('.credit-name').textContent)).toEqual(['F-22 Raptor']);
    expect(document.getElementById('credits-result').textContent).toBe('1 photo sur 4');
    expect(window.location.search).toBe('?q=f22');
    // Groupes sans résultat masqués
    expect(Array.from(document.querySelectorAll('.credits-group')).filter((g) => !g.hidden)).toHaveLength(1);

    input.value = 'schleiffert';
    input.dispatchEvent(new window.Event('input'));
    expect(visible()).toHaveLength(1);

    input.value = '';
    input.dispatchEvent(new window.Event('input'));
    filterButton('free').click();
    expect(visible()).toHaveLength(2);
    expect(filterButton('free').getAttribute('aria-pressed')).toBe('true');
    expect(filterButton('all').getAttribute('aria-pressed')).toBe('false');
    expect(document.getElementById('credits-result').textContent).toBe('2 photos sur 4');
    expect(window.location.search).toBe('?licence=free');
  });

  test('aucun résultat : message et remise à zéro', async () => {
    credits.bindControls('');
    await credits.load(jest.fn(ok(DATA)));
    const input = document.getElementById('credits-search');
    input.value = 'zzzz';
    input.dispatchEvent(new window.Event('input'));
    filterButton('cc').click();
    expect(visible()).toHaveLength(0);
    expect(document.getElementById('credits-none').hidden).toBe(false);
    document.getElementById('credits-reset').click();
    expect(input.value).toBe('');
    expect(credits.state).toEqual({ q: '', family: 'all' });
    expect(visible()).toHaveLength(4);
    expect(document.getElementById('credits-none').hidden).toBe(true);
    expect(window.location.search).toBe('');
  });

  test('vue de départ lue dans l\'adresse ; famille inconnue ignorée', async () => {
    expect(credits.readUrlState('?licence=bidon&q=x')).toEqual({ q: 'x', family: 'all' });
    expect(credits.readUrlState('')).toEqual({ q: '', family: 'all' });
    credits.bindControls('?q=rafale&licence=cc');
    expect(document.getElementById('credits-search').value).toBe('rafale');
    await credits.load(jest.fn(ok(DATA)));
    expect(visible()).toHaveLength(1);
    expect(filterButton('cc').getAttribute('aria-pressed')).toBe('true');
  });

  test('l\'adresse garde les autres paramètres (?lang=)', () => {
    window.history.replaceState(null, '', '/credits?lang=en');
    credits.writeUrlState({ q: 'mig', family: 'cc' });
    expect(window.location.search).toBe('?lang=en&q=mig&licence=cc');
    credits.writeUrlState({ q: '', family: 'all' });
    expect(window.location.search).toBe('?lang=en');
  });

  test('anglais : nom anglais affiché, nouveau rendu sans nouvelle requête', async () => {
    const fetchImpl = jest.fn(ok(DATA));
    await credits.load(fetchImpl);
    global.i18n.currentLang = 'en';
    credits.rerender();
    expect(fetchImpl).toHaveBeenCalledTimes(1);
    expect(document.getElementById('credits-list').textContent).toContain('Alize');
  });

  test('erreur HTTP ou réseau : message d\'erreur, liste et outils masqués', async () => {
    await credits.load(jest.fn(ok(DATA)));
    await credits.load(jest.fn(() => Promise.resolve({ ok: false, status: 404 })));
    const status = document.getElementById('credits-status');
    expect(status.hidden).toBe(false);
    expect(status.classList.contains('is-error')).toBe(true);
    expect(document.getElementById('credits-list').hidden).toBe(true);
    expect(document.getElementById('credits-tools').hidden).toBe(true);
    expect(document.getElementById('credits-result').hidden).toBe(true);
    await credits.load(jest.fn(() => Promise.reject(new TypeError('Failed to fetch'))));
    expect(status.classList.contains('is-error')).toBe(true);
  });

  test('liste vide : message dédié', async () => {
    await credits.load(jest.fn(ok([])));
    expect(document.getElementById('credits-status').hidden).toBe(false);
    expect(document.getElementById('credits-list').hidden).toBe(true);
    expect(document.getElementById('credits-none').hidden).toBe(true);
  });

  test('sans conteneur de liste : ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => credits.render(credits.normalizeCredits(DATA))).not.toThrow();
    expect(() => credits.applyView()).not.toThrow();
  });
});
