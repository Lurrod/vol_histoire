/**
 * Tests DOM — frontend/js/details/ui.js
 *
 * Barre de partage (intents, copie, partage natif), mini-barre de stats,
 * barre de progression de lecture, animations d'entrée des sections et
 * export PDF. jsdom n'a ni IntersectionObserver, ni navigator.share, ni
 * presse-papiers : ils sont simulés ici.
 */

const flush = () => new Promise((r) => setTimeout(r, 0));

const SHARE_BAR = `
  <div class="share-bar" role="group" aria-label="Partager cet avion">
    <button type="button" class="share-btn" data-share="twitter"></button>
    <button type="button" class="share-btn" data-share="linkedin"></button>
    <button type="button" class="share-btn" data-share="reddit"></button>
    <button type="button" class="share-btn" data-share="copy"><i class="fas fa-link"></i></button>
    <button type="button" class="share-btn share-btn-native hidden" data-share="native"></button>
    <span class="not-a-button">texte</span>
  </div>`;

/** IntersectionObserver simulé : on garde les instances pour les déclencher. */
class FakeIO {
  constructor(cb, options) {
    this.cb = cb;
    this.options = options;
    this.observed = [];
    FakeIO.instances.push(this);
  }
  observe(el) { this.observed.push(el); }
  unobserve(el) { this.observed = this.observed.filter((x) => x !== el); }
  fire(entries) { this.cb(entries, this); }
}
FakeIO.instances = [];

let ui;
let rafQueue;

function boot({ html = '', lang = 'fr', withIO = true } = {}) {
  jest.resetModules();
  document.body.innerHTML = html;
  document.body.className = '';
  global.i18n = { t: (k) => k, currentLang: lang };
  global.showToast = jest.fn();
  rafQueue = [];
  global.requestAnimationFrame = (fn) => { rafQueue.push(fn); return rafQueue.length; };
  FakeIO.instances = [];
  if (withIO) window.IntersectionObserver = FakeIO;
  else delete window.IntersectionObserver;
  window.VH = {};
  require('../js/details/ui');
  ui = window.VH.details.ui;
}

function flushRaf() {
  while (rafQueue.length) rafQueue.shift()();
}

// Les écouteurs posés sur window (scroll, beforeprint) survivent au test :
// on les retire pour qu'un test ne déclenche pas ceux du précédent.
let windowListeners = [];
const nativeAdd = window.addEventListener.bind(window);
beforeEach(() => {
  windowListeners = [];
  jest.spyOn(window, 'addEventListener').mockImplementation((type, fn, opts) => {
    windowListeners.push([type, fn, opts]);
    nativeAdd(type, fn, opts);
  });
});

afterEach(() => {
  windowListeners.forEach(([type, fn, opts]) => window.removeEventListener(type, fn, opts));
  jest.restoreAllMocks();
  delete navigator.share;
  delete navigator.clipboard;
  delete window.IntersectionObserver;
});

describe('setupShareBar — intents', () => {
  const state = { aircraftData: { name: 'Mirage 2000' } };

  beforeEach(() => {
    boot({ html: SHARE_BAR });
    window.history.replaceState(null, '', '/details/mirage-2000-68#specs');
    window.open = jest.fn();
    ui.setupShareBar(state);
  });

  const click = (action) => document.querySelector(`[data-share="${action}"]`).click();
  const openedUrl = () => new window.URL(window.open.mock.calls[0][0]);

  test('X/Twitter : URL et texte encodés, ancre retirée', () => {
    click('twitter');
    const u = openedUrl();
    expect(u.origin + u.pathname).toBe('https://twitter.com/intent/tweet');
    expect(u.searchParams.get('url')).toBe('http://localhost/details/mirage-2000-68');
    expect(u.searchParams.get('text')).toBe('Mirage 2000 — Vol d\'Histoire');
    expect(window.open.mock.calls[0][1]).toBe('vh-share');
    expect(window.open.mock.calls[0][2]).toMatch(/^width=600,height=540,left=-?\d+,top=-?\d+,menubar=no/);
  });

  test('LinkedIn et Reddit', () => {
    click('linkedin');
    expect(openedUrl().href).toBe('https://www.linkedin.com/sharing/share-offsite/?url='
      + encodeURIComponent('http://localhost/details/mirage-2000-68'));
    window.open.mockClear();
    click('reddit');
    expect(openedUrl().searchParams.get('title')).toBe('Mirage 2000 — Vol d\'Histoire');
  });

  test('clic hors bouton de partage : rien', () => {
    document.querySelector('.not-a-button').click();
    expect(window.open).not.toHaveBeenCalled();
  });

  test('clic sur l\'icône d\'un bouton : délégué au bouton parent', async () => {
    navigator.clipboard = { writeText: jest.fn(() => Promise.resolve()) };
    document.querySelector('[data-share="copy"] i').click();
    await flush();
    expect(navigator.clipboard.writeText).toHaveBeenCalledTimes(1);
  });
});

describe('setupShareBar — repli sur le titre de la page', () => {
  test('sans données d\'appareil : nom lu dans document.title', () => {
    boot({ html: SHARE_BAR });
    document.title = 'Rafale | Vol d\'Histoire';
    window.open = jest.fn();
    ui.setupShareBar({ aircraftData: null });
    document.querySelector('[data-share="twitter"]').click();
    expect(new window.URL(window.open.mock.calls[0][0]).searchParams.get('text')).toBe('Rafale — Vol d\'Histoire');
  });

  test('sans barre de partage : setup ne lève pas', () => {
    boot();
    expect(() => ui.setupShareBar({})).not.toThrow();
  });
});

describe('setupShareBar — copie du lien', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    window.history.replaceState(null, '', '/details/rafale-30');
  });
  afterEach(() => jest.useRealTimers());

  test('succès : presse-papiers, flash 800 ms, toast localisé (fr)', async () => {
    boot({ html: SHARE_BAR, lang: 'fr' });
    navigator.clipboard = { writeText: jest.fn(() => Promise.resolve()) };
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    const btn = document.querySelector('[data-share="copy"]');
    btn.click();
    await Promise.resolve();
    await Promise.resolve();
    expect(navigator.clipboard.writeText).toHaveBeenCalledWith('http://localhost/details/rafale-30');
    expect(btn.classList.contains('flash')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('Lien copié', 'success');
    jest.advanceTimersByTime(800);
    expect(btn.classList.contains('flash')).toBe(false);
  });

  test('succès en anglais : « Link copied »', async () => {
    boot({ html: SHARE_BAR, lang: 'en' });
    navigator.clipboard = { writeText: jest.fn(() => Promise.resolve()) };
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    document.querySelector('[data-share="copy"]').click();
    await Promise.resolve();
    await Promise.resolve();
    expect(showToast).toHaveBeenCalledWith('Link copied', 'success');
  });

  test('presse-papiers indisponible : repli sur window.prompt avec l\'URL', async () => {
    boot({ html: SHARE_BAR });
    window.prompt = jest.fn();
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    document.querySelector('[data-share="copy"]').click();
    await Promise.resolve();
    expect(window.prompt).toHaveBeenCalledWith('Copier le lien :', 'http://localhost/details/rafale-30');
    expect(showToast).not.toHaveBeenCalled();
  });

  test('repli window.prompt : libellé traduit (clé details.copy_link_prompt)', async () => {
    boot({ html: SHARE_BAR, lang: 'en' });
    global.i18n.t = (k) => (k === 'details.copy_link_prompt' ? 'Copy the link:' : k);
    window.prompt = jest.fn();
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    document.querySelector('[data-share="copy"]').click();
    await Promise.resolve();
    expect(window.prompt).toHaveBeenCalledWith('Copy the link:', 'http://localhost/details/rafale-30');
  });

  test('showToast absent : la copie réussit sans lever', async () => {
    boot({ html: SHARE_BAR });
    delete global.showToast;
    navigator.clipboard = { writeText: jest.fn(() => Promise.resolve()) };
    window.prompt = jest.fn();
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    document.querySelector('[data-share="copy"]').click();
    await Promise.resolve();
    await Promise.resolve();
    expect(window.prompt).not.toHaveBeenCalled();
  });
});

describe('setupShareBar — partage natif', () => {
  test('sans navigator.share : le bouton natif reste masqué', () => {
    boot({ html: SHARE_BAR });
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    expect(document.querySelector('.share-btn-native').classList.contains('hidden')).toBe(true);
  });

  test('avec navigator.share : bouton révélé, titre/texte/URL transmis', async () => {
    boot({ html: SHARE_BAR });
    window.history.replaceState(null, '', '/details/rafale-30');
    navigator.share = jest.fn(() => Promise.resolve());
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    const native = document.querySelector('.share-btn-native');
    expect(native.classList.contains('hidden')).toBe(false);
    native.click();
    await flush();
    expect(navigator.share).toHaveBeenCalledWith({
      title: 'Rafale', text: 'Rafale — Vol d\'Histoire', url: 'http://localhost/details/rafale-30',
    });
  });

  test('partage annulé par l\'utilisateur : rejet avalé', async () => {
    boot({ html: SHARE_BAR });
    navigator.share = jest.fn(() => Promise.reject(new window.DOMException('cancel', 'AbortError')));
    ui.setupShareBar({ aircraftData: { name: 'Rafale' } });
    document.querySelector('.share-btn-native').click();
    await flush();
    expect(navigator.share).toHaveBeenCalled();
  });

  test('navigator.share présent mais bouton natif absent du HTML : pas d\'erreur', () => {
    boot({ html: '<div class="share-bar"></div>' });
    navigator.share = jest.fn();
    expect(() => ui.setupShareBar({})).not.toThrow();
  });
});

describe('syncMiniBar', () => {
  const MINI = '<span id="mini-name"></span><span id="mini-speed"></span><span id="mini-range"></span><span id="mini-weight"></span>';

  test('sans données : rien n\'est écrit', () => {
    boot({ html: MINI });
    ui.syncMiniBar({ aircraftData: null });
    expect(document.getElementById('mini-name').textContent).toBe('');
  });

  test('nom, vitesse, rayon et masse à vide avec unités et icônes', () => {
    boot({ html: MINI });
    ui.syncMiniBar({ aircraftData: { name: 'Rafale', max_speed: 1912, max_range: 3700, empty_weight: 10300 } });
    expect(document.getElementById('mini-name').textContent).toBe('Rafale');
    expect(document.getElementById('mini-speed').textContent).toBe('1912 km/h');
    expect(document.getElementById('mini-speed').querySelector('i.fa-gauge-high')).not.toBeNull();
    expect(document.getElementById('mini-range').textContent).toBe('3700 km');
    expect(document.getElementById('mini-weight').textContent).toBe('10300 kg');
  });

  test('valeurs absentes : champs vidés (pas de « null km/h »)', () => {
    boot({ html: MINI });
    ui.syncMiniBar({ aircraftData: { name: 'A', max_speed: 1, max_range: 1, empty_weight: 1 } });
    ui.syncMiniBar({ aircraftData: {} });
    ['mini-name', 'mini-speed', 'mini-range', 'mini-weight'].forEach((id) => {
      expect(document.getElementById(id).innerHTML).toBe('');
    });
  });

  test('éléments absents : ne lève pas', () => {
    boot();
    expect(() => ui.syncMiniBar({ aircraftData: { name: 'A', max_speed: 1 } })).not.toThrow();
  });
});

describe('setupMiniBarVisibility', () => {
  test('hero hors écran → body.mini-bar-visible ; de retour → retirée', () => {
    boot({ html: '<section class="aircraft-hero"></section>' });
    ui.setupMiniBarVisibility();
    const io = FakeIO.instances[0];
    expect(io.observed).toEqual([document.querySelector('.aircraft-hero')]);
    expect(io.options).toEqual({ threshold: 0, rootMargin: '-80px 0px 0px 0px' });
    io.fire([{ isIntersecting: false }]);
    expect(document.body.classList.contains('mini-bar-visible')).toBe(true);
    io.fire([{ isIntersecting: true }]);
    expect(document.body.classList.contains('mini-bar-visible')).toBe(false);
  });

  test('sans hero : aucun observateur', () => {
    boot();
    ui.setupMiniBarVisibility();
    expect(FakeIO.instances).toHaveLength(0);
  });

  test('navigateur sans IntersectionObserver : ne lève pas', () => {
    boot({ html: '<section class="aircraft-hero"></section>', withIO: false });
    expect(() => ui.setupMiniBarVisibility()).not.toThrow();
  });
});

describe('setupScrollProgress', () => {
  function setScroll({ scrollHeight, clientHeight, scrollTop }) {
    const h = document.documentElement;
    Object.defineProperty(h, 'scrollHeight', { configurable: true, value: scrollHeight });
    Object.defineProperty(h, 'clientHeight', { configurable: true, value: clientHeight });
    h.scrollTop = scrollTop;
    Object.defineProperty(h, 'scrollTop', { configurable: true, value: scrollTop });
  }

  test('sans barre : rien', () => {
    boot();
    expect(() => ui.setupScrollProgress()).not.toThrow();
  });

  test('page plus courte que l\'écran : 0 %', () => {
    boot({ html: '<div id="scroll-progress"></div>' });
    setScroll({ scrollHeight: 500, clientHeight: 800, scrollTop: 0 });
    ui.setupScrollProgress();
    expect(document.getElementById('scroll-progress').style.width).toBe('0%');
  });

  test('défilement : largeur proportionnelle, une seule frame par rafale d\'événements', () => {
    boot({ html: '<div id="scroll-progress"></div>' });
    setScroll({ scrollHeight: 2000, clientHeight: 1000, scrollTop: 0 });
    ui.setupScrollProgress();
    setScroll({ scrollHeight: 2000, clientHeight: 1000, scrollTop: 250 });
    window.dispatchEvent(new Event('scroll'));
    window.dispatchEvent(new Event('scroll'));
    window.dispatchEvent(new Event('scroll'));
    expect(rafQueue).toHaveLength(1);
    flushRaf();
    expect(document.getElementById('scroll-progress').style.width).toBe('25%');
    // Après la frame, un nouveau scroll en programme une autre.
    window.dispatchEvent(new Event('scroll'));
    expect(rafQueue).toHaveLength(1);
  });
});

describe('setupSectionAnimations', () => {
  test('sections masquées puis révélées à l\'entrée dans le viewport, observées une seule fois', () => {
    boot({ html: '<section class="content-section" id="a"></section><section class="content-section" id="b"></section>' });
    ui.setupSectionAnimations();
    const a = document.getElementById('a');
    const b = document.getElementById('b');
    expect(a.style.opacity).toBe('0');
    expect(a.style.transform).toBe('translateY(20px)');
    const io = FakeIO.instances[0];
    expect(io.options).toEqual({ threshold: 0.1 });
    expect(io.observed).toEqual([a, b]);
    io.fire([{ isIntersecting: true, target: a }, { isIntersecting: false, target: b }]);
    expect(a.style.opacity).toBe('1');
    expect(a.style.transform).toBe('translateY(0)');
    expect(b.style.opacity).toBe('0');
    expect(io.observed).toEqual([b]);
  });

  // Robustesse (ui.js:212) : contrairement à setupMiniBarVisibility, aucune
  // garde `'IntersectionObserver' in window`. Sans l'API, l'appel lève, et
  // comme details.js l'appelle juste après le chargement de la fiche, la
  // suite de l'initialisation (mini-barre, écouteurs langChanged, Échap)
  // n'est jamais posée. Tous les navigateurs ciblés ont l'API : risque faible.
  test.skip('ROBUSTESSE : sans IntersectionObserver, les sections restent visibles et rien ne lève', () => {
    boot({ html: '<section class="content-section"></section>', withIO: false });
    expect(() => ui.setupSectionAnimations()).not.toThrow();
    expect(document.querySelector('.content-section').style.opacity).not.toBe('0');
  });
});

describe('setupPdfExport', () => {
  test('clic : sections forcées visibles, impression après deux frames, transition rétablie', () => {
    boot({ html: '<button id="pdf-btn">PDF</button><section class="content-section"></section>' });
    window.print = jest.fn();
    ui.setupPdfExport();
    const s = document.querySelector('.content-section');
    s.style.opacity = '0';
    document.getElementById('pdf-btn').click();
    expect(s.style.opacity).toBe('1');
    expect(s.style.transform).toBe('none');
    expect(window.print).not.toHaveBeenCalled();
    rafQueue.shift()();
    expect(window.print).not.toHaveBeenCalled();
    flushRaf();
    expect(window.print).toHaveBeenCalledTimes(1);
    expect(s.style.transition).toBe('all 0.5s ease');
  });

  test('impression depuis le navigateur (Ctrl+P) : beforeprint révèle les sections', () => {
    boot({ html: '<section class="content-section"></section>' });
    ui.setupPdfExport();
    const s = document.querySelector('.content-section');
    s.style.opacity = '0';
    s.style.transform = 'translateY(20px)';
    window.dispatchEvent(new Event('beforeprint'));
    expect(s.style.opacity).toBe('1');
    expect(s.style.transform).toBe('none');
  });
});
