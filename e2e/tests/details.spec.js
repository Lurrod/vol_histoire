// e2e/tests/details.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Page Détails', () => {
  test.beforeEach(async ({ page }) => {
    // L'avion id=1 (A-10 Thunderbolt II) doit exister en BDD locale
    await page.goto('/details?id=1');
    await page.waitForLoadState('networkidle');
  });

  test('le nom de l\'avion est affiché', async ({ page }) => {
    const title = page.locator('h1').first();
    await expect(title).toBeVisible({ timeout: 8000 });
    const text = await title.textContent();
    expect(text.trim().length).toBeGreaterThan(0);
  });

  test('l\'image de l\'avion est chargée', async ({ page }) => {
    const img = page.locator('img').first();
    await expect(img).toBeVisible({ timeout: 8000 });
    const naturalWidth = await img.evaluate(el => el.naturalWidth);
    expect(naturalWidth).toBeGreaterThan(0);
  });

  // FIXME: la page details affiche un état d'erreur sans texte 404 explicite
  test.fixme('un ID inexistant affiche un message d\'erreur ou 404', async ({ page }) => {
    await page.goto('/details?id=99999');
    await page.waitForLoadState('networkidle');
    const bodyText = await page.textContent('body');
    const hasNotFound =
      bodyText.includes('404') ||
      bodyText.includes('non trouvé') ||
      bodyText.toLowerCase().includes('not found') ||
      bodyText.includes('existe pas');
    expect(hasNotFound).toBe(true);
  });
});
