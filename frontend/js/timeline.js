/* Vol d'Histoire — Timeline cinématographique « Le Journal de Bord »
   Récit scroll-driven : couverture → chapitre par décennie (title card +
   narratif éditorial + événements marquants + grille d'appareils) → générique.
   Données : GET /api/timeline (backend — cache Redis 30 min).
*/
document.addEventListener("DOMContentLoaded", async () => {
  await auth.init();

  /* =========================================================================
     MÉTADONNÉES D'ÈRE
     ========================================================================= */

  const ERA_COLORS = {
    1940: '#d4a017', 1950: '#3aff6e', 1960: '#ff8c00', 1970: '#ff4500',
    1980: '#C8A96E', 1990: '#7b5cf0', 2000: '#2979ff', 2010: '#e040fb', 2020: '#ff3d6e'
  };

  function currentLang() {
    return (window.i18n && window.i18n.currentLang) || 'fr';
  }

  function getEra(decade) {
    return {
      color: ERA_COLORS[decade] || 'var(--hud-cyan)',
      label: i18n.t(`timeline.era_${decade}_label2`),
      title: i18n.t(`timeline.era_${decade}_title2`),
      narrative: i18n.t(`timeline.era_${decade}_narrative`),
    };
  }

  function localized(obj, field) {
    const lang = currentLang();
    return obj[`${field}_${lang}`] || obj[`${field}_fr`] || obj[field] || '';
  }

  function fmtDate(dateStr) {
    if (!dateStr) return '';
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return '';
    const lang = currentLang();
    try {
      return d.toLocaleDateString(lang === 'en' ? 'en-US' : 'fr-FR',
        { day: 'numeric', month: 'long', year: 'numeric' });
    } catch {
      return d.toISOString().slice(0, 10);
    }
  }

  function escapeAttr(s) {
    return String(s || '').replace(/['"<>&]/g, c => ({
      "'": '&#39;', '"': '&quot;', '<': '&lt;', '>': '&gt;', '&': '&amp;'
    }[c]));
  }

  /* =========================================================================
     CHARGEMENT DONNÉES
     ========================================================================= */

  async function loadTimeline() {
    const r = await auth.fetchWithTimeout('/api/timeline');
    if (!r.ok) throw new Error('timeline fetch failed: ' + r.status);
    const payload = await r.json();
    const decades = Array.isArray(payload.decades) ? payload.decades : [];
    // Ne garde que les décennies avec événement ou appareil — évite les
    // chapitres vides en milieu de frise.
    return decades.filter(d => (d.events && d.events.length > 0) ||
                               (d.aircraft && d.aircraft.length > 0));
  }

  /* =========================================================================
     RENDU — CARTES D'APPAREIL
     ========================================================================= */

  function renderAircraftCard(a) {
    const year = a.date_operationel ? new Date(a.date_operationel).getFullYear() : '—';
    const lang = currentLang();
    const name = (lang === 'en' && a.name_en) ? a.name_en : a.name;
    const country = (lang === 'en' && a.country_name_en)
      ? a.country_name_en
      : (a.country_name || '');
    const img = a.image_url || '';
    const gen = a.generation ? `G${a.generation}` : '';
    return `
      <a class="tl-plane-card" href="${VH.shared.buildDetailsPath(a.id, a.name)}">
        <div class="tl-plane-img">
          ${img ? VH.shared.picture.pictureHtml(img, { alt: a.name, loading: 'lazy', width: '400', height: '300' }) : ''}
          <span class="tl-plane-year">${year}</span>
          ${gen ? `<span class="tl-plane-gen">${gen}</span>` : ''}
        </div>
        <div class="tl-plane-body">
          <h4 class="tl-plane-name">${escapeHtml(name)}</h4>
          <div class="tl-plane-country">${escapeHtml(country)}</div>
        </div>
      </a>
    `;
  }

  /* =========================================================================
     RENDU — ÉVÉNEMENTS ÉDITORIAUX
     ========================================================================= */

  function renderEventCard(ev, idx) {
    const kindKey = `timeline.kind_${ev.kind || 'milestone'}`;
    const kindLabel = i18n.t(kindKey);
    const title = localized(ev, 'title');
    const body = localized(ev, 'body');
    const author = localized(ev, 'quote_author');
    const dateStr = fmtDate(ev.event_date);
    const year = ev.event_date ? new Date(ev.event_date).getFullYear() : '';

    const airplane = ev.airplane;
    const airplaneCard = airplane ? `
      <a class="tl-event-plane" href="${VH.shared.buildDetailsPath(airplane.id, airplane.name)}">
        <div class="tl-event-plane-img">
          ${airplane.image_url ? VH.shared.picture.pictureHtml(airplane.image_url, { alt: airplane.name, loading: 'lazy', width: '320', height: '180' }) : ''}
        </div>
        <div class="tl-event-plane-body">
          <span class="tl-event-plane-name">${escapeHtml(airplane.name)}</span>
          <span class="tl-event-plane-cta">${i18n.t('timeline.event_read_more')} <i class="fas fa-arrow-right"></i></span>
        </div>
      </a>
    ` : '';

    return `
      <article class="tl-event tl-event-kind-${escapeAttr(ev.kind || 'milestone')}" data-idx="${idx}">
        <div class="tl-event-rail">
          <span class="tl-event-year">${escapeHtml(String(year))}</span>
          <span class="tl-event-kind">${escapeHtml(kindLabel)}</span>
          <span class="tl-event-date">${escapeHtml(dateStr)}</span>
        </div>
        <div class="tl-event-body">
          <h3 class="tl-event-title">${escapeHtml(title)}</h3>
          <p class="tl-event-text">${escapeHtml(body)}</p>
          ${author ? `<cite class="tl-event-author">— ${escapeHtml(author)}</cite>` : ''}
          ${airplaneCard}
        </div>
      </article>
    `;
  }

  /* =========================================================================
     RENDU — CHAPITRES PAR DÉCENNIE
     ========================================================================= */

  function renderChapters(decades) {
    const root = document.getElementById('tl-chapters');
    if (!root) return;
    root.innerHTML = decades.map((bucket, idx) => {
      const dec = bucket.decade;
      const era = getEra(dec);
      const chapterNum = String(idx + 1).padStart(2, '0');
      const events = bucket.events || [];
      const aircraft = bucket.aircraft || [];

      return `
        <section class="tl-chapter" id="ch-${dec}" data-decade="${dec}" data-era-color="${escapeAttr(era.color)}">
          <div class="tl-chapter-tint" aria-hidden="true"></div>

          <header class="tl-title-card">
            <div class="tl-title-card-inner">
              <div class="tl-title-meta">
                <span class="tl-title-chapter">${escapeHtml(i18n.t('timeline.chapter_label'))} · ${chapterNum}</span>
                <span class="tl-title-span">${dec}–${dec + 9}</span>
              </div>
              <div class="tl-title-decade">
                <span class="tl-title-decade-num">${dec}</span>
                <span class="tl-title-decade-suffix">s</span>
              </div>
              <span class="tl-title-label">${escapeHtml(era.label)}</span>
              <h2 class="tl-title-era">${escapeHtml(era.title)}</h2>
            </div>
          </header>

          <div class="tl-narrative">
            <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_narrative_label'))}</span>
            <p class="tl-narrative-text">${escapeHtml(era.narrative)}</p>
          </div>

          ${events.length > 0 ? `
            <div class="tl-events">
              <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_events_label'))} · <strong>${events.length}</strong></span>
              <div class="tl-events-list">
                ${events.map(renderEventCard).join('')}
              </div>
            </div>
          ` : ''}

          ${aircraft.length > 0 ? `
            <div class="tl-aircraft-section">
              <span class="tl-section-label">${escapeHtml(i18n.t('timeline.chapter_aircraft_label'))} · <strong>${aircraft.length}</strong></span>
              <div class="tl-aircraft-grid">
                ${aircraft.map(renderAircraftCard).join('')}
              </div>
            </div>
          ` : ''}
        </section>
      `;
    }).join('');

    applyTimelineCssVars(root);
  }

  function applyTimelineCssVars(root) {
    root.querySelectorAll('.tl-chapter[data-era-color]').forEach(el => {
      el.style.setProperty('--era-color', el.dataset.eraColor);
    });
  }

  /* =========================================================================
     MINIMAP
     ========================================================================= */

  function renderMinimap(decades) {
    const mm = document.getElementById('tl-minimap');
    if (!mm) return;
    mm.innerHTML = decades.map(b => `
      <button class="tl-mm-btn" data-target="ch-${b.decade}" aria-label="${b.decade}s">
        <span class="tl-mm-label">${b.decade}s</span>
        <span class="tl-mm-tick"></span>
      </button>
    `).join('');
    mm.querySelectorAll('.tl-mm-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        const target = document.getElementById(btn.dataset.target);
        if (!target) return;
        const decade = Number(target.dataset.decade);
        mm.querySelectorAll('.tl-mm-btn').forEach(b => b.classList.toggle('active', b === btn));
        const era = getEra(decade);
        const yearNum = document.getElementById('tl-year-hud-num');
        const yearLbl = document.getElementById('tl-year-hud-label');
        if (yearNum) yearNum.textContent = decade + 's';
        if (yearLbl) yearLbl.textContent = era.label || '';
        document.body.style.setProperty('--tl-active-era', era.color);
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

    // Ancre verticale à 35 % de la hauteur d'écran : robuste sur grands chapitres
    function updateActive() {
      const anchor = window.innerHeight * 0.35;
      let dominant = null;
      let bestDistance = Infinity;
      document.querySelectorAll('.tl-chapter').forEach(section => {
        const rect = section.getBoundingClientRect();
        if (rect.top <= anchor && rect.bottom >= anchor) {
          const distance = Math.abs(rect.top + rect.height / 2 - anchor);
          if (distance < bestDistance) {
            bestDistance = distance;
            dominant = section;
          }
        }
      });
      if (dominant) {
        dominant.classList.add('in-view');
        const decade = Number(dominant.dataset.decade);
        const era = getEra(decade);
        if (yearNum) yearNum.textContent = decade + 's';
        if (yearLbl) yearLbl.textContent = era.label || '';
        document.body.style.setProperty('--tl-active-era', era.color);
        mmButtons.forEach(b => b.classList.toggle('active', b.dataset.target === `ch-${decade}`));
      }
    }

    let ticking = false;
    window.addEventListener('scroll', () => {
      if (!ticking) {
        requestAnimationFrame(() => { updateActive(); ticking = false; });
        ticking = true;
      }
    }, { passive: true });
    updateActive();

    // Chapter in-view pour animation (backdrop / tint)
    const io = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) entry.target.classList.add('in-view');
      });
    }, { threshold: 0.05 });
    document.querySelectorAll('.tl-chapter').forEach(c => io.observe(c));

    // Affichage HUD + minimap après la couverture
    const intro = document.getElementById('tl-intro');
    if (intro && yearHud) {
      new IntersectionObserver(entries => {
        const past = !entries[0].isIntersecting;
        yearHud.classList.toggle('visible', past);
        const mm = document.getElementById('tl-minimap');
        if (mm) mm.classList.toggle('visible', past);
        if (!past) document.body.style.removeProperty('--tl-active-era');
      }, { threshold: 0 }).observe(intro);
    }

    // Reveal staggered des cartes + événements
    const cardObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const card = entry.target;
          const siblings = Array.from(card.parentElement.children);
          const delay = (siblings.indexOf(card) % 6) * 80;
          card.style.animationDelay = `${delay}ms`;
          card.classList.add('reveal');
          cardObs.unobserve(card);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
    document.querySelectorAll('.tl-plane-card, .tl-event').forEach(c => cardObs.observe(c));

    // Narrative fade-in
    const narrObs = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('reveal');
          narrObs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.25 });
    document.querySelectorAll('.tl-narrative, .tl-title-card').forEach(el => narrObs.observe(el));
  }

  /* =========================================================================
     PARTICULES D'AMBIANCE
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
     SCROLL PROGRESS
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
      if (!ticking) { requestAnimationFrame(update); ticking = true; }
    }, { passive: true });
    update();
  }

  /* =========================================================================
     CLAVIER — navigation chapitre par chapitre
     ========================================================================= */

  function initKeyboard(decades) {
    const ids = decades.map(c => c.decade);
    function currentIdx() {
      const scrollY = window.pageYOffset + window.innerHeight / 2;
      for (let i = ids.length - 1; i >= 0; i--) {
        const el = document.getElementById('ch-' + ids[i]);
        if (el && el.offsetTop <= scrollY) return i;
      }
      return 0;
    }
    function jumpTo(idx) {
      const i = Math.max(0, Math.min(ids.length - 1, idx));
      const el = document.getElementById('ch-' + ids[i]);
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
        jumpTo(ids.length - 1);
      }
    });
  }

  /* =========================================================================
     COMPTEURS
     ========================================================================= */

  function animateCounter(el, target, duration = 1500) {
    if (!el) return;
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      el.textContent = String(target);
      return;
    }
    const start = performance.now();
    function frame(now) {
      const t = Math.min(1, (now - start) / duration);
      const eased = 1 - Math.pow(1 - t, 3);
      el.textContent = Math.round(target * eased);
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  /* =========================================================================
     INIT
     ========================================================================= */

  document.body.classList.add('tl-has-cinematic');
  initParticles();

  let decades = [];

  try {
    decades = await loadTimeline();

    if (!decades.length) {
      const root = document.getElementById('tl-chapters');
      if (root) root.innerHTML = `<p class="tl-empty-msg">${escapeHtml(i18n.t('timeline.no_aircraft') || '—')}</p>`;
      document.getElementById('tl-loading')?.classList.add('gone');
      return;
    }

    renderChapters(decades);
    renderMinimap(decades);

    // Totaux stats
    const totalEvents = decades.reduce((s, b) => s + (b.events?.length || 0), 0);
    const totalAircraft = decades.reduce((s, b) => s + (b.aircraft?.length || 0), 0);
    animateCounter(document.getElementById('tl-stat-events'), totalEvents);
    animateCounter(document.getElementById('tl-stat-aircraft'), totalAircraft);
    animateCounter(document.getElementById('tl-stat-decades'), decades.length);

    observeChapters();
    initProgress();
    initKeyboard(decades);

    // Re-render sur changement de langue — textes d'ère/événements proviennent d'i18n
    window.addEventListener('langChanged', () => {
      renderChapters(decades);
      renderMinimap(decades);
      observeChapters();
    });

    requestAnimationFrame(() => {
      document.getElementById('tl-loading')?.classList.add('gone');
    });

  } catch {
    document.getElementById('tl-loading')?.classList.add('gone');
    const root = document.getElementById('tl-chapters');
    if (root) {
      root.innerHTML = `<p class="tl-empty-msg">${escapeHtml(i18n.t('common.loading_error') || 'Erreur de chargement.')}</p>`;
    }
    if (typeof showToast === 'function') {
      showToast(i18n.t('common.loading_error'), 'error');
    }
  }
});
