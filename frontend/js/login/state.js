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
      registerPassword: byId('register-password'),
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
      state: { pendingSwap: null },
    };
  }

  VH.login.state = { createContext };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.login.state;
  }
})();
