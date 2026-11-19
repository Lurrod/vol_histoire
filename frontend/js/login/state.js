/* Connexion / inscription — contexte partagé par les modules VH.login.*.
 *
 * createContext() rassemble les éléments de la page et l'état mutable (une
 * bascule d'onglet en cours). Il renvoie null si un élément indispensable
 * manque : la page ne fait alors rien, comme avant le découpage.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.login = root.VH.login || {};

  function createContext(doc = document) {
    const byId = (id) => doc.getElementById(id);
    const els = {
      loginForm: byId('login-form'),
      registerForm: byId('register-form'),
      switchToRegister: byId('switch-to-register'),
      switchToLogin: byId('switch-to-login'),
      loginSlide: byId('login-slide'),
      registerSlide: byId('register-slide'),
      loginPassword: byId('login-password'),
      // Étapes par code (js/login/flow.js)
      container: doc.querySelector('.form-container'),
      openForgot: byId('open-forgot'),
      forgotSlide: byId('forgot-slide'),
      forgotForm: byId('forgot-form'),
      forgotEmail: byId('forgot-email'),
      codeSlide: byId('code-slide'),
      codeTitle: byId('code-title'),
      codeEmail: byId('code-email'),
      codeHint: byId('code-hint'),
      codeStatus: byId('code-status'),
      codeOtp: byId('code-otp'),
      codeResend: byId('code-resend'),
      codeChangeEmail: byId('code-change-email'),
      passwordSlide: byId('password-slide'),
      passwordTitle: byId('password-title'),
      passwordDesc: byId('password-desc'),
      passwordForm: byId('password-form'),
      passwordSubmitLabel: byId('password-submit-label'),
      newPassword: byId('new-password'),
      confirmPassword: byId('confirm-password'),
      // Contrôles de la tablist ARIA (motif WAI-ARIA APG)
      tabLogin: byId('tab-login'),
      tabRegister: byId('tab-register'),
    };

    if (!els.loginForm || !els.registerForm || !els.switchToRegister || !els.switchToLogin) {
      return null;
    }

    return {
      els,
      // pendingSwap : termine immédiatement une bascule animée en cours.
      // flow : parcours par code en cours ({ type, email, code }) ;
      // otp : champ de code (VH.otpInput) ; checking : vérification en vol.
      state: { pendingSwap: null, flow: null, otp: null, checking: false },
    };
  }

  VH.login.state = { createContext };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.state;
  }
})();
