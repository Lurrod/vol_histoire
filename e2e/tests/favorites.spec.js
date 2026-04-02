// e2e/tests/favorites.spec.js
const { test, expect } = require('@playwright/test');
const { loginViaApi } = require('../helpers/auth');

test.describe('Favoris', () => {
  test('utilisateur non connecté → page favoris redirige ou bloque', async ({ page }) => {
    await page.goto('/favorites');
    await page.waitForLoadState('networkidle');
    const url = page.url();
    const bodyText = await page.textContent('body');
    const isBlocked =
      url.includes('login') ||
      bodyText.includes('connecter') ||
      bodyText.includes('connexion') ||
      bodyText.toLowerCase().includes('login');
    expect(isBlocked).toBe(true);
  });

  test('utilisateur connecté → page favoris accessible', async ({ page }) => {
    await loginViaApi(page, 'titouan.borde.47@gmail.com', 'Titouan1.');
    await page.goto('/favorites');
    await page.waitForLoadState('networkidle');

    // La page ne doit pas rediriger vers login
    expect(page.url()).not.toContain('login');
    // Le conteneur de favoris doit être présent
    const container = page.locator('#favorites-container, #empty-state').first();
    await expect(container).toBeVisible({ timeout: 8000 });
  });
});
