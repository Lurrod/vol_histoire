/**
 * Tests DOM — frontend/js/details/favorites.js
 *
 * Bouton favori de la fiche : un cœur seul. État initial lu sur l'API ; ajout
 * d'un clic (POST) ; retrait en deux temps, sur place, comme la poubelle des
 * cartes de favoris (le cœur devient poubelle, « ✓ / ✗ » s'ouvrent à côté) ;
 * blocage pendant la requête (aria-busy) ; redirection vers /login sans
 * session.
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
    + '<i class="far fa-heart"></i></button>';
  global.i18n = { t: (k) => `t:${k}`, currentLang: 'fr' };
  global.showToast = jest.fn();
  global.auth = {
    getToken: jest.fn(() => token),
    authFetch: authFetch || jest.fn(() => jsonResponse({})),
  };
  window.VH = {};
  require('../js/shared/motion');
  require('../js/shared/confirm-action');
  require('../js/details/favorites');
  fav = window.VH.details.favorites;
}

const btn = () => document.getElementById('favorite-btn');
const swapState = () => btn().querySelector('.fav-heart').getAttribute('data-state');
const label = () => btn().getAttribute('aria-label');
const wrap = () => btn().closest('.cfm');

describe('updateFavoriteButton', () => {
  test('sans bouton dans la page : ne lève pas', () => {
    boot();
    document.body.innerHTML = '';
    expect(() => fav.updateFavoriteButton({ isFavorite: true })).not.toThrow();
  });

  test('premier rendu : un cœur seul (et sa poubelle cachée), masqués aux lecteurs d\'écran, nom accessible', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: false });
    const heart = btn().querySelector('.fav-heart');
    expect(heart.getAttribute('aria-hidden')).toBe('true');
    expect(heart.getAttribute('focusable')).toBe('false');
    const clip = heart.querySelector('clipPath');
    expect(heart.querySelector('.fav-heart-clip')).not.toBeNull();
    expect(heart.querySelector('.fav-heart-fill').getAttribute('clip-path')).toBe(`url(#${clip.id})`);
    expect(btn().querySelector('i')).toBeNull();
    expect(btn().querySelector('.fav-bin').getAttribute('aria-hidden')).toBe('true');
    expect(btn().textContent.trim()).toBe(''); // aucun libellé visible
    expect(swapState()).toBe('off');
    expect(label()).toBe('t:details.add_favorite');
    expect(btn().getAttribute('title')).toBe('t:details.add_favorite');
    expect(btn().getAttribute('aria-pressed')).toBe('false');
    expect(btn().classList.contains('favorited')).toBe(false);
  });

  test('favori : état « a », classe favorited, libellé « retirer »', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: true });
    expect(swapState()).toBe('on');
    expect(btn().classList.contains('favorited')).toBe(true);
    expect(label()).toBe('t:details.remove_favorite');
    expect(btn().getAttribute('aria-pressed')).toBe('true');
  });

  test('bascules successives : les icônes ne sont pas reconstruites (transition préservée)', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: false });
    const heart = btn().querySelector('.fav-heart');
    fav.updateFavoriteButton({ isFavorite: true });
    fav.updateFavoriteButton({ isFavorite: false });
    expect(btn().querySelector('.fav-heart')).toBe(heart);
    expect(swapState()).toBe('off');
    expect(btn().classList.contains('favorited')).toBe(false);
  });
});

describe('cœur — identifiant de découpe', () => {
  test('chaque cœur construit reçoit un clipPath d\'identifiant unique', () => {
    boot();
    fav.updateFavoriteButton({ isFavorite: false });
    const first = btn().querySelector('clipPath').id;
    btn().innerHTML = ''; // reconstruit : nouveau cœur, nouvel identifiant
    fav.updateFavoriteButton({ isFavorite: true });
    const second = btn().querySelector('clipPath').id;
    expect(second).not.toBe(first);
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
    expect(swapState()).toBe('on');
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
  test('setup : le cœur dessiné remplace l\'icône statique, même sans session', () => {
    boot({ token: null });
    fav.setup({ aircraftId: 30, isFavorite: false });
    expect(btn().querySelector('.fav-heart')).not.toBeNull();
    expect(btn().querySelector('i')).toBeNull();
  });

  test('langue pas encore chargée : le nom accessible du HTML est conservé', () => {
    boot();
    btn().setAttribute('aria-label', 'Ajouter aux favoris');
    global.i18n.t = (k) => k;
    fav.updateFavoriteButton({ isFavorite: false });
    expect(label()).toBe('Ajouter aux favoris');
  });

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
    expect(swapState()).toBe('on');
    expect(btn().classList.contains('is-popping')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_added', 'success');
    btn().dispatchEvent(new Event('animationend'));
    expect(btn().classList.contains('is-popping')).toBe(false);
  });

  test('retrait : le clic ouvre la confirmation sur place, rien n\'est envoyé', async () => {
    const authFetch = jest.fn(() => jsonResponse({}));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: true };
    fav.setup(state);
    fav.updateFavoriteButton(state);
    btn().click();
    await flush();
    expect(authFetch).not.toHaveBeenCalled();
    expect(wrap().classList.contains('det-fav')).toBe(true);
    expect(wrap().dataset.state).toBe('confirm');
    expect(document.activeElement).toBe(wrap().querySelector('.cfm-no'));
    expect(wrap().querySelector('.cfm-yes').getAttribute('aria-label')).toBe('t:favorites.remove_confirm');
  });

  test('retrait confirmé : DELETE, cœur vide, contrôle au repos, toast « retiré »', async () => {
    const authFetch = jest.fn(() => jsonResponse({}));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: true };
    fav.setup(state);
    fav.updateFavoriteButton(state);
    btn().click();
    wrap().querySelector('.cfm-yes').click();
    await flush();
    expect(authFetch).toHaveBeenCalledWith('/api/favorites/30', { method: 'DELETE' });
    expect(state.isFavorite).toBe(false);
    expect(swapState()).toBe('off');
    expect(wrap().dataset.state).toBe('idle');
    expect(btn().classList.contains('is-popping')).toBe(false);
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_removed', 'success');
    expect(document.activeElement).toBe(btn());
  });

  test('retrait annulé (✗) : rien n\'est envoyé, le cœur reste plein', async () => {
    const authFetch = jest.fn(() => jsonResponse({}));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: true };
    fav.setup(state);
    fav.updateFavoriteButton(state);
    btn().click();
    wrap().querySelector('.cfm-no').click();
    await flush();
    expect(authFetch).not.toHaveBeenCalled();
    expect(state.isFavorite).toBe(true);
    expect(wrap().dataset.state).toBe('idle');
  });

  test('retrait en erreur : contrôle remis au repos, favori conservé, toast d\'erreur', async () => {
    const authFetch = jest.fn(() => jsonResponse({}, false, 500));
    boot({ authFetch });
    const state = { aircraftId: 30, isFavorite: true };
    fav.setup(state);
    fav.updateFavoriteButton(state);
    btn().click();
    wrap().querySelector('.cfm-yes').click();
    await flush();
    expect(state.isFavorite).toBe(true);
    expect(swapState()).toBe('on');
    expect(wrap().dataset.state).toBe('idle');
    expect(showToast).toHaveBeenCalledWith('t:common.favorite_error', 'error');
    expect(btn().disabled).toBe(false);
  });

  test('ajout : aucun panneau de confirmation', async () => {
    boot();
    const state = { aircraftId: 30, isFavorite: false };
    fav.setup(state);
    btn().click();
    expect(wrap().dataset.state).toBe('idle');
    await flush();
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
