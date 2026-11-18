/**
 * Tests — bouton « Comparer » de la fiche (details/compare.js) : l'état
 * « dans le comparateur » se lit sur le bouton (aria-pressed, libellé, icône).
 */

global.i18n = { t: (key) => key, currentLang: 'fr' };
global.showToast = jest.fn();

function makeStore() {
  const ids = new Set();
  const listeners = [];
  return {
    init: jest.fn(),
    has: (id) => ids.has(id),
    toggle(id) {
      if (ids.has(id)) { ids.delete(id); } else { ids.add(id); }
      listeners.forEach((fn) => fn());
      return ids.has(id) ? 'added' : 'removed';
    },
    onChange: (fn) => listeners.push(fn),
  };
}

describe('details/compare — état du bouton', () => {
  let compare;
  beforeEach(() => {
    jest.resetModules();
    document.body.innerHTML = '<button id="compare-btn" aria-pressed="false"><i class="fas fa-crosshairs"></i><span data-i18n="details.compare_add">Comparer</span></button>';
    window.VH = { shared: { compare: makeStore() } };
    compare = require('../js/details/compare');
    compare.setup({ aircraftId: 7 });
  });

  test('au repos : non pressé, libellé « comparer », viseur dessiné', () => {
    const btn = document.getElementById('compare-btn');
    expect(btn.getAttribute('aria-pressed')).toBe('false');
    expect(btn.querySelector('span').textContent).toBe('details.compare_add');
    expect(btn.querySelector('svg.cmp-reticle')).not.toBeNull();
    expect(btn.querySelector('i')).toBeNull();
    expect(btn.querySelectorAll('.cmp-tick')).toHaveLength(4);
  });

  test('après ajout : pressé, libellé « dans le comparateur », même viseur (la coche se trace en CSS)', () => {
    const btn = document.getElementById('compare-btn');
    const before = btn.querySelector('svg.cmp-reticle');
    btn.click();
    expect(btn.getAttribute('aria-pressed')).toBe('true');
    expect(btn.classList.contains('is-active')).toBe(true);
    expect(btn.querySelector('span').textContent).toBe('details.compare_in');
    // Le SVG persiste : c'est lui qui anime graduations et coche.
    expect(btn.querySelector('svg.cmp-reticle')).toBe(before);
    expect(btn.querySelector('.cmp-check')).not.toBeNull();
    // La clé suit l'état : applyToDOM() (chargement ou changement de
    // langue) retraduit le bon libellé.
    expect(btn.querySelector('span').getAttribute('data-i18n')).toBe('details.compare_in');
  });

  test('traductions pas encore chargées : jamais la clé brute, applyToDOM traduira plus tard', () => {
    const saved = global.i18n;
    global.i18n = { t: (k) => k, currentLang: 'fr', isLoaded: false };
    try {
      jest.resetModules();
      document.body.innerHTML = '<button id="compare-btn" aria-pressed="false"><i class="fas fa-crosshairs"></i><span data-i18n="details.compare_add">Comparer</span></button>';
      window.VH = { shared: { compare: makeStore() } };
      require('../js/details/compare').setup({ aircraftId: 7 });
      const label = document.querySelector('#compare-btn span');
      expect(label.textContent).toBe('Comparer');
      expect(label.getAttribute('data-i18n')).toBe('details.compare_add');
    } finally {
      global.i18n = saved;
    }
  });

  test('second clic : retour à l\'état initial', () => {
    const btn = document.getElementById('compare-btn');
    btn.click();
    btn.click();
    expect(btn.getAttribute('aria-pressed')).toBe('false');
    expect(btn.querySelectorAll('svg.cmp-reticle')).toHaveLength(1);
  });

  test('le comparateur est initialisé sans synchronisation d\'URL (URL de fiche préservée)', () => {
    expect(window.VH.shared.compare.init).toHaveBeenCalledWith({ urlSync: false });
  });

  test('toasts : ajout en succès, retrait en information', () => {
    const btn = document.getElementById('compare-btn');
    global.showToast.mockClear();
    btn.click();
    expect(global.showToast).toHaveBeenLastCalledWith('details.compare_added', 'success');
    btn.click();
    expect(global.showToast).toHaveBeenLastCalledWith('details.compare_removed', 'info');
  });

  test('viseur : décoratif (aria-hidden), un seul, quel que soit l\'état', () => {
    const btn = document.getElementById('compare-btn');
    btn.click();
    expect(btn.querySelectorAll('svg')).toHaveLength(1);
    expect(btn.querySelector('svg').getAttribute('aria-hidden')).toBe('true');
    expect(btn.querySelector('svg').getAttribute('focusable')).toBe('false');
  });

  test('icône déjà convertie en <svg class="icon"> par icons.js : remplacée par le viseur', () => {
    jest.resetModules();
    document.body.innerHTML = '<button id="compare-btn" aria-pressed="false"><svg class="icon icon-crosshairs"></svg><span>c</span></button>';
    window.VH = { shared: { compare: makeStore() } };
    require('../js/details/compare').setup({ aircraftId: 7 });
    const btn = document.getElementById('compare-btn');
    expect(btn.querySelector('svg.icon')).toBeNull();
    expect(btn.querySelector('svg.cmp-reticle')).not.toBeNull();
  });
});

describe('details/compare — cas limites', () => {
  function bootWith(html, store) {
    jest.resetModules();
    document.body.innerHTML = html;
    window.VH = store === undefined ? { shared: { compare: makeStore() } } : store;
    return require('../js/details/compare');
  }

  test('comparateur plein : toast d\'avertissement, bouton inchangé', () => {
    const store = makeStore();
    store.toggle = jest.fn(() => 'full');
    bootWith('<button id="compare-btn"><i></i><span>c</span></button>', { shared: { compare: store } })
      .setup({ aircraftId: '9' });
    global.showToast.mockClear();
    document.getElementById('compare-btn').click();
    expect(store.toggle).toHaveBeenCalledWith(9);
    expect(global.showToast).toHaveBeenCalledWith('hangar.compare_max', 'warning');
    expect(document.getElementById('compare-btn').getAttribute('aria-pressed')).toBe('false');
  });

  test('showToast indisponible : le clic fonctionne quand même', () => {
    const saved = global.showToast;
    delete global.showToast;
    try {
      const store = makeStore();
      bootWith('<button id="compare-btn"><span>c</span></button>', { shared: { compare: store } })
        .setup({ aircraftId: 3 });
      const btn = document.getElementById('compare-btn');
      expect(() => btn.click()).not.toThrow();
      expect(btn.getAttribute('aria-pressed')).toBe('true');
      store.toggle = () => 'full';
      expect(() => btn.click()).not.toThrow();
    } finally {
      global.showToast = saved;
    }
  });

  test('bouton sans libellé ni icône : le viseur est ajouté en tête', () => {
    bootWith('<button id="compare-btn"></button>').setup({ aircraftId: 1 });
    expect(document.getElementById('compare-btn').firstElementChild.tagName.toLowerCase()).toBe('svg');
  });

  test('sans bouton ou sans comparateur partagé : rien n\'est branché', () => {
    const store = makeStore();
    bootWith('', { shared: { compare: store } }).setup({ aircraftId: 1 });
    expect(store.init).not.toHaveBeenCalled();
    expect(() => bootWith('<button id="compare-btn"></button>', {}).setup({ aircraftId: 1 })).not.toThrow();
    expect(() => bootWith('<button id="compare-btn"></button>', { shared: {} }).setup({ aircraftId: 1 })).not.toThrow();
  });
});
