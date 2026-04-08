// e2e/tests/login.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Login / Logout', () => {
  test('login réussi redirige vers l\'accueil', async ({ page }) => {
    await page.goto('/login');

    await page.fill('#login-email', 'titouan.borde.47@gmail.com');
    await page.fill('#login-password', 'Titouan1.');
    await page.click('#login-form button[type="submit"]');

    // login.js fait setTimeout(1500) avant redirect, donc on laisse 10s
    await page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 10000 });
    await expect(page).not.toHaveURL(/login/);
  });

  test('email incorrect → toast d\'erreur visible', async ({ page }) => {
    await page.goto('/login');

    await page.fill('#login-email', 'inexistant@vol-histoire.com');
    await page.fill('#login-password', 'WrongPass123');
    await page.click('#login-form button[type="submit"]');

    // login.js émet un toast sur 401, 429, et status !== ok
    const toast = page.locator('.toast').first();
    await expect(toast).toBeVisible({ timeout: 8000 });
  });

  test('champs vides → le formulaire ne soumet pas', async ({ page }) => {
    await page.goto('/login');
    await page.click('#login-form button[type="submit"]');

    // Toujours sur la page login
    await expect(page).toHaveURL(/login/);
  });
});
