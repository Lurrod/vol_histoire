/**
 * Tests — frontend/js/shared/busy-button.js
 */
let bb;

beforeEach(() => {
  jest.resetModules();
  window.VH = {};
  bb = require('../js/shared/busy-button');
  document.body.innerHTML = '<button id="b" type="submit"><i class="fas fa-save"></i> Enregistrer</button>';
  jest.spyOn(window.Element.prototype, 'getBoundingClientRect').mockReturnValue({ width: 182.5 });
});

afterEach(() => {
  jest.restoreAllMocks();
  jest.useRealTimers();
});

const btn = () => document.getElementById('b');

test('start : largeur figée, libellé gardé (lu), anneau, bouton bloqué', () => {
  bb.start(btn());
  expect(btn().style.width).toBe('182.5px');
  expect(btn().classList.contains('bb')).toBe(true);
  expect(btn().dataset.bb).toBe('busy');
  expect(btn().disabled).toBe(true);
  expect(btn().getAttribute('aria-busy')).toBe('true');
  const label = btn().querySelector(':scope > .bb-label');
  expect(label.textContent.trim()).toBe('Enregistrer');
  expect(label.querySelector('i.fa-save')).not.toBeNull();
  expect(btn().querySelector('.bb-spin').getAttribute('aria-hidden')).toBe('true');
  expect(btn().querySelector('.bb-done .bb-check')).not.toBeNull();
});

test('start répété : une seule structure, largeur d\'origine conservée', () => {
  bb.start(btn());
  window.Element.prototype.getBoundingClientRect.mockReturnValue({ width: 40 });
  bb.start(btn());
  expect(btn().querySelectorAll('.bb-label')).toHaveLength(1);
  expect(btn().style.width).toBe('182.5px');
});

test('stop : retour au repos, largeur rendue', () => {
  bb.start(btn());
  bb.stop(btn());
  expect(btn().dataset.bb).toBeUndefined();
  expect(btn().disabled).toBe(false);
  expect(btn().hasAttribute('aria-busy')).toBe(false);
  expect(btn().style.width).toBe('');
});

test('succeed : coche et texte, bouton bloqué le temps de lire, puis repos', async () => {
  jest.useFakeTimers();
  bb.start(btn());
  const done = bb.succeed(btn(), { label: 'Enregistré' });
  expect(btn().dataset.bb).toBe('done');
  expect(btn().querySelector('.bb-done-text').textContent).toBe('Enregistré');
  expect(btn().hasAttribute('aria-busy')).toBe(false);
  expect(btn().disabled).toBe(true);
  jest.advanceTimersByTime(bb.HOLD_MS - 1);
  expect(btn().dataset.bb).toBe('done');
  jest.advanceTimersByTime(1);
  await done;
  expect(btn().dataset.bb).toBeUndefined();
  expect(btn().disabled).toBe(false);
});

test('succeed sans start préalable, durée choisie ; start pendant la coche annule le retour', () => {
  jest.useFakeTimers();
  bb.succeed(btn(), { hold: 300 });
  expect(btn().style.width).toBe('182.5px');
  expect(btn().querySelector('.bb-done-text').textContent).toBe('');
  bb.start(btn());
  jest.advanceTimersByTime(1000);
  expect(btn().dataset.bb).toBe('busy');
});

test('bouton absent : rien ne lève', async () => {
  expect(() => bb.start(null)).not.toThrow();
  expect(() => bb.stop(null)).not.toThrow();
  await expect(bb.succeed(null)).resolves.toBeUndefined();
});
