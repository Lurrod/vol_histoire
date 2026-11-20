/* Écriture dans le ciel : un avion trace « 404 » avec sa traînée, qui se
 * diffuse ensuite comme une vraie traînée de condensation ; puis l'avion
 * sort du cadre. Un clic rejoue. Mouvements réduits : inscription posée,
 * sans avion. Position et orientation de l'avion : attribut transform ;
 * traînées : stroke-dashoffset en CSSOM (permis par la CSP). */
(function () {
  const DURATION = 4200;

  function reduced() {
    return !!(window.VH && VH.motion && VH.motion.prefersReducedMotion());
  }

  // Accélère au départ, file au milieu, ralentit à la sortie : un vol, pas un tracé de traceur.
  const ease = (t) => (t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2);

  function setup() {
    const sky = document.getElementById('e4-sky');
    if (!sky) return;
    const trails = Array.from(sky.querySelectorAll('.e4-trail'));
    const plane = document.getElementById('e4-plane');
    const lengths = trails.map((p) => p.getTotalLength());
    const total = lengths.reduce((a, b) => a + b, 0);
    let raf = 0;

    function pointAt(dist) {
      let d = dist;
      for (let i = 0; i < trails.length; i++) {
        if (d <= lengths[i] || i === trails.length - 1) return { i, d: Math.min(d, lengths[i]) };
        d -= lengths[i];
      }
      return { i: 0, d: 0 };
    }

    function draw(progress) {
      const dist = progress * total;
      let acc = 0;
      trails.forEach((p, i) => {
        const shown = Math.max(0, Math.min(lengths[i], dist - acc));
        p.style.strokeDasharray = `${lengths[i]} ${lengths[i]}`;
        p.style.strokeDashoffset = String(lengths[i] - shown);
        acc += lengths[i];
      });
      const { i, d } = pointAt(dist);
      const a = trails[i].getPointAtLength(Math.max(0, d - 0.5));
      const b = trails[i].getPointAtLength(Math.min(lengths[i], d + 0.5));
      const angle = Math.atan2(b.y - a.y, b.x - a.x) * 180 / Math.PI;
      plane.setAttribute('transform', `translate(${b.x.toFixed(1)} ${b.y.toFixed(1)}) rotate(${angle.toFixed(1)})`);
    }

    function finish() {
      draw(1);
      sky.classList.remove('is-flying');
      sky.classList.add('is-done');
    }

    function play() {
      cancelAnimationFrame(raf);
      sky.classList.remove('is-done');
      if (reduced()) { finish(); return; }
      sky.classList.add('is-flying');
      const start = performance.now();
      const step = (now) => {
        const t = Math.min(1, (now - start) / DURATION);
        draw(ease(t));
        if (t < 1) raf = requestAnimationFrame(step);
        else finish();
      };
      draw(0);
      raf = requestAnimationFrame(step);
    }

    sky.addEventListener('click', play);
    // Laisse la page s'installer avant le décollage.
    setTimeout(play, 350);
  }

  document.addEventListener('DOMContentLoaded', setup);
})();
