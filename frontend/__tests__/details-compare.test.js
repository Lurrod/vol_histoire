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

  test('au repos : non pressé, libellé « comparer », icône viseur', () => {
    const btn = document.getElementById('compare-btn');
    expect(btn.getAttribute('aria-pressed')).toBe('false');
    expect(btn.querySelector('span').textContent).toBe('details.compare_add');
    expect(btn.querySelector('i').className).toContain('fa-crosshairs');
  });

  test('après ajout : pressé, libellé « dans le comparateur », nouvelle icône coche', () => {
    const btn = document.getElementById('compare-btn');
    const before = btn.querySelector('i');
    btn.click();
    expect(btn.getAttribute('aria-pressed')).toBe('true');
    expect(btn.classList.contains('is-active')).toBe(true);
    expect(btn.querySelector('span').textContent).toBe('details.compare_in');
    // L'icône est un nouvel élément (icons.js ne convertit que les insertions)
    const after = btn.querySelector('i');
    expect(after).not.toBe(before);
    expect(after.className).toContain('fa-check');
    // Le libellé n'est plus retraduit par applyToDOM()
    expect(btn.querySelector('span').hasAttribute('data-i18n')).toBe(false);
  });

  test('second clic : retour à l\'état initial', () => {
    const btn = document.getElementById('compare-btn');
    btn.click();
    btn.click();
    expect(btn.getAttribute('aria-pressed')).toBe('false');
    expect(btn.querySelector('i').className).toContain('fa-crosshairs');
  });
});
