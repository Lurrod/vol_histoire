// e2e/tests/details.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Page Détails', () => {
  test.beforeEach(async ({ page }) => {
    // L'avion id=1 (A-10 Thunderbolt II) doit exister en BDD locale
    await page.goto('/details?id=1');
    await page.waitForLoadState('networkidle');
  });

  test('le nom de l\'avion est affiché', async ({ page }) => {
    const title = page.locator('#aircraft-name');
    await expect(title).toBeVisible({ timeout: 8000 });
    // Après rendu, le titre n'est plus vide et ne contient plus de skeleton
    await expect(async () => {
      const text = (await title.textContent() || '').trim();
      expect(text.length).toBeGreaterThan(1);
      expect(text).not.toBe('Chargement...');
    }).toPass({ timeout: 8000 });
  });

  test('l\'image hero est chargée', async ({ page }) => {
    const img = page.locator('#hero-image');
    await expect(img).toBeVisible({ timeout: 8000 });
    // Scroll pour garantir que l'image lazy est bien rentrée dans le viewport
    await img.scrollIntoViewIfNeeded();
    // Attendre que naturalWidth > 0 (image décodée)
    await expect(async () => {
      const naturalWidth = await img.evaluate(el => el.naturalWidth);
      expect(naturalWidth).toBeGreaterThan(0);
    }).toPass({ timeout: 10000 });
  });

  test('un ID inexistant redirige vers 404', async ({ page }) => {
    // details.js fait window.location.href = '/404' sur erreur de chargement
    await page.goto('/details?id=99999');
    await page.waitForURL('**/404', { timeout: 8000 });
    await expect(page).toHaveURL(/\/404/);
  });
});
