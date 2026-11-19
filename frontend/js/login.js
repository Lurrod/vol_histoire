/* Connexion / inscription — point d'entrée.
 * Les modules VH.login.* (js/login/) sont concaténés avant ce fichier dans
 * login.min.js (scripts/build-js.js).
 */
document.addEventListener('DOMContentLoaded', async () => {
  const ctx = VH.login.state.createContext(document);
  // Éléments de formulaire requis absents : rien à brancher.
  if (!ctx) return;

  await auth.init();

  // Afficher / masquer les mots de passe (utils.js)
  setupPasswordToggle(document.getElementById('toggle-login-password'), ctx.els.loginPassword);
  // Le bouton du nouveau mot de passe affiche aussi sa confirmation.
  setupPasswordToggle(document.getElementById('toggle-new-password'), ctx.els.newPassword, ctx.els.confirmPassword);
  VH.login.tabs.setupFormSwitching(ctx);
  VH.login.strength.setupPasswordStrength(ctx);
  // Mot de passe oublié, code reçu par email, choix du mot de passe.
  VH.login.flow.setup(ctx);
  // Pas de redirection si une session existe : on peut vouloir se reconnecter
  // avec un autre compte depuis cette page. Navigation, déconnexion → nav.js.
  VH.login.ui.fetchStats();
  VH.login.visual.load(document.querySelector('.auth-visual'));

  VH.login.forms.bindForms(ctx);
});
