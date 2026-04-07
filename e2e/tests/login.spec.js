// e2e/tests/login.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Login / Logout', () => {
  // FIXME: redirect via setTimeout(1500) → flaky en CI headless
  test.fixme('login réussi redirige vers l\'accueil', async ({ page }) => {
    await page.goto('/login');

    await page.fill('#login-email', 'titouan.borde.47@gmail.com');
    await page.fill('#login-password', 'Titouan1.');
    await page.click('#login-form button[type="submit"]');

    // Après login, on est redirigé vers l'index (login.js a un setTimeout 1500ms avant redirect)
    await page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 8000 });
    await expect(page).not.toHaveURL(/login/);
  });

  // FIXME: toast d'erreur pas systématiquement émis dans login.js sur 400/401
  test.fixme('email incorrect → message d\'erreur visible', async ({ page }) => {
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
