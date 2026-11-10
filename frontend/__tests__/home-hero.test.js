/**
 * Tests — widgets et effets du hero de l'accueil (js/home/hero-*.js,
 * js/home/page-effects.js, point d'entrée js/script.js). Découpage ARCH-004
 * de l'ancien script.js monolithique.
 */

const utils = require('../js/utils');

const HERO_DOM = `
  <a href="#cible" id="ancre">Aller</a><a href="#" id="vide">Vide</a>
  <div class="hero-split-meta">
    <span id="hero-split-stat-airplanes">400</span><span id="hero-split-stat-countries">30</span><span id="hero-split-stat-generations">5</span>
  </div>
  <div class="hero-aside">
    <div id="hero-quiz-card">
      <img id="hero-quiz-image" alt="">
      <span id="hero-quiz-daily-tag" hidden>Du jour</span>
      <div id="hero-quiz-options">
        <button class="hero-quiz-option"></button><button class="hero-quiz-option"></button><button class="hero-quiz-option"></button>
      </div>
      <a id="hero-quiz-link" href="#" hidden><span id="hero-quiz-link-label"></span></a>
      <button id="hero-quiz-reroll">Autre</button>
    </div>
    <div id="hero-fact-card">
      <span id="hero-fact-label">Saviez-vous ?</span>
      <p id="hero-fact-body" data-i18n="home.hero_fact_loading">Tirage en cours…</p>
      <a id="hero-fact-link" href="#">Voir</a>
      <button id="hero-fact-reroll">Autre</button>
    </div>
  </div>
  <section id="cible"></section>
  <img id="photo" src="x.jpg" alt="">`;

const AIRCRAFT = [
  { id: 1, name: 'Rafale', image_url: '/a/rafale.jpg', generation: 4 },
  { id: 2, name: 'F-22 Raptor', image_url: '/a/f22.jpg', generation: 5 },
  { id: 3, name: 'Su-57', image_url: '/a/su57.jpg', generation: 5 },
  { id: 4, name: 'F-35', image_url: '/a/f35.jpg', generation: 5 },
  { name: 'Mirage III', image_url: '/a/m3.jpg', generation: 2 },
];

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}

let auth;

function loadModules({ withDaily = true } = {}) {
  jest.resetModules();
  window.VH = {};
  if (withDaily) require('../js/home/hero-daily');
  require('../js/home/hero-helpers');
  require('../js/home/hero-data');
  require('../js/home/hero-today');
  require('../js/home/hero-quiz');
  require('../js/home/hero-stats');
  require('../js/home/page-effects');
  return window.VH.home;
}

beforeEach(() => {
  document.body.innerHTML = HERO_DOM;
  document.documentElement.lang = 'fr';
  global.escapeHtml = utils.escapeHtml;
  global.setNumberPopIn = jest.fn((el, v) => { el.textContent = String(v); });
  global.i18n = { getLang: () => 'fr', t: jest.fn((k) => k) }; // clés absentes : repli littéral
  auth = {
    init: jest.fn(() => Promise.resolve(null)),
    fetchWithTimeout: jest.fn(() => Promise.resolve(jsonResponse(500, {}))),
  };
  global.auth = auth;
  window.matchMedia = jest.fn(() => ({ matches: false }));
  window.Element.prototype.scrollIntoView = jest.fn();
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
  delete global.i18n;
});

describe('VH.home.heroHelpers', () => {
  test('nameToSearchSlug, airplaneHref', () => {
    const { heroHelpers: h } = loadModules();
    expect(h.nameToSearchSlug('  F-15  Eagle ')).toBe('f-15+eagle');
    expect(h.nameToSearchSlug(null)).toBe('');
    expect(h.airplaneHref(12, 'X')).toBe('/details?id=12');
    expect(h.airplaneHref(null, 'F-15 Eagle')).toBe('/hangar?search=f-15%2Beagle');
  });

  test('getHeroLang : i18n puis attribut lang du document', () => {
    const { heroHelpers: h } = loadModules();
    expect(h.getHeroLang()).toBe('fr');
    global.i18n = { getLang: () => 'en' };
    expect(h.getHeroLang()).toBe('en');
    delete global.i18n;
    document.documentElement.lang = 'en';
    expect(h.getHeroLang()).toBe('en');
    document.documentElement.lang = 'de';
    expect(h.getHeroLang()).toBe('fr');
  });

  test('tHero : traduction, sinon repli FR / EN avec paramètres', () => {
    const { heroHelpers: h } = loadModules();
    expect(h.tHero('k', { name: 'X' }, 'Vol : {name}', 'Flight: {name}')).toBe('Vol : X');
    global.i18n = { getLang: () => 'en', t: () => 'k' };
    expect(h.tHero('k', null, 'FR', 'EN')).toBe('EN');
    global.i18n = { getLang: () => 'fr', t: () => 'Traduit' };
    expect(h.tHero('k', {}, 'FR', 'EN')).toBe('Traduit');
  });

  test('shuffleArr : permutation sans modifier la source', () => {
    const { heroHelpers: h } = loadModules();
    const src = [1, 2, 3, 4];
    const out = h.shuffleArr(src);
    expect(out.slice().sort()).toEqual([1, 2, 3, 4]);
    expect(src).toEqual([1, 2, 3, 4]);
  });

  test('daily() : null sans hero-daily.js', () => {
    expect(loadModules({ withDaily: false }).heroHelpers.daily()).toBeNull();
  });
});

describe('VH.home.heroData', () => {
  test('réponse complète conservée', async () => {
    const { heroData } = loadModules();
    const payload = { facts: [{ year: 1 }], aircraft: AIRCRAFT, ephemeris: [{ kind: 'service' }], day: '2026-11-10' };
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(200, payload));
    await expect(heroData.fetchHeroDiscoveries()).resolves.toEqual(payload);
  });

  test('champs vides ou invalides : repli champ par champ', () => {
    const { heroData } = loadModules();
    const out = heroData.normalizeDiscoveries({ facts: [], aircraft: 'x', day: '' }, '2026-01-01');
    expect(out.facts).toBe(heroData.FALLBACK_FACTS);
    expect(out.aircraft).toBe(heroData.FALLBACK_AIRCRAFT);
    expect(out.ephemeris).toEqual([]);
    expect(out.day).toBe('2026-01-01');
  });

  test('API en erreur : données de repli et jour local', async () => {
    const { heroData } = loadModules();
    const out = await heroData.fetchHeroDiscoveries();
    expect(out.facts).toBe(heroData.FALLBACK_FACTS);
    expect(out.day).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    const noDaily = loadModules({ withDaily: false });
    expect((await noDaily.heroData.fetchHeroDiscoveries()).day).toBe('');
  });
});

describe('VH.home.heroToday', () => {
  const EPHEMERIS = [
    { kind: 'first_flight', airplane_id: 9, airplane_name: 'Mirage <III>', airplane_name_en: 'Mirage III EN', event_date: '1956-11-17', day_gap: 0 },
    { kind: 'service', airplane_name: 'F-15 Eagle', event_date: '1976-11-14', day_gap: 0 },
  ];

  test('anniversaires du jour : libellé, date, phrase échappée, lien ; tirage suivant', () => {
    const { heroToday } = loadModules();
    heroToday.init(EPHEMERIS, [], '2026-11-17');
    const body = document.getElementById('hero-fact-body');
    expect(body.hasAttribute('data-i18n')).toBe(false);
    expect(body.classList.contains('is-fading-in')).toBe(true);
    expect(document.getElementById('hero-fact-label').textContent).toBe('Ce jour-là');
    expect(body.innerHTML).toContain('<strong>Mirage &lt;III&gt;</strong>');
    expect(body.querySelector('.hero-fact-date')).not.toBeNull();
    expect(document.getElementById('hero-fact-link').getAttribute('href')).toBe('/details?id=9');

    document.getElementById('hero-fact-reroll').click();
    expect(body.textContent).toContain('Mise en service');
    expect(document.getElementById('hero-fact-link').getAttribute('href')).toBe('/hangar?search=f-15%2Beagle');
  });

  test('semaine : libellé « Cette semaine-là » ; un seul anniversaire : bouton masqué', () => {
    const { heroToday } = loadModules();
    heroToday.init([{ ...EPHEMERIS[0], day_gap: 2 }], [], '2026-11-15');
    expect(document.getElementById('hero-fact-label').textContent).toBe('Cette semaine-là');
    expect(document.getElementById('hero-fact-reroll').hasAttribute('hidden')).toBe(true);
  });

  test('sans anniversaire : fait du jour, nom en gras, tirage aléatoire au bouton', () => {
    const { heroToday } = loadModules();
    const facts = [
      { year: 1961, airplane_name: 'Mirage III', title_fr: 'Le Mirage III passe Mach 2.' },
      { year: 1976, airplane_name: 'F-15 Eagle', title_fr: 'Le F-15 Eagle entre en service.' },
    ];
    jest.spyOn(Math, 'random').mockReturnValue(0);
    heroToday.init([], facts, '2026-11-10');
    const body = document.getElementById('hero-fact-body');
    expect(document.getElementById('hero-fact-label').textContent).toBe('Saviez-vous ?');
    expect(body.querySelector('strong')).not.toBeNull();
    document.getElementById('hero-fact-reroll').click();
    expect(body.textContent).toContain('1961');
    expect(body.querySelector('strong').textContent).toBe('Mirage III');
    expect(document.getElementById('hero-fact-link').getAttribute('href')).toBe('/hangar?search=mirage%2Biii');
  });

  test('fait sans nom ni année, avec id ; langue anglaise au changement de langue', () => {
    const { heroToday } = loadModules({ withDaily: false });
    heroToday.init([], [{ title_fr: 'Titre', title_en: 'Title', airplane_id: 4 }], '');
    expect(document.getElementById('hero-fact-link').getAttribute('href')).toBe('/details?id=4');
    expect(document.getElementById('hero-fact-body').innerHTML).toBe('Titre');
    global.i18n = { getLang: () => 'en', t: (k) => k };
    window.dispatchEvent(new window.Event('langChanged'));
    expect(document.getElementById('hero-fact-label').textContent).toBe('Did you know?');
    expect(document.getElementById('hero-fact-body').innerHTML).toBe('Title');
  });

  test('fait sans nom ni id : lien « # » ; aucun fait : rien', () => {
    const { heroToday } = loadModules({ withDaily: false });
    heroToday.init([], [{ title_fr: 'T' }], '');
    expect(document.getElementById('hero-fact-link').getAttribute('href')).toBe('#');
    document.body.innerHTML = HERO_DOM;
    heroToday.init([], [], '');
    expect(document.getElementById('hero-fact-body').textContent).toBe('Tirage en cours…');
  });

  test('sans corps de widget : sans effet', () => {
    const { heroToday } = loadModules();
    document.getElementById('hero-fact-body').remove();
    expect(() => heroToday.init(EPHEMERIS, [], '2026-11-17')).not.toThrow();
  });

  test('phrases en anglais', () => {
    const { heroToday } = loadModules();
    global.i18n = { getLang: () => 'en', t: (k) => k };
    expect(heroToday.entrySentence(EPHEMERIS[0], 'en').sentence).toBe('First flight: <strong>Mirage III EN</strong>');
    expect(heroToday.factSentence({ title_fr: 'FR seul', airplane_name: '' }, 'en').sentence).toBe('FR seul');
  });
});

describe('VH.home.heroQuiz', () => {
  test('appareil du jour : propositions, étiquette « du jour », image', () => {
    const { heroQuiz } = loadModules();
    heroQuiz.init(AIRCRAFT, '2026-11-10');
    const opts = [...document.querySelectorAll('.hero-quiz-option')].map((b) => b.textContent);
    expect(new Set(opts).size).toBe(3);
    expect(document.getElementById('hero-quiz-daily-tag').hasAttribute('hidden')).toBe(false);
    expect(document.getElementById('hero-quiz-image').getAttribute('src')).toMatch(/^\/a\//);
    expect(document.getElementById('hero-quiz-link').hasAttribute('hidden')).toBe(true);
  });

  test('tirage déterministe : même jour, mêmes propositions', () => {
    const run = () => {
      document.body.innerHTML = HERO_DOM;
      loadModules().heroQuiz.init(AIRCRAFT, '2026-11-10');
      return [...document.querySelectorAll('.hero-quiz-option')].map((b) => b.textContent);
    };
    expect(run()).toEqual(run());
  });

  test('bonne réponse : boutons bloqués, lien vers la fiche', () => {
    const { heroQuiz } = loadModules();
    heroQuiz.init(AIRCRAFT, '2026-11-10');
    const answer = document.getElementById('hero-quiz-image').getAttribute('src');
    const target = AIRCRAFT.find((a) => a.image_url === answer);
    const btn = [...document.querySelectorAll('.hero-quiz-option')].find((b) => b.dataset.value === target.name);
    btn.click();
    expect(btn.classList.contains('is-correct')).toBe(true);
    expect([...document.querySelectorAll('.hero-quiz-option')].every((b) => b.disabled)).toBe(true);
    expect(document.getElementById('hero-quiz-card').classList.contains('is-revealed')).toBe(true);
    expect(document.getElementById('hero-quiz-link-label').textContent).toBe('Bien joué — voir la fiche');
    expect(document.getElementById('hero-quiz-link').hasAttribute('hidden')).toBe(false);
    btn.click(); // déjà répondu : sans effet
  });

  test('mauvaise réponse puis nouveau tirage aléatoire (repli sans hero-daily)', () => {
    const { heroQuiz } = loadModules({ withDaily: false });
    jest.spyOn(Math, 'random').mockReturnValue(0.99); // Mirage III, sans id
    heroQuiz.init(AIRCRAFT, '');
    expect(document.getElementById('hero-quiz-daily-tag').hasAttribute('hidden')).toBe(true);
    const wrong = [...document.querySelectorAll('.hero-quiz-option')].find((b) => b.dataset.value !== 'Mirage III');
    wrong.click();
    expect(wrong.classList.contains('is-wrong')).toBe(true);
    expect(document.getElementById('hero-quiz-link-label').textContent).toBe('C’était le Mirage III — voir la fiche');
    expect(document.getElementById('hero-quiz-link').getAttribute('href')).toBe('/hangar?search=mirage%2Biii');
    document.getElementById('hero-quiz-reroll').click();
    expect([...document.querySelectorAll('.hero-quiz-option')].some((b) => b.disabled)).toBe(false);
  });

  test('picture partagé utilisé quand il existe', () => {
    const home = loadModules();
    window.VH.shared = { picture: { applySourcesTo: jest.fn() } };
    home.heroQuiz.init(AIRCRAFT, '2026-11-10');
    expect(window.VH.shared.picture.applySourcesTo).toHaveBeenCalledWith(document.getElementById('hero-quiz-image'), expect.stringMatching(/^\/a\//));
  });

  test('pickDecoys : même génération si possible, sinon tout le pool', () => {
    const { heroQuiz } = loadModules();
    const random = () => 0;
    expect(heroQuiz.pickDecoys(AIRCRAFT, AIRCRAFT[1], random).every((n) => ['Su-57', 'F-35'].includes(n))).toBe(true);
    expect(heroQuiz.pickDecoys(AIRCRAFT, AIRCRAFT[0], random)).toHaveLength(2);
  });

  test('moins de trois appareils ou carte absente : rien', () => {
    const { heroQuiz } = loadModules();
    heroQuiz.init(AIRCRAFT.slice(0, 2), '2026-11-10');
    expect(document.querySelector('.hero-quiz-option').textContent).toBe('');
  });
});

describe('VH.home.heroStats', () => {
  test('compteurs mis à jour depuis /api/stats ; valeurs non numériques ignorées', async () => {
    const { heroStats } = loadModules();
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(200, { airplanes: 434, countries: 'x', generations: 6 }));
    await heroStats.fetchHeroStats();
    expect(document.getElementById('hero-split-stat-airplanes').textContent).toBe('434');
    expect(document.getElementById('hero-split-stat-countries').textContent).toBe('30');
    expect(document.getElementById('hero-split-stat-generations').textContent).toBe('6');
  });

  test('API en erreur : valeurs du HTML conservées ; aucun compteur : aucun appel', async () => {
    const { heroStats } = loadModules();
    await heroStats.fetchHeroStats();
    expect(document.getElementById('hero-split-stat-airplanes').textContent).toBe('400');
    document.querySelector('.hero-split-meta').innerHTML = '';
    auth.fetchWithTimeout.mockClear();
    await heroStats.fetchHeroStats();
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('observe : un seul chargement quand le bloc devient visible', () => {
    const { heroStats } = loadModules();
    let callback;
    const unobserve = jest.fn();
    window.IntersectionObserver = jest.fn((cb) => { callback = cb; return { observe: jest.fn(), unobserve }; });
    heroStats.observe();
    const target = document.querySelector('.hero-split-meta');
    callback([{ isIntersecting: false, target }]);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    callback([{ isIntersecting: true, target }, { isIntersecting: true, target }]);
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
    expect(unobserve).toHaveBeenCalledWith(target);
    document.querySelector('.hero-split-meta').remove();
    window.IntersectionObserver.mockClear();
    heroStats.observe();
    expect(window.IntersectionObserver).not.toHaveBeenCalled();
  });
});

describe('VH.home.pageEffects', () => {
  test('ancres internes : défilement doux ; « # » seul ignoré', () => {
    const { pageEffects } = loadModules();
    pageEffects.smoothAnchors();
    document.getElementById('ancre').click();
    expect(window.Element.prototype.scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth', block: 'start' });
    window.matchMedia = jest.fn(() => ({ matches: true }));
    document.getElementById('ancre').click();
    expect(window.Element.prototype.scrollIntoView).toHaveBeenLastCalledWith({ behavior: 'auto', block: 'start' });
    window.Element.prototype.scrollIntoView.mockClear();
    document.getElementById('vide').click();
    document.getElementById('ancre').setAttribute('href', '/hangar');
    document.getElementById('ancre').addEventListener('click', (e) => e.preventDefault());
    document.getElementById('ancre').click();
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
    document.getElementById('cible').remove();
    document.getElementById('ancre').setAttribute('href', '#cible');
    document.getElementById('ancre').click();
    expect(window.Element.prototype.scrollIntoView).not.toHaveBeenCalled();
  });

  test('fondu des images au chargement', () => {
    jest.useFakeTimers();
    const { pageEffects } = loadModules();
    pageEffects.fadeInImages();
    const img = document.getElementById('photo');
    img.dispatchEvent(new window.Event('load'));
    expect(img.style.opacity).toBe('0');
    jest.advanceTimersByTime(10);
    expect(img.style.opacity).toBe('1');
  });

  test('ordre des widgets : « Ce jour-là » remis avant le quiz', () => {
    const { pageEffects } = loadModules();
    pageEffects.ensureHeroAsideOrder();
    const aside = document.querySelector('.hero-aside');
    expect(aside.firstElementChild.id).toBe('hero-fact-card');
    pageEffects.ensureHeroAsideOrder(); // déjà dans l'ordre : inchangé
    expect(aside.firstElementChild.id).toBe('hero-fact-card');
    document.getElementById('hero-quiz-card').remove();
    expect(() => pageEffects.ensureHeroAsideOrder()).not.toThrow();
  });

  test('apparition en fondu du corps de page', () => {
    jest.useFakeTimers();
    const { pageEffects } = loadModules();
    pageEffects.revealBody();
    expect(document.body.style.opacity).toBe('0');
    jest.advanceTimersByTime(100);
    expect(document.body.style.opacity).toBe('1');
  });
});

describe('script.js — point d\'entrée de l\'accueil', () => {
  test('après auth.init() : effets branchés, un seul appel API pour les deux widgets', async () => {
    loadModules();
    window.IntersectionObserver = jest.fn(() => ({ observe: jest.fn(), unobserve: jest.fn() }));
    auth.fetchWithTimeout.mockResolvedValue(jsonResponse(200, { facts: [], aircraft: AIRCRAFT, ephemeris: [], day: '2026-11-10' }));
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/script');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
    await new Promise((r) => setTimeout(r, 0));
    expect(auth.init).toHaveBeenCalledTimes(1);
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/hero/discoveries');
    expect(window.IntersectionObserver).toHaveBeenCalledTimes(1);
    expect(document.querySelector('.hero-aside').firstElementChild.id).toBe('hero-fact-card');
    expect(document.getElementById('hero-fact-label').textContent).toBe('Saviez-vous ?');
    expect(document.querySelector('.hero-quiz-option').textContent).not.toBe('');
  });
});
