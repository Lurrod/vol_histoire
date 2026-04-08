// e2e/tests/navigation.spec.js
// Tests de navigation inter-pages et accessibilité
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

test.describe('Navigation inter-pages', () => {
  test('accueil → hangar → détails → retour hangar', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Cliquer sur le lien Hangar dans la nav
    await page.click('a[href="/hangar"]');
    await page.waitForURL('**/hangar', { timeout: 5000 });

    // Attendre les cartes
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    // Cliquer sur la première carte
    await page.locator('.aircraft-card').first().click();
    await page.waitForURL('**/details**', { timeout: 5000 });

    // Le titre de l'avion est affiché
    const title = page.locator('h1').first();
    await expect(title).toBeVisible({ timeout: 8000 });

    // Retour via le navigateur
    await page.goBack();
    await page.waitForURL('**/hangar', { timeout: 5000 });
  });

  test('le skip link est fonctionnel', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Tab pour focus le skip link
    await page.keyboard.press('Tab');
    const skipLink = page.locator('.skip-link');

    // Le skip link doit pointer vers #main-content
    const href = await skipLink.getAttribute('href');
    expect(href).toBe('#main-content');

    // Le #main-content doit exister
    const mainContent = page.locator('#main-content');
    await expect(mainContent).toBeAttached();
  });

  test('la timeline charge et affiche des avions', async ({ page }) => {
    await page.goto('/timeline');
    await page.waitForLoadState('networkidle');

    // Attendre le chargement des données
    await page.waitForTimeout(2000);

    const bodyText = await page.textContent('body');
    // La timeline doit contenir du contenu (des noms d'avions ou des décennies)
    const hasContent =
      bodyText.includes('196') || bodyText.includes('197') ||
      bodyText.includes('198') || bodyText.includes('199') ||
      bodyText.includes('200') || bodyText.includes('201') ||
      bodyText.includes('202');
    expect(hasContent).toBe(true);
  });

  test('les pages légales sont accessibles', async ({ page }) => {
    // Tester chaque page légale
    for (const path of ['/mentions-legales', '/politique-confidentialite', '/cgu']) {
      const response = await page.goto(path);
      expect(response.status()).toBe(200);

      const title = await page.title();
      expect(title.length).toBeGreaterThan(0);
    }
  });

  test('la page 404 affiche un message pour URL inconnue', async ({ page }) => {
    await page.goto('/page-inexistante-xyz');
    await page.waitForLoadState('networkidle');

    const bodyText = await page.textContent('body');
    const has404 =
      bodyText.includes('404') ||
      bodyText.includes('non trouvée') ||
      bodyText.toLowerCase().includes('not found');
    expect(has404).toBe(true);
  });
});

test.describe('Recherche et filtres', () => {
  test('la recherche dans le hangar filtre les résultats', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const initialCount = await page.locator('.aircraft-card').count();

    // Taper un terme de recherche spécifique
    const searchInput = page.locator('#search-input');
    await searchInput.fill('Rafale');

    // Attendre le debounce (300ms) + rendu
    await page.waitForTimeout(600);

    const filteredCount = await page.locator('.aircraft-card').count();
    expect(filteredCount).toBeLessThanOrEqual(initialCount);

    // Si Rafale existe, au moins une carte doit contenir le mot
    if (filteredCount > 0) {
      const firstCardText = await page.locator('.aircraft-card').first().textContent();
      expect(firstCardText.toLowerCase()).toContain('rafale');
    }
  });

  test('réinitialiser les filtres restaure tous les avions', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const initialCount = await page.locator('.aircraft-card').count();

    // Appliquer un filtre pays
    await page.click('#country-filter-btn');
    await page.locator('.filter-option').first().click();
    await page.waitForTimeout(500);

    const filteredCount = await page.locator('.aircraft-card').count();

    // S'il y a un bouton "Effacer tout", cliquer dessus
    const clearBtn = page.locator('.clear-all-filters');
    if (await clearBtn.isVisible()) {
      await clearBtn.click();
      await page.waitForTimeout(500);

      const restoredCount = await page.locator('.aircraft-card').count();
      expect(restoredCount).toBe(initialCount);
    }
  });
});

test.describe('Settings (authentifié)', () => {
  test('la page settings est accessible et affiche le profil', async ({ page }) => {
    await loginViaApi(page, 'titouan.borde.47@gmail.com', 'Titouan1.');
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    // Section dashboard est active par défaut → switch vers profil
    await page.click('[data-section="profile"]');
    await page.waitForTimeout(300);

    expect(page.url()).toContain('settings');

    // Le formulaire profil doit être visible
    const nameInput = page.locator('#name');
    await expect(nameInput).toBeVisible({ timeout: 8000 });

    // Le nom doit être pré-rempli
    const name = await nameInput.inputValue();
    expect(name.length).toBeGreaterThan(0);
  });
});
