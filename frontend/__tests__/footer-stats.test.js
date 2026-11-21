/**
 * Tests unitaires — frontend/js/shared/footer-stats.js
 *
 * Chiffres du catalogue dans le pied de page : lus dans /api/stats quand le
 * pied approche de l'écran, ligne masquée tant qu'aucun chiffre n'est arrivé.
 */
require('../js/shared/motion');
require('../js/shared/rolling-number');

const FOOTER = `
  <footer>
    <p class="footer-stats" hidden>
      <span class="footer-stat-num" data-stat="airplanes">0</span>
      <span class="footer-stat-num" data-stat="countries">0</span>
      <span class="footer-stat-num" data-stat="wars">0</span>
    </p>
  </footer>`;

const STATS = { airplanes: 733, countries: 34, wars: 61, generations: 6 };
const read = (key) => document.querySelector(`[data-stat="${key}"] .sr-only`).textContent;

let footerStats;
let observers;

beforeEach(() => {
  jest.resetModules();
  document.body.innerHTML = FOOTER;
  delete window.auth;
  observers = [];
  window.IntersectionObserver = class {
    constructor(cb, opts) { this.cb = cb; this.opts = opts; this.targets = []; this.disconnected = false; observers.push(this); }
    observe(el) { this.targets.push(el); }
    disconnect() { this.disconnected = true; }
  };
  window.fetch = jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve(STATS) }));
  footerStats = require('../js/shared/footer-stats');
});

afterEach(() => {
  delete window.IntersectionObserver;
  delete window.fetch;
});

describe('chargement différé', () => {
  test('aucune requête avant que le pied de page approche de l’écran', () => {
    expect(observers).toHaveLength(1);
    expect(observers[0].targets[0].tagName).toBe('FOOTER');
    expect(window.fetch).not.toHaveBeenCalled();
  });

  test('à l’approche : une seule requête, puis l’observateur se retire', async () => {
    const io = observers[0];
    io.cb([{ isIntersecting: true }]);
    io.cb([{ isIntersecting: true }]);
    await new Promise((r) => setTimeout(r, 0));
    expect(window.fetch).toHaveBeenCalledTimes(1);
    expect(window.fetch).toHaveBeenCalledWith('/api/stats');
    expect(io.disconnected).toBe(true);
  });

  test('passe par auth.fetchWithTimeout quand il existe', async () => {
    window.auth = { fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: true, json: () => Promise.resolve(STATS) })) };
    await footerStats.load(document.querySelector('.footer-stats'));
    expect(window.auth.fetchWithTimeout).toHaveBeenCalledWith('/api/stats');
    expect(window.fetch).not.toHaveBeenCalled();
  });
});

describe('affichage', () => {
  test('les trois chiffres arrivent en odomètre et la ligne s’affiche', async () => {
    const line = document.querySelector('.footer-stats');
    await expect(footerStats.load(line)).resolves.toBe(true);
    expect(line.hidden).toBe(false);
    expect(read('airplanes')).toBe('733');
    expect(read('countries')).toBe('34');
    expect(read('wars')).toBe('61');
  });

  test('réponse en erreur : la ligne reste masquée', async () => {
    window.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 500 }));
    const line = document.querySelector('.footer-stats');
    await expect(footerStats.load(line)).resolves.toBe(false);
    expect(line.hidden).toBe(true);
  });

  test('chiffre manquant (ancienne API sans « wars ») : la ligne reste masquée', () => {
    const line = document.querySelector('.footer-stats');
    expect(footerStats.fill(line, { airplanes: 733, countries: 34 })).toBe(false);
    expect(line.hidden).toBe(true);
  });

  test('sans odomètre : texte brut', () => {
    const roll = window.VH.rollingNumber;
    delete window.VH.rollingNumber;
    const line = document.querySelector('.footer-stats');
    expect(footerStats.fill(line, STATS)).toBe(true);
    expect(document.querySelector('[data-stat="wars"]').textContent).toBe('61');
    window.VH.rollingNumber = roll;
  });

  test('sans IntersectionObserver : chargement immédiat', async () => {
    delete window.IntersectionObserver;
    jest.resetModules();
    document.body.innerHTML = FOOTER;
    require('../js/shared/footer-stats');
    await new Promise((r) => setTimeout(r, 0));
    expect(window.fetch).toHaveBeenCalledTimes(1);
  });

  test('page sans pied de page : rien ne se passe', () => {
    document.body.innerHTML = '';
    expect(footerStats.init(document)).toBeNull();
  });
});
