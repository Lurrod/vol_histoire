/* Visionneuse de la photo de la fiche (2026-11-19).
 *
 * Un bouton couvre la photo du hero (curseur loupe) : la photo s'agrandit
 * en plein écran depuis sa place (VH.viewMorph : même nom vh-zoom avant et
 * après, shared-morph.css), avec son crédit ; la fermeture (croix, Échap,
 * clic hors de la photo) la ramène à sa place. Sans l'API View
 * Transitions ou en mouvement réduit : fondu d'entrée et VH.motion.exit.
 * Bouton masqué tant que le hero ne montre pas une vraie photo
 * (image d'attente, illustration de remplacement). */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  const NAME = 'vh-zoom';

  function t(key, fallback) {
    const v = window.i18n && typeof window.i18n.t === 'function' ? window.i18n.t(key) : key;
    return v && v !== key ? v : fallback;
  }

  function canMorph() {
    return typeof document.startViewTransition === 'function' &&
      !(VH.motion && VH.motion.prefersReducedMotion());
  }

  /** Vraie photo affichée (ni l'image d'attente, ni l'illustration). */
  function isRealPhoto(img) {
    const src = img.currentSrc || img.getAttribute('src') || '';
    return !!src && !/^data:/.test(src) && !/placeholder-airplane/.test(src) && img.naturalWidth > 0;
  }

  function buildDialog() {
    const dlg = document.createElement('dialog');
    dlg.className = 'det-zoom';
    dlg.innerHTML =
      '<figure class="det-zoom-figure"><img class="det-zoom-img" alt="" decoding="async">' +
      '<figcaption class="det-zoom-credit"></figcaption></figure>' +
      '<button type="button" class="det-zoom-close"><i class="fas fa-times" aria-hidden="true"></i></button>';
    document.body.appendChild(dlg);
    return dlg;
  }

  /**
   * @param {{ heroImg?: HTMLImageElement|null, frame?: Element|null }} [opts]
   * @returns {{ open: () => Promise<void>, close: () => void }|null}
   */
  function setup(opts) {
    const o = opts || {};
    const heroImg = o.heroImg || document.getElementById('hero-image');
    const frame = o.frame || (heroImg && heroImg.closest('.aircraft-image-container'));
    if (!heroImg || !frame || frame.querySelector('.det-zoom-btn')) return null;

    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'det-zoom-btn';
    btn.hidden = true;
    // Quatre coins qui s'écartent au survol (details.css).
    btn.innerHTML = '<span class="det-zoom-hint"><svg class="det-zoom-ico" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
      '<path class="dz-c dz-tl" d="M4 9V4h5"/><path class="dz-c dz-tr" d="M15 4h5v5"/>' +
      '<path class="dz-c dz-br" d="M20 15v5h-5"/><path class="dz-c dz-bl" d="M9 20H4v-5"/></svg></span>';
    frame.appendChild(btn);

    let dlg = null;
    let busy = false;
    let cancelExit = null;

    function labels() {
      btn.setAttribute('aria-label', t('details.photo_zoom', 'Agrandir la photo'));
      if (!dlg) return;
      dlg.setAttribute('aria-label', heroImg.alt || t('details.photo_zoom', 'Agrandir la photo'));
      dlg.querySelector('.det-zoom-close').setAttribute('aria-label', t('common.close', 'Fermer'));
    }

    function refresh() {
      btn.hidden = !isRealPhoto(heroImg);
      labels();
    }

    function morph(update, done) {
      busy = true;
      const vt = document.startViewTransition(update);
      vt.finished.catch(() => {}).then(() => {
        busy = false;
        if (done) done();
      });
    }

    async function open() {
      if (busy || btn.hidden) return;
      if (!dlg) {
        dlg = buildDialog();
        dlg.addEventListener('cancel', (e) => { e.preventDefault(); close(); });
        dlg.addEventListener('click', (e) => { if (!e.target.closest('.det-zoom-img')) close(); });
        labels();
      }
      if (cancelExit) { cancelExit(); cancelExit = null; }
      const img = dlg.querySelector('.det-zoom-img');
      img.src = heroImg.currentSrc || heroImg.src;
      img.alt = heroImg.alt || '';
      const credit = document.getElementById('image-credit');
      const cap = dlg.querySelector('.det-zoom-credit');
      cap.textContent = credit && !credit.hidden ? credit.textContent.trim() : '';
      cap.hidden = !cap.textContent;
      // Image déjà en cache (c'est celle du hero) : décodée avant la
      // capture, sinon la transition s'ouvrirait sur un cadre vide.
      try { await img.decode(); } catch { /* décodage refusé : affichage normal */ }

      if (!canMorph()) {
        dlg.classList.remove('is-morph');
        dlg.showModal();
        return;
      }
      dlg.classList.add('is-morph');
      heroImg.style.viewTransitionName = NAME;
      morph(() => {
        heroImg.style.viewTransitionName = '';
        img.style.viewTransitionName = NAME;
        dlg.showModal();
      }, () => { img.style.viewTransitionName = ''; });
    }

    function close() {
      // Sortie déjà en cours : une seconde fermeture laisserait une minuterie orpheline.
      if (!dlg || !dlg.open || busy || cancelExit) return;
      const img = dlg.querySelector('.det-zoom-img');
      if (!canMorph()) {
        cancelExit = VH.motion.exit(dlg, () => { cancelExit = null; dlg.close(); }, { className: 'is-closing' });
        return;
      }
      img.style.viewTransitionName = NAME;
      morph(() => {
        img.style.viewTransitionName = '';
        dlg.close();
        heroImg.style.viewTransitionName = NAME;
      }, () => { heroImg.style.viewTransitionName = ''; });
    }

    btn.addEventListener('click', open);
    heroImg.addEventListener('load', refresh);
    window.addEventListener('langChanged', labels);
    if (heroImg.complete) refresh();
    else labels();

    return { open, close };
  }

  VH.details.photoZoom = { setup, isRealPhoto };
  if (typeof module !== 'undefined' && module.exports) module.exports = VH.details.photoZoom;
})();
