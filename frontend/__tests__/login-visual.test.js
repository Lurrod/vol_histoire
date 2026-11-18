/**
 * Tests — frontend/js/login/visual.js : panneau gauche de la connexion.
 *
 * Une grande photo en vol, tirée d'une courte sélection de clichés du
 * domaine public, avec sa légende (nom, pays, lien vers la fiche) et son
 * crédit. Sans réseau ou sans fiche trouvée : pas de photo, pas d'erreur.
 */
global.i18n = { t: (k) => k, currentLang: 'fr' };
window.VH = {};
require('../js/shared/picture');
require('../js/shared/photo-credit');
const visual = require('../js/login/visual');

const F15 = { id: 159, name: 'F-15 Eagle', country_name: 'États-Unis', image_url: '/assets/airplanes/f15c-eagle.jpg', image_credit: 'Airman 1st Class Matthew Seefeldt', image_licence: 'Public domain' };

function mount() {
  document.body.innerHTML = `
    <div class="auth-visual">
      <div class="auth-photo-media" aria-hidden="true"></div>
      <p class="auth-photo-caption" hidden>
        <a class="auth-photo-link" href="/hangar"><span class="auth-photo-name"></span><span class="auth-photo-country"></span></a>
        <span class="auth-photo-credit"></span>
      </p>
    </div>`;
  return document.querySelector('.auth-visual');
}

const json = (body, ok = true) => Promise.resolve({ ok, json: () => Promise.resolve(body) });

function fakeFetch({ search = [F15, { id: 161, name: 'F-15EX Eagle II' }], detail = F15 } = {}) {
  return jest.fn((url) => (url.includes('search=') ? json({ data: search }) : json(detail)));
}

test('la sélection : des noms de fiches, tirage borné', () => {
  expect(visual.SHOWCASE.length).toBeGreaterThan(2);
  expect(visual.choose(() => 0)).toBe(visual.SHOWCASE[0]);
  expect(visual.choose(() => 0.9999)).toBe(visual.SHOWCASE[visual.SHOWCASE.length - 1]);
});

test('charge la fiche au nom exact, pose la photo, la légende et le crédit', async () => {
  const root = mount();
  const fetchImpl = fakeFetch();
  await visual.load(root, fetchImpl, () => 0.2); // SHOWCASE[1] = F-15 Eagle
  expect(fetchImpl.mock.calls[0][0]).toBe(`/api/airplanes?search=${encodeURIComponent('F-15 Eagle')}&limit=10`);
  expect(fetchImpl.mock.calls[1][0]).toBe('/api/airplanes/159');
  expect(root.querySelector('.auth-photo-media img')).not.toBeNull();
  expect(root.querySelector('.auth-photo-media img').getAttribute('alt')).toBe('');
  expect(root.querySelector('.auth-photo-name').textContent).toBe('F-15 Eagle');
  expect(root.querySelector('.auth-photo-country').textContent).toBe('États-Unis');
  expect(root.querySelector('.auth-photo-link').getAttribute('href')).toBe('/details?id=159');
  expect(root.querySelector('.auth-photo-credit').textContent).toContain('Matthew Seefeldt');
  expect(root.querySelector('.auth-photo-caption').hidden).toBe(false);
  expect(root.classList.contains('has-photo')).toBe(true);
});

test('la photo n\'apparaît qu\'une fois chargée (fondu)', async () => {
  const root = mount();
  await visual.load(root, fakeFetch(), () => 0.2);
  const media = root.querySelector('.auth-photo-media');
  expect(media.classList.contains('is-loaded')).toBe(false);
  media.querySelector('img').dispatchEvent(new Event('load'));
  expect(media.classList.contains('is-loaded')).toBe(true);
});

test('nom exact introuvable (homonymes seulement) : rien n\'est posé', async () => {
  const root = mount();
  const fetchImpl = fakeFetch({ search: [{ id: 161, name: 'F-15EX Eagle II' }] });
  await visual.load(root, fetchImpl, () => 0.2);
  expect(fetchImpl).toHaveBeenCalledTimes(1);
  expect(root.classList.contains('has-photo')).toBe(false);
  expect(root.querySelector('.auth-photo-caption').hidden).toBe(true);
});

test('réseau en échec ou réponse en erreur : aucune exception, pas de photo', async () => {
  const root = mount();
  await expect(visual.load(root, () => Promise.reject(new Error('offline')))).resolves.toBeUndefined();
  await expect(visual.load(root, () => json({}, false))).resolves.toBeUndefined();
  expect(root.classList.contains('has-photo')).toBe(false);
});

test('sans conteneur : ne fait rien', async () => {
  const fetchImpl = jest.fn();
  await visual.load(null, fetchImpl);
  expect(fetchImpl).not.toHaveBeenCalled();
});
