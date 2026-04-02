document.addEventListener("DOMContentLoaded", async () => {
  /* =========================================================================
     AUTH INITIALIZATION
     ========================================================================= */
  await auth.init();

  /* Provided by nav.js — header, hamburger, dropdown, logout, updateAuthUI */

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
      const res = await auth.fetchWithTimeout('/api/stats');
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

  /* Provided by utils.js — animateNumber */

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
        heroContent.style.opacity = Math.max(0, 1 - (scrolled / heroHeight) * 1.5);
      }
    }
  });

  /* Provided by utils.js — escapeHtml, showToast */

  /* =========================================================================
     VIDEO CONTROLS
     ========================================================================= */

  const videoObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      const video = entry.target;
      if (entry.isIntersecting) {
        video.play().catch(() => {});
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

  /* Provided by nav.js — ESC keyboard handler */

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
     FEATURED AIRCRAFT — Load 3 real aircraft from the API
     ========================================================================= */

  /* =========================================================================
     INITIALIZE (updateAuthUI called automatically by nav.js)
     ========================================================================= */

  window.addEventListener('load', () => {
  });

  // Smooth page reveal
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.5s ease';
  setTimeout(() => { document.body.style.opacity = '1'; }, 100);
});