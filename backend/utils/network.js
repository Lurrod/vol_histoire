/**
 * Exposition réseau du backend.
 *
 * En production, Apache est le seul point d'entrée : Node n'écoute que sur la
 * boucle locale, sinon le port 3000 est joignable en HTTP clair depuis
 * Internet et contourne TLS, logs et restrictions d'Apache.
 * HOST=0.0.0.0 reste possible pour un usage explicite (conteneur, LAN de dev).
 */

const DEFAULT_LISTEN_HOST = '127.0.0.1';

function resolveListenHost(env = process.env) {
  return env.HOST || DEFAULT_LISTEN_HOST;
}

module.exports = { resolveListenHost, DEFAULT_LISTEN_HOST };
