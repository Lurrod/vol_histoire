'use strict';

/**
 * Verrouillage d'un compte après des échecs de mot de passe répétés. Mêmes
 * seuils pour la connexion (routes/auth.js) et pour la confirmation par le
 * mot de passe actuel des actions sensibles (routes/users.js, SEC-005) :
 * sans cela, ces routes offraient environ 200 essais par fenêtre et par IP.
 */
module.exports = Object.freeze({
  LOCKOUT_MAX_ATTEMPTS: 10,
  LOCKOUT_DURATION_MIN: 15,
});
