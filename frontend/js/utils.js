/* ======================================================================
   VOL D'HISTOIRE — UTILITAIRES PARTAGÉS
   Fonctions réutilisées par toutes les pages.
   Chargé avant les scripts de page via <script defer>.
   ====================================================================== */
/* global DOMParser */

/**
 * Échappe le HTML pour éviter les injections XSS.
 * Utilisable dans les templates : `${escapeHtml(userData.name)}`
 * Sûr aussi dans un attribut entre guillemets (`href="${escapeHtml(url)}"`) :
 * les guillemets doubles et simples sont échappés.
 */
function escapeHtml(text) {
  if (text == null) return '';
  const escapes = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', '\'': '&#39;' };
  return String(text).replace(/[&<>"']/g, (c) => escapes[c]);
}

/**
 * Assigne du HTML à un élément avec sanitization DOMPurify (défense en profondeur).
 *
 * Usage RECOMMANDÉ pour tout innerHTML qui interpole des données utilisateur,
 * MÊME si escapeHtml() est déjà utilisé dans le template. C'est une couche
 * supplémentaire qui protège contre les bugs futurs (oubli d'escape, regex
 * cassé, etc.).
 *
 * Si DOMPurify n'est pas disponible (CDN bloqué, dev offline), fallback sur
 * innerHTML brut + log un warning. Le code ne crash pas.
 *
 * @param {HTMLElement} el - élément cible
 * @param {string} html - chaîne HTML (peut contenir des balises)
 */
function safeSetHTML(el, html) {
  if (!el) return;
  if (typeof DOMPurify !== 'undefined' && DOMPurify.sanitize) {
    el.innerHTML = DOMPurify.sanitize(html, {
      // Configuration permissive : autorise les balises HTML standards + Font Awesome
      // + landmarks ARIA (aside/section/nav/header/footer/main) pour préserver
      // les rôles a11y du fragment injecté (ex: cookie-banner = <aside>).
      ALLOWED_TAGS: ['div', 'span', 'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
                     'a', 'i', 'b', 'strong', 'em', 'br', 'hr', 'img',
                     'ul', 'ol', 'li', 'button', 'input', 'label', 'option',
                     'table', 'tr', 'td', 'th', 'thead', 'tbody',
                     'aside', 'section', 'nav', 'header', 'footer', 'main', 'article'],
      // data-i18n* : attributs déclaratifs lus par i18n.applyToDOM pour
      // traduire le contenu injecté (sans ces attributs, le banner reste figé en FR).
      // label/for/checked/disabled : interrupteurs du bandeau cookies
      // (cookie-consent.html) — sans eux, les cookies essentiels arrivaient
      // décochés et modifiables, le marketing activable, et sans libellé.
      ALLOWED_ATTR: ['class', 'id', 'href', 'src', 'alt', 'title', 'data-id',
                     'data-user-id', 'data-value', 'value', 'type', 'role',
                     'for', 'checked', 'disabled',
                     'aria-label', 'aria-labelledby', 'aria-hidden', 'aria-live',
                     'tabindex', 'width', 'height', 'loading',
                     'data-i18n', 'data-i18n-html', 'data-i18n-aria',
                     'data-i18n-alt', 'data-i18n-placeholder', 'data-i18n-title'],
    });
    return;
  }

  // Fallback sans DOMPurify : parse via DOMParser puis supprime
  // scripts/iframes/objets + handlers on* + URLs javascript:. Moins strict
  // que DOMPurify mais coupe les principaux vecteurs XSS.
  _safeReport('warn', '[safeSetHTML] DOMPurify indisponible, fallback DOMParser scrub');
  try {
    const doc = new DOMParser().parseFromString(html, 'text/html');
    doc.querySelectorAll('script, iframe, object, embed, link[rel="import"], meta[http-equiv]')
      .forEach(n => n.remove());
    doc.querySelectorAll('*').forEach(node => {
      for (const attr of Array.from(node.attributes)) {
        const name = attr.name.toLowerCase();
        const val = (attr.value || '').trim().toLowerCase();
        if (name.startsWith('on') || val.startsWith('javascript:') || val.startsWith('data:text/html')) {
          node.removeAttribute(attr.name);
        }
      }
    });
    el.replaceChildren(...Array.from(doc.body.childNodes));
  } catch (e) {
    _safeReport('error', '[safeSetHTML] fallback DOMParser a échoué, injection refusée', e);
    el.textContent = '';
  }
}

/**
 * Reporte un événement de chemin de panic (DOMPurify down, etc.) en privilégiant
 * Sentry quand il est disponible (cf. js/sentry-init.js, attaché à window.Sentry
 * post-LCP). Fallback console sinon — utile en dev/local et si Sentry n'a pas
 * encore fini de booter quand le panic se déclenche. Évite de polluer la console
 * des visiteurs en prod tout en gardant la visibilité côté monitoring.
 */
function _safeReport(level, message, error) {
  const S = (typeof window !== 'undefined') ? window.Sentry : null;
  if (S && typeof S.captureMessage === 'function') {
    if (error && typeof S.captureException === 'function') {
      S.captureException(error);
    } else {
      S.captureMessage(message, level === 'error' ? 'error' : 'warning');
    }
    return;
  }
  // Fallback diag quand Sentry est indisponible (dev/local ou panic pré-init).
  if (level === 'error') console.error(message, error);
  else console.warn(message);
}

// Durées d'affichage par défaut : une erreur se lit plus longuement.
const TOAST_DURATION_DEFAULT = 3000;
const TOAST_DURATION_ERROR = 6000;
// Durée de l'animation de sortie (keyframes toastOut, shared-base.css).
const TOAST_EXIT_MS = 300;

/** Libellé traduit si i18n est chargé, sinon repli français. */
function _toastLabel(key, fallback) {
  const t = (typeof window !== 'undefined' && window.i18n && typeof window.i18n.t === 'function')
    ? window.i18n.t(key) : null;
  return t && t !== key ? t : fallback;
}

/**
 * Affiche un toast de notification.
 * Fonctionne avec un #toast-container si présent, sinon s'ajoute au body.
 * Bouton de fermeture, minuterie suspendue au survol et au focus, erreurs
 * affichées plus longtemps (6 s contre 3 s) sauf durée explicite.
 */
function showToast(message, type = 'info', duration) {
  const container = document.getElementById('toast-container') || document.body;
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  // Une erreur interrompt la lecture d'écran ; le reste est annoncé poliment.
  toast.setAttribute('role', type === 'error' ? 'alert' : 'status');

  const icon = type === 'success' ? 'check-circle' :
               type === 'error' ? 'exclamation-circle' :
               'info-circle';

  const span = document.createElement('span');
  span.className = 'toast-message';
  span.textContent = message;
  toast.innerHTML = `<i class="fas fa-${icon}" aria-hidden="true"></i>`;
  toast.appendChild(span);

  const closeBtn = document.createElement('button');
  closeBtn.type = 'button';
  closeBtn.className = 'toast-close';
  closeBtn.setAttribute('aria-label', _toastLabel('common.close', 'Fermer'));
  closeBtn.innerHTML = '<i class="fas fa-times" aria-hidden="true"></i>';
  toast.appendChild(closeBtn);

  container.appendChild(toast);

  const total = Number.isFinite(duration) && duration > 0 ? duration
    : (type === 'error' ? TOAST_DURATION_ERROR : TOAST_DURATION_DEFAULT);
  let remaining = total;
  let startedAt = 0;
  let timer = null;
  let dismissed = false;

  function dismiss() {
    if (dismissed) return;
    dismissed = true;
    clearTimeout(timer);
    toast.classList.add('fade-out');
    setTimeout(() => toast.remove(), TOAST_EXIT_MS);
  }

  function start() {
    if (dismissed) return;
    startedAt = Date.now();
    timer = setTimeout(dismiss, remaining);
  }

  function pause() {
    if (dismissed || timer === null) return;
    clearTimeout(timer);
    timer = null;
    remaining = Math.max(remaining - (Date.now() - startedAt), 0);
  }

  function resume() {
    // Reste en pause tant que le pointeur survole ou que le focus est dedans.
    if (dismissed || timer !== null) return;
    if (toast.matches(':hover') || toast.contains(document.activeElement)) return;
    // Un minimum d'une seconde pour laisser le temps de relire.
    remaining = Math.max(remaining, 1000);
    start();
  }

  closeBtn.addEventListener('click', dismiss);
  toast.addEventListener('mouseenter', pause);
  toast.addEventListener('mouseleave', resume);
  toast.addEventListener('focusin', pause);
  toast.addEventListener('focusout', () => setTimeout(resume, 0));

  start();
  return { dismiss };
}

/**
 * Anime un compteur de 0 à target sur un élément DOM.
 */
function animateNumber(el, target, duration = 1400) {
  if (!el) return;
  const start = performance.now();
  function step(now) {
    const progress = Math.min((now - start) / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    el.textContent = Math.round(eased * target);
    if (progress < 1) requestAnimationFrame(step);
  }
  requestAnimationFrame(step);
}

/**
 * Configure le toggle de visibilité d'un ou plusieurs champs mot de passe
 * (le second sert aux champs de confirmation qui suivent le premier).
 *
 * L'icône est remplacée, jamais modifiée : icons.js convertit chaque
 * `<i class="fas fa-…">` en `<svg class="icon icon-…">` au chargement, et un
 * changement de classe sur ce SVG ne redessine rien. Le nouveau `<i>` inséré
 * est converti à son tour par le MutationObserver d'icons.js.
 */
function setupPasswordToggle(buttonEl, inputEl, ...linkedInputs) {
  if (!buttonEl || !inputEl) return;
  buttonEl.setAttribute('aria-pressed', 'false');
  buttonEl.addEventListener('click', () => {
    const visible = inputEl.type === 'password';
    [inputEl, ...linkedInputs].forEach((el) => { if (el) el.type = visible ? 'text' : 'password'; });
    buttonEl.setAttribute('aria-pressed', String(visible));

    const icon = document.createElement('i');
    icon.className = `fas ${visible ? 'fa-eye' : 'fa-eye-slash'}`;
    icon.setAttribute('aria-hidden', 'true');
    const current = buttonEl.querySelector('svg.icon, i');
    if (current) current.replaceWith(icon);
    else buttonEl.appendChild(icon);
  });
}

/**
 * Calcule la force d'un mot de passe (0–100).
 * Critères : longueur ≥8, minuscule, majuscule, chiffre, longueur ≥12, caractère spécial.
 */
function calculatePasswordStrength(password) {
  let strength = 0;
  if (password.length >= 8) strength += 25;
  if (/[a-z]/.test(password)) strength += 20;
  if (/[A-Z]/.test(password)) strength += 20;
  if (/[0-9]/.test(password)) strength += 15;
  if (password.length >= 12) strength += 10;
  if (/[^a-zA-Z0-9]/.test(password)) strength += 10;
  return Math.min(strength, 100);
}

/**
 * Valide un email — même regex que le backend (validators.js).
 * Partie locale : alphanum + _%+-, pas de point en début/fin ni consécutifs.
 * Domaine : TLD alphabétique ≥ 2 caractères. Max 255 chars.
 */
function isValidEmail(email) {
  if (typeof email !== 'string' || email.length > 255) return false;
  return /^[a-zA-Z0-9_%+\-]+(\.[a-zA-Z0-9_%+\-]+)*@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,}$/.test(email);
}

/**
 * Focus trap — empêche le focus de sortir d'un conteneur (modal, dialog).
 * Retourne une fonction cleanup() pour détacher le listener.
 *
 * @param {HTMLElement} container — élément contenant les éléments focusables
 * @returns {{ destroy: () => void }} — appeler destroy() quand la modal se ferme
 */
function trapFocus(container, options = {}) {
  if (!container) return { destroy() {} };

  const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';
  const onEscape = typeof options.onEscape === 'function' ? options.onEscape : null;

  function handler(e) {
    if (e.key === 'Escape' && onEscape) {
      e.preventDefault();
      onEscape();
      return;
    }
    if (e.key !== 'Tab') return;

    const focusable = Array.from(container.querySelectorAll(FOCUSABLE)).filter(el => el.offsetParent !== null);
    if (focusable.length === 0) return;

    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (e.shiftKey) {
      if (document.activeElement === first) {
        e.preventDefault();
        last.focus();
      }
    } else {
      if (document.activeElement === last) {
        e.preventDefault();
        first.focus();
      }
    }
  }

  container.addEventListener('keydown', handler);

  // Focus le premier élément focusable
  requestAnimationFrame(() => {
    const first = container.querySelector(FOCUSABLE);
    if (first) first.focus();
  });

  return { destroy() { container.removeEventListener('keydown', handler); } };
}

/* aria-describedby peut lister plusieurs identifiants (aide permanente +
 * erreur, WCAG 3.3.2). Ces helpers n'ajoutent et ne retirent que celui de
 * l'erreur : une aide déjà référencée n'est jamais écrasée ni vidée. */
function _describedByIds(inputEl) {
  return (inputEl.getAttribute('aria-describedby') || '').split(/\s+/).filter(Boolean);
}

function _setDescribedByIds(inputEl, ids) {
  if (ids.length) inputEl.setAttribute('aria-describedby', ids.join(' '));
  else inputEl.removeAttribute('aria-describedby');
}

/** Élément d'erreur du champ : un `.form-error` déjà référencé, sinon celui
 *  nommé `<id>-error` (présent dans le HTML mais pas encore référencé). */
function _findErrorElement(inputEl, ids) {
  for (const id of ids) {
    const el = document.getElementById(id);
    if (el && el.classList.contains('form-error')) return el;
  }
  return inputEl.id ? document.getElementById(inputEl.id + '-error') : null;
}

/**
 * Affiche une erreur en ligne sous un champ de formulaire.
 * Ajoute aria-invalid="true" et lie le message via aria-describedby
 * (placé en tête, devant les éventuelles aides déjà référencées).
 */
function setFieldError(inputEl, message) {
  if (!inputEl) return;
  inputEl.setAttribute('aria-invalid', 'true');

  const ids = _describedByIds(inputEl);
  let errEl = _findErrorElement(inputEl, ids);

  if (!errEl) {
    errEl = document.createElement('span');
    errEl.id = inputEl.id + '-error';
    errEl.className = 'form-error';
    errEl.setAttribute('role', 'alert');
    inputEl.parentNode.insertBefore(errEl, inputEl.nextSibling);
  }
  if (!ids.includes(errEl.id)) _setDescribedByIds(inputEl, [errEl.id, ...ids]);

  errEl.textContent = message;

  // transitions-dev (error state shake) : rejoue le shake depuis une base
  // propre (retrait → reflow → ré-ajout). Les durées sont lues sur les
  // tokens CSS (--shake-dur-a/-b) pour rester synchronisées. Le respect de
  // prefers-reduced-motion est assuré par le guard CSS de .is-shaking.
  inputEl.classList.remove('is-shaking');
  void inputEl.offsetWidth; // force reflow
  inputEl.classList.add('is-shaking');
  const cs = window.getComputedStyle(document.documentElement);
  const ms = (name, fb) => {
    const v = parseFloat(cs.getPropertyValue(name));
    return Number.isFinite(v) ? v : fb;
  };
  const shakeMs = ms('--shake-dur-a', 80) * 2 + ms('--shake-dur-b', 60) * 2;
  setTimeout(() => inputEl.classList.remove('is-shaking'), shakeMs + 20);
}

/**
 * Retire l'erreur en ligne d'un champ de formulaire : vide le message et
 * retire son identifiant d'aria-describedby, en laissant les autres.
 */
function clearFieldError(inputEl) {
  if (!inputEl) return;
  inputEl.removeAttribute('aria-invalid');
  inputEl.classList.remove('is-shaking');
  const ids = _describedByIds(inputEl);
  const kept = ids.filter((id) => {
    const el = document.getElementById(id);
    if (!el || !el.classList.contains('form-error')) return true;
    el.textContent = '';
    return false;
  });
  if (kept.length !== ids.length) _setDescribedByIds(inputEl, kept);
}

/**
 * transitions-dev (number pop-in) — réécrit el avec des <span.t-digit>
 * (les 2 derniers caractères décalés via data-stagger) puis rejoue
 * l'animation d'entrée. prefers-reduced-motion géré par le guard CSS.
 */
function setNumberPopIn(el, value) {
  if (!el) return;
  const chars = String(value).split('');
  el.classList.add('t-digit-group');
  el.classList.remove('is-animating');
  el.replaceChildren();
  chars.forEach((ch, i) => {
    const span = document.createElement('span');
    span.className = 't-digit';
    span.textContent = ch;
    if (i === chars.length - 2) span.dataset.stagger = '1';
    else if (i === chars.length - 1) span.dataset.stagger = '2';
    el.appendChild(span);
  });
  void el.offsetHeight; // reflow → rejoue l'animation
  el.classList.add('is-animating');
}

// Export conditionnel pour les tests unitaires (Node.js)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { escapeHtml, safeSetHTML, showToast, animateNumber, setNumberPopIn, setupPasswordToggle, isValidEmail, calculatePasswordStrength, trapFocus, setFieldError, clearFieldError };
}
