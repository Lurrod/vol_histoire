// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  const response = await page.request.post('http://localhost:3000/api/login', {
    data: { email, password },
  });
  const body = await response.json();
  if (!body.token) {
    throw new Error(`Login échoué : ${JSON.stringify(body)}`);
  }
  // Stocker le token dans localStorage pour que auth.js le trouve
  await page.addInitScript((token) => {
    window.localStorage.setItem('authToken', token);
  }, body.token);
}

module.exports = { loginViaApi };
