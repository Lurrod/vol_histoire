/* Favori de la fiche : un cœur seul.
 * - Pas encore favori : un clic ajoute (POST), le cœur se remplit.
 * - Déjà favori : le retrait se confirme sur place, comme la poubelle des
 *   cartes de la page Favoris — le cœur devient poubelle (couvercle soulevé),
 *   « ✓ / ✗ » s'ouvrent à côté ; à la confirmation une coche se trace, puis
 *   le DELETE part et le cœur revient, vide (VH.confirmAction, details.css). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  async function checkFavoriteStatus(state) {
    if (!auth.getToken()) return;
    try {
      const response = await auth.authFetch(`/api/airplanes/${state.aircraftId}/favorite`);
      const data = await response.json();
      state.isFavorite = data.isFavorite;
      updateFavoriteButton(state);
    } catch { /* silencieux */ }
  }

  const HEART_PATH = 'M12 21s-7.5-4.6-9.5-9.2C1.1 8.6 3 5 6.6 5c2 0 3.7 1.1 5.4 3 1.7-1.9 3.4-3 5.4-3 3.6 0 5.5 3.6 4.1 6.8C19.5 16.4 12 21 12 21z';
  let heartUid = 0;

  // Cœur dessiné : le contour est fixe, le remplissage est un même cœur
  // découpé par un rectangle qui glisse de bas en haut (CSS, details.css).
  function heartSvg() {
    const id = 'fav-heart-clip-' + (++heartUid);
    return '<svg class="fav-heart" viewBox="0 0 24 24" data-state="off" aria-hidden="true" focusable="false">'
      + '<defs><clipPath id="' + id + '"><rect class="fav-heart-clip" x="0" y="0" width="24" height="24"/></clipPath></defs>'
      + '<path class="fav-heart-fill" clip-path="url(#' + id + ')" d="' + HEART_PATH + '"/>'
      + '<path class="fav-heart-line" d="' + HEART_PATH + '"/>'
      + '</svg>';
  }

  // Même poubelle que les cartes de favoris (shared/card.js) : couvercle,
  // cuve et coche, animés séparément.
  function binSvg() {
    return '<svg class="fav-bin" viewBox="0 0 24 24" aria-hidden="true" focusable="false">'
      + '<g class="fav-bin-lid"><path d="M4.5 7h15"/><path d="M9.5 7V5.2c0-.7.5-1.2 1.2-1.2h2.6c.7 0 1.2.5 1.2 1.2V7"/></g>'
      + '<g class="fav-bin-can"><path d="M6.5 7.5l.9 11.2c.1 1 .9 1.8 1.9 1.8h5.4c1 0 1.8-.8 1.9-1.8l.9-11.2"/><path d="M10.2 11v5.5M13.8 11v5.5"/></g>'
      + '<path class="fav-bin-check" d="M6.5 12.5l3.6 3.6 7.4-7.6"/>'
      + '</svg>';
  }

  function updateFavoriteButton(state) {
    const btn = document.getElementById('favorite-btn');
    if (!btn) return;
    // Le contenu n'est construit qu'une fois : on bascule data-state pour que
    // le remplissage monte ou redescende au lieu de reconstruire le bouton
    // (ce qui tuerait la transition).
    let heart = btn.querySelector('.fav-heart');
    if (!heart) {
      btn.innerHTML = '<span class="fav-icons">' + heartSvg() + binSvg() + '</span>';
      heart = btn.querySelector('.fav-heart');
    }
    const on = Boolean(state.isFavorite);
    btn.classList.toggle('favorited', on);
    heart.setAttribute('data-state', on ? 'on' : 'off');
    btn.setAttribute('aria-pressed', on ? 'true' : 'false');
    // Bouton sans texte : son nom passe par aria-label (et title au survol).
    // Langue pas encore chargée (i18n.t renvoie la clé) : on garde celui du
    // HTML plutôt que d'afficher « details.add_favorite ».
    const key = on ? 'details.remove_favorite' : 'details.add_favorite';
    const name = i18n.t(key);
    if (name !== key) {
      btn.setAttribute('aria-label', name);
      btn.setAttribute('title', name);
    }
  }

  function lock(btn) {
    btn.setAttribute('aria-busy', 'true');
    btn.disabled = true;
  }

  function unlock(btn) {
    btn.disabled = false;
    btn.removeAttribute('aria-busy');
  }

  async function addFavorite(state, btn) {
    lock(btn);
    try {
      const response = await auth.authFetch(`/api/favorites/${state.aircraftId}`, { method: 'POST' });
      if (!response.ok) throw new Error(i18n.t('common.favorite_error'));
      state.isFavorite = true;
      updateFavoriteButton(state);
      // Petit « pop » du cœur à l'ajout (classe retirée en fin d'animation)
      window.VH.motion.replay(btn, 'is-popping');
      btn.addEventListener('animationend', () => btn.classList.remove('is-popping'), { once: true });
      showToast(i18n.t('common.favorite_added'), 'success');
    } catch (error) {
      showToast(error.message, 'error');
    } finally {
      unlock(btn);
    }
  }

  async function removeFavorite(state, btn, control) {
    lock(btn);
    try {
      const response = await auth.authFetch(`/api/favorites/${state.aircraftId}`, { method: 'DELETE' });
      if (!response.ok) throw new Error(i18n.t('common.favorite_error'));
      state.isFavorite = false;
      updateFavoriteButton(state);
      showToast(i18n.t('common.favorite_removed'), 'success');
    } catch (error) {
      showToast(error.message, 'error');
    } finally {
      unlock(btn);
      // Retour au repos dans tous les cas : cœur vide après un retrait,
      // cœur plein (le favori reste) après un échec.
      control?.reset();
      btn.focus();
    }
  }

  function setup(state) {
    const btn = document.getElementById('favorite-btn');
    if (!btn) return;
    // Bouton bloqué pendant une requête : un double clic enverrait deux
    // requêtes contradictoires (ajout puis retrait).
    const busy = () => btn.getAttribute('aria-busy') === 'true';
    // Cœur dessiné dès l'arrivée, session ou non (sinon l'icône statique du
    // HTML resterait jusqu'à la réponse de l'API).
    updateFavoriteButton(state);
    const control = window.VH.confirmAction.arm(btn, {
      when: () => Boolean(state.isFavorite) && !busy(),
      className: 'det-fav',
      side: 'right',
      measure: '.fav-bin-check',
      labels: {
        group: () => i18n.t('favorites.remove_confirm_group'),
        confirm: () => i18n.t('favorites.remove_confirm'),
        cancel: () => i18n.t('favorites.remove_keep'),
      },
      onConfirm: () => removeFavorite(state, btn, control),
    });
    // Le retrait passe par la confirmation ci-dessus ; ce clic ne gère que
    // l'ajout (et l'invitation à se connecter).
    btn.addEventListener('click', () => {
      if (state.isFavorite || busy()) return;
      if (!auth.getToken()) {
        showToast(i18n.t('common.login_to_favorite'), 'info');
        setTimeout(() => window.location.href = '/login', 1500);
        return;
      }
      addFavorite(state, btn);
    });
  }

  VH.details.favorites = { checkFavoriteStatus, updateFavoriteButton, setup };
})();
