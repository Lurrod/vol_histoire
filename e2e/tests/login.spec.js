// e2e/tests/login.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Login / Logout', () => {
  test('login réussi redirige vers l\'accueil', async ({ page }) => {
    await page.goto('/login');

    await page.fill('#login-email', 'test@vol-histoire.com');
    await page.fill('#login-password', 'TestPass123');
    await page.click('#login-form button[type="submit"]');

    // Après login, on est redirigé vers l'index
    await page.waitForURL('**/', { timeout: 5000 });
    await expect(page).not.toHaveURL(/login/);
  });

  test('email incorrect → message d\'erreur visible', async ({ page }) => {
    await page.goto('/login');

    await page.fill('#login-email', 'inexistant@vol-histoire.com');
    await page.fill('#login-password', 'WrongPass123');
    await page.click('#login-form button[type="submit"]');

    // Un toast ou message d'erreur doit apparaître
    const errorMsg = page.locator('.toast, .error-message, .form-error').first();
    await expect(errorMsg).toBeVisible({ timeout: 5000 });
  });

  test('champs vides → le formulaire ne soumet pas', async ({ page }) => {
    await page.goto('/login');
    await page.click('#login-form button[type="submit"]');

    // Toujours sur la page login
    await expect(page).toHaveURL(/login/);
  });
});
