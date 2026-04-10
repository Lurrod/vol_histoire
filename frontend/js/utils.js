/* ======================================================================
   VOL D'HISTOIRE — UTILITAIRES PARTAGÉS
   Fonctions réutilisées par toutes les pages.
   Chargé avant les scripts de page via <script defer>.
   ====================================================================== */

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
                     'loading', 'style'],
    });
  } else {
    // eslint-disable-next-line no-console
    console.warn('[safeSetHTML] DOMPurify indisponible, fallback innerHTML brut');
    el.innerHTML = html;
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

// Export conditionnel pour les tests unitaires (Node.js)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { escapeHtml, safeSetHTML, showToast, animateNumber, setupPasswordToggle, isValidEmail, calculatePasswordStrength };
}
