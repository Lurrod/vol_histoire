/* Gabarit de la page de connexion pour les tests (login.test.js, login-flow.test.js) :
 * onglets, connexion, inscription et étapes par code (mot de passe oublié, code,
 * nouveau mot de passe). */
const LOGIN_DOM = `
  <section class="form-container">
    <div role="tablist">
      <button type="button" role="tab" id="tab-login" class="form-tab active" aria-controls="login-slide" aria-selected="true" tabindex="0">Identification</button>
      <button type="button" role="tab" id="tab-register" class="form-tab" aria-controls="register-slide" aria-selected="false" tabindex="-1">Enregistrement</button>
    </div>
    <div class="form-slide form-login active" id="login-slide" role="tabpanel">
      <form id="login-form">
        <input type="email" id="login-email">
        <div><input type="password" id="login-password"><button type="button" id="toggle-login-password"><i class="fas fa-eye-slash"></i></button></div>
        <button type="submit" class="btn-submit"><span>Se connecter</span></button>
      </form>
      <button type="button" class="switch-form" id="switch-to-register">Créer un compte</button>
    </div>
    <div class="form-slide form-register" id="register-slide" role="tabpanel" inert>
      <form id="register-form">
        <input type="text" id="register-name">
        <input type="email" id="register-email">
        <input type="checkbox" id="accept-terms">
        <button type="submit" class="btn-submit"><span>Créer mon compte</span></button>
      </form>
      <button type="button" class="switch-form" id="switch-to-login">Se connecter</button>
    </div>
    <section class="form-slide form-flow" id="forgot-slide" inert>
      <form id="forgot-form"><input type="email" id="forgot-email"><button type="submit" class="btn-submit"><span>Recevoir un code</span></button></form>
      <button type="button" class="flow-back" data-back="login">Retour</button>
    </section>
    <section class="form-slide form-flow" id="code-slide" inert>
      <h2 id="code-title" data-i18n="login.code_title_verify">Activez</h2>
      <p><strong id="code-email"></strong></p>
      <div id="code-otp"></div>
      <p id="code-hint" data-i18n="login.code_hint_verify">30 min</p>
      <p id="code-status" role="status"></p>
      <button type="button" id="code-resend"><span data-i18n="login.code_resend">Renvoyer</span></button>
      <button type="button" id="code-change-email">Changer</button>
    </section>
    <section class="form-slide form-flow" id="password-slide" inert>
      <h2 id="password-title" data-i18n="login.password_title_verify">Mot de passe</h2>
      <p id="password-desc" data-i18n="login.password_desc_verify">Dernière étape</p>
      <form id="password-form">
        <div><input type="password" id="new-password" aria-describedby="new-password-hint"><button type="button" id="toggle-new-password"><i class="fas fa-eye-slash"></i></button></div>
        <span id="new-password-error" class="form-error" role="alert"></span>
        <p id="new-password-hint">Minimum 8 caractères avec 1 majuscule, 1 minuscule et 1 chiffre.</p>
        <div class="password-strength"><div class="strength-bar"><div class="strength-fill"></div></div><span class="strength-text">Force</span></div>
        <input type="password" id="confirm-password">
        <span id="confirm-password-error" class="form-error" role="alert"></span>
        <button type="submit" class="btn-submit"><span id="password-submit-label" data-i18n="login.password_submit_verify">Activer</span></button>
      </form>
    </section>
    <div class="auth-visual"><div class="auth-photo-media"></div></div><span id="stat-airplanes"></span><span id="stat-years"></span><span id="stat-years-label"></span><span id="stat-countries"></span>
  </section>`;

module.exports = { LOGIN_DOM };
