// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  // URL relative : page.request hérite automatiquement du baseURL du context.
  // Le cookie refreshToken (HttpOnly, Path=/api, SameSite=Strict) est posé
  // sur le BrowserContext et envoyé sur les navigations same-origin suivantes.
  const response = await page.request.post('/api/login', {
    data: { email, password },
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok() || !body.token) {
    throw new Error(`Login échoué (${response.status()}) : ${JSON.stringify(body)}`);
  }
  // Force la première navigation (load + auth.init() → /api/refresh) pour
  // garantir que l'access token est en mémoire AVANT que le test ne goto une page.
  // Sinon certaines pages (settings) peuvent rendre avant que le rôle soit connu.
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  return body.token;
}

module.exports = { loginViaApi };
