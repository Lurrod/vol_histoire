/* Paramètres — barre d'enregistrement flottante (2026-11-20).
 *
 * Les formulaires « à enregistrer » (profil, préférences de cookies) n'ont
 * plus de boutons permanents : dès qu'un formulaire diffère de ce qui est
 * enregistré, une barre monte en bas de l'écran — « Modifications non
 * enregistrées », Annuler (retour aux valeurs enregistrées), Enregistrer
 * (VH.busyButton : attente puis coche). Elle redescend une fois l'état
 * enregistré retrouvé.
 *
 * Chaque formulaire s'inscrit par register({ isDirty, save, reset }) :
 *   isDirty() → boolean ; save() → Promise<boolean> (true : tout est
 *   enregistré) ; reset() remet les valeurs enregistrées.
 * Puis appelle update() à chaque saisie.
 *
 * La barre se tient au-dessus du bandeau de consentement (comme celle du
 * comparateur) ; un message est lu par les lecteurs d'écran à son arrivée
 * (#save-bar-live) ; mouvements réduits : VH.motion.exit la masque aussitôt. */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  // Espace entre le bandeau de consentement et la barre.
  const BANNER_GAP_PX = 16;

  let owners = [];
  let els = null;
  let cancelLeave = null;
  let saving = false;

  function announce(text) {
    if (els && els.live) els.live.textContent = text || '';
  }

  function isShown() {
    return Boolean(els && !els.bar.hidden && !els.bar.classList.contains('is-leaving'));
  }

  /** Remonte la barre au-dessus du bandeau de consentement s'il est affiché. */
  function clearOfConsentBanner() {
    if (!els) return;
    const banner = document.querySelector('.cookie-banner.show');
    const offset = banner ? banner.getBoundingClientRect().height + BANNER_GAP_PX : 0;
    els.bar.style.setProperty('--savebar-offset', `${offset}px`);
  }

  function show() {
    if (!els || isShown()) return;
    if (cancelLeave) { cancelLeave(); cancelLeave = null; }
    els.bar.classList.remove('is-leaving');
    clearOfConsentBanner();
    els.bar.hidden = false;
    document.body.classList.add('has-save-bar');
    announce(VH.settings.ui.tr('settings.savebar_text', 'Modifications non enregistrées'));
  }

  function hide(message) {
    if (!els || els.bar.hidden || els.bar.classList.contains('is-leaving')) return;
    announce(message || '');
    let done = false;
    const cancel = window.VH.motion.exit(els.bar, () => {
      done = true;
      els.bar.hidden = true;
      document.body.classList.remove('has-save-bar');
      cancelLeave = null;
    }, { className: 'is-leaving' });
    if (!done) cancelLeave = cancel;
  }

  function dirtyOwners() {
    return owners.filter((o) => {
      try { return Boolean(o.isDirty()); } catch { return false; }
    });
  }

  /** Montre ou masque la barre selon l'état des formulaires inscrits. */
  function update() {
    if (saving) return;
    if (dirtyOwners().length) show();
    else hide();
  }

  /** Enregistre tous les formulaires modifiés.
   * @returns {Promise<boolean>} true si tout a été enregistré */
  async function save() {
    if (saving || !els) return false;
    const pending = dirtyOwners();
    if (!pending.length) return false;
    saving = true;
    const { tr } = VH.settings.ui;
    window.VH.busyButton.start(els.save);
    let ok = true;
    for (const owner of pending) {
      try {
        ok = (await owner.save()) === true && ok;
      } catch {
        ok = false;
      }
    }
    if (ok) await window.VH.busyButton.succeed(els.save, { label: tr('settings.btn_saved', 'Enregistré') });
    else window.VH.busyButton.stop(els.save);
    saving = false;
    if (!dirtyOwners().length) hide(ok ? tr('settings.savebar_saved', 'Modifications enregistrées') : '');
    return ok;
  }

  function cancel() {
    if (saving) return;
    dirtyOwners().forEach((o) => o.reset());
    hide(VH.settings.ui.tr('settings.savebar_cancelled', 'Modifications annulées'));
  }

  /** @param {{ isDirty: () => boolean, save: () => Promise<boolean>, reset: () => void }} owner */
  function register(owner) {
    if (owner && typeof owner.isDirty === 'function') owners = [...owners, owner];
    return owner;
  }

  function watchConsentBanner() {
    const banner = document.querySelector('.cookie-banner');
    if (!banner || typeof MutationObserver === 'undefined') return;
    new MutationObserver(clearOfConsentBanner).observe(banner, { attributes: true, attributeFilter: ['class'] });
  }

  function setup() {
    const bar = document.getElementById('save-bar');
    if (!bar) return;
    els = {
      bar,
      save: document.getElementById('save-bar-save'),
      cancel: document.getElementById('save-bar-cancel'),
      live: document.getElementById('save-bar-live'),
    };
    els.save?.addEventListener('click', () => { save(); });
    els.cancel?.addEventListener('click', cancel);
    watchConsentBanner();
  }

  /** Tests : oublie les formulaires inscrits et l'état. */
  function reset() {
    owners = [];
    els = null;
    cancelLeave = null;
    saving = false;
  }

  VH.settings.saveBar = { setup, register, update, save, cancel, isShown, clearOfConsentBanner, reset };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.saveBar;
  }
})();
