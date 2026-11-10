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
    <p id="credits-status" hidden></p>
    <section id="credits-table-wrap" hidden><table><tbody id="credits-body"></tbody></table></section>`;
  const DATA = [
    { id: 30, name: 'Rafale', name_en: 'Rafale', image_credit: 'Rob Schleiffert', image_licence: 'CC BY-SA 2.0' },
    { id: 12, name: 'F-22 Raptor', name_en: 'F-22 Raptor', image_credit: 'USAF', image_licence: 'Public domain' },
    { id: 7, name: 'Sans crédit', image_credit: null, image_licence: null },
    { id: 9, name: 'Alizé', name_en: 'Alize', image_credit: null, image_licence: 'CC0' },
  ];
  const ok = (body) => () => Promise.resolve({ ok: true, json: () => Promise.resolve(body) });

  beforeEach(() => {
    document.body.innerHTML = PAGE;
    global.i18n.currentLang = 'fr';
  });

  test('normalise : écarte les fiches sans crédit, trie par nom, accepte { data }', () => {
    expect(credits.normalizeCredits(DATA).map((c) => c.id)).toEqual([9, 12, 30]);
    expect(credits.normalizeCredits({ data: DATA })).toHaveLength(3);
    expect(credits.normalizeCredits(null)).toEqual([]);
  });

  test('chargement : une ligne par photo, lien vers la fiche, lien de licence, modifications', async () => {
    const fetchImpl = jest.fn(ok(DATA));
    await credits.load(fetchImpl);
    expect(fetchImpl).toHaveBeenCalledWith('/api/credits');
    const rows = Array.from(document.querySelectorAll('#credits-body tr'));
    expect(rows).toHaveLength(3);
    const rafale = rows.find((r) => r.textContent.includes('Rafale'));
    const cells = rafale.querySelectorAll('td');
    expect(cells[0].querySelector('a').getAttribute('href')).toBe('/details/rafale-30');
    expect(cells[1].textContent).toBe('Rob Schleiffert');
    expect(cells[2].querySelector('a').getAttribute('href')).toBe('https://creativecommons.org/licenses/by-sa/2.0/');
    expect(cells[3].textContent).not.toBe('');
    const raptor = rows.find((r) => r.textContent.includes('F-22'));
    expect(raptor.querySelectorAll('td')[2].textContent).toBe('Domaine public');
    expect(raptor.querySelectorAll('td')[3].textContent).toBe('');
    expect(document.getElementById('credits-table-wrap').hidden).toBe(false);
    expect(document.getElementById('credits-status').hidden).toBe(true);
  });

  test('anglais : nom anglais affiché', async () => {
    global.i18n.currentLang = 'en';
    await credits.load(jest.fn(ok(DATA)));
    expect(document.getElementById('credits-body').textContent).toContain('Alize');
  });

  test('erreur HTTP ou réseau : message d\'erreur, tableau masqué', async () => {
    await credits.load(jest.fn(() => Promise.resolve({ ok: false, status: 404 })));
    const status = document.getElementById('credits-status');
    expect(status.hidden).toBe(false);
    expect(status.classList.contains('is-error')).toBe(true);
    expect(document.getElementById('credits-table-wrap').hidden).toBe(true);
    await credits.load(jest.fn(() => Promise.reject(new TypeError('Failed to fetch'))));
    expect(status.classList.contains('is-error')).toBe(true);
  });

  test('liste vide : message dédié', async () => {
    await credits.load(jest.fn(ok([])));
    expect(document.getElementById('credits-status').hidden).toBe(false);
    expect(document.getElementById('credits-table-wrap').hidden).toBe(true);
  });
});
