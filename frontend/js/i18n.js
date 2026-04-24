/**
 * i18n — Internationalization module for Vol d'Histoire
 * Supports: fr (default), en
 * 
 * Usage in HTML:
 *   <span data-i18n="nav.home">Accueil</span>
 *   <input data-i18n-placeholder="hangar.search_placeholder" placeholder="Rechercher...">
 *   <meta data-i18n-content="meta.description" content="...">
 * 
 * Usage in JS:
 *   i18n.t('details.no_armament')  → returns translated string
 *   i18n.t('hangar.results', { count: 5 }) → "5 avions trouvés" / "5 aircraft found"
 *   i18n.currentLang → 'fr' | 'en'
 */

// eslint-disable-next-line no-unused-vars -- exposé via concaténation de bundle aux autres scripts
const i18n = (() => {
  const SUPPORTED_LANGS = ['fr', 'en'];
  const DEFAULT_LANG = 'fr';
  const STORAGE_KEY = 'vol-histoire-lang';
  let translations = {};
  let currentLang = DEFAULT_LANG;
  let isLoaded = false;

  /** Detect initial language */
  function detectLang() {
    // 1) ?lang= query parameter (SEO: each language has its own URL)
    const urlLang = new URLSearchParams(window.location.search).get('lang');
    if (urlLang && SUPPORTED_LANGS.includes(urlLang)) {
      localStorage.setItem(STORAGE_KEY, urlLang);
      return urlLang;
    }
    // 2) localStorage
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored && SUPPORTED_LANGS.includes(stored)) return stored;
    // 3) Browser lang
    const browserLang = (navigator.language || '').slice(0, 2);
    if (SUPPORTED_LANGS.includes(browserLang)) return browserLang;
    // 4) Default
    return DEFAULT_LANG;
  }

  /** Update URL, canonical and hreflang tags to reflect the current language */
  function updateLangMeta(lang) {
    // Update ?lang= in URL without reload
    const url = new URL(window.location.href);
    url.searchParams.set('lang', lang);
    window.history.replaceState(null, '', url.toString());

    // Update canonical
    const canonical = document.querySelector('link[rel="canonical"]');
    if (canonical) {
      const canonicalUrl = new URL(canonical.href);
      canonicalUrl.searchParams.set('lang', lang);
      canonical.href = canonicalUrl.toString();
    }

    // Update hreflang tags
    document.querySelectorAll('link[hreflang]').forEach(link => {
      const hl = link.getAttribute('hreflang');
      const linkUrl = new URL(link.href);
      if (hl === 'x-default') {
        linkUrl.searchParams.delete('lang');
      } else {
        linkUrl.searchParams.set('lang', hl);
      }
      link.href = linkUrl.toString();
    });
  }

  /** Load JSON translation file */
  async function loadTranslations(lang) {
    try {
      // Determine the base path relative to the page
      const basePath = document.querySelector('script[src*="i18n.js"]')?.src.replace(/js\/i18n\.js.*$/, '') || './';
      const url = `${basePath}locales/${lang}.json`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return await res.json();
    } catch {
      // Échec silencieux du chargement i18n
      return {};
    }
  }

  /** Get nested key from object: "nav.home" → translations.nav.home */
  function getNestedValue(obj, key) {
    return key.split('.').reduce((o, k) => (o && o[k] !== undefined ? o[k] : null), obj);
  }

  /** Global interpolation variables available in all translations */
  const GLOBAL_PARAMS = { year: new Date().getFullYear() };

  /** Translate a key, with optional interpolation: {count}, {name}, etc. */
  function t(key, params = {}) {
    let value = getNestedValue(translations, key);
    if (value === null || value === undefined) return key; // fallback = key
    if (typeof value === 'string') {
      const merged = { ...GLOBAL_PARAMS, ...params };
      Object.entries(merged).forEach(([k, v]) => {
        value = value.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
      });
    }
    return value;
  }

  /** Sanitize HTML — DOMPurify avec whitelist étendue pour supporter les
   *  blocs de contenu des pages légales (pages contrôlées 100% côté auteur,
   *  jamais d'input user injecté dedans). Les tags exécutables (script, style,
   *  iframe, object, embed, form, input) restent interdits. */
  const PURIFY_CONFIG = {
    ALLOWED_TAGS: [
      'a', 'strong', 'em', 'br', 'span', 'i', 'u', 'b',
      'p', 'ul', 'ol', 'li', 'h3', 'h4', 'h5', 'div',
    ],
    ALLOWED_ATTR: ['href', 'class', 'target', 'rel', 'id'],
  };

  function sanitizeHtml(html) {
    if (typeof DOMPurify !== 'undefined') {
      return DOMPurify.sanitize(html, PURIFY_CONFIG);
    }
    // Fallback si DOMPurify n'est pas chargé : échapper tout le HTML
    const div = document.createElement('div');
    div.textContent = html;
    return div.innerHTML;
  }

  /** Apply translations to all data-i18n elements in the DOM */
  function applyToDOM(root = document) {
    // Text content
    root.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      const translated = t(key);
      if (translated !== key) {
        // Preserve child icons (e.g. <i class="fas ..."></i>)
        const icon = el.querySelector('i.fas, i.fab, i.far');
        if (icon) {
          el.textContent = '';
          el.appendChild(icon);
          el.append(' ' + translated);
        } else {
          el.textContent = translated;
        }
      }
    });

    // innerHTML (for content with embedded HTML like links)
    // Seules les balises sûres sont autorisées (a, strong, em, br, span, i, u, b)
    root.querySelectorAll('[data-i18n-html]').forEach(el => {
      const key = el.getAttribute('data-i18n-html');
      const translated = t(key);
      if (translated !== key) el.innerHTML = sanitizeHtml(translated);
    });

    // Placeholders
    root.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
      const key = el.getAttribute('data-i18n-placeholder');
      const translated = t(key);
      if (translated !== key) el.placeholder = translated;
    });

    // aria-label
    root.querySelectorAll('[data-i18n-aria]').forEach(el => {
      const key = el.getAttribute('data-i18n-aria');
      const translated = t(key);
      if (translated !== key) el.setAttribute('aria-label', translated);
    });

    // <title>
    const titleKey = document.querySelector('title[data-i18n]');
    if (titleKey) {
      document.title = t(titleKey.getAttribute('data-i18n'));
    }

    // Update <html lang>
    document.documentElement.lang = currentLang;

    // Update lang toggle button
    const langBtn = document.getElementById('lang-toggle');
    if (langBtn) {
      langBtn.setAttribute('aria-label', currentLang === 'fr' ? 'Switch to English' : 'Passer en français');
    }

    // Marquer l'option active dans le dropdown
    document.querySelectorAll('.lang-option').forEach(opt => {
      opt.classList.toggle('active', opt.getAttribute('data-lang') === currentLang);
    });
  }

  /** Switch language */
  async function setLang(lang) {
    if (!SUPPORTED_LANGS.includes(lang)) return;
    const previous = currentLang;
    currentLang = lang;
    localStorage.setItem(STORAGE_KEY, lang);
    translations = await loadTranslations(lang);
    isLoaded = true;
    applyToDOM();
    updateLangMeta(lang);
    // Dispatch event so JS modules can react
    window.dispatchEvent(new CustomEvent('langChanged', { detail: { lang } }));
    // i18n BD : si la langue change effectivement et qu'on est sur une page
    // qui affiche du contenu DB (hangar, details, favorites, timeline, index),
    // on recharge pour refetch /api/* avec le bon ?lang=.
    // Les pages sans données DB (login, settings, legal) peuvent être exclues
    // pour éviter les reloads inutiles.
    if (previous && previous !== lang) {
      const path = window.location.pathname;
      const needsReload = /^\/$|^\/(hangar|details|favorites|timeline)/.test(path);
      if (needsReload) {
        // Petit délai pour que l'event langChanged soit traité par les listeners
        // et que le localStorage soit bien écrit avant le reload.
        setTimeout(() => window.location.reload(), 100);
      }
    }
  }

  /** Initialize — call once on DOMContentLoaded */
  async function init() {
    currentLang = detectLang();
    translations = await loadTranslations(currentLang);
    isLoaded = true;
    applyToDOM();
    updateLangMeta(currentLang);

    // Bind lang toggle button + dropdown
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('#lang-toggle');
      const option = e.target.closest('.lang-option');
      const langSwitch = document.querySelector('.lang-switch');

      if (btn) {
        e.preventDefault();
        const isOpen = langSwitch && langSwitch.classList.toggle('open');
        btn.classList.toggle('open', !!isOpen);
        btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        return;
      }

      if (option) {
        e.preventDefault();
        const lang = option.getAttribute('data-lang');
        if (lang) setLang(lang);
        if (langSwitch) langSwitch.classList.remove('open');
        const toggle = document.getElementById('lang-toggle');
        if (toggle) { toggle.classList.remove('open'); toggle.setAttribute('aria-expanded', 'false'); }
        return;
      }

      // Clic en dehors — fermer le dropdown
      if (langSwitch && langSwitch.classList.contains('open') && !e.target.closest('.lang-switch')) {
        langSwitch.classList.remove('open');
        const toggle = document.getElementById('lang-toggle');
        if (toggle) { toggle.classList.remove('open'); toggle.setAttribute('aria-expanded', 'false'); }
      }
    });
  }

  // Auto-init
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Public API
  return {
    t,
    setLang,
    applyToDOM,
    get currentLang() { return currentLang; },
    get isLoaded() { return isLoaded; },
    SUPPORTED_LANGS
  };
})();

// Expose globalement : `const` top-level dans un script classique ne crée pas
// window.i18n, alors que plusieurs modules (timeline.js, shared/card.js) testent
// `window.i18n` comme garde avant usage. Sans cette ligne, le garde échoue
// toujours et les fonctions tombent sur leur fallback FR.
window.i18n = i18n;
