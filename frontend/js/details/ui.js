/* UI divers : share-bar, mini-bar, scroll progress, PDF, animations, raccourcis. */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  // Lien dessiné : à la copie, les deux maillons s'effacent et une coche se
  // trace à leur place (details.css, état .flash), puis tout revient.
  const LINK_SVG =
    '<svg class="copy-link-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">'
    + '<g class="copy-link-chain"><path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1"/>'
    + '<path d="M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1"/></g>'
    + '<path class="copy-link-check" pathLength="20" d="M5.5 12.5l4.2 4.2L18.5 7.5"/>'
    + '</svg>';

  function setupShareBar(state) {
    const bar = document.querySelector('.share-bar');
    if (!bar) return;

    const copyBtn = bar.querySelector('[data-share="copy"]');
    if (copyBtn && !copyBtn.querySelector('.copy-link-icon')) {
      const holder = document.createElement('span');
      holder.innerHTML = LINK_SVG;
      const old = copyBtn.querySelector('svg.icon, i');
      if (old) old.replaceWith(holder.firstChild); else copyBtn.prepend(holder.firstChild);
    }

    function getShareData() {
      const a = state.aircraftData;
      const name = (a && a.name) || document.title.split('|')[0].trim();
      const url = location.href.split('#')[0];
      return { name, url, text: `${name} — Vol d'Histoire` };
    }

    function openIntent(targetUrl) {
      const w = 600, h = 540;
      const left = (window.screen.width - w) / 2;
      const top = (window.screen.height - h) / 2;
      window.open(targetUrl, 'vh-share',
        `width=${w},height=${h},left=${left},top=${top},menubar=no,toolbar=no,location=no,status=no`);
    }

    async function copyLink(btn) {
      const { url } = getShareData();
      try {
        await navigator.clipboard.writeText(url);
        btn.classList.add('flash');
        if (typeof showToast === 'function') {
          showToast(i18n.currentLang === 'en' ? 'Link copied' : 'Lien copié', 'success');
        }
        setTimeout(() => btn.classList.remove('flash'), 800);
      } catch {
        // Repli français tant que les locales ne sont pas chargées
        // (i18n.t() renvoie alors la clé).
        const label = i18n.t('details.copy_link_prompt');
        window.prompt(label && label !== 'details.copy_link_prompt' ? label : 'Copier le lien :', url);
      }
    }

    async function nativeShare() {
      const { name, text, url } = getShareData();
      try { await navigator.share({ title: name, text, url }); } catch { /* cancel */ }
    }

    if ('share' in navigator) {
      const native = bar.querySelector('.share-btn-native');
      if (native) native.classList.remove('hidden');
    }

    bar.addEventListener('click', e => {
      const btn = e.target.closest('.share-btn');
      if (!btn) return;
      const action = btn.dataset.share;
      const { url, text } = getShareData();
      const u = encodeURIComponent(url);
      const t = encodeURIComponent(text);
      switch (action) {
        case 'twitter':  openIntent(`https://twitter.com/intent/tweet?url=${u}&text=${t}`); break;
        case 'linkedin': openIntent(`https://www.linkedin.com/sharing/share-offsite/?url=${u}`); break;
        case 'reddit':   openIntent(`https://www.reddit.com/submit?url=${u}&title=${t}`); break;
        case 'copy':     copyLink(btn); break;
        case 'native':   nativeShare(); break;
      }
    });
  }

  function syncMiniBar(state) {
    const a = state.aircraftData;
    if (!a) return;
    const nameEl = document.getElementById('mini-name');
    if (nameEl) nameEl.textContent = a.name || '';
    const sp = document.getElementById('mini-speed');
    if (sp) sp.innerHTML = a.max_speed ? '<i class="fas fa-gauge-high"></i>' + a.max_speed + ' km/h' : '';
    const rn = document.getElementById('mini-range');
    if (rn) rn.innerHTML = a.max_range ? '<i class="fas fa-route"></i>' + a.max_range + ' km' : '';
    const wt = document.getElementById('mini-weight');
    if (wt) wt.innerHTML = a.empty_weight ? '<i class="fas fa-weight-hanging"></i>' + a.empty_weight + ' kg' : '';
  }

  function setupMiniBarVisibility() {
    const heroSection = document.querySelector('.aircraft-hero');
    if (!heroSection || !('IntersectionObserver' in window)) return;
    new IntersectionObserver(entries => {
      entries.forEach(e => document.body.classList.toggle('mini-bar-visible', !e.isIntersecting));
    }, { threshold: 0, rootMargin: '-80px 0px 0px 0px' }).observe(heroSection);
  }

  function setupScrollProgress() {
    const progressEl = document.getElementById('scroll-progress');
    if (!progressEl) return;
    let ticking = false;
    function updateProgress() {
      const h = document.documentElement;
      const max = h.scrollHeight - h.clientHeight;
      const pct = max > 0 ? (h.scrollTop / max) * 100 : 0;
      progressEl.style.width = pct + '%';
      ticking = false;
    }
    window.addEventListener('scroll', () => {
      if (!ticking) { requestAnimationFrame(updateProgress); ticking = true; }
    }, { passive: true });
    updateProgress();
  }

  // Apparition des sections au défilement. L'état masqué est une classe
  // (.is-pending, details.css) et non des styles en ligne : la transition
  // en ligne `all 0.5s ease` d'avant écrasait celle du survol (bordure,
  // ombre). Sans IntersectionObserver, les sections restent simplement
  // visibles.
  function setupSectionAnimations() {
    if (!('IntersectionObserver' in window)) return;
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.remove('is-pending');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });
    document.querySelectorAll('.content-section').forEach(section => {
      section.classList.add('is-pending');
      observer.observe(section);
    });
  }

  function revealAllSections() {
    document.querySelectorAll('.content-section.is-pending')
      .forEach(s => s.classList.remove('is-pending'));
  }

  function setupPdfExport() {
    document.getElementById('pdf-btn')?.addEventListener('click', () => {
      revealAllSections();
      // Deux images : laisser le navigateur peindre les sections révélées.
      requestAnimationFrame(() => {
        requestAnimationFrame(() => window.print());
      });
    });
    window.addEventListener('beforeprint', revealAllSections);
  }

  // ── Pagination PDF : table des matières automatique ───────────────
  // Non utilisée actuellement mais réservée pour évolution future.

  VH.details.ui = {
    setupShareBar, syncMiniBar, setupMiniBarVisibility,
    setupScrollProgress, setupSectionAnimations, setupPdfExport,
  };
})();
