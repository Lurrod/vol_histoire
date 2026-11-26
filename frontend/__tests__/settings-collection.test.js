/**
 * Tests — « Ma collection » et en-tête d'identité des réglages
 * (js/settings/collection.js, js/settings/identity.js) et dernière fiche
 * consultée (js/shared/last-viewed.js, écrite par details/data.js).
 */
global.DOMPurify = require('dompurify');
const { jsonResponse, flush, env, rolled, loadModules, resetEnv } = require('./helpers/settings-env');

let auth;

beforeEach(() => {
  resetEnv();
  ({ auth } = env);
  window.requestAnimationFrame = (cb) => cb();
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
});

const FAVS = [
  { id: 30, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg', date_operationel: '2001-05-18', country_name: 'France', country_name_en: 'France', country_code: 'FRA' },
  { id: 12, name: 'F-22 Raptor', image_url: '/assets/airplanes/f22.jpg', date_operationel: '2005-12-15', country_name: 'États-Unis', country_name_en: 'United States', country_code: 'USA' },
  { id: 7, name: 'F-86 Sabre', image_url: null, date_operationel: '1949-02-01', country_name: 'États-Unis', country_name_en: 'United States', country_code: 'USA' },
  { id: 8, name: 'Prototype', image_url: null, date_operationel: null, country_name: 'Tchécoslovaquie', country_code: 'XXX' },
  { id: 9, name: 'Sans pays', date_operationel: '1300-01-01' },
];

describe('VH.lastViewed (shared/last-viewed.js)', () => {
  test('enregistre une fiche nettoyée et la relit', () => {
    loadModules();
    const lv = window.VH.lastViewed;
    expect(lv.save({ id: '30', name: '  Rafale  ', image_url: '/assets/airplanes/rafale.jpg', extra: 'x' })).toBe(true);
    expect(JSON.parse(localStorage.getItem(lv.KEY))).toEqual({ id: 30, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg' });
    expect(lv.read()).toEqual({ id: 30, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg' });
  });

  test('refuse les entrées inexploitables et les images douteuses', () => {
    loadModules();
    const lv = window.VH.lastViewed;
    expect(lv.save(null)).toBe(false);
    expect(lv.save({ id: 0, name: 'x' })).toBe(false);
    expect(lv.save({ id: 3, name: '' })).toBe(false);
    expect(lv.save({ id: 'abc', name: 'x' })).toBe(false);
    lv.save({ id: 3, name: 'X', image_url: 'javascript:alert(1)' });
    expect(lv.read().image_url).toBeNull();
    lv.save({ id: 3, name: 'X', image_url: '//evil.example/a.jpg' });
    expect(lv.read().image_url).toBeNull();
    lv.save({ id: 3, name: 'X', image_url: 'https://upload.wikimedia.org/a.jpg' });
    expect(lv.read().image_url).toBe('https://upload.wikimedia.org/a.jpg');
    expect(lv.save({ id: 3, name: 'n'.repeat(500) })).toBe(true);
    expect(lv.read().name).toHaveLength(200);
  });

  test('lecture : JSON invalide, contenu falsifié ou stockage refusé → null', () => {
    loadModules();
    const lv = window.VH.lastViewed;
    expect(lv.read()).toBeNull();
    localStorage.setItem(lv.KEY, '{');
    expect(lv.read()).toBeNull();
    localStorage.setItem(lv.KEY, JSON.stringify({ id: -1, name: 'x' }));
    expect(lv.read()).toBeNull();
    localStorage.setItem(lv.KEY, '"texte"');
    expect(lv.read()).toBeNull();
    jest.spyOn(window.Storage.prototype, 'setItem').mockImplementation(() => { throw new Error('quota'); });
    expect(lv.save({ id: 1, name: 'x' })).toBe(false);
  });
});

describe('VH.settings.identity', () => {
  test('roleBadge et memberSince (fr, en, absent, illisible)', () => {
    const { identity } = loadModules();
    expect(identity.roleBadge(1).cls).toBe('role-admin');
    expect(identity.roleBadge(2).cls).toBe('role-editor');
    expect(identity.roleBadge(NaN).cls).toBe('role-member');
    expect(identity.memberSince('2025-03-04T10:00:00Z', 'fr')).toBe('mars 2025');
    expect(identity.memberSince('2025-03-04T10:00:00Z', 'en')).toBe('March 2025');
    expect(identity.memberSince(null, 'fr')).toBeNull();
    expect(identity.memberSince('pas une date', 'fr')).toBeNull();
  });

  test('render : initiale, nom, rôle, date d’inscription ; sans date : masquée', () => {
    const { identity } = loadModules();
    identity.render({ name: 'chef', role: 2, created_at: '2025-03-04' });
    expect(document.getElementById('id-avatar').textContent).toBe('C');
    expect(document.getElementById('id-name').textContent).toBe('chef');
    expect(document.getElementById('id-role').className).toBe('role-pill role-editor');
    expect(document.getElementById('id-role').textContent).toBe('t:common.role_editor');
    const since = document.getElementById('id-since');
    expect(since.hidden).toBe(false);
    expect(since.textContent).toBe('t:settings.member_since:{"date":"mars 2025"}');
    identity.render(null);
    expect(document.getElementById('id-name').textContent).toBe('t:settings.user_default');
    expect(since.hidden).toBe(true);
    expect(since.textContent).toBe('');
  });

  test('render et compteur sans i18n ni éléments : replis, aucune erreur', () => {
    const { identity } = loadModules();
    delete global.i18n;
    identity.render({ name: 'Zoé', role: 1, created_at: '2024-11-02' });
    expect(document.getElementById('id-since').textContent).toBe('Membre depuis novembre 2024');
    document.querySelector('.settings-id').remove();
    expect(() => identity.render({ name: 'x' })).not.toThrow();
    expect(() => identity.setFavoriteCount(2)).not.toThrow();
  });

  test('setFavoriteCount : odomètre et libellé accordé ; sans odomètre : texte', () => {
    const { identity } = loadModules();
    identity.setFavoriteCount(1);
    expect(rolled('id-fav-count')).toBe('1');
    expect(document.getElementById('id-fav-label').textContent).toBe('t:settings.id_favorites_one');
    identity.setFavoriteCount('x');
    expect(rolled('id-fav-count')).toBe('0');
    expect(document.getElementById('id-fav-label').textContent).toBe('t:settings.id_favorites_many');
    delete window.VH.rollingNumber;
    identity.setFavoriteCount(4);
    expect(document.getElementById('id-fav-count').textContent).toBe('4');
  });

  test('changement de langue : re-rendu une fois l’utilisateur et le compteur connus', () => {
    const { identity } = loadModules();
    identity.init();
    window.dispatchEvent(new window.Event('langChanged')); // rien encore
    identity.render({ name: 'A', role: 3 });
    identity.setFavoriteCount(3);
    i18n.t.mockImplementation((k, p) => `en:${k}${p ? JSON.stringify(p) : ''}`);
    window.dispatchEvent(new window.Event('langChanged'));
    expect(document.getElementById('id-role').textContent).toBe('en:nav.user_role');
    expect(document.getElementById('id-fav-label').textContent).toBe('en:settings.id_favorites_many');
  });
});

describe('VH.settings.collection — calculs', () => {
  test('yearOf : année valide ou null', () => {
    const { collection } = loadModules();
    expect(collection.yearOf(FAVS[0])).toBe(2001);
    expect(collection.yearOf(FAVS[3])).toBeNull();
    expect(collection.yearOf(FAVS[4])).toBeNull(); // hors bornes
    expect(collection.yearOf({ date_operationel: 'n/a' })).toBeNull();
    expect(collection.yearOf(null)).toBeNull();
  });

  test('decadeStats : de la première à la dernière décennie, vides comprises ; sans date', () => {
    const { collection } = loadModules();
    const stats = collection.decadeStats(FAVS);
    expect(stats.decades.map((d) => d.decade)).toEqual([1940, 1950, 1960, 1970, 1980, 1990, 2000]);
    expect(stats.decades[0].count).toBe(1);
    expect(stats.decades.at(-1).count).toBe(2);
    expect(stats.undated).toBe(2);
    expect(stats.max).toBe(2);
    expect(collection.decadeStats([FAVS[3]])).toEqual({ decades: [], undated: 1, max: 0 });
  });

  test('countryStats : tri par nombre puis par nom, noms anglais, pays absent ignoré', () => {
    const { collection } = loadModules();
    expect(collection.countryStats(FAVS, 'fr').map((c) => [c.name, c.count])).toEqual([
      ['États-Unis', 2], ['France', 1], ['Tchécoslovaquie', 1],
    ]);
    expect(collection.countryStats(FAVS, 'en').map((c) => c.name)).toEqual(['United States', 'France', 'Tchécoslovaquie']);
  });

  test('flagSrc : drapeau local ou null', () => {
    const { collection } = loadModules();
    expect(collection.flagSrc('FRA')).toBe('/assets/flags/fr.png');
    expect(collection.flagSrc('XXX')).toBeNull();
    expect(collection.flagSrc(null)).toBeNull();
    expect(collection.flagSrc('toString')).toBeNull();
    delete window.VH.shared.ALPHA3_TO_ALPHA2;
    expect(collection.flagSrc('FRA')).toBeNull();
  });
});

describe('VH.settings.collection — rendu', () => {
  test('load : vignettes liées à la fiche (morphing), décennies, pays, compteur de l’en-tête', async () => {
    const S = loadModules();
    auth.authFetch.mockResolvedValue(jsonResponse(200, FAVS));
    const count = jest.spyOn(S.identity, 'setFavoriteCount');
    await S.collection.load();
    expect(auth.authFetch).toHaveBeenCalledWith('/api/favorites');
    expect(document.getElementById('col-content').hidden).toBe(false);
    expect(document.getElementById('col-empty').hidden).toBe(true);
    expect(document.getElementById('col-status').hidden).toBe(true);
    expect(count).toHaveBeenCalledWith(5);

    const items = document.querySelectorAll('#col-strip .col-item');
    expect(items).toHaveLength(5);
    expect(items[0].dataset.morphId).toBe('30');
    expect(items[0].querySelector('a').getAttribute('href')).toBe('/details/rafale-30');
    expect(items[0].querySelector('[data-morph="photo"] picture source').getAttribute('srcset')).toContain('/thumbs/rafale');
    // Sans photo : illustration de repli.
    expect(items[2].querySelector('img').getAttribute('src')).toContain('placeholder-airplane-fr.svg');

    const decades = document.querySelectorAll('#col-decades .col-decade');
    expect(decades).toHaveLength(7);
    expect(decades[1].classList.contains('is-empty')).toBe(true);
    expect(decades[6].querySelector('.col-decade-bar').style.getPropertyValue('--col-h')).toBe('100.0');
    expect(decades[0].querySelector('.col-decade-bar').style.getPropertyValue('--col-h')).toBe('50.0');
    expect(decades[0].querySelector('.sr-only').textContent).toBe('t:settings.collection_decade_sr:{"decade":1940,"count":1}');
    const undated = document.getElementById('col-undated');
    expect(undated.hidden).toBe(false);
    expect(undated.textContent).toBe('t:settings.collection_undated_many:{"count":2}');

    const countries = document.querySelectorAll('#col-countries .col-country');
    expect(countries).toHaveLength(3);
    expect(countries[0].querySelector('img').getAttribute('src')).toBe('/assets/flags/us.png');
    expect(countries[0].querySelector('.col-country-fill').style.getPropertyValue('--col-w')).toBe('100.0%');
    expect(countries[2].querySelector('img')).toBeNull(); // code inconnu : pas de drapeau
  });

  test('plus de 8 favoris et de 6 pays : bande limitée, « + n autres pays »', () => {
    const { collection } = loadModules();
    const many = Array.from({ length: 10 }, (_, i) => ({ id: i + 1, name: `A${i}`, country_name: `Pays ${i}`, date_operationel: '1990-01-02' }));
    collection.render(many);
    expect(document.querySelectorAll('#col-strip .col-item')).toHaveLength(8);
    expect(document.querySelector('.col-country-more').textContent).toBe('t:settings.collection_more_countries_many:{"count":4}');
    expect(document.getElementById('col-undated').hidden).toBe(true);
    collection.render(many.slice(0, 7));
    expect(document.querySelector('.col-country-more').textContent).toBe('t:settings.collection_more_countries_one:{"count":1}');
  });

  test('aucun favori : invitation ; liste invalide traitée comme vide', async () => {
    const S = loadModules();
    auth.authFetch.mockResolvedValue(jsonResponse(200, { pas: 'un tableau' }));
    await S.collection.load();
    expect(document.getElementById('col-empty').hidden).toBe(false);
    expect(document.getElementById('col-content').hidden).toBe(true);
    S.collection.render(undefined);
    expect(document.getElementById('col-empty').hidden).toBe(false);
  });

  test('erreur serveur ou réseau : message d’erreur dans la zone d’état', async () => {
    const S = loadModules();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    await S.collection.load();
    expect(document.getElementById('col-status').textContent).toBe('t:settings.collection_error');
    expect(document.getElementById('col-status').hidden).toBe(false);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.collection.load();
    expect(document.getElementById('col-status').textContent).toBe('t:settings.collection_error');
  });

  test('dernière fiche consultée : affichée même sans favori, liée à la fiche ; absente : masquée', () => {
    const { collection } = loadModules();
    collection.renderLastViewed();
    expect(document.getElementById('col-last').hidden).toBe(true);
    window.VH.lastViewed.save({ id: 12, name: 'F-22 <Raptor>', image_url: '/assets/airplanes/f22.jpg' });
    collection.render([]);
    expect(document.getElementById('col-last').hidden).toBe(false);
    const link = document.querySelector('#col-last-body a');
    expect(link.dataset.morphId).toBe('12');
    expect(link.getAttribute('href')).toBe('/details/f-22-raptor-12');
    expect(link.querySelector('.col-last-name').textContent).toBe('F-22 <Raptor>');
    expect(link.querySelector('.col-last-name').innerHTML).toBe('F-22 &lt;Raptor&gt;');
    localStorage.clear();
    collection.renderLastViewed();
    expect(document.getElementById('col-last').hidden).toBe(true);
    expect(document.getElementById('col-last-body').innerHTML).toBe('');
  });

  test('sans picture, card ni lastViewed : replis (img nue, /details/<id>)', () => {
    const { collection } = loadModules();
    delete window.VH.shared.picture;
    delete window.VH.shared.buildDetailsPath;
    collection.render([FAVS[0]]);
    const link = document.querySelector('#col-strip a');
    expect(link.getAttribute('href')).toBe('/details/30');
    expect(link.querySelector('img').getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
    delete window.VH.lastViewed;
    expect(() => collection.renderLastViewed()).not.toThrow();
  });

  test('éléments absents et requestAnimationFrame absent : aucune erreur', () => {
    const { collection } = loadModules();
    delete window.requestAnimationFrame;
    collection.render([FAVS[0]]);
    expect(document.querySelector('.col-decade-bar').style.getPropertyValue('--col-h')).toBe('100.0');
    document.getElementById('collection').innerHTML = '';
    expect(() => collection.render(FAVS)).not.toThrow();
    expect(() => collection.renderLastViewed()).not.toThrow();
  });

  test('changement de langue : nouveau rendu sans requête (noms anglais)', async () => {
    const S = loadModules();
    S.collection.init();
    window.dispatchEvent(new window.Event('langChanged')); // avant chargement : rien
    auth.authFetch.mockResolvedValue(jsonResponse(200, FAVS));
    await S.collection.load();
    auth.authFetch.mockClear();
    i18n.currentLang = 'en';
    window.dispatchEvent(new window.Event('langChanged'));
    expect(auth.authFetch).not.toHaveBeenCalled();
    expect(document.querySelector('.col-country-name').textContent).toBe('United States');
    expect(document.querySelector('#col-strip .col-item:nth-child(3) img').getAttribute('src')).toContain('placeholder-airplane-en.svg');
  });
});

describe('details/data.js — dernière fiche consultée', () => {
  test('la fiche chargée est notée pour les réglages', async () => {
    jest.resetModules();
    window.VH = {};
    require('../js/shared/last-viewed');
    window.VH.details = { render: { renderAircraftDetails: jest.fn() }, lineage: { load: jest.fn() }, favorites: { checkFavoriteStatus: jest.fn() } };
    document.body.innerHTML = '<div id="aircraft-description"></div>';
    global.auth = {
      fetchWithTimeout: jest.fn(() => Promise.resolve(jsonResponse(200, { id: 30, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg' }))),
      authFetch: jest.fn(() => Promise.resolve(jsonResponse(200, []))),
    };
    global.fetch = jest.fn(() => Promise.resolve(jsonResponse(200, [])));
    require('../js/shared/meta-description');
    require('../js/details/data');
    await window.VH.details.data.loadAircraftDetails({ aircraftId: '30' });
    await flush();
    expect(window.VH.lastViewed.read()).toEqual({ id: 30, name: 'Rafale', image_url: '/assets/airplanes/rafale.jpg' });
  });
});
