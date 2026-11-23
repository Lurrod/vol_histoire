/**
 * Tests DOM — frontend/js/conflicts/detail.js : page d'un conflit étoffée
 * (issue, contexte et récit en Markdown, dates clés, appareils par camp avec
 * leur rôle, sources), et repli sur la grille pour un conflit non rédigé.
 */

const T = {
  'conflicts.several_sides': 'Dans plusieurs camps',
  'conflicts.other_aircraft': 'Autres appareils engagés',
  'conflicts.source_label': 'Source',
};

let detail;

function page() {
  document.body.innerHTML = `
    <p id="conflict-outcome" class="hidden"><span id="conflict-outcome-text"></span></p>
    <section id="contexte" class="hidden"><h2>Contexte</h2><div id="conflict-context"></div></section>
    <section id="guerre-aerienne" class="hidden"><h2>Air</h2><div id="conflict-narrative"></div></section>
    <section id="dates-cles" class="hidden"><h2>Dates</h2><div id="conflict-events" role="tablist"></div><div id="conflict-event-panel"><div id="conflict-event-content"></div><button data-dir="-1"></button><span id="conflict-event-count"></span><button data-dir="1"></button></div></section>
    <section id="appareils"><div id="conflict-sides" class="hidden"></div><div id="conflict-aircraft"></div></section>
    <section id="sources" class="hidden"><ol id="conflict-sources"></ol></section>`;
}

function load({ lang = 'fr', picture = true } = {}) {
  jest.resetModules();
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.safeSetHTML = (el, html) => { el.innerHTML = html; };
  global.i18n = {
    currentLang: lang,
    t: (k, p = {}) => (T[k] || k).replace(/\{(\w+)\}/g, (_, n) => p[n]),
  };
  window.i18n = global.i18n;
  window.VH = {
    shared: {
      renderAircraftCard: jest.fn((a) => `<article class="aircraft-card" data-id="${a.id}"></article>`),
      buildDetailsPath: (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`,
    },
  };
  if (picture) {
    window.VH.shared.picture = {
      thumbHtml: jest.fn((url) => `<picture data-url="${url}"></picture>`),
      pictureHtml: jest.fn((url) => `<picture data-url="${url}"></picture>`),
    };
  }
  require('../js/details/markdown.js');
  require('../js/conflicts/dates.js');
  detail = require('../js/conflicts/detail.js');
}

const $ = (id) => document.getElementById(id);

const WAR = {
  outcome: 'Victoire de la *coalition*.',
  context: 'Le **2 août 1990**, l\'Irak envahit le Koweït.\n\nSecond paragraphe.',
  narrative: 'Opération *Desert Storm* : 38 jours de frappes.',
  sources: ['https://fr.wikipedia.org/wiki/Guerre_du_Golfe', 'https://en.wikipedia.org/wiki/Gulf_War'],
  sides: [
    { key: 'coalition', name: 'Coalition', members: 'États-Unis, Royaume-Uni, France', count: 2 },
    { key: 'irak', name: 'Irak', members: 'Irak', count: 1 },
    { key: 'vide', name: 'Camp sans appareil', members: '', count: 0 },
  ],
  events: [
    { date: '1991-01-17', precision: 'day', title: 'Début de *Desert Storm*', body: 'Frappes sur Bagdad.', source: null, airplane: { id: 12, name: 'F-117 Nighthawk' } },
    { date: '1990-08-01', precision: 'month', title: 'Invasion', body: null, source: null, airplane: null },
  ],
  airplanes: [
    { id: 12, name: 'F-117 Nighthawk', type_name: 'Bombardier', country_name: 'États-Unis', image_url: '/assets/airplanes/f117.jpg', side_key: 'coalition', role: 'Frappe la <b>première</b> nuit.', role_sources: ['https://en.wikipedia.org/a', 'https://en.wikipedia.org/b', 'https://www.nationalmuseum.af.mil/x', 'notaurl'] },
    { id: 13, name: 'A-10', type_name: null, country_name: null, image_url: null, side_key: 'coalition', role: 'Chasse aux chars.', role_sources: [] },
    { id: 20, name: 'MiG-29', side_key: 'irak', role: 'Abattus en combat.', role_sources: [] },
    { id: 30, name: 'Mirage F1', side_key: null, role: 'Irak et France.', role_sources: [] },
    { id: 40, name: 'C-17', side_key: null, role: null, role_sources: [] },
  ],
};

beforeEach(page);
afterEach(() => { delete window.i18n; });

describe('sourceHost / inline', () => {
  test('nom de domaine lisible', () => {
    load();
    expect(detail.sourceHost('https://www.nationalmuseum.af.mil/x')).toBe('nationalmuseum.af.mil');
    expect(detail.sourceHost('pas une url')).toBe('');
  });

  test('texte échappé, italique rendu, typographie française seulement en français', () => {
    load();
    expect(detail.inline('<b>Opération *Granby* :</b>')).toBe('&lt;b&gt;Opération <em>Granby</em> :&lt;/b&gt;');
    expect(detail.inline(null)).toBe('');
    load({ lang: 'en' });
    expect(detail.inline('Operation *Granby*: done')).toBe('Operation <em>Granby</em>: done');
  });
});

describe('groupBySide', () => {
  test('un groupe par camp ayant des appareils, puis « plusieurs camps », puis le reste sans rôle', () => {
    load();
    const { groups, rest } = detail.groupBySide(WAR);
    expect(groups.map((g) => g.name)).toEqual(['Coalition', 'Irak', 'Dans plusieurs camps']);
    expect(groups[0].airplanes.map((a) => a.id)).toEqual([12, 13]);
    expect(groups[2].airplanes.map((a) => a.id)).toEqual([30]);
    expect(rest.map((a) => a.id)).toEqual([40]);
  });

  test('camp inconnu : rangé avec « plusieurs camps » ; conflit vide', () => {
    load();
    const { groups } = detail.groupBySide({ sides: [], airplanes: [{ id: 1, side_key: 'x', role: 'r' }] });
    expect(groups).toHaveLength(1);
    expect(groups[0].key).toBe('');
    expect(detail.groupBySide({})).toEqual({ groups: [], rest: [] });
  });
});

describe('render — conflit rédigé', () => {
  test('issue, contexte et récit en Markdown, sections affichées', () => {
    load();
    expect(detail.render(WAR)).toBe(true);
    expect($('conflict-outcome').classList.contains('hidden')).toBe(false);
    expect($('conflict-outcome-text').innerHTML).toContain('<em>coalition</em>');
    expect($('conflict-context').querySelectorAll('p')).toHaveLength(2);
    expect($('conflict-context').querySelector('strong').textContent).toBe('2 août 1990');
    expect($('contexte').classList.contains('hidden')).toBe(false);
    expect($('conflict-narrative').querySelector('em').textContent).toBe('Desert Storm');
  });

  test('dates clés : déléguées au bandeau (conflicts/dates.js)', () => {
    load();
    detail.render(WAR);
    expect(document.querySelectorAll('#conflict-events [role="tab"]')).toHaveLength(2);
    expect($('dates-cles').classList.contains('hidden')).toBe(false);
  });

  test('appareils par camp : rôle échappé, vignette, une source par site, camp vide omis', () => {
    load();
    detail.render(WAR);
    const sides = document.querySelectorAll('#conflict-sides .conflict-side');
    expect(sides).toHaveLength(3);
    expect(sides[0].dataset.side).toBe('coalition');
    expect(sides[0].querySelector('.conflict-side-count').textContent).toBe('2');
    expect(sides[0].querySelector('.conflict-side-members').textContent).toContain('Royaume-Uni');
    // Membres identiques au nom (« Irak ») : pas répétés
    expect(sides[1].querySelector('.conflict-side-members')).toBeNull();
    expect(sides[2].hasAttribute('data-side')).toBe(false);

    const f117 = sides[0].querySelector('.role-card');
    expect(f117.querySelector('.role-name a').getAttribute('href')).toBe('/details/f-117-nighthawk-12');
    expect(f117.querySelector('.role-text').innerHTML).toContain('&lt;b&gt;première&lt;/b&gt;');
    expect(f117.querySelector('.role-meta').textContent).toBe('Bombardier · États-Unis');
    expect(f117.querySelector('picture').dataset.url).toBe('/assets/airplanes/f117.jpg');
    const links = Array.from(f117.querySelectorAll('.role-sources a')).map((a) => a.textContent);
    expect(links).toEqual(['en.wikipedia.org', 'nationalmuseum.af.mil']);

    const a10 = sides[0].querySelectorAll('.role-card')[1];
    expect(a10.querySelector('.role-thumb-empty')).not.toBeNull();
    expect(a10.querySelector('.role-meta')).toBeNull();
    expect(a10.querySelector('.role-sources')).toBeNull();
  });

  test('appareils sans rôle : grille de cartes sous un titre « Autres appareils », non dupliqué au second rendu', () => {
    load();
    detail.render(WAR);
    detail.render(WAR);
    expect(document.querySelectorAll('#conflict-others-heading')).toHaveLength(1);
    expect($('conflict-aircraft').querySelectorAll('.aircraft-card')).toHaveLength(1);
    expect($('conflict-aircraft').classList.contains('hidden')).toBe(false);
  });

  test('sources : liste de liens, adresses invalides écartées', () => {
    load();
    detail.render({ ...WAR, sources: [...WAR.sources, 'pas une url'] });
    const links = document.querySelectorAll('#conflict-sources a');
    expect(links).toHaveLength(2);
    expect(links[0].getAttribute('rel')).toBe('noopener noreferrer');
    expect($('sources').classList.contains('hidden')).toBe(false);
  });

  test('sans module d\'images : simple <img>', () => {
    load({ picture: false });
    detail.render(WAR);
    expect(document.querySelector('.role-thumb img').getAttribute('src')).toBe('/assets/airplanes/f117.jpg');
  });
});

describe('render — conflit pas encore rédigé', () => {
  test('grille de cartes seule, sections de texte masquées', () => {
    load();
    const war = { sides: [], events: [], sources: [], airplanes: [{ id: 1, name: 'F8F', role: null }, { id: 2, name: 'C-47', role: null }] };
    expect(detail.render(war)).toBe(false);
    expect($('conflict-sides').classList.contains('hidden')).toBe(true);
    expect($('conflict-aircraft').querySelectorAll('.aircraft-card')).toHaveLength(2);
    expect(document.getElementById('conflict-others-heading')).toBeNull();
    ['contexte', 'guerre-aerienne', 'dates-cles', 'sources'].forEach((id) => {
      expect($(id).classList.contains('hidden')).toBe(true);
    });
    expect($('conflict-outcome').classList.contains('hidden')).toBe(true);
  });

  test('sans les éléments de la page ni le rendu Markdown : pas d\'erreur', () => {
    load();
    delete window.VH.details;
    delete window.VH.shared.renderAircraftCard;
    expect(() => detail.render(WAR)).not.toThrow();
    document.body.innerHTML = '';
    expect(detail.render(WAR)).toBe(true);
  });
});
