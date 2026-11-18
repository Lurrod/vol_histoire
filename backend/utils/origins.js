/**
 * Origines acceptées par CORS.
 *
 * Production : uniquement ALLOWED_ORIGINS (ou les valeurs par défaut).
 * Ailleurs (développement, test) : on ajoute le serveur local ouvert par
 * localhost OU par 127.0.0.1 sur son port — sans quoi un site ouvert par
 * http://127.0.0.1:3000 voyait toutes ses requêtes refusées (403 « Origine
 * non autorisée ») et la connexion était impossible.
 */
const DEFAULT_ORIGINS = ['http://localhost:3000', 'https://vol-histoire.titouan-borde.com'];

/**
 * @param {Record<string, string|undefined>} env  process.env (ou équivalent)
 * @returns {string[]}
 */
function allowedOrigins(env) {
  const configured = env.ALLOWED_ORIGINS
    ? env.ALLOWED_ORIGINS.split(',').map(o => o.trim()).filter(Boolean)
    : DEFAULT_ORIGINS.slice();
  if (env.NODE_ENV === 'production') return configured;
  const port = env.PORT || '3000';
  const local = [`http://localhost:${port}`, `http://127.0.0.1:${port}`];
  return configured.concat(local.filter(o => !configured.includes(o)));
}

module.exports = { allowedOrigins, DEFAULT_ORIGINS };
