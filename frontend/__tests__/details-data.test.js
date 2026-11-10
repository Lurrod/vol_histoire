/**
 * Tests DOM — frontend/js/details/data.js : updateSeoMeta (HTML-003).
 *
 * Le rendu serveur pose deux blocs JSON-LD (#jsonld-article, #jsonld-breadcrumb) ;
 * le client doit les mettre à jour sur place au lieu d'en ajouter, et faire du
 * Vehicle l'objet de l'Article plutôt qu'une seconde entité principale.
 */
global.i18n = { t: (k) => ({ 'nav.home': 'Accueil', 'nav.hangar': 'Hangar' }[k] || k), currentLang: 'fr' };
window.i18n = global.i18n;
require('../js/details/data');

const { updateSeoMeta } = window.VH.details.data;
const PAGE = 'https://vol-histoire.titouan-borde.com/details/sr-71-blackbird-31';

function ldBlocks() {
  return [...document.querySelectorAll('script[type="application/ld+json"]')].map(s => JSON.parse(s.textContent));
}

function mountHead(withSsr) {
  document.head.innerHTML = `
    <link rel="canonical" href="x">
    <link rel="alternate" hreflang="fr" href="x">
    <link rel="alternate" hreflang="en" href="x">
    <link rel="alternate" hreflang="x-default" href="x">
    <meta name="description" content="x">
    ${withSsr ? `
    <script type="application/ld+json" id="jsonld-article">${JSON.stringify({
      '@context': 'https://schema.org', '@type': 'Article', headline: 'SR-71 Blackbird — titre serveur',
      datePublished: '2026-01-02', publisher: { '@type': 'Organization', name: "Vol d'Histoire" },
    })}</script>
    <script type="application/ld+json" id="jsonld-breadcrumb">{"@type":"BreadcrumbList","itemListElement":[]}</script>` : ''}`;
}

const state = {
  aircraftData: {
    name: 'SR-71 Blackbird', manufacturer_name: 'Lockheed', country_name: 'États-Unis',
    date_operationel: '1966-01-07T00:00:00Z', date_first_fly: '1964-12-22T00:00:00Z',
    max_speed: 3540, max_range: 5400, empty_weight: 30600, type_name: 'Reconnaissance',
  },
};

describe('updateSeoMeta — JSON-LD', () => {
  test('met à jour les blocs du serveur sans en ajouter (2 blocs, pas 4)', () => {
    mountHead(true);
    updateSeoMeta(state, 'SR-71 Blackbird', 'Avion espion', '/assets/airplanes/sr71.jpg', PAGE);
    const blocks = ldBlocks();
    expect(blocks.map(b => b['@type'])).toEqual(['Article', 'BreadcrumbList']);
    expect(document.getElementById('jsonld-vehicle')).toBeNull();
  });

  test('l\'Article garde les champs du serveur et prend le Vehicle pour objet', () => {
    mountHead(true);
    updateSeoMeta(state, 'SR-71 Blackbird', 'Avion espion', '/assets/airplanes/sr71.jpg', PAGE);
    const [article, crumbs] = ldBlocks();
    expect(article.headline).toBe('SR-71 Blackbird — titre serveur');
    expect(article.datePublished).toBe('2026-01-02');
    expect(article.about['@type']).toBe('Vehicle');
    expect(article.about['@context']).toBeUndefined();
    expect(article.about.manufacturer.name).toBe('Lockheed');
    expect(article.image).toBe('https://vol-histoire.titouan-borde.com/assets/airplanes/sr71.jpg');
    expect(crumbs.itemListElement.map(i => i.name)).toEqual(['Accueil', 'Hangar', 'SR-71 Blackbird']);
  });

  test('sans rendu serveur : crée un Article minimal et le fil d\'Ariane', () => {
    mountHead(false);
    updateSeoMeta(state, 'SR-71 Blackbird', '', 'https://example.com/a.jpg', PAGE);
    const [article] = ldBlocks();
    expect(article['@type']).toBe('Article');
    expect(article.headline).toBe('SR-71 Blackbird');
    expect(ldBlocks()).toHaveLength(2);
  });

  test('supprime un ancien bloc Vehicle autonome', () => {
    mountHead(true);
    const legacy = document.createElement('script');
    legacy.type = 'application/ld+json';
    legacy.id = 'jsonld-vehicle';
    legacy.textContent = '{"@type":"Vehicle"}';
    document.head.appendChild(legacy);
    updateSeoMeta(state, 'SR-71 Blackbird', 'd', '/a.jpg', PAGE);
    expect(ldBlocks().map(b => b['@type'])).toEqual(['Article', 'BreadcrumbList']);
  });
});

describe('updateSeoMeta — balises', () => {
  test('SEO-002 : les hreflang ne sont jamais réécrits côté client', () => {
    mountHead(true);
    updateSeoMeta(state, 'SR-71 Blackbird', 'd', '/a.jpg', PAGE);
    ['fr', 'en', 'x-default'].forEach((hl) => {
      expect(document.querySelector(`link[hreflang="${hl}"]`).getAttribute('href')).toBe('x');
    });
  });

  test.each([
    ['français', PAGE],
    ['anglais', `${PAGE}?lang=en`],
  ])('rendu serveur (%s) : tête laissée intacte, titre du serveur rétabli', (_, canonical) => {
    document.head.innerHTML = `
      <link rel="canonical" href="${canonical}">
      <meta name="description" content="Description serveur">
      <meta property="og:title" content="SR-71 Blackbird — Reconnaissance, États-Unis (1966) | Vol d'Histoire">
      <script type="application/ld+json" id="jsonld-article">{"@type":"Article","headline":"serveur"}</script>`;
    const snap = () => [...document.head.querySelectorAll('link, meta, script')].map((e) => e.outerHTML).join('');
    const before = snap();
    document.title = 'SR-71 Blackbird | Vol d\'Histoire'; // écrit par render.js
    updateSeoMeta(state, 'SR-71 Blackbird', '## Genèse\n**Markdown**', '/a.jpg', PAGE);
    expect(snap()).toBe(before);
    expect(document.title).toBe('SR-71 Blackbird — Reconnaissance, États-Unis (1966) | Vol d\'Histoire');
  });

  test('og:image absolue', () => {
    mountHead(true);
    updateSeoMeta(state, 'SR-71 Blackbird', 'd', '/assets/airplanes/sr71.jpg', PAGE);
    expect(document.querySelector('meta[property="og:image"]').content)
      .toBe('https://vol-histoire.titouan-borde.com/assets/airplanes/sr71.jpg');
  });
});

describe('updateSeoMeta — balises absentes et description', () => {
  test('crée canonical, description, og:* et twitter:* quand le HTML ne les porte pas', () => {
    document.head.innerHTML = '';
    updateSeoMeta(state, 'Rafale', 'Omnirôle', 'http://ex.com/r.jpg', PAGE);
    expect(document.querySelector('link[rel="canonical"]').href).toBe(PAGE);
    expect(document.querySelector('meta[name="description"]').content).toBe('Omnirôle');
    expect(document.querySelector('meta[property="og:title"]').content).toBe('Rafale | Vol d\'Histoire');
    expect(document.querySelector('meta[property="og:url"]').content).toBe(PAGE);
    expect(document.querySelector('meta[name="twitter:title"]').content).toBe('Rafale | Vol d\'Histoire');
    // URL d'image http forcée en https
    expect(document.querySelector('meta[name="twitter:image"]').content).toBe('https://ex.com/r.jpg');
  });

  test('balises existantes mises à jour sur place, sans doublon', () => {
    mountHead(true);
    updateSeoMeta(state, 'A', 'd1', '/a.jpg', PAGE);
    updateSeoMeta(state, 'B', 'd2', '/b.jpg', PAGE);
    expect(document.querySelectorAll('meta[property="og:title"]')).toHaveLength(1);
    expect(document.querySelectorAll('link[rel="canonical"]')).toHaveLength(1);
    expect(document.querySelector('meta[property="og:title"]').content).toBe('B | Vol d\'Histoire');
  });

  test('description tronquée sur un mot à 155 caractères + « … »', () => {
    mountHead(false);
    const long = 'a'.repeat(150) + '     ' + 'b'.repeat(50);
    updateSeoMeta(state, 'X', long, '/a.jpg', PAGE);
    expect(document.querySelector('meta[name="description"]').content).toBe('a'.repeat(150) + '…');
    mountHead(false);
    updateSeoMeta(state, 'X', 'x'.repeat(155), '/a.jpg', PAGE);
    expect(document.querySelector('meta[name="description"]').content).toBe('x'.repeat(155));
  });

  test('SEO-006 : jamais de Markdown brut, accroche en tête', () => {
    mountHead(false);
    const st = { aircraftData: { ...state.aircraftData, little_description: 'Avion espion' } };
    updateSeoMeta(st, 'SR-71', '## Genèse\nProgramme du **Skunk Works** de [Lockheed](https://x.org).\n\n## Suite\nAutre', '/a.jpg', PAGE);
    expect(document.querySelector('meta[name="description"]').content)
      .toBe('Avion espion. Programme du Skunk Works de Lockheed.');
    expect(document.querySelector('meta[property="og:description"]').content).not.toMatch(/[#*[\]]/);
  });

  test('sans description : texte générique (plus « avion de chasse »)', () => {
    mountHead(false);
    updateSeoMeta(state, 'X', null, '/a.jpg', PAGE);
    expect(document.querySelector('meta[name="description"]').content)
      .toBe('Fiche technique, armement, production et histoire de cet appareil militaire.');
  });

  test('markdownToText / plainDescription exposés', () => {
    const { markdownToText, plainDescription } = window.VH.details.data;
    expect(markdownToText('- *un* `deux`')).toBe('un deux');
    expect(plainDescription('Fini !', '')).toBe('Fini !');
    expect(plainDescription('', '')).toBe('');
  });

  test('image absente : og:image vide plutôt que « undefined »', () => {
    mountHead(false);
    updateSeoMeta(state, 'X', 'd', undefined, PAGE);
    expect(document.querySelector('meta[property="og:image"]').content).toBe('');
  });

  test('JSON-LD serveur illisible : remplacé par un Article minimal', () => {
    mountHead(false);
    const bad = document.createElement('script');
    bad.type = 'application/ld+json';
    bad.id = 'jsonld-article';
    bad.textContent = '{ pas du json';
    document.head.appendChild(bad);
    updateSeoMeta(state, 'Rafale', 'd', '/a.jpg', PAGE);
    const [article] = ldBlocks();
    expect(article.headline).toBe('Rafale');
    expect(article.inLanguage).toBe('fr');
  });

  test('un bloc #jsonld-article qui n\'est pas un Article n\'est pas repris', () => {
    mountHead(false);
    const other = document.createElement('script');
    other.type = 'application/ld+json';
    other.id = 'jsonld-article';
    other.textContent = '{"@type":"WebPage","headline":"autre"}';
    document.head.appendChild(other);
    updateSeoMeta(state, 'Rafale', 'd', '/a.jpg', PAGE);
    expect(ldBlocks()[0]).toMatchObject({ '@type': 'Article', headline: 'Rafale' });
  });
});

describe('buildVehicleLd / buildArticleLd', () => {
  const { buildVehicleLd, buildArticleLd } = window.VH.details.data;

  test('Vehicle complet : constructeur, pays, dates, unités UN/CEFACT', () => {
    const ld = buildVehicleLd({ aircraftData: { ...state.aircraftData, complete_name: 'Lockheed SR-71' } },
      'SR-71', 'd', 'https://x/i.jpg', PAGE);
    expect(ld).toMatchObject({
      '@type': 'Vehicle', name: 'SR-71', alternateName: 'Lockheed SR-71',
      vehicleConfiguration: 'Reconnaissance', vehicleModelDate: '1966',
      manufacturer: { '@type': 'Organization', name: 'Lockheed' },
      countryOfOrigin: { '@type': 'Country', name: 'États-Unis' },
      productionDate: '1964-12-22',
      speed: { value: 3540, unitCode: 'KMH' },
      weight: { value: 30600, unitCode: 'KGM' },
    });
    expect(ld.additionalProperty).toEqual([{ '@type': 'PropertyValue', name: 'Range', value: 5400, unitCode: 'KMT' }]);
  });

  test('Vehicle minimal : aucun champ undefined sérialisé', () => {
    const ld = buildVehicleLd({ aircraftData: null }, 'X', 'd', 'i', 'u');
    expect(Object.keys(ld).sort()).toEqual(['@context', '@type', 'description', 'image', 'name', 'url']);
    expect(JSON.stringify(ld)).not.toContain('undefined');
  });

  test('Article : langue courante, copie (l\'objet serveur n\'est pas modifié)', () => {
    const existing = { '@type': 'Article', headline: 'H' };
    const saved = JSON.stringify(existing);
    const prev = window.i18n.currentLang;
    window.i18n.currentLang = 'en';
    const art = buildArticleLd(existing, { '@context': 'c', '@type': 'Vehicle' }, 'N', 'd', 'i', 'u');
    window.i18n.currentLang = prev;
    expect(art.inLanguage).toBe('en');
    expect(art.about).toEqual({ '@type': 'Vehicle' });
    expect(JSON.stringify(existing)).toBe(saved);
  });

  test('Article : langue par défaut « fr » si i18n n\'est pas chargé', () => {
    const saved = window.i18n;
    delete window.i18n;
    const art = buildArticleLd(null, { '@type': 'Vehicle' }, 'N', 'd', 'i', 'u');
    window.i18n = saved;
    expect(art.inLanguage).toBe('fr');
  });
});

describe('slugify', () => {
  const { slugify } = window.VH.details.data;
  test.each([
    ['F-22 Raptor', 'f-22-raptor'],
    ['Mirage 2000-5', 'mirage-2000-5'],
    ['Su-27 « Flanker »', 'su-27-flanker'],
    ['Dassault Étendard IV', 'dassault-etendard-iv'],
    ['  --Rafale--  ', 'rafale'],
  ])('%s → %s', (input, expected) => {
    expect(slugify(input)).toBe(expected);
  });
});

describe('loadAircraftDetails / loadRelatedData', () => {
  const flush = () => new Promise((r) => setTimeout(r, 0));
  const AIRCRAFT = { id: 30, name: 'Rafale' };
  const RELATED = {
    armament: [{ name: 'MICA' }], tech: [{ name: 'RBE2' }],
    missions: [{ name: 'Supériorité aérienne' }], wars: [{ name: 'Libye' }],
  };
  let render;
  let consoleSpy;

  const res = (body, ok = true, status = 200) => Promise.resolve({ ok, status, json: () => Promise.resolve(body) });

  function stubModules(fetchImpl) {
    render = {
      renderAircraftDetails: jest.fn(), renderArmament: jest.fn(), renderTechnologies: jest.fn(),
      renderMissions: jest.fn(), finalizeCapabilities: jest.fn(), renderWars: jest.fn(),
    };
    Object.assign(window.VH.details, {
      render,
      radar: { render: jest.fn() },
      lineage: { load: jest.fn() },
      favorites: { checkFavoriteStatus: jest.fn() },
    });
    global.auth = { fetchWithTimeout: jest.fn(fetchImpl) };
  }

  beforeEach(() => {
    document.body.innerHTML = `
      <h1 id="aircraft-name">Rafale SSR</h1><p id="aircraft-complete-name"></p>
      <span id="hero-country"></span><span id="hero-manufacturer"></span><span id="hero-year"></span>
      <span id="stat-speed"></span><span id="stat-range"></span><span id="stat-weight"></span><span id="stat-status"></span>
      <p id="aircraft-description"></p>`;
    // jsdom n'implémente pas la navigation : une redirection est journalisée.
    consoleSpy = jest.spyOn(console, 'error').mockImplementation(() => {});
  });
  afterEach(() => consoleSpy.mockRestore());

  const navigated = () => consoleSpy.mock.calls.some((c) => /navigation/.test(String(c[0] && c[0].message)));

  test('squelettes de chargement posés avant la réponse', () => {
    stubModules(() => new Promise(() => {}));
    window.VH.details.data.loadAircraftDetails({ aircraftId: '30' });
    // h1 rendu par le serveur (sans data-i18n) : conservé, pas de squelette.
    expect(document.getElementById('aircraft-name').textContent).toBe('Rafale SSR');
    expect(document.querySelector('#aircraft-complete-name .skeleton-inline-md')).not.toBeNull();
    expect(document.querySelector('#hero-year .skeleton-inline-meta')).not.toBeNull();
    expect(document.querySelector('#stat-status .skeleton-inline-badge')).not.toBeNull();
    expect(document.querySelectorAll('#aircraft-description .skeleton-line')).toHaveLength(3);
  });

  test('squelette du h1 quand il porte encore le texte du gabarit', () => {
    document.getElementById('aircraft-name').setAttribute('data-i18n', 'details.aircraft_default_title');
    stubModules(() => new Promise(() => {}));
    window.VH.details.data.loadAircraftDetails({ aircraftId: '30' });
    expect(document.querySelector('#aircraft-name .skeleton-line.skeleton-inline-xl')).not.toBeNull();
  });

  test('squelettes : éléments absents tolérés', () => {
    document.body.innerHTML = '';
    stubModules(() => new Promise(() => {}));
    expect(() => window.VH.details.data.loadAircraftDetails({ aircraftId: '30' })).not.toThrow();
  });

  test('succès : état rempli, rendu, related, filiation et favori lancés', async () => {
    stubModules((url) => (url.endsWith('/related') ? res(RELATED) : res(AIRCRAFT)));
    const st = { aircraftId: '30', aircraftData: null };
    await window.VH.details.data.loadAircraftDetails(st);
    await flush();
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/airplanes/30');
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/airplanes/30/related');
    expect(st.aircraftData).toEqual(AIRCRAFT);
    expect(render.renderAircraftDetails).toHaveBeenCalledWith(st);
    expect(window.VH.details.lineage.load).toHaveBeenCalledWith(st);
    expect(window.VH.details.favorites.checkFavoriteStatus).toHaveBeenCalledWith(st);
    expect(navigated()).toBe(false);
  });

  test('404 de l\'API : redirection vers /404, rien n\'est rendu', async () => {
    stubModules(() => res({ error: 'introuvable' }, false, 404));
    await window.VH.details.data.loadAircraftDetails({ aircraftId: '999' });
    expect(render.renderAircraftDetails).not.toHaveBeenCalled();
    expect(navigated()).toBe(true);
  });

  test('400 (identifiant hors plage) : redirection vers /404', async () => {
    stubModules(() => res({ error: 'ID invalide' }, false, 400));
    await window.VH.details.data.loadAircraftDetails({ aircraftId: '99999999999' });
    expect(navigated()).toBe(true);
  });

  /* SEO-005 : une erreur passagère ne mène plus à /404. */
  const errorBox = () => document.getElementById('details-load-error');

  test.each([
    ['429 (limiteur)', () => res({}, false, 429)],
    ['500', () => res({}, false, 500)],
    ['503', () => res({}, false, 503)],
    ['délai dépassé / réseau', () => Promise.reject(new Error('AbortError'))],
    ['JSON illisible', () => Promise.resolve({ ok: true, status: 200, json: () => Promise.reject(new Error('json')) })],
  ])('%s : pas de redirection, état d\'erreur avec « Réessayer »', async (_, impl) => {
    stubModules(impl);
    await window.VH.details.data.loadAircraftDetails({ aircraftId: '30' });
    expect(navigated()).toBe(false);
    expect(render.renderAircraftDetails).not.toHaveBeenCalled();
    const box = errorBox();
    expect(box).not.toBeNull();
    expect(box.getAttribute('role')).toBe('alert');
    expect(box.querySelector('h3').textContent).toBe('details.load_error_title');
    expect(box.querySelector('button').textContent).toBe('details.retry');
    expect(document.getElementById('aircraft-description').hidden).toBe(true);
    // Squelettes retirés, h1 du serveur conservé.
    expect(document.querySelector('.skeleton-line')).toBeNull();
    expect(document.getElementById('aircraft-name').textContent).toBe('Rafale SSR');
  });

  test('h1 vidé par le squelette : titre par défaut rétabli dans l\'état d\'erreur', async () => {
    document.getElementById('aircraft-name').setAttribute('data-i18n', 'x');
    stubModules(() => res({}, false, 500));
    await window.VH.details.data.loadAircraftDetails({ aircraftId: '30' });
    expect(document.getElementById('aircraft-name').textContent).toBe('details.aircraft_default_title');
  });

  test('« Réessayer » relance le chargement ; succès : l\'erreur disparaît', async () => {
    let calls = 0;
    stubModules((url) => {
      if (url.endsWith('/related')) return res(RELATED);
      calls += 1;
      return calls === 1 ? res({}, false, 429) : res(AIRCRAFT);
    });
    const st = { aircraftId: '30' };
    await window.VH.details.data.loadAircraftDetails(st);
    expect(errorBox()).not.toBeNull();
    errorBox().querySelector('button').click();
    await flush();
    await flush();
    expect(errorBox()).toBeNull();
    expect(document.getElementById('aircraft-description').hidden).toBe(false);
    expect(st.aircraftData).toEqual(AIRCRAFT);
    expect(render.renderAircraftDetails).toHaveBeenCalledWith(st);
    expect(navigated()).toBe(false);
  });

  test('deux échecs de suite : un seul encart d\'erreur', async () => {
    stubModules(() => res({}, false, 503));
    const st = { aircraftId: '30' };
    await window.VH.details.data.loadAircraftDetails(st);
    await window.VH.details.data.loadAircraftDetails(st);
    expect(document.querySelectorAll('#details-load-error')).toHaveLength(1);
  });

  test('showLoadError sans zone de description : sans effet', () => {
    document.body.innerHTML = '';
    expect(() => window.VH.details.data.showLoadError({})).not.toThrow();
    expect(errorBox()).toBeNull();
  });

  test('related : chaque section rendue avec sa liste, puis le radar', async () => {
    stubModules(() => res(RELATED));
    const st = { aircraftId: '30' };
    await window.VH.details.data.loadRelatedData(st);
    expect(render.renderArmament).toHaveBeenCalledWith(RELATED.armament);
    expect(render.renderTechnologies).toHaveBeenCalledWith(RELATED.tech);
    expect(render.renderMissions).toHaveBeenCalledWith(RELATED.missions);
    expect(render.finalizeCapabilities).toHaveBeenCalled();
    expect(render.renderWars).toHaveBeenCalledWith(RELATED.wars);
    expect(window.VH.details.radar.render).toHaveBeenCalledWith(st, RELATED.armament, RELATED.tech, RELATED.missions);
  });

  test('related en erreur : silencieux, rien n\'est rendu, pas de redirection', async () => {
    stubModules(() => res({}, false, 500));
    await expect(window.VH.details.data.loadRelatedData({ aircraftId: '30' })).resolves.toBeUndefined();
    expect(render.renderArmament).not.toHaveBeenCalled();
    expect(navigated()).toBe(false);
  });
});
