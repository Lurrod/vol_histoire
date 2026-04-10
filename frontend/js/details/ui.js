/* UI divers : share-bar, mini-bar, scroll progress, PDF, animations, raccourcis. */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function setupShareBar(state) {
    const bar = document.querySelector('.share-bar');
    if (!bar) return;

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
      } catch (_) {
        window.prompt('Copier le lien :', url);
      }
    }

    async function nativeShare() {
      const { name, text, url } = getShareData();
      try { await navigator.share({ title: name, text, url }); } catch (_) { /* cancel */ }
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
    if (wt) wt.innerHTML = a.weight ? '<i class="fas fa-weight-hanging"></i>' + a.weight + ' kg' : '';
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

  function setupSectionAnimations() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });
    document.querySelectorAll('.content-section').forEach(section => {
      section.style.opacity = '0';
      section.style.transform = 'translateY(20px)';
      section.style.transition = 'all 0.5s ease';
      observer.observe(section);
    });
  }

  function setupPdfExport() {
    document.getElementById('pdf-btn')?.addEventListener('click', () => {
      const sections = document.querySelectorAll('.content-section');
      sections.forEach(s => { s.style.opacity = '1'; s.style.transform = 'none'; s.style.transition = 'none'; });
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          window.print();
          sections.forEach(s => { s.style.transition = 'all 0.5s ease'; });
        });
      });
    });
    window.addEventListener('beforeprint', () => {
      document.querySelectorAll('.content-section').forEach(s => {
        s.style.opacity = '1'; s.style.transform = 'none'; s.style.transition = 'none';
      });
    });
  }

  VH.details.ui = {
    setupShareBar, syncMiniBar, setupMiniBarVisibility,
    setupScrollProgress, setupSectionAnimations, setupPdfExport,
  };
})();
