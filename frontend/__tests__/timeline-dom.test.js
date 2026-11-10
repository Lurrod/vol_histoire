/**
 * Tests DOM — frontend/js/timeline/{render,observers,effects}.js et timeline.js
 * Rendu des chapitres (data-decade, plus de couleur en ligne), minimap,
 * observateurs de défilement, particules, progression et démarrage.
 */

global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { currentLang: 'fr', t: (key) => key };
window.i18n = global.i18n;
window.VH = {
  shared: {
    buildDetailsPath: (id, name) => `/details/${String(name).toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${id}`,
    picture: { pictureHtml: (src, o) => `<picture data-src="${src}"><img alt="${o.alt}"></picture>` },
  },
};

require('../js/timeline/util');
require('../js/timeline/era');
require('../js/timeline/data');
const render = require('../js/timeline/render');
const observers = require('../js/timeline/observers');
const effects = require('../js/timeline/effects');
require('../js/timeline/keyboard');

const DECADES = [
  {
    decade: 1950,
    events: [{
      kind: 'war', title_fr: 'Corée', body_fr: 'Premiers duels <jets>', quote_author_fr: 'Un pilote',
      event_date: '1950-06-25', airplane: { id: 7, name: 'MiG-15', image_url: '/assets/airplanes/mig15.jpg' },
    }],
    aircraft: [{ id: 1, name: 'F-86 Sabre', name_en: 'F-86 Sabre (EN)', country_name: 'États-Unis', country_name_en: 'United States', date_operationel: '1949-02-01', generation: 1, image_url: '/assets/airplanes/f86.jpg' }],
  },
  { decade: 1990, events: [{ title_fr: 'Sans date' }], aircraft: [] },
  { decade: 2020, events: [], aircraft: [{ id: 3, name: 'X <script>', generation: null }] },
];

/* IntersectionObserver factice : garde les instances pour les déclencher. */
let ioInstances = [];
class FakeIO {
  constructor(cb, opts) { this.cb = cb; this.opts = opts; this.targets = []; ioInstances.push(this); }
  observe(t) { this.targets.push(t); }
  unobserve(t) { this.targets = this.targets.filter(x => x !== t); }
  fire(entries) { this.cb(entries); }
}

function page() {
  document.body.innerHTML = `
    <canvas id="tl-particles"></canvas>
    <section id="tl-intro"></section>
    <span id="tl-stat-events">0</span><span id="tl-stat-aircraft">0</span><span id="tl-stat-decades">0</span>
    <div id="tl-chapters"></div>
    <div id="tl-year-hud"><span id="tl-year-hud-num"></span><span id="tl-year-hud-label"></span></div>
    <nav id="tl-minimap"></nav>
    <div id="tl-progress"></div>
    <div id="tl-loading"></div>
    <div id="toast-container"></div>`;
}

beforeEach(() => {
  page();
  document.body.removeAttribute('style');
  document.body.className = '';
  ioInstances = [];
  window.IntersectionObserver = global.IntersectionObserver = FakeIO;
  window.scrollTo = jest.fn();
  global.requestAnimationFrame = window.requestAnimationFrame = jest.fn();
  window.i18n.currentLang = 'fr';
});

describe('render', () => {
  test('un chapitre par décennie, porteur de data-decade, sans couleur en ligne', () => {
    render.renderChapters(DECADES);
    const chapters = document.querySelectorAll('.tl-chapter');
    expect([...chapters].map(c => c.dataset.decade)).toEqual(['1950', '1990', '2020']);
    chapters.forEach(c => {
      expect(c.getAttribute('style')).toBeNull();
      expect(c.hasAttribute('data-era-color')).toBe(false);
      expect(c.id).toBe(`ch-${c.dataset.decade}`);
    });
  });

  test('title card : numéro de chapitre, bornes et textes d\'ère', () => {
    render.renderChapters(DECADES);
    const second = document.querySelectorAll('.tl-chapter')[1];
    expect(second.querySelector('.tl-title-chapter').textContent).toBe('timeline.chapter_label · 02');
    expect(second.querySelector('.tl-title-span').textContent).toBe('1990–1999');
    expect(second.querySelector('.tl-title-era').textContent).toBe('timeline.era_1990_title2');
    expect(second.querySelector('.tl-narrative-text').textContent).toBe('timeline.era_1990_narrative');
  });

  test('blocs événements et appareils absents quand vides', () => {
    render.renderChapters(DECADES);
    const [c1950, c1990, c2020] = document.querySelectorAll('.tl-chapter');
    expect(c1950.querySelector('.tl-events strong').textContent).toBe('1');
    expect(c1950.querySelector('.tl-aircraft-section strong').textContent).toBe('1');
    expect(c1990.querySelector('.tl-aircraft-section')).toBeNull();
    expect(c2020.querySelector('.tl-events')).toBeNull();
  });

  test('carte d\'événement : genre, date, citation, appareil lié, texte échappé', () => {
    render.renderChapters(DECADES);
    const ev = document.querySelector('.tl-event');
    expect(ev.classList.contains('tl-event-kind-war')).toBe(true);
    expect(ev.dataset.idx).toBe('0');
    expect(ev.querySelector('.tl-event-year').textContent).toBe('1950');
    expect(ev.querySelector('.tl-event-kind').textContent).toBe('timeline.kind_war');
    expect(ev.querySelector('.tl-event-text').textContent).toBe('Premiers duels <jets>');
    expect(ev.querySelector('.tl-event-author').textContent).toBe('— Un pilote');
    expect(ev.querySelector('.tl-event-plane').getAttribute('href')).toBe('/details/mig-15-7');
    expect(ev.querySelector('.tl-event-plane picture')).not.toBeNull();
  });

  test('événement sans genre ni date ni appareil', () => {
    render.renderChapters(DECADES);
    const ev = document.querySelectorAll('.tl-event')[1];
    expect(ev.classList.contains('tl-event-kind-milestone')).toBe(true);
    expect(ev.querySelector('.tl-event-year').textContent).toBe('');
    expect(ev.querySelector('.tl-event-author')).toBeNull();
    expect(ev.querySelector('.tl-event-plane')).toBeNull();
  });

  test('carte d\'appareil : année, génération, nom et pays selon la langue', () => {
    window.i18n.currentLang = 'en';
    render.renderChapters(DECADES);
    const card = document.querySelector('.tl-plane-card');
    expect(card.getAttribute('href')).toBe('/details/f-86-sabre-1');
    expect(card.querySelector('.tl-plane-year').textContent).toBe('1949');
    expect(card.querySelector('.tl-plane-gen').textContent).toBe('G1');
    expect(card.querySelector('.tl-plane-name').textContent).toBe('F-86 Sabre (EN)');
    expect(card.querySelector('.tl-plane-country').textContent).toBe('United States');
  });

  test('carte d\'appareil minimale : tiret, pas de génération ni d\'image, nom échappé', () => {
    render.renderChapters(DECADES);
    const card = document.querySelectorAll('.tl-plane-card')[1];
    expect(card.querySelector('.tl-plane-year').textContent).toBe('—');
    expect(card.querySelector('.tl-plane-gen')).toBeNull();
    expect(card.querySelector('picture')).toBeNull();
    expect(card.querySelector('script')).toBeNull();
    expect(card.querySelector('.tl-plane-name').textContent).toBe('X <script>');
  });

  test('sans conteneur, le rendu ne fait rien', () => {
    document.body.innerHTML = '';
    expect(() => { render.renderChapters(DECADES); render.renderMinimap(DECADES); render.renderMessage('x'); }).not.toThrow();
  });

  test('renderMessage remplace les chapitres par un message échappé', () => {
    render.renderMessage('<b>vide</b>');
    const msg = document.querySelector('#tl-chapters .tl-empty-msg');
    expect(msg.textContent).toBe('<b>vide</b>');
  });

  test('minimap : un bouton par décennie, le clic active, met à jour le HUD et défile', () => {
    render.renderChapters(DECADES);
    render.renderMinimap(DECADES);
    const btns = document.querySelectorAll('.tl-mm-btn');
    expect([...btns].map(b => b.getAttribute('aria-label'))).toEqual(['1950s', '1990s', '2020s']);
    btns[1].click();
    expect(btns[1].classList.contains('active')).toBe(true);
    expect(btns[0].classList.contains('active')).toBe(false);
    expect(document.getElementById('tl-year-hud-num').textContent).toBe('1990s');
    expect(document.getElementById('tl-year-hud-label').textContent).toBe('timeline.era_1990_label2');
    expect(window.scrollTo).toHaveBeenCalledTimes(1);
  });

  test('minimap : cible absente, aucun effet', () => {
    render.renderMinimap(DECADES); // pas de chapitres rendus
    document.querySelector('.tl-mm-btn').click();
    expect(window.scrollTo).not.toHaveBeenCalled();
  });
});

describe('observers', () => {
  function layout(rects) {
    document.querySelectorAll('.tl-chapter').forEach((c, i) => {
      c.getBoundingClientRect = () => rects[i];
    });
  }

  test('findDominant : chapitre qui chevauche l\'ancre, centre le plus proche', () => {
    const mk = (top, height) => ({ getBoundingClientRect: () => ({ top, bottom: top + height, height }) });
    const a = mk(-500, 1000); const b = mk(100, 2000); const c = mk(900, 500);
    expect(observers.findDominant([a, b, c], 280)).toBe(a);
    expect(observers.findDominant([b, c], 280)).toBe(b);
    expect(observers.findDominant([c], 280)).toBeNull();
  });

  test('staggerDelay : 80 ms par rang, cycle de 6', () => {
    document.body.innerHTML = `<div>${'<a></a>'.repeat(8)}</div>`;
    const cards = document.querySelectorAll('a');
    expect(observers.staggerDelay(cards[0])).toBe(0);
    expect(observers.staggerDelay(cards[2])).toBe(160);
    expect(observers.staggerDelay(cards[7])).toBe(80);
  });

  test('observeChapters marque le chapitre actif, le HUD et la minimap', () => {
    window.innerHeight = 800;
    render.renderChapters(DECADES);
    render.renderMinimap(DECADES);
    layout([
      { top: -2000, bottom: -100, height: 1900 },
      { top: -100, bottom: 900, height: 1000 },
      { top: 900, bottom: 1900, height: 1000 },
    ]);
    observers.observeChapters();
    const c1990 = document.getElementById('ch-1990');
    expect(c1990.classList.contains('in-view')).toBe(true);
    expect(document.getElementById('tl-year-hud-num').textContent).toBe('1990s');
    expect(document.querySelector('[data-target="ch-1990"]').classList.contains('active')).toBe(true);
    expect(document.querySelector('[data-target="ch-1950"]').classList.contains('active')).toBe(false);
  });

  test('aucun chapitre sous l\'ancre : rien n\'est marqué', () => {
    window.innerHeight = 800;
    render.renderChapters(DECADES);
    layout(DECADES.map(() => ({ top: 2000, bottom: 3000, height: 1000 })));
    observers.observeChapters();
    expect(document.querySelectorAll('.tl-chapter.in-view')).toHaveLength(0);
    expect(document.getElementById('tl-year-hud-num').textContent).toBe('');
  });

  test('observateurs : entrée des chapitres, HUD après la couverture, révélations', () => {
    render.renderChapters(DECADES);
    render.renderMinimap(DECADES);
    layout(DECADES.map(() => ({ top: 2000, bottom: 3000, height: 1000 })));
    observers.observeChapters();
    const [chapterIO, introIO, cardIO, narrIO] = ioInstances;

    const chapter = document.getElementById('ch-2020');
    chapterIO.fire([{ isIntersecting: true, target: chapter }, { isIntersecting: false, target: document.getElementById('ch-1950') }]);
    expect(chapter.classList.contains('in-view')).toBe(true);
    expect(document.getElementById('ch-1950').classList.contains('in-view')).toBe(false);

    document.body.style.setProperty('--tl-active-era', '#fff');
    introIO.fire([{ isIntersecting: false }]);
    expect(document.getElementById('tl-year-hud').classList.contains('visible')).toBe(true);
    expect(document.getElementById('tl-minimap').classList.contains('visible')).toBe(true);
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('#fff');
    introIO.fire([{ isIntersecting: true }]);
    expect(document.getElementById('tl-year-hud').classList.contains('visible')).toBe(false);
    expect(document.body.style.getPropertyValue('--tl-active-era')).toBe('');

    const card = document.querySelector('.tl-plane-card');
    expect(cardIO.targets).toContain(card);
    cardIO.fire([{ isIntersecting: true, target: card }, { isIntersecting: false, target: document.querySelector('.tl-event') }]);
    expect(card.classList.contains('reveal')).toBe(true);
    expect(card.style.animationDelay).toBe('0ms');
    expect(cardIO.targets).not.toContain(card);

    const narrative = document.querySelector('.tl-narrative');
    narrIO.fire([{ isIntersecting: true, target: narrative }, { isIntersecting: false, target: document.querySelector('.tl-title-card') }]);
    expect(narrative.classList.contains('reveal')).toBe(true);
    expect(narrIO.targets).not.toContain(narrative);
  });

  test('sans couverture ni HUD, pas d\'observateur d\'introduction', () => {
    document.getElementById('tl-intro').remove();
    render.renderChapters(DECADES);
    observers.observeChapters();
    expect(ioInstances).toHaveLength(3);
  });
});

describe('effects — DOM', () => {
  function fakeCtx() {
    return {
      setTransform: jest.fn(), clearRect: jest.fn(), beginPath: jest.fn(),
      arc: jest.fn(), fill: jest.fn(), fillStyle: '',
    };
  }

  test('initParticles dimensionne le canevas et dessine une image', () => {
    window.innerWidth = 1100; window.innerHeight = 400;
    const ctx = fakeCtx();
    const canvas = document.getElementById('tl-particles');
    canvas.getContext = jest.fn(() => ctx);
    effects.initParticles();
    expect(canvas.style.width).toBe('1100px');
    expect(canvas.width).toBe(1100);
    expect(ctx.arc).toHaveBeenCalledTimes(20);
    expect(ctx.fillStyle).toMatch(/^rgba\(200, 169, 110, /);
    expect(window.requestAnimationFrame).toHaveBeenCalledTimes(1);
    window.innerWidth = 550;
    window.dispatchEvent(new Event('resize'));
    expect(canvas.style.width).toBe('550px');
  });

  test('initParticles : rien en mouvement réduit ou sans canevas', () => {
    window.matchMedia = jest.fn(() => ({ matches: true }));
    const canvas = document.getElementById('tl-particles');
    canvas.getContext = jest.fn();
    effects.initParticles();
    expect(canvas.getContext).not.toHaveBeenCalled();
    delete window.matchMedia;
    canvas.remove();
    expect(() => effects.initParticles()).not.toThrow();
  });

  test('initProgress règle la largeur de la barre', () => {
    effects.initProgress();
    expect(document.getElementById('tl-progress').style.width).toBe('0%');
    document.getElementById('tl-progress').remove();
    expect(() => effects.initProgress()).not.toThrow();
  });
});

describe('timeline.js — démarrage', () => {
  async function boot(fetchImpl) {
    jest.resetModules();
    page();
    global.auth = { init: jest.fn(() => Promise.resolve()), fetchWithTimeout: jest.fn(fetchImpl) };
    global.showToast = jest.fn();
    document.getElementById('tl-particles').getContext = () => null;
    window.matchMedia = jest.fn(() => ({ matches: true })); // pas de particules ni d'animation
    const spy = jest.spyOn(document, 'addEventListener');
    require('../js/timeline');
    const onReady = spy.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
    spy.mockRestore();
    await onReady();
  }

  afterEach(() => { delete window.matchMedia; });

  test('rend chapitres, minimap et totaux puis masque le chargement', async () => {
    await boot(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: DECADES }) }));
    expect(document.body.classList.contains('tl-has-cinematic')).toBe(true);
    expect(document.querySelectorAll('.tl-chapter')).toHaveLength(3);
    expect(document.querySelectorAll('.tl-mm-btn')).toHaveLength(3);
    expect(document.getElementById('tl-stat-events').textContent).toBe('2');
    expect(document.getElementById('tl-stat-aircraft').textContent).toBe('2');
    expect(document.getElementById('tl-stat-decades').textContent).toBe('3');
    const hide = window.requestAnimationFrame.mock.calls.at(-1)[0];
    hide();
    expect(document.getElementById('tl-loading').classList.contains('gone')).toBe(true);
  });

  test('changement de langue : nouveau rendu des chapitres', async () => {
    await boot(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: DECADES }) }));
    const before = document.querySelector('.tl-chapter');
    window.dispatchEvent(new Event('langChanged'));
    expect(document.querySelector('.tl-chapter')).not.toBe(before);
    expect(document.querySelectorAll('.tl-chapter')).toHaveLength(3);
  });

  test('frise vide : message et chargement masqué', async () => {
    await boot(() => Promise.resolve({ ok: true, json: () => Promise.resolve({ decades: [] }) }));
    expect(document.querySelector('.tl-empty-msg').textContent).toBe('timeline.no_aircraft');
    expect(document.getElementById('tl-loading').classList.contains('gone')).toBe(true);
  });

  test('erreur réseau : message d\'erreur et toast', async () => {
    await boot(() => Promise.resolve({ ok: false, status: 500 }));
    expect(document.querySelector('.tl-empty-msg').textContent).toBe('common.loading_error');
    expect(document.getElementById('tl-loading').classList.contains('gone')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('common.loading_error', 'error');
  });
});
