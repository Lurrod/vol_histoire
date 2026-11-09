/**
 * Tests — liens vers les conflits et missions (details/render.js) et
 * helpers de la page des conflits (conflicts.js).
 */

global.i18n = {
  t: (key, params = {}) => (params.year ? `${key}:${params.year}` : key),
  currentLang: 'fr',
};
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
}[c]));
window.VH = { details: { data: { slugify: () => 'x', updateSeoMeta: () => {} } } };

const render = require('../js/details/render');
const conflicts = require('../js/conflicts');

describe('renderWars — carte cliquable vers la page du conflit', () => {
  beforeEach(() => { document.body.innerHTML = '<div id="wars-list"></div>'; });

  test('lien /conflits/<slug> quand le slug est fourni', () => {
    render.renderWars([{ name: "Guerre d'Indochine", slug: 'guerre-d-indochine', description: 'd', date_start: '1946-12-19', date_end: '1954-07-21' }]);
    const link = document.querySelector('#wars-list a.war-link');
    expect(link).not.toBeNull();
    expect(link.getAttribute('href')).toBe('/conflits/guerre-d-indochine');
    expect(document.querySelector('.war-card').classList.contains('war-card-linked')).toBe(true);
    expect(document.querySelector('.war-more')).not.toBeNull();
  });

  test('pas de lien sans slug (rétrocompatible)', () => {
    render.renderWars([{ name: 'X', description: 'd', date_start: '2000-01-01', date_end: '2001-01-01' }]);
    expect(document.querySelector('#wars-list a')).toBeNull();
  });

  test('conflit en cours : « auj. » au lieu de « ? »', () => {
    render.renderWars([{ name: 'Ukraine', slug: 'u', description: 'd', date_start: '2022-02-24', date_end: null }]);
    expect(document.getElementById('wars-list').innerHTML).toContain('2022 - details.war_ongoing');
  });
});

describe('renderMissions — chaque mission ouvre le hangar filtré', () => {
  beforeEach(() => {
    document.body.innerHTML = '<div id="col-missions"></div><ul id="missions-list"></ul><span id="missions-count"></span>';
  });

  test('lien /hangar?mission=<nom FR encodé>', () => {
    render.renderMissions([{ name: 'Air Superiority', name_fr: 'Supériorité aérienne', description: '' }]);
    const link = document.querySelector('#missions-list a.capability-link');
    expect(link.getAttribute('href')).toBe('/hangar?mission=Sup%C3%A9riorit%C3%A9%20a%C3%A9rienne');
    expect(link.textContent).toBe('Air Superiority');
  });

  test('sans name_fr : texte simple, pas de lien', () => {
    render.renderMissions([{ name: 'Interception', description: '' }]);
    expect(document.querySelector('#missions-list a')).toBeNull();
    expect(document.querySelector('#missions-list .capability-name').textContent).toBe('Interception');
  });
});

describe('conflicts.period', () => {
  test('début et fin', () => {
    expect(conflicts.period({ date_start: '1955-11-01', date_end: '1975-04-30' })).toBe('1955 – 1975');
  });
  test('même année : une seule', () => {
    expect(conflicts.period({ date_start: '1982-04-02', date_end: '1982-06-14' })).toBe('1982');
  });
  test('en cours : « depuis »', () => {
    expect(conflicts.period({ date_start: '2022-02-24', date_end: null })).toBe('conflicts.since:2022');
  });
  test('sans date : vide', () => {
    expect(conflicts.period({})).toBe('');
  });
});
