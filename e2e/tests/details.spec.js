// e2e/tests/details.spec.js
const { test, expect } = require('../helpers/fixtures');

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

  test('la section capacités affiche les 3 colonnes pour un avion complet', async ({ page }) => {
    // A-10 Thunderbolt II (id=1) a armement + tech + missions renseignés
    const section = page.locator('#capabilities-section');
    await expect(section).toBeVisible({ timeout: 8000 });
    await expect(section).not.toHaveClass(/hidden/);

    await expect(page.locator('#col-armament')).toBeVisible();
    await expect(page.locator('#col-tech')).toBeVisible();
    await expect(page.locator('#col-missions')).toBeVisible();

    // Au moins un item rendu dans chaque colonne
    await expect(page.locator('#armament-list .capability-item').first()).toBeVisible({ timeout: 8000 });
    await expect(page.locator('#tech-list .capability-item').first()).toBeVisible();
    await expect(page.locator('#missions-list .capability-item').first()).toBeVisible();
  });

  test('les descriptions sont visibles inline (plus de tooltip)', async ({ page }) => {
    await expect(page.locator('#armament-list')).toBeVisible({ timeout: 8000 });
    const descs = page.locator('#armament-list .capability-desc');
    const count = await descs.count();
    if (count > 0) {
      await expect(descs.first()).toBeVisible();
      const text = (await descs.first().textContent() || '').trim();
      expect(text.length).toBeGreaterThan(0);
    }
  });

  test('le compteur de colonne reflète le nombre d\'items', async ({ page }) => {
    await expect(page.locator('#armament-list')).toBeVisible({ timeout: 8000 });
    const itemsCount = await page.locator('#armament-list .capability-item').count();
    const counterText = (await page.locator('#armament-count').textContent() || '').trim();
    if (itemsCount > 0) {
      expect(counterText).toBe(String(itemsCount));
    }
  });

  test('en anglais, au moins une colonne reste visible et contient du contenu', async ({ page }) => {
    await page.goto('/details?id=1&lang=en');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('#capabilities-section')).toBeVisible({ timeout: 8000 });
    const visibleCols = await page.locator('.capability-column:not(.hidden)').count();
    expect(visibleCols).toBeGreaterThan(0);
  });
});
