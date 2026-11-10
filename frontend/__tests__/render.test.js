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
    expect(typeof render.renderImageCredit).toBe('function');
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


describe('renderImageCredit()', () => {
  beforeEach(() => {
    document.body.innerHTML = '<p id="image-credit" hidden></p>';
  });

  test('affiche auteur et licence separes par un tiret', () => {
    render.renderImageCredit({ image_credit: 'Mike McBey', image_licence: 'CC BY 2.0' });
    const el = document.getElementById('image-credit');
    expect(el.hidden).toBe(false);
    expect(el.textContent).toBe('details.photo : Mike McBey — CC BY 2.0');
  });

  test('traduit la licence « Public domain » via i18n', () => {
    render.renderImageCredit({ image_credit: 'USAF', image_licence: 'Public domain' });
    // le stub i18n renvoie la cle : on verifie qu'elle est bien sollicitee
    expect(document.getElementById('image-credit').textContent)
      .toBe('details.photo : USAF — details.licence_public_domain');
  });

  test('se contente de la licence quand aucun auteur nest fourni', () => {
    render.renderImageCredit({ image_credit: null, image_licence: 'CC BY-SA 4.0' });
    expect(document.getElementById('image-credit').textContent)
      .toBe('details.photo : CC BY-SA 4.0');
  });

  test('reste masque quand les deux champs sont absents', () => {
    render.renderImageCredit({ image_credit: null, image_licence: null });
    const el = document.getElementById('image-credit');
    expect(el.hidden).toBe(true);
    expect(el.textContent).toBe('');
  });

  test('ne casse pas quand la legende est absente du DOM', () => {
    document.body.innerHTML = '';
    expect(() => render.renderImageCredit({ image_credit: 'X', image_licence: 'Y' })).not.toThrow();
  });
});

describe('titres des cartes (A11Y-007) : h3 sous le h2 de section', () => {
  test('renderWars emet un h3, plus aucun h4', () => {
    document.body.innerHTML = '<div id="wars-list"></div>';
    render.renderWars([{ name: 'Golfe', description: 'd', date_start: '1990-08-02', date_end: '1991-02-28', slug: 'golfe' }]);
    expect(document.querySelector('#wars-list .war-card h3')).not.toBeNull();
    expect(document.querySelector('#wars-list h4')).toBeNull();
  });
});

describe('renderHeroImage() — element LCP (PERF-005)', () => {
  beforeAll(() => { require('../js/shared/picture'); });

  test('ne repasse jamais l\'image hero en loading="lazy"', () => {
    document.body.innerHTML = '<picture><source type="image/avif"><source type="image/webp">'
      + '<img id="hero-image" fetchpriority="high" alt=""></picture>';
    render.renderHeroImage({ image_url: '/assets/airplanes/rafale.jpg', name: 'Rafale' });
    const img = document.getElementById('hero-image');
    expect(img.loading).not.toBe('lazy');
    expect(img.getAttribute('fetchpriority')).toBe('high');
    expect(img.getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
  });

  test('sans image : placeholder SVG localise', () => {
    document.body.innerHTML = '<picture><img id="hero-image" alt=""></picture>';
    render.renderHeroImage({ image_url: null, name: 'X' });
    expect(document.getElementById('hero-image').getAttribute('src')).toBe('/assets/logo/placeholder-airplane-fr.svg');
  });
});

describe('renderRelatedAircraft() — repli d\'image sans onerror en ligne (JS-005)', () => {
  beforeAll(() => { require('../js/shared/picture'); });
  beforeEach(() => {
    document.body.innerHTML = '<section id="related-aircraft-section" class="hidden"><div id="related-grid"></div></section>';
  });

  const base = { predecessor_id: 22, predecessor_name: 'MiG-21', predecessor_image: '/assets/airplanes/mig21.jpg' };

  test('aucun attribut on* dans le HTML emis (CSP script-src sans unsafe-inline)', () => {
    render.renderRelatedAircraft(base);
    const html = document.getElementById('related-grid').innerHTML;
    expect(html).not.toMatch(/\son[a-z]+=/i);
    expect(document.querySelector('#related-grid .related-card h3').textContent).toBe('MiG-21');
    expect(document.querySelector('#related-grid h4')).toBeNull();
  });

  test('sans image en base : placeholder SVG localise, plus de placeholder.jpg inexistant', () => {
    render.renderRelatedAircraft({ successor_id: 292, successor_name: 'MiG-35', successor_image: null });
    const html = document.getElementById('related-grid').innerHTML;
    expect(html).not.toContain('placeholder.jpg');
    expect(document.querySelector('#related-grid img').getAttribute('src')).toBe('/assets/logo/placeholder-airplane-fr.svg');
    expect(document.querySelector('#related-grid source')).toBeNull();
  });

  test('image en erreur : placeholder SVG et sources AVIF/WebP retirees', () => {
    render.renderRelatedAircraft(base);
    const img = document.querySelector('#related-grid img');
    expect(document.querySelectorAll('#related-grid source')).toHaveLength(2);
    img.dispatchEvent(new Event('error')); // ne bulle pas : capte en phase de capture
    expect(img.getAttribute('src')).toBe('/assets/logo/placeholder-airplane-fr.svg');
    expect(document.querySelectorAll('#related-grid source')).toHaveLength(0);
    expect(img.closest('picture').hidden).toBe(false);
  });

  test('placeholder en erreur a son tour : l\'image est masquee, sans boucle', () => {
    render.renderRelatedAircraft(base);
    const img = document.querySelector('#related-grid img');
    img.dispatchEvent(new Event('error'));
    img.dispatchEvent(new Event('error'));
    expect(img.closest('picture').hidden).toBe(true);
    expect(img.getAttribute('src')).toBe('/assets/logo/placeholder-airplane-fr.svg');
  });

  test('un seul ecouteur meme apres plusieurs rendus', () => {
    const grid = document.getElementById('related-grid');
    const spy = jest.spyOn(grid, 'addEventListener');
    render.renderRelatedAircraft(base);
    render.renderRelatedAircraft(base);
    expect(spy.mock.calls.filter(([type]) => type === 'error')).toHaveLength(1);
  });

  test('aucune relation : section masquee', () => {
    render.renderRelatedAircraft({});
    expect(document.getElementById('related-aircraft-section').classList.contains('hidden')).toBe(true);
  });
});
