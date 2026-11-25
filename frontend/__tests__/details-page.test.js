/**
 * Tests — frontend/js/details.js (orchestrateur de la fiche).
 *
 * Le script tient dans un écouteur DOMContentLoaded : on le capture au
 * chargement du module pour l'appeler directement, avec des modules
 * VH.details.* simulés. On vérifie l'extraction de l'identifiant (deux formats
 * d'URL), l'interface selon le rôle, l'ordre d'initialisation, la restauration
 * des filtres du hangar et les réactions au changement de langue / à Échap.
 */

let handler;
let listeners;
let consoleSpy;

function mountDom() {
  document.body.innerHTML = `
    <button id="edit-btn" class="hidden"></button>
    <button id="delete-btn" class="hidden"></button>
    <nav><a id="crumb" href="/hangar">Hangar</a><a id="hq" href="/hangar?gen=3">Hangar filtré</a>
      <a id="home" href="/">Accueil</a><a id="other" href="/hangar-x">Autre</a></nav>`;
}

function stubModules() {
  const order = [];
  const track = (name, impl) => jest.fn((...args) => { order.push(name); return impl ? impl(...args) : undefined; });
  window.VH = {
    shared: { adminLoader: { isEditor: (p) => [1, 2].includes(Number(p && p.role)), load: jest.fn(() => Promise.resolve()) } },
    details: {
      favorites: { setup: track('favorites.setup'), updateFavoriteButton: track('favorites.update') },
      compare: { setup: track('compare.setup') },
      admin: { setup: track('admin.setup'), closeEditModal: track('admin.close') },
      ui: {
        setupShareBar: track('ui.share'), setupScrollProgress: track('ui.scroll'),
        setupPdfExport: track('ui.pdf'), setupMiniBarVisibility: track('ui.minibarVisibility'),
        setupSectionAnimations: track('ui.sections'), syncMiniBar: track('ui.syncMiniBar'),
      },
      data: {
        loadAircraftDetails: track('data.load', (state) => { state.aircraftData = { name: 'Rafale' }; }),
        loadRelatedData: track('data.related'),
      },
      render: { renderAircraftDetails: track('render.details') },
      lineage: { load: track('lineage.load') },
      photoZoom: { setup: track('photoZoom.setup') },
    },
  };
  return order;
}

/** Charge details.js et capture son écouteur DOMContentLoaded et ses écouteurs globaux. */
function load({ url = '/details/rafale-30', payload = null, saved } = {}) {
  jest.resetModules();
  window.history.replaceState(null, '', url);
  mountDom();
  global.auth = { init: jest.fn(() => Promise.resolve()), getPayload: jest.fn(() => payload) };
  global.i18n = { t: (k) => `t:${k}`, currentLang: 'fr' };
  sessionStorage.clear();
  if (saved !== undefined) sessionStorage.setItem('hangar_filters', saved);
  const order = stubModules();

  listeners = [];
  const docAdd = jest.spyOn(document, 'addEventListener');
  const winAdd = jest.spyOn(window, 'addEventListener');
  require('../js/details');
  handler = docAdd.mock.calls.find(([type]) => type === 'DOMContentLoaded')[1];
  const nativeAdd = window.EventTarget.prototype.addEventListener;
  docAdd.mockImplementation(function (type, fn, opts) {
    listeners.push([document, type, fn, opts]);
    return nativeAdd.call(this, type, fn, opts);
  });
  winAdd.mockImplementation(function (type, fn, opts) {
    listeners.push([window, type, fn, opts]);
    return nativeAdd.call(this, type, fn, opts);
  });
  return order;
}

beforeEach(() => {
  consoleSpy = jest.spyOn(console, 'error').mockImplementation(() => {});
});

afterEach(() => {
  listeners.forEach(([target, type, fn, opts]) => target.removeEventListener(type, fn, opts));
  jest.restoreAllMocks();
});

const navigated = () => consoleSpy.mock.calls.some((c) => /navigation/.test(String(c[0] && c[0].message)));
const VHd = () => window.VH.details;

describe('details.js — identifiant de l\'appareil', () => {
  test('URL propre /details/<slug>-<id> : id extrait du dernier segment', async () => {
    load({ url: '/details/f-22-raptor-14' });
    await handler();
    expect(VHd().data.loadAircraftDetails).toHaveBeenCalledWith(expect.objectContaining({ aircraftId: '14' }));
    expect(navigated()).toBe(false);
  });

  test('ancien format /details?id=14 : prioritaire sur le chemin', async () => {
    load({ url: '/details/autre-99?id=14' });
    await handler();
    expect(VHd().data.loadAircraftDetails.mock.calls[0][0].aircraftId).toBe('14');
  });

  test.each([
    ['/details', 'aucun identifiant'],
    ['/details/rafale', 'slug sans id'],
    ['/details?id=14abc', 'id non numérique'],
    ['/details?id=-3', 'id négatif'],
    ['/', 'racine'],
  ])('%s (%s) : redirection vers /404, rien n\'est chargé', async (url) => {
    load({ url });
    await handler();
    expect(navigated()).toBe(true);
    expect(VHd().data.loadAircraftDetails).not.toHaveBeenCalled();
    expect(VHd().favorites.setup).not.toHaveBeenCalled();
  });

  test('l\'authentification est initialisée avant tout', async () => {
    const order = load();
    let initDone = false;
    auth.init.mockImplementation(() => new Promise((r) => setTimeout(() => { initDone = true; r(); }, 0)));
    VHd().favorites.setup.mockImplementation(() => { expect(initDone).toBe(true); order.push('favorites.setup'); });
    await handler();
    expect(auth.init).toHaveBeenCalledTimes(1);
    expect(VHd().favorites.setup).toHaveBeenCalled();
  });
});

describe('details.js — ordre d\'initialisation', () => {
  test('écouteurs posés avant le chargement, animations et mini-barre après', async () => {
    const order = load();
    await handler();
    expect(order).toEqual([
      // Visiteur anonyme : le code d'administration n'est ni chargé ni initialisé (JS-002).
      'favorites.setup', 'compare.setup', 'ui.share', 'ui.scroll', 'ui.pdf',
      'ui.minibarVisibility', 'photoZoom.setup', 'data.load', 'ui.sections', 'ui.syncMiniBar',
    ]);
    const state = VHd().data.loadAircraftDetails.mock.calls[0][0];
    // Le même objet state est partagé par tous les modules.
    expect(VHd().favorites.setup.mock.calls[0][0]).toBe(state);
    expect(VHd().ui.syncMiniBar.mock.calls[0][0]).toBe(state);
    expect(state).toMatchObject({ aircraftId: '30', isFavorite: false, userRole: null });
  });
});

describe('details.js — interface selon la session', () => {
  const hidden = (id) => document.getElementById(id).classList.contains('hidden');

  test('visiteur anonyme : boutons d\'administration masqués', async () => {
    load({ payload: null });
    await handler();
    expect(hidden('edit-btn')).toBe(true);
    expect(hidden('delete-btn')).toBe(true);
  });

  test.each([
    [1, false],
    [2, false],
    [3, true],
  ])('rôle %i : boutons admin masqués = %s', async (role, adminHidden) => {
    load({ payload: { name: 'Titouan', role: String(role) } });
    await handler();
    expect(hidden('edit-btn')).toBe(adminHidden);
    expect(hidden('delete-btn')).toBe(adminHidden);
    expect(VHd().favorites.setup.mock.calls[0][0].userRole).toBe(role);
    // Code d'administration chargé et initialisé pour les seuls admin/éditeur (JS-002).
    expect(window.VH.shared.adminLoader.load).toHaveBeenCalledTimes(adminHidden ? 0 : 1);
    expect(VHd().admin.setup).toHaveBeenCalledTimes(adminHidden ? 0 : 1);
  });

  test('module d’administration indisponible : boutons masqués, message d’erreur', async () => {
    load({ payload: { name: 'Titouan', role: '1' } });
    window.VH.shared.adminLoader.load.mockRejectedValueOnce(new Error('réseau'));
    global.showToast = jest.fn();
    await handler();
    expect(hidden('edit-btn')).toBe(true);
    expect(VHd().admin.setup).not.toHaveBeenCalled();
    expect(global.showToast).toHaveBeenCalledWith('t:common.loading_error', 'error');
    delete global.showToast;
  });
});

describe('details.js — liens « retour au hangar »', () => {
  const hrefs = () => ['crumb', 'hq', 'home', 'other'].map((id) => document.getElementById(id).getAttribute('href'));

  test('filtres et page sauvegardés : tous les liens /hangar les reprennent', async () => {
    load({
      saved: JSON.stringify({
        filters: { country: 'France', generation: 4, type: 'Chasseur', search: 'mirage 2000' },
        sort: 'alphabetical', currentPage: 3,
      }),
    });
    await handler();
    const target = '/hangar?country=France&gen=4&type=Chasseur&q=mirage+2000&sort=alphabetical&page=3';
    expect(hrefs()).toEqual([target, target, '/', '/hangar-x']);
  });

  test('tri par défaut et page 1 : non reportés ; rien d\'utile → liens intacts', async () => {
    load({ saved: JSON.stringify({ filters: {}, sort: 'default', currentPage: 1 }) });
    await handler();
    expect(hrefs()).toEqual(['/hangar', '/hangar?gen=3', '/', '/hangar-x']);
  });

  test('aucune sauvegarde (arrivée depuis un moteur de recherche) : liens intacts', async () => {
    load();
    await handler();
    expect(hrefs()).toEqual(['/hangar', '/hangar?gen=3', '/', '/hangar-x']);
  });

  test('sauvegarde corrompue : ignorée sans erreur, la fiche se charge', async () => {
    load({ saved: '{pas du json' });
    await handler();
    expect(hrefs()[0]).toBe('/hangar');
    expect(VHd().data.loadAircraftDetails).toHaveBeenCalled();
  });

  test('sauvegarde sans filtres mais avec page : seule la page est reportée', async () => {
    load({ saved: JSON.stringify({ currentPage: 2 }) });
    await handler();
    expect(hrefs()[0]).toBe('/hangar?page=2');
  });
});

describe('details.js — changement de langue et clavier', () => {
  test('langChanged : mini-barre resynchronisée, fiche, related, filiation et favori re-rendus', async () => {
    load();
    await handler();
    const state = VHd().data.loadAircraftDetails.mock.calls[0][0];
    window.dispatchEvent(new Event('langChanged'));
    expect(VHd().ui.syncMiniBar).toHaveBeenCalledTimes(2);
    expect(VHd().render.renderAircraftDetails).toHaveBeenCalledWith(state);
    expect(VHd().data.loadRelatedData).toHaveBeenCalledWith(state);
    expect(VHd().lineage.load).toHaveBeenCalledWith(state);
    expect(VHd().favorites.updateFavoriteButton).toHaveBeenCalledWith(state);
  });

  test('langChanged avant que la fiche soit chargée : aucun re-rendu', async () => {
    load();
    VHd().data.loadAircraftDetails.mockImplementation(() => {});
    await handler();
    window.dispatchEvent(new Event('langChanged'));
    expect(VHd().render.renderAircraftDetails).not.toHaveBeenCalled();
  });

  test('Échap ferme la modale d\'édition ; les autres touches non', async () => {
    load();
    await handler();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter' }));
    expect(VHd().admin.closeEditModal).not.toHaveBeenCalled();
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    expect(VHd().admin.closeEditModal).toHaveBeenCalledTimes(1);
  });
});
