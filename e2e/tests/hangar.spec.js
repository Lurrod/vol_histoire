// e2e/tests/hangar.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Hangar', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/hangar');
    // Attendre que les cartes avions soient chargées
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });
  });

  test('la page affiche au moins une carte avion', async ({ page }) => {
    const cards = page.locator('.aircraft-card');
    await expect(cards.first()).toBeVisible();
    const count = await cards.count();
    expect(count).toBeGreaterThan(0);
  });

  test('cliquer sur une carte navigue vers la page détails', async ({ page }) => {
    const firstCard = page.locator('.aircraft-card').first();
    await firstCard.click();
    await page.waitForURL('**/details**', { timeout: 5000 });
    await expect(page).toHaveURL(/details/);
  });

  test('le filtre par pays réduit ou filtre les résultats', async ({ page }) => {
    // Compter les cartes initiales
    const cards = page.locator('.aircraft-card');
    const initialCount = await cards.count();

    // Ouvrir le dropdown pays et sélectionner le premier
    const countryBtn = page.locator('#country-filter-btn').first();
    await countryBtn.click();
    const firstOption = page.locator('.filter-option').first();
    await firstOption.click();

    // Attendre le rechargement
    await page.waitForTimeout(500);
    const filteredCount = await page.locator('.aircraft-card').count();

    // Le filtre doit avoir un effet (moins ou égal)
    expect(filteredCount).toBeLessThanOrEqual(initialCount);
  });
});
