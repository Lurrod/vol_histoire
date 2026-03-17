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

const i18n = (() => {
  const SUPPORTED_LANGS = ['fr', 'en'];
  const DEFAULT_LANG = 'fr';
  const STORAGE_KEY = 'vol-histoire-lang';
  let translations = {};
  let currentLang = DEFAULT_LANG;
  let isLoaded = false;

  /** Detect initial language */
  function detectLang() {
    // 1) localStorage
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored && SUPPORTED_LANGS.includes(stored)) return stored;
    // 2) Browser lang
    const browserLang = (navigator.language || '').slice(0, 2);
    if (SUPPORTED_LANGS.includes(browserLang)) return browserLang;
    // 3) Default
    return DEFAULT_LANG;
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
    } catch (err) {
      console.error(`[i18n] Failed to load ${lang}.json:`, err);
      return {};
    }
  }

  /** Get nested key from object: "nav.home" → translations.nav.home */
  function getNestedValue(obj, key) {
    return key.split('.').reduce((o, k) => (o && o[k] !== undefined ? o[k] : null), obj);
  }

  /** Translate a key, with optional interpolation: {count}, {name}, etc. */
  function t(key, params = {}) {
    let value = getNestedValue(translations, key);
    if (value === null || value === undefined) return key; // fallback = key
    if (typeof value === 'string' && params) {
      Object.entries(params).forEach(([k, v]) => {
        value = value.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
      });
    }
    return value;
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
    root.querySelectorAll('[data-i18n-html]').forEach(el => {
      const key = el.getAttribute('data-i18n-html');
      const translated = t(key);
      if (translated !== key) el.innerHTML = translated;
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
      langBtn.textContent = currentLang === 'fr' ? 'EN' : 'FR';
      langBtn.setAttribute('aria-label', currentLang === 'fr' ? 'Switch to English' : 'Passer en français');
    }
  }

  /** Switch language */
  async function setLang(lang) {
    if (!SUPPORTED_LANGS.includes(lang)) return;
    currentLang = lang;
    localStorage.setItem(STORAGE_KEY, lang);
    translations = await loadTranslations(lang);
    isLoaded = true;
    applyToDOM();
    // Dispatch event so JS modules can react
    window.dispatchEvent(new CustomEvent('langChanged', { detail: { lang } }));
  }

  /** Initialize — call once on DOMContentLoaded */
  async function init() {
    currentLang = detectLang();
    translations = await loadTranslations(currentLang);
    isLoaded = true;
    applyToDOM();

    // Bind lang toggle button
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('#lang-toggle');
      if (btn) {
        e.preventDefault();
        const newLang = currentLang === 'fr' ? 'en' : 'fr';
        setLang(newLang);
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
