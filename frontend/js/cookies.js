/* ================================================================
   COOKIE CONSENT SYSTEM
   ================================================================ */

// Marge laissée entre l'élément focalisé et le bord haut du bandeau.
const BANNER_FOCUS_MARGIN = 16;

/**
 * WCAG 2.2 — 2.4.11 (focus non masqué). Le bandeau est fixé en bas de
 * l'écran ; au clavier, le navigateur ne fait défiler que si l'élément sort
 * de la fenêtre, et le laissait donc SOUS le bandeau (10 contrôles sur 27 du
 * hangar en mobile). Renvoie de combien de pixels faire défiler la page pour
 * remonter `target` au-dessus du bandeau, 0 s'il n'est pas caché.
 *
 * @param {Element} target  élément qui vient de recevoir le focus
 * @param {Element} banner  #cookie-banner
 * @param {Element} [header] en-tête fixe : le haut de l'élément ne passe pas dessous
 * @returns {number}
 */
function bannerOverlap(target, banner, header) {
  if (!banner || !banner.classList.contains('show')) return 0;
  if (!target || typeof target.getBoundingClientRect !== 'function' || banner.contains(target)) return 0;

  const r = target.getBoundingClientRect();
  const b = banner.getBoundingClientRect();
  if (r.width === 0 && r.height === 0) return 0; // hors rendu (lien d'évitement replié…)
  if (r.bottom <= b.top || r.top >= b.bottom) return 0;

  // Un élément peint AU-DESSUS du bandeau (toast, modale) n'est pas caché.
  if (typeof document.elementFromPoint === 'function') {
    const x = Math.min(Math.max(r.left + r.width / 2, 0), window.innerWidth - 1);
    const y = Math.min(Math.max(r.bottom - 1, b.top), b.bottom - 1);
    const hit = document.elementFromPoint(x, y);
    if (hit && !banner.contains(hit)) return 0;
  }

  const needed = Math.ceil(r.bottom - b.top + BANNER_FOCUS_MARGIN);
  const head = header === undefined ? document.querySelector('body > header') : header;
  const headBottom = head ? head.getBoundingClientRect().bottom : 0;
  // Élément plus haut que la place disponible : on le remonte jusqu'à
  // l'en-tête, pas au-delà (il reste alors visible en partie, ce que
  // demande le critère, au lieu de disparaître par le haut).
  const room = Math.max(0, Math.floor(r.top - headBottom - BANNER_FOCUS_MARGIN));
  return Math.min(needed, room);
}

// ─────────────────────────────────────────────────────────────────────────────
// Conservation du choix (LEGAL-004). La CNIL recommande de redemander le
// consentement au bout de 6 mois : le choix est daté, et un choix plus ancien
// (ou sans date lisible) est traité comme une absence de choix — le bandeau
// revient. Le cookie miroir expire à la même échéance.
// ─────────────────────────────────────────────────────────────────────────────
const CONSENT_STORAGE_KEY = 'voldhistoire_cookie_consent';
const CONSENT_MAX_AGE_DAYS = 180;
const DAY_MS = 24 * 60 * 60 * 1000;
const CONSENT_VERSION = '2';

/** Seules deux finalités existent : essentiel (toujours) et mesure d'audience.
 *  La catégorie « préférence » a été retirée (LEGAL-006) : les stockages de
 *  confort (langue, vue, comparateur…) sont des traceurs fonctionnels exemptés,
 *  et aucun code ne consultait ce choix. Le marketing n'est pas utilisé. */
function normalizePreferences(prefs) {
  return {
    essential: true,
    analytics: Boolean(prefs && prefs.analytics === true),
    marketing: false,
  };
}

/** true si le choix daté `timestamp` a dépassé la durée de conservation. */
function isConsentExpired(timestamp, now = Date.now()) {
  const at = Date.parse(timestamp);
  if (Number.isNaN(at)) return true;
  return now - at > CONSENT_MAX_AGE_DAYS * DAY_MS;
}

function removeConsentCookie() {
  document.cookie = `${CONSENT_STORAGE_KEY}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; SameSite=Lax`;
}

/**
 * Choix enregistré et encore valide : { preferences, timestamp }, sinon null.
 * Un choix expiré est effacé (stockage + cookie) pour que le bandeau revienne.
 * Les données corrompues ou un stockage inaccessible valent absence de choix.
 */
function readConsentRecord(now = Date.now()) {
  let parsed;
  try {
    const brut = window.localStorage.getItem(CONSENT_STORAGE_KEY);
    if (!brut) return null;
    parsed = JSON.parse(brut);
  } catch {
    return null;
  }
  if (!parsed || typeof parsed !== 'object' || !parsed.preferences || typeof parsed.preferences !== 'object') return null;
  if (isConsentExpired(parsed.timestamp, now)) {
    try { window.localStorage.removeItem(CONSENT_STORAGE_KEY); } catch { /* stockage bloqué */ }
    removeConsentCookie();
    return null;
  }
  const preferences = normalizePreferences(parsed.preferences);
  // Finalité non renseignée ≠ refus : VH.consent.denies() doit rester faux.
  if (typeof parsed.preferences.analytics !== 'boolean') delete preferences.analytics;
  return { preferences, timestamp: parsed.timestamp };
}

/** Enregistre le choix daté (localStorage + cookie miroir de même durée). */
function writeConsentRecord(prefs, now = Date.now()) {
  const record = {
    preferences: normalizePreferences(prefs),
    timestamp: new Date(now).toISOString(),
    version: CONSENT_VERSION,
  };
  try {
    window.localStorage.setItem(CONSENT_STORAGE_KEY, JSON.stringify(record));
  } catch {
    // Stockage bloqué (navigation privée stricte) : le choix vaut pour la page.
  }
  document.cookie = `${CONSENT_STORAGE_KEY}=true; max-age=${CONSENT_MAX_AGE_DAYS * 24 * 60 * 60}; path=/; SameSite=Lax`;
  return record;
}

// ─────────────────────────────────────────────────────────────────────────────
// Retrait de la mesure d'audience (LEGAL-005). Refuser doit être aussi effectif
// qu'accepter : on coupe Google Analytics (drapeau officiel ga-disable-<ID>),
// on efface ses cookies sur l'hôte ET sur les domaines parents (GA les pose
// par défaut sur le domaine le plus large possible, ici .titouan-borde.com).
// ─────────────────────────────────────────────────────────────────────────────
const GA_COOKIE_RE = /^(_ga(_.+)?|_gid|_gat(_.+)?)$/;

/** Domaines sur lesquels un cookie a pu être posé : hôte, puis chaque parent
 *  d'au moins deux libellés (« .com » seul est refusé par le navigateur). */
function cookieDomainCandidates(hostname) {
  const host = String(hostname || '');
  const candidates = [''];
  if (!host || /^[\d.]+$/.test(host) || host.indexOf('.') === -1) return candidates;
  const labels = host.split('.');
  for (let i = 0; i <= labels.length - 2; i++) {
    candidates.push(`.${labels.slice(i).join('.')}`);
  }
  return candidates;
}

/** Noms des cookies de Google Analytics présents sur la page. */
function analyticsCookieNames() {
  return document.cookie
    .split(';')
    .map((c) => c.split('=')[0].trim())
    .filter((name) => GA_COOKIE_RE.test(name));
}

/** Identifiants de mesure GA4 connus : ceux de gtm.js et ceux que révèlent les
 *  cookies `_ga_<ID>` (le cookie porte l'identifiant sans le préfixe « G- »). */
function analyticsMeasurementIds() {
  const ids = new Set(Array.isArray(window.__VH_GA_IDS) ? window.__VH_GA_IDS : []);
  analyticsCookieNames().forEach((name) => {
    const m = /^_ga_(.+)$/.exec(name);
    if (m) ids.add(`G-${m[1]}`);
  });
  return Array.from(ids);
}

/** Efface les cookies GA sur l'hôte et sur chaque domaine parent. */
function removeAnalyticsCookies(hostname = window.location.hostname) {
  const names = analyticsCookieNames();
  const domains = cookieDomainCandidates(hostname);
  names.forEach((name) => {
    domains.forEach((domain) => {
      const domainAttr = domain ? `; domain=${domain}` : '';
      document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/${domainAttr}`;
    });
  });
  return names;
}

/** Pose (ou lève) le drapeau ga-disable-<ID> lu par gtag avant chaque envoi. */
function setAnalyticsDisabled(disabled) {
  analyticsMeasurementIds().forEach((id) => { window[`ga-disable-${id}`] = disabled; });
}

class CookieConsent {
  constructor() {
    this.cookieName = CONSENT_STORAGE_KEY;
    this.cookieExpiry = CONSENT_MAX_AGE_DAYS; // jours
    this.preferences = normalizePreferences(null);

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
      // CNIL : bandeau visible "dès l'arrivée sur le site". 200 ms = laisse
      // passer le first paint et le LCP de la page sans le pénaliser, mais
      // reste sous le temps de réaction (~250 ms) → le user n'a pas le temps
      // d'interagir avant que le bandeau s'affiche. Trackers bloqués par
      // défaut (Google Consent Mode v2 default 'denied') donc 0 PII pendant
      // ce délai.
      setTimeout(() => {
        this.showBanner();
      }, 200);
    }

    this.attachEventListeners();
  }

  async loadTemplate() {
    try {
      const basePath = document.querySelector('script[src*="cookies.js"]')?.src.replace(/js\/cookies\.js.*$/, '') || './';
      const res = await fetch(`${basePath}cookie-consent.html`);
      if (!res.ok) return;
      const html = await res.text();
      // Garde-fou : un serveur statique en mode SPA-fallback peut servir
      // index.html (33 Ko de DOM en flow normal) à la place du fragment, ce
      // qui pousse tout le contenu en bas de page et plombe CLS à 1.0.
      // On vérifie la présence du marker du fragment avant d'insérer.
      if (!/id=["']cookie-banner["']/i.test(html)) return;
      const container = document.createElement('div');
      safeSetHTML(container, html);
      // Insérer au début du body (avant le header)
      document.body.insertBefore(container, document.body.firstChild);
      // Appliquer les traductions i18n au contenu injecté
      if (typeof i18n !== 'undefined' && i18n.applyToDOM) {
        i18n.applyToDOM(container);
      }
    } catch {
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

    // Interrupteur de la mesure d'audience (seule finalité réglable)
    const analyticsToggle = document.getElementById('cookie-analytics');

    if (analyticsToggle) {
      analyticsToggle.addEventListener('change', (e) => {
        this.preferences = { ...this.preferences, analytics: e.target.checked };
      });
    }

    this.bindCategoryHeaders();

    // Settings link in footer (if exists)
    const cookieSettingsLinks = document.querySelectorAll('.cookie-settings-link');
    cookieSettingsLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        this.openModal();
      });
    });

    // Fermeture ESC : ne se déclenche que si la modal est visible,
    // pour éviter de consommer ESC globalement (cause d'effets de bord ailleurs).
    // Le focus trap attaché dans openModal() gère aussi ESC quand il est actif,
    // mais ce listener sert de filet si le trap n'a pas pu s'attacher (HTML absent).
    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Escape') return;
      const modal = document.getElementById('cookie-modal');
      if (modal && !modal.classList.contains('hidden')) {
        this.closeModal();
      }
    });
  }

  /** Libellé traduit, ou repli français tant que la clé manque. */
  t(key, fallback) {
    const value = (typeof i18n !== 'undefined' && typeof i18n.t === 'function') ? i18n.t(key) : null;
    return value && value !== key ? value : fallback;
  }

  /**
   * Un clic sur l'en-tête d'une catégorie réglable bascule son interrupteur,
   * comme le laisse attendre le curseur. Les catégories verrouillées
   * (essentiels, marketing) ne reçoivent ni la classe ni l'écouteur.
   */
  bindCategoryHeaders() {
    document.querySelectorAll('.cookie-category-header').forEach((header) => {
      const input = header.querySelector('.cookie-toggle input[type="checkbox"]');
      // .is-toggleable sert aussi de marqueur : jamais deux écouteurs.
      if (!input || input.disabled || header.classList.contains('is-toggleable')) return;
      header.classList.add('is-toggleable');
      header.addEventListener('click', (e) => {
        // La case et son label basculent déjà nativement ; les liens gardent leur rôle.
        if (e.target.closest('.cookie-toggle, a, button')) return;
        input.click();
      });
    });
  }

  showBanner() {
    const banner = document.getElementById('cookie-banner');
    if (banner) {
      banner.classList.remove('hidden');
      // Trigger reflow for animation
      banner.offsetHeight;
      banner.classList.add('show');
      this.guardFocus(banner);
    }
  }

  /**
   * Tant que le bandeau est affiché, remonte au-dessus de lui tout élément
   * qui reçoit le focus en dessous (voir bannerOverlap). La place pour
   * remonter les derniers éléments de la page est réservée en CSS
   * (padding-bottom du body, cookies.css).
   */
  guardFocus(banner) {
    if (this._focusGuard) return;
    this._focusGuard = (e) => {
      // Bandeau retiré du DOM sans passer par hideBanner : plus rien à garder.
      if (!banner.isConnected) {
        this.releaseFocusGuard();
        return;
      }
      const delta = bannerOverlap(e.target, banner);
      // 'instant' : html porte scroll-behavior: smooth, et un défilement
      // animé laisserait le focus caché le temps de l'animation.
      if (delta > 0) window.scrollBy({ top: delta, behavior: 'instant' });
    };
    document.addEventListener('focusin', this._focusGuard);
  }

  releaseFocusGuard() {
    if (!this._focusGuard) return;
    document.removeEventListener('focusin', this._focusGuard);
    this._focusGuard = null;
  }

  hideBanner() {
    const banner = document.getElementById('cookie-banner');
    this.releaseFocusGuard();
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
      // Mémorise l'élément focusé avant ouverture pour le restaurer à la fermeture.
      this._previousFocus = document.activeElement;

      // Attributs ARIA requis par WCAG 2.1 4.1.2 (rôles dialogue modaux).
      // Appliqués dynamiquement car le HTML est injecté depuis cookie-consent.html
      // qui ne les porte pas, et pour éviter une régression si le template change.
      modal.setAttribute('role', 'dialog');
      modal.setAttribute('aria-modal', 'true');
      const header = modal.querySelector('.cookie-modal-header h2, .cookie-modal-header h3');
      if (header) {
        if (!header.id) header.id = 'cookie-modal-title';
        modal.setAttribute('aria-labelledby', header.id);
      }

      // Load current preferences
      const consent = this.getConsent();
      if (consent) {
        this.preferences = consent;
      }

      // Update toggle states
      const analyticsToggle = document.getElementById('cookie-analytics');

      if (analyticsToggle) {
        analyticsToggle.checked = this.preferences.analytics;
      }

      modal.classList.remove('hidden');
      // Trigger reflow for animation
      modal.offsetHeight;
      modal.classList.add('show');
      // Classe plutôt qu'element.style : la CSP interdit les styles en ligne.
      document.body.classList.add('cookie-modal-open');

      // Focus trap + ESC fournis par trapFocus (utils.js, concaténé en amont
      // dans app.min.js). Bind la fermeture pour préserver le contexte this.
      if (typeof trapFocus === 'function') {
        this._focusTrap = trapFocus(modal, { onEscape: this.closeModal.bind(this) });
      }
    }
  }

  closeModal() {
    const modal = document.getElementById('cookie-modal');
    if (modal) {
      if (this._focusTrap) {
        this._focusTrap.destroy();
        this._focusTrap = null;
      }
      modal.classList.remove('show');
      document.body.classList.remove('cookie-modal-open');
      setTimeout(() => {
        modal.classList.add('hidden');
      }, 300);
      // Restaure le focus sur l'élément qui a ouvert la modal
      // (ex. bouton « Paramétrer » de la bannière).
      if (this._previousFocus && typeof this._previousFocus.focus === 'function') {
        this._previousFocus.focus();
        this._previousFocus = null;
      }
    }
  }

  acceptAll() {
    // Le marketing reste refusé : le site n'en utilise pas.
    this.preferences = normalizePreferences({ analytics: true });

    this.saveConsent();
    this.applyConsent();
    this.hideBanner();
    this.showToast(this.t('cookie.toast_accepted', 'Tous les cookies ont été acceptés'), 'success');
  }

  rejectAll() {
    this.preferences = normalizePreferences({ analytics: false });

    this.saveConsent();
    this.applyConsent();
    this.hideBanner();
    this.showToast(this.t('cookie.toast_rejected', 'Seuls les cookies essentiels sont activés'), 'info');
  }

  savePreferences() {
    const analyticsToggle = document.getElementById('cookie-analytics');

    this.preferences = normalizePreferences({ analytics: analyticsToggle ? analyticsToggle.checked : false });

    this.saveConsent();
    this.applyConsent();
    this.closeModal();
    this.hideBanner();
    this.showToast(this.t('cookie.toast_saved', 'Vos préférences ont été enregistrées'), 'success');
  }

  /** Enregistre le choix courant, daté, pour CONSENT_MAX_AGE_DAYS jours. */
  saveConsent() {
    writeConsentRecord(this.preferences);
  }

  /** Préférences encore valides (choix de moins de 6 mois), sinon null. */
  getConsent() {
    const record = readConsentRecord();
    return record ? record.preferences : null;
  }

  applyConsent() {
    // Update GTM Consent Mode
    this.updateGTMConsent();

    // CNIL : on ne charge gtm.js externe QUE si l'utilisateur a donné son
    // consentement analytics. __loadGTM est idempotent → safe de l'appeler
    // plusieurs fois. Aucune requête vers googletagmanager.com avant ce point.
    if (this.preferences.analytics && typeof window.__loadGTM === 'function') {
      window.__loadGTM();
    }

    if (this.preferences.analytics) {
      this.enableAnalytics();
    } else {
      this.disableAnalytics();
    }
  }

  updateGTMConsent() {
    // Update Google Consent Mode v2 via GTM dataLayer
    window.dataLayer = window.dataLayer || [];
    function gtag(){window.dataLayer.push(arguments);}

    // Aucune finalité « fonctionnalité » ou « personnalisation » n'est confiée
    // à Google : ces stockages restent refusés quel que soit le choix.
    gtag('consent', 'update', {
      analytics_storage: this.preferences.analytics ? 'granted' : 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted'
    });

    // Push consent event for GTM triggers
    window.dataLayer.push({
      event: 'cookie_consent_update',
      cookie_consent_analytics: this.preferences.analytics,
      cookie_consent_marketing: false
    });

  }

  enableAnalytics() {
    setAnalyticsDisabled(false);
    this.fireEvent('analytics_enabled');
  }

  /**
   * Refus ou retrait : drapeau ga-disable posé, cookies GA effacés (hôte et
   * domaines parents). Si GTM a déjà été chargé dans cette page, sa file
   * d'envoi peut encore partir (défilement, sortie de page) : on recharge la
   * page, qui repart sans GTM puisque le choix enregistré est un refus.
   */
  disableAnalytics() {
    setAnalyticsDisabled(true);
    removeAnalyticsCookies();
    this.fireEvent('analytics_disabled');
    if (typeof window.__isGTMLoaded === 'function' && window.__isGTMLoaded()) {
      this.reloadPage();
    }
  }

  /** Isolé pour les tests (jsdom n'implémente pas location.reload). */
  reloadPage() {
    window.location.reload();
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
    // Toast partagé (utils.js, concaténé avant ce fichier dans app.min.js) :
    // bouton de fermeture, pause au survol, animations d'entrée et de sortie.
    if (typeof showToast === 'function') {
      showToast(message, type);
      return;
    }

    // Repli si utils.js est absent : mêmes classes, animations portées par
    // le CSS (toastIn / .fade-out) — aucune écriture dans element.style.
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

    // Sortie animée par .fade-out (keyframes toastOut), puis retrait.
    setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  createToastContainer() {
    // Positionnement porté par #toast-container (shared-base.css).
    const container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
    return container;
  }

  // Public method to reset consent (useful for testing)
  resetConsent() {
    try { localStorage.removeItem(this.cookieName); } catch { /* stockage bloqué */ }
    removeConsentCookie();
    this.reloadPage();
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

// ─────────────────────────────────────────────────────────────────────────────
// Source unique du consentement, pour tout code hors de cette classe.
//
// sentry-init.js lisait sa propre clé ('cookie-consent') et sa propre forme
// ({ analytics }) : les deux étaient fausses, la garde ne se déclenchait donc
// jamais et Sentry se chargeait malgré un refus. Exposer un accesseur unique
// empêche la forme de diverger à nouveau — un seul endroit connaît le nom de la
// clé et la structure stockée.
// ─────────────────────────────────────────────────────────────────────────────
window.VH = window.VH || {};
window.VH.consent = {
  STORAGE_KEY: CONSENT_STORAGE_KEY,
  MAX_AGE_DAYS: CONSENT_MAX_AGE_DAYS,

  /** @returns {{preferences: object, timestamp: string}|null} choix valide, daté */
  record() {
    return readConsentRecord();
  },

  /** @returns {object|null} les préférences, ou null si aucun choix valide
   *  (absent, corrompu ou plus vieux que MAX_AGE_DAYS) */
  get() {
    const record = readConsentRecord();
    return record ? record.preferences : null;
  },

  /** Enregistre un choix (daté maintenant) ; renvoie l'enregistrement écrit. */
  save(preferences) {
    return writeConsentRecord(preferences);
  },

  /** true seulement si la finalité a été explicitement accordée. */
  allows(finalite) {
    const prefs = this.get();
    return Boolean(prefs && prefs[finalite] === true);
  },

  /** true si la finalité a été explicitement refusée (≠ pas encore répondu). */
  denies(finalite) {
    const prefs = this.get();
    return Boolean(prefs && prefs[finalite] === false);
  },
};

// Export conditionnel pour les tests unitaires (Node.js / jsdom)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    CookieConsent,
    bannerOverlap,
    isConsentExpired,
    readConsentRecord,
    writeConsentRecord,
    cookieDomainCandidates,
    removeAnalyticsCookies,
    analyticsMeasurementIds,
    CONSENT_MAX_AGE_DAYS,
  };
}
