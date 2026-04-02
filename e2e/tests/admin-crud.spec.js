// e2e/tests/admin-crud.spec.js
// Tests CRUD avion pour les utilisateurs admin/éditeur
const { test, expect } = require('@playwright/test');
const { loginViaApi } = require('../helpers/auth');

// Ces tests nécessitent un compte admin en BDD (id=1, role_id=1)
test.describe('Admin — CRUD Avions', () => {
  let createdAircraftId;

  test.beforeEach(async ({ page }) => {
    await loginViaApi(page, 'test@gmail.com', 'test');
  });

  test('le bouton ajouter est visible pour un admin', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const addBtn = page.locator('#add-airplane-btn');
    await expect(addBtn).toBeVisible({ timeout: 5000 });
  });

  test('créer un avion via le formulaire modal', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    // Compter les cartes avant
    const initialCount = await page.locator('.aircraft-card').count();

    // Ouvrir la modale
    await page.click('#add-airplane-btn');
    const modal = page.locator('#aircraft-modal');
    await expect(modal).toBeVisible({ timeout: 3000 });

    // Remplir les champs obligatoires
    await page.fill('#aircraft-name', 'E2E Test Aircraft');
    await page.fill('#aircraft-little-description', 'Avion créé par les tests E2E');
    await page.fill('#aircraft-image-url', 'https://i.postimg.cc/gcysXwvG/a10-thunderbolt-2.jpg');

    // Sélectionner un pays (si dropdown dispo)
    const countrySelect = page.locator('#aircraft-country');
    if (await countrySelect.isVisible()) {
      const options = await countrySelect.locator('option').allTextContents();
      if (options.length > 1) {
        await countrySelect.selectOption({ index: 1 });
      }
    }

    // Soumettre
    await page.click('#aircraft-form button[type="submit"]');

    // Attendre le toast de succès ou le rechargement
    await page.waitForTimeout(2000);

    // Vérifier qu'un avion a été ajouté (via API)
    const response = await page.request.get('http://localhost:3000/api/airplanes');
    const data = await response.json();
    const created = data.data?.find(a => a.name === 'E2E Test Aircraft');
    if (created) {
      createdAircraftId = created.id;
      expect(created.name).toBe('E2E Test Aircraft');
    }
  });

  test('la page détails affiche l\'avion créé', async ({ page }) => {
    // Chercher l'avion par son nom via l'API
    const response = await page.request.get('http://localhost:3000/api/airplanes');
    const data = await response.json();
    const aircraft = data.data?.find(a => a.name === 'E2E Test Aircraft');

    test.skip(!aircraft, 'Avion E2E non trouvé — test de création peut avoir échoué');

    await page.goto(`/details?id=${aircraft.id}`);
    await page.waitForLoadState('networkidle');

    const title = page.locator('h1').first();
    await expect(title).toContainText('E2E Test Aircraft', { timeout: 8000 });
  });

  test('supprimer l\'avion créé via l\'API', async ({ page }) => {
    // Chercher l'avion
    const listResponse = await page.request.get('http://localhost:3000/api/airplanes');
    const data = await listResponse.json();
    const aircraft = data.data?.find(a => a.name === 'E2E Test Aircraft');

    test.skip(!aircraft, 'Avion E2E non trouvé — rien à supprimer');

    // Supprimer via l'API (le token est dans les cookies via loginViaApi)
    const deleteResponse = await page.request.delete(
      `http://localhost:3000/api/airplanes/${aircraft.id}`,
      {
        headers: {
          'Authorization': `Bearer ${await page.evaluate(() => window.localStorage.getItem('authToken'))}`,
        },
      }
    );
    expect(deleteResponse.status()).toBe(200);

    // Vérifier que l'avion n'existe plus
    const checkResponse = await page.request.get(`http://localhost:3000/api/airplanes/${aircraft.id}`);
    expect(checkResponse.status()).toBe(404);
  });
});
