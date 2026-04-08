// e2e/tests/i18n.spec.js
const { test, expect } = require('../helpers/fixtures');

test.describe('Internationalisation fr/en', () => {
  test('la page index se charge en français quand lang=fr est stocké', async ({ page }) => {
    // Force le français dans localStorage avant le chargement, sinon i18n.js
    // utilise navigator.language qui est 'en-US' dans Playwright sur Windows.
    await page.addInitScript(() => window.localStorage.setItem('vol-histoire-lang', 'fr'));
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const navHome = page.locator('header [data-i18n="nav.home"]').first();
    await expect(navHome).toHaveText(/Accueil/i, { timeout: 5000 });
  });

  test('le sélecteur de langue change FR → EN', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Ouvrir le sélecteur de langue et cliquer sur EN.
    // i18n.js fait un reload 100ms après setLang() → on attend la nouvelle nav.
    await page.click('#lang-toggle');
    await Promise.all([
      page.waitForLoadState('load'),
      page.click('.lang-option[data-lang="en"]'),
    ]);
    await page.waitForLoadState('networkidle');

    const navHome = page.locator('header [data-i18n="nav.home"]').first();
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
