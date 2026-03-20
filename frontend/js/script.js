document.addEventListener("DOMContentLoaded", () => {
  /* =========================================================================
     NAVIGATION & HEADER
     ========================================================================= */

  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userDropdown = document.querySelector('.user-dropdown');

  // Header scroll effect
  window.addEventListener('scroll', () => {
    if (window.pageYOffset > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // Mobile menu toggle
  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Close mobile menu on link click
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', (e) => {
      if (link.id === 'login-icon') return;
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close mobile menu on window resize
  window.addEventListener('resize', () => {
    if (window.innerWidth > 992) {
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    }
  });

  /* =========================================================================
     USER AUTHENTICATION & MENU
     ========================================================================= */

  const updateAuthUI = () => {
    const payload = auth.getPayload();
    if (payload) {
      const userNameEl = document.getElementById('user-name');
      const userRoleEl = document.querySelector('.user-role');

      if (userNameEl) userNameEl.textContent = payload.name || i18n.t('nav.user_default');
      if (userRoleEl) {
        const role = Number(payload.role);
        userRoleEl.textContent = role === 1 ? i18n.t('common.role_admin') :
                                 role === 2 ? i18n.t('common.role_editor') : i18n.t('nav.user_role');
      }
    }
  };

  // User menu toggle
  loginIcon?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();

    const token = auth.getToken();
    if (!token) {
      window.location.href = '/login';
      return;
    }

    if (userDropdown?.classList.contains('show')) {
      userDropdown.classList.remove('show');
      setTimeout(() => userDropdown.classList.add('hidden'), 300);
    } else {
      userDropdown?.classList.remove('hidden');
      requestAnimationFrame(() => userDropdown?.classList.add('show'));
    }
  });

  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (userDropdown && !userDropdown.contains(e.target) && e.target !== loginIcon && !loginIcon?.contains(e.target)) {
      if (userDropdown.classList.contains('show')) {
        userDropdown.classList.remove('show');
        setTimeout(() => userDropdown.classList.add('hidden'), 300);
      }
    }
  });

  // Settings navigation
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = '/settings';
  });

  // Logout handlers
  const logoutButtons = document.querySelectorAll('#logout-icon, #logout-btn');
  logoutButtons.forEach(btn => {
    btn?.addEventListener('click', async (e) => {
      e.preventDefault();
      await auth.logout();
      showToast(i18n.t('common.logout_success'), 'success');
      setTimeout(() => { window.location.href = '/'; }, 1000);
    });
  });

  /* =========================================================================
     STATS API — Dynamic hero stats from /api/stats
     ========================================================================= */

  async function fetchHeroStats() {
    const elAirplanes = document.getElementById('hero-stat-airplanes');
    const elYears     = document.getElementById('hero-stat-years');
    const elYearsLbl  = document.getElementById('hero-stat-years-label');
    const elCountries = document.getElementById('hero-stat-countries');

    if (!elAirplanes || !elYears || !elCountries) return;

    try {
      const res = await fetch('/api/stats');
      if (!res.ok) throw new Error('API stats error');
      const data = await res.json();

      // Animate all values with count-up
      animateNumber(elAirplanes, data.airplanes);
      animateNumber(elCountries, data.countries);

      if (data.earliest_year && data.latest_year) {
        const span = data.latest_year - data.earliest_year;
        animateNumber(elYears, span);
        if (elYearsLbl) elYearsLbl.textContent = i18n.t('home.stat_years');
      }
    } catch (err) {
      // Fallback: hardcoded values if API unreachable
      console.warn('Stats API unavailable, using fallback values.');
      animateNumber(elAirplanes, 45);
      animateNumber(elYears, 75);
      animateNumber(elCountries, 12);
    }
  }

  function animateNumber(el, target) {
    const duration = 1400;
    const start = performance.now();

    function step(now) {
      const progress = Math.min((now - start) / duration, 1);
      // ease-out cubic
      const eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.round(eased * target);
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  /* =========================================================================
     SCROLL ANIMATIONS (AOS-like)
     ========================================================================= */

  const animateOnScroll = () => {
    const elements = document.querySelectorAll('[data-aos]');

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const delay = entry.target.dataset.aosDelay || 0;
          setTimeout(() => {
            entry.target.classList.add('aos-animate');
          }, delay);
          observer.unobserve(entry.target);
        }
      });
    }, {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    });

    elements.forEach(el => observer.observe(el));
  };

  animateOnScroll();

  /* =========================================================================
     SMOOTH SCROLL FOR ANCHOR LINKS
     ========================================================================= */

  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (href !== '#') {
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }
    });
  });

  /* =========================================================================
     PARALLAX EFFECT FOR HERO
     ========================================================================= */

  const heroVideo = document.querySelector('.hero-video');
  const heroContent = document.querySelector('.hero-content');

  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const heroHeight = document.querySelector('.hero')?.offsetHeight || 0;

    if (scrolled < heroHeight) {
      if (heroVideo) {
        heroVideo.style.transform = `translate(-50%, -50%) scale(${1 + scrolled * 0.0002})`;
      }
      if (heroContent) {
        heroContent.style.transform = `translateY(${scrolled * 0.4}px)`;
        heroContent.style.opacity = 1 - (scrolled / heroHeight) * 1.5;
      }
    }
  });

  /* =========================================================================
     UTILITIES
     ========================================================================= */

  function escapeHtml(text) {
    if (text == null) return '';
    const div = document.createElement('div');
    div.textContent = String(text);
    return div.innerHTML;
  }

  /* =========================================================================
     TOAST NOTIFICATIONS
     ========================================================================= */

  function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.style.cssText = `
      position: fixed;
      top: 100px;
      right: 20px;
      background: ${type === 'success' ? 'rgba(0, 230, 118, 0.15)' : type === 'error' ? 'rgba(231, 76, 60, 0.15)' : 'rgba(0, 229, 255, 0.15)'};
      color: ${type === 'success' ? '#00e676' : type === 'error' ? '#e74c3c' : '#00e5ff'};
      border: 1px solid ${type === 'success' ? 'rgba(0, 230, 118, 0.3)' : type === 'error' ? 'rgba(231, 76, 60, 0.3)' : 'rgba(0, 229, 255, 0.3)'};
      padding: 1rem 1.5rem;
      border-radius: 12px;
      backdrop-filter: blur(16px);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
      z-index: 10000;
      animation: slideInRight 0.3s ease;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      font-weight: 600;
      font-family: 'Space Grotesk', sans-serif;
    `;

    const icon = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
    toast.innerHTML = `<span style="font-size: 1.25rem;">${icon}</span><span>${escapeHtml(message)}</span>`;

    document.body.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = 'slideOutRight 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  /* =========================================================================
     VIDEO CONTROLS
     ========================================================================= */

  const videoObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      const video = entry.target;
      if (entry.isIntersecting) {
        video.play().catch(err => console.log('Video play error:', err));
      } else {
        video.pause();
      }
    });
  }, { threshold: 0.5 });

  if (heroVideo) {
    videoObserver.observe(heroVideo);
  }

  /* =========================================================================
     FEATURED CARDS HOVER EFFECT
     ========================================================================= */

  const aircraftCards = document.querySelectorAll('.aircraft-card');
  aircraftCards.forEach(card => {
    card.addEventListener('mouseenter', function() { this.style.zIndex = '10'; });
    card.addEventListener('mouseleave', function() { this.style.zIndex = '1'; });
  });

  /* =========================================================================
     LOADING ANIMATION FOR IMAGES
     ========================================================================= */

  const images = document.querySelectorAll('img');
  images.forEach(img => {
    img.addEventListener('load', function() {
      this.style.opacity = '0';
      this.style.transition = 'opacity 0.5s ease';
      setTimeout(() => { this.style.opacity = '1'; }, 10);
    });
  });

  /* =========================================================================
     SCROLL INDICATOR
     ========================================================================= */

  const scrollIndicator = document.querySelector('.scroll-indicator');

  if (scrollIndicator) {
    scrollIndicator.addEventListener('click', () => {
      const featuresSection = document.querySelector('.features');
      if (featuresSection) {
        featuresSection.scrollIntoView({ behavior: 'smooth' });
      }
    });

    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 100) {
        scrollIndicator.style.opacity = '0';
        scrollIndicator.style.pointerEvents = 'none';
      } else {
        scrollIndicator.style.opacity = '1';
        scrollIndicator.style.pointerEvents = 'all';
      }
    });
  }

  /* =========================================================================
     PRELOAD CRITICAL RESOURCES
     ========================================================================= */

  const preloadImages = [
    'https://i.postimg.cc/d0fvshX3/f16-fighting-falcon.jpg',
    'https://i.postimg.cc/bwnsrntT/mig21.jpg',
    'https://i.postimg.cc/W4rW55Jk/su27.jpg'
  ];

  preloadImages.forEach(src => {
    const link = document.createElement('link');
    link.rel = 'preload';
    link.as = 'image';
    link.href = src;
    document.head.appendChild(link);
  });

  /* =========================================================================
     FEATURE CARDS STAGGER ANIMATION
     ========================================================================= */

  const featureCards = document.querySelectorAll('.feature-card');

  const featureObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry, index) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, index * 100);
        featureObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  featureCards.forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(40px)';
    card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
    featureObserver.observe(card);
  });

  /* =========================================================================
     TIMELINE CARDS ANIMATION
     ========================================================================= */

  const timelineCards = document.querySelectorAll('.timeline-card');

  const timelineObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry, index) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateX(0)';
        }, index * 150);
        timelineObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.2 });

  timelineCards.forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateX(-40px)';
    card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
    timelineObserver.observe(card);
  });

  /* =========================================================================
     KEYBOARD NAVIGATION
     ========================================================================= */

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';

      if (userDropdown?.classList.contains('show')) {
        userDropdown.classList.remove('show');
        setTimeout(() => userDropdown.classList.add('hidden'), 300);
      }
    }
  });

  /* =========================================================================
     PERFORMANCE OPTIMIZATION
     ========================================================================= */

  let scrollTimeout;
  window.addEventListener('scroll', () => {
    if (scrollTimeout) window.cancelAnimationFrame(scrollTimeout);
    scrollTimeout = window.requestAnimationFrame(() => {});
  }, { passive: true });

  // Add CSS animation keyframes dynamically
  const style = document.createElement('style');
  style.textContent = `
    @keyframes slideInRight {
      from { transform: translateX(400px); opacity: 0; }
      to   { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOutRight {
      from { transform: translateX(0); opacity: 1; }
      to   { transform: translateX(400px); opacity: 0; }
    }
  `;
  document.head.appendChild(style);

  /* =========================================================================
     HERO STATS — Trigger animation on visibility
     ========================================================================= */

  const heroStats = document.querySelector('.hero-stats');
  let statsLoaded = false;

  if (heroStats) {
    const statsObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !statsLoaded) {
          statsLoaded = true;
          fetchHeroStats();
          statsObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.5 });

    statsObserver.observe(heroStats);
  }

  /* =========================================================================
     INITIALIZE
     ========================================================================= */

  updateAuthUI();

  window.addEventListener('load', () => {
    const loadTime = performance.now();
    console.log(`Page loaded in ${Math.round(loadTime)}ms`);
  });

  // Smooth page reveal
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.5s ease';
  setTimeout(() => { document.body.style.opacity = '1'; }, 100);
});