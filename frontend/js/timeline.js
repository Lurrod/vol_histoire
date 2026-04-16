/* Vol d'Histoire — Timeline cinematic
   Scroll-driven narrative: hero → decade chapters → outro.
*/
document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* =========================================================================
     ERA METADATA
     ========================================================================= */

  /* Couleurs des décennies (stable) ; textes résolus via i18n à l'appel. */
  const ERA_COLORS = {
    1940: '#d4a017', 1950: '#3aff6e', 1960: '#ff8c00', 1970: '#ff4500',
    1980: '#C8A96E', 1990: '#7b5cf0', 2000: '#2979ff', 2010: '#e040fb', 2020: '#ff3d6e'
  };
  function getEra(decade) {
    return {
      color: ERA_COLORS[decade] || 'var(--hud-cyan)',
      label: i18n.t(`timeline.era_${decade}_label2`),
      title: i18n.t(`timeline.era_${decade}_title2`),
      desc:  i18n.t(`timeline.era_${decade}_desc2`),
    };
  }

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

  function splitWords(text) {
    return text.split(/(\s+)/).map((part, i) => {
      if (/^\s+$/.test(part)) return part;
      return `<span class="tl-split-word" data-i="${i}">${escapeHtml(part)}</span>`;
    }).join('');
  }

  // Applique les custom properties CSS (--i, --era-color, --era-bg) après
  // insertion DOM pour éviter style="..." en attribut (interdit par CSP).
  function applyTimelineCssVars(root) {
    root.querySelectorAll('.tl-split-word[data-i]').forEach(el => {
      el.style.setProperty('--i', el.dataset.i);
    });
    root.querySelectorAll('.tl-chapter[data-era-color]').forEach(el => {
      el.style.setProperty('--era-color', el.dataset.eraColor);
      if (el.dataset.eraBg) el.style.setProperty('--era-bg', `url('${el.dataset.eraBg}')`);
    });
  }

  function renderChapters(chapters) {
    const root = document.getElementById('tl-chapters');
    root.innerHTML = chapters.map(ch => {
      const era = getEra(ch.decade);
      const countries = new Set(ch.items.map(a => a.country_name_fr || a.country_name).filter(Boolean));
      const gens = new Set(ch.items.map(a => a.generation).filter(Boolean));
      // Backdrop image: first aircraft with an image
      const backdropPlane = ch.items.find(a => a.image_url) || ch.items[0];
      const bgUrl = backdropPlane && backdropPlane.image_url ? backdropPlane.image_url : '';
      const bgAttr = bgUrl ? ` data-era-bg="${escapeAttr(bgUrl)}"` : '';
      return `
        <section class="tl-chapter" id="ch-${ch.decade}" data-decade="${ch.decade}" data-era-color="${escapeAttr(era.color)}"${bgAttr}>
          <div class="tl-chapter-backdrop" aria-hidden="true"></div>
          <div class="tl-chapter-inner">
            <aside class="tl-chapter-side">
              <div class="tl-decade-block">
                <span class="tl-decade-num">${ch.decade}</span>
                <span class="tl-decade-suffix">s</span>
              </div>
              <div class="tl-era-text">
                <span class="tl-era-label">${escapeHtml(era.label)}</span>
                <h2 class="tl-era-title tl-split">${splitWords(era.title)}</h2>
                <p class="tl-era-desc">${escapeHtml(era.desc)}</p>
                <div class="tl-era-meta">
                  <div>${i18n.t('timeline.meta_aircraft')}<strong>${ch.items.length}</strong></div>
                  <div>${i18n.t('timeline.meta_nations')}<strong>${countries.size}</strong></div>
                  <div>${i18n.t('timeline.meta_generations')}<strong>${[...gens].sort().join(' · ') || '—'}</strong></div>
                </div>
              </div>
            </aside>
            <div class="tl-chapter-main">
              <div class="tl-aircraft-grid">
                ${ch.items.map((p, i) => renderPlaneCard(p, i === 0)).join('')}
              </div>
            </div>
          </div>
        </section>
      `;
    }).join('');
    // Applique les custom properties CSS via DOM API (non bloquées par CSP)
    applyTimelineCssVars(root);
  }

  function escapeAttr(s) {
    return String(s || '').replace(/['"<>&]/g, c => ({
      "'": '&#39;', '"': '&quot;', '<': '&lt;', '>': '&gt;', '&': '&amp;'
    }[c]));
  }

  function renderPlaneCard(plane, isFeature) {
    const year = yearOf(plane) || '—';
    const gen = plane.generation ? `G${plane.generation}` : '';
    const country = plane.country_name || '';
    const img = plane.image_url || '';
    const speed = plane.max_speed ? `${plane.max_speed} km/h` : null;
    const range = plane.max_range ? `${plane.max_range} km` : null;
    const featureClass = isFeature ? ' feature' : '';
    return `
      <a class="tl-plane-card${featureClass}" href="${VH.shared.buildDetailsPath(plane.id, plane.name)}">
        <div class="tl-plane-img">
          ${img ? `<img src="${escapeAttr(img)}" alt="${escapeAttr(plane.name)}" loading="lazy">` : ''}
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
      const era = getEra(ch.decade);
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
          // Update year HUD + body tint on "dominant" chapter
          if (entry.intersectionRatio > 0.2) {
            yearNum.textContent = decade + 's';
            const era = getEra(decade);
            if (yearLbl) yearLbl.textContent = era.label || '';
            document.body.style.setProperty('--tl-active-era', era.color);
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
      // Clear tint while in hero
      if (!past) document.body.style.removeProperty('--tl-active-era');
    }, { threshold: 0 }).observe(intro);

    // Stagger reveal aircraft cards
    const cardObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
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

    // Split-text reveal on era titles
    const splitObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          splitObs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.4 });
    document.querySelectorAll('.tl-split').forEach(el => splitObs.observe(el));
  }

  /* =========================================================================
     AMBIENT PARTICLE FIELD (canvas)
     ========================================================================= */

  function initParticles() {
    const reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (reduce) return;
    const canvas = document.getElementById('tl-particles');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let width = 0, height = 0;
    const dpr = Math.min(window.devicePixelRatio || 1, 2);

    function resize() {
      width = window.innerWidth;
      height = window.innerHeight;
      canvas.width = Math.floor(width * dpr);
      canvas.height = Math.floor(height * dpr);
      canvas.style.width = width + 'px';
      canvas.style.height = height + 'px';
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }
    resize();
    window.addEventListener('resize', resize, { passive: true });

    const count = Math.min(80, Math.floor((width * height) / 22000));
    const particles = Array.from({ length: count }, () => ({
      x: Math.random() * width,
      y: Math.random() * height,
      r: Math.random() * 1.3 + 0.3,
      vx: (Math.random() - 0.5) * 0.12,
      vy: (Math.random() - 0.5) * 0.08,
      a: Math.random() * 0.35 + 0.15,
    }));

    function tick() {
      ctx.clearRect(0, 0, width, height);
      for (const p of particles) {
        p.x += p.vx;
        p.y += p.vy;
        if (p.x < -5) p.x = width + 5;
        if (p.x > width + 5) p.x = -5;
        if (p.y < -5) p.y = height + 5;
        if (p.y > height + 5) p.y = -5;
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(200, 169, 110, ${p.a})`;
        ctx.fill();
      }
      requestAnimationFrame(tick);
    }
    tick();
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

  document.body.classList.add('tl-has-cinematic');
  initParticles();

  try {
    const aircraft = await loadAllAircraft();
    if (aircraft.length === 0) {
      document.getElementById('tl-chapters').innerHTML =
        `<p class="tl-empty-msg">${i18n.t('timeline.no_aircraft')}</p>`;
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

    // Re-render chapters + minimap when language changes (les textes d'ère
    // proviennent d'i18n.t() et ne sont pas dans le DOM HTML d'origine).
    window.addEventListener('langChanged', () => {
      renderChapters(chapters);
      renderMinimap(chapters);
      observeChapters();
    });

    // Fade out loader
    requestAnimationFrame(() => {
      document.getElementById('tl-loading').classList.add('gone');
    });

  } catch (err) {
    document.getElementById('tl-loading').classList.add('gone');
    showToast(i18n.t('common.loading_error'), 'error');
  }
});
