// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  // Login via le FORMULAIRE réel → garantit que :
  //  1. Le cookie refreshToken est posé par une vraie navigation browser
  //  2. auth.setToken() est appelé en mémoire JS du contexte page
  //  3. login.js gère le redirect vers /
  // Plus fiable que page.request.post (qui souffre de subtilités cookie context).
  await page.goto('/login');
  await page.fill('#login-email', email);
  await page.fill('#login-password', password);
  await Promise.all([
    page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 10000 }),
    page.click('#login-form button[type="submit"]'),
  ]);
  await page.waitForLoadState('networkidle');
}

module.exports = { loginViaApi };
