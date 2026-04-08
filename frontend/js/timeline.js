/* Vol d'Histoire — Timeline cinematic
   Scroll-driven narrative: hero → decade chapters → outro.
*/
document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* =========================================================================
     ERA METADATA
     ========================================================================= */

  const ERAS = {
    1940: { color: '#d4a017', label: 'Seconde Guerre mondiale', title: 'Les derniers moteurs à piston',
      desc: "Les dernières générations d'avions à hélice dominent les cieux. L'ère des Mustang, Spitfire et Zeros s'achève — les moteurs à piston atteignent leurs limites technologiques alors que le jet pointe son nez." },
    1950: { color: '#3aff6e', label: 'Guerre de Corée · Premiers jets', title: "L'arrivée du réacteur",
      desc: "La propulsion par réaction bouleverse l'aviation militaire. MiG-15 et F-86 Sabre se croisent dans le ciel de Corée dans les premiers combats entre avions à réaction de l'histoire. La course au Mach commence." },
    1960: { color: '#ff8c00', label: 'Guerre froide · Vitesse pure', title: 'La poursuite du Mach',
      desc: "L'ère des intercepteurs surpuissants. Mach 2 devient la norme, les missiles air-air remplacent progressivement les canons, et la doctrine privilégie la vitesse et l'altitude au détriment de la manœuvrabilité." },
    1970: { color: '#ff4500', label: 'Vietnam · Retour aux fondamentaux', title: "L'âge de la polyvalence",
      desc: "Les leçons du Vietnam forcent un retour à la manœuvrabilité et au combat rapproché. Naissance de la 4e génération : F-14, F-15, F-16, MiG-29, Su-27 — des machines conçues pour dominer dans tous les régimes de vol." },
    1980: { color: '#C8A96E', label: 'Haute technologie', title: 'L’avionique règne',
      desc: "Les radars à impulsion Doppler, les missiles BVR et les contre-mesures électroniques transforment le combat aérien. La furtivité fait son apparition avec le F-117 — un avion que personne n’est censé voir." },
    1990: { color: '#7b5cf0', label: 'Guerre du Golfe · Guerre électronique', title: 'La supériorité absolue',
      desc: "La guerre du Golfe démontre la suprématie occidentale. Les frappes de précision, la fusion de capteurs et la guerre électronique redéfinissent les règles. La 4.5e génération prolonge la vie des chasseurs existants." },
    2000: { color: '#2979ff', label: 'Ère stealth · 5e génération', title: 'Le retour de la furtivité',
      desc: "Le F-22 Raptor inaugure la cinquième génération : furtivité, supercroisière, avionique de fusion. Les conflits asymétriques et les opérations multi-rôles dominent. La supériorité aérienne se joue avant même le contact visuel." },
    2010: { color: '#e040fb', label: 'Guerre en réseau', title: 'La fusion de capteurs',
      desc: "F-35, J-20, Su-57 — les grandes puissances déploient leurs chasseurs de 5e génération. Les drones de combat, l'IA embarquée et la guerre en réseau redessinent le champ de bataille aérien." },
    2020: { color: '#ff3d6e', label: '6e génération · Future', title: 'Vers la sixième génération',
      desc: "NGAD, FCAS, Tempest : les grandes nations préparent leurs chasseurs de 6e génération. Drones loyal wingman, IA, armes à énergie dirigée, furtivité active — l'avenir du combat aérien se dessine maintenant." }
  };

  function getDecade(year) { return Math.floor(year / 10) * 10; }
  function yearOf(a) {
    const d = a.date_operationel || a.date_operational;
    if (!d) return null;
    const y = new Date(d).getFullYear();
    return isNaN(y) ? null : y;
  }

  /* =========================================================================
     LOAD ALL AIRCRAFT
     ========================================================================= */

  async function loadAllAircraft() {
    const p1 = await auth.fetchWithTimeout('/api/airplanes?sort=service-date&page=1');
    const p1Data = await p1.json();
    let aircraft = p1Data.data || [];
    const totalPages = p1Data.pagination?.totalPages || 1;
    if (totalPages > 1) {
      const rest = await Promise.all(
        Array.from({ length: totalPages - 1 }, (_, i) =>
          auth.fetchWithTimeout(`/api/airplanes?sort=service-date&page=${i + 2}`).then(r => r.json())
        )
      );
      rest.forEach(d => { aircraft = aircraft.concat(d.data || []); });
    }
    return aircraft
      .filter(a => yearOf(a) != null)
      .sort((a, b) => yearOf(a) - yearOf(b));
  }

  /* =========================================================================
     RENDER CHAPTERS
     ========================================================================= */

  function groupByDecade(list) {
    const byDec = {};
    list.forEach(a => {
      const y = yearOf(a);
      const d = getDecade(y);
      (byDec[d] = byDec[d] || []).push(a);
    });
    return Object.entries(byDec)
      .map(([d, items]) => ({ decade: Number(d), items }))
      .sort((a, b) => a.decade - b.decade);
  }

  function renderChapters(chapters) {
    const root = document.getElementById('tl-chapters');
    root.innerHTML = chapters.map(ch => {
      const era = ERAS[ch.decade] || { color: 'var(--hud-cyan)', label: '', title: '', desc: '' };
      const countries = new Set(ch.items.map(a => a.country_name_fr || a.country_name).filter(Boolean));
      const gens = new Set(ch.items.map(a => a.generation).filter(Boolean));
      return `
        <section class="tl-chapter" id="ch-${ch.decade}" data-decade="${ch.decade}" style="--era-color:${era.color}">
          <div class="tl-chapter-inner">
            <div class="tl-chapter-head">
              <div class="tl-decade-block">
                <span class="tl-decade-num">${ch.decade}</span>
                <span class="tl-decade-suffix">s</span>
              </div>
              <div class="tl-era-text">
                <span class="tl-era-label">${escapeHtml(era.label)}</span>
                <h2 class="tl-era-title">${escapeHtml(era.title)}</h2>
                <p class="tl-era-desc">${escapeHtml(era.desc)}</p>
                <div class="tl-era-meta">
                  <div>Appareils<strong>${ch.items.length}</strong></div>
                  <div>Nations<strong>${countries.size}</strong></div>
                  <div>Générations<strong>${[...gens].sort().join(' · ') || '—'}</strong></div>
                </div>
              </div>
            </div>
            <div class="tl-aircraft-grid">
              ${ch.items.map(renderPlaneCard).join('')}
            </div>
          </div>
        </section>
      `;
    }).join('');
  }

  function renderPlaneCard(plane) {
    const year = yearOf(plane) || '—';
    const gen = plane.generation ? `G${plane.generation}` : '';
    const country = plane.country_name || '';
    const img = plane.image_url || '';
    const speed = plane.max_speed ? `${plane.max_speed} km/h` : null;
    const range = plane.max_range ? `${plane.max_range} km` : null;
    return `
      <a class="tl-plane-card" href="/details?id=${encodeURIComponent(plane.id)}">
        <div class="tl-plane-img">
          ${img ? `<img src="${escapeHtml(img)}" alt="${escapeHtml(plane.name)}" loading="lazy">` : ''}
          <span class="tl-plane-year">${year}</span>
          ${gen ? `<span class="tl-plane-gen">${gen}</span>` : ''}
        </div>
        <div class="tl-plane-body">
          <h3 class="tl-plane-name">${escapeHtml(plane.name)}</h3>
          <div class="tl-plane-country">${escapeHtml(country)}</div>
          ${(speed || range) ? `<div class="tl-plane-specs">
            ${speed ? `<span><i class="fas fa-gauge-high"></i>${speed}</span>` : ''}
            ${range ? `<span><i class="fas fa-route"></i>${range}</span>` : ''}
          </div>` : ''}
        </div>
      </a>
    `;
  }

  /* =========================================================================
     MINIMAP
     ========================================================================= */

  function renderMinimap(chapters) {
    const mm = document.getElementById('tl-minimap');
    mm.innerHTML = chapters.map(ch => {
      const era = ERAS[ch.decade] || {};
      return `
        <button class="tl-mm-btn" data-target="ch-${ch.decade}" aria-label="${ch.decade}s">
          <span class="tl-mm-label">${ch.decade}s</span>
          <span class="tl-mm-tick"></span>
        </button>
      `;
    }).join('');
    mm.querySelectorAll('.tl-mm-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        const target = document.getElementById(btn.dataset.target);
        if (!target) return;
        const y = target.getBoundingClientRect().top + window.pageYOffset - 80;
        window.scrollTo({ top: y, behavior: 'smooth' });
      });
    });
  }

  /* =========================================================================
     SCROLL OBSERVERS
     ========================================================================= */

  function observeChapters() {
    const yearHud = document.getElementById('tl-year-hud');
    const yearNum = document.getElementById('tl-year-hud-num');
    const yearLbl = document.getElementById('tl-year-hud-label');
    const mmButtons = document.querySelectorAll('.tl-mm-btn');

    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        const section = entry.target;
        const decade = Number(section.dataset.decade);
        if (entry.isIntersecting) {
          section.classList.add('in-view');
          // Update year HUD
          if (entry.intersectionRatio > 0.2) {
            yearNum.textContent = decade + 's';
            const era = ERAS[decade];
            if (era && yearLbl) yearLbl.textContent = era.label || '';
            // Minimap active state
            mmButtons.forEach(b => b.classList.toggle('active', b.dataset.target === `ch-${decade}`));
          }
        }
      });
    }, { threshold: [0, 0.2, 0.5, 1], rootMargin: '-20% 0px -40% 0px' });

    document.querySelectorAll('.tl-chapter').forEach(c => observer.observe(c));

    // Show HUD + minimap once we're past the hero
    const intro = document.getElementById('tl-intro');
    new IntersectionObserver(entries => {
      const past = !entries[0].isIntersecting;
      yearHud.classList.toggle('visible', past);
      document.getElementById('tl-minimap').classList.toggle('visible', past);
    }, { threshold: 0 }).observe(intro);

    // Stagger reveal aircraft cards
    const cardObs = new IntersectionObserver(entries => {
      entries.forEach((entry, i) => {
        if (entry.isIntersecting) {
          const card = entry.target;
          const delay = (Array.from(card.parentElement.children).indexOf(card) % 6) * 80;
          card.style.animationDelay = `${delay}ms`;
          card.classList.add('reveal');
          cardObs.unobserve(card);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
    document.querySelectorAll('.tl-plane-card').forEach(c => cardObs.observe(c));
  }

  /* =========================================================================
     SCROLL PROGRESS BAR
     ========================================================================= */

  function initProgress() {
    const bar = document.getElementById('tl-progress');
    if (!bar) return;
    let ticking = false;
    function update() {
      const h = document.documentElement;
      const max = h.scrollHeight - h.clientHeight;
      const pct = max > 0 ? (h.scrollTop / max) * 100 : 0;
      bar.style.width = pct + '%';
      ticking = false;
    }
    window.addEventListener('scroll', () => {
      if (!ticking) {
        requestAnimationFrame(update);
        ticking = true;
      }
    }, { passive: true });
    update();
  }

  /* =========================================================================
     KEYBOARD NAV
     ========================================================================= */

  function initKeyboard(chapters) {
    const decades = chapters.map(c => c.decade);
    function currentIdx() {
      const scrollY = window.pageYOffset + window.innerHeight / 2;
      for (let i = decades.length - 1; i >= 0; i--) {
        const el = document.getElementById('ch-' + decades[i]);
        if (el && el.offsetTop <= scrollY) return i;
      }
      return 0;
    }
    function jumpTo(idx) {
      const i = Math.max(0, Math.min(decades.length - 1, idx));
      const el = document.getElementById('ch-' + decades[i]);
      if (!el) return;
      const y = el.getBoundingClientRect().top + window.pageYOffset - 80;
      window.scrollTo({ top: y, behavior: 'smooth' });
    }
    window.addEventListener('keydown', e => {
      if (e.target.matches('input, textarea, [contenteditable]')) return;
      if (e.key === 'ArrowDown' || e.key === 'PageDown' || e.key === ' ') {
        e.preventDefault();
        jumpTo(currentIdx() + 1);
      } else if (e.key === 'ArrowUp' || e.key === 'PageUp') {
        e.preventDefault();
        jumpTo(currentIdx() - 1);
      } else if (e.key === 'Home') {
        e.preventDefault();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      } else if (e.key === 'End') {
        e.preventDefault();
        jumpTo(decades.length - 1);
      }
    });
  }

  /* =========================================================================
     INTRO STATS (counter)
     ========================================================================= */

  function animateCounter(el, target, duration = 1500) {
    if (!el) return;
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      el.textContent = String(target);
      return;
    }
    const start = performance.now();
    const from = 0;
    function frame(now) {
      const t = Math.min(1, (now - start) / duration);
      const eased = 1 - Math.pow(1 - t, 3);
      el.textContent = Math.round(from + (target - from) * eased);
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  /* =========================================================================
     INIT
     ========================================================================= */

  try {
    const aircraft = await loadAllAircraft();
    if (aircraft.length === 0) {
      document.getElementById('tl-chapters').innerHTML =
        '<p style="text-align:center;padding:6rem;color:var(--text-secondary)">Aucun appareil avec une date opérationnelle.</p>';
      document.getElementById('tl-loading').classList.add('gone');
      return;
    }

    const chapters = groupByDecade(aircraft);
    renderChapters(chapters);
    renderMinimap(chapters);

    // Stats
    const years = aircraft.map(yearOf);
    const minYear = Math.min(...years);
    const maxYear = Math.max(...years);
    animateCounter(document.getElementById('tl-stat-aircraft'), aircraft.length);
    animateCounter(document.getElementById('tl-stat-years'), maxYear - minYear);
    animateCounter(document.getElementById('tl-stat-decades'), chapters.length);

    observeChapters();
    initProgress();
    initKeyboard(chapters);

    // Fade out loader
    requestAnimationFrame(() => {
      document.getElementById('tl-loading').classList.add('gone');
    });

  } catch (err) {
    document.getElementById('tl-loading').classList.add('gone');
    showToast(i18n.t('common.loading_error'), 'error');
  }
});
