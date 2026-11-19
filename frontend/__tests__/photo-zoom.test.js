/**
 * Tests — frontend/js/details/photo-zoom.js
 * jsdom : <dialog> sans showModal/close, ni View Transitions, ni décodage
 * d'image — simulés.
 */
const { loadMotion, EXIT_MS } = require('./helpers/motion-env');

let pz;

function fakeVt() {
  let end;
  const vt = { finished: new Promise((r) => { end = r; }) };
  vt.end = () => end();
  return vt;
}
const flush = () => new Promise((r) => setTimeout(r, 0));

function setNatural(img, w) {
  Object.defineProperty(img, 'naturalWidth', { configurable: true, get: () => w });
}

function boot({ src = '/assets/airplanes/rafale.avif', natural = 1600, credit = 'Photo : Armée de l\'air — CC BY 4.0', complete = true } = {}) {
  jest.resetModules();
  window.VH = {};
  loadMotion(['.det-zoom.is-closing']);
  window.i18n = { t: (k) => (k === 'details.photo_zoom' ? 'Agrandir la photo' : k) };
  document.body.innerHTML =
    '<div class="aircraft-image-container" data-morph="photo"><picture><img id="hero-image" alt="Rafale" src="' + src + '"></picture></div>' +
    '<p class="image-credit" id="image-credit"' + (credit ? '' : ' hidden') + '>' + (credit || '') + '</p>';
  const img = document.getElementById('hero-image');
  setNatural(img, natural);
  Object.defineProperty(img, 'complete', { configurable: true, get: () => complete });
  require('../js/details/photo-zoom');
  pz = window.VH.details.photoZoom;
  return img;
}

beforeAll(() => {
  window.HTMLDialogElement.prototype.showModal = function () { this.setAttribute('open', ''); };
  window.HTMLDialogElement.prototype.close = function () { this.removeAttribute('open'); };
  window.HTMLImageElement.prototype.decode = function () { return Promise.resolve(); };
});

afterEach(() => {
  delete document.startViewTransition;
  delete window.i18n;
  jest.useRealTimers();
});

const btn = () => document.querySelector('.det-zoom-btn');
const dlg = () => document.querySelector('dialog.det-zoom');

test('bouton posé sur la photo, nommé ; masqué tant que la photo n\'est pas réelle', () => {
  const img = boot({ src: '/assets/logo/placeholder-airplane-fr.svg' });
  const ctl = pz.setup();
  expect(ctl).not.toBeNull();
  expect(btn().hidden).toBe(true);
  expect(btn().getAttribute('aria-label')).toBe('Agrandir la photo');
  // La vraie photo arrive : le bouton apparaît.
  img.setAttribute('src', '/assets/airplanes/rafale.avif');
  img.dispatchEvent(new window.Event('load'));
  expect(btn().hidden).toBe(false);
  // Un second setup ne double pas le bouton.
  expect(pz.setup()).toBeNull();
  expect(document.querySelectorAll('.det-zoom-btn')).toHaveLength(1);
});

test('isRealPhoto : image d\'attente, illustration ou image vide refusées', () => {
  boot();
  const img = document.createElement('img');
  img.setAttribute('src', 'data:image/gif;base64,R0lGOD');
  setNatural(img, 1);
  expect(pz.isRealPhoto(img)).toBe(false);
  img.setAttribute('src', '/x.avif');
  setNatural(img, 0);
  expect(pz.isRealPhoto(img)).toBe(false);
  setNatural(img, 800);
  expect(pz.isRealPhoto(img)).toBe(true);
});

test('sans hero : aucun bouton', () => {
  boot();
  document.body.innerHTML = '';
  expect(pz.setup()).toBeNull();
});

test('sans View Transitions : ouverture en fondu, crédit repris ; Échap ferme par la sortie animée', async () => {
  boot();
  const ctl = pz.setup();
  btn().click();
  await flush();
  expect(dlg().open).toBe(true);
  expect(dlg().classList.contains('is-morph')).toBe(false);
  expect(dlg().getAttribute('aria-label')).toBe('Rafale');
  expect(dlg().querySelector('.det-zoom-img').getAttribute('src')).toContain('rafale.avif');
  expect(dlg().querySelector('.det-zoom-credit').textContent).toBe('Photo : Armée de l\'air — CC BY 4.0');
  expect(dlg().querySelector('.det-zoom-close').getAttribute('aria-label')).toBe('Fermer'); // clé absente : repli

  jest.useFakeTimers();
  const cancel = new window.Event('cancel', { cancelable: true });
  dlg().dispatchEvent(cancel);
  expect(cancel.defaultPrevented).toBe(true);
  expect(dlg().classList.contains('is-closing')).toBe(true);
  ctl.close(); // seconde fermeture pendant la sortie : ignorée
  jest.advanceTimersByTime(EXIT_MS + 50);
  expect(dlg().open).toBe(false);
});

test('clic sur le fond ou la croix : fermeture ; clic sur la photo : rien', async () => {
  boot({ credit: '' });
  pz.setup();
  btn().click();
  await flush();
  expect(dlg().querySelector('.det-zoom-credit').hidden).toBe(true);
  jest.useFakeTimers();
  dlg().querySelector('.det-zoom-img').click();
  expect(dlg().classList.contains('is-closing')).toBe(false);
  dlg().querySelector('.det-zoom-close').click();
  jest.advanceTimersByTime(EXIT_MS + 50);
  expect(dlg().open).toBe(false);
});

test('avec View Transitions : la photo du hero devient celle du plein écran, et retour', async () => {
  const hero = boot();
  const ctl = pz.setup();
  const vts = [];
  const namesSeen = [];
  document.startViewTransition = jest.fn((cb) => {
    namesSeen.push(['avant', hero.style.viewTransitionName]);
    cb();
    const vt = fakeVt();
    vts.push(vt);
    return vt;
  });

  await ctl.open();
  const big = dlg().querySelector('.det-zoom-img');
  expect(namesSeen[0]).toEqual(['avant', 'vh-zoom']);
  expect(hero.style.viewTransitionName).toBe('');
  expect(big.style.viewTransitionName).toBe('vh-zoom');
  expect(dlg().open).toBe(true);
  expect(dlg().classList.contains('is-morph')).toBe(true);
  // Pendant la transition : ni réouverture, ni fermeture.
  await ctl.open();
  ctl.close();
  expect(document.startViewTransition).toHaveBeenCalledTimes(1);
  vts[0].end();
  await flush();
  expect(big.style.viewTransitionName).toBe('');

  ctl.close();
  expect(dlg().open).toBe(false);
  expect(hero.style.viewTransitionName).toBe('vh-zoom');
  vts[1].end();
  await flush();
  expect(hero.style.viewTransitionName).toBe('');
});

test('changement de langue : libellés relus ; image pas encore chargée : bouton masqué', () => {
  boot({ complete: false });
  pz.setup();
  expect(btn().hidden).toBe(true);
  window.i18n.t = (k) => (k === 'details.photo_zoom' ? 'Enlarge photo' : k);
  window.dispatchEvent(new window.Event('langChanged'));
  expect(btn().getAttribute('aria-label')).toBe('Enlarge photo');
});
