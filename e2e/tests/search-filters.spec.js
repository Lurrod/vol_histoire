// e2e/tests/search-filters.spec.js
// Parcours critique : recherche et filtres avancés (hangar)

const { test, expect } = require('../helpers/fixtures');

test.describe('Search & Filters — Hangar', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });
  });

  test('la barre de recherche est fonctionnelle', async ({ page }) => {
    const searchInput = page.locator('input[placeholder*="echercher"], input[type="search"], #search-input').first();
    await expect(searchInput).toBeVisible();
  });

  test('rechercher un avion filtre les résultats en temps réel', async ({ page }) => {
    const countBefore = await page.locator('.aircraft-card').count();
    const searchInput = page.locator('input[placeholder*="echercher"], input[type="search"], #search-input').first();

    // Utiliser un terme qui existe probablement (premier avion affiché)
    const firstName = await page.locator('.aircraft-card h3').first().textContent();
    const searchTerm = firstName.split(' ')[0]; // Premier mot du nom

    await searchInput.fill(searchTerm);
    await page.waitForTimeout(600); // debounce

    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeLessThanOrEqual(countBefore);
    expect(countAfter).toBeGreaterThanOrEqual(1);
  });

  test('recherche sans résultat affiche un état vide', async ({ page }) => {
    const searchInput = page.locator('input[placeholder*="echercher"], input[type="search"], #search-input').first();
    await searchInput.fill('xyznonexistent999');
    await page.waitForTimeout(600);

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

    // Cliquer sur la première option non vide
    const firstOption = page.locator('#country-dropdown .filter-option:not(.filter-option-empty)').first();
    await firstOption.click();

    await page.waitForTimeout(300);
    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeLessThanOrEqual(countBefore);
  });

  test('les filtres actifs s\'affichent sous la toolbar', async ({ page }) => {
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();

    const firstOption = page.locator('#country-dropdown .filter-option:not(.filter-option-empty)').first();
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
    await page.locator('#country-dropdown .filter-option:not(.filter-option-empty)').first().click();
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
    const pagination = page.locator('.pagination, [class*="pagination"]');
    const cards = await page.locator('.aircraft-card').count();

    if (cards >= 6) {
      await expect(pagination).toBeVisible();
    }
  });

  test('le raccourci "/" focus la recherche', async ({ page }) => {
    await page.keyboard.press('/');

    const searchInput = page.locator('input[placeholder*="echercher"], input[type="search"], #search-input').first();
    await expect(searchInput).toBeFocused();
  });

  test('combiner recherche + filtre pays réduit les résultats', async ({ page }) => {
    // Filtre pays
    const countryBtn = page.locator('#country-filter-btn, button:has-text("Pays")').first();
    await countryBtn.click();
    await page.locator('#country-dropdown .filter-option:not(.filter-option-empty)').first().click();
    await page.waitForTimeout(300);

    const countWithFilter = await page.locator('.aircraft-card').count();

    // Ajouter recherche
    const searchInput = page.locator('input[placeholder*="echercher"], input[type="search"], #search-input').first();
    await searchInput.fill('zzz');
    await page.waitForTimeout(600);

    const countWithBoth = await page.locator('.aircraft-card').count();
    expect(countWithBoth).toBeLessThanOrEqual(countWithFilter);
  });
});
