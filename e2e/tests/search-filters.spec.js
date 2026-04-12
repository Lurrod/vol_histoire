// e2e/tests/search-filters.spec.js
// Parcours critique : recherche et filtres avancés (hangar)

const { test, expect } = require('../helpers/fixtures');

test.describe('Search & Filters — Hangar', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });
  });

  test('la barre de recherche est fonctionnelle', async ({ page }) => {
    const searchInput = page.locator('#search-input, [type="search"], input[placeholder*="Rechercher"]');
    await expect(searchInput).toBeVisible();
  });

  test('rechercher un avion filtre les résultats en temps réel', async ({ page }) => {
    const countBefore = await page.locator('.aircraft-card').count();

    await page.fill('#search-input, [type="search"], input[placeholder*="Rechercher"]', 'F-22');
    await page.waitForTimeout(500); // debounce

    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeLessThanOrEqual(countBefore);
    expect(countAfter).toBeGreaterThanOrEqual(1);
  });

  test('recherche sans résultat affiche un état vide', async ({ page }) => {
    await page.fill('#search-input, [type="search"], input[placeholder*="Rechercher"]', 'xyznonexistent999');
    await page.waitForTimeout(500);

    const cards = await page.locator('.aircraft-card').count();
    expect(cards).toBe(0);
  });

  test('le filtre pays ouvre un dropdown avec des options', async ({ page }) => {
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();

    const dropdown = page.locator('#country-dropdown');
    await expect(dropdown).toBeVisible({ timeout: 2000 });

    const options = dropdown.locator('.filter-option');
    const count = await options.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('sélectionner un pays filtre les résultats', async ({ page }) => {
    const countBefore = await page.locator('.aircraft-card').count();

    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();

    const firstOption = page.locator('#country-dropdown .filter-option').first();
    await firstOption.click();

    await page.waitForTimeout(300);
    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeLessThanOrEqual(countBefore);
  });

  test('les filtres actifs s\'affichent sous la toolbar', async ({ page }) => {
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();

    const firstOption = page.locator('#country-dropdown .filter-option').first();
    await firstOption.click();
    await page.waitForTimeout(300);

    const activeFilters = page.locator('#active-filters');
    await expect(activeFilters).toBeVisible();

    const filterTag = activeFilters.locator('.active-filter');
    await expect(filterTag).toHaveCount(1);
  });

  test('supprimer un filtre actif restaure les résultats', async ({ page }) => {
    // Appliquer un filtre
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();
    await page.locator('#country-dropdown .filter-option').first().click();
    await page.waitForTimeout(300);

    const countFiltered = await page.locator('.aircraft-card').count();

    // Supprimer le filtre
    await page.locator('.remove-filter-btn').first().click();
    await page.waitForTimeout(300);

    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeGreaterThanOrEqual(countFiltered);
  });

  test('le tri par ordre alphabétique fonctionne', async ({ page }) => {
    const sortSelect = page.locator('#sort-select, select[name="sort"]').first();
    await sortSelect.selectOption('alphabetical');
    await page.waitForTimeout(300);

    const names = await page.locator('.aircraft-card h3').allTextContents();
    const sorted = [...names].sort((a, b) => a.localeCompare(b));
    expect(names).toEqual(sorted);
  });

  test('la pagination est présente si plus de 6 avions', async ({ page }) => {
    // Vérifier si la pagination existe (dépend du nombre d'avions en BDD)
    const pagination = page.locator('.pagination, [class*="pagination"]');
    const cards = await page.locator('.aircraft-card').count();

    if (cards >= 6) {
      await expect(pagination).toBeVisible();
    }
  });

  test('le raccourci "/" focus la recherche', async ({ page }) => {
    await page.keyboard.press('/');

    const searchInput = page.locator('#search-input, [type="search"], input[placeholder*="Rechercher"]');
    await expect(searchInput).toBeFocused();
  });

  test('combiner recherche + filtre pays réduit les résultats', async ({ page }) => {
    // Filtre pays
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();
    await page.locator('#country-dropdown .filter-option').first().click();
    await page.waitForTimeout(300);

    const countWithFilter = await page.locator('.aircraft-card').count();

    // Ajouter recherche
    await page.fill('#search-input, [type="search"], input[placeholder*="Rechercher"]', 'A');
    await page.waitForTimeout(500);

    const countWithBoth = await page.locator('.aircraft-card').count();
    expect(countWithBoth).toBeLessThanOrEqual(countWithFilter);
  });
});
