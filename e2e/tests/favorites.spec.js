// e2e/tests/favorites.spec.js
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

test.describe('Favoris', () => {
  test('utilisateur non connecté → auth gate affiché', async ({ page }) => {
    await page.goto('/favorites');
    await page.waitForLoadState('networkidle');

    // favorites.js montre #auth-gate et cache #favorites-content si pas de token
    const gate = page.locator('#auth-gate');
    await expect(gate).not.toHaveClass(/hidden/, { timeout: 5000 });
  });

  test('utilisateur connecté → contenu favoris accessible', async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/favorites');

    // Pas de redirection vers login
    await expect(page).not.toHaveURL(/\/login/);

    // #favorites-content perd sa classe .hidden après init de favorites.js
    const content = page.locator('#favorites-content');
    await expect(content).not.toHaveClass(/hidden/, { timeout: 8000 });
  });
});
