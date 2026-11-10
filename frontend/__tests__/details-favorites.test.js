/**
 * Tests DOM — frontend/js/details/favorites.js
 *
 * Bouton favori de la fiche : état initial lu sur l'API, bascule POST/DELETE,
 * blocage pendant la requête (aria-busy), cross-fade des deux cœurs par
 * data-state (le contenu n'est construit qu'une fois), redirection vers
 * /login sans session.
 */

const flush = () => new Promise((r) => setTimeout(r, 0));

function jsonResponse(body, ok = true, status = 200) {
  return Promise.resolve({ ok, status, json: () => Promise.resolve(body) });
}

let fav;

function boot({ token = 'jeton', authFetch } = {}) {
  jest.resetModules();
  document.body.innerHTML =
    '<button type="button" id="favorite-btn" class="btn btn-favorite">'
    + '<i class="far fa-heart"></i><span data-i18n="details.add_favorite">Ajouter aux favoris</span></button>';
  global.i18n = { t: (k) => `t:${k}`, currentLang: 'fr' };
  global.showToast = jest.fn();
  global.auth = {
    getToken: jest.fn(() => token),
    authFetch: authFetch || jest.fn(() => jsonResponse({})),
  };
  window.VH = {};
  require('../js/details/favorites');
  fav = window.VH.details.favorites;
}

const btn = () => document.getElementById('favorite-btn');
const swapState = () => btn().querySelector('.t-icon-swap').getAttribute('data-state');
const label = () => btn().querySelector('.fav-label').textContent;

describe('updateFavoriteButton', () => {
  test('sans bouton dans la page : ne lève pas', () => {
    boot();
    document.body.innerHTML = '';
    expect(() => fav.updateFavoriteButton({ isFavorite: true })).not.toThrow();
  });

  test('premier rendu : deux cœurs empilés, masqués aux lecteurs d\'écran, libellé lisible', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: false });
    const swap = btn().querySelector('.t-icon-swap');
    expect(swap.getAttribute('aria-hidden')).toBe('true');
    expect(swap.querySelectorAll('i')).toHaveLength(2);
    expect(swapState()).toBe('b');
    expect(label()).toBe('t:details.add_favorite');
    expect(btn().classList.contains('favorited')).toBe(false);
  });

  test('favori : état « a », classe favorited, libellé « retirer »', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: true });
    expect(swapState()).toBe('a');
    expect(btn().classList.contains('favorited')).toBe(true);
    expect(label()).toBe('t:details.remove_favorite');
  });

  test('bascules successives : les icônes ne sont pas reconstruites (transition préservée)', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: false });
    const swap = btn().querySelector('.t-icon-swap');
    fav.updateFavoriteButton({ isFavorite: true });
    fav.updateFavoriteButton({ isFavorite: false });
    expect(btn().querySelector('.t-icon-swap')).toBe(swap);
    expect(swapState()).toBe('b');
    expect(btn().classList.contains('favorited')).toBe(false);
  });
});

describe('checkFavoriteStatus', () => {
  test('sans session : aucun appel réseau', async () => {
    boot({ token: null });
    await fav.checkFavoriteStatus({ aircraftId: 30 });
    expect(auth.authFetch).not.toHaveBeenCalled();
  });

  test('interroge /api/airplanes/:id/favorite et reflète la réponse', async () => {
    const authFetch = jest.fn(() => jsonResponse({ isFavorite: true }));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: false };
    await fav.checkFavoriteStatus(state);
    expect(authFetch).toHaveBeenCalledWith('/api/airplanes/30/favorite');
    expect(state.isFavorite).toBe(true);
    expect(swapState()).toBe('a');
  });

  test('erreur réseau : silencieuse, état inchangé', async () => {
    const authFetch = jest.fn(() => Promise.reject(new Error('offline')));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: false };
    await expect(fav.checkFavoriteStatus(state)).resolves.toBeUndefined();
    expect(state.isFavorite).toBe(false);
  });
});

describe('setup — clic sur le bouton', () => {
  test('sans bouton : setup ne lève pas', () => {
    boot();
    document.body.innerHTML = '';
    expect(() => fav.setup({ aircraftId: 1 })).not.toThrow();
  });

  test('sans session : toast d\'information puis redirection vers /login après 1,5 s', () => {
    jest.useFakeTimers();
    try {
      boot({ token: null });
      fav.setup({ aircraftId: 30, isFavorite: false });
      btn().click();
      expect(showToast).toHaveBeenCalledWith('t:common.login_to_favorite', 'info');
      expect(auth.authFetch).not.toHaveBeenCalled();
      const spy = jest.spyOn(console, 'error').mockImplementation(() => {});
      jest.advanceTimersByTime(1499);
      expect(spy).not.toHaveBeenCalled();
      jest.advanceTimersByTime(1);
      // jsdom n'implémente pas la navigation : la tentative est journalisée.
      expect(String(spy.mock.calls[0][0].message)).toMatch(/navigation/);
      spy.mockRestore();
    } finally {
      jest.useRealTimers();
    }
  });

  test('ajout : POST /api/favorites/:id, état basculé, « pop » du cœur, toast de succès', async () => {
    const authFetch = jest.fn(() => jsonResponse({}));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: false };
    fav.setup(state);
    btn().click();
    await flush();
    expect(authFetch).toHaveBeenCalledWith('/api/favorites/30', { method: 'POST' });
    expect(state.isFavorite).toBe(true);
    expect(swapState()).toBe('a');
    expect(btn().classList.contains('is-popping')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_added', 'success');
    btn().dispatchEvent(new Event('animationend'));
    expect(btn().classList.contains('is-popping')).toBe(false);
  });

  test('retrait : DELETE, pas d\'animation, toast « retiré »', async () => {
    const authFetch = jest.fn(() => jsonResponse({}));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: true };
    fav.setup(state);
    btn().click();
    await flush();
    expect(authFetch).toHaveBeenCalledWith('/api/favorites/30', { method: 'DELETE' });
    expect(state.isFavorite).toBe(false);
    expect(btn().classList.contains('is-popping')).toBe(false);
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_removed', 'success');
  });

  test('pendant la requête : aria-busy + disabled, un second clic n\'envoie rien', async () => {
    let resolve;
    const authFetch = jest.fn(() => new Promise((r) => { resolve = r; }));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: false };
    fav.setup(state);
    btn().click();
    expect(btn().getAttribute('aria-busy')).toBe('true');
    expect(btn().disabled).toBe(true);
    // Même réactivé (ex. par un autre script), aria-busy suffit à bloquer.
    btn().disabled = false;
    btn().click();
    expect(authFetch).toHaveBeenCalledTimes(1);
    resolve({ ok: true, json: () => Promise.resolve({}) });
    await flush();
    expect(btn().hasAttribute('aria-busy')).toBe(false);
    expect(btn().disabled).toBe(false);
  });

  test('réponse en erreur : toast d\'erreur traduit, état inchangé, bouton réactivé', async () => {
    const authFetch = jest.fn(() => jsonResponse({}, false, 500));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: false };
    fav.setup(state);
    btn().click();
    await flush();
    expect(state.isFavorite).toBe(false);
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_error', 'error');
    expect(btn().disabled).toBe(false);
    expect(btn().hasAttribute('aria-busy')).toBe(false);
  });
});
