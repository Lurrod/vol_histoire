/**
 * Tests DOM — frontend/js/nations-map.js (suite de nations-map.test.js)
 *
 * Montage de la carte : une seule requête pour deux montages, échec propre et
 * réessayable, paliers et noms accessibles des nations, infobulle (souris,
 * focus clavier), activation au clic / Entrée / Espace en mode filtre et en
 * mode navigation, ligne de synthèse échappée, montage différé de l'accueil.
 */

const SVG = '<svg xmlns="http://www.w3.org/2000/svg" class="world-map" role="img" aria-hidden="true">'
  + '<g class="wm-nations">'
  + '<path class="wm-nation" data-code="USA" data-cx="10" data-cy="20" d="M0 0"/>'
  + '<path class="wm-nation" data-code="FRA" d="M1 1"/>'
  + '<path class="wm-nation" data-code="TWN" d="M2 2"/>'
  + '<path class="wm-nation" data-code="LBY" d="M3 3"/>'
  + '</g><rect class="sea"/></svg>';

const NATIONS = [
  { code: 'USA', name: 'United States', name_fr: 'États-Unis', count: 120 },
  { code: 'FRA', name: 'France', name_fr: 'France', count: 40 },
  { code: 'TWN', name: '<b>Taïwan</b>', count: 1 },
];

let map;

function frame(id = 'm', { summary = false } = {}) {
  return `<section id="${id}"><div class="nations-map-frame">`
    + '<div class="nations-map-canvas"></div><div class="nations-map-tooltip"></div></div>'
    + '<span class="nations-map-legend-max">—</span><p class="nations-map-status"></p>'
    + (summary ? '<p class="nations-map-summary"></p>' : '')
    + '</section>';
}

function load({ nations = NATIONS, svg = SVG, apiOk = true, svgOk = true } = {}) {
  jest.resetModules();
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.i18n = { t: (k, p) => (p ? `${k}|${p.n}` : k) };
  global.auth = {
    fetchWithTimeout: jest.fn(() => Promise.resolve({ ok: apiOk, json: () => Promise.resolve(nations) })),
  };
  global.fetch = jest.fn(() => Promise.resolve({ ok: svgOk, text: () => Promise.resolve(svg) }));
  map = require('../js/nations-map');
}

afterEach(() => { delete global.fetch; });

const nation = (code, root = document) => root.querySelector(`[data-code="${code}"]`);
const tooltip = () => document.querySelector('.nations-map-tooltip');

describe('montage', () => {
  test('paliers, rôle, nom accessible et données de chaque nation', async () => {
    load();
    document.body.innerHTML = frame();
    const ok = await map.mount(document.getElementById('m'));
    expect(ok).toBe(true);

    const usa = nation('USA');
    expect(usa.classList.contains('wm-nation-active')).toBe(true);
    expect(usa.classList.contains('wm-tier-4')).toBe(true);
    expect(nation('TWN').classList.contains('wm-tier-1')).toBe(true);
    expect(usa.getAttribute('aria-label')).toBe('United States — home.nations_map_count_many|120');
    expect(nation('TWN').getAttribute('aria-label')).toBe('<b>Taïwan</b> — home.nations_map_count_one|1');
    expect(usa.dataset.nameFr).toBe('États-Unis');
    // Sans name_fr, le nom sert de clé de filtre
    expect(nation('TWN').dataset.nameFr).toBe('<b>Taïwan</b>');
    // Pays du référentiel sans fiche : décor
    expect(nation('LBY').classList.contains('wm-nation-empty')).toBe(true);
    expect(nation('LBY').hasAttribute('role')).toBe(false);
    // Légende : le maximum
    expect(document.querySelector('.nations-map-legend-max').textContent).toBe('120');
  });

  test('deux montages : une seule requête API et un seul téléchargement du SVG', async () => {
    load();
    document.body.innerHTML = frame('a') + frame('b');
    await map.mount(document.getElementById('a'));
    await map.mount(document.getElementById('b'));
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/nations');
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(fetch).toHaveBeenCalledWith('/assets/map/world-nations.svg');
  });

  test('remonter le même conteneur est sans effet', async () => {
    load();
    document.body.innerHTML = frame();
    const root = document.getElementById('m');
    await map.mount(root);
    expect(await map.mount(root)).toBe(true);
    expect(root.querySelectorAll('svg')).toHaveLength(1);
  });

  test('conteneur absent ou sans zone de dessin : échec sans requête', async () => {
    load();
    expect(await map.mount(null)).toBe(true);
    document.body.innerHTML = '<section id="x"></section>';
    expect(await map.mount(document.getElementById('x'))).toBe(false);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('API en erreur : carte retirée, message traduit, et un second essai refait la requête', async () => {
    load({ apiOk: false });
    document.body.innerHTML = frame();
    const root = document.getElementById('m');
    expect(await map.mount(root)).toBe(false);
    expect(root.classList.contains('nations-map-failed')).toBe(true);
    expect(root.querySelector('.nations-map-status').textContent).toBe('home.nations_map_error');
    expect(root.dataset.mapMounted).toBe('');

    auth.fetchWithTimeout.mockImplementation(() => Promise.resolve({ ok: true, json: () => Promise.resolve(NATIONS) }));
    expect(await map.mount(root)).toBe(true);
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(2);
  });

  test('SVG introuvable : échec, même sans zone de statut', async () => {
    load({ svgOk: false });
    document.body.innerHTML = '<section id="m"><div class="nations-map-canvas"></div></section>';
    expect(await map.mount(document.getElementById('m'))).toBe(false);
  });

  test('fichier reçu sans <svg> : échec', async () => {
    load({ svg: '<p>maintenance</p>' });
    document.body.innerHTML = frame();
    expect(await map.mount(document.getElementById('m'))).toBe(false);
  });

  test('aucune fiche : aucune nation colorée', async () => {
    load({ nations: [{ code: 'FRA', name: 'France', count: 0 }] });
    document.body.innerHTML = frame();
    await map.mount(document.getElementById('m'));
    expect(nation('FRA').classList.contains('wm-tier-0')).toBe(true);
    expect(document.querySelector('.nations-map-legend-max').textContent).toBe('0');
  });
});

describe('interactions', () => {
  async function mounted(onSelect) {
    load();
    document.body.innerHTML = frame();
    await map.mount(document.getElementById('m'), onSelect ? { onSelect } : {});
    return document.querySelector('#m svg');
  }

  test('en mode filtre, les nations sont des boutons ; clic, Entrée et Espace appellent onSelect', async () => {
    const onSelect = jest.fn();
    await mounted(onSelect);
    const fra = nation('FRA');
    expect(fra.getAttribute('role')).toBe('button');

    fra.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    expect(onSelect).toHaveBeenLastCalledWith({ code: 'FRA', name: 'France', nameFr: 'France', count: 40 });

    const enter = new KeyboardEvent('keydown', { key: 'Enter', bubbles: true, cancelable: true });
    nation('USA').dispatchEvent(enter);
    expect(enter.defaultPrevented).toBe(true);
    expect(onSelect).toHaveBeenLastCalledWith(expect.objectContaining({ code: 'USA', nameFr: 'États-Unis' }));

    const space = new KeyboardEvent('keydown', { key: ' ', bubbles: true, cancelable: true });
    fra.dispatchEvent(space);
    expect(space.defaultPrevented).toBe(true);
    expect(onSelect).toHaveBeenCalledTimes(3);
  });

  test('autre touche, ou clic/touche hors d\'une nation active : rien', async () => {
    const onSelect = jest.fn();
    const svg = await mounted(onSelect);
    const tab = new KeyboardEvent('keydown', { key: 'Tab', bubbles: true, cancelable: true });
    nation('FRA').dispatchEvent(tab);
    expect(tab.defaultPrevented).toBe(false);
    nation('LBY').dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', bubbles: true }));
    svg.querySelector('.sea').dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    expect(onSelect).not.toHaveBeenCalled();
  });

  test('en mode navigation (accueil), les nations sont des liens vers le hangar filtré', async () => {
    await mounted();
    expect(nation('FRA').getAttribute('role')).toBe('link');
    // jsdom n'implémente pas la navigation : il la signale sur la console
    // virtuelle avec l'URL visée, ce qui suffit à vérifier la cible.
    const err = jest.spyOn(console, 'error').mockImplementation(() => {});
    nation('USA').dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    const logged = err.mock.calls.flat().map(String).join(' ');
    err.mockRestore();
    expect(logged).toMatch(/navigation/i);
  });

  test('infobulle à la souris : suit le curseur, nom échappé, masquée hors d\'une nation', async () => {
    const svg = await mounted(jest.fn());
    nation('TWN').dispatchEvent(new window.MouseEvent('pointerover', { bubbles: true, clientX: 50, clientY: 80 }));
    expect(tooltip().classList.contains('is-visible')).toBe(true);
    expect(tooltip().querySelector('strong').textContent).toBe('<b>Taïwan</b>');
    expect(tooltip().querySelector('b')).toBeNull();
    expect(tooltip().querySelector('span').textContent).toBe('home.nations_map_count_one|1');
    expect(tooltip().style.left).toBe('50px');
    expect(tooltip().style.top).toBe('74px');

    nation('FRA').dispatchEvent(new window.MouseEvent('pointermove', { bubbles: true, clientX: 60, clientY: 90 }));
    expect(tooltip().querySelector('strong').textContent).toBe('France');
    expect(tooltip().style.left).toBe('60px');

    svg.querySelector('.sea').dispatchEvent(new window.MouseEvent('pointermove', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(false);

    svg.querySelector('.sea').dispatchEvent(new window.MouseEvent('pointerover', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(false);

    nation('FRA').dispatchEvent(new window.MouseEvent('pointerover', { bubbles: true }));
    nation('FRA').dispatchEvent(new window.MouseEvent('pointerout', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(false);
  });

  test('au focus clavier, l\'infobulle s\'ancre sur le centroïde calculé au build', async () => {
    const svg = await mounted(jest.fn());
    svg.getScreenCTM = () => ({ a: 2 });
    svg.createSVGPoint = () => ({ x: 0, y: 0, matrixTransform() { return { x: this.x * 2 + 5, y: this.y * 2 + 7 }; } });
    nation('USA').dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(true);
    expect(tooltip().style.left).toBe('25px');
    expect(tooltip().style.top).toBe('47px');

    nation('USA').dispatchEvent(new window.FocusEvent('focusout', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(false);
  });

  test('sans centroïde ou sans matrice d\'écran : repli sur la boîte englobante', async () => {
    const svg = await mounted(jest.fn());
    const fra = nation('FRA');
    fra.getBoundingClientRect = () => ({ left: 100, top: 30, width: 40, height: 20 });
    svg.getScreenCTM = () => ({});
    fra.dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
    expect(tooltip().style.left).toBe('120px');
    expect(tooltip().style.top).toBe('30px');

    // Le centroïde existe mais le SVG n'est pas rendu (matrice nulle)
    const usa = nation('USA');
    usa.getBoundingClientRect = () => ({ left: 0, top: 4, width: 10, height: 10 });
    svg.getScreenCTM = () => null;
    usa.dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
    expect(tooltip().style.left).toBe('5px');
  });

  test('focus hors d\'une nation active : pas d\'infobulle', async () => {
    const svg = await mounted(jest.fn());
    svg.querySelector('.sea').dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
    expect(tooltip().classList.contains('is-visible')).toBe(false);
  });

  test('conteneur sans infobulle : survol et sortie sans erreur', async () => {
    load();
    document.body.innerHTML = '<section id="m"><div class="nations-map-canvas"></div></section>';
    await map.mount(document.getElementById('m'), { onSelect: jest.fn() });
    expect(() => {
      nation('FRA').dispatchEvent(new window.MouseEvent('pointerover', { bubbles: true }));
      nation('FRA').dispatchEvent(new window.MouseEvent('pointerout', { bubbles: true }));
    }).not.toThrow();
  });
});

describe('ligne de synthèse (accueil)', () => {
  test('total au pluriel et trois premières nations, noms échappés, liens vers le hangar en nom FR encodé', async () => {
    load();
    document.body.innerHTML = frame('m', { summary: true });
    await map.mount(document.getElementById('m'));
    const summary = document.querySelector('.nations-map-summary');
    expect(summary.querySelector('.nm-total').textContent).toBe('home.nations_map_total_many|3');
    const chips = Array.from(summary.querySelectorAll('a.nm-chip'));
    expect(chips).toHaveLength(3);
    expect(chips[0].getAttribute('href')).toBe('/hangar?country=%C3%89tats-Unis');
    expect(chips[0].querySelector('.nm-chip-count').textContent).toBe('120');
    expect(summary.querySelector('b')).toBeNull();
    expect(chips[2].textContent).toBe('<b>Taïwan</b>1');
  });

  test('une seule nation : total au singulier', async () => {
    load({ nations: [NATIONS[1]] });
    document.body.innerHTML = frame('m', { summary: true });
    await map.mount(document.getElementById('m'));
    expect(document.querySelector('.nm-total').textContent).toBe('home.nations_map_total_one|1');
  });
});

describe('init — montage différé de l\'accueil', () => {
  const flush = () => new Promise(r => setTimeout(r, 0));
  let observers;

  beforeEach(() => {
    observers = [];
    window.IntersectionObserver = jest.fn(function (cb, opts) {
      this.cb = cb;
      this.opts = opts;
      this.observe = jest.fn();
      this.disconnect = jest.fn();
      observers.push(this);
    });
  });
  afterEach(() => { delete window.IntersectionObserver; });

  test('la carte n\'est chargée qu\'à l\'approche de la section (marge de 300 px)', async () => {
    load();
    document.body.innerHTML = frame('nations-map-section');
    map.init();
    const io = observers[0];
    expect(io.opts).toEqual({ rootMargin: '300px' });
    expect(io.observe).toHaveBeenCalledWith(document.getElementById('nations-map-section'));
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();

    io.cb([{ isIntersecting: false }]);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();

    io.cb([{ isIntersecting: true }]);
    expect(io.disconnect).toHaveBeenCalled();
    await flush();
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
  });

  test('sans IntersectionObserver : montage immédiat', async () => {
    delete window.IntersectionObserver;
    load();
    document.body.innerHTML = frame('nations-map-section');
    map.init();
    await flush();
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
  });

  test('page sans section carte : rien n\'est observé', () => {
    load();
    document.body.innerHTML = '';
    map.init();
    expect(observers).toHaveLength(0);
  });
});
