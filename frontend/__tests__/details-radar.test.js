/**
 * Tests DOM — frontend/js/details/radar.js
 *
 * Radar SVG des capacités : cinq axes normalisés sur des références fixes
 * (vitesse 3 529 km/h, rayon 15 000 km, 10 armements, 8 missions, 8 technos),
 * plus une légende textuelle — seule partie lue par les lecteurs d'écran,
 * le SVG étant aria-hidden.
 */

const escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

let rafQueue;

function boot(lang = 'fr', labels = {}) {
  jest.resetModules();
  document.body.innerHTML = '<div id="radar-chart"></div><div id="radar-legend"></div>';
  global.escapeHtml = escapeHtml;
  global.i18n = { t: (k) => labels[k] || k, currentLang: lang };
  rafQueue = [];
  global.requestAnimationFrame = (fn) => { rafQueue.push(fn); return rafQueue.length; };
  window.VH = {};
  require('../js/details/radar');
  return window.VH.details.radar;
}

function flushRaf() {
  while (rafQueue.length) rafQueue.shift()();
}

const items = (n) => Array.from({ length: n }, (_, i) => ({ name: `x${i}` }));

function legend() {
  return [...document.querySelectorAll('#radar-legend .radar-stat')].map((s) => ({
    label: s.querySelector('.radar-stat-label').textContent,
    value: s.querySelector('.radar-stat-value').textContent,
    pct: s.querySelector('.radar-stat-pct').textContent,
    target: s.querySelector('.radar-bar-fill').dataset.target,
  }));
}

describe('radar.render — gardes', () => {
  test('sans conteneur de graphique : ne rend rien', () => {
    const radar = boot();
    document.body.innerHTML = '<div id="radar-legend"></div>';
    radar.render({ aircraftData: { max_speed: 1 } }, [], [], []);
    expect(document.getElementById('radar-legend').innerHTML).toBe('');
  });

  test('sans légende : ne rend rien', () => {
    const radar = boot();
    document.body.innerHTML = '<div id="radar-chart"></div>';
    radar.render({ aircraftData: { max_speed: 1 } }, [], [], []);
    expect(document.getElementById('radar-chart').innerHTML).toBe('');
  });

  test('sans données d\'appareil : ne rend rien', () => {
    const radar = boot();
    radar.render({ aircraftData: null }, [], [], []);
    expect(document.getElementById('radar-chart').innerHTML).toBe('');
    expect(document.getElementById('radar-legend').innerHTML).toBe('');
  });
});

describe('radar.render — SVG', () => {
  test('SVG décoratif : aria-hidden et non focalisable', () => {
    const radar = boot();
    radar.render({ aircraftId: 30, aircraftData: { max_speed: 1912, max_range: 3700 } }, [], [], []);
    const svg = document.querySelector('#radar-chart svg');
    expect(svg.getAttribute('aria-hidden')).toBe('true');
    expect(svg.getAttribute('focusable')).toBe('false');
  });

  test('5 niveaux de grille, 5 axes, 5 points et 5 libellés', () => {
    const radar = boot();
    radar.render({ aircraftId: 30, aircraftData: { max_speed: 1912 } }, [], [], []);
    const svg = document.querySelector('#radar-chart svg');
    expect(svg.querySelectorAll('polygon:not(.radar-polygon)')).toHaveLength(5);
    expect(svg.querySelectorAll('line')).toHaveLength(5);
    expect(svg.querySelectorAll('circle')).toHaveLength(5);
    expect(svg.querySelectorAll('text')).toHaveLength(5);
  });

  test('le dégradé porte l\'id de l\'appareil (pas de collision entre fiches)', () => {
    const radar = boot();
    radar.render({ aircraftId: 30, aircraftData: { max_speed: 1 } }, [], [], []);
    expect(document.getElementById('radarFill_30')).not.toBeNull();
    expect(document.querySelector('.radar-polygon').getAttribute('fill')).toBe('url(#radarFill_30)');
  });

  test('libellés d\'axe en majuscules, traduits', () => {
    const radar = boot('fr', { 'details.radar_speed': 'Vitesse' });
    radar.render({ aircraftId: 1, aircraftData: { max_speed: 1 } }, [], [], []);
    expect(document.querySelector('#radar-chart text').textContent).toBe('VITESSE');
  });

  test('score nul : tous les points au centre (150,150)', () => {
    const radar = boot();
    radar.render({ aircraftId: 1, aircraftData: {} }, [], [], []);
    const dots = [...document.querySelectorAll('#radar-chart circle')];
    dots.forEach((c) => {
      expect(Number(c.getAttribute('cx'))).toBeCloseTo(150, 1);
      expect(Number(c.getAttribute('cy'))).toBeCloseTo(150, 1);
    });
  });

  test('vitesse maximale : le point de l\'axe vertical touche le bord (y = 150 - 95)', () => {
    const radar = boot();
    radar.render({ aircraftId: 1, aircraftData: { max_speed: 3529 } }, [], [], []);
    const top = document.querySelector('#radar-chart circle');
    expect(Number(top.getAttribute('cx'))).toBeCloseTo(150, 1);
    expect(Number(top.getAttribute('cy'))).toBeCloseTo(55, 1);
  });
});

describe('radar.render — légende', () => {
  test('pourcentages normalisés et plafonnés à 100 %', () => {
    const radar = boot();
    radar.render(
      { aircraftId: 1, aircraftData: { max_speed: 7058, max_range: 3750 } },
      items(5), items(20), items(2),
    );
    expect(legend().map((l) => l.pct)).toEqual(['100%', '25%', '50%', '25%', '100%']);
    expect(legend().map((l) => l.target)).toEqual(['100.0', '25.0', '50.0', '25.0', '100.0']);
  });

  test('valeurs brutes en français : unités, pluriels, N/A', () => {
    const radar = boot('fr');
    radar.render({ aircraftId: 1, aircraftData: { max_speed: null, max_range: 0 } }, items(1), items(2), items(0));
    expect(legend().map((l) => l.value)).toEqual(['N/A', 'N/A', '1 système', '0 mission', '2 techs']);
    radar.render({ aircraftId: 1, aircraftData: {} }, items(3), items(1), items(2));
    expect(legend().map((l) => l.value).slice(2)).toEqual(['3 systèmes', '2 missions', '1 tech']);
  });

  test('valeurs brutes en anglais : pluriel dès 0', () => {
    const radar = boot('en');
    radar.render({ aircraftId: 1, aircraftData: {} }, items(0), [], items(1));
    expect(legend().map((l) => l.value).slice(2, 4)).toEqual(['0 systems', '1 mission']);
    radar.render({ aircraftId: 1, aircraftData: {} }, items(1), [], items(3));
    expect(legend().map((l) => l.value).slice(2, 4)).toEqual(['1 system', '3 missions']);
  });

  test('vitesse et rayon formatés avec l\'unité', () => {
    const radar = boot();
    radar.render({ aircraftId: 1, aircraftData: { max_speed: '2120', max_range: 3700 } }, [], [], []);
    const [speed, range] = legend();
    expect(speed.value).toMatch(/^2.?120 km\/h$/);
    expect(range.value).toMatch(/^3.?700 km$/);
  });

  test('les libellés traduits sont échappés dans la légende', () => {
    const radar = boot('fr', { 'details.radar_speed': '<img src=x onerror=alert(1)>' });
    radar.render({ aircraftId: 1, aircraftData: {} }, [], [], []);
    expect(document.querySelector('#radar-legend img')).toBeNull();
    expect(legend()[0].label).toBe('<img src=x onerror=alert(1)>');
  });

  test('les barres ne prennent leur largeur qu\'après deux frames (animation CSS)', () => {
    const radar = boot();
    radar.render({ aircraftId: 1, aircraftData: { max_speed: 3529 } }, [], [], []);
    const bar = document.querySelector('.radar-bar-fill');
    expect(bar.style.width).toBe('');
    rafQueue.shift()();
    expect(bar.style.width).toBe('');
    flushRaf();
    expect(bar.style.width).toBe('100%');
  });

  test('icône par axe', () => {
    const radar = boot();
    radar.render({ aircraftId: 1, aircraftData: {} }, [], [], []);
    const icons = [...document.querySelectorAll('.radar-stat-icon i')].map((i) => i.className);
    expect(icons).toEqual(['fas fa-gauge-high', 'fas fa-route', 'fas fa-crosshairs', 'fas fa-bullseye', 'fas fa-microchip']);
  });
});
