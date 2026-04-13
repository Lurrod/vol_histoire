/* ======================================================================
   VOL D'HISTOIRE — ONBOARDING CINÉMATIQUE
   Expérience immersive plein écran, style HUD militaire.
   4 slides avec transitions, particules, scan-lines.
   ====================================================================== */
(function () {
  'use strict';

  var STORAGE_KEY = 'vh-onboarding-done';

  function shouldShow() {
    if (localStorage.getItem(STORAGE_KEY)) return false;
    if (window.location.pathname !== '/') return false;
    if (typeof auth === 'undefined' || !auth.getToken || !auth.getToken()) return false;
    return true;
  }

  function t(key, fallback) {
    return (typeof i18n !== 'undefined' && i18n.t) ? i18n.t(key) : fallback;
  }

  function createTour() {
    var userName = '';
    try {
      var payload = auth.getPayload();
      if (payload && payload.name) userName = payload.name;
    } catch (_) {}

    var steps = [
      {
        icon: 'fa-satellite-dish',
        badge: t('onboarding.step1_badge', 'TRANSMISSION ENTRANTE'),
        title: t('onboarding.step1_title', 'Bienvenue à bord' + (userName ? ', ' + userName : '') + '.'),
        desc: t('onboarding.step1_desc', 'Votre accès est confirmé. Voici un briefing rapide avant votre première mission.'),
        accent: '#C8A96E',
      },
      {
        icon: 'fa-jet-fighter',
        badge: t('onboarding.step2_badge', 'MODULE 01 — HANGAR'),
        title: t('onboarding.step2_title', 'Le Hangar'),
        desc: t('onboarding.step2_desc', 'Plus de 50 fiches d\'avions de chasse. Filtrez par pays, génération, type. Chaque appareil a ses specs, son armement, son histoire.'),
        accent: '#C8A96E',
      },
      {
        icon: 'fa-crosshairs',
        badge: t('onboarding.step3_badge', 'MODULE 02 — FAVORIS'),
        title: t('onboarding.step3_title', 'Vos Favoris'),
        desc: t('onboarding.step3_desc', 'Un clic sur le cœur sauvegarde un appareil dans votre collection. Retrouvez-les à tout moment dans l\'onglet Favoris.'),
        accent: '#C8A96E',
      },
      {
        icon: 'fa-bullseye',
        badge: t('onboarding.step4_badge', 'MODULE 03 — CHRONOLOGIE'),
        title: t('onboarding.step4_title', 'La Chronologie'),
        desc: t('onboarding.step4_desc', '75 ans d\'aviation militaire. Une frise interactive pour traverser les générations, des premiers jets à la 5e génération.'),
        accent: '#C8A96E',
      },
    ];

    // ── Build DOM ──────────────────────────────────────────────────────
    var overlay = document.createElement('div');
    overlay.className = 'ob';
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-modal', 'true');
    overlay.setAttribute('aria-label', t('onboarding.aria_label', 'Briefing de bienvenue'));

    overlay.innerHTML =
      '<div class="ob-scanlines"></div>' +
      '<div class="ob-grid"></div>' +
      '<div class="ob-vignette"></div>' +
      '<div class="ob-hud-tl"></div><div class="ob-hud-tr"></div>' +
      '<div class="ob-hud-bl"></div><div class="ob-hud-br"></div>' +
      '<div class="ob-content">' +
        '<div class="ob-counter"></div>' +
        '<div class="ob-badge"></div>' +
        '<div class="ob-icon-ring"><i class="fas"></i></div>' +
        '<h2 class="ob-title"></h2>' +
        '<p class="ob-desc"></p>' +
        '<div class="ob-progress"></div>' +
        '<div class="ob-actions"></div>' +
      '</div>';

    var content = overlay.querySelector('.ob-content');
    var counterEl = overlay.querySelector('.ob-counter');
    var badgeEl = overlay.querySelector('.ob-badge');
    var iconEl = overlay.querySelector('.ob-icon-ring i');
    var titleEl = overlay.querySelector('.ob-title');
    var descEl = overlay.querySelector('.ob-desc');
    var progressEl = overlay.querySelector('.ob-progress');
    var actionsEl = overlay.querySelector('.ob-actions');

    var current = 0;
    var transitioning = false;

    function render(direction) {
      if (transitioning) return;
      transitioning = true;

      var step = steps[current];
      var isLast = current === steps.length - 1;
      var isFirst = current === 0;

      // Transition out
      content.classList.add('ob-fade-out');

      setTimeout(function () {
        counterEl.textContent = (current + 1) + ' / ' + steps.length;
        badgeEl.innerHTML = '<span class="ob-badge-pulse"></span><i class="fas fa-tower-broadcast"></i> ' + escapeHtml(step.badge);
        iconEl.className = 'fas ' + step.icon;
        titleEl.textContent = step.title;
        descEl.textContent = step.desc;

        // Progress bar
        progressEl.innerHTML = steps.map(function (_, i) {
          return '<div class="ob-bar' + (i < current ? ' done' : '') + (i === current ? ' active' : '') + '"></div>';
        }).join('');

        // Actions
        var html = '';
        if (isFirst) {
          html += '<button class="ob-btn ob-skip">' + t('onboarding.skip', 'Passer le briefing') + '</button>';
        } else {
          html += '<button class="ob-btn ob-prev"><i class="fas fa-chevron-left"></i> ' + t('onboarding.prev', 'Précédent') + '</button>';
        }
        if (isLast) {
          html += '<button class="ob-btn ob-primary ob-finish"><i class="fas fa-paper-plane"></i> ' + t('onboarding.finish', 'Commencer l\'exploration') + '</button>';
        } else {
          html += '<button class="ob-btn ob-primary ob-next">' + t('onboarding.next', 'Suivant') + ' <i class="fas fa-chevron-right"></i></button>';
        }
        actionsEl.innerHTML = html;

        // Bind
        var skip = actionsEl.querySelector('.ob-skip');
        var prev = actionsEl.querySelector('.ob-prev');
        var next = actionsEl.querySelector('.ob-next');
        var finish = actionsEl.querySelector('.ob-finish');
        if (skip) skip.addEventListener('click', close);
        if (prev) prev.addEventListener('click', function () { current--; render('prev'); });
        if (next) next.addEventListener('click', function () { current++; render('next'); });
        if (finish) finish.addEventListener('click', close);

        content.classList.remove('ob-fade-out');
        content.classList.add('ob-fade-in');
        setTimeout(function () {
          content.classList.remove('ob-fade-in');
          transitioning = false;
        }, 400);
      }, direction ? 250 : 0);
    }

    function close() {
      localStorage.setItem(STORAGE_KEY, '1');
      overlay.classList.add('ob-exit');
      setTimeout(function () { overlay.remove(); }, 600);
    }

    // Keyboard
    function onKey(e) {
      if (e.key === 'Escape') { close(); document.removeEventListener('keydown', onKey); }
      if (e.key === 'ArrowRight' && current < steps.length - 1) { current++; render('next'); }
      if (e.key === 'ArrowLeft' && current > 0) { current--; render('prev'); }
    }
    document.addEventListener('keydown', onKey);

    document.body.appendChild(overlay);
    render(null);

    // Enter animation
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { overlay.classList.add('ob-active'); });
    });
  }

  // Launch after auth + i18n are ready
  document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
      if (shouldShow()) createTour();
    }, 2000);
  });
})();
