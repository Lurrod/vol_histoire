/* Frise — effets d'ambiance : particules, barre de progression, compteurs.
 * Particules et compteurs s'effacent devant prefers-reduced-motion. */
(function () {
  window.VH = window.VH || {};
  window.VH.timeline = window.VH.timeline || {};

  const MAX_PARTICLES = 80;
  const PX_PER_PARTICLE = 22000;
  const WRAP_MARGIN = 5;
  const PARTICLE_RGB = '200, 169, 110';

  /* =========================================================================
     PARTICULES D'AMBIANCE
     ========================================================================= */

  function particleCount(width, height) {
    return Math.min(MAX_PARTICLES, Math.floor((width * height) / PX_PER_PARTICLE));
  }

  function makeParticles(count, width, height, rand) {
    return Array.from({ length: count }, () => ({
      x: rand() * width,
      y: rand() * height,
      r: rand() * 1.3 + 0.3,
      vx: (rand() - 0.5) * 0.12,
      vy: (rand() - 0.5) * 0.08,
      a: rand() * 0.35 + 0.15,
    }));
  }

  /* Avance une particule ; elle réapparaît du côté opposé en sortant du cadre. */
  function stepParticle(p, width, height) {
    p.x += p.vx;
    p.y += p.vy;
    if (p.x < -WRAP_MARGIN) p.x = width + WRAP_MARGIN;
    if (p.x > width + WRAP_MARGIN) p.x = -WRAP_MARGIN;
    if (p.y < -WRAP_MARGIN) p.y = height + WRAP_MARGIN;
    if (p.y > height + WRAP_MARGIN) p.y = -WRAP_MARGIN;
  }

  function sizeCanvas(canvas, ctx, view) {
    view.width = window.innerWidth;
    view.height = window.innerHeight;
    canvas.width = Math.floor(view.width * view.dpr);
    canvas.height = Math.floor(view.height * view.dpr);
    canvas.style.width = view.width + 'px';
    canvas.style.height = view.height + 'px';
    ctx.setTransform(view.dpr, 0, 0, view.dpr, 0, 0);
  }

  function drawFrame(ctx, particles, view) {
    ctx.clearRect(0, 0, view.width, view.height);
    for (const p of particles) {
      stepParticle(p, view.width, view.height);
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${PARTICLE_RGB}, ${p.a})`;
      ctx.fill();
    }
  }

  function initParticles() {
    if (VH.timeline.util.prefersReducedMotion()) return;
    const canvas = document.getElementById('tl-particles');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const view = { width: 0, height: 0, dpr: Math.min(window.devicePixelRatio || 1, 2) };
    const resize = () => sizeCanvas(canvas, ctx, view);
    resize();
    window.addEventListener('resize', resize, { passive: true });

    const particles = makeParticles(particleCount(view.width, view.height), view.width, view.height, Math.random);
    function tick() {
      drawFrame(ctx, particles, view);
      requestAnimationFrame(tick);
    }
    tick();
  }

  /* =========================================================================
     SCROLL PROGRESS
     ========================================================================= */

  function scrollPercent(scrollTop, scrollHeight, clientHeight) {
    const max = scrollHeight - clientHeight;
    return max > 0 ? (scrollTop / max) * 100 : 0;
  }

  function initProgress() {
    const bar = document.getElementById('tl-progress');
    if (!bar) return;
    function update() {
      const h = document.documentElement;
      bar.style.width = scrollPercent(h.scrollTop, h.scrollHeight, h.clientHeight) + '%';
    }
    VH.timeline.util.onScrollFrame(update);
    update();
  }

  /* =========================================================================
     COMPTEURS
     ========================================================================= */

  function easeOutCubic(t) {
    return 1 - Math.pow(1 - t, 3);
  }

  function animateCounter(el, target, duration = 1500) {
    if (!el) return;
    if (VH.timeline.util.prefersReducedMotion()) {
      el.textContent = String(target);
      return;
    }
    const start = performance.now();
    function frame(now) {
      const t = Math.min(1, (now - start) / duration);
      el.textContent = Math.round(target * easeOutCubic(t));
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  const api = {
    particleCount,
    makeParticles,
    stepParticle,
    initParticles,
    scrollPercent,
    initProgress,
    easeOutCubic,
    animateCounter,
  };
  window.VH.timeline.effects = api;

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  }
})();
