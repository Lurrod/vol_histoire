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
    // Attendre la réponse filtrée, pas une durée : sous charge, 600 ms de
    // debounce ne suffisaient pas et le compte tombait pendant le chargement.
    await expect.poll(() => page.locator('.aircraft-card').count(), { timeout: 10000 })
      .toBeGreaterThanOrEqual(1);
    const countAfter = await page.locator('.aircraft-card').count();
    expect(countAfter).toBeLessThanOrEqual(countBefore);
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

  test('liste de tri personnalisée : souris puis clavier, le <select> natif suit', async ({ page }) => {
    const trigger = page.locator('.cselect-trigger').first();
    await expect(trigger).toHaveAttribute('role', 'combobox');

    // Souris : ouvrir, choisir « Ordre alphabétique »
    await trigger.click();
    await expect(trigger).toHaveAttribute('aria-expanded', 'true');
    await page.locator('.cselect-option', { hasText: /alphab/i }).click();
    await expect(trigger).toHaveAttribute('aria-expanded', 'false');
    await expect(page.locator('#sort-select')).toHaveValue('alphabetical');
    await expect(trigger.locator('.cselect-value')).toHaveText(/alphab/i);
    await page.waitForTimeout(300);
    const names = await page.locator('.aircraft-card h3').allTextContents();
    expect(names).toEqual([...names].sort((a, b) => a.localeCompare(b)));

    // Clavier : Flèche bas ouvre sur l'option choisie, Début, Entrée choisit
    await trigger.focus();
    await page.keyboard.press('ArrowDown');
    await expect(trigger).toHaveAttribute('aria-expanded', 'true');
    await page.keyboard.press('Home');
    await page.keyboard.press('Enter');
    await expect(page.locator('#sort-select')).toHaveValue('default');
    await expect(trigger).toBeFocused();
  });

  test('les stats du hero glissent vers la nouvelle valeur (compteur odomètre)', async ({ page }) => {
    const stat = page.locator('#total-aircraft');
    await expect(stat.locator('.t-roll-cols')).toHaveAttribute('aria-hidden', 'true');
    const before = await stat.locator('.sr-only').textContent();

    await page.locator('#country-filter-btn').click();
    await page.locator('#country-dropdown .filter-option:not(.filter-option-empty)').first().click();

    await expect(stat.locator('.sr-only')).not.toHaveText(before);
    const value = await stat.locator('.sr-only').textContent();
    // Les colonnes affichent exactement la valeur lisible, chiffre par chiffre.
    await expect.poll(async () =>
      (await stat.locator('.t-roll-col:not(.is-leaving)').evaluateAll(cols => cols.map(c => c.dataset.d).join('')))
    ).toBe(value.replace(/\D/g, ''));
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
