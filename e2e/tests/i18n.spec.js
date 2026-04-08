// e2e/tests/i18n.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Internationalisation fr/en', () => {
  test('la page index se charge en français par défaut', async ({ page }) => {
    await page.addInitScript(() => window.localStorage.clear());
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Cible un élément connu avec data-i18n plutôt que body (évite banner cookies)
    const navHome = page.locator('a[href="/"] [data-i18n="nav.home"]').first();
    await expect(navHome).toHaveText(/Accueil/i, { timeout: 5000 });
  });

  test('le sélecteur de langue change vers l\'anglais', async ({ page }) => {
    await page.addInitScript(() => window.localStorage.clear());
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Ouvrir le sélecteur de langue et cliquer sur EN
    await page.click('#lang-toggle');
    await page.click('.lang-option[data-lang="en"]');

    // Attendre que l'élément connu ait changé de contenu
    const navHome = page.locator('a[href="/"] [data-i18n="nav.home"]').first();
    await expect(navHome).toHaveText(/Home/i, { timeout: 5000 });
  });

  test('le changement de langue est persisté dans localStorage', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.click('#lang-toggle');
    await page.click('.lang-option[data-lang="en"]');
    await page.waitForTimeout(500);

    const storedLang = await page.evaluate(() => window.localStorage.getItem('vol-histoire-lang'));
    expect(storedLang).toBe('en');
  });
});
