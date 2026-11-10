/**
 * Tests DOM — frontend/js/conflicts.js (page /conflits et /conflits/<slug>)
 *
 * Choix de l'API d'après l'URL (slug décodé puis réencodé), rendu de la
 * liste et d'un conflit (données échappées, lien hangar ?war= en nom FR
 * canonique), retrait des data-i18n sur le contenu rendu, aria-busy, erreurs.
 */

const T = {
  'conflicts.since': 'depuis {year}',
  'conflicts.aircraft_one': '{count} appareil',
  'conflicts.aircraft_many': '{count} appareils',
  'conflicts.eyebrow_war': 'Conflit',
  'conflicts.stat_aircraft_engaged': 'Appareils engagés',
  'conflicts.stat_nations': 'Nations',
};

let conflicts;

function page() {
  document.body.innerHTML = `
    <nav><span id="crumb-current" class="hidden"><span id="crumb-current-name" data-i18n="x">…</span></span></nav>
    <h1 id="page-hero-heading" data-i18n="conflicts.title">Conflits</h1>
    <p id="hero-eyebrow" data-i18n="conflicts.eyebrow">…</p>
    <p id="hero-desc" data-i18n-html="conflicts.desc">…</p>
    <span id="stat-a" data-i18n="x">—</span><span id="stat-a-label" data-i18n="x">—</span>
    <span id="stat-b" data-i18n="x">—</span><span id="stat-b-label" data-i18n="x">—</span>
    <section class="conflicts-section">
      <div id="conflicts-loading"></div>
      <div id="conflicts-error" class="hidden"></div>
      <div id="conflicts-list" class="hidden"></div>
      <div id="conflict-detail" class="hidden">
        <a id="conflict-hangar-link" href="/hangar">Hangar</a>
        <div id="conflict-aircraft"></div>
      </div>
    </section>`;
}

function load({ response, loaded = true } = {}) {
  jest.resetModules();
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.i18n = {
    isLoaded: loaded,
    t: (k, p = {}) => (T[k] || k).replace(/\{(\w+)\}/g, (_, n) => p[n]),
  };
  global.showToast = jest.fn();
  global.auth = {
    init: jest.fn(() => Promise.resolve()),
    fetchWithTimeout: jest.fn(response || (() => Promise.resolve({ ok: true, json: () => Promise.resolve([]) }))),
  };
  window.nav = { updateAuthUI: jest.fn() };
  window.VH = { shared: { renderAircraftCard: jest.fn(a => `<article class="aircraft-card" data-id="${a.id}"></article>`) } };
  conflicts = require('../js/conflicts');
}

const ok = (body) => () => Promise.resolve({ ok: true, json: () => Promise.resolve(body) });
const $ = (id) => document.getElementById(id);

beforeEach(page);
afterEach(() => { delete window.nav; });

describe('slugFromPath', () => {
  test.each([
    ['/conflits', null],
    ['/conflits/', null],
    ['/conflits/guerre-du-golfe', 'guerre-du-golfe'],
    ['/conflits/guerre%20d%27alg%C3%A9rie', "guerre d'algérie"],
    ['/hangar/guerre', null],
  ])('%s → %s', (path, slug) => {
    load();
    window.history.replaceState(null, '', path);
    expect(conflicts.slugFromPath()).toBe(slug);
  });
});

describe('page liste (/conflits)', () => {
  const WARS = [
    { slug: 'guerre-du-golfe', name: 'Guerre du Golfe', description: 'Koweït <script>', date_start: '1990-08-02', date_end: '1991-02-28', count: 24 },
    { slug: "l'ukraine", name: 'Guerre <b>en Ukraine</b>', date_start: '2022-02-24', date_end: null, count: 1 },
    { slug: 'x', name: 'Sans compte', date_start: null },
  ];

  test('interroge /api/wars, rend une carte-lien par conflit et les totaux', async () => {
    window.history.replaceState(null, '', '/conflits');
    load({ response: ok(WARS) });
    await conflicts.init();

    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/wars');
    expect(nav.updateAuthUI).toHaveBeenCalled();
    const list = $('conflicts-list');
    expect(list.classList.contains('hidden')).toBe(false);
    const cards = list.querySelectorAll('a.conflict-card');
    expect(cards).toHaveLength(3);
    expect(cards[0].getAttribute('href')).toBe('/conflits/guerre-du-golfe');
    expect(cards[1].getAttribute('href')).toBe("/conflits/l'ukraine");
    expect(cards[0].querySelector('.conflict-period').textContent).toBe('1990 – 1991');
    expect(cards[1].querySelector('.conflict-period').textContent).toBe('depuis 2022');
    expect(cards[0].querySelector('.conflict-count').textContent.trim()).toBe('24 appareils');
    expect(cards[1].querySelector('.conflict-count').textContent.trim()).toBe('1 appareil');
    // Données de l'API échappées
    expect(list.querySelector('script, b')).toBeNull();
    expect(cards[1].querySelector('.conflict-name').textContent).toBe('Guerre <b>en Ukraine</b>');
    expect(cards[0].querySelector('.conflict-desc').textContent).toBe('Koweït <script>');
    expect(cards[1].querySelector('.conflict-desc')).toBeNull();

    expect($('stat-a').textContent).toBe('3');
    expect($('stat-b').textContent).toBe('25');
    // Contenu rendu : plus de data-i18n qui le ramènerait au texte d'attente
    expect($('stat-a').hasAttribute('data-i18n')).toBe(false);
    // Chargement terminé
    expect($('conflicts-loading')).toBeNull();
    expect(document.querySelector('.conflicts-section').hasAttribute('aria-busy')).toBe(false);
    expect($('conflict-detail').classList.contains('hidden')).toBe(true);
  });

  test('réponse non tableau : liste vide, pas d\'erreur', async () => {
    window.history.replaceState(null, '', '/conflits');
    load({ response: ok({ error: 'x' }) });
    await conflicts.init();
    expect($('conflicts-list').children).toHaveLength(0);
    expect($('stat-a').textContent).toBe('0');
  });

  test('page sans conteneur de liste : rien n\'est rendu', async () => {
    window.history.replaceState(null, '', '/conflits');
    $('conflicts-list').remove();
    load({ response: ok(WARS) });
    await conflicts.init();
    expect($('stat-a').textContent).toBe('—');
  });

  test('aria-busy est posé pendant le chargement', async () => {
    window.history.replaceState(null, '', '/conflits');
    let busyDuringFetch;
    load({
      response: () => {
        busyDuringFetch = document.querySelector('.conflicts-section').getAttribute('aria-busy');
        return Promise.resolve({ ok: true, json: () => Promise.resolve([]) });
      },
    });
    await conflicts.init();
    expect(busyDuringFetch).toBe('true');
  });
});

describe('page d\'un conflit (/conflits/<slug>)', () => {
  const WAR = {
    name: 'Guerre du Golfe', name_fr: 'Guerre du Golfe', description: 'Libération du Koweït',
    date_start: '1990-08-02', date_end: '1991-02-28', count: 3,
    airplanes: [
      { id: 1, country_code: 'USA' }, { id: 2, country_code: 'FRA' }, { id: 3, country_code: 'USA' }, { id: 4 },
    ],
  };

  test('interroge /api/wars/<slug encodé> et remplit titre, fil d\'Ariane, stats et cartes', async () => {
    window.history.replaceState(null, '', '/conflits/guerre%20du%20golfe');
    load({ response: ok(WAR) });
    await conflicts.init();

    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/wars/guerre%20du%20golfe');
    expect($('page-hero-heading').textContent).toBe('Guerre du Golfe');
    expect($('page-hero-heading').hasAttribute('data-i18n')).toBe(false);
    expect($('hero-eyebrow').textContent).toBe('Conflit · 1990 – 1991');
    expect($('hero-desc').textContent).toBe('Libération du Koweït');
    expect($('hero-desc').hasAttribute('data-i18n-html')).toBe(false);
    expect($('stat-a').textContent).toBe('3');
    expect($('stat-a-label').textContent).toBe('Appareils engagés');
    // Nations distinctes, appareils sans pays ignorés
    expect($('stat-b').textContent).toBe('2');
    expect($('stat-b-label').textContent).toBe('Nations');
    expect($('crumb-current').classList.contains('hidden')).toBe(false);
    expect($('crumb-current-name').textContent).toBe('Guerre du Golfe');
    expect($('conflict-aircraft').querySelectorAll('.aircraft-card')).toHaveLength(4);
    expect(window.VH.shared.renderAircraftCard).toHaveBeenCalledWith(WAR.airplanes[0]);
    expect($('conflict-detail').classList.contains('hidden')).toBe(false);
    expect($('conflicts-list').classList.contains('hidden')).toBe(true);
  });

  test('le lien vers le hangar filtre sur le nom FR canonique, quelle que soit la langue', async () => {
    window.history.replaceState(null, '', '/conflits/gulf-war');
    load({ response: ok({ ...WAR, name: 'Gulf War', name_fr: "Guerre d'Algérie & co" }) });
    await conflicts.init();
    expect($('conflict-hangar-link').getAttribute('href')).toBe('/hangar?war=Guerre%20d\'Alg%C3%A9rie%20%26%20co');
    expect($('page-hero-heading').textContent).toBe('Gulf War');
  });

  test('conflit sans description ni appareils, page allégée : pas d\'erreur', async () => {
    window.history.replaceState(null, '', '/conflits/x');
    ['hero-desc', 'crumb-current', 'conflict-hangar-link', 'conflict-aircraft'].forEach(id => $(id).remove());
    load({ response: ok({ name: 'X', name_fr: 'X', count: 0, date_start: '2001-01-01' }) });
    await conflicts.init();
    expect($('stat-b').textContent).toBe('0');
    expect($('hero-eyebrow').textContent).toBe('Conflit · depuis 2001');
    expect($('conflict-detail').classList.contains('hidden')).toBe(false);
  });

  test('slug inconnu (404) : message d\'erreur affiché, chargement retiré, pas de toast', async () => {
    window.history.replaceState(null, '', '/conflits/inconnu');
    load({ response: () => Promise.resolve({ ok: false, status: 404 }) });
    await conflicts.init();
    expect($('conflicts-error').classList.contains('hidden')).toBe(false);
    expect($('conflicts-loading')).toBeNull();
    expect($('conflict-detail').classList.contains('hidden')).toBe(true);
    expect(showToast).not.toHaveBeenCalled();
  });

  test('réseau coupé : message d\'erreur et toast traduit', async () => {
    window.history.replaceState(null, '', '/conflits/x');
    load({ response: () => Promise.reject(new Error('timeout')) });
    await conflicts.init();
    expect($('conflicts-error').classList.contains('hidden')).toBe(false);
    expect(showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    expect(document.querySelector('.conflicts-section').hasAttribute('aria-busy')).toBe(false);
  });

  test('page sans bloc d\'erreur ni section : pas d\'erreur', async () => {
    window.history.replaceState(null, '', '/conflits/x');
    document.body.innerHTML = '';
    load({ response: () => Promise.resolve({ ok: false }) });
    await expect(conflicts.init()).resolves.toBeUndefined();
  });
});

describe('attente des traductions', () => {
  afterEach(() => jest.useRealTimers());

  test('le rendu attend i18n.isLoaded avant de traduire', async () => {
    jest.useFakeTimers();
    window.history.replaceState(null, '', '/conflits');
    load({ response: ok([]), loaded: false });
    const done = conflicts.init();
    await Promise.resolve();
    await Promise.resolve();
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    i18n.isLoaded = true;
    await jest.advanceTimersByTimeAsync(40);
    await done;
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
  });

  test('traductions jamais chargées : on n\'attend pas plus de 3 s', async () => {
    jest.useFakeTimers();
    window.history.replaceState(null, '', '/conflits');
    load({ response: ok([]), loaded: false });
    const done = conflicts.init();
    await jest.advanceTimersByTimeAsync(2900);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    await jest.advanceTimersByTimeAsync(200);
    await done;
    expect(auth.fetchWithTimeout).toHaveBeenCalledTimes(1);
  });

  test('sans nav.updateAuthUI : la page se charge quand même', async () => {
    window.history.replaceState(null, '', '/conflits');
    load({ response: ok([]) });
    delete window.nav;
    await conflicts.init();
    expect(auth.fetchWithTimeout).toHaveBeenCalled();
  });
});
