// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  // Utilise une URL relative → même origine que le frontend → le cookie
  // refreshToken (HttpOnly, Path=/api, SameSite=Strict) est correctement
  // posé sur le BrowserContext et envoyé sur les navigations suivantes.
  const baseURL = page.context()._options?.baseURL || 'http://localhost:3000';
  const response = await page.request.post(`${baseURL}/api/login`, {
    data: { email, password },
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok() || !body.token) {
    throw new Error(`Login échoué (${response.status()}) : ${JSON.stringify(body)}`);
  }
  // Le cookie refreshToken est désormais dans le BrowserContext.
  // À la prochaine navigation, auth.init() appellera /api/refresh et
  // récupérera un access token frais en mémoire (pattern attendu).
  return body.token;
}

module.exports = { loginViaApi };
