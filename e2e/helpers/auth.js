// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  // Login via le FORMULAIRE réel.
  //
  // RACE CRITIQUE : login.js fait `await auth.init()` au DOMContentLoaded
  // (qui appelle /api/refresh). Le handler submit est bindé APRÈS cette
  // attente. Si on clique submit avant que init() ne se termine, le handler
  // n'est pas encore bindé → le formulaire submit nativement en GET vers
  // /login? et le test échoue. SOLUTION : waitForLoadState('networkidle')
  // après goto pour garantir que auth.init() + setupFormSwitching ont fini.
  await page.goto('/login');
  await page.waitForLoadState('networkidle');
  // Sécurité supplémentaire : attendre que le handler soit effectivement
  // attaché en vérifiant que login.js a fini son init (le bouton existe).
  await page.waitForSelector('#login-form button[type="submit"]', { state: 'visible' });

  await page.fill('#login-email', email);
  await page.fill('#login-password', password);
  await Promise.all([
    page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 10000 }),
    page.click('#login-form button[type="submit"]'),
  ]);
  await page.waitForLoadState('networkidle');
}

module.exports = { loginViaApi };
