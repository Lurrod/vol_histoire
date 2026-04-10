/* ================================================================
   COOKIE CONSENT SYSTEM
   ================================================================ */

class CookieConsent {
  constructor() {
    this.cookieName = 'voldhistoire_cookie_consent';
    this.cookieExpiry = 365; // days
    this.preferences = {
      essential: true, // Always true
      analytics: false,
      preference: false,
      marketing: false
    };
    
    this.init();
  }
  
  async init() {
    // Charger le template cookie-consent.html s'il n'est pas déjà dans le DOM
    if (!document.getElementById('cookie-banner')) {
      await this.loadTemplate();
    }

    // Check if consent already given
    const consent = this.getConsent();

    if (consent) {
      this.preferences = consent;
      this.applyConsent();
    } else {
      // Show banner after a short delay
      setTimeout(() => {
        this.showBanner();
      }, 1000);
    }

    this.attachEventListeners();
  }

  async loadTemplate() {
    try {
      const basePath = document.querySelector('script[src*="cookies.js"]')?.src.replace(/js\/cookies\.js.*$/, '') || './';
      const res = await fetch(`${basePath}cookie-consent.html`);
      if (!res.ok) return;
      const html = await res.text();
      const container = document.createElement('div');
      container.innerHTML = html;
      // Insérer au début du body (avant le header)
      document.body.insertBefore(container, document.body.firstChild);
      // Appliquer les traductions i18n au contenu injecté
      if (typeof i18n !== 'undefined' && i18n.applyToDOM) {
        i18n.applyToDOM(container);
      }
    } catch (e) {
      // Échec silencieux — le banner inline sert de fallback
    }
  }
  
  attachEventListeners() {
    // Banner buttons
    const acceptBtn = document.getElementById('cookie-accept-btn');
    const rejectBtn = document.getElementById('cookie-reject-btn');
    const settingsBtn = document.getElementById('cookie-settings-btn');
    
    if (acceptBtn) {
      acceptBtn.addEventListener('click', () => this.acceptAll());
    }
    
    if (rejectBtn) {
      rejectBtn.addEventListener('click', () => this.rejectAll());
    }
    
    if (settingsBtn) {
      settingsBtn.addEventListener('click', () => this.openModal());
    }
    
    // Modal buttons
    const acceptAllBtn = document.getElementById('cookie-accept-all-btn');
    const rejectAllBtn = document.getElementById('cookie-reject-all-btn');
    const savePreferencesBtn = document.getElementById('cookie-save-preferences-btn');
    const modalClose = document.querySelector('.cookie-modal-close');
    const modalBackdrop = document.querySelector('.cookie-modal-backdrop');
    
    if (acceptAllBtn) {
      acceptAllBtn.addEventListener('click', () => {
        this.acceptAll();
        this.closeModal();
      });
    }
    
    if (rejectAllBtn) {
      rejectAllBtn.addEventListener('click', () => {
        this.rejectAll();
        this.closeModal();
      });
    }
    
    if (savePreferencesBtn) {
      savePreferencesBtn.addEventListener('click', () => this.savePreferences());
    }
    
    if (modalClose) {
      modalClose.addEventListener('click', () => this.closeModal());
    }
    
    if (modalBackdrop) {
      modalBackdrop.addEventListener('click', () => this.closeModal());
    }
    
    // Cookie toggles
    const analyticsToggle = document.getElementById('cookie-analytics');
    const preferenceToggle = document.getElementById('cookie-preference');
    
    if (analyticsToggle) {
      analyticsToggle.addEventListener('change', (e) => {
        this.preferences.analytics = e.target.checked;
      });
    }
    
    if (preferenceToggle) {
      preferenceToggle.addEventListener('change', (e) => {
        this.preferences.preference = e.target.checked;
      });
    }
    
    // Settings link in footer (if exists)
    const cookieSettingsLinks = document.querySelectorAll('.cookie-settings-link');
    cookieSettingsLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        this.openModal();
      });
    });
    
    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.closeModal();
      }
    });
  }
  
  showBanner() {
    const banner = document.getElementById('cookie-banner');
    if (banner) {
      banner.classList.remove('hidden');
      // Trigger reflow for animation
      banner.offsetHeight;
      banner.classList.add('show');
    }
  }
  
  hideBanner() {
    const banner = document.getElementById('cookie-banner');
    if (banner) {
      banner.classList.remove('show');
      setTimeout(() => {
        banner.classList.add('hidden');
      }, 400);
    }
  }
  
  openModal() {
    const modal = document.getElementById('cookie-modal');
    if (modal) {
      // Load current preferences
      const consent = this.getConsent();
      if (consent) {
        this.preferences = consent;
      }
      
      // Update toggle states
      const analyticsToggle = document.getElementById('cookie-analytics');
      const preferenceToggle = document.getElementById('cookie-preference');
      
      if (analyticsToggle) {
        analyticsToggle.checked = this.preferences.analytics;
      }
      if (preferenceToggle) {
        preferenceToggle.checked = this.preferences.preference;
      }
      
      modal.classList.remove('hidden');
      // Trigger reflow for animation
      modal.offsetHeight;
      modal.classList.add('show');
      document.body.style.overflow = 'hidden';
    }
  }
  
  closeModal() {
    const modal = document.getElementById('cookie-modal');
    if (modal) {
      modal.classList.remove('show');
      document.body.style.overflow = '';
      setTimeout(() => {
        modal.classList.add('hidden');
      }, 300);
    }
  }
  
  acceptAll() {
    this.preferences = {
      essential: true,
      analytics: true,
      preference: true,
      marketing: false // Keep false as not used
    };
    
    this.saveConsent();
    this.applyConsent();
    this.hideBanner();
    this.showToast('Tous les cookies ont été acceptés', 'success');
  }
  
  rejectAll() {
    this.preferences = {
      essential: true, // Can't disable essential
      analytics: false,
      preference: false,
      marketing: false
    };
    
    this.saveConsent();
    this.applyConsent();
    this.hideBanner();
    this.showToast('Seuls les cookies essentiels sont activés', 'info');
  }
  
  savePreferences() {
    // Get current toggle states
    const analyticsToggle = document.getElementById('cookie-analytics');
    const preferenceToggle = document.getElementById('cookie-preference');
    
    this.preferences = {
      essential: true,
      analytics: analyticsToggle ? analyticsToggle.checked : false,
      preference: preferenceToggle ? preferenceToggle.checked : false,
      marketing: false
    };
    
    this.saveConsent();
    this.applyConsent();
    this.closeModal();
    this.hideBanner();
    this.showToast('Vos préférences ont été enregistrées', 'success');
  }
  
  saveConsent() {
    const consentData = {
      preferences: this.preferences,
      timestamp: new Date().toISOString(),
      version: '1.0'
    };
    
    // Save to localStorage
    localStorage.setItem(this.cookieName, JSON.stringify(consentData));
    
    // Also set a cookie for 365 days
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + this.cookieExpiry);
    document.cookie = `${this.cookieName}=true; expires=${expiryDate.toUTCString()}; path=/; SameSite=Lax`;
  }
  
  getConsent() {
    const consentData = localStorage.getItem(this.cookieName);
    if (consentData) {
      try {
        const parsed = JSON.parse(consentData);
        return parsed.preferences;
      } catch (e) {
        // Erreur silencieuse — données de consentement corrompues
        return null;
      }
    }
    return null;
  }
  
  applyConsent() {
    // Update GTM Consent Mode
    this.updateGTMConsent();

    // Apply analytics cookies
    if (this.preferences.analytics) {
      this.enableAnalytics();
    } else {
      this.disableAnalytics();
    }
    
    // Apply preference cookies
    if (this.preferences.preference) {
      this.enablePreferences();
    } else {
      this.disablePreferences();
    }
    
  }
  
  updateGTMConsent() {
    // Update Google Consent Mode v2 via GTM dataLayer
    window.dataLayer = window.dataLayer || [];
    function gtag(){window.dataLayer.push(arguments);}
    
    gtag('consent', 'update', {
      analytics_storage: this.preferences.analytics ? 'granted' : 'denied',
      ad_storage: this.preferences.marketing ? 'granted' : 'denied',
      ad_user_data: this.preferences.marketing ? 'granted' : 'denied',
      ad_personalization: this.preferences.marketing ? 'granted' : 'denied',
      functionality_storage: this.preferences.preference ? 'granted' : 'denied',
      personalization_storage: this.preferences.preference ? 'granted' : 'denied',
      security_storage: 'granted'
    });

    // Push consent event for GTM triggers
    window.dataLayer.push({
      event: 'cookie_consent_update',
      cookie_consent_analytics: this.preferences.analytics,
      cookie_consent_preference: this.preferences.preference,
      cookie_consent_marketing: this.preferences.marketing
    });

  }

  enableAnalytics() {
    this.fireEvent('analytics_enabled');
  }

  disableAnalytics() {
    this.fireEvent('analytics_disabled');
  }

  enablePreferences() {
    this.fireEvent('preferences_enabled');
  }

  disablePreferences() {
    this.fireEvent('preferences_disabled');
  }
  
  fireEvent(eventName) {
    // Fire custom event for other scripts to listen to
    const event = new CustomEvent('cookieConsent', {
      detail: {
        event: eventName,
        preferences: this.preferences
      }
    });
    document.dispatchEvent(event);
  }
  
  showToast(message, type = 'info') {
    // Show toast notification
    const toastContainer = document.getElementById('toast-container') || this.createToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.setAttribute('role', 'status');

    const icon = type === 'success' ? 'check-circle' :
                 type === 'error' ? 'exclamation-circle' :
                 'info-circle';

    const iconEl = document.createElement('i');
    iconEl.className = `fas fa-${icon}`;
    iconEl.setAttribute('aria-hidden', 'true');
    const spanEl = document.createElement('span');
    spanEl.textContent = message;
    toast.appendChild(iconEl);
    toast.appendChild(spanEl);

    toastContainer.appendChild(toast);
    
    // Show animation
    setTimeout(() => {
      toast.style.opacity = '1';
      toast.style.transform = 'translateX(0)';
    }, 100);
    
    // Remove after delay
    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateX(100%)';
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
  
  createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toast-container';
    container.style.cssText = `
      position: fixed;
      top: 100px;
      right: 20px;
      z-index: 10001;
      display: flex;
      flex-direction: column;
      gap: 10px;
    `;
    document.body.appendChild(container);
    return container;
  }
  
  // Public method to reset consent (useful for testing)
  resetConsent() {
    localStorage.removeItem(this.cookieName);
    document.cookie = `${this.cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
    location.reload();
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  window.cookieConsent = new CookieConsent();
  
  // Expose reset function to console for testing
  window.resetCookieConsent = () => {
    if (window.cookieConsent) {
      window.cookieConsent.resetConsent();
    }
  };
  
});

// Listen to cookie consent events (GTM integration)
document.addEventListener('cookieConsent', () => {
});
