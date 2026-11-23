/**
 * Tests DOM — frontend/js/conflicts/dates.js : dates clés d'un conflit en
 * bandeau d'onglets + panneau (motif APG « onglets », boutons, glissement).
 */

let dates;

function page() {
  document.body.innerHTML = `
    <section id="dates-cles" class="hidden">
      <h2>Dates</h2>
      <div id="conflict-events" role="tablist"></div>
      <div id="conflict-event-panel" role="tabpanel" tabindex="0">
        <div id="conflict-event-content"></div>
        <button type="button" data-dir="-1">‹</button>
        <span id="conflict-event-count"></span>
        <button type="button" data-dir="1">›</button>
      </div>
    </section>`;
}

function load({ lang = 'fr', picture = true, detail = true } = {}) {
  jest.resetModules();
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.i18n = { currentLang: lang, t: (k) => k };
  window.i18n = global.i18n;
  window.VH = {
    shared: {
      buildDetailsPath: (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`,
    },
  };
  if (picture) {
    window.VH.shared.picture = { pictureHtml: jest.fn((url) => `<picture data-url="${url}"></picture>`) };
  }
  if (detail) {
    require('../js/details/markdown.js');
    require('../js/conflicts/detail.js');
  }
  dates = require('../js/conflicts/dates.js');
}

const $ = (id) => document.getElementById(id);
const tabs = () => Array.from(document.querySelectorAll('#conflict-events [role="tab"]'));

const WAR = {
  events: [
    { date: '1990-08-02', precision: 'day', title: 'Invasion du Koweït', body: 'Résolution 660.', airplane: null },
    { date: '1991-01-17', precision: 'day', title: 'Début de *Desert Storm*', body: 'Frappes <sur> Bagdad.', airplane: { id: 12, name: 'F-117 Nighthawk' } },
    { date: '1991-02-01', precision: 'month', title: 'Bataille de Khafji', body: null, airplane: { id: 99, name: 'AC-130' } },
  ],
  airplanes: [
    { id: 12, name: 'F-117 Nighthawk', image_url: '/assets/airplanes/f117.jpg' },
  ],
};

beforeEach(page);
afterEach(() => { delete window.i18n; delete global.i18n; });

describe('formatEventDate / dateParts', () => {
  test('date selon la précision connue, en UTC, courte ou en toutes lettres', () => {
    load();
    expect(dates.formatEventDate('1991-01-17', 'day', 'fr')).toMatch(/^17 janv\.? 1991$/);
    expect(dates.formatEventDate('1991-01-17', 'day', 'fr', true)).toBe('17 janvier 1991');
    expect(dates.formatEventDate('1991-01-17', 'day', 'en', true)).toBe('17 January 1991');
    expect(dates.formatEventDate('1990-08-01', 'month', 'fr')).toBe('août 1990');
    expect(dates.formatEventDate('1990-08-01', 'year', 'fr')).toBe('1990');
    expect(dates.formatEventDate('pas une date', 'day', 'fr')).toBe('');
    expect(dates.formatEventDate(null, 'day', 'fr')).toBe('');
  });

  test('onglet : en-tête du jour ou du mois, année à part', () => {
    load();
    expect(dates.dateParts('1991-01-17', 'day', 'fr')).toEqual({ lead: '17 janv.', year: '1991' });
    expect(dates.dateParts('1990-08-01', 'month', 'fr')).toEqual({ lead: 'août', year: '1990' });
    expect(dates.dateParts('1950-01-01', 'year', 'fr')).toEqual({ lead: '', year: '1950' });
    expect(dates.dateParts('1991-01-17', 'day', 'en')).toEqual({ lead: '17 Jan', year: '1991' });
    expect(dates.dateParts('x', 'day', 'fr')).toEqual({ lead: '', year: '' });
  });

  test('repli sans Intl utilisable', () => {
    load();
    const original = Intl.DateTimeFormat;
    Intl.DateTimeFormat = function () { throw new RangeError('x'); };
    try {
      expect(dates.formatEventDate('1991-01-17', 'day', 'fr')).toBe('17/01/1991');
      expect(dates.formatEventDate('1991-01-17', 'month', 'fr')).toBe('01/1991');
      expect(dates.dateParts('1991-01-17', 'day', 'fr')).toEqual({ lead: '17/01', year: '1991' });
      expect(dates.dateParts('1991-01-17', 'month', 'fr')).toEqual({ lead: '01', year: '1991' });
    } finally {
      Intl.DateTimeFormat = original;
    }
  });
});

describe('render', () => {
  test('bandeau : un onglet par date, le premier choisi, seul dans la tabulation', () => {
    load();
    expect(dates.render(WAR)).toBe(true);
    expect($('dates-cles').classList.contains('hidden')).toBe(false);
    const t = tabs();
    expect(t).toHaveLength(3);
    expect(t.map((x) => x.getAttribute('aria-selected'))).toEqual(['true', 'false', 'false']);
    expect(t.map((x) => x.tabIndex)).toEqual([0, -1, -1]);
    expect(t[0].querySelector('.conflict-date-lead').textContent).toBe('2 août');
    expect(t[0].querySelector('.conflict-date-year').textContent).toBe('1990');
    expect(t[0].querySelector('.sr-only').textContent).toContain('Invasion du Koweït');
    expect($('conflict-event-panel').getAttribute('aria-labelledby')).toBe('conflict-date-tab-0');
    expect($('conflict-event-count').textContent).toBe('1 / 3');
    const [prev, next] = $('conflict-event-panel').querySelectorAll('[data-dir]');
    expect([prev.disabled, next.disabled]).toEqual([true, false]);
    expect($('conflict-event-content').querySelector('.conflict-date-photo')).toBeNull();
  });

  test('panneau : date en toutes lettres, texte échappé, photo et lien de la fiche liée', () => {
    load();
    dates.render(WAR);
    tabs()[1].click();
    const content = $('conflict-event-content');
    expect(content.querySelector('time').getAttribute('datetime')).toBe('1991-01-17');
    expect(content.querySelector('time').textContent).toBe('17 janvier 1991');
    expect(content.querySelector('.conflict-date-title em').textContent).toBe('Desert Storm');
    expect(content.querySelector('.conflict-date-body').innerHTML).toContain('&lt;sur&gt;');
    expect(content.querySelector('.conflict-event-plane').getAttribute('href')).toBe('/details/f-117-nighthawk-12');
    expect(content.querySelector('.conflict-date-photo picture').dataset.url).toBe('/assets/airplanes/f117.jpg');
    expect(content.classList.contains('is-entering')).toBe(true);
    expect($('conflict-event-count').textContent).toBe('2 / 3');
  });

  test('appareil lié sans fiche au conflit : lien sans photo ; pas de récit : pas de paragraphe', () => {
    load();
    dates.render(WAR);
    tabs()[2].click();
    const content = $('conflict-event-content');
    expect(content.querySelector('time').textContent).toBe('février 1991');
    expect(content.querySelector('.conflict-event-plane').textContent).toContain('AC-130');
    expect(content.querySelector('.conflict-date-photo')).toBeNull();
    expect(content.querySelector('.conflict-date-body')).toBeNull();
  });

  test('clavier : flèches, Début, Fin ; le focus suit l\'onglet choisi', () => {
    load();
    dates.render(WAR);
    const strip = $('conflict-events');
    const key = (k) => strip.dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true }));
    tabs()[0].focus();
    key('ArrowRight');
    expect(document.activeElement).toBe(tabs()[1]);
    expect(tabs()[1].getAttribute('aria-selected')).toBe('true');
    key('End');
    expect(document.activeElement).toBe(tabs()[2]);
    key('ArrowRight'); // borné au dernier
    expect(tabs()[2].getAttribute('aria-selected')).toBe('true');
    key('Home');
    expect(document.activeElement).toBe(tabs()[0]);
    key('ArrowLeft');
    expect(tabs()[0].getAttribute('aria-selected')).toBe('true');
    key('Enter'); // ignorée
    expect(tabs()[0].getAttribute('aria-selected')).toBe('true');
  });

  test('boutons précédente / suivante, bornés aux extrémités', () => {
    load();
    dates.render(WAR);
    const [prev, next] = $('conflict-event-panel').querySelectorAll('[data-dir]');
    next.click();
    next.click();
    expect($('conflict-event-count').textContent).toBe('3 / 3');
    expect([prev.disabled, next.disabled]).toEqual([false, true]);
    prev.click();
    expect(tabs()[1].getAttribute('aria-selected')).toBe('true');
  });

  test('glissement horizontal sur le panneau ; un glissement vertical ne change rien', () => {
    load();
    dates.render(WAR);
    const panel = $('conflict-event-panel');
    const swipe = (x0, x1, y0 = 100, y1 = 100) => {
      const ts = new window.Event('touchstart');
      ts.touches = [{ clientX: x0, clientY: y0 }];
      panel.dispatchEvent(ts);
      const te = new window.Event('touchend');
      te.changedTouches = [{ clientX: x1, clientY: y1 }];
      panel.dispatchEvent(te);
    };
    swipe(300, 200);
    expect(tabs()[1].getAttribute('aria-selected')).toBe('true');
    swipe(200, 300);
    expect(tabs()[0].getAttribute('aria-selected')).toBe('true');
    swipe(300, 280, 100, 300);
    expect(tabs()[0].getAttribute('aria-selected')).toBe('true');
    const te = new window.Event('touchend');
    te.changedTouches = [{ clientX: 0, clientY: 0 }];
    panel.dispatchEvent(te); // sans touchstart : ignoré
    expect(tabs()[0].getAttribute('aria-selected')).toBe('true');
  });

  test('nouveau rendu (changement de langue) : date choisie gardée, écouteurs non doublés', () => {
    load();
    dates.render(WAR);
    tabs()[1].click();
    global.i18n.currentLang = 'en';
    dates.render(WAR);
    expect(tabs()[1].getAttribute('aria-selected')).toBe('true');
    expect($('conflict-event-content').querySelector('time').textContent).toBe('17 January 1991');
    const [, next] = $('conflict-event-panel').querySelectorAll('[data-dir]');
    next.click();
    expect($('conflict-event-count').textContent).toBe('3 / 3');
  });

  test('sans date : section masquée, contenus vidés ; DOM incomplet : rien', () => {
    load();
    dates.render(WAR);
    expect(dates.render({ events: [] })).toBe(false);
    expect($('dates-cles').classList.contains('hidden')).toBe(true);
    expect($('conflict-events').innerHTML).toBe('');
    expect(dates.render(null)).toBe(false);
    document.body.innerHTML = '';
    expect(dates.render(WAR)).toBe(false);
  });

  test('sans module de détail ni de photos : texte échappé, image simple', () => {
    load({ detail: false, picture: false });
    dates.render(WAR);
    tabs()[1].click();
    const content = $('conflict-event-content');
    expect(content.querySelector('.conflict-date-title').textContent).toBe('Début de *Desert Storm*');
    expect(content.querySelector('.conflict-date-photo img').getAttribute('src')).toBe('/assets/airplanes/f117.jpg');
  });
});
