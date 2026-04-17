/* ======================================================================
   VOL D'HISTOIRE — UTILITAIRES PARTAGÉS
   Fonctions réutilisées par toutes les pages.
   Chargé avant les scripts de page via <script defer>.
   ====================================================================== */
/* global DOMParser */

/**
 * Échappe le HTML pour éviter les injections XSS.
 * Utilisable dans les templates : `${escapeHtml(userData.name)}`
 */
function escapeHtml(text) {
  if (text == null) return '';
  const div = document.createElement('div');
  div.textContent = String(text);
  return div.innerHTML;
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
      ALLOWED_TAGS: ['div', 'span', 'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
                     'a', 'i', 'b', 'strong', 'em', 'br', 'hr', 'img',
                     'ul', 'ol', 'li', 'button', 'input', 'option',
                     'table', 'tr', 'td', 'th', 'thead', 'tbody'],
      ALLOWED_ATTR: ['class', 'id', 'href', 'src', 'alt', 'title', 'data-id',
                     'data-user-id', 'data-value', 'value', 'type', 'role',
                     'aria-label', 'aria-hidden', 'tabindex', 'width', 'height',
                     'loading'],
    });
    return;
  }

  // Fallback sans DOMPurify : parse via DOMParser puis supprime
  // scripts/iframes/objets + handlers on* + URLs javascript:. Moins strict
  // que DOMPurify mais coupe les principaux vecteurs XSS.
  console.warn('[safeSetHTML] DOMPurify indisponible, fallback DOMParser scrub');
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
    console.error('[safeSetHTML] fallback DOMParser a échoué, injection refusée', e);
    el.textContent = '';
  }
}

/**
 * Affiche un toast de notification.
 * Fonctionne avec un #toast-container si présent, sinon s'ajoute au body.
 */
function showToast(message, type = 'info', duration = 3000) {
  const container = document.getElementById('toast-container') || document.body;
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.setAttribute('role', 'status');

  const icon = type === 'success' ? 'check-circle' :
               type === 'error' ? 'exclamation-circle' :
               'info-circle';

  const span = document.createElement('span');
  span.textContent = message;
  toast.innerHTML = `<i class="fas fa-${icon}" aria-hidden="true"></i>`;
  toast.appendChild(span);

  container.appendChild(toast);

  setTimeout(() => {
    toast.classList.add('fade-out');
    setTimeout(() => toast.remove(), 300);
  }, duration);
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
 * Configure le toggle de visibilité d'un champ mot de passe.
 */
function setupPasswordToggle(buttonEl, inputEl) {
  if (!buttonEl || !inputEl) return;
  buttonEl.addEventListener('click', () => {
    const icon = buttonEl.querySelector('i');
    if (inputEl.type === 'password') {
      inputEl.type = 'text';
      icon.classList.replace('fa-eye-slash', 'fa-eye');
    } else {
      inputEl.type = 'password';
      icon.classList.replace('fa-eye', 'fa-eye-slash');
    }
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

/**
 * Affiche une erreur en ligne sous un champ de formulaire.
 * Ajoute aria-invalid="true" et lie le message via aria-describedby.
 */
function setFieldError(inputEl, message) {
  if (!inputEl) return;
  inputEl.setAttribute('aria-invalid', 'true');

  let errorId = inputEl.getAttribute('aria-describedby');
  let errEl = errorId ? document.getElementById(errorId) : null;

  if (!errEl) {
    errorId = inputEl.id + '-error';
    errEl = document.createElement('span');
    errEl.id = errorId;
    errEl.className = 'form-error';
    errEl.setAttribute('role', 'alert');
    inputEl.parentNode.insertBefore(errEl, inputEl.nextSibling);
    inputEl.setAttribute('aria-describedby', errorId);
  }

  errEl.textContent = message;
}

/**
 * Retire l'erreur en ligne d'un champ de formulaire.
 */
function clearFieldError(inputEl) {
  if (!inputEl) return;
  inputEl.removeAttribute('aria-invalid');
  const errorId = inputEl.getAttribute('aria-describedby');
  if (errorId) {
    const errEl = document.getElementById(errorId);
    if (errEl && errEl.classList.contains('form-error')) {
      errEl.textContent = '';
    }
  }
}

// Export conditionnel pour les tests unitaires (Node.js)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { escapeHtml, safeSetHTML, showToast, animateNumber, setupPasswordToggle, isValidEmail, calculatePasswordStrength, setFieldError, clearFieldError };
}
