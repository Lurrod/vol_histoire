/**
 * Tests unitaires — frontend/js/details/render.js
 *
 * render.js depend de :
 *   - window.i18n (.t, .currentLang)
 *   - global escapeHtml
 *   - window.VH.details.data (slugify, updateSeoMeta)
 *   - de nombreux #ID DOM
 *
 * On stub i18n + escapeHtml + VH.details.data avant require, et on teste les
 * fonctions les plus isolees : renderWars (DOM contenu unique), finalizeCapabilities
 * (toggle de classe). Les fonctions renderArmament/Tech/Missions sont des wrappers
 * de renderCapabilityList et sont couvertes indirectement via finalizeCapabilities.
 */

global.i18n = {
  t: (key) => key, // identity = on assert sur la cle elle-meme
  currentLang: 'fr',
};
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
}[c]));
window.VH = { details: { data: { slugify: () => 'x', updateSeoMeta: () => {} } } };

const render = require('../js/details/render');

describe('render — module shape', () => {
  test('expose renderAircraftDetails, renderArmament, renderTechnologies, renderMissions, finalizeCapabilities, renderWars', () => {
    expect(typeof render.renderAircraftDetails).toBe('function');
    expect(typeof render.renderArmament).toBe('function');
    expect(typeof render.renderTechnologies).toBe('function');
    expect(typeof render.renderMissions).toBe('function');
    expect(typeof render.finalizeCapabilities).toBe('function');
    expect(typeof render.renderWars).toBe('function');
  });
});

describe('renderWars()', () => {
  beforeEach(() => {
    document.body.innerHTML = '<div id="wars-list"></div>';
  });

  test('rend le hint vide quand wars = []', () => {
    render.renderWars([]);
    const html = document.getElementById('wars-list').innerHTML;
    expect(html).toContain('details-empty-hint');
    expect(html).toContain('details.no_war'); // i18n.t identity → la cle apparait
  });

  test('rend le hint vide quand wars est null/undefined', () => {
    render.renderWars(null);
    expect(document.getElementById('wars-list').innerHTML).toContain('details-empty-hint');
    render.renderWars(undefined);
    expect(document.getElementById('wars-list').innerHTML).toContain('details-empty-hint');
  });

  test('rend une war-card par element', () => {
    const wars = [
      { name: 'Guerre du Golfe', description: 'Operation Tempete du desert', date_start: '1990-08-02', date_end: '1991-02-28' },
      { name: 'Falklands', description: 'Conflit naval', date_start: '1982-04-02', date_end: '1982-06-14' },
    ];
    render.renderWars(wars);
    const cards = document.querySelectorAll('#wars-list .war-card');
    expect(cards).toHaveLength(2);
  });

  test('echappe les noms de guerre (XSS)', () => {
    render.renderWars([{ name: '<img src=x onerror=alert(1)>', description: 'd', date_start: '2000-01-01', date_end: '2000-12-31' }]);
    const html = document.getElementById('wars-list').innerHTML;
    expect(html).not.toContain('<img src=x');
    expect(html).toContain('&lt;img');
  });

  test('extrait l\'annee de debut et de fin depuis les dates', () => {
    render.renderWars([{ name: 'Vietnam', description: 'd', date_start: '1965-03-08', date_end: '1975-04-30' }]);
    const html = document.getElementById('wars-list').innerHTML;
    expect(html).toContain('1965 - 1975');
  });

  test('utilise "?" quand date_start ou date_end manquent', () => {
    render.renderWars([{ name: 'X', description: 'd', date_start: null, date_end: null }]);
    const html = document.getElementById('wars-list').innerHTML;
    expect(html).toContain('? - ?');
  });
});

describe('renderArmament / renderTechnologies / renderMissions (renderCapabilityList)', () => {
  function setupCapabilityDom(prefix) {
    document.body.innerHTML = `
      <div id="col-${prefix}"></div>
      <ul id="${prefix}-list"></ul>
      <span id="${prefix}-count"></span>
    `;
  }

  test('renderArmament([]) cache la colonne et vide la liste', () => {
    setupCapabilityDom('armament');
    const n = render.renderArmament([]);
    expect(n).toBe(0);
    expect(document.getElementById('col-armament').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('armament-list').innerHTML).toBe('');
  });

  test('renderArmament([items]) affiche la liste, retire .hidden, ecrit le count', () => {
    setupCapabilityDom('armament');
    const items = [
      { name: 'AIM-9 Sidewinder', description: 'Missile air-air courte portee' },
      { name: 'AIM-120 AMRAAM', description: 'BVR' },
      { name: 'GBU-12', description: '' },
    ];
    const n = render.renderArmament(items);
    expect(n).toBe(3);
    expect(document.getElementById('col-armament').classList.contains('hidden')).toBe(false);
    expect(document.getElementById('armament-count').textContent).toBe('3');
    const lis = document.querySelectorAll('#armament-list li.capability-item');
    expect(lis).toHaveLength(3);
  });

  test('renderArmament echappe le nom + description (XSS)', () => {
    setupCapabilityDom('armament');
    render.renderArmament([{ name: '<script>x</script>', description: '<img onerror=1>' }]);
    const html = document.getElementById('armament-list').innerHTML;
    expect(html).not.toContain('<script>');
    expect(html).toContain('&lt;script&gt;');
    expect(html).toContain('&lt;img');
  });

  test('renderArmament returns 0 quand DOM absent (pas de #col-armament)', () => {
    document.body.innerHTML = '';
    const n = render.renderArmament([{ name: 'x' }]);
    expect(n).toBe(0);
  });

  test('renderTechnologies wrap renderCapabilityList sur les bons IDs', () => {
    setupCapabilityDom('tech');
    const n = render.renderTechnologies([{ name: 'AESA Radar' }]);
    expect(n).toBe(1);
    expect(document.getElementById('tech-count').textContent).toBe('1');
  });

  test('renderMissions wrap renderCapabilityList sur les bons IDs', () => {
    setupCapabilityDom('missions');
    const n = render.renderMissions([{ name: 'CAS' }, { name: 'CAP' }]);
    expect(n).toBe(2);
    expect(document.getElementById('missions-count').textContent).toBe('2');
  });

  test('renderCapabilityList sans count element fonctionne quand-meme', () => {
    document.body.innerHTML = `
      <div id="col-armament"></div>
      <ul id="armament-list"></ul>
    `;
    expect(() => render.renderArmament([{ name: 'x' }])).not.toThrow();
  });
});

describe('finalizeCapabilities()', () => {
  test('ne casse pas sans #capabilities-section dans le DOM', () => {
    document.body.innerHTML = '';
    expect(() => render.finalizeCapabilities()).not.toThrow();
  });

  test('cache la section quand toutes les colonnes sont .hidden', () => {
    document.body.innerHTML = `
      <section id="capabilities-section">
        <div id="col-armament" class="hidden"></div>
        <div id="col-tech" class="hidden"></div>
        <div id="col-missions" class="hidden"></div>
      </section>
    `;
    render.finalizeCapabilities();
    expect(document.getElementById('capabilities-section').classList.contains('hidden')).toBe(true);
  });

  test('garde la section visible quand au moins une colonne est visible', () => {
    document.body.innerHTML = `
      <section id="capabilities-section">
        <div id="col-armament"></div>
        <div id="col-tech" class="hidden"></div>
        <div id="col-missions" class="hidden"></div>
      </section>
    `;
    render.finalizeCapabilities();
    expect(document.getElementById('capabilities-section').classList.contains('hidden')).toBe(false);
  });

  test('garde la section visible quand aucune colonne n\'est presente (pas tous hidden si vide)', () => {
    document.body.innerHTML = '<section id="capabilities-section"></section>';
    render.finalizeCapabilities();
    // cols.length === 0 → allHidden = false → pas de toggle vers hidden
    expect(document.getElementById('capabilities-section').classList.contains('hidden')).toBe(false);
  });
});
