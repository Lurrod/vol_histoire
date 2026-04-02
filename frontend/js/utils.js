/* ======================================================================
   VOL D'HISTOIRE — UTILITAIRES PARTAGÉS
   Fonctions réutilisées par toutes les pages.
   Chargé avant les scripts de page via <script defer>.
   ====================================================================== */

/**
 * Échappe le HTML pour éviter les injections XSS.
 */
function escapeHtml(text) {
  if (text == null) return '';
  const div = document.createElement('div');
  div.textContent = String(text);
  return div.innerHTML;
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

// Export conditionnel pour les tests unitaires (Node.js)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { escapeHtml, showToast, animateNumber, setupPasswordToggle };
}
