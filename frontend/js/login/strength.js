/* Connexion / inscription — validation du mot de passe et jauge de force.
 *
 * validatePassword() délègue à isValidPassword() (utils.js), copie de la
 * règle du serveur, bornes 8–128 comprises ; strengthLevel() est la
 * correspondance pure score → libellé / couleur, testée sans DOM.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  function validatePassword(password) {
    return isValidPassword(password);
  }

  /** Score 0–100 (calculatePasswordStrength, utils.js) → clé i18n et couleurs. */
  function strengthLevel(strength) {
    if (strength === 0) {
      return { key: 'login.password_strength', text: 'var(--text-secondary)', fill: 'transparent' };
    }
    if (strength < 40) return { key: 'login.strength_weak', text: 'var(--accent)', fill: 'var(--accent)' };
    if (strength < 70) return { key: 'login.strength_medium', text: 'var(--warning)', fill: 'var(--warning)' };
    return { key: 'login.strength_strong', text: 'var(--success)', fill: 'var(--success)' };
  }

  function updatePasswordStrength(strength) {
    const strengthFill = document.querySelector('.strength-fill');
    const strengthText = document.querySelector('.strength-text');
    if (!strengthFill || !strengthText) return;

    const level = strengthLevel(strength);
    strengthFill.style.width = `${strength}%`;
    strengthText.textContent = i18n.t(level.key);
    strengthText.style.color = level.text;
    strengthFill.style.background = level.fill;
  }

  function setupPasswordStrength(ctx) {
    const input = ctx.els.registerPassword;
    if (!input) return;
    input.addEventListener('input', () => {
      updatePasswordStrength(calculatePasswordStrength(input.value));
    });
  }

  VH.login.strength = { validatePassword, strengthLevel, updatePasswordStrength, setupPasswordStrength };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.strength;
  }
})();
